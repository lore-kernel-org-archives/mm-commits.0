From: akpm@linux-foundation.org
Subject: + memcg-remove-unused-retry-signal-from-reclaim.patch added to -mm tree
Date: Mon, 16 May 2011 15:31:36 -0700
Message-ID: <201105162231.p4GMVad2023253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826Ab1EPWck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 May 2011 18:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, yinghan@google.com


The patch titled
     memcg: remove unused retry signal from reclaim
has been added to the -mm tree.  Its filename is
     memcg-remove-unused-retry-signal-from-reclaim.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1675,7 +1675,7 @@ static int mem_cgroup_hierarchical_recla
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
mm-vmscan-correct-use-of-pgdat_balanced-in-sleeping_prematurely.patch
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch
mm-break-out-page-allocation-warning-code.patch
mm-print-vmalloc-state-after-allocation-failures.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-remove-unused-retry-signal-from-reclaim.patch

