From: akpm@linux-foundation.org
Subject: - distinct-tgid-tid-i-o-statistics.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:03:09 -0700
Message-ID: <200807252303.m6PN39ZC003931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbYGYXEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: righi.andrea@gmail.com, balbir@linux.vnet.ibm.com, matt@hostmonster.com, nagar@watson.ibm.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     task IO accounting: provide distinct tgid/tid I/O statistics
has been removed from the -mm tree.  Its filename was
     distinct-tgid-tid-i-o-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: task IO accounting: provide distinct tgid/tid I/O statistics
From: Andrea Righi <righi.andrea@gmail.com>

Report per-thread I/O statistics in /proc/pid/task/tid/io and aggregate
parent I/O statistics in /proc/pid/io.  This approach follows the same
model used to account per-process and per-thread CPU times.

As a practial application, this allows for example to quickly find the top
I/O consumer when a process spawns many child threads that perform the
actual I/O work, because the aggregated I/O statistics can always be found
in /proc/pid/io.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: Matt Heaton <matt@hostmonster.com>
Cc: Shailabh Nagar <nagar@watson.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c        |   84 +++++++++++++++++++++++++++++++++-------
 include/linux/sched.h |    4 +
 kernel/exit.c         |   27 ++++++++++++
 kernel/fork.c         |    6 ++
 4 files changed, 107 insertions(+), 14 deletions(-)

diff -puN fs/proc/base.c~distinct-tgid-tid-i-o-statistics fs/proc/base.c
--- a/fs/proc/base.c~distinct-tgid-tid-i-o-statistics
+++ a/fs/proc/base.c
@@ -2376,29 +2376,82 @@ static int proc_base_fill_cache(struct f
 }
 
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-static int proc_pid_io_accounting(struct task_struct *task, char *buffer)
+static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
 {
+	u64 rchar, wchar, syscr, syscw;
+	struct task_io_accounting ioac;
+
+	if (!whole) {
+		rchar = task->rchar;
+		wchar = task->wchar;
+		syscr = task->syscr;
+		syscw = task->syscw;
+		memcpy(&ioac, &task->ioac, sizeof(ioac));
+	} else {
+		unsigned long flags;
+		struct task_struct *t = task;
+		rchar = wchar = syscr = syscw = 0;
+		memset(&ioac, 0, sizeof(ioac));
+
+		rcu_read_lock();
+		do {
+			rchar += t->rchar;
+			wchar += t->wchar;
+			syscr += t->syscr;
+			syscw += t->syscw;
+
+			ioac.read_bytes += t->ioac.read_bytes;
+			ioac.write_bytes += t->ioac.write_bytes;
+			ioac.cancelled_write_bytes +=
+					t->ioac.cancelled_write_bytes;
+			t = next_thread(t);
+		} while (t != task);
+		rcu_read_unlock();
+
+		if (lock_task_sighand(task, &flags)) {
+			struct signal_struct *sig = task->signal;
+
+			rchar += sig->rchar;
+			wchar += sig->wchar;
+			syscr += sig->syscr;
+			syscw += sig->syscw;
+
+			ioac.read_bytes += sig->ioac.read_bytes;
+			ioac.write_bytes += sig->ioac.write_bytes;
+			ioac.cancelled_write_bytes +=
+					sig->ioac.cancelled_write_bytes;
+
+			unlock_task_sighand(task, &flags);
+		}
+	}
+
 	return sprintf(buffer,
-#ifdef CONFIG_TASK_XACCT
 			"rchar: %llu\n"
 			"wchar: %llu\n"
 			"syscr: %llu\n"
 			"syscw: %llu\n"
-#endif
 			"read_bytes: %llu\n"
 			"write_bytes: %llu\n"
 			"cancelled_write_bytes: %llu\n",
-#ifdef CONFIG_TASK_XACCT
-			(unsigned long long)task->rchar,
-			(unsigned long long)task->wchar,
-			(unsigned long long)task->syscr,
-			(unsigned long long)task->syscw,
-#endif
-			(unsigned long long)task->ioac.read_bytes,
-			(unsigned long long)task->ioac.write_bytes,
-			(unsigned long long)task->ioac.cancelled_write_bytes);
+			(unsigned long long)rchar,
+			(unsigned long long)wchar,
+			(unsigned long long)syscr,
+			(unsigned long long)syscw,
+			(unsigned long long)ioac.read_bytes,
+			(unsigned long long)ioac.write_bytes,
+			(unsigned long long)ioac.cancelled_write_bytes);
+}
+
+static int proc_tid_io_accounting(struct task_struct *task, char *buffer)
+{
+	return do_io_accounting(task, buffer, 0);
 }
-#endif
+
+static int proc_tgid_io_accounting(struct task_struct *task, char *buffer)
+{
+	return do_io_accounting(task, buffer, 1);
+}
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
 
 /*
  * Thread groups
@@ -2470,7 +2523,7 @@ static const struct pid_entry tgid_base_
 	REG("coredump_filter", S_IRUGO|S_IWUSR, coredump_filter),
 #endif
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	INF("io",	S_IRUGO, pid_io_accounting),
+	INF("io",	S_IRUGO, tgid_io_accounting),
 #endif
 };
 
@@ -2797,6 +2850,9 @@ static const struct pid_entry tid_base_s
 #ifdef CONFIG_FAULT_INJECTION
 	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
 #endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	INF("io",	S_IRUGO, tid_io_accounting),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file * filp,
diff -puN include/linux/sched.h~distinct-tgid-tid-i-o-statistics include/linux/sched.h
--- a/include/linux/sched.h~distinct-tgid-tid-i-o-statistics
+++ a/include/linux/sched.h
@@ -506,6 +506,10 @@ struct signal_struct {
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
 	unsigned long min_flt, maj_flt, cmin_flt, cmaj_flt;
 	unsigned long inblock, oublock, cinblock, coublock;
+#ifdef CONFIG_TASK_XACCT
+	u64 rchar, wchar, syscr, syscw;
+#endif
+	struct task_io_accounting ioac;
 
 	/*
 	 * Cumulative ns of scheduled CPU time for dead threads in the
diff -puN kernel/exit.c~distinct-tgid-tid-i-o-statistics kernel/exit.c
--- a/kernel/exit.c~distinct-tgid-tid-i-o-statistics
+++ a/kernel/exit.c
@@ -120,6 +120,18 @@ static void __exit_signal(struct task_st
 		sig->nivcsw += tsk->nivcsw;
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
+#ifdef CONFIG_TASK_XACCT
+		sig->rchar += tsk->rchar;
+		sig->wchar += tsk->wchar;
+		sig->syscr += tsk->syscr;
+		sig->syscw += tsk->syscw;
+#endif /* CONFIG_TASK_XACCT */
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+		sig->ioac.read_bytes += tsk->ioac.read_bytes;
+		sig->ioac.write_bytes += tsk->ioac.write_bytes;
+		sig->ioac.cancelled_write_bytes +=
+					tsk->ioac.cancelled_write_bytes;
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
 		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
@@ -1366,6 +1378,21 @@ static int wait_task_zombie(struct task_
 		psig->coublock +=
 			task_io_get_oublock(p) +
 			sig->oublock + sig->coublock;
+#ifdef CONFIG_TASK_XACCT
+		psig->rchar += p->rchar + sig->rchar;
+		psig->wchar += p->wchar + sig->wchar;
+		psig->syscr += p->syscr + sig->syscr;
+		psig->syscw += p->syscw + sig->syscw;
+#endif /* CONFIG_TASK_XACCT */
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+		psig->ioac.read_bytes +=
+			p->ioac.read_bytes + sig->ioac.read_bytes;
+		psig->ioac.write_bytes +=
+			p->ioac.write_bytes + sig->ioac.write_bytes;
+		psig->ioac.cancelled_write_bytes +=
+				p->ioac.cancelled_write_bytes +
+				sig->ioac.cancelled_write_bytes;
+#endif /* CONFIG_TASK_IO_ACCOUNTING */
 		spin_unlock_irq(&p->parent->sighand->siglock);
 	}
 
diff -puN kernel/fork.c~distinct-tgid-tid-i-o-statistics kernel/fork.c
--- a/kernel/fork.c~distinct-tgid-tid-i-o-statistics
+++ a/kernel/fork.c
@@ -812,6 +812,12 @@ static int copy_signal(unsigned long clo
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
 	sig->min_flt = sig->maj_flt = sig->cmin_flt = sig->cmaj_flt = 0;
 	sig->inblock = sig->oublock = sig->cinblock = sig->coublock = 0;
+#ifdef CONFIG_TASK_XACCT
+	sig->rchar = sig->wchar = sig->syscr = sig->syscw = 0;
+#endif
+#ifdef CONFIG_TASK_IO_ACCOUNTING
+	memset(&sig->ioac, 0, sizeof(sig->ioac));
+#endif
 	sig->sum_sched_runtime = 0;
 	INIT_LIST_HEAD(&sig->cpu_timers[0]);
 	INIT_LIST_HEAD(&sig->cpu_timers[1]);
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

origin.patch

