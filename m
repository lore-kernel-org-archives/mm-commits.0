From: akpm@linux-foundation.org
Subject: [patch 109/127] seq/proc: modify seq_put_decimal_[u]ll to take a
 const char *, not char
Date: Fri, 07 Oct 2016 17:02:20 -0700
Message-ID: <57f8378c.n9wJEoV/D2Jhtufh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39589 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753618AbcJHACW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com, andi@firstfloor.org, viro@zeniv.linux.org.uk

From: Joe Perches <joe@perches.com>
Subject: seq/proc: modify seq_put_decimal_[u]ll to take a const char *, not char

Allow some seq_puts removals by taking a string instead of a single char.

[akpm@linux-foundation.org: update vmstat_show(), per Joe]
Link: http://lkml.kernel.org/r/667e1cf3d436de91a5698170a1e98d882905e956.1470704995.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c          |  178 +++++++++++++++++--------------------
 fs/proc/stat.c           |   49 ++++------
 fs/seq_file.c            |   57 +++++++++--
 include/linux/seq_file.h |    4 
 mm/vmstat.c              |    2 
 5 files changed, 154 insertions(+), 136 deletions(-)

diff -puN fs/proc/array.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char fs/proc/array.c
--- a/fs/proc/array.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char
+++ a/fs/proc/array.c
@@ -188,33 +188,26 @@ static inline void task_state(struct seq
 
 	seq_printf(m, "State:\t%s", get_task_state(p));
 
-	seq_puts(m, "\nTgid:\t");
-	seq_put_decimal_ull(m, 0, tgid);
-	seq_puts(m, "\nNgid:\t");
-	seq_put_decimal_ull(m, 0, ngid);
-	seq_puts(m, "\nPid:\t");
-	seq_put_decimal_ull(m, 0, pid_nr_ns(pid, ns));
-	seq_puts(m, "\nPPid:\t");
-	seq_put_decimal_ull(m, 0, ppid);
-	seq_puts(m, "\nTracerPid:\t");
-	seq_put_decimal_ull(m, 0, tpid);
-	seq_puts(m, "\nUid:");
-	seq_put_decimal_ull(m, '\t', from_kuid_munged(user_ns, cred->uid));
-	seq_put_decimal_ull(m, '\t', from_kuid_munged(user_ns, cred->euid));
-	seq_put_decimal_ull(m, '\t', from_kuid_munged(user_ns, cred->suid));
-	seq_put_decimal_ull(m, '\t', from_kuid_munged(user_ns, cred->fsuid));
-	seq_puts(m, "\nGid:");
-	seq_put_decimal_ull(m, '\t', from_kgid_munged(user_ns, cred->gid));
-	seq_put_decimal_ull(m, '\t', from_kgid_munged(user_ns, cred->egid));
-	seq_put_decimal_ull(m, '\t', from_kgid_munged(user_ns, cred->sgid));
-	seq_put_decimal_ull(m, '\t', from_kgid_munged(user_ns, cred->fsgid));
-	seq_puts(m, "\nFDSize:\t");
-	seq_put_decimal_ull(m, 0, max_fds);
+	seq_put_decimal_ull(m, "\nTgid:\t", tgid);
+	seq_put_decimal_ull(m, "\nNgid:\t", ngid);
+	seq_put_decimal_ull(m, "\nPid:\t", pid_nr_ns(pid, ns));
+	seq_put_decimal_ull(m, "\nPPid:\t", ppid);
+	seq_put_decimal_ull(m, "\nTracerPid:\t", tpid);
+	seq_put_decimal_ull(m, "\nUid:\t", from_kuid_munged(user_ns, cred->uid));
+	seq_put_decimal_ull(m, "\t", from_kuid_munged(user_ns, cred->euid));
+	seq_put_decimal_ull(m, "\t", from_kuid_munged(user_ns, cred->suid));
+	seq_put_decimal_ull(m, "\t", from_kuid_munged(user_ns, cred->fsuid));
+	seq_put_decimal_ull(m, "\nGid:\t", from_kgid_munged(user_ns, cred->gid));
+	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->egid));
+	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->sgid));
+	seq_put_decimal_ull(m, "\t", from_kgid_munged(user_ns, cred->fsgid));
+	seq_put_decimal_ull(m, "\nFDSize:\t", max_fds);
 
 	seq_puts(m, "\nGroups:\t");
 	group_info = cred->group_info;
 	for (g = 0; g < group_info->ngroups; g++)
