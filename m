From: akpm@linux-foundation.org
Subject: [merged] memcg-change-memcg_oom_mutex-to-spinlock.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:08 -0700
Message-ID: <201107271926.p6RJQsoW003154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114Ab1G0T1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: change memcg_oom_mutex to spinlock
has been removed from the -mm tree.  Its filename was
     memcg-change-memcg_oom_mutex-to-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: change memcg_oom_mutex to spinlock
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
@@ -1725,7 +1725,7 @@ static int mem_cgroup_hierarchical_recla
 /*
  * Check OOM-Killer is already running under our hierarchy.
  * If someone is running, return false.
- * Has to be called with memcg_oom_mutex
+ * Has to be called with memcg_oom_lock
  */
 static bool mem_cgroup_oom_lock(struct mem_cgroup *mem)
 {
@@ -1770,7 +1770,7 @@ done:
 }
 
 /*
- * Has to be called with memcg_oom_mutex
+ * Has to be called with memcg_oom_lock
  */
 static int mem_cgroup_oom_unlock(struct mem_cgroup *mem)
 {
@@ -1802,7 +1802,7 @@ static void mem_cgroup_unmark_under_oom(
 		atomic_add_unless(&iter->under_oom, -1, 0);
 }
 
-static DEFINE_MUTEX(memcg_oom_mutex);
+static DEFINE_SPINLOCK(memcg_oom_lock);
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
 
 struct oom_wait_info {
@@ -1864,7 +1864,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 	mem_cgroup_mark_under_oom(mem);
 
 	/* At first, try to OOM lock hierarchy under mem.*/
-	mutex_lock(&memcg_oom_mutex);
+	spin_lock(&memcg_oom_lock);
 	locked = mem_cgroup_oom_lock(mem);
 	/*
 	 * Even if signal_pending(), we can't quit charge() loop without
@@ -1876,7 +1876,7 @@ bool mem_cgroup_handle_oom(struct mem_cg
 		need_to_kill = false;
 	if (locked)
 		mem_cgroup_oom_notify(mem);
-	mutex_unlock(&memcg_oom_mutex);
+	spin_unlock(&memcg_oom_lock);
 
 	if (need_to_kill) {
 		finish_wait(&memcg_oom_waitq, &owait.wait);
@@ -1885,11 +1885,11 @@ bool mem_cgroup_handle_oom(struct mem_cg
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
 
@@ -4553,7 +4553,7 @@ static int mem_cgroup_oom_register_event
 	if (!event)
 		return -ENOMEM;
 
-	mutex_lock(&memcg_oom_mutex);
+	spin_lock(&memcg_oom_lock);
 
 	event->eventfd = eventfd;
 	list_add(&event->list, &memcg->oom_notify);
@@ -4561,7 +4561,7 @@ static int mem_cgroup_oom_register_event
 	/* already in OOM ? */
 	if (atomic_read(&memcg->under_oom))
 		eventfd_signal(eventfd, 1);
-	mutex_unlock(&memcg_oom_mutex);
+	spin_unlock(&memcg_oom_lock);
 
 	return 0;
 }
@@ -4575,7 +4575,7 @@ static void mem_cgroup_oom_unregister_ev
 
 	BUG_ON(type != _OOM_TYPE);
 
-	mutex_lock(&memcg_oom_mutex);
+	spin_lock(&memcg_oom_lock);
 
 	list_for_each_entry_safe(ev, tmp, &mem->oom_notify, list) {
 		if (ev->eventfd == eventfd) {
@@ -4584,7 +4584,7 @@ static void mem_cgroup_oom_unregister_ev
 		}
 	}
 
-	mutex_unlock(&memcg_oom_mutex);
+	spin_unlock(&memcg_oom_lock);
 }
 
 static int mem_cgroup_oom_control_read(struct cgroup *cgrp,
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

