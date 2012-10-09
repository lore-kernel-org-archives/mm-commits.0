From: akpm@linux-foundation.org
Subject: [merged] mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:32 -0700
Message-ID: <20121009180633.40C08200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:49646 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISGf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:06:35 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so363085eek.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, bhalevy@tonian.com, dhillf@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap.c: replace find_vma_prepare() with clearer find_vma_links()
has been removed from the -mm tree.  Its filename was
     mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/mmap.c: replace find_vma_prepare() with clearer find_vma_links()

People get confused by find_vma_prepare(), because it doesn't care about
what it returns in its output args, when its callers won't be interested.

Clarify by passing in end-of-range address too, and returning failure if
any existing vma overlaps the new range: instead of returning an ambiguous
vma which most callers then must check.  find_vma_links() is a clearer
name.

This does revert 2.6.27's dfe195fb79e88 ("mm: fix uninitialized variables
for find_vma_prepare callers"), but it looks like gcc 4.3.0 was one of
those releases too eager to shout about uninitialized variables: only
copy_vma() warns with 4.5.1 and 4.7.1, which a BUG on error silences.

[hughd@google.com: fix warning, remove BUG()]
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Benny Halevy <bhalevy@tonian.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links
+++ a/mm/mmap.c
@@ -353,17 +353,14 @@ void validate_mm(struct mm_struct *mm)
 #define validate_mm(mm) do { } while (0)
 #endif
 
-static struct vm_area_struct *
-find_vma_prepare(struct mm_struct *mm, unsigned long addr,
-		struct vm_area_struct **pprev, struct rb_node ***rb_link,
-		struct rb_node ** rb_parent)
+static int find_vma_links(struct mm_struct *mm, unsigned long addr,
+		unsigned long end, struct vm_area_struct **pprev,
+		struct rb_node ***rb_link, struct rb_node **rb_parent)
 {
-	struct vm_area_struct * vma;
-	struct rb_node ** __rb_link, * __rb_parent, * rb_prev;
+	struct rb_node **__rb_link, *__rb_parent, *rb_prev;
 
 	__rb_link = &mm->mm_rb.rb_node;
 	rb_prev = __rb_parent = NULL;
-	vma = NULL;
 
 	while (*__rb_link) {
 		struct vm_area_struct *vma_tmp;
@@ -372,9 +369,9 @@ find_vma_prepare(struct mm_struct *mm, u
 		vma_tmp = rb_entry(__rb_parent, struct vm_area_struct, vm_rb);
 
 		if (vma_tmp->vm_end > addr) {
-			vma = vma_tmp;
-			if (vma_tmp->vm_start <= addr)
-				break;
+			/* Fail if an existing vma overlaps the area */
+			if (vma_tmp->vm_start < end)
+				return -ENOMEM;
 			__rb_link = &__rb_parent->rb_left;
 		} else {
 			rb_prev = __rb_parent;
@@ -387,7 +384,7 @@ find_vma_prepare(struct mm_struct *mm, u
 		*pprev = rb_entry(rb_prev, struct vm_area_struct, vm_rb);
 	*rb_link = __rb_link;
 	*rb_parent = __rb_parent;
-	return vma;
+	return 0;
 }
 
 void __vma_link_rb(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -456,11 +453,12 @@ static void vma_link(struct mm_struct *m
  */
 static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct *__vma, *prev;
+	struct vm_area_struct *prev;
 	struct rb_node **rb_link, *rb_parent;
 
-	__vma = find_vma_prepare(mm, vma->vm_start,&prev, &rb_link, &rb_parent);
-	BUG_ON(__vma && __vma->vm_start < vma->vm_end);
+	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
+			   &prev, &rb_link, &rb_parent))
+		BUG();
 	__vma_link(mm, vma, prev, rb_link, rb_parent);
 	mm->map_count++;
 }
@@ -1221,8 +1219,7 @@ unsigned long mmap_region(struct file *f
 	/* Clear old maps */
 	error = -ENOMEM;
 munmap_back:
-	vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
-	if (vma && vma->vm_start < addr + len) {
+	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
 		goto munmap_back;
@@ -2183,8 +2180,7 @@ static unsigned long do_brk(unsigned lon
 	 * Clear old maps.  this also does some error checking for us
 	 */
  munmap_back:
-	vma = find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
-	if (vma && vma->vm_start < addr + len) {
+	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent)) {
 		if (do_munmap(mm, addr, len))
 			return -ENOMEM;
 		goto munmap_back;
@@ -2298,10 +2294,10 @@ void exit_mmap(struct mm_struct *mm)
  * and into the inode's i_mmap tree.  If vm_file is non-NULL
  * then i_mmap_mutex is taken here.
  */
-int insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
+int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct * __vma, * prev;
-	struct rb_node ** rb_link, * rb_parent;
+	struct vm_area_struct *prev;
+	struct rb_node **rb_link, *rb_parent;
 
 	/*
 	 * The vm_pgoff of a purely anonymous vma should be irrelevant
@@ -2319,8 +2315,8 @@ int insert_vm_struct(struct mm_struct * 
 		BUG_ON(vma->anon_vma);
 		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
 	}
-	__vma = find_vma_prepare(mm,vma->vm_start,&prev,&rb_link,&rb_parent);
-	if (__vma && __vma->vm_start < vma->vm_end)
+	if (find_vma_links(mm, vma->vm_start, vma->vm_end,
+			   &prev, &rb_link, &rb_parent))
 		return -ENOMEM;
 	if ((vma->vm_flags & VM_ACCOUNT) &&
 	     security_vm_enough_memory_mm(mm, vma_pages(vma)))
@@ -2354,7 +2350,8 @@ struct vm_area_struct *copy_vma(struct v
 		faulted_in_anon_vma = false;
 	}
 
-	find_vma_prepare(mm, addr, &prev, &rb_link, &rb_parent);
+	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent))
+		return NULL;	/* should never get here */
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
 			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma));
 	if (new_vma) {
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

