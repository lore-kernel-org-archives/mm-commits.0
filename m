From: akpm@linux-foundation.org
Subject: + add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5.patch added to -mm tree
Date: Wed, 19 Sep 2007 23:20:57 -0700
Message-ID: <200709200620.l8K6KvXQ031766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56982 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbXITGWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 02:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guichaz@yahoo.fr, balbir@in.ibm.com, jlan@engr.sgi.com, jlim@sgi.com, mikey@neuling.org, oleg@tv-sign.ru


The patch titled
     Add all thread stats for TASKSTATS_CMD_ATTR_TGID
has been added to the -mm tree.  Its filename is
     add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add all thread stats for TASKSTATS_CMD_ATTR_TGID
From: Guillaume Chazarain <guichaz@yahoo.fr>

TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
the basic and extended accounting.  With this patch,
TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
of a thread group.  This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
(http://guichaz.free.fr/misc/iotop.py).

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Michael Neuling <mikey@neuling.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tsacct_kern.h |   12 ++-
 kernel/taskstats.c          |  129 +++++++++++++++++++++-------------
 kernel/tsacct.c             |  122 ++++++++++++++++++--------------
 3 files changed, 160 insertions(+), 103 deletions(-)

diff -puN include/linux/tsacct_kern.h~add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5 include/linux/tsacct_kern.h
--- a/include/linux/tsacct_kern.h~add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5
+++ a/include/linux/tsacct_kern.h
@@ -10,17 +10,23 @@
 #include <linux/taskstats.h>
 
 #ifdef CONFIG_TASKSTATS
-extern void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk);
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task);
 #else
-static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{}
+static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
 {}
 #endif /* CONFIG_TASKSTATS */
 
 #ifdef CONFIG_TASK_XACCT
-extern void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
 extern void acct_update_integrals(struct task_struct *tsk);
 extern void acct_clear_integrals(struct task_struct *tsk);
 #else
+static inline void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{}
 static inline void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {}
 static inline void acct_update_integrals(struct task_struct *tsk)
