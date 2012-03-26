From: akpm@linux-foundation.org
Subject: [merged] procfs-add-num_to_str-to-speed-up-proc-stat.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:45 -0700
Message-ID: <20120326193245.DFF52A00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:58080 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2CZTcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:46 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so830938ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, andrea@betterlinux.com, eric.dumazet@gmail.com, glommer@parallels.com, mingo@elte.hu, pjt@google.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: add num_to_str() to speed up /proc/stat
has been removed from the -mm tree.  Its filename was
     procfs-add-num_to_str-to-speed-up-proc-stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: procfs: add num_to_str() to speed up /proc/stat

== stat_check.py
num = 0
with open("/proc/stat") as f:
        while num < 1000 :
                data = f.read()
                f.seek(0, 0)
                num = num + 1
==

perf shows

    20.39%  stat_check.py  [kernel.kallsyms]    [k] format_decode
    13.41%  stat_check.py  [kernel.kallsyms]    [k] number
    12.61%  stat_check.py  [kernel.kallsyms]    [k] vsnprintf
    10.85%  stat_check.py  [kernel.kallsyms]    [k] memcpy
     4.85%  stat_check.py  [kernel.kallsyms]    [k] radix_tree_lookup
     4.43%  stat_check.py  [kernel.kallsyms]    [k] seq_printf

This patch removes most of calls to vsnprintf() by adding
num_to_str() and seq_print_decimal_ull(), which prints decimal numbers
without rich functions provided by printf().

On my 8cpu box.
== Before patch ==
[root@bluextal test]# time ./stat_check.py

real    0m0.150s
user    0m0.026s
sys     0m0.121s

== After patch ==
[root@bluextal test]# time ./stat_check.py

real    0m0.055s
user    0m0.022s
sys     0m0.030s

[akpm@linux-foundation.org: remove incorrect comment, use less statck in num_to_str(), move comment from .h to .c, simplify seq_put_decimal_ull()]
[andrea@betterlinux.com: avoid breaking the ABI in /proc/stat]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Turner <pjt@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c           |   55 ++++++++++++++++++-------------------
 fs/seq_file.c            |   33 ++++++++++++++++++++++
 include/linux/kernel.h   |    2 +
 include/linux/seq_file.h |    3 +-
 lib/vsprintf.c           |   20 +++++++++++++
 5 files changed, 84 insertions(+), 29 deletions(-)

diff -puN fs/proc/stat.c~procfs-add-num_to_str-to-speed-up-proc-stat fs/proc/stat.c
--- a/fs/proc/stat.c~procfs-add-num_to_str-to-speed-up-proc-stat
+++ a/fs/proc/stat.c
@@ -89,18 +89,19 @@ static int show_stat(struct seq_file *p,
 	}
 	sum += arch_irq_stat();
 
-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-		"%llu\n",
-		(unsigned long long)cputime64_to_clock_t(user),
-		(unsigned long long)cputime64_to_clock_t(nice),
-		(unsigned long long)cputime64_to_clock_t(system),
-		(unsigned long long)cputime64_to_clock_t(idle),
-		(unsigned long long)cputime64_to_clock_t(iowait),
-		(unsigned long long)cputime64_to_clock_t(irq),
-		(unsigned long long)cputime64_to_clock_t(softirq),
-		(unsigned long long)cputime64_to_clock_t(steal),
-		(unsigned long long)cputime64_to_clock_t(guest),
-		(unsigned long long)cputime64_to_clock_t(guest_nice));
+	seq_puts(p, "cpu ");
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
+	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+	seq_putc(p, '\n');
+
 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
 		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