-		seq_put_decimal_ull(m, g ? ' ' : 0, from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
+		seq_put_decimal_ull(m, g ? " " : "",
+				    from_kgid_munged(user_ns, GROUP_AT(group_info, g)));
 	put_cred(cred);
 	/* Trailing space shouldn't have been added in the first place. */
 	seq_putc(m, ' ');
@@ -222,16 +215,16 @@ static inline void task_state(struct seq
 #ifdef CONFIG_PID_NS
 	seq_puts(m, "\nNStgid:");
 	for (g = ns->level; g <= pid->level; g++)
-		seq_put_decimal_ull(m, '\t', task_tgid_nr_ns(p, pid->numbers[g].ns));
+		seq_put_decimal_ull(m, "\t", task_tgid_nr_ns(p, pid->numbers[g].ns));
 	seq_puts(m, "\nNSpid:");
 	for (g = ns->level; g <= pid->level; g++)
-		seq_put_decimal_ull(m, '\t', task_pid_nr_ns(p, pid->numbers[g].ns));
+		seq_put_decimal_ull(m, "\t", task_pid_nr_ns(p, pid->numbers[g].ns));
 	seq_puts(m, "\nNSpgid:");
 	for (g = ns->level; g <= pid->level; g++)
-		seq_put_decimal_ull(m, '\t', task_pgrp_nr_ns(p, pid->numbers[g].ns));
+		seq_put_decimal_ull(m, "\t", task_pgrp_nr_ns(p, pid->numbers[g].ns));
 	seq_puts(m, "\nNSsid:");
 	for (g = ns->level; g <= pid->level; g++)
-		seq_put_decimal_ull(m, '\t', task_session_nr_ns(p, pid->numbers[g].ns));
+		seq_put_decimal_ull(m, "\t", task_session_nr_ns(p, pid->numbers[g].ns));
 #endif
 	seq_putc(m, '\n');
 }
@@ -300,11 +293,9 @@ static inline void task_sig(struct seq_f
 		unlock_task_sighand(p, &flags);
 	}
 
-	seq_puts(m, "Threads:\t");
-	seq_put_decimal_ull(m, 0, num_threads);
-	seq_puts(m, "\nSigQ:\t");
-	seq_put_decimal_ull(m, 0, qsize);
-	seq_put_decimal_ull(m, '/', qlim);
+	seq_put_decimal_ull(m, "Threads:\t", num_threads);
+	seq_put_decimal_ull(m, "\nSigQ:\t", qsize);
+	seq_put_decimal_ull(m, "/", qlim);
 
 	/* render them all */
 	render_sigset_t(m, "\nSigPnd:\t", &pending);
@@ -352,8 +343,7 @@ static inline void task_cap(struct seq_f
 static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
 {
 #ifdef CONFIG_SECCOMP
-	seq_puts(m, "Seccomp:\t");
-	seq_put_decimal_ull(m, 0, p->seccomp.mode);
+	seq_put_decimal_ull(m, "Seccomp:\t", p->seccomp.mode);
 	seq_putc(m, '\n');
 #endif
 }
@@ -361,10 +351,8 @@ static inline void task_seccomp(struct s
 static inline void task_context_switch_counts(struct seq_file *m,
 						struct task_struct *p)
 {
-	seq_puts(m, "voluntary_ctxt_switches:\t");
-	seq_put_decimal_ull(m, 0, p->nvcsw);
-	seq_puts(m, "\nnonvoluntary_ctxt_switches:\t");
-	seq_put_decimal_ull(m, 0, p->nivcsw);
+	seq_put_decimal_ull(m, "voluntary_ctxt_switches:\t", p->nvcsw);
+	seq_put_decimal_ull(m, "\nnonvoluntary_ctxt_switches:\t", p->nivcsw);
 	seq_putc(m, '\n');
 }
 
@@ -497,41 +485,41 @@ static int do_task_stat(struct seq_file
 	start_time = nsec_to_clock_t(task->real_start_time);
 
 	seq_printf(m, "%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
-	seq_put_decimal_ll(m, ' ', ppid);
-	seq_put_decimal_ll(m, ' ', pgid);
-	seq_put_decimal_ll(m, ' ', sid);
-	seq_put_decimal_ll(m, ' ', tty_nr);
-	seq_put_decimal_ll(m, ' ', tty_pgrp);
-	seq_put_decimal_ull(m, ' ', task->flags);
-	seq_put_decimal_ull(m, ' ', min_flt);
-	seq_put_decimal_ull(m, ' ', cmin_flt);
-	seq_put_decimal_ull(m, ' ', maj_flt);
-	seq_put_decimal_ull(m, ' ', cmaj_flt);
-	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(utime));
-	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(stime));
-	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cutime));
-	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cstime));
-	seq_put_decimal_ll(m, ' ', priority);
-	seq_put_decimal_ll(m, ' ', nice);
-	seq_put_decimal_ll(m, ' ', num_threads);
-	seq_put_decimal_ull(m, ' ', 0);
-	seq_put_decimal_ull(m, ' ', start_time);
-	seq_put_decimal_ull(m, ' ', vsize);
-	seq_put_decimal_ull(m, ' ', mm ? get_mm_rss(mm) : 0);
-	seq_put_decimal_ull(m, ' ', rsslim);
-	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->start_code : 1) : 0);
-	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->end_code : 1) : 0);
-	seq_put_decimal_ull(m, ' ', (permitted && mm) ? mm->start_stack : 0);
-	seq_put_decimal_ull(m, ' ', esp);
-	seq_put_decimal_ull(m, ' ', eip);
+	seq_put_decimal_ll(m, " ", ppid);
+	seq_put_decimal_ll(m, " ", pgid);
+	seq_put_decimal_ll(m, " ", sid);
+	seq_put_decimal_ll(m, " ", tty_nr);
+	seq_put_decimal_ll(m, " ", tty_pgrp);
+	seq_put_decimal_ull(m, " ", task->flags);
+	seq_put_decimal_ull(m, " ", min_flt);
+	seq_put_decimal_ull(m, " ", cmin_flt);
+	seq_put_decimal_ull(m, " ", maj_flt);
+	seq_put_decimal_ull(m, " ", cmaj_flt);
+	seq_put_decimal_ull(m, " ", cputime_to_clock_t(utime));
+	seq_put_decimal_ull(m, " ", cputime_to_clock_t(stime));
+	seq_put_decimal_ll(m, " ", cputime_to_clock_t(cutime));
+	seq_put_decimal_ll(m, " ", cputime_to_clock_t(cstime));
+	seq_put_decimal_ll(m, " ", priority);
+	seq_put_decimal_ll(m, " ", nice);
+	seq_put_decimal_ll(m, " ", num_threads);
+	seq_put_decimal_ull(m, " ", 0);
+	seq_put_decimal_ull(m, " ", start_time);
+	seq_put_decimal_ull(m, " ", vsize);
+	seq_put_decimal_ull(m, " ", mm ? get_mm_rss(mm) : 0);
+	seq_put_decimal_ull(m, " ", rsslim);
+	seq_put_decimal_ull(m, " ", mm ? (permitted ? mm->start_code : 1) : 0);
+	seq_put_decimal_ull(m, " ", mm ? (permitted ? mm->end_code : 1) : 0);
+	seq_put_decimal_ull(m, " ", (permitted && mm) ? mm->start_stack : 0);
+	seq_put_decimal_ull(m, " ", esp);
+	seq_put_decimal_ull(m, " ", eip);
 	/* The signal information here is obsolete.
 	 * It must be decimal for Linux 2.0 compatibility.
 	 * Use /proc/#/status for real-time signals.
 	 */
