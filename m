From: akpm@linux-foundation.org
Subject: +
 mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb.patch
 added to -mm tree
Date: Tue, 27 Sep 2016 13:00:41 -0700
Message-ID: <57eacfe9.Dw/59a6ASI0XE/XM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934098AbcI0UAm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 16:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vma_merge: correct false positive from __vma_unlink->validate_mm_rb
has been added to the -mm tree.  Its filename is
     mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: vma_merge: correct false positive from __vma_unlink->validate_mm_rb

The old code was always doing:

   vma->vm_end = next->vm_end
   vma_rb_erase(next) // in __vma_unlink
   vma->vm_next = next->vm_next // in __vma_unlink
   next = vma->vm_next
   vma_gap_update(next)

The new code still does the above for remove_next == 1 and 2, but for
remove_next == 3 it has been changed and it does:

   next->vm_start = vma->vm_start
   vma_rb_erase(vma) // in __vma_unlink
   vma_gap_update(next)

In the latter case, while unlinking "vma", validate_mm_rb() is told to
ignore "vma" that is being removed, but next->vm_start was reduced
instead. So for the new case, to avoid the false positive from
validate_mm_rb, it should be "next" that is ignored when "vma" is
being unlinked.

"vma" and "next" in the above comment, considered pre-swap().

Link: http://lkml.kernel.org/r/1474492522-2261-4-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Vorlicek <janvorli@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   59 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 18 deletions(-)

diff -puN mm/mmap.c~mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb mm/mmap.c
--- a/mm/mmap.c~mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb
+++ a/mm/mmap.c
@@ -397,15 +397,9 @@ static inline void vma_rb_insert(struct
 	rb_insert_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
 }
 
-static void vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
+static void __vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
 {
 	/*
-	 * All rb_subtree_gap values must be consistent prior to erase,
-	 * with the possible exception of the vma being erased.
-	 */
-	validate_mm_rb(root, vma);
-
-	/*
 	 * Note rb_erase_augmented is a fairly large inline function,
 	 * so make sure we instantiate it only once with our desired
 	 * augmented rbtree callbacks.
@@ -413,6 +407,32 @@ static void vma_rb_erase(struct vm_area_
 	rb_erase_augmented(&vma->vm_rb, root, &vma_gap_callbacks);
 }
 
+static __always_inline void vma_rb_erase_ignore(struct vm_area_struct *vma,
+						struct rb_root *root,
+						struct vm_area_struct *ignore)
+{
+	/*
+	 * All rb_subtree_gap values must be consistent prior to erase,
+	 * with the possible exception of the "next" vma being erased if
+	 * next->vm_start was reduced.
+	 */
+	validate_mm_rb(root, ignore);
+
+	__vma_rb_erase(vma, root);
+}
+
+static __always_inline void vma_rb_erase(struct vm_area_struct *vma,
+					 struct rb_root *root)
+{
+	/*
+	 * All rb_subtree_gap values must be consistent prior to erase,
+	 * with the possible exception of the vma being erased.
+	 */
+	validate_mm_rb(root, vma);
+
+	__vma_rb_erase(vma, root);
+}
+
 /*
  * vma has some anon_vma assigned, and is already inserted on that
  * anon_vma's interval trees.
@@ -599,11 +619,12 @@ static void __insert_vm_struct(struct mm
 static __always_inline void __vma_unlink_common(struct mm_struct *mm,
 						struct vm_area_struct *vma,
 						struct vm_area_struct *prev,
-						bool has_prev)
+						bool has_prev,
+						struct vm_area_struct *ignore)
 {
 	struct vm_area_struct *next;
 
-	vma_rb_erase(vma, &mm->mm_rb);
+	vma_rb_erase_ignore(vma, &mm->mm_rb, ignore);
 	next = vma->vm_next;
 	if (has_prev)
 		prev->vm_next = next;
@@ -625,13 +646,7 @@ static inline void __vma_unlink_prev(str
 				     struct vm_area_struct *vma,
 				     struct vm_area_struct *prev)
 {
-	__vma_unlink_common(mm, vma, prev, true);
-}
-
-static inline void __vma_unlink(struct mm_struct *mm,
-				struct vm_area_struct *vma)
-{
-	__vma_unlink_common(mm, vma, NULL, false);
+	__vma_unlink_common(mm, vma, prev, true, vma);
 }
 
 /*
@@ -810,8 +825,16 @@ again:
 		if (remove_next != 3)
 			__vma_unlink_prev(mm, next, vma);
 		else
-			/* vma is not before next if they've been swapped */
-			__vma_unlink(mm, next);
+			/*
+			 * vma is not before next if they've been
+			 * swapped.
+			 *
+			 * pre-swap() next->vm_start was reduced so
+			 * tell validate_mm_rb to ignore pre-swap()
+			 * "next" (which is stored in post-swap()
+			 * "vma").
+			 */
+			__vma_unlink_common(mm, next, NULL, false, vma);
 		if (file)
 			__remove_shared_vm_struct(next, file, mapping);
 	} else if (insert) {
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-vm_page_prot-update-with-write_once-read_once.patch
mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case.patch
mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch
mm-vma_adjust-minor-comment-correction.patch
mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb.patch

