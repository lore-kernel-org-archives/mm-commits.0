From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch removed from -mm tree
Date: Fri, 11 Mar 2011 16:50:15 -0800
Message-ID: <201103120050.p2C0oFQE005638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768Ab1CLAvH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 19:51:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@g


The patch titled
     memcg: avoid "free" overflow in memcg_hierarchical_free_pages()
has been removed from the -mm tree.  Its filename was
     memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid "free" overflow in memcg_hierarchical_free_pages()
From: Greg Thelen <gthelen@google.com>

memcg limit and usage values are stored in res_counter, as 64-bit numbers,
even on 32-bit machines.  The "free" variable in
memcg_hierarchical_free_pages() stores the difference between two 64-bit
numbers (limit - current_usage), and thus should be stored in a 64-bit
local rather than a machine defined unsigned long.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages
+++ a/mm/memcontrol.c
@@ -1319,7 +1319,8 @@ static s64 mem_cgroup_local_page_stat(st
 static unsigned long
 memcg_hierarchical_free_pages(struct mem_cgroup *mem)
 {
-	unsigned long free, min_free;
+	u64 free;
+	unsigned long min_free;
 
 	min_free = global_page_state(NR_FREE_PAGES);
 
@@ -1327,7 +1328,7 @@ memcg_hierarchical_free_pages(struct mem
 		free = (res_counter_read_u64(&mem->res, RES_LIMIT) -
 			res_counter_read_u64(&mem->res, RES_USAGE)) >>
 			PAGE_SHIFT;
-		min_free = min(min_free, free);
+		min_free = min((u64)min_free, free);
 		mem = parent_mem_cgroup(mem);
 	}
 
_

Patches currently in -mm which might be from gthelen@google.com are

linux-next.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch

