From: akpm@linux-foundation.org
Subject: [folded] memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:17:34 -0700
Message-ID: <201105262317.p4QNHYOk026368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527Ab1EZXSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:18:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghan@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-reclaim-memory-from-nodes-in-round-robin-order-fix
has been removed from the -mm tree.  Its filename was
     memcg-reclaim-memory-from-nodes-in-round-robin-order-fix.patch

This patch was dropped because it was folded into memcg-reclaim-memory-from-nodes-in-round-robin-order.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-reclaim-memory-from-nodes-in-round-robin-order-fix
From: Ying Han <yinghan@google.com>

The value for counter base should be initialized. If not,
this returns wrong value.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-order-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reclaim-memory-from-nodes-in-round-robin-order-fix
+++ a/mm/memcontrol.c
@@ -633,7 +633,7 @@ static unsigned long
 mem_cgroup_get_zonestat_node(struct mem_cgroup *mem, int nid, enum lru_list idx)
 {
 	struct mem_cgroup_per_zone *mz;
-	u64 total;
+	u64 total = 0;
 	int zid;
 
 	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
_

Patches currently in -mm which might be from yinghan@google.com are

origin.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-count-the-soft_limit-reclaim-in-global-background-reclaim.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
memcg-fix-get_scan_count-for-small-targets.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch
memcg-add-memorynumastat-api-for-numa-statistics.patch
memcg-add-memorynumastat-api-for-numa-statistics-v5.patch
add-the-pagefault-count-into-memcg-stats.patch

