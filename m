From: akpm@linux-foundation.org
Subject: +
 mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place.patch added to -mm tree
Date: Tue, 25 Jun 2013 15:37:06 -0700
Message-ID: <51ca1b92.jBZMv1hdyuEBz33T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43749 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3FYWhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com, joe@perches.com

Subject: + mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place.patch added to -mm tree
To: joe@perches.com,kosaki.motohiro@jp.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:37:06 -0700


The patch titled
     Subject: mm: remove unused VM_<READfoo> macros and expand other in-place
has been added to the -mm tree.  Its filename is
     mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm: remove unused VM_<READfoo> macros and expand other in-place

These VM_<READfoo> macros aren't used very often and three of them aren't
used at all.

Expand the ones that are used in-place, and remove all the now unused
#define VM_<foo> macros.

VM_READHINTMASK, VM_NormalReadHint and VM_ClearReadHint were added just
before 2.4 and appears have never been used.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ------
 mm/filemap.c       |    6 +++---
 mm/memory.c        |    2 +-
 mm/rmap.c          |    2 +-
 4 files changed, 5 insertions(+), 11 deletions(-)

diff -puN include/linux/mm.h~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place include/linux/mm.h
--- a/include/linux/mm.h~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place
+++ a/include/linux/mm.h
@@ -151,12 +151,6 @@ extern unsigned int kobjsize(const void
 #define VM_STACK_FLAGS	(VM_GROWSDOWN | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
 #endif
 
-#define VM_READHINTMASK			(VM_SEQ_READ | VM_RAND_READ)
-#define VM_ClearReadHint(v)		(v)->vm_flags &= ~VM_READHINTMASK
-#define VM_NormalReadHint(v)		(!((v)->vm_flags & VM_READHINTMASK))
-#define VM_SequentialReadHint(v)	((v)->vm_flags & VM_SEQ_READ)
-#define VM_RandomReadHint(v)		((v)->vm_flags & VM_RAND_READ)
-
 /*
  * Special vmas that are non-mergable, non-mlock()able.
  * Note: mm/huge_memory.c VM_NO_THP depends on this definition.
diff -puN mm/filemap.c~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place mm/filemap.c
--- a/mm/filemap.c~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place
+++ a/mm/filemap.c
@@ -1539,12 +1539,12 @@ static void do_sync_mmap_readahead(struc
 	struct address_space *mapping = file->f_mapping;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (VM_RandomReadHint(vma))
+	if (vma->vm_flags & VM_RAND_READ)
 		return;
 	if (!ra->ra_pages)
 		return;
 
-	if (VM_SequentialReadHint(vma)) {
+	if (vma->vm_flags & VM_SEQ_READ) {
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
 		return;
@@ -1584,7 +1584,7 @@ static void do_async_mmap_readahead(stru
 	struct address_space *mapping = file->f_mapping;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (VM_RandomReadHint(vma))
+	if (vma->vm_flags & VM_RAND_READ)
 		return;
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
diff -puN mm/memory.c~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place mm/memory.c
--- a/mm/memory.c~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place
+++ a/mm/memory.c
@@ -1150,7 +1150,7 @@ again:
 				if (pte_dirty(ptent))
 					set_page_dirty(page);
 				if (pte_young(ptent) &&
-				    likely(!VM_SequentialReadHint(vma)))
+				    likely(!(vma->vm_flags & VM_SEQ_READ)))
 					mark_page_accessed(page);
 				rss[MM_FILEPAGES]--;
 			}
diff -puN mm/rmap.c~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place mm/rmap.c
--- a/mm/rmap.c~mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place
+++ a/mm/rmap.c
@@ -720,7 +720,7 @@ int page_referenced_one(struct page *pag
 			 * mapping is already gone, the unmap path will have
 			 * set PG_referenced or activated the page.
 			 */
-			if (likely(!VM_SequentialReadHint(vma)))
+			if (likely(!(vma->vm_flags & VM_SEQ_READ)))
 				referenced++;
 		}
 		pte_unmap_unlock(pte, ptl);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-remove-unused-vm_readfoo-macros-and-expand-other-in-place.patch
checkpatch-change-camelcase-test-and-make-it-strict.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
checkpatch-add-strict-preference-for-p-=-kmallocsizeofp.patch
checkpatch-remove-quote-from-camelcase-test.patch
checkpatch-improve-network-block-comment-test-and-message.patch
checkpatch-warn-when-networking-block-comment-lines-dont-start-with.patch
checkpatch-warn-on-comparisons-to-jiffies.patch
checkpatch-warn-on-comparisons-to-get_jiffies_64.patch
checkpatch-reduce-false-positive-rate-of-complex-macros.patch
checkpatch-add-a-placeholder-to-check-blank-lines-before-declarations.patch
checkpatch-dont-warn-on-blank-lines-before-after-braces-as-often.patch
checkpatch-add-a-strict-test-for-comparison-to-true-false.patch
checkpatch-improve-no-space-after-cast-test.patch
checkpatch-create-an-experimental-fix-option-to-correct-patches.patch
checkpatch-move-test-for-space-before-semicolon-after-operator-spacing.patch
checkpatch-ignore-si-unit-camelcase-variants-like-_uv.patch
checkpatch-ignore-existing-camelcase-uses-from-include.patch

