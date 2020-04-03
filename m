From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch removed from
 -mm tree
Date: Fri, 03 Apr 2020 13:39:55 -0700
Message-ID: <20200403203955.AcTYjGsiH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUj4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@redhat.com, mateusznosek0@gmail.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/vmscan.c: clean code by removing unnecessary assignment
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/vmscan.c: clean code by removing unnecessary assignment

Previously 0 was assigned to variable 'lruvec_size', but the variable was
never read later.  So the assignment can be removed.

Link: http://lkml.kernel.org/r/20200229214022.11853-1-mateusznosek0@gmail.com
Fixes: f87bccde6a7d ("mm/vmscan: remove unused lru_pages argument")
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
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

mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch
