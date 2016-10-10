From: akpm@linux-foundation.org
Subject: [merged]
 mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case.patch removed from -mm tree
Date: Mon, 10 Oct 2016 15:46:10 -0700
Message-ID: <57fc1a32.sotxAr3eO9Ghntnh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37230 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbcJJWqL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vma_adjust: remove superfluous confusing update in remove_next == 1 case
has been removed from the -mm tree.  Its filename was
     mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: vma_adjust: remove superfluous confusing update in remove_next == 1 case

mm->highest_vm_end doesn't need any update.

After finally removing the oddness from vma_merge case 8 that was causing:

1) constant risk of trouble whenever anybody would check vma fields
   from rmap_walks, like it happened when page migration was
   introduced and it read the vma->vm_page_prot from a rmap_walk

2) the callers of vma_merge to re-initialize any value different from
   the current vma, instead of vma_merge() more reliably returning a
   vma that already matches all fields passed as parameter

... it is also worth to take the opportunity of cleaning up
superfluous code in vma_adjust(), that if not removed adds up to the
hard readability of the function.

Link: http://lkml.kernel.org/r/1474492522-2261-5-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Vorlicek <janvorli@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case mm/mmap.c
--- a/mm/mmap.c~mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case
+++ a/mm/mmap.c
@@ -817,8 +817,28 @@ again:
 		}
 		else if (next)
 			vma_gap_update(next);
-		else
-			mm->highest_vm_end = end;
+		else {
+			/*
+			 * If remove_next == 2 we obviously can't
+			 * reach this path.
+			 *
+			 * If remove_next == 3 we can't reach this
+			 * path because pre-swap() next is always not
+			 * NULL. pre-swap() "next" is not being
+			 * removed and its next->vm_end is not altered
+			 * (and furthermore "end" already matches
+			 * next->vm_end in remove_next == 3).
+			 *
+			 * We reach this only in the remove_next == 1
+			 * case if the "next" vma that was removed was
+			 * the highest vma of the mm. However in such
+			 * case next->vm_end == "end" and the extended
+			 * "vma" has vma->vm_end == next->vm_end so
+			 * mm->highest_vm_end doesn't need any update
+			 * in remove_next == 1 case.
+			 */
+			VM_WARN_ON(mm->highest_vm_end != end);
+		}
 	}
 	if (insert && file)
 		uprobe_mmap(insert);
_

Patches currently in -mm which might be from aarcange@redhat.com are


