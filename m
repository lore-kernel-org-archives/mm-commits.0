From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:37 -0700
Message-ID: <20120322201737.86014A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44214 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab2CVURj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:39 -0400
Received: by mail-bk0-f74.google.com with SMTP id jm19so134208bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()

The value of nr_reclaimed is the number of pages reclaimed in the current
round of the loop, whereas nr_to_reclaim should be compared with the
number of pages reclaimed in all rounds.

In each round of the loop, reclaimed pages are cut off from the reclaim
goal, and the loop stops once the goal achieved.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone
+++ a/mm/vmscan.c
@@ -2112,7 +2112,12 @@ restart:
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
+		if (nr_reclaimed >= nr_to_reclaim)
+			nr_to_reclaim = 0;
+		else
+			nr_to_reclaim -= nr_reclaimed;
+
+		if (!nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
 	blk_finish_plug(&plug);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch

