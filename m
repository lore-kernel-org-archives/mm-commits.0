From: akpm@linux-foundation.org
Subject: [folded] memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch removed from -mm tree
Date: Thu, 26 May 2011 16:17:31 -0700
Message-ID: <201105262317.p4QNHVEe026365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527Ab1EZXSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg-reclaim-memory-from-nodes-in-round-robin-fix-2
has been removed from the -mm tree.  Its filename was
     memcg-reclaim-memory-from-nodes-in-round-robin-fix-2.patch

This patch was dropped because it was folded into memcg-reclaim-memory-from-nodes-in-round-robin-order.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-reclaim-memory-from-nodes-in-round-robin-fix-2
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

next_scan_node_update is the time when scan_nodes nodemask should be
updated.  Then, time_after() is correct.  Otherwise, next-scan_node_update
is intialized to be 0 and time_before() returns always true, scan_nodes
never be updated.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-fix-2
+++ a/mm/memcontrol.c
@@ -1517,7 +1517,7 @@ static void mem_cgroup_may_update_nodema
 {
 	int nid;
 
-	if (time_before(mem->next_scan_node_update, jiffies))
+	if (time_after(mem->next_scan_node_update, jiffies))
 		return;
 
 	mem->next_scan_node_update = jiffies + 10*HZ;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch
add-the-pagefault-count-into-memcg-stats.patch

