From: akpm@linux-foundation.org
Subject: + memcg-avoid-oom-during-moving-charge.patch added to -mm tree
Date: Tue, 22 Dec 2009 16:26:51 -0800
Message-ID: <200912230026.nBN0QpE7001201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbZLWA1M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 19:27:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com


The patch titled
     memcg: avoid oom during moving charge
has been added to the -mm tree.  Its filename is
     memcg-avoid-oom-during-moving-charge.patch

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
@@ -3384,7 +3430,6 @@ mem_cgroup_create(struct cgroup_subsys *
 			INIT_WORK(&stock->work, drain_local_stock);
 		}
 		hotcpu_notifier(memcg_stock_cpu_callback, 0);
-
 	} else {
 		parent = mem_cgroup_from_cont(cont->parent);
 		mem->use_hierarchy = parent->use_hierarchy;
@@ -3644,6 +3689,8 @@ static void mem_cgroup_clear_mc(void)
 	}
 	mc.from = NULL;
 	mc.to = NULL;
+	mc.moving_task = NULL;
+	wake_up_all(&mc.waitq);
 }
 
 static int mem_cgroup_can_attach(struct cgroup_subsys *ss,
@@ -3669,10 +3716,12 @@ static int mem_cgroup_can_attach(struct 
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

cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-improve-performance-in-moving-swap-charge.patch

