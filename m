From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch removed from -mm tree
Date: Fri, 11 Mar 2011 16:50:18 -0800
Message-ID: <201103120050.p2C0oIHq005644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752768Ab1CLAvE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 19:51:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@g


The patch titled
     memcg: avoid overflow in memcg_hierarchical_free_pages()
has been removed from the -mm tree.  Its filename was
     memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid overflow in memcg_hierarchical_free_pages()
From: Greg Thelen <gthelen@google.com>

Use page counts rather than byte counts to avoid overflowing
unsigned long local variables.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrea Righi <arighi@develer.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages
+++ a/mm/memcontrol.c
@@ -1321,17 +1321,17 @@ memcg_hierarchical_free_pages(struct mem
 {
 	unsigned long free, min_free;
 
-	min_free = global_page_state(NR_FREE_PAGES) << PAGE_SHIFT;
+	min_free = global_page_state(NR_FREE_PAGES);
 
 	while (mem) {
-		free = res_counter_read_u64(&mem->res, RES_LIMIT) -
-			res_counter_read_u64(&mem->res, RES_USAGE);
+		free = (res_counter_read_u64(&mem->res, RES_LIMIT) -
+			res_counter_read_u64(&mem->res, RES_USAGE)) >>
+			PAGE_SHIFT;
 		min_free = min(min_free, free);
 		mem = parent_mem_cgroup(mem);
 	}
 
-	/* Translate free memory in pages */
-	return min_free >> PAGE_SHIFT;
+	return min_free;
 }
 
 /*
_

Patches currently in -mm which might be from gthelen@google.com are

linux-next.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch

