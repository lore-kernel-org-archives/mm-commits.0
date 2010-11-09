From: akpm@linux-foundation.org
Subject: + memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch added to -mm tree
Date: Tue, 09 Nov 2010 11:21:59 -0800
Message-ID: <201011091921.oA9JLxEQ002262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493Ab0KITWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Nov 2010 14:22:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hidave.darkstar@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: make mem_cgroup_page_stat() return value unsigned
has been added to the -mm tree.  Its filename is
     memcg-make-mem_cgroup_page_stat-return-value-unsigned.patch

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
Subject: memcg: make mem_cgroup_page_stat() return value unsigned
From: Greg Thelen <gthelen@google.com>

mem_cgroup_page_stat() used to return a negative page count value to
indicate value.

mem_cgroup_page_stat() has changed so it never returns error so convert
the return value to the traditional page count type (unsigned long).

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

 include/linux/memcontrol.h |    6 +++---
 mm/memcontrol.c            |   12 ++++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-make-mem_cgroup_page_stat-return-value-unsigned include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-make-mem_cgroup_page_stat-return-value-unsigned
+++ a/include/linux/memcontrol.h
@@ -158,8 +158,8 @@ bool mem_cgroup_has_dirty_limit(void);
 bool mem_cgroup_dirty_info(unsigned long sys_available_mem,
 			   struct mem_cgroup *memcg,
 			   struct dirty_info *info);
-long mem_cgroup_page_stat(struct mem_cgroup *mem,
-			  enum mem_cgroup_nr_pages_item item);
+unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
+				   enum mem_cgroup_nr_pages_item item);
 
 unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
 						gfp_t gfp_mask);
@@ -354,7 +354,7 @@ static inline bool mem_cgroup_dirty_info
 	return false;
 }
 
-static inline long mem_cgroup_page_stat(struct mem_cgroup *mem,
+static inline unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
 					enum mem_cgroup_nr_pages_item item)
 {
 	return -ENOSYS;
diff -puN mm/memcontrol.c~memcg-make-mem_cgroup_page_stat-return-value-unsigned mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-make-mem_cgroup_page_stat-return-value-unsigned
+++ a/mm/memcontrol.c
@@ -1361,8 +1361,8 @@ memcg_hierarchical_free_pages(struct mem
  *
  * Return the accounted statistic value.
  */
-long mem_cgroup_page_stat(struct mem_cgroup *mem,
-			  enum mem_cgroup_nr_pages_item item)
+unsigned long mem_cgroup_page_stat(struct mem_cgroup *mem,
+				   enum mem_cgroup_nr_pages_item item)
 {
 	struct mem_cgroup *iter;
 	long value;
@@ -1388,6 +1388,14 @@ long mem_cgroup_page_stat(struct mem_cgr
 	for_each_mem_cgroup_tree(iter, mem)
 		value += mem_cgroup_local_page_stat(iter, item);
 
+	/*
+	 * The sum of unlocked per-cpu counters may yield a slightly negative
+	 * value.  This function returns an unsigned value, so round it up to
+	 * zero to avoid returning a very large value.
+	 */
+	if (value < 0)
+		value = 0;
+
 	put_online_cpus();
 
 	return value;
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