-	seq_put_decimal_ull(m, ' ', task->pending.signal.sig[0] & 0x7fffffffUL);
-	seq_put_decimal_ull(m, ' ', task->blocked.sig[0] & 0x7fffffffUL);
-	seq_put_decimal_ull(m, ' ', sigign.sig[0] & 0x7fffffffUL);
-	seq_put_decimal_ull(m, ' ', sigcatch.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, " ", task->pending.signal.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, " ", task->blocked.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, " ", sigign.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, " ", sigcatch.sig[0] & 0x7fffffffUL);
 
 	/*
 	 * We used to output the absolute kernel address, but that's an
@@ -545,31 +533,31 @@ static int do_task_stat(struct seq_file
 	else
 		seq_puts(m, " 0");
 
-	seq_put_decimal_ull(m, ' ', 0);
-	seq_put_decimal_ull(m, ' ', 0);
-	seq_put_decimal_ll(m, ' ', task->exit_signal);
-	seq_put_decimal_ll(m, ' ', task_cpu(task));
-	seq_put_decimal_ull(m, ' ', task->rt_priority);
-	seq_put_decimal_ull(m, ' ', task->policy);
-	seq_put_decimal_ull(m, ' ', delayacct_blkio_ticks(task));
-	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(gtime));
-	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cgtime));
+	seq_put_decimal_ull(m, " ", 0);
+	seq_put_decimal_ull(m, " ", 0);
+	seq_put_decimal_ll(m, " ", task->exit_signal);
+	seq_put_decimal_ll(m, " ", task_cpu(task));
+	seq_put_decimal_ull(m, " ", task->rt_priority);
+	seq_put_decimal_ull(m, " ", task->policy);
+	seq_put_decimal_ull(m, " ", delayacct_blkio_ticks(task));
+	seq_put_decimal_ull(m, " ", cputime_to_clock_t(gtime));
+	seq_put_decimal_ll(m, " ", cputime_to_clock_t(cgtime));
 
 	if (mm && permitted) {
-		seq_put_decimal_ull(m, ' ', mm->start_data);
-		seq_put_decimal_ull(m, ' ', mm->end_data);
-		seq_put_decimal_ull(m, ' ', mm->start_brk);
-		seq_put_decimal_ull(m, ' ', mm->arg_start);
-		seq_put_decimal_ull(m, ' ', mm->arg_end);
-		seq_put_decimal_ull(m, ' ', mm->env_start);
-		seq_put_decimal_ull(m, ' ', mm->env_end);
+		seq_put_decimal_ull(m, " ", mm->start_data);
+		seq_put_decimal_ull(m, " ", mm->end_data);
+		seq_put_decimal_ull(m, " ", mm->start_brk);
+		seq_put_decimal_ull(m, " ", mm->arg_start);
+		seq_put_decimal_ull(m, " ", mm->arg_end);
+		seq_put_decimal_ull(m, " ", mm->env_start);
+		seq_put_decimal_ull(m, " ", mm->env_end);
 	} else
-		seq_printf(m, " 0 0 0 0 0 0 0");
+		seq_puts(m, " 0 0 0 0 0 0 0");
 
 	if (permitted)
-		seq_put_decimal_ll(m, ' ', task->exit_code);
+		seq_put_decimal_ll(m, " ", task->exit_code);
 	else
-		seq_put_decimal_ll(m, ' ', 0);
+		seq_puts(m, " 0");
 
 	seq_putc(m, '\n');
 	if (mm)
@@ -605,13 +593,13 @@ int proc_pid_statm(struct seq_file *m, s
 	 * seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
 	 *               size, resident, shared, text, data);
 	 */
