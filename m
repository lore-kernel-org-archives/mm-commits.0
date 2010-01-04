From: akpm@linux-foundation.org
Subject: + memcg-implement-memory-thresholds.patch added to -mm tree
Date: Mon, 04 Jan 2010 13:34:16 -0800
Message-ID: <201001042134.o04LYGkZ019491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045Ab0ADVep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 16:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, vbuzov@embeddedalley.com, virtuoso@slind.org, xemul@openvz.org


The patch titled
     memcg: implement memory thresholds
has been added to the -mm tree.  Its filename is
     memcg-implement-memory-thresholds.patch

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
Subject: memcg: implement memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>

It allows to register multiple memory and memsw thresholds and gets
notifications when it crosses.

To register a threshold application need:
- create an eventfd;
- open memory.usage_in_bytes or memory.memsw.usage_in_bytes;
- write string like "<event_fd> <memory.usage_in_bytes> <threshold>" to
  cgroup.event_control.

Application will be notified through eventfd when memory usage crosses
threshold in any direction.

It's applicable for root and non-root cgroup.

It uses stats to track memory usage, simmilar to soft limits. It checks
if we need to send event to userspace on every 100 page in/out. I guess
it's good compromise between performance and accuracy of thresholds.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Vladislav Buzov <vbuzov@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Alexander Shishkin <virtuoso@slind.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   20 +
 mm/memcontrol.c                  |  312 +++++++++++++++++++++++++++++
 2 files changed, 331 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memcg-implement-memory-thresholds Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-implement-memory-thresholds
+++ a/Documentation/cgroups/memory.txt
@@ -458,7 +458,25 @@ Note: Those pages and swaps must be char
 Note: More type of pages(e.g. file cache, shmem,) will be supported by other
       bits in future.
 
-8.3 TODO
+8.3 Memory thresholds
+
+Memory controler implements memory thresholds using cgroups notification
+API (see cgroups.txt). It allows to register multiple memory and memsw
+thresholds and gets notifications when it crosses.
+
+To register a threshold application need:
+ - create an eventfd using eventfd(2);
+ - open memory.usage_in_bytes or memory.memsw.usage_in_bytes;
+ - write string like "<event_fd> <memory.usage_in_bytes> <threshold>" to
+   cgroup.event_control.
+
+Application will be notified through eventfd when memory usage crosses
+threshold in any direction.
+
+It's applicable for root and non-root cgroup.
+
+
+8.4 TODO
 
 - Add support for other types of pages(e.g. file cache, shmem, etc.).
 - Implement madvise(2) to let users decide the vma to be moved or not to be
diff -puN mm/memcontrol.c~memcg-implement-memory-thresholds mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-implement-memory-thresholds
+++ a/mm/memcontrol.c
@@ -6,6 +6,10 @@
  * Copyright 2007 OpenVZ SWsoft Inc
  * Author: Pavel Emelianov <xemul@openvz.org>
  *
+ * Memory thresholds
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Kirill A. Shutemov
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -41,6 +45,8 @@
 #include <linux/mm_inline.h>
 #include <linux/page_cgroup.h>
 #include <linux/cpu.h>
+#include <linux/eventfd.h>
+#include <linux/sort.h>
 #include "internal.h"
 
 #include <asm/uaccess.h>
@@ -58,6 +64,7 @@ static int really_do_swap_account __init
 #endif
 
 #define SOFTLIMIT_EVENTS_THRESH (1000)
+#define THRESHOLDS_EVENTS_THRESH (100)
 
 /*
  * Statistics for memory cgroup.
@@ -74,6 +81,8 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_SOFTLIMIT, /* decrements on each page in/out.
 					used by soft limit implementation */
