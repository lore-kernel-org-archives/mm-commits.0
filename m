From: akpm@linux-foundation.org
Subject: [merged] proc-remove-use-of-seq_printf-return-value.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:55:35 -0700
Message-ID: <552fe987.JYqh+qVRhQCt0wld%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbbDPQuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     proc-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -632,7 +632,9 @@ static int children_seq_show(struct seq_
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

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

