From: akpm@linux-foundation.org
Subject: + memcg-clean-up-waiting-move-acct-v2.patch added to -mm tree
Date: Fri, 04 Jun 2010 15:31:31 -0700
Message-ID: <201006042231.o54MVVsX022116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530Ab0FDWbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 18:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: clean up waiting move acct
has been added to the -mm tree.  Its filename is
     memcg-clean-up-waiting-move-acct-v2.patch

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
Subject: memcg: clean up waiting move acct
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, for checking a memcg is under task-account-moving, we do css_tryget()
against mc.to and mc.from.  But this is just complicating things.  This
patch makes the check easier.

This patch adds a spinlock to move_charge_struct and guard modification of
mc.to and mc.from.  By this, we don't have to think about complicated
races arount this not-critical path.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-waiting-move-acct-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-waiting-move-acct-v2
+++ a/mm/memcontrol.c
@@ -268,6 +268,7 @@ enum move_type {
 
 /* "mc" and its members are protected by cgroup_mutex */
 static struct move_charge_struct {
+	spinlock_t	  lock; /* for from, to, moving_task */
 	struct mem_cgroup *from;
 	struct mem_cgroup *to;
 	unsigned long precharge;
@@ -276,6 +277,7 @@ static struct move_charge_struct {
 	struct task_struct *moving_task;	/* a task moving charges */
 	wait_queue_head_t waitq;		/* a waitq for other context */
 } mc = {
+	.lock = __SPIN_LOCK_UNLOCKED(mc.lock),
 	.waitq = __WAIT_QUEUE_HEAD_INITIALIZER(mc.waitq),
 };
 
@@ -1076,26 +1078,24 @@ static unsigned int get_swappiness(struc
 
 static bool mem_cgroup_under_move(struct mem_cgroup *mem)
 {
-	struct mem_cgroup *from = mc.from;
-	struct mem_cgroup *to = mc.to;
+	struct mem_cgroup *from;
+	struct mem_cgroup *to;
 	bool ret = false;
-
-	if (from == mem || to == mem)
-		return true;
-
-	if (!from || !to || !mem->use_hierarchy)
-		return false;
-
-	rcu_read_lock();
-	if (css_tryget(&from->css)) {
-		ret = css_is_ancestor(&from->css, &mem->css);
-		css_put(&from->css);
-	}
-	if (!ret && css_tryget(&to->css)) {
-		ret = css_is_ancestor(&to->css,	&mem->css);
-		css_put(&to->css);
-	}
-	rcu_read_unlock();
+	/*
+	 * Unlike task_move routines, we access mc.to, mc.from not under
+	 * mutual exclusion by cgroup_mutex. Here, we take spinlock instead.
+	 */
+	spin_lock(&mc.lock);
+	from = mc.from;
+	to = mc.to;
+	if (!from)
+		goto unlock;
+	if (from == mem || to == mem
+	    || (mem->use_hierarchy && css_is_ancestor(&from->css, &mem->css))
+	    || (mem->use_hierarchy && css_is_ancestor(&to->css,	&mem->css)))
+		ret = true;
+unlock:
+	spin_unlock(&mc.lock);
 	return ret;
 }
 
@@ -4446,11 +4446,13 @@ static int mem_cgroup_precharge_mc(struc
 
 static void mem_cgroup_clear_mc(void)
 {
+	struct mem_cgroup *from = mc.from;
+	struct mem_cgroup *to = mc.to;
+
 	/* we must uncharge all the leftover precharges from mc.to */
 	if (mc.precharge) {
 		__mem_cgroup_cancel_charge(mc.to, mc.precharge);
 		mc.precharge = 0;
-		memcg_oom_recover(mc.to);
 	}
 	/*
 	 * we didn't uncharge from mc.from at mem_cgroup_move_account(), so
@@ -4459,7 +4461,6 @@ static void mem_cgroup_clear_mc(void)
 	if (mc.moved_charge) {
 		__mem_cgroup_cancel_charge(mc.from, mc.moved_charge);
 		mc.moved_charge = 0;
-		memcg_oom_recover(mc.from);
 	}
 	/* we must fixup refcnts and charges */
 	if (mc.moved_swap) {
@@ -4484,9 +4485,13 @@ static void mem_cgroup_clear_mc(void)
 
 		mc.moved_swap = 0;
 	}
+	spin_lock(&mc.lock);
 	mc.from = NULL;
 	mc.to = NULL;
 	mc.moving_task = NULL;
+	spin_unlock(&mc.lock);
+	memcg_oom_recover(from);
+	memcg_oom_recover(to);
 	wake_up_all(&mc.waitq);
 }
 
@@ -4515,12 +4520,14 @@ static int mem_cgroup_can_attach(struct 
 			VM_BUG_ON(mc.moved_charge);
 			VM_BUG_ON(mc.moved_swap);
 			VM_BUG_ON(mc.moving_task);
+			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = mem;
 			mc.precharge = 0;
 			mc.moved_charge = 0;
 			mc.moved_swap = 0;
 			mc.moving_task = current;
+			spin_unlock(&mc.lock);
 
 			ret = mem_cgroup_precharge_mc(mm);
 			if (ret)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

cgroup-alloc_css_id-increments-hierarchy-depth.patch
vmscan-fix-do_try_to_free_pages-return-value-when-priority==0-reclaim-failure.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch

