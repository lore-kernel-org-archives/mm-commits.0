From: akpm@linux-foundation.org
Subject: + proc-remove-use-of-seq_printf-return-value.patch added to -mm
 tree
Date: Mon, 23 Feb 2015 15:59:14 -0800
Message-ID: <54ebbed2.tw31BIl8l9WTDqe2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbBWX7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:59:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     proc-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: proc: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    4 +-
 fs/proc/base.c  |   82 ++++++++++++++++++++++++++--------------------
 2 files changed, 50 insertions(+), 36 deletions(-)

diff -puN fs/proc/array.c~proc-remove-use-of-seq_printf-return-value fs/proc/array.c
--- a/fs/proc/array.c~proc-remove-use-of-seq_printf-return-value
+++ a/fs/proc/array.c
@@ -630,7 +630,9 @@ static int children_seq_show(struct seq_
 	pid_t pid;
 
 	pid = pid_nr_ns(v, inode->i_sb->s_fs_info);
-	return seq_printf(seq, "%d ", pid);
+	seq_printf(seq, "%d ", pid);
+
+	return 0;
 }
 
 static void *children_seq_start(struct seq_file *seq, loff_t *pos)
diff -puN fs/proc/base.c~proc-remove-use-of-seq_printf-return-value fs/proc/base.c
--- a/fs/proc/base.c~proc-remove-use-of-seq_printf-return-value
+++ a/fs/proc/base.c
@@ -238,13 +238,15 @@ static int proc_pid_wchan(struct seq_fil
 
 	wchan = get_wchan(task);
 
-	if (lookup_symbol_name(wchan, symname) < 0)
+	if (lookup_symbol_name(wchan, symname) < 0) {
 		if (!ptrace_may_access(task, PTRACE_MODE_READ))
 			return 0;
-		else
-			return seq_printf(m, "%lu", wchan);
-	else
-		return seq_printf(m, "%s", symname);
+		seq_printf(m, "%lu", wchan);
+	} else {
+		seq_printf(m, "%s", symname);
+	}
+
+	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
 
@@ -309,10 +311,12 @@ static int proc_pid_stack(struct seq_fil
 static int proc_pid_schedstat(struct seq_file *m, struct pid_namespace *ns,
 			      struct pid *pid, struct task_struct *task)
 {
-	return seq_printf(m, "%llu %llu %lu\n",
-			(unsigned long long)task->se.sum_exec_runtime,
-			(unsigned long long)task->sched_info.run_delay,
-			task->sched_info.pcount);
+	seq_printf(m, "%llu %llu %lu\n",
+		   (unsigned long long)task->se.sum_exec_runtime,
+		   (unsigned long long)task->sched_info.run_delay,
+		   task->sched_info.pcount);
+
+	return 0;
 }
 #endif
 
@@ -387,7 +391,9 @@ static int proc_oom_score(struct seq_fil
 		points = oom_badness(task, NULL, NULL, totalpages) *
 						1000 / totalpages;
 	read_unlock(&tasklist_lock);
-	return seq_printf(m, "%lu\n", points);
+	seq_printf(m, "%lu\n", points);
+
+	return 0;
 }
 
 struct limit_names {
@@ -432,15 +438,15 @@ static int proc_pid_limits(struct seq_fi
 	 * print the file header
 	 */
        seq_printf(m, "%-25s %-20s %-20s %-10s\n",
-			"Limit", "Soft Limit", "Hard Limit", "Units");
+		  "Limit", "Soft Limit", "Hard Limit", "Units");
 
 	for (i = 0; i < RLIM_NLIMITS; i++) {
 		if (rlim[i].rlim_cur == RLIM_INFINITY)
 			seq_printf(m, "%-25s %-20s ",
-					 lnames[i].name, "unlimited");
+				   lnames[i].name, "unlimited");
 		else
 			seq_printf(m, "%-25s %-20lu ",
-					 lnames[i].name, rlim[i].rlim_cur);
+				   lnames[i].name, rlim[i].rlim_cur);
 
 		if (rlim[i].rlim_max == RLIM_INFINITY)
 			seq_printf(m, "%-20s ", "unlimited");
@@ -462,7 +468,9 @@ static int proc_pid_syscall(struct seq_f
 {
 	long nr;
 	unsigned long args[6], sp, pc;
-	int res = lock_trace(task);
+	int res;
+
+	res = lock_trace(task);
 	if (res)
 		return res;
 
@@ -477,7 +485,8 @@ static int proc_pid_syscall(struct seq_f
 		       args[0], args[1], args[2], args[3], args[4], args[5],
 		       sp, pc);
 	unlock_trace(task);
-	return res;
+
+	return 0;
 }
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
@@ -2002,12 +2011,13 @@ static int show_timer(struct seq_file *m
 	notify = timer->it_sigev_notify;
 
 	seq_printf(m, "ID: %d\n", timer->it_id);
-	seq_printf(m, "signal: %d/%p\n", timer->sigq->info.si_signo,
-			timer->sigq->info.si_value.sival_ptr);
+	seq_printf(m, "signal: %d/%p\n",
+		   timer->sigq->info.si_signo,
+		   timer->sigq->info.si_value.sival_ptr);
 	seq_printf(m, "notify: %s/%s.%d\n",
-		nstr[notify & ~SIGEV_THREAD_ID],
-		(notify & SIGEV_THREAD_ID) ? "tid" : "pid",
-		pid_nr_ns(timer->it_pid, tp->ns));
+		   nstr[notify & ~SIGEV_THREAD_ID],
+		   (notify & SIGEV_THREAD_ID) ? "tid" : "pid",
+		   pid_nr_ns(timer->it_pid, tp->ns));
 	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
@@ -2352,21 +2362,23 @@ static int do_io_accounting(struct task_
 
 		unlock_task_sighand(task, &flags);
 	}
-	result = seq_printf(m,
-			"rchar: %llu\n"
-			"wchar: %llu\n"
-			"syscr: %llu\n"
-			"syscw: %llu\n"
-			"read_bytes: %llu\n"
-			"write_bytes: %llu\n"
-			"cancelled_write_bytes: %llu\n",
-			(unsigned long long)acct.rchar,
-			(unsigned long long)acct.wchar,
-			(unsigned long long)acct.syscr,
-			(unsigned long long)acct.syscw,
-			(unsigned long long)acct.read_bytes,
-			(unsigned long long)acct.write_bytes,
-			(unsigned long long)acct.cancelled_write_bytes);
+	seq_printf(m,
+		   "rchar: %llu\n"
+		   "wchar: %llu\n"
+		   "syscr: %llu\n"
+		   "syscw: %llu\n"
+		   "read_bytes: %llu\n"
+		   "write_bytes: %llu\n"
+		   "cancelled_write_bytes: %llu\n",
+		   (unsigned long long)acct.rchar,
+		   (unsigned long long)acct.wchar,
+		   (unsigned long long)acct.syscr,
+		   (unsigned long long)acct.syscw,
+		   (unsigned long long)acct.read_bytes,
+		   (unsigned long long)acct.write_bytes,
+		   (unsigned long long)acct.cancelled_write_bytes);
+	result = 0;
+
 out_unlock:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 	return result;
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

