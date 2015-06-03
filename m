From: akpm@linux-foundation.org
Subject: + memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int.patch
 added to -mm tree
Date: Wed, 03 Jun 2015 15:47:35 -0700
Message-ID: <556f8407.dqAN+0XUlJzRurMc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbbFCWrg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2015 18:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: convert mem_cgroup->under_oom from atomic_t to int
has been added to the -mm tree.  Its filename is
     memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memcg: convert mem_cgroup->under_oom from atomic_t to int

memcg->under_oom tracks whether the memcg is under OOM conditions and is
an atomic_t counter managed with mem_cgroup_[un]mark_under_oom().  While
atomic_t appears to be simple synchronization-wise, when used as a
synchronization construct like here, it's trickier and more error-prone
due to weak memory ordering rules, especially around atomic_read(), and
false sense of security.

For example, both non-trivial read sites of memcg->under_oom are a bit
problematic although not being actually broken.

* mem_cgroup_oom_register_event()

  It isn't explicit what guarantees the memory ordering between event
  addition and memcg->under_oom check.  This isn't broken only because
  memcg_oom_lock is used for both event list and memcg->oom_lock.

* memcg_oom_recover()

  The lockless test doesn't have any explanation why this would be
  safe.

mem_cgroup_[un]mark_under_oom() are very cold paths and there's no point
in avoiding locking memcg_oom_lock there.  This patch converts
memcg->under_oom from atomic_t to int, puts their modifications under
memcg_oom_lock and documents why the lockless test in memcg_oom_recover()
is safe.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int
+++ a/mm/memcontrol.c
@@ -285,8 +285,9 @@ struct mem_cgroup {
 	 */
 	bool use_hierarchy;
 
+	/* protected by memcg_oom_lock */
 	bool		oom_lock;
-	atomic_t	under_oom;
+	int		under_oom;
 
 	int	swappiness;
 	/* OOM-Killer disable */
@@ -1810,8 +1811,10 @@ static void mem_cgroup_mark_under_oom(st
 {
 	struct mem_cgroup *iter;
 
+	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
-		atomic_inc(&iter->under_oom);
+		iter->under_oom++;
+	spin_unlock(&memcg_oom_lock);
 }
 
 static void mem_cgroup_unmark_under_oom(struct mem_cgroup *memcg)
@@ -1820,11 +1823,13 @@ static void mem_cgroup_unmark_under_oom(
 
 	/*
 	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. We have to use
-	 * atomic_add_unless() here.
+	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
 	 */
+	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
-		atomic_add_unless(&iter->under_oom, -1, 0);
+		if (iter->under_oom > 0)
+			iter->under_oom--;
+	spin_unlock(&memcg_oom_lock);
 }
 
 static DECLARE_WAIT_QUEUE_HEAD(memcg_oom_waitq);
@@ -1852,7 +1857,15 @@ static int memcg_oom_wake_function(wait_
 
 static void memcg_oom_recover(struct mem_cgroup *memcg)
 {
-	if (memcg && atomic_read(&memcg->under_oom))
+	/*
+	 * For the following lockless ->under_oom test, the only required
+	 * guarantee is that it must see the state asserted by an OOM when
+	 * this function is called as a result of userland actions
+	 * triggered by the notification of the OOM.  This is trivially
+	 * achieved by invoking mem_cgroup_mark_under_oom() before
+	 * triggering notification.
+	 */
+	if (memcg && memcg->under_oom)
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
@@ -3861,7 +3874,7 @@ static int mem_cgroup_oom_register_event
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
-	if (atomic_read(&memcg->under_oom))
+	if (memcg->under_oom)
 		eventfd_signal(eventfd, 1);
 	spin_unlock(&memcg_oom_lock);
 
@@ -3890,7 +3903,7 @@ static int mem_cgroup_oom_control_read(s
 	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(sf));
 
 	seq_printf(sf, "oom_kill_disable %d\n", memcg->oom_kill_disable);
-	seq_printf(sf, "under_oom %d\n", (bool)atomic_read(&memcg->under_oom));
+	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	return 0;
 }
 
_

Patches currently in -mm which might be from tj@kernel.org are

block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
mm-memcg-try-charging-a-page-before-setting-page-up-to-date.patch
memcg-remove-unused-mem_cgroup-oom_wakeups.patch
memcg-convert-mem_cgroup-under_oom-from-atomic_t-to-int.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch
printk-guard-the-amount-written-per-line-by-devkmsg_read.patch
printk-factor-out-message-formatting-from-devkmsg_read.patch
printk-implement-support-for-extended-console-drivers.patch
netconsole-remove-unnecessary-netconsole_target_get-out-from-write_msg.patch
netconsole-make-netconsole_target-enabled-a-bool.patch
netconsole-make-all-dynamic-netconsoles-share-a-mutex.patch
netconsole-implement-extended-console-support.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
ipc-msgc-msgsnd-use-freezable-blocking-call.patch
msgrcv-use-freezable-blocking-call.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch

