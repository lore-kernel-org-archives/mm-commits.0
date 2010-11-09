From: akpm@linux-foundation.org
Subject: + memcg-simplify-mem_cgroup_dirty_info.patch added to -mm tree
Date: Tue, 09 Nov 2010 11:21:57 -0800
Message-ID: <201011091921.oA9JLv2x002259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab0KITWe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 14:22:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: simplify mem_cgroup_dirty_info()
has been added to the -mm tree.  Its filename is
     memcg-simplify-mem_cgroup_dirty_info.patch

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
Subject: memcg: simplify mem_cgroup_dirty_info()
From: Greg Thelen <gthelen@google.com>

Because mem_cgroup_page_stat() no longer returns negative numbers to
indicate failure, mem_cgroup_dirty_info() does not need to check for such
failures.

Signed-off-by: Greg Thelen <gthelen@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
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

 mm/memcontrol.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-simplify-mem_cgroup_dirty_info mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-mem_cgroup_dirty_info
+++ a/mm/memcontrol.c
@@ -1258,8 +1258,6 @@ bool mem_cgroup_dirty_info(unsigned long
 	__mem_cgroup_dirty_param(&dirty_param, memcg);
 
 	value = mem_cgroup_page_stat(memcg, MEMCG_NR_DIRTYABLE_PAGES);
-	if (value < 0)
-		goto done;
 
 	available_mem = min((unsigned long)value, sys_available_mem);
 
@@ -1279,15 +1277,9 @@ bool mem_cgroup_dirty_info(unsigned long
 			(dirty_param.dirty_background_ratio *
 			       available_mem) / 100;
 
-	value = mem_cgroup_page_stat(memcg, MEMCG_NR_RECLAIM_PAGES);
-	if (value < 0)
-		goto done;
-	info->nr_reclaimable = value;
-
-	value = mem_cgroup_page_stat(memcg, MEMCG_NR_WRITEBACK);
-	if (value < 0)
-		goto done;
-	info->nr_writeback = value;
+	info->nr_reclaimable =
+		mem_cgroup_page_stat(memcg, MEMCG_NR_RECLAIM_PAGES);
+	info->nr_writeback = mem_cgroup_page_stat(memcg, MEMCG_NR_WRITEBACK);
 
 	valid = true;
 
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
memcg-add-dirty-limits-to-mem_cgroup-avoid-free-overflow-in-memcg_hierarchical_free_pages.patch
memcg-cpu-hotplug-lockdep-warning-fix.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix.patch
memcg-add-mem_cgroup-parameter-to-mem_cgroup_page_stat.patch
memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch
memcg-make-throttle_vm_writeout-memcg-aware.patch
memcg-simplify-mem_cgroup_page_stat.patch
memcg-simplify-mem_cgroup_dirty_info.patch
memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch

