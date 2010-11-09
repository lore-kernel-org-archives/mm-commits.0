From: akpm@linux-foundation.org
Subject: + memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch added to -mm tree
Date: Mon, 08 Nov 2010 17:23:59 -0800
Message-ID: <201011090126.oA91Q8Mb020899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab0KIB0h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Nov 2010 20:26:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: avoid overflow in memcg_hierarchical_free_pages()
has been added to the -mm tree.  Its filename is
     memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch

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

memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
memcg-create-extensible-page-stat-update-routines.patch
memcg-add-lock-to-synchronize-page-accounting-and-migration.patch
writeback-create-dirty_info-structure.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-dirty-limits-to-mem_cgroup-use-native-word-to-represent-dirtyable-pages.patch
memcg-add-dirty-limits-to-mem_cgroup-catch-negative-per-cpu-sums-in-dirty-info.patch
memcg-add-dirty-limits-to-mem_cgroup-avoid-overflow-in-memcg_hierarchical_free_pages.patch
memcg-add-dirty-limits-to-mem_cgroup-correct-memcg_hierarchical_free_pages-return-type.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch

