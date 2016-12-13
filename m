From: akpm@linux-foundation.org
Subject: [patch 081/123] mm, rmap: handle anon_vma_prepare() common case
 inline
Date: Mon, 12 Dec 2016 16:44:38 -0800
Message-ID: <584f4476.928TRqivUF2w74I6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932298AbcLMAok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, koct9i@gmail.com, riel@redhat.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, rmap: handle anon_vma_prepare() common case inline

anon_vma_prepare() is mostly a large "if (unlikely(...))" block, as the
expected common case is that an anon_vma already exists.  We could turn
the condition around and return 0, but it also makes sense to do it inline
and avoid a call for the common case.

Bloat-o-meter naturally shows that inlining the check has some code size
costs:

add/remove: 1/1 grow/shrink: 4/0 up/down: 475/-373 (102)
function                                     old     new   delta
__anon_vma_prepare                             -     359    +359
handle_mm_fault                             2744    2796     +52
hugetlb_cow                                 1146    1170     +24
hugetlb_fault                               2123    2145     +22
wp_page_copy                                1469    1487     +18
anon_vma_prepare                             373       -    -373

Checking the asm however confirms that the hot paths now avoid a call,
which is moved away.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/20161116074005.22768-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   10 +++++
 mm/rmap.c            |   73 ++++++++++++++++++++---------------------
 2 files changed, 45 insertions(+), 38 deletions(-)

diff -puN include/linux/rmap.h~mm-rmap-handle-anon_vma_prepare-common-case-inline include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmap-handle-anon_vma_prepare-common-case-inline
+++ a/include/linux/rmap.h
@@ -137,11 +137,19 @@ static inline void anon_vma_unlock_read(
  * anon_vma helper functions.
  */
 void anon_vma_init(void);	/* create anon_vma_cachep */
-int  anon_vma_prepare(struct vm_area_struct *);
+int  __anon_vma_prepare(struct vm_area_struct *);
 void unlink_anon_vmas(struct vm_area_struct *);
 int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
 int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
 
+static inline int anon_vma_prepare(struct vm_area_struct *vma)
+{
+	if (likely(vma->anon_vma))
+		return 0;
+
+	return __anon_vma_prepare(vma);
+}
+
 static inline void anon_vma_merge(struct vm_area_struct *vma,
 				  struct vm_area_struct *next)
 {
diff -puN mm/rmap.c~mm-rmap-handle-anon_vma_prepare-common-case-inline mm/rmap.c
--- a/mm/rmap.c~mm-rmap-handle-anon_vma_prepare-common-case-inline
+++ a/mm/rmap.c
@@ -141,14 +141,15 @@ static void anon_vma_chain_link(struct v
 }
 
 /**
- * anon_vma_prepare - attach an anon_vma to a memory region
+ * __anon_vma_prepare - attach an anon_vma to a memory region
  * @vma: the memory region in question
  *
  * This makes sure the memory mapping described by 'vma' has
  * an 'anon_vma' attached to it, so that we can associate the
  * anonymous pages mapped into it with that anon_vma.
  *
- * The common case will be that we already have one, but if
+ * The common case will be that we already have one, which
+ * is handled inline by anon_vma_prepare(). But if
  * not we either need to find an adjacent mapping that we
  * can re-use the anon_vma from (very common when the only
  * reason for splitting a vma has been mprotect()), or we
@@ -167,48 +168,46 @@ static void anon_vma_chain_link(struct v
  *
  * This must be called with the mmap_sem held for reading.
  */
-int anon_vma_prepare(struct vm_area_struct *vma)
+int __anon_vma_prepare(struct vm_area_struct *vma)
 {
-	struct anon_vma *anon_vma = vma->anon_vma;
+	struct mm_struct *mm = vma->vm_mm;
+	struct anon_vma *anon_vma, *allocated;
 	struct anon_vma_chain *avc;
 
 	might_sleep();
-	if (unlikely(!anon_vma)) {
-		struct mm_struct *mm = vma->vm_mm;
-		struct anon_vma *allocated;
-
-		avc = anon_vma_chain_alloc(GFP_KERNEL);
-		if (!avc)
-			goto out_enomem;
 
-		anon_vma = find_mergeable_anon_vma(vma);
+	avc = anon_vma_chain_alloc(GFP_KERNEL);
+	if (!avc)
+		goto out_enomem;
+
+	anon_vma = find_mergeable_anon_vma(vma);
+	allocated = NULL;
+	if (!anon_vma) {
+		anon_vma = anon_vma_alloc();
+		if (unlikely(!anon_vma))
+			goto out_enomem_free_avc;
+		allocated = anon_vma;
+	}
+
+	anon_vma_lock_write(anon_vma);
+	/* page_table_lock to protect against threads */
+	spin_lock(&mm->page_table_lock);
+	if (likely(!vma->anon_vma)) {
+		vma->anon_vma = anon_vma;
+		anon_vma_chain_link(vma, avc, anon_vma);
+		/* vma reference or self-parent link for new root */
+		anon_vma->degree++;
 		allocated = NULL;
-		if (!anon_vma) {
-			anon_vma = anon_vma_alloc();
-			if (unlikely(!anon_vma))
-				goto out_enomem_free_avc;
-			allocated = anon_vma;
-		}
-
-		anon_vma_lock_write(anon_vma);
-		/* page_table_lock to protect against threads */
-		spin_lock(&mm->page_table_lock);
-		if (likely(!vma->anon_vma)) {
-			vma->anon_vma = anon_vma;
-			anon_vma_chain_link(vma, avc, anon_vma);
-			/* vma reference or self-parent link for new root */
-			anon_vma->degree++;
-			allocated = NULL;
-			avc = NULL;
-		}
-		spin_unlock(&mm->page_table_lock);
-		anon_vma_unlock_write(anon_vma);
