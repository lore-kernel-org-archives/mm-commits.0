From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-unused-retry-signal-from-reclaim.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:14 -0700
Message-ID: <201105271956.p4RJuJVm017543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932225Ab1E0T4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, riel@redha


The patch titled
     memcg: remove unused retry signal from reclaim
has been removed from the -mm tree.  Its filename was
     memcg-remove-unused-retry-signal-from-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove unused retry signal from reclaim
From: Johannes Weiner <hannes@cmpxchg.org>

If the memcg reclaim code detects the target memcg below its limit it
exits and returns a guaranteed non-zero value so that the charge is
retried.

Nowadays, the charge side checks the memcg limit itself and does not rely
on this non-zero return value trick.

This patch removes it.  The reclaim code will now always return the true
number of pages it reclaimed on its own.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel<riel@redhat.com>
Acked-by: Ying Han<yinghan@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-unused-retry-signal-from-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-unused-retry-signal-from-reclaim
+++ a/mm/memcontrol.c
@@ -1596,7 +1596,7 @@ static int mem_cgroup_hierarchical_recla
 			if (!res_counter_soft_limit_excess(&root_mem->res))
 				return total;
 		} else if (mem_cgroup_margin(root_mem))
-			return 1 + total;
+			return total;
 	}
 	return total;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch

