From: akpm@linux-foundation.org
Subject: - memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:39 -0800
Message-ID: <200901082249.n08MndQB028923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762891AbZAHWuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:50:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: avoid deadlock caused by race between oom and cpuset_attach
has been removed from the -mm tree.  Its filename was
     memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid deadlock caused by race between oom and cpuset_attach
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

mpol_rebind_mm(), which can be called from cpuset_attach(), does
down_write(mm->mmap_sem).  This means down_write(mm->mmap_sem) can be
called under cgroup_mutex.

OTOH, page fault path does down_read(mm->mmap_sem) and calls
mem_cgroup_try_charge_xxx(), which may eventually calls
mem_cgroup_out_of_memory().  And mem_cgroup_out_of_memory() calls
cgroup_lock().  This means cgroup_lock() can be called under
down_read(mm->mmap_sem).

If those two paths race, deadlock can happen.

This patch avoid this deadlock by:
  - remove cgroup_lock() from mem_cgroup_out_of_memory().
  - define new mutex (memcg_tasklist) and serialize mem_cgroup_move_task()
    (->attach handler of memory cgroup) and mem_cgroup_out_of_memory.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++++
 mm/oom_kill.c   |    2 --
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach
+++ a/mm/memcontrol.c
@@ -51,6 +51,7 @@ static int really_do_swap_account __init
 #define do_swap_account		(0)
 #endif
 
+static DEFINE_MUTEX(memcg_tasklist);	/* can be hold under cgroup_mutex */
 
 /*
  * Statistics for memory cgroup.
@@ -827,7 +828,9 @@ static int __mem_cgroup_try_charge(struc
 
 		if (!nr_retries--) {
 			if (oom) {
+				mutex_lock(&memcg_tasklist);
 				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
+				mutex_unlock(&memcg_tasklist);
 				mem_over_limit->last_oom_jiffies = jiffies;
 			}
 			goto nomem;
@@ -2211,10 +2214,12 @@ static void mem_cgroup_move_task(struct 
 				struct cgroup *old_cont,
 				struct task_struct *p)
 {
+	mutex_lock(&memcg_tasklist);
 	/*
 	 * FIXME: It's better to move charges of this process from old
 	 * memcg to new memcg. But it's just on TODO-List now.
 	 */
+	mutex_unlock(&memcg_tasklist);
 }
 
 struct cgroup_subsys mem_cgroup_subsys = {
diff -puN mm/oom_kill.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach mm/oom_kill.c
--- a/mm/oom_kill.c~memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach
+++ a/mm/oom_kill.c
@@ -429,7 +429,6 @@ void mem_cgroup_out_of_memory(struct mem
 	unsigned long points = 0;
 	struct task_struct *p;
 
-	cgroup_lock();
 	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, mem);
@@ -444,7 +443,6 @@ retry:
 		goto retry;
 out:
 	read_unlock(&tasklist_lock);
-	cgroup_unlock();
 }
 #endif
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch

