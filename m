From: akpm@linux-foundation.org
Subject: + memcg-change-memcg_oom_mutex-to-spinlock.patch added to -mm tree
Date: Thu, 21 Jul 2011 13:58:45 -0700
Message-ID: <201107212058.p6LKwjxb007029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191Ab1GUU6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 16:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     : change memcg_oom_mutex to spinlock
has been added to the -mm tree.  Its filename is
     memcg-change-memcg_oom_mutex-to-spinlock.patch

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
Subject: : change memcg_oom_mutex to spinlock
From: Michal Hocko <mhocko@suse.cz>

memcg_oom_mutex is used to protect memcg OOM path and eventfd interface
for oom_control.  None of the critical sections which it protects sleep
(eventfd_signal works from atomic context and the rest are simple linked
list resp.  oom_lock atomic operations).

Mutex is also too heavyweight for those code paths because it triggers a
lot of scheduling.  It also makes makes convoying effects more visible
when we have a big number of oom killing because we take the lock mutliple
times during mem_cgroup_handle_oom so we have multiple places where many
processes can sleep.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-change-memcg_oom_mutex-to-spinlock mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-change-memcg_oom_mutex-to-spinlock
+++ a/mm/memcontrol.c
@@ -1724,7 +1724,7 @@ static int mem_cgroup_hierarchical_recla
 /*
  * Check OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
- * Has to be called with memcg_oom_mutex
+ * Has to be called with memcg_oom_lock
  */
 static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
 {
@@ -1769,7 +1769,7 @@ done:
 }
 
 /*
- * Has to be called with memcg_oom_mutex
+ * Has to be called with memcg_oom_lock
  */
 static int mem_cgroup_oom_unlock(struct mem_cgroup *mem)
 {
@@ -1801,7 +1801,7 @@ static void mem_cgroup_unmark_under_oom(
 		atomic_add_unless(&iter->under_oom, -1, 0);
 }
 
-static DEFINE_MUTEX(memcg_oom_mutex);
+static DEFINE_SPINLOCK(memcg_oom_lock);
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
 
 struct oom_wait_info {
@@ -1863,7 +1863,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	mem_cgroup_mark_under_oom(mem);
 
 	/* At first, try to OOM lock hierarchy under mem.*/
-	mutex_lock(&memcg_oom_mutex);
+	spin_lock(&memcg_oom_lock);
 	locked = mem_cgroup_oom_lock(mem);
 	/*
 	 * Even if signal_pending(), we can't quit charge() loop without
@@ -1875,7 +1875,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 		need_to_kill = false;
 	if (locked)
 		mem_cgroup_oom_notify(mem);
-	mutex_unlock(&memcg_oom_mutex);
+	spin_unlock(&memcg_oom_lock);
 
 	if (need_to_kill) {
 		finish_wait(&memcg_oom_waitq, &owait.wait);
@@ -1884,11 +1884,11 @@ bool mem_cgroup_handle_oom(struct mem_cg
 		schedule();
 		finish_wait(&memcg_oom_waitq, &owait.wait);
 	}
-	mutex_lock(&memcg_oom_mutex);
+	spin_lock(&memcg_oom_lock);
 	if (locked)
 		mem_cgroup_oom_unlock(mem);
 	memcg_wakeup_oom(mem);
-	mutex_unlock(&memcg_oom_mutex);
+	spin_unlock(&memcg_oom_lock);
 
 	mem_cgroup_unmark_under_oom(mem);
 
@@ -4503,7 +4503,7 @@ static int mem_cgroup_oom_register_event
 	if (!event)
 		return -ENOMEM;
 
-	mutex_lock(&memcg_oom_mutex);
+	spin_lock(&memcg_oom_lock);
 
 	event->eventfd = eventfd;
 	list_add(&event->list, &memcg->oom_notify);
@@ -4511,7 +4511,7 @@ static int mem_cgroup_oom_register_event
 	/* already in OOM ? */
 	if (atomic_read(&memcg->under_oom))
 		eventfd_signal(eventfd, 1);
-	mutex_unlock(&memcg_oom_mutex);
+	spin_unlock(&memcg_oom_lock);
 
 	return 0;
 }
@@ -4525,7 +4525,7 @@ static void mem_cgroup_oom_unregister_ev
 
 	BUG_ON(type != _OOM_TYPE);
 
-	mutex_lock(&memcg_oom_mutex);
+	spin_lock(&memcg_oom_lock);
 
 	list_for_each_entry_safe(ev, tmp, &mem->oom_notify, list) {
 		if (ev->eventfd == eventfd) {
@@ -4534,7 +4534,7 @@ static void mem_cgroup_oom_unregister_ev
 		}
 	}
 
-	mutex_unlock(&memcg_oom_mutex);
+	spin_unlock(&memcg_oom_lock);
 }
 
 static int mem_cgroup_oom_control_read(struct cgroup *cgrp,
_

Patches currently in -mm which might be from mhocko@suse.cz are

linux-next.patch
mm-remove-the-leftovers-of-noswapaccount.patch
mm-thp-minor-lock-simplification-in-__khugepaged_exit.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
um-clean-up-vm-flagsh.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch
memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch
memcg-change-memcg_oom_mutex-to-spinlock.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

