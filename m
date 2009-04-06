From: akpm@linux-foundation.org
Subject: [merged] memcg-show-memcg-information-during-oom.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:34:37 -0700
Message-ID: <200904061934.n36JYbBZ011700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbZDFUd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: show memcg information during OOM
has been removed from the -mm tree.  Its filename was
     memcg-show-memcg-information-during-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: show memcg information during OOM
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Add RSS and swap to OOM output from memcg

Display memcg values like failcnt, usage and limit when an OOM occurs due
to memcg.

Thanks to Johannes Weiner, Li Zefan, David Rientjes, Kamezawa Hiroyuki,
Daisuke Nishimura and KOSAKI Motohiro for review.

Sample output
-------------

Task in /a/x killed as a result of limit of /a
memory: usage 1048576kB, limit 1048576kB, failcnt 4183
memory+swap: usage 1400964kB, limit 9007199254740991kB, failcnt 0

[akpm@linux-foundation.org: compilation fix]
[akpm@linux-foundation.org: fix kerneldoc and whitespace]
[akpm@linux-foundation.org: add printk facility level]
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++
 mm/memcontrol.c            |   69 +++++++++++++++++++++++++++++++++++
 mm/oom_kill.c              |    1 
 3 files changed, 77 insertions(+)

diff -puN include/linux/memcontrol.h~memcg-show-memcg-information-during-oom include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-show-memcg-information-during-oom
+++ a/include/linux/memcontrol.h
@@ -104,6 +104,8 @@ struct zone_reclaim_stat *mem_cgroup_get
 						      struct zone *zone);
 struct zone_reclaim_stat*
 mem_cgroup_get_reclaim_stat_from_page(struct page *page);
+extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
+					struct task_struct *p);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -270,6 +272,11 @@ mem_cgroup_get_reclaim_stat_from_page(st
 	return NULL;
 }
 
+static inline void
+mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
+{
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcg-show-memcg-information-during-oom mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-memcg-information-during-oom
+++ a/mm/memcontrol.c
@@ -27,6 +27,7 @@
 #include <linux/backing-dev.h>
 #include <linux/bit_spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/limits.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/swap.h>
@@ -721,6 +722,74 @@ static int mem_cgroup_count_children_cb(
 	(*val)++;
 	return 0;
 }
+
+/**
+ * mem_cgroup_print_mem_info: Called from OOM with tasklist_lock held in read mode.
+ * @memcg: The memory cgroup that went over limit
+ * @p: Task that is going to be killed
+ *
+ * NOTE: @memcg and @p's mem_cgroup can be different when hierarchy is
+ * enabled
+ */
+void mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
+{
+	struct cgroup *task_cgrp;
+	struct cgroup *mem_cgrp;
+	/*
+	 * Need a buffer in BSS, can't rely on allocations. The code relies
+	 * on the assumption that OOM is serialized for memory controller.
+	 * If this assumption is broken, revisit this code.
+	 */
+	static char memcg_name[PATH_MAX];
+	int ret;
+
+	if (!memcg)
+		return;
+
+
+	rcu_read_lock();
+
+	mem_cgrp = memcg->css.cgroup;
+	task_cgrp = task_cgroup(p, mem_cgroup_subsys_id);
+
+	ret = cgroup_path(task_cgrp, memcg_name, PATH_MAX);
+	if (ret < 0) {
+		/*
+		 * Unfortunately, we are unable to convert to a useful name
+		 * But we'll still print out the usage information
+		 */
+		rcu_read_unlock();
+		goto done;
+	}
+	rcu_read_unlock();
+
+	printk(KERN_INFO "Task in %s killed", memcg_name);
+
+	rcu_read_lock();
+	ret = cgroup_path(mem_cgrp, memcg_name, PATH_MAX);
+	if (ret < 0) {
+		rcu_read_unlock();
+		goto done;
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Continues from above, so we don't need an KERN_ level
+	 */
+	printk(KERN_CONT " as a result of limit of %s\n", memcg_name);
+done:
+
+	printk(KERN_INFO "memory: usage %llukB, limit %llukB, failcnt %llu\n",
+		res_counter_read_u64(&memcg->res, RES_USAGE) >> 10,
+		res_counter_read_u64(&memcg->res, RES_LIMIT) >> 10,
+		res_counter_read_u64(&memcg->res, RES_FAILCNT));
+	printk(KERN_INFO "memory+swap: usage %llukB, limit %llukB, "
+		"failcnt %llu\n",
+		res_counter_read_u64(&memcg->memsw, RES_USAGE) >> 10,
+		res_counter_read_u64(&memcg->memsw, RES_LIMIT) >> 10,
+		res_counter_read_u64(&memcg->memsw, RES_FAILCNT));
+}
+
 /*
  * This function returns the number of memcg under hierarchy tree. Returns
  * 1(self count) if no children.
diff -puN mm/oom_kill.c~memcg-show-memcg-information-during-oom mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-show-memcg-information-during-oom
+++ a/mm/oom_kill.c
@@ -394,6 +394,7 @@ static int oom_kill_process(struct task_
 		cpuset_print_task_mems_allowed(current);
 		task_unlock(current);
 		dump_stack();
+		mem_cgroup_print_oom_info(mem, current);
 		show_mem();
 		if (sysctl_oom_dump_tasks)
 			dump_tasks(mem);
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
linux-next.patch

