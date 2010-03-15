From: akpm@linux-foundation.org
Subject: + memcg-oom-kill-disable-and-oom-status.patch added to -mm tree
Date: Mon, 15 Mar 2010 15:00:38 -0700
Message-ID: <201003152200.o2FM0cXx025115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936880Ab0COWBM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 18:01:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com


The patch titled
     memcg: oom kill disable and oom status
has been added to the -mm tree.  Its filename is
     memcg-oom-kill-disable-and-oom-status.patch

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
Subject: memcg: oom kill disable and oom status
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This adds a feature to disable oom-killer for memcg, if disabled, of
course, tasks under memcg will stop.

But now, we have oom-notifier for memcg.  And the world around memcg is
not under out-of-memory.  memcg's out-of-memory just shows memcg hits
limit.  Then, administrator or management daemon can recover the situation
by

	- kill some process
	- enlarge limit, add more swap.
	- migrate some tasks
	- remove file cache on tmps (difficult ?)

Unlike OOM-Kill by the kernel, the users can take snapshot or coredump of
guilty process, cgroups.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   19 ++++
 mm/memcontrol.c                  |  113 ++++++++++++++++++++++++-----
 2 files changed, 113 insertions(+), 19 deletions(-)

diff -puN Documentation/cgroups/memory.txt~memcg-oom-kill-disable-and-oom-status Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-oom-kill-disable-and-oom-status
+++ a/Documentation/cgroups/memory.txt
@@ -493,6 +493,8 @@ It's applicable for root and non-root cg
 
 10. OOM Control
 
+memory.oom_control file is for OOM notification and other controls.
+
 Memory controler implements oom notifier using cgroup notification
 API (See cgroups.txt). It allows to register multiple oom notification
 delivery and gets notification when oom happens.
@@ -505,6 +507,23 @@ To register a notifier, application need
 Application will be notifier through eventfd when oom happens.
 OOM notification doesn't work for root cgroup.
 
+You can disable oom-killer by writing "1" to memory.oom_control file.
+As.
+	#echo 1 > memory.oom_control
+
+This operation is only allowed to the top cgroup of subhierarchy.
+If oom-killer is disabled, tasks under cgroup will hang/sleep
+in memcg's oom-waitq when they request accountable memory.
+For running them, you have to relax the memcg's oom sitaution by
+	* enlarge limit
+	* kill some tasks.
+	* move some tasks to other group with account migration.
+Then, stopped tasks will work again.
+
+At reading, current status of OOM is shown.
+	oom_kill_disable 0 or 1 (if 1, oom-killer is disabled)
+	under_oom	 0 or 1 (if 1, the memcg is under OOM,tasks may
+				 be stopped.)
 
 11. TODO
 
diff -puN mm/memcontrol.c~memcg-oom-kill-disable-and-oom-status mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-oom-kill-disable-and-oom-status
+++ a/mm/memcontrol.c
@@ -235,7 +235,8 @@ struct mem_cgroup {
 	 * mem_cgroup ? And what type of charges should we move ?
 	 */
 	unsigned long 	move_charge_at_immigrate;
-
+	/* Disable OOM killer */
+	unsigned long	oom_kill_disable;
 	/*
 	 * percpu counter.
 	 */
@@ -1340,20 +1341,26 @@ static void memcg_wakeup_oom(struct mem_
 	__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, mem);
 }
 
+static void memcg_oom_recover(struct mem_cgroup *mem)
+{
+	if (mem->oom_kill_disable && atomic_read(&mem->oom_lock))
+		memcg_wakeup_oom(mem);
+}
+
 /*
  * try to call OOM killer. returns false if we should exit memory-reclaim loop.
  */
 bool mem_cgroup_handle_oom(struct mem_cgroup *mem, gfp_t mask)
 {
 	struct oom_wait_info owait;
-	bool locked;
+	bool locked, need_to_kill;
 
 	owait.mem = mem;
 	owait.wait.flags = 0;
 	owait.wait.func = memcg_oom_wake_function;
 	owait.wait.private = current;
 	INIT_LIST_HEAD(&owait.wait.task_list);
-
+	need_to_kill = true;
 	/* At first, try to OOM lock hierarchy under mem.*/
 	mutex_lock(&memcg_oom_mutex);
 	locked = mem_cgroup_oom_lock(mem);
@@ -1362,15 +1369,17 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	 * accounting. So, UNINTERRUPTIBLE is appropriate. But SIGKILL
 	 * under OOM is always welcomed, use TASK_KILLABLE here.
 	 */
-	if (!locked)
-		prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
-	else
+	prepare_to_wait(&memcg_oom_waitq, &owait.wait, TASK_KILLABLE);
+	if (!locked || mem->oom_kill_disable)
+		need_to_kill = false;
+	if (locked)
 		mem_cgroup_oom_notify(mem);
 	mutex_unlock(&memcg_oom_mutex);
 
-	if (locked)
+	if (need_to_kill) {
+		finish_wait(&memcg_oom_waitq, &owait.wait);
 		mem_cgroup_out_of_memory(mem, mask);
-	else {
+	} else {
 		schedule();
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
@@ -2162,15 +2171,6 @@ __do_uncharge(struct mem_cgroup *mem, co
 	/* If swapout, usage of swap doesn't decrease */
 	if (!do_swap_account || ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
 		uncharge_memsw = false;
-	/*
-	 * do_batch > 0 when unmapping pages or inode invalidate/truncate.
-	 * In those cases, all pages freed continously can be expected to be in
-	 * the same cgroup and we have chance to coalesce uncharges.
-	 * But we do uncharge one by one if this is killed by OOM(TIF_MEMDIE)
-	 * because we want to do uncharge as soon as possible.
-	 */
-	if (!current->memcg_batch.do_batch || test_thread_flag(TIF_MEMDIE))
-		goto direct_uncharge;
 
 	batch = &current->memcg_batch;
 	/*
@@ -2181,6 +2181,17 @@ __do_uncharge(struct mem_cgroup *mem, co
 	if (!batch->memcg)
 		batch->memcg = mem;
 	/*
+	 * do_batch > 0 when unmapping pages or inode invalidate/truncate.
+	 * In those cases, all pages freed continously can be expected to be in
+	 * the same cgroup and we have chance to coalesce uncharges.
+	 * But we do uncharge one by one if this is killed by OOM(TIF_MEMDIE)
+	 * because we want to do uncharge as soon as possible.
+	 */
+
+	if (!batch->do_batch || test_thread_flag(TIF_MEMDIE))
+		goto direct_uncharge;
+
+	/*
 	 * In typical case, batch->memcg == mem. This means we can
 	 * merge a series of uncharges to an uncharge of res_counter.
 	 * If not, we uncharge res_counter ony by one.
@@ -2196,6 +2207,8 @@ direct_uncharge:
 	res_counter_uncharge(&mem->res, PAGE_SIZE);
 	if (uncharge_memsw)
 		res_counter_uncharge(&mem->memsw, PAGE_SIZE);
+	if (unlikely(batch->memcg != mem))
+		memcg_oom_recover(mem);
 	return;
 }
 
@@ -2332,6 +2345,7 @@ void mem_cgroup_uncharge_end(void)
 		res_counter_uncharge(&batch->memcg->res, batch->bytes);
 	if (batch->memsw_bytes)
 		res_counter_uncharge(&batch->memcg->memsw, batch->memsw_bytes);
+	memcg_oom_recover(batch->memcg);
 	/* forget this pointer (for sanity check) */
 	batch->memcg = NULL;
 }
@@ -2568,10 +2582,11 @@ static int mem_cgroup_resize_limit(struc
 				unsigned long long val)
 {
 	int retry_count;
-	u64 memswlimit;
+	u64 memswlimit, memlimit;
 	int ret = 0;
 	int children = mem_cgroup_count_children(memcg);
 	u64 curusage, oldusage;
+	int enlarge;
 
 	/*
 	 * For keeping hierarchical_reclaim simple, how long we should retry
@@ -2582,6 +2597,7 @@ static int mem_cgroup_resize_limit(struc
 
 	oldusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 
+	enlarge = 0;
 	while (retry_count) {
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -2599,6 +2615,11 @@ static int mem_cgroup_resize_limit(struc
 			mutex_unlock(&set_limit_mutex);
 			break;
 		}
+
+		memlimit = res_counter_read_u64(&memcg->res, RES_LIMIT);
+		if (memlimit < val)
+			enlarge = 1;
+
 		ret = res_counter_set_limit(&memcg->res, val);
 		if (!ret) {
 			if (memswlimit == val)
@@ -2620,6 +2641,8 @@ static int mem_cgroup_resize_limit(struc
 		else
 			oldusage = curusage;
 	}
+	if (!ret && enlarge)
+		memcg_oom_recover(memcg);
 
 	return ret;
 }
@@ -2628,9 +2651,10 @@ static int mem_cgroup_resize_memsw_limit
 					unsigned long long val)
 {
 	int retry_count;
-	u64 memlimit, oldusage, curusage;
+	u64 memlimit, memswlimit, oldusage, curusage;
 	int children = mem_cgroup_count_children(memcg);
 	int ret = -EBUSY;
+	int enlarge = 0;
 
 	/* see mem_cgroup_resize_res_limit */
  	retry_count = children * MEM_CGROUP_RECLAIM_RETRIES;
@@ -2652,6 +2676,9 @@ static int mem_cgroup_resize_memsw_limit
 			mutex_unlock(&set_limit_mutex);
 			break;
 		}
+		memswlimit = res_counter_read_u64(&memcg->memsw, RES_LIMIT);
+		if (memswlimit < val)
+			enlarge = 1;
 		ret = res_counter_set_limit(&memcg->memsw, val);
 		if (!ret) {
 			if (memlimit == val)
@@ -2674,6 +2701,8 @@ static int mem_cgroup_resize_memsw_limit
 		else
 			oldusage = curusage;
 	}
+	if (!ret && enlarge)
+		memcg_oom_recover(memcg);
 	return ret;
 }
 
@@ -2865,6 +2894,7 @@ move_account:
 			if (ret)
 				break;
 		}
+		memcg_oom_recover(mem);
 		/* it seems parent cgroup doesn't have enough mem */
 		if (ret == -ENOMEM)
 			goto try_to_free;
@@ -3645,6 +3675,46 @@ static int mem_cgroup_oom_unregister_eve
 	return 0;
 }
 
+static int mem_cgroup_oom_control_read(struct cgroup *cgrp,
+	struct cftype *cft,  struct cgroup_map_cb *cb)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
+
+	cb->fill(cb, "oom_kill_disable", mem->oom_kill_disable);
+
+	if (atomic_read(&mem->oom_lock))
+		cb->fill(cb, "under_oom", 1);
+	else
+		cb->fill(cb, "under_oom", 0);
+	return 0;
+}
+
+/*
+ */
+static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
+	struct cftype *cft, u64 val)
+{
+	struct mem_cgroup *mem = mem_cgroup_from_cont(cgrp);
+	struct mem_cgroup *parent;
+
+	/* cannot set to root cgroup and only 0 and 1 are allowed */
+	if (!cgrp->parent || !((val == 0) || (val == 1)))
+		return -EINVAL;
+
+	parent = mem_cgroup_from_cont(cgrp->parent);
+
+	cgroup_lock();
+	/* oom-kill-disable is a flag for subhierarchy. */
+	if ((parent->use_hierarchy) ||
+	    (mem->use_hierarchy && !list_empty(&cgrp->children))) {
+		cgroup_unlock();
+		return -EINVAL;
+	}
+	mem->oom_kill_disable = val;
+	cgroup_unlock();
+	return 0;
+}
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -3702,6 +3772,8 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "oom_control",
+		.read_map = mem_cgroup_oom_control_read,
+		.write_u64 = mem_cgroup_oom_control_write,
 		.register_event = mem_cgroup_oom_register_event,
 		.unregister_event = mem_cgroup_oom_unregister_event,
 		.private = MEMFILE_PRIVATE(_OOM_TYPE, OOM_CONTROL),
