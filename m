From: akpm@osdl.org
Subject: - taskstats-cleanup-signal-stats-allocation.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:22 -0800
Message-ID: <200612072303.kB7N3Mkn029956@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51926 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163727AbWLGXDk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, balbir@in.ibm.com, jlan@engr.sgi.com, nagar@watson.ibm.com, mm-commits@vger.kernel.org


The patch titled
     taskstats: cleanup ->signal->stats allocation
has been removed from the -mm tree.  Its filename was
     taskstats-cleanup-signal-stats-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: taskstats: cleanup ->signal->stats allocation
From: Oleg Nesterov <oleg@tv-sign.ru>

Allocate ->signal->stats on demand in taskstats_exit(), this allows us to
remove taskstats_tgid_alloc() (the last non-trivial inline) from taskstat's
public interface.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/taskstats_kern.h |   24 ------------------------
 kernel/fork.c                  |    1 -
 kernel/taskstats.c             |   26 +++++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 26 deletions(-)

diff -puN include/linux/taskstats_kern.h~taskstats-cleanup-signal-stats-allocation include/linux/taskstats_kern.h
--- a/include/linux/taskstats_kern.h~taskstats-cleanup-signal-stats-allocation
+++ a/include/linux/taskstats_kern.h
@@ -20,28 +20,6 @@ static inline void taskstats_tgid_init(s
 	sig->stats = NULL;
 }
 
-static inline void taskstats_tgid_alloc(struct task_struct *tsk)
-{
-	struct signal_struct *sig = tsk->signal;
-	struct taskstats *stats;
-
-	if (sig->stats != NULL)
-		return;
-
-	/* No problem if kmem_cache_zalloc() fails */
-	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
-
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (!sig->stats) {
-		sig->stats = stats;
-		stats = NULL;
-	}
-	spin_unlock_irq(&tsk->sighand->siglock);
-
-	if (stats)
-		kmem_cache_free(taskstats_cache, stats);
-}
-
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {
 	if (sig->stats)
@@ -55,8 +33,6 @@ static inline void taskstats_exit(struct
 {}
 static inline void taskstats_tgid_init(struct signal_struct *sig)
 {}
-static inline void taskstats_tgid_alloc(struct task_struct *tsk)
-{}
 static inline void taskstats_tgid_free(struct signal_struct *sig)
 {}
 static inline void taskstats_init_early(void)
diff -puN kernel/fork.c~taskstats-cleanup-signal-stats-allocation kernel/fork.c
--- a/kernel/fork.c~taskstats-cleanup-signal-stats-allocation
+++ a/kernel/fork.c
@@ -847,7 +847,6 @@ static inline int copy_signal(unsigned l
 	if (clone_flags & CLONE_THREAD) {
 		atomic_inc(&current->signal->count);
 		atomic_inc(&current->signal->live);
-		taskstats_tgid_alloc(current);
 		return 0;
 	}
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
diff -puN kernel/taskstats.c~taskstats-cleanup-signal-stats-allocation kernel/taskstats.c
--- a/kernel/taskstats.c~taskstats-cleanup-signal-stats-allocation
+++ a/kernel/taskstats.c
@@ -412,6 +412,30 @@ err:
 	return rc;
 }
 
+static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct taskstats *stats;
+
+	if (sig->stats || thread_group_empty(tsk))
+		goto ret;
+
+	/* No problem if kmem_cache_zalloc() fails */
+	stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (!sig->stats) {
+		sig->stats = stats;
+		stats = NULL;
+	}
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (stats)
+		kmem_cache_free(taskstats_cache, stats);
+ret:
+	return sig->stats;
+}
+
 /* Send pid data out on exit */
 void taskstats_exit(struct task_struct *tsk, int group_dead)
 {
@@ -433,7 +457,7 @@ void taskstats_exit(struct task_struct *
 	size = nla_total_size(sizeof(u32)) +
 		nla_total_size(sizeof(struct taskstats)) + nla_total_size(0);
 
-	is_thread_group = (tsk->signal->stats != NULL);
+	is_thread_group = !!taskstats_tgid_alloc(tsk);
 	if (is_thread_group) {
 		/* PID + STATS + TGID + STATS */
 		size = 2 * size;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
trivial-make-set_special_pids-static.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
sys_setpgid-eliminate-unnecessary-do_each_task_pidpidtype_pgid.patch
session_of_pgrp-kill-unnecessary-do_each_task_pidpidtype_pgid.patch
pidhash-temporary-debug-checks.patch

