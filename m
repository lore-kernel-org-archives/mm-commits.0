From: akpm@linux-foundation.org
Subject: - memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:25 -0800
Message-ID: <200802080804.m18846Gf014241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759364AbYBHIbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:31:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     memory cgroup enhancements: add status accounting function for memory cgroup
has been removed from the -mm tree.  Its filename was
     memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memory cgroup enhancements: add status accounting function for memory cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add statistics account infrastructure for memory controller.  All account
information is stored per-cpu and caller will not have to take lock or use
atomic ops.  This will be used by memory.stat file later.

CACHE includes swapcache now. I'd like to divide it to
PAGECACHE and SWAPCACHE later.

This patch adds 3 functions for accounting.
 * __mem_cgroup_stat_add() ... for usual routine.
 * __mem_cgroup_stat_add_safe ... for calling under irq_disabled section.
 * mem_cgroup_read_stat() ... for reading stat value.
 * renamed PAGECACHE to CACHE (because it may include swapcache *now*)

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix smp_processor_id-in-preemptible]
[akpm@linux-foundation.org: uninline things]
[akpm@linux-foundation.org: remove dead code]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   77 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 5 deletions(-)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup
+++ a/mm/memcontrol.c
@@ -21,6 +21,7 @@
 #include <linux/memcontrol.h>
 #include <linux/cgroup.h>
 #include <linux/mm.h>
+#include <linux/smp.h>
 #include <linux/page-flags.h>
 #include <linux/backing-dev.h>
 #include <linux/bit_spinlock.h>
@@ -35,6 +36,47 @@ struct cgroup_subsys mem_cgroup_subsys;
 static const int MEM_CGROUP_RECLAIM_RETRIES = 5;
 
 /*
+ * Statistics for memory cgroup.
+ */
+enum mem_cgroup_stat_index {
+	/*
+	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
+	 */
+	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
+	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
+
+	MEM_CGROUP_STAT_NSTATS,
+};
+
+struct mem_cgroup_stat_cpu {
+	s64 count[MEM_CGROUP_STAT_NSTATS];
+} ____cacheline_aligned_in_smp;
+
+struct mem_cgroup_stat {
+	struct mem_cgroup_stat_cpu cpustat[NR_CPUS];
+};
+
+/*
+ * For accounting under irq disable, no need for increment preempt count.
+ */
+static void __mem_cgroup_stat_add_safe(struct mem_cgroup_stat *stat,
+		enum mem_cgroup_stat_index idx, int val)
+{
+	int cpu = smp_processor_id();
+	stat->cpustat[cpu].count[idx] += val;
+}
+
+static s64 mem_cgroup_read_stat(struct mem_cgroup_stat *stat,
+		enum mem_cgroup_stat_index idx)
+{
+	int cpu;
+	s64 ret = 0;
+	for_each_possible_cpu(cpu)
+		ret += stat->cpustat[cpu].count[idx];
+	return ret;
+}
+
+/*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
  * statistics based on the statistics developed by Rik Van Riel for clock-pro,
@@ -63,6 +105,10 @@ struct mem_cgroup {
 	 */
 	spinlock_t lru_lock;
 	unsigned long control_type;	/* control RSS or RSS+Pagecache */
+	/*
+	 * statistics.
+	 */
+	struct mem_cgroup_stat stat;
 };
 
 /*
@@ -101,6 +147,24 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
 };
 
+/*
+ * Always modified under lru lock. Then, not necessary to preempt_disable()
+ */
+static void mem_cgroup_charge_statistics(struct mem_cgroup *mem, int flags,
+					bool charge)
+{
+	int val = (charge)? 1 : -1;
+	struct mem_cgroup_stat *stat = &mem->stat;
+	VM_BUG_ON(!irqs_disabled());
+
+	if (flags & PAGE_CGROUP_FLAG_CACHE)
+		__mem_cgroup_stat_add_safe(stat,
+					MEM_CGROUP_STAT_CACHE, val);
+	else
+		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
+
+}
+
 static struct mem_cgroup init_mem_cgroup;
 
 static inline
@@ -175,8 +239,8 @@ static void __always_inline unlock_page_
  * This can fail if the page has been tied to a page_cgroup.
  * If success, returns 0.
  */
-static inline int
-page_cgroup_assign_new_page_cgroup(struct page *page, struct page_cgroup *pc)
+static int page_cgroup_assign_new_page_cgroup(struct page *page,
+						struct page_cgroup *pc)
 {
 	int ret = 0;
 
@@ -198,8 +262,8 @@ page_cgroup_assign_new_page_cgroup(struc
  *  clear_page_cgroup(page, pc) == pc
  */
 
-static inline struct page_cgroup *
-clear_page_cgroup(struct page *page, struct page_cgroup *pc)
+static struct page_cgroup *clear_page_cgroup(struct page *page,
+						struct page_cgroup *pc)
 {
 	struct page_cgroup *ret;
 	/* lock and clear */
@@ -211,7 +275,6 @@ clear_page_cgroup(struct page *page, str
 	return ret;
 }
 
-
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
 	if (active) {
@@ -426,6 +489,8 @@ retry:
 	}
 
 	spin_lock_irqsave(&mem->lru_lock, flags);
+	/* Update statistics vector */
+	mem_cgroup_charge_statistics(mem, pc->flags, true);
 	list_add(&pc->lru, &mem->active_list);
 	spin_unlock_irqrestore(&mem->lru_lock, flags);
 
@@ -496,6 +561,7 @@ void mem_cgroup_uncharge(struct page_cgr
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			spin_lock_irqsave(&mem->lru_lock, flags);
 			list_del_init(&pc->lru);
+			mem_cgroup_charge_statistics(mem, pc->flags, false);
 			spin_unlock_irqrestore(&mem->lru_lock, flags);
 			kfree(pc);
 		}
@@ -572,6 +638,7 @@ retry:
 			css_put(&mem->css);
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			list_del_init(&pc->lru);
+			mem_cgroup_charge_statistics(mem, pc->flags, false);
 			kfree(pc);
 		} else 	/* being uncharged ? ...do relax */
 			break;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
