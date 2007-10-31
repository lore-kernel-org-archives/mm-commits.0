From: akpm@linux-foundation.org
Subject: + memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch added to -mm tree
Date: Wed, 31 Oct 2007 15:00:40 -0700
Message-ID: <200710312200.l9VM0eEx031027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42125 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760923AbXJaWBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 18:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memory cgroup enhancements: add status accounting function for memory cgroup
has been added to the -mm tree.  Its filename is
     memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff -puN mm/memcontrol.c~memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup
+++ a/mm/memcontrol.c
@@ -35,6 +35,59 @@ struct cgroup_subsys mem_cgroup_subsys;
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
+ * modifies value with disabling preempt.
+ */
+static inline void __mem_cgroup_stat_add(struct mem_cgroup_stat *stat,
+                enum mem_cgroup_stat_index idx, int val)
+{
+	int cpu = smp_processor_id();
+	preempt_disable();
+	stat->cpustat[cpu].count[idx] += val;
+	preempt_enable();
+}
+
+/*
+ * For accounting under irq disable, no need for increment preempt count.
+ */
+static inline void __mem_cgroup_stat_add_safe(struct mem_cgroup_stat *stat,
+		enum mem_cgroup_stat_index idx, int val)
+{
+	int cpu = smp_processor_id();
+	stat->cpustat[cpu].count[idx] += val;
+}
+
+static inline s64 mem_cgroup_read_stat(struct mem_cgroup_stat *stat,
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
@@ -63,6 +116,10 @@ struct mem_cgroup {
 	 */
 	spinlock_t lru_lock;
 	unsigned long control_type;	/* control RSS or RSS+Pagecache */
+	/*
+	 * statistics.
+	 */
+	struct mem_cgroup_stat stat;
 };
 
 /*
@@ -101,6 +158,27 @@ enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_MAPPED,
 };
 
+/*
+ * Always modified under lru lock. Then, not necessary to preempt_disable()
+ */
+static inline void
+mem_cgroup_charge_statistics(struct mem_cgroup *mem, int flags, bool charge)
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
+
+
+
 static struct mem_cgroup init_mem_cgroup;
 
 static inline
@@ -445,6 +523,8 @@ noreclaim:
 	}
 
 	spin_lock_irqsave(&mem->lru_lock, flags);
+	/* Update statistics vector */
+	mem_cgroup_charge_statistics(mem, pc->flags, true);
 	list_add(&pc->lru, &mem->active_list);
 	spin_unlock_irqrestore(&mem->lru_lock, flags);
 
@@ -510,6 +590,7 @@ void mem_cgroup_uncharge(struct page_cgr
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			spin_lock_irqsave(&mem->lru_lock, flags);
 			list_del_init(&pc->lru);
+			mem_cgroup_charge_statistics(mem, pc->flags, false);
 			spin_unlock_irqrestore(&mem->lru_lock, flags);
 			kfree(pc);
 		}
@@ -586,6 +667,7 @@ retry:
 			css_put(&mem->css);
 			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			list_del_init(&pc->lru);
+			mem_cgroup_charge_statistics(mem, pc->flags, false);
 			kfree(pc);
 		} else 	/* being uncharged ? ...do relax */
 			break;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

git-sh.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force-empty-at-rmdir.patch
