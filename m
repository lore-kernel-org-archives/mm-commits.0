From: akpm@linux-foundation.org
Subject: + mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch
 added to -mm tree
Date: Tue, 20 Sep 2016 14:16:45 -0700
Message-ID: <57e1a73d.Q4E2luJVLuDRBdC2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753632AbcITVQq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Sep 2016 17:16:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vma_adjust: remove superfluous check for next not NULL
has been added to the -mm tree.  Its filename is
     mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch

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
Subject: mm: vma_adjust: remove superfluous check for next not NULL

If next would be NULL we couldn't reach such code path.

Link: http://lkml.kernel.org/r/1474309513-20313-2-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Vorlicek <janvorli@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-vma_adjust-remove-superfluous-check-for-next-not-null mm/mmap.c
--- a/mm/mmap.c~mm-vma_adjust-remove-superfluous-check-for-next-not-null
+++ a/mm/mmap.c
@@ -699,7 +699,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * If next doesn't have anon_vma, import from vma after
 			 * next, if the vma overlaps with it.
 			 */
-			if (remove_next == 2 && next && !next->anon_vma)
+			if (remove_next == 2 && !next->anon_vma)
 				exporter = next->vm_next;
 
 		} else if (end > next->vm_start) {
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch

