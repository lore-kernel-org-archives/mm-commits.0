From: akpm@linux-foundation.org
Subject: +
 mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case.patch added to -mm tree
Date: Tue, 27 Sep 2016 13:00:36 -0700
Message-ID: <57eacfe4.XMYqXDvMUox58MJz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45273 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934274AbcI0UAn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 16:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vma_adjust: remove superfluous confusing update in remove_next == 1 case
has been added to the -mm tree.  Its filename is
     mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-%3D%3D-1-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-%3D%3D-1-case.patch

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
@@ -812,8 +812,28 @@ again:
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

mm-vm_page_prot-update-with-write_once-read_once.patch
mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case.patch
mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch
mm-vma_adjust-minor-comment-correction.patch
mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb.patch