+	MEM_CGROUP_STAT_THRESHOLDS, /* decrements on each page in/out.
+					used by threshold implementation */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -177,6 +186,23 @@ struct mem_cgroup_tree {
 
 static struct mem_cgroup_tree soft_limit_tree __read_mostly;
 
+struct mem_cgroup_threshold {
+	struct eventfd_ctx *eventfd;
+	u64 threshold;
+};
+
+struct mem_cgroup_threshold_ary {
+	/* An array index points to threshold just below usage. */
+	atomic_t current_threshold;
+	/* Size of entries[] */
+	unsigned int size;
+	/* Array of thresholds */
+	struct mem_cgroup_threshold entries[0];
+};
+
+static bool mem_cgroup_threshold_check(struct mem_cgroup* mem);
+static void mem_cgroup_threshold(struct mem_cgroup* mem);
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -228,6 +254,15 @@ struct mem_cgroup {
 	/* set when res.limit == memsw.limit */
 	bool		memsw_is_minimum;
 
+	/* protect arrays of thresholds */
+	struct mutex thresholds_lock;
+
+	/* thresholds for memory usage. RCU-protected */
+	struct mem_cgroup_threshold_ary *thresholds;
+
+	/* thresholds for mem+swap usage. RCU-protected */
+	struct mem_cgroup_threshold_ary *memsw_thresholds;
+
 	/*
 	 * Should we move charges of a task when a task is moved into this
 	 * mem_cgroup ? And what type of charges should we move ?
@@ -549,6 +584,8 @@ static void mem_cgroup_charge_statistics
 		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
 	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_THRESHOLDS, -1);
+
 	put_cpu();
 }
 
@@ -1576,6 +1613,8 @@ charged:
 	if (page && mem_cgroup_soft_limit_check(mem))
 		mem_cgroup_update_tree(mem, page);
 done:
+	if (mem_cgroup_threshold_check(mem))
+		mem_cgroup_threshold(mem);
 	return 0;
 nomem:
 	css_put(&mem->css);
@@ -2148,6 +2187,8 @@ __mem_cgroup_uncharge_common(struct page
 
 	if (mem_cgroup_soft_limit_check(mem))
 		mem_cgroup_update_tree(mem, page);
+	if (mem_cgroup_threshold_check(mem))
+		mem_cgroup_threshold(mem);
 	/* at swapout, this memcg will be accessed to record to swap */
 	if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		css_put(&mem->css);
@@ -3227,12 +3268,280 @@ static int mem_cgroup_swappiness_write(s
 	return 0;
 }
 
+static bool mem_cgroup_threshold_check(struct mem_cgroup *mem)
+{
+	bool ret = false;
+	int cpu;
+	s64 val;
+	struct mem_cgroup_stat_cpu *cpustat;
+
+	cpu = get_cpu();
+	cpustat = &mem->stat.cpustat[cpu];
+	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_THRESHOLDS);
+	if (unlikely(val < 0)) {
+		__mem_cgroup_stat_set_safe(cpustat, MEM_CGROUP_STAT_THRESHOLDS,
+				THRESHOLDS_EVENTS_THRESH);
+		ret = true;
+	}
+	put_cpu();
+	return ret;
+}
+
+static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
+{
+	struct mem_cgroup_threshold_ary *t;
+	u64 usage;
+	int i;
+
+	rcu_read_lock();
+	if (!swap) {
+		t = rcu_dereference(memcg->thresholds);
+	} else {
+		t = rcu_dereference(memcg->memsw_thresholds);
+	}
+
+	if (!t)
+		goto unlock;
+
+	usage = mem_cgroup_usage(memcg, swap);
+
+	/*
+	 * current_threshold points to threshold just below usage.
+	 * If it's not true, a threshold was crossed after last
+	 * call of __mem_cgroup_threshold().
+	 */
+	i = atomic_read(&t->current_threshold);
+
+	/*
+	 * Iterate backward over array of thresholds starting from
+	 * current_threshold and check if a threshold is crossed.
+	 * If none of thresholds below usage is crossed, we read
+	 * only one element of the array here.
+	 */
+	for(; i > 0 && unlikely(t->entries[i].threshold > usage); i--) {
+		eventfd_signal(t->entries[i].eventfd, 1);
+	}
+
+	/* i = current_threshold + 1 */
+	i++;
+
+	/*
+	 * Iterate forward over array of thresholds starting from
+	 * current_threshold+1 and check if a threshold is crossed.
+	 * If none of thresholds above usage is crossed, we read
+	 * only one element of the array here.
+	 */
+	for(; i < t->size && unlikely(t->entries[i].threshold <= usage); i++) {
+		eventfd_signal(t->entries[i].eventfd, 1);
+	}
+
+	/* Update current_threshold */
+	atomic_set(&t->current_threshold, i - 1);
+unlock:
+	rcu_read_unlock();
+}
+
+static void mem_cgroup_threshold(struct mem_cgroup *memcg)
+{
+	__mem_cgroup_threshold(memcg, false);
+	if (do_swap_account)
+		__mem_cgroup_threshold(memcg, true);
+}
+
+static int compare_thresholds(const void *a, const void *b)
+{
+	const struct mem_cgroup_threshold *_a = a;
+	const struct mem_cgroup_threshold *_b = b;
+
+	return _a->threshold - _b->threshold;
+}
+
+static int mem_cgroup_register_event(struct cgroup *cgrp, struct cftype *cft,
+		struct eventfd_ctx *eventfd, const char *args)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
+	int type = MEMFILE_TYPE(cft->private);
+	u64 threshold, usage;
+	int size;
+	int i, ret;
+
+	ret = res_counter_memparse_write_strategy(args, &threshold);
+	if (ret)
+		return ret;
+
+	mutex_lock(&memcg->thresholds_lock);
+	if (type == _MEM)
+		thresholds = memcg->thresholds;
+	else if (type == _MEMSWAP)
+		thresholds = memcg->memsw_thresholds;
+	else
+		BUG();
+
+	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
+
+	/* Check if a threshold crossed before adding a new one */
+	if (thresholds)
+		__mem_cgroup_threshold(memcg, type == _MEMSWAP);
+
+	if (thresholds)
+		size = thresholds->size + 1;
+	else
+		size = 1;
+
+	/* Allocate memory for new array of thresholds */
+	thresholds_new = kmalloc(sizeof(*thresholds_new) +
+			size * sizeof(struct mem_cgroup_threshold),
+			GFP_KERNEL);
+	if (!thresholds_new) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	thresholds_new->size = size;
+
+	/* Copy thresholds (if any) to new array */
+	if (thresholds)
+		memcpy(thresholds_new->entries, thresholds->entries,
+				thresholds->size *
+				sizeof(struct mem_cgroup_threshold));
+	/* Add new threshold */
+	thresholds_new->entries[size - 1].eventfd = eventfd;
+	thresholds_new->entries[size - 1].threshold = threshold;
+
+	/* Sort thresholds. Registering of new threshold isn't time-critical */
+	sort(thresholds_new->entries, size,
+			sizeof(struct mem_cgroup_threshold),
+			compare_thresholds, NULL);
+
+	/* Find current threshold */
+	atomic_set(&thresholds_new->current_threshold, -1);
+	for(i = 0; i < size; i++) {
+		if (thresholds_new->entries[i].threshold < usage) {
+			/*
+			 * thresholds_new->current_threshold will not be used
+			 * until rcu_assign_pointer(), so it's safe to increment
+			 * it here.
+			 */
+			atomic_inc(&thresholds_new->current_threshold);
+		}
+	}
+
+	/*
+	 * We need to increment refcnt to be sure that all thresholds
+	 * will be unregistered before calling __mem_cgroup_free()
+	 */
+	mem_cgroup_get(memcg);
+
+	if (type == _MEM)
+		rcu_assign_pointer(memcg->thresholds, thresholds_new);
+	else
+		rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
+
+	/* To be sure that nobody uses thresholds before freeing it */
+	synchronize_rcu();
+
+	kfree(thresholds);
+unlock:
+	mutex_unlock(&memcg->thresholds_lock);
+
+	return ret;
+}
+
+static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
+		struct eventfd_ctx *eventfd)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
+	struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
+	int type = MEMFILE_TYPE(cft->private);
+	u64 usage;
+	int size = 0;
+	int i, j, ret;
+
+	mutex_lock(&memcg->thresholds_lock);
+	if (type == _MEM)
+		thresholds = memcg->thresholds;
+	else if (type == _MEMSWAP)
+		thresholds = memcg->memsw_thresholds;
+	else
+		BUG();
+
+	/*
+	 * Something went wrong if we trying to unregister a threshold
+	 * if we don't have thresholds
+	 */
+	BUG_ON(!thresholds);
+
+	usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
+
+	/* Check if a threshold crossed before removing */
+	__mem_cgroup_threshold(memcg, type == _MEMSWAP);
+
+	/* Calculate new number of threshold */
+	for(i = 0; i < thresholds->size; i++) {
+		if (thresholds->entries[i].eventfd != eventfd)
+			size++;
+	}
+
+	/* Set thresholds array to NULL if we don't have thresholds */
+	if (!size) {
+		thresholds_new = NULL;
+		goto assign;
+	}
+
+	/* Allocate memory for new array of thresholds */
+	thresholds_new = kmalloc(sizeof(*thresholds_new) +
+			size * sizeof(struct mem_cgroup_threshold),
+			GFP_KERNEL);
+	if (!thresholds_new) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+	thresholds_new->size = size;
+
+	/* Copy thresholds and find current threshold */
+	atomic_set(&thresholds_new->current_threshold, -1);
+	for(i = 0, j = 0; i < thresholds->size; i++) {
+		if (thresholds->entries[i].eventfd == eventfd)
+			continue;
+
+		thresholds_new->entries[j] = thresholds->entries[i];
+		if (thresholds_new->entries[j].threshold < usage) {
+			/*
+			 * thresholds_new->current_threshold will not be used
+			 * until rcu_assign_pointer(), so it's safe to increment
+			 * it here.
+			 */
+			atomic_inc(&thresholds_new->current_threshold);
+		}
+		j++;
+	}
+
+assign:
+	if (type == _MEM)
+		rcu_assign_pointer(memcg->thresholds, thresholds_new);
+	else
+		rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
+
+	/* To be sure that nobody uses thresholds before freeing it */
+	synchronize_rcu();
+
+	for(i = 0; i < thresholds->size - size; i++)
+		mem_cgroup_put(memcg);
+
+	kfree(thresholds);
+unlock:
+	mutex_unlock(&memcg->thresholds_lock);
+
+	return ret;
+}
 
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
+		.register_event = mem_cgroup_register_event,
+		.unregister_event = mem_cgroup_unregister_event,
 	},
 	{
 		.name = "max_usage_in_bytes",
@@ -3289,6 +3598,8 @@ static struct cftype memsw_cgroup_files[
 		.name = "memsw.usage_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
 		.read_u64 = mem_cgroup_read,
+		.register_event = mem_cgroup_register_event,
+		.unregister_event = mem_cgroup_unregister_event,
 	},
 	{
 		.name = "memsw.max_usage_in_bytes",
@@ -3533,6 +3844,7 @@ mem_cgroup_create(struct cgroup_subsys *
 		mem->swappiness = get_swappiness(parent);
 	atomic_set(&mem->refcnt, 1);
 	mem->move_charge_at_immigrate = 0;
+	mutex_init(&mem->thresholds_lock);
 	return &mem->css;
 free_out:
 	__mem_cgroup_free(mem);
_

Patches currently in -mm which might be from kirill@shutemov.name are

cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch

