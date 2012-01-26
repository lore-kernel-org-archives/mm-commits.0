From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch added to -mm tree
Date: Wed, 25 Jan 2012 17:03:15 -0800
Message-ID: <20120126010315.A718FA02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:48104 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2AZBDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Jan 2012 20:03:16 -0500
Received: by ghbg20 with SMTP id g20so3481ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Jan 2012 17:03:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com


The patch titled
     Subject: mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: vmscan: fix misused nr_reclaimed in shrink_mem_cgroup_zone()

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
mm-vmscanc-cleanup-with-s-reclaim_mode-isolate_mode.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch

