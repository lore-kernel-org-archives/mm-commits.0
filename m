From: akpm@linux-foundation.org
Subject: + memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-3.patch added to -mm tree
Date: Mon, 16 May 2011 17:11:41 -0700
Message-ID: <201105170011.p4H0BfAa028401@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47021 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805Ab1EQAM6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 May 2011 20:12:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com


The patch titled
     memcg: fix typo in the soft_limit stats.
has been added to the -mm tree.  Its filename is
     memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-3.patch

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
Subject: memcg: fix typo in the soft_limit stats.
From: Ying Han <yinghan@google.com>

This fixes the typo in the memory.stat including the following two
stats:

$ cat /dev/cgroup/memory/A/memory.stat
total_soft_steal 0
total_soft_scan 0

And change it to:

$ cat /dev/cgroup/memory/A/memory.stat
total_soft_kswapd_steal 0
total_soft_kswapd_scan 0

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-3 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-3
+++ a/mm/memcontrol.c
@@ -3850,8 +3850,8 @@ struct {
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
 	{"swap", "total_swap"},
-	{"soft_kswapd_steal", "total_soft_steal"},
-	{"soft_kswapd_scan", "total_soft_scan"},
+	{"soft_kswapd_steal", "total_soft_kswapd_steal"},
+	{"soft_kswapd_scan", "total_soft_kswapd_scan"},
 	{"soft_direct_steal", "total_soft_direct_steal"},
 	{"soft_direct_scan", "total_soft_direct_scan"},
 	{"inactive_anon", "total_inactive_anon"},
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch
memcg-fix-zone-congestion.patch
memcg-fix-zone-congestion-fix.patch
memcg-fix-zone-congestion-fix-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix.patch
vmscan-change-shrink_slab-interfaces-by-passing-shrink_control-fix-2.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix.patch
vmscan-change-shrinker-api-by-passing-shrink_control-struct-fix-2.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-2.patch
memcg-add-stats-to-monitor-soft_limit-reclaim-v2-fix-3.patch
add-the-pagefault-count-into-memcg-stats.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix.patch
memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch

