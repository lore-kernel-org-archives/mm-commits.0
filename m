From: akpm@linux-foundation.org
Subject: [merged] mm-oom_reaper-implement-oom-victims-queuing.patch
 removed from -mm tree
Date: Sat, 26 Mar 2016 20:29:59 -0700
Message-ID: <56f753b7.ZekaF3unMvln+iST%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbcC0DaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andrea@kernel.org, hannes@cmpxchg.org, hughd@google.com, mgorman@suse.de, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, riel@redhat.com, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: implement OOM victims queuing
has been removed from the -mm tree.  Its filename was
     mm-oom_reaper-implement-oom-victims-queuing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: implement OOM victims queuing

wake_oom_reaper has allowed only 1 oom victim to be queued.  The main
reason for that was the simplicity as other solutions would require some
way of queuing.  The current approach is racy and that was deemed
sufficient as the oom_reaper is considered a best effort approach to help
with oom handling when the OOM victim cannot terminate in a reasonable
time.  The race could lead to missing an oom victim which can get stuck

out_of_memory
  wake_oom_reaper
    cmpxchg // OK
    			oom_reaper
			  oom_reap_task
			    __oom_reap_task
oom_victim terminates
			      atomic_inc_not_zero // fail
out_of_memory
  wake_oom_reaper
    cmpxchg // fails
			  task_to_reap = NULL

This race requires 2 OOM invocations in a short time period which is not
very likely but certainly not impossible.  E.g.  the original victim might
have not released a lot of memory for some reason.

The situation would improve considerably if wake_oom_reaper used a more
robust queuing.  This is what this patch implements.  This means adding
oom_reaper_list list_head into task_struct (eat a hole before embeded
thread_struct for that purpose) and a oom_reaper_lock spinlock for queuing
synchronization.  wake_oom_reaper will then add the task on the queue and
oom_reaper will dequeue it.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andrea Argangeli <andrea@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 +++
 mm/oom_kill.c         |   36 +++++++++++++++++++-----------------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff -puN include/linux/sched.h~mm-oom_reaper-implement-oom-victims-queuing include/linux/sched.h
--- a/include/linux/sched.h~mm-oom_reaper-implement-oom-victims-queuing
+++ a/include/linux/sched.h
@@ -1849,6 +1849,9 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+#ifdef CONFIG_MMU
+	struct list_head oom_reaper_list;
+#endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
 /*
diff -puN mm/oom_kill.c~mm-oom_reaper-implement-oom-victims-queuing mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_reaper-implement-oom-victims-queuing
+++ a/mm/oom_kill.c
@@ -418,8 +418,10 @@ bool oom_killer_disabled __read_mostly;
  * victim (if that is possible) to help the OOM killer to move on.
  */
 static struct task_struct *oom_reaper_th;
-static struct task_struct *task_to_reap;
 static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
+static LIST_HEAD(oom_reaper_list);
+static DEFINE_SPINLOCK(oom_reaper_lock);
+
 
 static bool __oom_reap_task(struct task_struct *tsk)
 {
@@ -524,12 +526,20 @@ static void oom_reap_task(struct task_st
 static int oom_reaper(void *unused)
 {
 	while (true) {
-		struct task_struct *tsk;
+		struct task_struct *tsk = NULL;
 
 		wait_event_freezable(oom_reaper_wait,
-				     (tsk = READ_ONCE(task_to_reap)));
-		oom_reap_task(tsk);
-		WRITE_ONCE(task_to_reap, NULL);
+				     (!list_empty(&oom_reaper_list)));
+		spin_lock(&oom_reaper_lock);
+		if (!list_empty(&oom_reaper_list)) {
+			tsk = list_first_entry(&oom_reaper_list,
+					struct task_struct, oom_reaper_list);
+			list_del(&tsk->oom_reaper_list);
+		}
+		spin_unlock(&oom_reaper_lock);
+
+		if (tsk)
+			oom_reap_task(tsk);
 	}
 
 	return 0;
@@ -537,23 +547,15 @@ static int oom_reaper(void *unused)
 
 static void wake_oom_reaper(struct task_struct *tsk)
 {
-	struct task_struct *old_tsk;
-
 	if (!oom_reaper_th)
 		return;
 
 	get_task_struct(tsk);
 
-	/*
-	 * Make sure that only a single mm is ever queued for the reaper
-	 * because multiple are not necessary and the operation might be
-	 * disruptive so better reduce it to the bare minimum.
-	 */
-	old_tsk = cmpxchg(&task_to_reap, NULL, tsk);
-	if (!old_tsk)
-		wake_up(&oom_reaper_wait);
-	else
-		put_task_struct(tsk);
+	spin_lock(&oom_reaper_lock);
+	list_add(&tsk->oom_reaper_list, &oom_reaper_list);
+	spin_unlock(&oom_reaper_lock);
+	wake_up(&oom_reaper_wait);
 }
 
 static int __init oom_init(void)
_

Patches currently in -mm which might be from mhocko@suse.com are

oom-oom_reaper-disable-oom_reaper-for-oom_kill_allocating_task.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch

