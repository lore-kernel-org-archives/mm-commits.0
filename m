From: akpm@linux-foundation.org
Subject: [merged] memcg-avoid-oom-during-moving-charge.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:52 -0400
Message-ID: <201003150659.o2F6xPcZ016545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934472Ab0COG7l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:59:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: avoid oom during moving charge
has been removed from the -mm tree.  Its filename was
     memcg-avoid-oom-during-moving-charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid oom during moving charge
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

This move-charge-at-task-migration feature has extra charges on
"to"(pre-charges) and "from"(left-over charges) during moving charge. 
This means unnecessary oom can happen.

This patch tries to avoid such oom.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   53 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-oom-during-moving-charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-oom-during-moving-charge
+++ a/mm/memcontrol.c
@@ -254,7 +254,11 @@ static struct move_charge_struct {
 	struct mem_cgroup *to;
 	unsigned long precharge;
 	unsigned long moved_charge;
-} mc;
+	struct task_struct *moving_task;	/* a task moving charges */
+	wait_queue_head_t waitq;		/* a waitq for other context */
+} mc = {
+	.waitq = __WAIT_QUEUE_HEAD_INITIALIZER(mc.waitq),
+};
 
 /*
  * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
@@ -1508,6 +1512,48 @@ static int __mem_cgroup_try_charge(struc
 		if (mem_cgroup_check_under_limit(mem_over_limit))
 			continue;
 
+		/* try to avoid oom while someone is moving charge */
+		if (mc.moving_task && current != mc.moving_task) {
+			struct mem_cgroup *from, *to;
+			bool do_continue = false;
+			/*
+			 * There is a small race that "from" or "to" can be
+			 * freed by rmdir, so we use css_tryget().
+			 */
+			rcu_read_lock();
+			from = mc.from;
+			to = mc.to;
+			if (from && css_tryget(&from->css)) {
+				if (mem_over_limit->use_hierarchy)
+					do_continue = css_is_ancestor(
+							&from->css,
+							&mem_over_limit->css);
+				else
+					do_continue = (from == mem_over_limit);
+				css_put(&from->css);
+			}
+			if (!do_continue && to && css_tryget(&to->css)) {
+				if (mem_over_limit->use_hierarchy)
+					do_continue = css_is_ancestor(
+							&to->css,
+							&mem_over_limit->css);
+				else
+					do_continue = (to == mem_over_limit);
+				css_put(&to->css);
+			}
+			rcu_read_unlock();
+			if (do_continue) {
+				DEFINE_WAIT(wait);
+				prepare_to_wait(&mc.waitq, &wait,
+							TASK_INTERRUPTIBLE);
+				/* moving charge context might have finished. */
+				if (mc.moving_task)
+					schedule();
+				finish_wait(&mc.waitq, &wait);
+				continue;
+			}
+		}
+
 		if (!nr_retries--) {
 			if (oom) {
 				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
@@ -3381,7 +3427,6 @@ mem_cgroup_create(struct cgroup_subsys *
 			INIT_WORK(&stock->work, drain_local_stock);
 		}
 		hotcpu_notifier(memcg_stock_cpu_callback, 0);
-
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
@@ -3641,6 +3686,8 @@ static void mem_cgroup_clear_mc(void)
 	}
 	mc.from = NULL;
 	mc.to = NULL;
+	mc.moving_task = NULL;
+	wake_up_all(&mc.waitq);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
@@ -3666,10 +3713,12 @@ static int mem_cgroup_can_attach(struct 
 			VM_BUG_ON(mc.to);
 			VM_BUG_ON(mc.precharge);
 			VM_BUG_ON(mc.moved_charge);
+			VM_BUG_ON(mc.moving_task);
 			mc.from = from;
 			mc.to = mem;
 			mc.precharge = 0;
 			mc.moved_charge = 0;
+			mc.moving_task = current;
 
 			ret = mem_cgroup_precharge_mc(mm);
 			if (ret)
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-avoid-use-cmpxchg-in-swap-cgroup-maintainance.patch

