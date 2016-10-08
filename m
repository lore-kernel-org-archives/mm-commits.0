From: akpm@linux-foundation.org
Subject: [patch 095/127] mm: vma_merge: correct false positive from
 __vma_unlink->validate_mm_rb
Date: Fri, 07 Oct 2016 17:01:37 -0700
Message-ID: <57f83761.9EFMWmLlR4CM32II%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39469 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932764AbcJHABi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, shaun.tancheff@seagate.com

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
Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>
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
@@ -402,15 +402,9 @@ static inline void vma_rb_insert(struct
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
@@ -418,6 +412,32 @@ static void vma_rb_erase(struct vm_area_
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
@@ -604,11 +624,12 @@ static void __insert_vm_struct(struct mm
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
@@ -630,13 +651,7 @@ static inline void __vma_unlink_prev(str
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
@@ -815,8 +830,16 @@ again:
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
