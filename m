From: akpm@linux-foundation.org
Subject: + memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch added to -mm tree
Date: Tue, 09 Nov 2010 11:21:51 -0800
Message-ID: <201011091921.oA9JLpIH002247@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493Ab0KITWa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 14:22:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: pass mem_cgroup to mem_cgroup_dirty_info()
has been added to the -mm tree.  Its filename is
     memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info.patch

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
Subject: memcg: pass mem_cgroup to mem_cgroup_dirty_info()
From: Greg Thelen <gthelen@google.com>

Pass mem_cgroup parameter through memcg_dirty_info() into
mem_cgroup_dirty_info().  This allows for querying dirty memory
information from a particular cgroup, rather than just the current task's
cgroup.

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

 include/linux/memcontrol.h |    2 ++
 mm/memcontrol.c            |    5 +++--
 mm/page-writeback.c        |    9 ++++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info
+++ a/include/linux/memcontrol.h
@@ -156,6 +156,7 @@ static inline void mem_cgroup_dec_page_s
 
 bool mem_cgroup_has_dirty_limit(void);
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
+			   struct mem_cgroup *memcg,
 			   struct dirty_info *info);
 long mem_cgroup_page_stat(struct mem_cgroup *mem,
 			  enum mem_cgroup_nr_pages_item item);
@@ -347,6 +348,7 @@ static inline bool mem_cgroup_has_dirty_
 }
 
 static inline bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
+					 struct mem_cgroup *memcg,
 					 struct dirty_info *info)
 {
 	return false;
diff -puN mm/memcontrol.c~memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info
+++ a/mm/memcontrol.c
@@ -1239,11 +1239,11 @@ static void __mem_cgroup_dirty_param(str
  * "memcg" will not be freed while holding rcu_read_lock().
  */
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
+			   struct mem_cgroup *memcg,
 			   struct dirty_info *info)
 {
 	struct vm_dirty_param dirty_param;
 	unsigned long available_mem;
-	struct mem_cgroup *memcg;
 	long value;
 	bool valid = false;
 
@@ -1251,7 +1251,8 @@ bool mem_cgroup_dirty_info(unsigned long
 		return false;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_task(current);
+	if (!memcg)
+		memcg = mem_cgroup_from_task(current);
 	if (!__mem_cgroup_has_dirty_limit(memcg))
 		goto done;
 	__mem_cgroup_dirty_param(&dirty_param, memcg);
diff -puN mm/page-writeback.c~memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-pass-mem_cgroup-to-mem_cgroup_dirty_info
+++ a/mm/page-writeback.c
@@ -461,12 +461,15 @@ void global_dirty_info(struct dirty_info
  * Calculate the background-writeback and dirty-throttling thresholds and dirty
  * usage metrics from the current task's memcg dirty limit parameters.  Returns
  * false if no memcg limits exist.
+ *
+ * @memcg may be NULL if the current task's memcg should be used.
+ * @info is the location where the dirty information is written.
  */
-static bool memcg_dirty_info(struct dirty_info *info)
+static bool memcg_dirty_info(struct mem_cgroup *memcg, struct dirty_info *info)
 {
 	unsigned long available_memory = determine_dirtyable_memory();
 
-	if (!mem_cgroup_dirty_info(available_memory, info))
+	if (!mem_cgroup_dirty_info(available_memory, memcg, info))
 		return false;
 
 	adjust_dirty_info(info);
@@ -534,7 +537,7 @@ static void balance_dirty_pages(struct a
 
 		global_dirty_info(&sys_info);
 
-		if (!memcg_dirty_info(&memcg_info))
+		if (!memcg_dirty_info(NULL, &memcg_info))
 			memcg_info = sys_info;
 
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

