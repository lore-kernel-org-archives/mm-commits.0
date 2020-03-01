From: akpm@linux-foundation.org
Subject: +
 mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch added to -mm
 tree
Date: Sat, 29 Feb 2020 18:03:16 -0800
Message-ID: <20200301020316.jY5CBQMWY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbgCACDS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 21:03:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mateusznosek0@gmail.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm/vmscan.c: Clean code by removing unnecessary assignment
has been added to the -mm tree.  Its filename is
     mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/vmscan.c: Clean code by removing unnecessary assignment

Previously 0 was assigned to variable 'lruvec_size', but the variable was
never read later.  So the assignment can be removed.

Link: http://lkml.kernel.org/r/20200229214022.11853-1-mateusznosek0@gmail.com
Fixes: f87bccde6a7d ("mm/vmscan: remove unused lru_pages argument")
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-clean-code-by-removing-unnecessary-assignment
+++ a/mm/vmscan.c
@@ -2427,10 +2427,8 @@ out:
 		case SCAN_FILE:
 		case SCAN_ANON:
 			/* Scan one type exclusively */
-			if ((scan_balance == SCAN_FILE) != file) {
-				lruvec_size = 0;
+			if ((scan_balance == SCAN_FILE) != file)
 				scan = 0;
-			}
 			break;
 		default:
 			/* Look ma, no brain */
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
