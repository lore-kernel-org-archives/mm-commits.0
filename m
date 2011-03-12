From: akpm@linux-foundation.org
Subject: + memcg-add-dirty-limits-to-mem_cgroup.patch added to -mm tree
Date: Fri, 11 Mar 2011 17:23:15 -0800
Message-ID: <201103120123.p2C1NGJP007054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab1CLBYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Mar 2011 20:24:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, ctalbott@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, teravest@google.com


The patch titled
     memcg: add dirty limits to mem_cgroup
has been added to the -mm tree.  Its filename is
     memcg-add-dirty-limits-to-mem_cgroup.patch

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
Subject: memcg: add dirty limits to mem_cgroup
From: Greg Thelen <gthelen@google.com>

Extend mem_cgroup to contain dirty page limits.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>
Cc: Justin TerAvest <teravest@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   51 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-dirty-limits-to-mem_cgroup
+++ a/mm/memcontrol.c
@@ -203,6 +203,14 @@ struct mem_cgroup_eventfd_list {
 static void mem_cgroup_threshold(struct mem_cgroup *mem);
 static void mem_cgroup_oom_notify(struct mem_cgroup *mem);
 
+/* Dirty memory parameters */
+struct vm_dirty_param {
+	int dirty_ratio;
+	int dirty_background_ratio;
+	unsigned long dirty_bytes;
+	unsigned long dirty_background_bytes;
+};
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -242,6 +250,10 @@ struct mem_cgroup {
 	atomic_t	refcnt;
 
 	unsigned int	swappiness;
+
+	/* control memory cgroup dirty pages */
+	struct vm_dirty_param dirty_param;
+
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
@@ -1198,6 +1210,36 @@ static unsigned int get_swappiness(struc
 	return memcg->swappiness;
 }
 
+/*
+ * Return true if the current memory cgroup has local dirty memory settings.
+ * There is an allowed race between the current task migrating in-to/out-of the
+ * root cgroup while this routine runs.  So the return value may be incorrect if
+ * the current task is being simultaneously migrated.
+ */
+static bool mem_cgroup_has_dirty_limit(struct mem_cgroup *mem)
+{
+	return mem && !mem_cgroup_is_root(mem);
+}
+
+/*
+ * Returns a snapshot of the current dirty limits which is not synchronized with
+ * the routines that change the dirty limits.  If this routine races with an
+ * update to the dirty bytes/ratio value, then the caller must handle the case
+ * where neither dirty_[background_]_ratio nor _bytes are set.
+ */
+static void mem_cgroup_dirty_param(struct vm_dirty_param *param,
+				   struct mem_cgroup *mem)
+{
+	if (mem_cgroup_has_dirty_limit(mem)) {
+		*param = mem->dirty_param;
+	} else {
+		param->dirty_ratio = vm_dirty_ratio;
+		param->dirty_bytes = vm_dirty_bytes;
+		param->dirty_background_ratio = dirty_background_ratio;
+		param->dirty_background_bytes = dirty_background_bytes;
+	}
+}
+
 static void mem_cgroup_start_move(struct mem_cgroup *mem)
 {
 	int cpu;
@@ -4669,8 +4711,15 @@ mem_cgroup_create(struct cgroup_subsys *
 	mem->last_scanned_child = 0;
 	INIT_LIST_HEAD(&mem->oom_notify);
 
-	if (parent)
+	if (parent) {
 		mem->swappiness = get_swappiness(parent);
+		mem_cgroup_dirty_param(&mem->dirty_param, parent);
+	} else {
+		/*
+		 * The root cgroup dirty_param field is not used, instead,
+		 * system-wide dirty limits are used.
+		 */
+	}
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
 	mutex_init(&mem->thresholds_lock);
_

Patches currently in -mm which might be from gthelen@google.com are

linux-next.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

