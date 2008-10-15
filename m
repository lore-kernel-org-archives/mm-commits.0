From: akpm@linux-foundation.org
Subject: - signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:07 -0700
Message-ID: <200810152114.m9FLE7CV005704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464AbYJOVPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, adobriyan@gmail.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signal, procfs: lock_task_sighand() do not need rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signal, procfs: lock_task_sighand() do not need rcu_read_lock()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

lock_task_sighand() make sure task->sighand is being protected, so we do
not need rcu_read_lock().  exec() will get task->sighand->siglock before
change task->sighand!

But code using rcu_read_lock() _just_ to protect lock_task_sighand() only
appear in procfs.  (and some code in procfs use lock_task_sighand()
without such redundant protection.)

Other subsystem may put lock_task_sighand() into rcu_read_lock() critical
region, but these rcu_read_lock() are used for protecting
"for_each_process()", "find_task_by_vpid()" etc.  , not for protecting
lock_task_sighand().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c      |    2 --
 fs/proc/base.c       |    9 +--------
 kernel/sched_debug.c |    2 --
 3 files changed, 1 insertion(+), 12 deletions(-)

diff -puN fs/proc/array.c~signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock fs/proc/array.c
--- a/fs/proc/array.c~signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock
+++ a/fs/proc/array.c
@@ -261,7 +261,6 @@ static inline void task_sig(struct seq_f
 	sigemptyset(&ignored);
 	sigemptyset(&caught);
 
-	rcu_read_lock();
 	if (lock_task_sighand(p, &flags)) {
 		pending = p->pending.signal;
 		shpending = p->signal->shared_pending.signal;
@@ -272,7 +271,6 @@ static inline void task_sig(struct seq_f
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
-	rcu_read_unlock();
 
 	seq_printf(m, "Threads:\t%d\n", num_threads);
 	seq_printf(m, "SigQ:\t%lu/%lu\n", qsize, qlim);
diff -puN fs/proc/base.c~signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock fs/proc/base.c
--- a/fs/proc/base.c~signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock
+++ a/fs/proc/base.c
@@ -164,7 +164,6 @@ static struct fs_struct *get_fs_struct(s
 
 static int get_nr_threads(struct task_struct *tsk)
 {
-	/* Must be called with the rcu_read_lock held */
 	unsigned long flags;
 	int count = 0;
 
@@ -471,14 +470,10 @@ static int proc_pid_limits(struct task_s
 
 	struct rlimit rlim[RLIM_NLIMITS];
 
-	rcu_read_lock();
-	if (!lock_task_sighand(task,&flags)) {
-		rcu_read_unlock();
+	if (!lock_task_sighand(task, &flags))
 		return 0;
-	}
 	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
 	unlock_task_sighand(task, &flags);
-	rcu_read_unlock();
 
 	/*
 	 * print the file header
@@ -3088,9 +3083,7 @@ static int proc_task_getattr(struct vfsm
 	generic_fillattr(inode, stat);
 
 	if (p) {
-		rcu_read_lock();
 		stat->nlink += get_nr_threads(p);
-		rcu_read_unlock();
 		put_task_struct(p);
 	}
 
diff -puN kernel/sched_debug.c~signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock kernel/sched_debug.c
--- a/kernel/sched_debug.c~signal-procfs-lock_task_sighand-do-not-need-rcu_read_lock
+++ a/kernel/sched_debug.c
@@ -333,12 +333,10 @@ void proc_sched_show_task(struct task_st
 	unsigned long flags;
 	int num_threads = 1;
 
-	rcu_read_lock();
 	if (lock_task_sighand(p, &flags)) {
 		num_threads = atomic_read(&p->signal->count);
 		unlock_task_sighand(p, &flags);
 	}
-	rcu_read_unlock();
 
 	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid, num_threads);
 	SEQ_printf(m,
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
devcgroup-remove-spin_lock.patch