diff -puN kernel/taskstats.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5 kernel/taskstats.c
--- a/kernel/taskstats.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5
+++ a/kernel/taskstats.c
@@ -176,6 +176,68 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
+/**
+ * fill_threadgroup - initialize some common stats for the thread group
+ * @stats: the taskstats to write into
+ * @task: the thread representing the whole group
+ *
+ * There are two types of taskstats fields when considering a thread group:
+ *	- those that can be aggregated from each thread in the group (like CPU
+ *	times),
+ *	- those that cannot be aggregated (like UID) or are identical (like
+ *	memory usage), so are taken from the group leader.
+ * XXX_threadgroup() methods deal with the first type while XXX_add_tsk() with
+ * the second.
+ */
+static void fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to initialize
+	 * relevant parts of struct taskstsats for a single tgid as follows:
+	 *
+	 *	per-task-foo-fill_threadgroup(stats, task);
+	 */
+
+	stats->version = TASKSTATS_VERSION;
+
+	/* fill in basic acct fields */
+	bacct_fill_threadgroup(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_fill_threadgroup(stats, task);
+}
+
+/**
+ * add_tsk - combine some thread specific stats in a taskstats
+ * @stats: the taskstats to write into
+ * @task: the thread to combine
+ *
+ * Stats specific to each thread in the thread group. Stats of @task should be
+ * combined with those already present in @stats. add_tsk() works in
+ * conjunction with fill_threadgroup(), taskstats fields should not be touched
+ * by both functions.
+ */
+static void add_tsk(struct taskstats *stats, struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to combine
+	 * relevant parts of struct taskstsats for a single pid as follows:
+	 *
+	 *	per-task-foo-add_tsk(stats, task);
+	 */
+	stats->nvcsw  += task->nvcsw;
+	stats->nivcsw += task->nivcsw;
+
+	/* fill in delay acct fields */
+	delayacct_add_tsk(stats, task);
+
+	/* fill in basic acct fields */
+	bacct_add_tsk(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_add_tsk(stats, task);
+}
+
 static int fill_pid(pid_t pid, struct task_struct *tsk,
 		struct taskstats *stats)
 {
@@ -193,23 +255,8 @@ static int fill_pid(pid_t pid, struct ta
 		get_task_struct(tsk);
 
 	memset(stats, 0, sizeof(*stats));
-	/*
-	 * Each accounting subsystem adds calls to its functions to
-	 * fill in relevant parts of struct taskstsats as follows
-	 *
-	 *	per-task-foo(stats, tsk);
-	 */
-
-	delayacct_add_tsk(stats, tsk);
-
-	/* fill in basic acct fields */
-	stats->version = TASKSTATS_VERSION;
-	stats->nvcsw = tsk->nvcsw;
-	stats->nivcsw = tsk->nivcsw;
-	bacct_add_tsk(stats, tsk);
-
-	/* fill in extended acct fields */
-	xacct_add_tsk(stats, tsk);
+	fill_threadgroup(stats, tsk);
+	add_tsk(stats, tsk);
 
 	/* Define err: label here if needed */
 	put_task_struct(tsk);
@@ -240,32 +287,25 @@ static int fill_tgid(pid_t tgid, struct 
 	else
 		memset(stats, 0, sizeof(*stats));
 
+	fill_threadgroup(stats, first->group_leader);
+
 	tsk = first;
-	do {
-		if (tsk->exit_state)
-			continue;
-		/*
-		 * Accounting subsystem can call its functions here to
-		 * fill in relevant parts of struct taskstsats as follows
-		 *
-		 *	per-task-foo(stats, tsk);
-		 */
-		delayacct_add_tsk(stats, tsk);
-
-		stats->nvcsw += tsk->nvcsw;
-		stats->nivcsw += tsk->nivcsw;
-	} while_each_thread(first, tsk);
+	do
+		if (!tsk->exit_state)
+			/*
+			 * This check is racy as a thread could exit just right
+			 * now and have its statistics accounted twice.
+			 */
+			add_tsk(stats, tsk);
+	while_each_thread(first, tsk);
+
+	if (first->signal->group_exit_code)
+		stats->ac_exitcode = first->signal->group_exit_code;
 
 	unlock_task_sighand(first, &flags);
 	rc = 0;
 out:
 	rcu_read_unlock();
-
-	stats->version = TASKSTATS_VERSION;
-	/*
-	 * Accounting subsytems can also add calls here to modify
-	 * fields of taskstats.
-	 */
 	return rc;
 }
 
@@ -275,19 +315,14 @@ static void fill_tgid_exit(struct task_s
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	if (!tsk->signal->stats)
-		goto ret;
 
 	/*
-	 * Each accounting subsystem calls its functions here to
-	 * accumalate its per-task stats for tsk, into the per-tgid structure
-	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
+	 * The fill_threadgroup() part of the statistics will be added by the
+	 * stats requester, i.e. fill_tgid()
 	 */
-	delayacct_add_tsk(tsk->signal->stats, tsk);
-ret:
+	add_tsk(tsk->signal->stats, tsk);
+
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
@@ -561,7 +596,7 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
-	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	fill_tgid(tsk->pid, tsk, stats);
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
diff -puN kernel/tsacct.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5 kernel/tsacct.c
--- a/kernel/tsacct.c~add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5
+++ a/kernel/tsacct.c
@@ -22,56 +22,70 @@
 #include <linux/acct.h>
 #include <linux/jiffies.h>
 
-/*
- * fill in basic accounting fields
- */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static void fill_wall_times(struct taskstats *stats, struct task_struct *task)
 {
 	struct timespec uptime, ts;
 	s64 ac_etime;
 
-	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
-
 	/* calculate task elapsed time in timespec */
 	do_posix_clock_monotonic_gettime(&uptime);
-	ts = timespec_sub(uptime, tsk->start_time);
+	ts = timespec_sub(uptime, task->start_time);
 	/* rebase elapsed time to usec */
 	ac_etime = timespec_to_ns(&ts);
 	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
-	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
-	if (tsk->flags & PF_SUPERPRIV)
-		stats->ac_flag |= ASU;
-	if (tsk->flags & PF_DUMPCORE)
-		stats->ac_flag |= ACORE;
-	if (tsk->flags & PF_SIGNALED)
-		stats->ac_flag |= AXSIG;
-	stats->ac_nice	 = task_nice(tsk);
-	stats->ac_sched	 = tsk->policy;
-	stats->ac_uid	 = tsk->uid;
-	stats->ac_gid	 = tsk->gid;
-	stats->ac_pid	 = tsk->pid;
+	stats->ac_etime	= ac_etime;
+	stats->ac_btime	= get_seconds() - ts.tv_sec;
+}
+
+/*
+ * fill in basic accounting fields
+ */
+
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{
+	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
+
 	rcu_read_lock();
-	stats->ac_ppid	 = pid_alive(tsk) ?
-				rcu_dereference(tsk->real_parent)->tgid : 0;
+	stats->ac_ppid	= pid_alive(task) ?
+				rcu_dereference(task->real_parent)->tgid : 0;
 	rcu_read_unlock();
-	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
-	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
-	stats->ac_utimescaled =
-		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
-	stats->ac_stimescaled =
-		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
-	stats->ac_minflt = tsk->min_flt;
-	stats->ac_majflt = tsk->maj_flt;
 
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	fill_wall_times(stats, task);
+
+	stats->ac_exitcode	= task->exit_code;
+	stats->ac_nice		= task_nice(task);
+	stats->ac_sched		= task->policy;
+	stats->ac_uid		= task->uid;
+	stats->ac_gid		= task->gid;
+	stats->ac_pid		= task->pid;
+
+	strncpy(stats->ac_comm, task->comm, sizeof(stats->ac_comm));
 }
 
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
+{
+	if (task->flags & PF_SUPERPRIV)
+		stats->ac_flag |= ASU;
+	if (task->flags & PF_DUMPCORE)
+		stats->ac_flag |= ACORE;
+	if (task->flags & PF_SIGNALED)
+		stats->ac_flag |= AXSIG;
+	if (thread_group_leader(task) && (task->flags & PF_FORKNOEXEC))
+		/*
+		 * Threads are created by do_fork() and don't exec but not in
+		 * the AFORK sense, as the latter involves fork(2).
+		 */
+		stats->ac_flag |= AFORK;
+
+	stats->ac_utimescaled +=
+		cputime_to_msecs(task->utimescaled) * USEC_PER_MSEC;
+	stats->ac_stimescaled +=
+		cputime_to_msecs(task->stimescaled) * USEC_PER_MSEC;
+	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
+	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
+	stats->ac_minflt += task->min_flt;
+	stats->ac_majflt += task->maj_flt;
+}
 
 #ifdef CONFIG_TASK_XACCT
 
@@ -80,32 +94,34 @@ void bacct_add_tsk(struct taskstats *sta
 /*
  * fill in extended accounting fields
  */
-void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
 {
 	struct mm_struct *mm;
 
-	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
-	mm = get_task_mm(p);
+	mm = get_task_mm(task);
 	if (mm) {
 		/* adjust to KB unit */
 		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
-		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
+		stats->hiwater_vm    = mm->hiwater_vm  * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
+}
+
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
+{
+	/* convert pages-jiffies to Mbyte-usec */
+	stats->coremem	+= jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem	+= jiffies_to_usecs(p->acct_vm_mem1)  * PAGE_SIZE / MB;
+
+	stats->read_char	+= p->rchar;
+	stats->write_char	+= p->wchar;
+	stats->read_syscalls	+= p->syscr;
+	stats->write_syscalls	+= p->syscw;
+
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
-#else
-	stats->read_bytes	= 0;
-	stats->write_bytes	= 0;
-	stats->cancelled_write_bytes = 0;
+	stats->read_bytes		+= p->ioac.read_bytes;
+	stats->write_bytes		+= p->ioac.write_bytes;
+	stats->cancelled_write_bytes	+= p->ioac.cancelled_write_bytes;
 #endif
 }
 #undef KB
_

Patches currently in -mm which might be from guichaz@yahoo.fr are

sync_sb_inodes-propagate-errors.patch
add-all-thread-stats-for-taskstats_cmd_attr_tgid-v5.patch