-	seq_put_decimal_ull(m, 0, size);
-	seq_put_decimal_ull(m, ' ', resident);
-	seq_put_decimal_ull(m, ' ', shared);
-	seq_put_decimal_ull(m, ' ', text);
-	seq_put_decimal_ull(m, ' ', 0);
-	seq_put_decimal_ull(m, ' ', data);
-	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ull(m, "", size);
+	seq_put_decimal_ull(m, " ", resident);
+	seq_put_decimal_ull(m, " ", shared);
+	seq_put_decimal_ull(m, " ", text);
+	seq_put_decimal_ull(m, " ", 0);
+	seq_put_decimal_ull(m, " ", data);
+	seq_put_decimal_ull(m, " ", 0);
 	seq_putc(m, '\n');
 
 	return 0;
diff -puN fs/proc/stat.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char fs/proc/stat.c
--- a/fs/proc/stat.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char
+++ a/fs/proc/stat.c
@@ -115,17 +115,16 @@ static int show_stat(struct seq_file *p,
 	}
 	sum += arch_irq_stat();
 
-	seq_puts(p, "cpu ");
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
-	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+	seq_put_decimal_ull(p, "cpu  ", cputime64_to_clock_t(user));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(nice));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(system));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(idle));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(iowait));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(irq));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(softirq));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(steal));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(guest));
+	seq_put_decimal_ull(p, " ", cputime64_to_clock_t(guest_nice));
 	seq_putc(p, '\n');
 
 	for_each_online_cpu(i) {
@@ -141,23 +140,23 @@ static int show_stat(struct seq_file *p,
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
 		seq_printf(p, "cpu%d", i);
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
-		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(user));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(nice));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(system));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(idle));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(iowait));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(irq));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(softirq));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(steal));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(guest));
+		seq_put_decimal_ull(p, " ", cputime64_to_clock_t(guest_nice));
 		seq_putc(p, '\n');
 	}
-	seq_printf(p, "intr %llu", (unsigned long long)sum);
+	seq_put_decimal_ull(p, "intr ", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j)
-		seq_put_decimal_ull(p, ' ', kstat_irqs_usr(j));
+		seq_put_decimal_ull(p, " ", kstat_irqs_usr(j));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -171,10 +170,10 @@ static int show_stat(struct seq_file *p,
 		nr_running(),
 		nr_iowait());
 
-	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
+	seq_put_decimal_ull(p, "softirq ", (unsigned long long)sum_softirq);
 
 	for (i = 0; i < NR_SOFTIRQS; i++)
-		seq_put_decimal_ull(p, ' ', per_softirq_sums[i]);
+		seq_put_decimal_ull(p, " ", per_softirq_sums[i]);
 	seq_putc(p, '\n');
 
 	return 0;
diff -puN fs/seq_file.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char fs/seq_file.c
--- a/fs/seq_file.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char
+++ a/fs/seq_file.c
@@ -679,11 +679,11 @@ EXPORT_SYMBOL(seq_puts);
 /*
  * A helper routine for putting decimal numbers without rich format of printf().
  * only 'unsigned long long' is supported.
- * This routine will put one byte delimiter + number into seq_file.
+ * This routine will put strlen(delimiter) + number into seq_file.
  * This routine is very quick when you show lots of numbers.
  * In usual cases, it will be better to use seq_printf(). It's easier to read.
  */
-void seq_put_decimal_ull(struct seq_file *m, char delimiter,
+void seq_put_decimal_ull(struct seq_file *m, const char *delimiter,
 			 unsigned long long num)
 {
 	int len;
@@ -691,8 +691,15 @@ void seq_put_decimal_ull(struct seq_file
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	if (delimiter)
-		m->buf[m->count++] = delimiter;
+	len = strlen(delimiter);
+	if (m->count + len >= m->size)
+		goto overflow;
+
+	memcpy(m->buf + m->count, delimiter, len);
+	m->count += len;
+
+	if (m->count + 1 >= m->size)
+		goto overflow;
 
 	if (num < 10) {
 		m->buf[m->count++] = num + '0';
@@ -702,6 +709,7 @@ void seq_put_decimal_ull(struct seq_file
 	len = num_to_str(m->buf + m->count, m->size - m->count, num);
 	if (!len)
 		goto overflow;
+
 	m->count += len;
 	return;
 
@@ -710,19 +718,42 @@ overflow:
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
 
-void seq_put_decimal_ll(struct seq_file *m, char delimiter, long long num)
+void seq_put_decimal_ll(struct seq_file *m, const char *delimiter, long long num)
 {
+	int len;
+
+	if (m->count + 3 >= m->size) /* we'll write 2 bytes at least */
+		goto overflow;
+
+	len = strlen(delimiter);
+	if (m->count + len >= m->size)
+		goto overflow;
+
+	memcpy(m->buf + m->count, delimiter, len);
+	m->count += len;
+
+	if (m->count + 2 >= m->size)
+		goto overflow;
+
 	if (num < 0) {
-		if (m->count + 3 >= m->size) {
-			seq_set_overflow(m);
-			return;
-		}
-		if (delimiter)
-			m->buf[m->count++] = delimiter;
+		m->buf[m->count++] = '-';
 		num = -num;
-		delimiter = '-';
 	}
-	seq_put_decimal_ull(m, delimiter, num);
+
+	if (num < 10) {
+		m->buf[m->count++] = num + '0';
+		return;
+	}
+
+	len = num_to_str(m->buf + m->count, m->size - m->count, num);
+	if (!len)
+		goto overflow;
+
+	m->count += len;
+	return;
+
+overflow:
+	seq_set_overflow(m);
 }
 EXPORT_SYMBOL(seq_put_decimal_ll);
 
diff -puN include/linux/seq_file.h~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char include/linux/seq_file.h
--- a/include/linux/seq_file.h~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char
+++ a/include/linux/seq_file.h
@@ -117,9 +117,9 @@ __printf(2, 3)
 void seq_printf(struct seq_file *m, const char *fmt, ...);
 void seq_putc(struct seq_file *m, char c);
 void seq_puts(struct seq_file *m, const char *s);
-void seq_put_decimal_ull(struct seq_file *m, char delimiter,
+void seq_put_decimal_ull(struct seq_file *m, const char *delimiter,
 			 unsigned long long num);
-void seq_put_decimal_ll(struct seq_file *m, char delimiter, long long num);
+void seq_put_decimal_ll(struct seq_file *m, const char *delimiter, long long num);
 void seq_escape(struct seq_file *m, const char *s, const char *esc);
 
 void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
diff -puN mm/vmstat.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char mm/vmstat.c
--- a/mm/vmstat.c~seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char
+++ a/mm/vmstat.c
@@ -1515,7 +1515,7 @@ static int vmstat_show(struct seq_file *
 	unsigned long off = l - (unsigned long *)m->private;
 
 	seq_puts(m, vmstat_text[off]);
-	seq_put_decimal_ull(m, ' ', *l);
+	seq_put_decimal_ull(m, " ", *l);
 	seq_putc(m, '\n');
 	return 0;
 }
_