@@ -3943,6 +4015,7 @@ mem_cgroup_create(struct cgroup_subsys *
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
+		mem->oom_kill_disable = parent->oom_kill_disable;
 	}
 
 	if (parent && parent->use_hierarchy) {
@@ -4215,6 +4288,7 @@ static void mem_cgroup_clear_mc(void)
 	if (mc.precharge) {
 		__mem_cgroup_cancel_charge(mc.to, mc.precharge);
 		mc.precharge = 0;
+		memcg_oom_recover(mc.to);
 	}
 	/*
 	 * we didn't uncharge from mc.from at mem_cgroup_move_account(), so
@@ -4223,6 +4297,7 @@ static void mem_cgroup_clear_mc(void)
 	if (mc.moved_charge) {
 		__mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
 		mc.moved_charge = 0;
+		memcg_oom_recover(mc.from);
 	}
 	/* we must fixup refcnts and charges */
 	if (mc.moved_swap) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch
memory-hotplug-allow-setting-of-phys_device.patch
memory-hotplug-s390-set-phys_device.patch
memcg-disable-move-charge-in-no-mmu-case.patch
memcontrol-fix-potential-null-deref.patch
linux-next.patch
cgroups-net_cls-as-module.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
memcg-oom-wakeup-filter.patch
memcg-oom-notifier.patch
memcg-oom-notifier-fix.patch
memcg-oom-kill-disable-and-oom-status.patch

