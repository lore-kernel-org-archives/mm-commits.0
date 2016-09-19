From: akpm@linux-foundation.org
Subject: +
 mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
 added to -mm tree
Date: Mon, 19 Sep 2016 16:00:02 -0700
Message-ID: <57e06df2.64UWX14eQB/lADEX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54183 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751032AbcISXAD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2016 19:00:03 -0400
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

Link: http://lkml.kernel.org/r/1474128315-22726-2-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Aditya Mandaleeka <adityam@microsoft.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Vorlicek <janvorli@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   40 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk mm/mmap.c
--- a/mm/mmap.c~mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk
+++ a/mm/mmap.c
@@ -724,6 +724,25 @@ again:
 			vma_interval_tree_remove(next, root);
 	}
 
+	if (remove_next == 1) {
+		/*
+		 * vm_page_prot and vm_flags can be read by the
+		 * rmap_walk, for example in remove_migration_ptes(),
+		 * so before releasing the rmap locks the permissions
+		 * of the expanded vmas must be already the correct
+		 * one for the whole merged range.
+		 *
+		 * mprotect case 8 (which sets remove_next == 1) needs
+		 * special handling to provide the above guarantee, as
+		 * it is the only case where the "vma" that is being
+		 * expanded is the one with the wrong permissions for
+		 * the whole merged region. So copy the right
+		 * permissions from the next one that is getting
+		 * removed before releasing the rmap locks.
+		 */
+		vma->vm_page_prot = next->vm_page_prot;
+		vma->vm_flags = next->vm_flags;
+	}
 	if (start != vma->vm_start) {
 		vma->vm_start = start;
 		start_changed = true;
@@ -804,7 +823,16 @@ again:
 		 */
 		next = vma->vm_next;
 		if (remove_next == 2) {
-			remove_next = 1;
+			/*
+			 * No need to transfer vm_page_prot/vm_flags
+			 * in the remove_next == 2 case,
+			 * vma_page_prot/vm_flags of the "vma" was
+			 * already the correct one for the whole range
+			 * in mprotect case 6. So set remove_next to 3
+			 * to skip that. It wouldn't hurt to execute
+			 * it but it's superfluous.
+			 */
+			remove_next = 3;
 			end = next->vm_end;
 			goto again;
 		}
@@ -936,8 +964,14 @@ can_vma_merge_after(struct vm_area_struc
  *    PPPP    NNNN    PPPPPPPPPPPP    PPPPPPPPNNNN    PPPPNNNNNNNN
  *    might become    case 1 below    case 2 below    case 3 below
  *
- * Odd one out? Case 8, because it extends NNNN but needs flags of XXXX:
- * mprotect_fixup updates vm_flags & vm_page_prot on successful return.
+ * Odd one out? Case 8, because it extends NNNN but needs the
+ * properties of XXXX. In turn the vma_merge caller must update the
+ * properties on successful return of vma_merge. An update in the
+ * caller of those properties is only ok if those properties are never
+ * accessed through rmap_walks (i.e. without the mmap_sem). The
+ * vm_page_prot/vm_flags (which may be accessed by rmap_walks) must be
+ * transferred from XXXX to NNNN in case 8 before releasing the rmap
+ * locks.
  */
 struct vm_area_struct *vma_merge(struct mm_struct *mm,
 			struct vm_area_struct *prev, unsigned long addr,
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch

