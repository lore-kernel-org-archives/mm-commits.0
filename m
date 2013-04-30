From: akpm@linux-foundation.org
Subject: [merged] memcg-add-memorypressure_level-events.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:49:28 -0700
Message-ID: <20130430184928.BD23331C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:49739 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760848Ab3D3Sta (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:49:30 -0400
Received: by mail-yh0-f73.google.com with SMTP id f35so84846yha.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:49:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, b.zolnierkie@samsung.com, glommer@parallels.com, gthelen@google.com, john.stultz@linaro.org, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, kosaki.motohiro@gmail.com, lcapitulino@redhat.com, leonid.moiseichuk@nokia.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, penberg@kernel.org, rientjes@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: add memory.pressure_level events
has been removed from the -mm tree.  Its filename was
     memcg-add-memorypressure_level-events.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: memcg: add memory.pressure_level events

With this patch userland applications that want to maintain the
interactivity/memory allocation cost can use the pressure level
notifications.  The levels are defined like this:

The "low" level means that the system is reclaiming memory for new
allocations.  Monitoring this reclaiming activity might be useful for
maintaining cache level.  Upon notification, the program (typically
"Activity Manager") might analyze vmstat and act in advance (i.e. 
prematurely shutdown unimportant services).

The "medium" level means that the system is experiencing medium memory
pressure, the system might be making swap, paging out active file caches,
etc.  Upon this event applications may decide to further analyze
vmstat/zoneinfo/memcg or internal memory usage statistics and free any
resources that can be easily reconstructed or re-read from a disk.

The "critical" level means that the system is actively thrashing, it is
about to out of memory (OOM) or even the in-kernel OOM killer is on its
way to trigger.  Applications should do whatever they can to help the
system.  It might be too late to consult with vmstat or any other
statistics, so it's advisable to take an immediate action.

The events are propagated upward until the event is handled, i.e.  the
events are not pass-through.  Here is what this means: for example you
have three cgroups: A->B->C.  Now you set up an event listener on cgroups
A, B and C, and suppose group C experiences some pressure.  In this
situation, only group C will receive the notification, i.e.  groups A and
B will not receive it.  This is done to avoid excessive "broadcasting" of
messages, which disturbs the system and which is especially bad if we are
low on memory or thrashing.  So, organize the cgroups wisely, or propagate
the events manually (or, ask us to implement the pass-through events,
explaining why would you need them.)

Performance wise, the memory pressure notifications feature itself is
lightweight and does not require much of bookkeeping, in contrast to the
rest of memcg features.  Unfortunately, as of current memcg
implementation, pages accounting is an inseparable part and cannot be
turned off.  The good news is that there are some efforts[1] to improve
the situation; plus, implementing the same, fully API-compatible[2]
interface for CONFIG_MEMCG=n case (e.g.  embedded) is also a viable
option, so it will not require any changes on the userland side.

[1] http://permalink.gmane.org/gmane.linux.kernel.cgroups/6291
[2] http://lkml.org/lkml/2013/2/21/454

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix CONFIG_CGROPUPS=n warnings]
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   70 +++++
 include/linux/vmpressure.h       |   47 +++
 mm/Makefile                      |    2 
 mm/memcontrol.c                  |   29 ++
 mm/vmpressure.c                  |  374 +++++++++++++++++++++++++++++
 mm/vmscan.c                      |    8 
 6 files changed, 528 insertions(+), 2 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-add-memorypressure_level-events Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-add-memorypressure_level-events
+++ a/Documentation/cgroups/memory.txt
@@ -40,6 +40,7 @@ Features:
  - soft limit
  - moving (recharging) account at moving a task is selectable.
  - usage threshold notifier
+ - memory pressure notifier
  - oom-killer disable knob and oom-notifier
  - Root cgroup has no limit controls.
 
@@ -65,6 +66,7 @@ Brief summary of control files.
  memory.stat			 # show various statistics
  memory.use_hierarchy		 # set/show hierarchical account enabled
  memory.force_empty		 # trigger forced move charge to parent
