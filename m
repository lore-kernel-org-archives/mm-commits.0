From: akpm@linux-foundation.org
Subject: +
 mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
 added to -mm tree
Date: Tue, 20 Sep 2016 14:16:43 -0700
Message-ID: <57e1a73b.IlSkedZqcwwiaP0S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50225 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752931AbcITVQo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 17:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, adityam@microsoft.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vma_merge: fix vm_page_prot SMP race condition against rmap_walk
has been added to the -mm tree.  Its filename is
     mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch

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
Subject: mm: vma_merge: fix vm_page_prot SMP race condition against rmap_walk

The rmap_walk can access vm_page_prot (and potentially vm_flags in the
pte/pmd manipulations).  So it's not safe to wait the caller to update the
vm_page_prot/vm_flags after vma_merge returned potentially removing the
"next" vma and extending the "current" vma over the next->vm_start,vm_end
range, but still with the "current" vma vm_page_prot, after releasing the
rmap locks.

The vm_page_prot/vm_flags must be transferred from the "next" vma to the
current vma while vma_merge still holds the rmap locks.

The side effect of this race condition is pte corruption during migrate as
remove_migration_ptes when run on a address of the "next" vma that got
removed, used the vm_page_prot of the current vma.

migrate	     	      	        mprotect
------------			-------------
migrating in "next" vma
				vma_merge() # removes "next" vma and
			        	    # extends "current" vma
					    # current vma is not with
					    # vm_page_prot updated
remove_migration_ptes
read vm_page_prot of current "vma"
establish pte with wrong permissions
				vm_set_page_prot(vma) # too late!
				change_protection in the old vma range
				only, next range is not updated

This caused segmentation faults and potentially memory corruption in heavy
mprotect loads with some light page migration caused by compaction in the
background.

Hugh Dickins pointed out the comment about the Odd case 8 in vma_merge
which confirms the case 8 is only buggy one where the race can trigger, in
all other vma_merge cases the above cannot happen.

This fix removes the oddness factor from case 8 and it converts it
from:

    AAAA
PPPPNNNNXXXX -> PPPPNNNNNNNN

to:

    AAAA
PPPPNNNNXXXX -> PPPPXXXXXXXX

XXXX has the right vma properties for the whole merged vma returned by
vma_adjust, so it solves the problem fully.  It has the added benefits
that the callers could stop updating vma properties when vma_merge
succeeds however the callers are not updated by this patch (there are bits
like VM_SOFTDIRTY that still need special care for the whole range, as the
vma merging ignores them, but as long as they're not processed by rmap
walks and instead they're accessed with the mmap_sem at least for reading,
they are fine not to be updated within vma_adjust before releasing the
rmap_locks).

Link: http://lkml.kernel.org/r/1474309513-20313-1-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Aditya Mandaleeka <adityam@microsoft.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Vorlicek <janvorli@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ++
 mm/mmap.c          |  157 +++++++++++++++++++++++++++++++++++--------
 mm/mprotect.c      |    1 
 3 files changed, 139 insertions(+), 29 deletions(-)

diff -puN include/linux/mm.h~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk include/linux/mm.h
--- a/include/linux/mm.h~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk
+++ a/include/linux/mm.h
@@ -1968,8 +1968,14 @@ void anon_vma_interval_tree_verify(struc
 
 /* mmap.c */
 extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
-extern int vma_adjust(struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert);
+extern int __vma_adjust(struct vm_area_struct *vma, unsigned long start,
+	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
+	struct vm_area_struct *expand);
+static inline int vma_adjust(struct vm_area_struct *vma, unsigned long start,
+	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
+{
+	return __vma_adjust(vma, start, end, pgoff, insert, NULL);
+}
 extern struct vm_area_struct *vma_merge(struct mm_struct *,
 	struct vm_area_struct *prev, unsigned long addr, unsigned long end,
 	unsigned long vm_flags, struct anon_vma *, struct file *, pgoff_t,
diff -puN mm/mmap.c~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk mm/mmap.c
--- a/mm/mmap.c~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk
+++ a/mm/mmap.c
@@ -594,14 +594,24 @@ static void __insert_vm_struct(struct mm
 	mm->map_count++;
 }
 
-static inline void
-__vma_unlink(struct mm_struct *mm, struct vm_area_struct *vma,
-		struct vm_area_struct *prev)
+static __always_inline void __vma_unlink_common(struct mm_struct *mm,
+						struct vm_area_struct *vma,
+						struct vm_area_struct *prev,
+						bool has_prev)
 {
 	struct vm_area_struct *next;
 
 	vma_rb_erase(vma, &mm->mm_rb);
-	prev->vm_next = next = vma->vm_next;
+	next = vma->vm_next;
+	if (has_prev)
+		prev->vm_next = next;
+	else {
+		prev = vma->vm_prev;
+		if (prev)
+			prev->vm_next = next;
+		else
+			mm->mmap = next;
+	}
 	if (next)
 		next->vm_prev = prev;
 
@@ -609,6 +619,19 @@ __vma_unlink(struct mm_struct *mm, struc
 	vmacache_invalidate(mm);
 }
 
+static inline void __vma_unlink_prev(struct mm_struct *mm,
+				     struct vm_area_struct *vma,
+				     struct vm_area_struct *prev)
+{
+	__vma_unlink_common(mm, vma, prev, true);
+}
+
+static inline void __vma_unlink(struct mm_struct *mm,
+				struct vm_area_struct *vma)
+{
+	__vma_unlink_common(mm, vma, NULL, false);
+}
+
 /*
  * We cannot adjust vm_start, vm_end, vm_pgoff fields of a vma that
  * is already present in an i_mmap tree without adjusting the tree.
@@ -616,11 +639,12 @@ __vma_unlink(struct mm_struct *mm, struc
  * are necessary.  The "insert" vma (if any) is to be inserted
  * before we drop the necessary locks.
  */
-int vma_adjust(struct vm_area_struct *vma, unsigned long start,
-	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert)
+int __vma_adjust(struct vm_area_struct *vma, unsigned long start,
+	unsigned long end, pgoff_t pgoff, struct vm_area_struct *insert,
+	struct vm_area_struct *expand)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct vm_area_struct *next = vma->vm_next;
+	struct vm_area_struct *next = vma->vm_next, *orig_vma = vma;
 	struct address_space *mapping = NULL;
 	struct rb_root *root = NULL;
 	struct anon_vma *anon_vma = NULL;
@@ -636,9 +660,38 @@ int vma_adjust(struct vm_area_struct *vm
 			/*
 			 * vma expands, overlapping all the next, and
 			 * perhaps the one after too (mprotect case 6).
+			 * The only two other cases that gets here are
+			 * case 1, case 7 and case 8.
 			 */
-			remove_next = 1 + (end > next->vm_end);
-			end = next->vm_end;
+			if (next == expand) {
+				/*
+				 * The only case where we don't expand "vma"
+				 * and we expand "next" instead is case 8.
+				 */
+				VM_WARN_ON(end != next->vm_end);
+				/*
+				 * remove_next == 3 means we're
+				 * removing "vma" and that to do so we
+				 * swapped "vma" and "next".
+				 */
+				remove_next = 3;
+				VM_WARN_ON(file != next->vm_file);
+				swap(vma, next);
+			} else {
+				VM_WARN_ON(expand != vma);
+				/*
+				 * case 1, 6, 7, remove_next == 2 is case 6,
+				 * remove_next == 1 is case 1 or 7.
+				 */
+				remove_next = 1 + (end > next->vm_end);
+				VM_WARN_ON(remove_next == 2 &&
+					   end != next->vm_next->vm_end);
+				VM_WARN_ON(remove_next == 1 &&
+					   end != next->vm_end);
+				/* trim end to next, for case 6 first pass */
+				end = next->vm_end;
+			}
+
 			exporter = next;
 			importer = vma;
 
@@ -657,6 +710,7 @@ int vma_adjust(struct vm_area_struct *vm
 			adjust_next = (end - next->vm_start) >> PAGE_SHIFT;
 			exporter = next;
 			importer = vma;
+			VM_WARN_ON(expand != importer);
 		} else if (end < vma->vm_end) {
 			/*
 			 * vma shrinks, and !insert tells it's not
@@ -666,6 +720,7 @@ int vma_adjust(struct vm_area_struct *vm
 			adjust_next = -((vma->vm_end - end) >> PAGE_SHIFT);
 			exporter = vma;
 			importer = next;
+			VM_WARN_ON(expand != importer);
 		}
 
 		/*
@@ -683,7 +738,7 @@ int vma_adjust(struct vm_area_struct *vm
 		}
 	}
 again:
-	vma_adjust_trans_huge(vma, start, end, adjust_next);
+	vma_adjust_trans_huge(orig_vma, start, end, adjust_next);
 
 	if (file) {
 		mapping = file->f_mapping;
@@ -709,8 +764,8 @@ again:
 	if (!anon_vma && adjust_next)
 		anon_vma = next->anon_vma;
 	if (anon_vma) {
-		VM_BUG_ON_VMA(adjust_next && next->anon_vma &&
-			  anon_vma != next->anon_vma, next);
+		VM_WARN_ON(adjust_next && next->anon_vma &&
+			   anon_vma != next->anon_vma);
 		anon_vma_lock_write(anon_vma);
 		anon_vma_interval_tree_pre_update_vma(vma);
 		if (adjust_next)
@@ -750,7 +805,11 @@ again:
 		 * vma_merge has merged next into vma, and needs
 		 * us to remove next before dropping the locks.
 		 */
-		__vma_unlink(mm, next, vma);
+		if (remove_next != 3)
+			__vma_unlink_prev(mm, next, vma);
+		else
+			/* vma is not before next if they've been swapped */
+			__vma_unlink(mm, next);
 		if (file)
 			__remove_shared_vm_struct(next, file, mapping);
 	} else if (insert) {
@@ -802,7 +861,27 @@ again:
 		 * we must remove another next too. It would clutter
 		 * up the code too much to do both in one go.
 		 */
-		next = vma->vm_next;
+		if (remove_next != 3) {
+			/*
+			 * If "next" was removed and vma->vm_end was
+			 * expanded (up) over it, in turn
+			 * "next->vm_prev->vm_end" changed and the
+			 * "vma->vm_next" gap must be updated.
+			 */
+			next = vma->vm_next;
+		} else {
+			/*
+			 * For the scope of the comment "next" and
+			 * "vma" considered pre-swap(): if "vma" was
+			 * removed, next->vm_start was expanded (down)
+			 * over it and the "next" gap must be updated.
+			 * Because of the swap() the post-swap() "vma"
+			 * actually points to pre-swap() "next"
+			 * (post-swap() "next" as opposed is now a
+			 * dangling pointer).
+			 */
+			next = vma;
+		}
 		if (remove_next == 2) {
 			remove_next = 1;
 			end = next->vm_end;
@@ -931,13 +1010,24 @@ can_vma_merge_after(struct vm_area_struc
  *    cannot merge    might become    might become    might become
  *                    PPNNNNNNNNNN    PPPPPPPPPPNN    PPPPPPPPPPPP 6 or
  *    mmap, brk or    case 4 below    case 5 below    PPPPPPPPXXXX 7 or
- *    mremap move:                                    PPPPNNNNNNNN 8
+ *    mremap move:                                    PPPPXXXXXXXX 8
  *        AAAA
  *    PPPP    NNNN    PPPPPPPPPPPP    PPPPPPPPNNNN    PPPPNNNNNNNN
  *    might become    case 1 below    case 2 below    case 3 below
  *
- * Odd one out? Case 8, because it extends NNNN but needs flags of XXXX:
- * mprotect_fixup updates vm_flags & vm_page_prot on successful return.
+ * It is important for case 8 that the the vma NNNN overlapping the
+ * region AAAA is never going to extended over XXXX. Instead XXXX must
+ * be extended in region AAAA and NNNN must be removed. This way in
+ * all cases where vma_merge succeeds, the moment vma_adjust drops the
+ * rmap_locks, the properties of the merged vma will be already
+ * correct for the whole merged range. Some of those properties like
+ * vm_page_prot/vm_flags may be accessed by rmap_walks and they must
+ * be correct for the whole merged range immediately after the
+ * rmap_locks are released. Otherwise if XXXX would be removed and
+ * NNNN would be extended over the XXXX range, remove_migration_ptes
+ * or other rmap walkers (if working on addresses beyond the "end"
+ * parameter) may establish ptes with the wrong permissions of NNNN
+ * instead of the right permissions of XXXX.
  */
 struct vm_area_struct *vma_merge(struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
@@ -962,9 +1052,14 @@ struct vm_area_struct *vma_merge(struct
 	else
 		next = mm->mmap;
 	area = next;
-	if (next && next->vm_end == end)		/* cases 6, 7, 8 */
+	if (area && area->vm_end == end)		/* cases 6, 7, 8 */
 		next = next->vm_next;
 
+	/* verify some invariant that must be enforced by the caller */
+	VM_WARN_ON(prev && addr <= prev->vm_start);
+	VM_WARN_ON(area && end > area->vm_end);
+	VM_WARN_ON(addr >= end);
+
 	/*
 	 * Can it merge with the predecessor?
 	 */
@@ -985,11 +1080,12 @@ struct vm_area_struct *vma_merge(struct
 				is_mergeable_anon_vma(prev->anon_vma,
 						      next->anon_vma, NULL)) {
 							/* cases 1, 6 */
-			err = vma_adjust(prev, prev->vm_start,
-				next->vm_end, prev->vm_pgoff, NULL);
+			err = __vma_adjust(prev, prev->vm_start,
+					 next->vm_end, prev->vm_pgoff, NULL,
+					 prev);
 		} else					/* cases 2, 5, 7 */
-			err = vma_adjust(prev, prev->vm_start,
-				end, prev->vm_pgoff, NULL);
+			err = __vma_adjust(prev, prev->vm_start,
+					 end, prev->vm_pgoff, NULL, prev);
 		if (err)
 			return NULL;
 		khugepaged_enter_vma_merge(prev, vm_flags);
@@ -1005,11 +1101,18 @@ struct vm_area_struct *vma_merge(struct
 					     anon_vma, file, pgoff+pglen,
 					     vm_userfaultfd_ctx)) {
 		if (prev && addr < prev->vm_end)	/* case 4 */
-			err = vma_adjust(prev, prev->vm_start,
-				addr, prev->vm_pgoff, NULL);
-		else					/* cases 3, 8 */
-			err = vma_adjust(area, addr, next->vm_end,
-				next->vm_pgoff - pglen, NULL);
+			err = __vma_adjust(prev, prev->vm_start,
+					 addr, prev->vm_pgoff, NULL, next);
+		else {					/* cases 3, 8 */
+			err = __vma_adjust(area, addr, next->vm_end,
+					 next->vm_pgoff - pglen, NULL, next);
+			/*
+			 * In case 3 area is already equal to next and
+			 * this is a noop, but in case 8 "area" has
+			 * been removed and next was expanded over it.
+			 */
+			area = next;
+		}
 		if (err)
 			return NULL;
 		khugepaged_enter_vma_merge(area, vm_flags);
diff -puN mm/mprotect.c~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk mm/mprotect.c
--- a/mm/mprotect.c~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk
+++ a/mm/mprotect.c
@@ -304,6 +304,7 @@ mprotect_fixup(struct vm_area_struct *vm
 			   vma->vm_userfaultfd_ctx);
 	if (*pprev) {
 		vma = *pprev;
+		VM_WARN_ON((vma->vm_flags ^ newflags) & ~VM_SOFTDIRTY);
 		goto success;
 	}
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch

