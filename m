From: akpm@linux-foundation.org
Subject: [patch 093/127] mm: vma_adjust: remove superfluous check for next not NULL
Date: Fri, 07 Oct 2016 17:01:31 -0700
Message-ID: <57f8375b.XBA4xp29PLb1fB0J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39457 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753684AbcJHABc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com

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
@@ -706,7 +706,7 @@ int __vma_adjust(struct vm_area_struct *
 			 * If next doesn't have anon_vma, import from vma after
 			 * next, if the vma overlaps with it.
 			 */
-			if (remove_next == 2 && next && !next->anon_vma)
+			if (remove_next == 2 && !next->anon_vma)
 				exporter = next->vm_next;
 
 		} else if (end > next->vm_start) {
_