@@ -113,26 +114,24 @@ static int show_stat(struct seq_file *p,
 		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		seq_printf(p,
-			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
-			"%llu\n",
-			i,
-			(unsigned long long)cputime64_to_clock_t(user),
-			(unsigned long long)cputime64_to_clock_t(nice),
-			(unsigned long long)cputime64_to_clock_t(system),
-			(unsigned long long)cputime64_to_clock_t(idle),
-			(unsigned long long)cputime64_to_clock_t(iowait),
-			(unsigned long long)cputime64_to_clock_t(irq),
-			(unsigned long long)cputime64_to_clock_t(softirq),
-			(unsigned long long)cputime64_to_clock_t(steal),
-			(unsigned long long)cputime64_to_clock_t(guest),
-			(unsigned long long)cputime64_to_clock_t(guest_nice));
+		seq_printf(p, "cpu%d", i);
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
+		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
+		seq_putc(p, '\n');
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
 	/* sum again ? it could be updated? */
 	for_each_irq_nr(j)
-		seq_printf(p, " %u", kstat_irqs(j));
+		seq_put_decimal_ull(p, ' ', kstat_irqs(j));
 
 	seq_printf(p,
 		"\nctxt %llu\n"
@@ -149,7 +148,7 @@ static int show_stat(struct seq_file *p,
 	seq_printf(p, "softirq %llu", (unsigned long long)sum_softirq);
 
 	for (i = 0; i < NR_SOFTIRQS; i++)
-		seq_printf(p, " %u", per_softirq_sums[i]);
+		seq_put_decimal_ull(p, ' ', per_softirq_sums[i]);
 	seq_putc(p, '\n');
 
 	return 0;
diff -puN fs/seq_file.c~procfs-add-num_to_str-to-speed-up-proc-stat fs/seq_file.c
--- a/fs/seq_file.c~procfs-add-num_to_str-to-speed-up-proc-stat
+++ a/fs/seq_file.c
@@ -644,6 +644,39 @@ int seq_puts(struct seq_file *m, const c
 }
 EXPORT_SYMBOL(seq_puts);
 
+/*
+ * A helper routine for putting decimal numbers without rich format of printf().
+ * only 'unsigned long long' is supported.
+ * This routine will put one byte delimiter + number into seq_file.
+ * This routine is very quick when you show lots of numbers.
+ * In usual cases, it will be better to use seq_printf(). It's easier to read.
+ */
+int seq_put_decimal_ull(struct seq_file *m, char delimiter,
+			unsigned long long num)
+{
+	int len;
+
+	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
+		goto overflow;
+
+	m->buf[m->count++] = delimiter;
+
+	if (num < 10) {
+		m->buf[m->count++] = num + '0';
+		return 0;
+	}
+
+	len = num_to_str(m->buf + m->count, m->size - m->count, num);
+	if (!len)
+		goto overflow;
+	m->count += len;
+	return 0;
+overflow:
+	m->count = m->size;
+	return -1;
+}
+EXPORT_SYMBOL(seq_put_decimal_ull);
+
 /**
  * seq_write - write arbitrary data to buffer
  * @seq: seq_file identifying the buffer to which data should be written
diff -puN include/linux/kernel.h~procfs-add-num_to_str-to-speed-up-proc-stat include/linux/kernel.h
--- a/include/linux/kernel.h~procfs-add-num_to_str-to-speed-up-proc-stat
+++ a/include/linux/kernel.h
@@ -312,6 +312,8 @@ extern long long simple_strtoll(const ch
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
+extern int num_to_str(char *buf, int size, unsigned long long num);
+
 /* lib/printf utilities */
 
 extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
diff -puN include/linux/seq_file.h~procfs-add-num_to_str-to-speed-up-proc-stat include/linux/seq_file.h
--- a/include/linux/seq_file.h~procfs-add-num_to_str-to-speed-up-proc-stat
+++ a/include/linux/seq_file.h
@@ -121,9 +121,10 @@ int single_release(struct inode *, struc
 void *__seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
+int seq_put_decimal_ull(struct seq_file *m, char delimiter,
+			unsigned long long num);
 
 #define SEQ_START_TOKEN ((void *)1)
-
 /*
  * Helpers for iteration over list_head-s in seq_files
  */
diff -puN lib/vsprintf.c~procfs-add-num_to_str-to-speed-up-proc-stat lib/vsprintf.c
--- a/lib/vsprintf.c~procfs-add-num_to_str-to-speed-up-proc-stat
+++ a/lib/vsprintf.c
@@ -212,6 +212,26 @@ char *put_dec(char *buf, unsigned long l
 	}
 }
 
+/*
+ * Convert passed number to decimal string.
+ * Returns the length of string.  On buffer overflow, returns 0.
+ *
+ * If speed is not important, use snprintf(). It's easy to read the code.
+ */
+int num_to_str(char *buf, int size, unsigned long long num)
+{
+	char tmp[21];		/* Enough for 2^64 in decimal */
+	int idx, len;
+
+	len = put_dec(tmp, num) - tmp;
+
+	if (len > size)
+		return 0;
+	for (idx = 0; idx < len; ++idx)
+		buf[idx] = tmp[len - idx - 1];
+	return  len;
+}
+
 #define ZEROPAD	1		/* pad with zero */
 #define SIGN	2		/* unsigned/signed long */
 #define PLUS	4		/* show plus */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-coredump-fail-allocations-when-coredumping-instead-of-oom-killing.patch
memcg-change-behavior-of-moving-charges-at-task-move.patch
memcg-change-behavior-of-moving-charges-at-task-move-fix.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