+ memory.pressure_level		 # set memory pressure notifications
  memory.swappiness		 # set/show swappiness parameter of vmscan
 				 (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate # set/show controls of moving charges
@@ -762,7 +764,73 @@ At reading, current status of OOM is sho
 	under_oom	 0 or 1 (if 1, the memory cgroup is under OOM, tasks may
 				 be stopped.)
 
-11. TODO
+11. Memory Pressure
+
+The pressure level notifications can be used to monitor the memory
+allocation cost; based on the pressure, applications can implement
+different strategies of managing their memory resources. The pressure
+levels are defined as following:
+
+The "low" level means that the system is reclaiming memory for new
+allocations. Monitoring this reclaiming activity might be useful for
+maintaining cache level. Upon notification, the program (typically
+"Activity Manager") might analyze vmstat and act in advance (i.e.
+prematurely shutdown unimportant services).
+
+The "medium" level means that the system is experiencing medium memory
+pressure, the system might be making swap, paging out active file caches,
+etc. Upon this event applications may decide to further analyze
+vmstat/zoneinfo/memcg or internal memory usage statistics and free any
+resources that can be easily reconstructed or re-read from a disk.
+
+The "critical" level means that the system is actively thrashing, it is
+about to out of memory (OOM) or even the in-kernel OOM killer is on its
+way to trigger. Applications should do whatever they can to help the
+system. It might be too late to consult with vmstat or any other
+statistics, so it's advisable to take an immediate action.
+
+The events are propagated upward until the event is handled, i.e. the
+events are not pass-through. Here is what this means: for example you have
+three cgroups: A->B->C. Now you set up an event listener on cgroups A, B
+and C, and suppose group C experiences some pressure. In this situation,
+only group C will receive the notification, i.e. groups A and B will not
+receive it. This is done to avoid excessive "broadcasting" of messages,
+which disturbs the system and which is especially bad if we are low on
+memory or thrashing. So, organize the cgroups wisely, or propagate the
+events manually (or, ask us to implement the pass-through events,
+explaining why would you need them.)
+
+The file memory.pressure_level is only used to setup an eventfd. To
+register a notification, an application must:
+
+- create an eventfd using eventfd(2);
+- open memory.pressure_level;
+- write string like "<event_fd> <fd of memory.pressure_level> <level>"
+  to cgroup.event_control.
+
+Application will be notified through eventfd when memory pressure is at
+the specific level (or higher). Read/write operations to
+memory.pressure_level are no implemented.
+
+Test:
+
+   Here is a small script example that makes a new cgroup, sets up a
+   memory limit, sets up a notification in the cgroup and then makes child
+   cgroup experience a critical pressure:
+
+   # cd /sys/fs/cgroup/memory/
+   # mkdir foo
+   # cd foo
+   # cgroup_event_listener memory.pressure_level low &
+   # echo 8000000 > memory.limit_in_bytes
+   # echo 8000000 > memory.memsw.limit_in_bytes
+   # echo $$ > tasks
+   # dd if=/dev/zero | read x
+
+   (Expect a bunch of notifications, and eventually, the oom-killer will
+   trigger.)
+
+12. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
diff -puN /dev/null include/linux/vmpressure.h
--- /dev/null
+++ a/include/linux/vmpressure.h
@@ -0,0 +1,47 @@
+#ifndef __LINUX_VMPRESSURE_H
+#define __LINUX_VMPRESSURE_H
+
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/workqueue.h>
+#include <linux/gfp.h>
+#include <linux/types.h>
+#include <linux/cgroup.h>
+
+struct vmpressure {
+	unsigned long scanned;
+	unsigned long reclaimed;
+	/* The lock is used to keep the scanned/reclaimed above in sync. */
+	struct mutex sr_lock;
+
+	/* The list of vmpressure_event structs. */
+	struct list_head events;
+	/* Have to grab the lock on events traversal or modifications. */
+	struct mutex events_lock;
+
+	struct work_struct work;
+};
+
+struct mem_cgroup;
+
+#ifdef CONFIG_MEMCG
+extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
+		       unsigned long scanned, unsigned long reclaimed);
+extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
+
+extern void vmpressure_init(struct vmpressure *vmpr);
+extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
+extern struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr);
+extern struct vmpressure *css_to_vmpressure(struct cgroup_subsys_state *css);
+extern int vmpressure_register_event(struct cgroup *cg, struct cftype *cft,
+				     struct eventfd_ctx *eventfd,
+				     const char *args);
+extern void vmpressure_unregister_event(struct cgroup *cg, struct cftype *cft,
+					struct eventfd_ctx *eventfd);
+#else
+static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
+			      unsigned long scanned, unsigned long reclaimed) {}
+static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
+				   int prio) {}
+#endif /* CONFIG_MEMCG */
+#endif /* __LINUX_VMPRESSURE_H */
diff -puN mm/Makefile~memcg-add-memorypressure_level-events mm/Makefile
--- a/mm/Makefile~memcg-add-memorypressure_level-events
+++ a/mm/Makefile
@@ -50,7 +50,7 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o
-obj-$(CONFIG_MEMCG) += memcontrol.o page_cgroup.o
+obj-$(CONFIG_MEMCG) += memcontrol.o page_cgroup.o vmpressure.o
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
diff -puN mm/memcontrol.c~memcg-add-memorypressure_level-events mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memorypressure_level-events
+++ a/mm/memcontrol.c
@@ -49,6 +49,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <linux/vmpressure.h>
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
@@ -261,6 +262,9 @@ struct mem_cgroup {
 	 */
 	struct res_counter res;
 
+	/* vmpressure notifications */
+	struct vmpressure vmpressure;
+
 	union {
 		/*
 		 * the counter to account for mem+swap usage.
@@ -359,6 +363,7 @@ struct mem_cgroup {
 	atomic_t	numainfo_events;
 	atomic_t	numainfo_updating;
 #endif
+
 	/*
 	 * Per cgroup active and inactive list, similar to the
 	 * per zone LRU lists.
@@ -510,6 +515,24 @@ struct mem_cgroup *mem_cgroup_from_css(s
 	return container_of(s, struct mem_cgroup, css);
 }
 
+/* Some nice accessors for the vmpressure. */
+struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
+{
+	if (!memcg)
+		memcg = root_mem_cgroup;
+	return &memcg->vmpressure;
+}
+
+struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr)
+{
+	return &container_of(vmpr, struct mem_cgroup, vmpressure)->css;
+}
+
+struct vmpressure *css_to_vmpressure(struct cgroup_subsys_state *css)
+{
+	return &mem_cgroup_from_css(css)->vmpressure;
+}
+
 static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
 {
 	return (memcg == root_mem_cgroup);
@@ -5907,6 +5930,11 @@ static struct cftype mem_cgroup_files[]
 		.unregister_event = mem_cgroup_oom_unregister_event,
 		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
 	},
+	{
+		.name = "pressure_level",
+		.register_event = vmpressure_register_event,
+		.unregister_event = vmpressure_unregister_event,
+	},
 #ifdef CONFIG_NUMA
 	{
 		.name = "numa_stat",
@@ -6188,6 +6216,7 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	memcg->move_charge_at_immigrate = 0;
 	mutex_init(&memcg->thresholds_lock);
 	spin_lock_init(&memcg->move_lock);
+	vmpressure_init(&memcg->vmpressure);
 
 	return &memcg->css;
 
diff -puN /dev/null mm/vmpressure.c
--- /dev/null
+++ a/mm/vmpressure.c
@@ -0,0 +1,374 @@
+/*
+ * Linux VM pressure
+ *
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * Based on ideas from Andrew Morton, David Rientjes, KOSAKI Motohiro,
+ * Leonid Moiseichuk, Mel Gorman, Minchan Kim and Pekka Enberg.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/cgroup.h>
+#include <linux/fs.h>
+#include <linux/log2.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
+#include <linux/eventfd.h>
+#include <linux/swap.h>
+#include <linux/printk.h>
+#include <linux/vmpressure.h>
+
+/*
+ * The window size (vmpressure_win) is the number of scanned pages before
+ * we try to analyze scanned/reclaimed ratio. So the window is used as a
+ * rate-limit tunable for the "low" level notification, and also for
+ * averaging the ratio for medium/critical levels. Using small window
+ * sizes can cause lot of false positives, but too big window size will
+ * delay the notifications.
+ *
+ * As the vmscan reclaimer logic works with chunks which are multiple of
+ * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
+ *
+ * TODO: Make the window size depend on machine size, as we do for vmstat
+ * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ */
+static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+
+/*
+ * These thresholds are used when we account memory pressure through
+ * scanned/reclaimed ratio. The current values were chosen empirically. In
+ * essence, they are percents: the higher the value, the more number
+ * unsuccessful reclaims there were.
+ */
+static const unsigned int vmpressure_level_med = 60;
+static const unsigned int vmpressure_level_critical = 95;
+
+/*
+ * When there are too little pages left to scan, vmpressure() may miss the
+ * critical pressure as number of pages will be less than "window size".
+ * However, in that case the vmscan priority will raise fast as the
+ * reclaimer will try to scan LRUs more deeply.
+ *
+ * The vmscan logic considers these special priorities:
+ *
+ * prio == DEF_PRIORITY (12): reclaimer starts with that value
+ * prio <= DEF_PRIORITY - 2 : kswapd becomes somewhat overwhelmed
+ * prio == 0                : close to OOM, kernel scans every page in an lru
+ *
+ * Any value in this range is acceptable for this tunable (i.e. from 12 to
+ * 0). Current value for the vmpressure_level_critical_prio is chosen
+ * empirically, but the number, in essence, means that we consider
+ * critical level when scanning depth is ~10% of the lru size (vmscan
+ * scans 'lru_size >> prio' pages, so it is actually 12.5%, or one
+ * eights).
+ */
+static const unsigned int vmpressure_level_critical_prio = ilog2(100 / 10);
+
+static struct vmpressure *work_to_vmpressure(struct work_struct *work)
+{
+	return container_of(work, struct vmpressure, work);
+}
+
+static struct vmpressure *cg_to_vmpressure(struct cgroup *cg)
+{
+	return css_to_vmpressure(cgroup_subsys_state(cg, mem_cgroup_subsys_id));
+}
+
+static struct vmpressure *vmpressure_parent(struct vmpressure *vmpr)
+{
+	struct cgroup *cg = vmpressure_to_css(vmpr)->cgroup;
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cg);
+
+	memcg = parent_mem_cgroup(memcg);
+	if (!memcg)
+		return NULL;
+	return memcg_to_vmpressure(memcg);
+}
+
+enum vmpressure_levels {
+	VMPRESSURE_LOW = 0,
+	VMPRESSURE_MEDIUM,
+	VMPRESSURE_CRITICAL,
+	VMPRESSURE_NUM_LEVELS,
+};
+
+static const char * const vmpressure_str_levels[] = {
+	[VMPRESSURE_LOW] = "low",
+	[VMPRESSURE_MEDIUM] = "medium",
+	[VMPRESSURE_CRITICAL] = "critical",
+};
+
+static enum vmpressure_levels vmpressure_level(unsigned long pressure)
+{
+	if (pressure >= vmpressure_level_critical)
+		return VMPRESSURE_CRITICAL;
+	else if (pressure >= vmpressure_level_med)
+		return VMPRESSURE_MEDIUM;
+	return VMPRESSURE_LOW;
+}
+
+static enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
+						    unsigned long reclaimed)
+{
+	unsigned long scale = scanned + reclaimed;
+	unsigned long pressure;
+
+	/*
+	 * We calculate the ratio (in percents) of how many pages were
+	 * scanned vs. reclaimed in a given time frame (window). Note that
+	 * time is in VM reclaimer's "ticks", i.e. number of pages
+	 * scanned. This makes it possible to set desired reaction time
+	 * and serves as a ratelimit.
+	 */
+	pressure = scale - (reclaimed * scale / scanned);
+	pressure = pressure * 100 / scale;
+
+	pr_debug("%s: %3lu  (s: %lu  r: %lu)\n", __func__, pressure,
+		 scanned, reclaimed);
+
+	return vmpressure_level(pressure);
+}
+
+struct vmpressure_event {
+	struct eventfd_ctx *efd;
+	enum vmpressure_levels level;
+	struct list_head node;
+};
+
+static bool vmpressure_event(struct vmpressure *vmpr,
+			     unsigned long scanned, unsigned long reclaimed)
+{
+	struct vmpressure_event *ev;
+	enum vmpressure_levels level;
+	bool signalled = false;
+
+	level = vmpressure_calc_level(scanned, reclaimed);
+
+	mutex_lock(&vmpr->events_lock);
+
+	list_for_each_entry(ev, &vmpr->events, node) {
+		if (level >= ev->level) {
+			eventfd_signal(ev->efd, 1);
+			signalled = true;
+		}
+	}
+
+	mutex_unlock(&vmpr->events_lock);
+
+	return signalled;
+}
+
+static void vmpressure_work_fn(struct work_struct *work)
+{
+	struct vmpressure *vmpr = work_to_vmpressure(work);
+	unsigned long scanned;
+	unsigned long reclaimed;
+
+	/*
+	 * Several contexts might be calling vmpressure(), so it is
+	 * possible that the work was rescheduled again before the old
+	 * work context cleared the counters. In that case we will run
+	 * just after the old work returns, but then scanned might be zero
+	 * here. No need for any locks here since we don't care if
+	 * vmpr->reclaimed is in sync.
+	 */
+	if (!vmpr->scanned)
+		return;
+
+	mutex_lock(&vmpr->sr_lock);
+	scanned = vmpr->scanned;
+	reclaimed = vmpr->reclaimed;
+	vmpr->scanned = 0;
+	vmpr->reclaimed = 0;
+	mutex_unlock(&vmpr->sr_lock);
+
+	do {
+		if (vmpressure_event(vmpr, scanned, reclaimed))
+			break;
+		/*
+		 * If not handled, propagate the event upward into the
+		 * hierarchy.
+		 */
+	} while ((vmpr = vmpressure_parent(vmpr)));
+}
+
+/**
+ * vmpressure() - Account memory pressure through scanned/reclaimed ratio
+ * @gfp:	reclaimer's gfp mask
+ * @memcg:	cgroup memory controller handle
+ * @scanned:	number of pages scanned
+ * @reclaimed:	number of pages reclaimed
+ *
+ * This function should be called from the vmscan reclaim path to account
+ * "instantaneous" memory pressure (scanned/reclaimed ratio). The raw
+ * pressure index is then further refined and averaged over time.
+ *
+ * This function does not return any value.
+ */
+void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,
+		unsigned long scanned, unsigned long reclaimed)
+{
+	struct vmpressure *vmpr = memcg_to_vmpressure(memcg);
+
+	/*
+	 * Here we only want to account pressure that userland is able to
+	 * help us with. For example, suppose that DMA zone is under
+	 * pressure; if we notify userland about that kind of pressure,
+	 * then it will be mostly a waste as it will trigger unnecessary
+	 * freeing of memory by userland (since userland is more likely to
+	 * have HIGHMEM/MOVABLE pages instead of the DMA fallback). That
+	 * is why we include only movable, highmem and FS/IO pages.
+	 * Indirect reclaim (kswapd) sets sc->gfp_mask to GFP_KERNEL, so
+	 * we account it too.
+	 */
+	if (!(gfp & (__GFP_HIGHMEM | __GFP_MOVABLE | __GFP_IO | __GFP_FS)))
+		return;
+
+	/*
+	 * If we got here with no pages scanned, then that is an indicator
+	 * that reclaimer was unable to find any shrinkable LRUs at the
+	 * current scanning depth. But it does not mean that we should
+	 * report the critical pressure, yet. If the scanning priority
+	 * (scanning depth) goes too high (deep), we will be notified
+	 * through vmpressure_prio(). But so far, keep calm.
+	 */
+	if (!scanned)
+		return;
+
+	mutex_lock(&vmpr->sr_lock);
+	vmpr->scanned += scanned;
+	vmpr->reclaimed += reclaimed;
+	scanned = vmpr->scanned;
+	mutex_unlock(&vmpr->sr_lock);
+
+	if (scanned < vmpressure_win || work_pending(&vmpr->work))
+		return;
+	schedule_work(&vmpr->work);
+}
+
+/**
+ * vmpressure_prio() - Account memory pressure through reclaimer priority level
+ * @gfp:	reclaimer's gfp mask
+ * @memcg:	cgroup memory controller handle
+ * @prio:	reclaimer's priority
+ *
+ * This function should be called from the reclaim path every time when
+ * the vmscan's reclaiming priority (scanning depth) changes.
+ *
+ * This function does not return any value.
+ */
+void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
+{
+	/*
+	 * We only use prio for accounting critical level. For more info
+	 * see comment for vmpressure_level_critical_prio variable above.
+	 */
+	if (prio > vmpressure_level_critical_prio)
+		return;
+
+	/*
+	 * OK, the prio is below the threshold, updating vmpressure
+	 * information before shrinker dives into long shrinking of long
+	 * range vmscan. Passing scanned = vmpressure_win, reclaimed = 0
+	 * to the vmpressure() basically means that we signal 'critical'
+	 * level.
+	 */
+	vmpressure(gfp, memcg, vmpressure_win, 0);
+}
+
+/**
+ * vmpressure_register_event() - Bind vmpressure notifications to an eventfd
+ * @cg:		cgroup that is interested in vmpressure notifications
+ * @cft:	cgroup control files handle
+ * @eventfd:	eventfd context to link notifications with
+ * @args:	event arguments (used to set up a pressure level threshold)
+ *
+ * This function associates eventfd context with the vmpressure
+ * infrastructure, so that the notifications will be delivered to the
+ * @eventfd. The @args parameter is a string that denotes pressure level
+ * threshold (one of vmpressure_str_levels, i.e. "low", "medium", or
+ * "critical").
+ *
+ * This function should not be used directly, just pass it to (struct
+ * cftype).register_event, and then cgroup core will handle everything by
+ * itself.
+ */
+int vmpressure_register_event(struct cgroup *cg, struct cftype *cft,
+			      struct eventfd_ctx *eventfd, const char *args)
+{
+	struct vmpressure *vmpr = cg_to_vmpressure(cg);
+	struct vmpressure_event *ev;
+	int level;
+
+	for (level = 0; level < VMPRESSURE_NUM_LEVELS; level++) {
+		if (!strcmp(vmpressure_str_levels[level], args))
+			break;
+	}
+
+	if (level >= VMPRESSURE_NUM_LEVELS)
+		return -EINVAL;
+
+	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->efd = eventfd;
+	ev->level = level;
+
+	mutex_lock(&vmpr->events_lock);
+	list_add(&ev->node, &vmpr->events);
+	mutex_unlock(&vmpr->events_lock);
+
+	return 0;
+}
+
+/**
+ * vmpressure_unregister_event() - Unbind eventfd from vmpressure
+ * @cg:		cgroup handle
+ * @cft:	cgroup control files handle
+ * @eventfd:	eventfd context that was used to link vmpressure with the @cg
+ *
+ * This function does internal manipulations to detach the @eventfd from
+ * the vmpressure notifications, and then frees internal resources
+ * associated with the @eventfd (but the @eventfd itself is not freed).
+ *
+ * This function should not be used directly, just pass it to (struct
+ * cftype).unregister_event, and then cgroup core will handle everything
+ * by itself.
+ */
+void vmpressure_unregister_event(struct cgroup *cg, struct cftype *cft,
+				 struct eventfd_ctx *eventfd)
+{
+	struct vmpressure *vmpr = cg_to_vmpressure(cg);
+	struct vmpressure_event *ev;
+
+	mutex_lock(&vmpr->events_lock);
+	list_for_each_entry(ev, &vmpr->events, node) {
+		if (ev->efd != eventfd)
+			continue;
+		list_del(&ev->node);
+		kfree(ev);
+		break;
+	}
+	mutex_unlock(&vmpr->events_lock);
+}
+
+/**
+ * vmpressure_init() - Initialize vmpressure control structure
+ * @vmpr:	Structure to be initialized
+ *
+ * This function should be called on every allocated vmpressure structure
+ * before any usage.
+ */
+void vmpressure_init(struct vmpressure *vmpr)
+{
+	mutex_init(&vmpr->sr_lock);
+	mutex_init(&vmpr->events_lock);
+	INIT_LIST_HEAD(&vmpr->events);
+	INIT_WORK(&vmpr->work, vmpressure_work_fn);
+}
diff -puN mm/vmscan.c~memcg-add-memorypressure_level-events mm/vmscan.c
--- a/mm/vmscan.c~memcg-add-memorypressure_level-events
+++ a/mm/vmscan.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
+#include <linux/vmpressure.h>
 #include <linux/vmstat.h>
 #include <linux/file.h>
 #include <linux/writeback.h>
@@ -1982,6 +1983,11 @@ static void shrink_zone(struct zone *zon
 			}
 			memcg = mem_cgroup_iter(root, memcg, &reclaim);
 		} while (memcg);
+
+		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
+			   sc->nr_scanned - nr_scanned,
+			   sc->nr_reclaimed - nr_reclaimed);
+
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
 }
@@ -2167,6 +2173,8 @@ static unsigned long do_try_to_free_page
 		count_vm_event(ALLOCSTALL);
 
 	do {
+		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
+				sc->priority);
 		sc->nr_scanned = 0;
 		aborted_reclaim = shrink_zones(zonelist, sc);
 
_

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch

