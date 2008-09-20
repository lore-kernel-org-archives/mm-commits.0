From: akpm@linux-foundation.org
Subject: + memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch added to -mm tree
Date: Fri, 19 Sep 2008 17:26:52 -0700
Message-ID: <200809200026.m8K0QqpG014848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbYITA05 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Sep 2008 20:26:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, balbir@linux.vnet.ibm.com


The patch titled
     memrlimit: fix task_lock() recursive locking
has been added to the -mm tree.  Its filename is
     memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memrlimit: fix task_lock() recursive locking
From: Andrea Righi <righi.andrea@gmail.com>

cgroup_mm_owner_callbacks() can be called with task_lock() held in
mm_update_next_owner(), and all the .mm_owner_changed callbacks seem to
be *always* called with task_lock() held.

Actually, memrlimit is using task_lock() via get_task_mm() in
memrlimit_cgroup_mm_owner_changed(), raising the following recursive locking
trace:

[ 5346.421365] =============================================
[ 5346.421374] [ INFO: possible recursive locking detected ]
[ 5346.421381] 2.6.27-rc5-mm1 #20
[ 5346.421385] ---------------------------------------------
[ 5346.421391] interbench/10530 is trying to acquire lock:
[ 5346.421396]  (&p->alloc_lock){--..}, at: [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421417]
[ 5346.421418] but task is already holding lock:
[ 5346.421423]  (&p->alloc_lock){--..}, at: [<ffffffff8023db98>] mm_update_next_owner+0x148/0x230
[ 5346.421438]
[ 5346.421440] other info that might help us debug this:
[ 5346.421446] 2 locks held by interbench/10530:
[ 5346.421450]  #0:  (&mm->mmap_sem){----}, at: [<ffffffff8023db90>] mm_update_next_owner+0x140/0x230
[ 5346.421467]  #1:  (&p->alloc_lock){--..}, at: [<ffffffff8023db98>] mm_update_next_owner+0x148/0x230
[ 5346.421483]
[ 5346.421485] stack backtrace:
[ 5346.421491] Pid: 10530, comm: interbench Not tainted 2.6.27-rc5-mm1 #20
[ 5346.421496] Call Trace:
[ 5346.421507]  [<ffffffff80263383>] validate_chain+0xb03/0x10d0
[ 5346.421515]  [<ffffffff80263c05>] __lock_acquire+0x2b5/0x9c0
[ 5346.421522]  [<ffffffff80262cc2>] validate_chain+0x442/0x10d0
[ 5346.421530]  [<ffffffff802643aa>] lock_acquire+0x9a/0xe0
[ 5346.421537]  [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421546]  [<ffffffff804757c7>] _spin_lock+0x37/0x70
[ 5346.421553]  [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421560]  [<ffffffff8023b034>] get_task_mm+0x24/0x70
[ 5346.421569]  [<ffffffff802b91f8>] memrlimit_cgroup_mm_owner_changed+0x18/0x90
[ 5346.421579]  [<ffffffff80278b03>] cgroup_mm_owner_callbacks+0x93/0xc0
[ 5346.421587]  [<ffffffff8023dc36>] mm_update_next_owner+0x1e6/0x230
[ 5346.421595]  [<ffffffff8023dd72>] exit_mm+0xf2/0x120
[ 5346.421602]  [<ffffffff8023f547>] do_exit+0x167/0x930
[ 5346.421610]  [<ffffffff8047604a>] _spin_unlock_irq+0x2a/0x50
[ 5346.421618]  [<ffffffff8023fd46>] do_group_exit+0x36/0xa0
[ 5346.421626]  [<ffffffff8020b7cb>] system_call_fastpath+0x16/0x1b

Since we hold task_lock(), we know that p->mm cannot change and we don't have
to worry about incrementing mm_users. So, just use p->mm directly and
check that we've not picked a kernel thread.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c      |    3 ++-
 mm/memrlimitcgroup.c |   10 ++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/cgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2 kernel/cgroup.c
--- a/kernel/cgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2
+++ a/kernel/cgroup.c
@@ -2792,7 +2792,8 @@ void cgroup_fork_callbacks(struct task_s
  * invoke this routine, since it assigns the mm->owner the first time
  * and does not change it.
  *
- * The callbacks are invoked with mmap_sem held in read mode.
+ * The callbacks are invoked with task_lock held and mmap_sem held in read
+ * mode.
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
diff -puN mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2 mm/memrlimitcgroup.c
--- a/mm/memrlimitcgroup.c~memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2
+++ a/mm/memrlimitcgroup.c
@@ -196,7 +196,7 @@ out:
 }
 
 /*
- * This callback is called with mmap_sem held
+ * This callback is called with mmap_sem and task_lock held
  */
 static void memrlimit_cgroup_mm_owner_changed(struct cgroup_subsys *ss,
 						struct cgroup *old_cgrp,
@@ -204,9 +204,9 @@ static void memrlimit_cgroup_mm_owner_ch
 						struct task_struct *p)
 {
 	struct memrlimit_cgroup *memrcg, *old_memrcg;
-	struct mm_struct *mm = get_task_mm(p);
+	struct mm_struct *mm = p->mm;
 
-	BUG_ON(!mm);
+	BUG_ON(!mm || (p->flags & PF_KTHREAD));
 
 	/*
 	 * If we don't have a new cgroup, we just uncharge from the old one.
@@ -216,7 +216,7 @@ static void memrlimit_cgroup_mm_owner_ch
 		memrcg = memrlimit_cgroup_from_cgrp(cgrp);
 		if (res_counter_charge(&memrcg->as_res,
 				mm->total_vm << PAGE_SHIFT))
-			goto out;
+			return;
 	}
 
 	if (old_cgrp) {
@@ -224,8 +224,6 @@ static void memrlimit_cgroup_mm_owner_ch
 		res_counter_uncharge(&old_memrcg->as_res,
 				mm->total_vm << PAGE_SHIFT);
 	}
-out:
-	mmput(mm);
 }
 
 struct cgroup_subsys memrlimit_cgroup_subsys = {
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

cpufreq-bug-using-smp_processor_id-in-preemptible-code.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch

