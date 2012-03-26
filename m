From: akpm@linux-foundation.org
Subject: [merged] procfs-speed-up-proc-pid-stat-statm.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:32:48 -0700
Message-ID: <20120326193248.77D2FA00A9@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42292 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2CZTcu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:32:50 -0400
Received: by wejx9 with SMTP id x9so290247wej.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:32:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: speed up /proc/pid/stat, statm
has been removed from the -mm tree.  Its filename was
     procfs-speed-up-proc-pid-stat-statm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: procfs: speed up /proc/pid/stat, statm

Process accounting applications as top, ps visit some files under
/proc/<pid>.  With seq_put_decimal_ull(), we can optimize /proc/<pid>/stat
and /proc/<pid>/statm files.

This patch adds
  - seq_put_decimal_ll() for signed values.
  - allow delimiter == 0.
  - convert seq_printf() to seq_put_decimal_ull/ll in /proc/stat, statm.

Test result on a system with 2000+ procs.

Before patch:
[kamezawa@bluextal test]$ top -b -n 1 | wc -l
2223
[kamezawa@bluextal test]$ time top -b -n 1 > /dev/null

real    0m0.675s
user    0m0.044s
sys     0m0.121s

[kamezawa@bluextal test]$ time ps -elf > /dev/null

real    0m0.236s
user    0m0.056s
sys     0m0.176s

After patch:
kamezawa@bluextal ~]$ time top -b -n 1 > /dev/null

real    0m0.657s
user    0m0.052s
sys     0m0.100s

[kamezawa@bluextal ~]$ time ps -elf > /dev/null

real    0m0.198s
user    0m0.050s
sys     0m0.145s

Considering top, ps tend to scan /proc periodically, this will reduce cpu
consumption by top/ps to some extent.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c          |  119 +++++++++++++++++++------------------
 fs/seq_file.c            |   21 ++++++
 include/linux/seq_file.h |    2 
 3 files changed, 86 insertions(+), 56 deletions(-)

diff -puN fs/proc/array.c~procfs-speed-up-proc-pid-stat-statm fs/proc/array.c
--- a/fs/proc/array.c~procfs-speed-up-proc-pid-stat-statm
+++ a/fs/proc/array.c
@@ -462,59 +462,56 @@ static int do_task_stat(struct seq_file 
 	/* convert nsec -> ticks */
 	start_time = nsec_to_clock_t(start_time);
 
-	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
-%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
-		pid_nr_ns(pid, ns),
-		tcomm,
-		state,
-		ppid,
-		pgid,
-		sid,
-		tty_nr,
-		tty_pgrp,
-		task->flags,
-		min_flt,
-		cmin_flt,
-		maj_flt,
-		cmaj_flt,
-		cputime_to_clock_t(utime),
-		cputime_to_clock_t(stime),
-		cputime_to_clock_t(cutime),
-		cputime_to_clock_t(cstime),
-		priority,
-		nice,
-		num_threads,
-		start_time,
-		vsize,
-		mm ? get_mm_rss(mm) : 0,
-		rsslim,
-		mm ? (permitted ? mm->start_code : 1) : 0,
-		mm ? (permitted ? mm->end_code : 1) : 0,
-		(permitted && mm) ? mm->start_stack : 0,
-		esp,
-		eip,
-		/* The signal information here is obsolete.
-		 * It must be decimal for Linux 2.0 compatibility.
-		 * Use /proc/#/status for real-time signals.
-		 */
-		task->pending.signal.sig[0] & 0x7fffffffUL,
-		task->blocked.sig[0] & 0x7fffffffUL,
-		sigign      .sig[0] & 0x7fffffffUL,
-		sigcatch    .sig[0] & 0x7fffffffUL,
-		wchan,
-		0UL,
-		0UL,
-		task->exit_signal,
-		task_cpu(task),
-		task->rt_priority,
-		task->policy,
-		(unsigned long long)delayacct_blkio_ticks(task),
-		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime),
-		(mm && permitted) ? mm->start_data : 0,
-		(mm && permitted) ? mm->end_data : 0,
-		(mm && permitted) ? mm->start_brk : 0);
+	seq_printf(m, "%d (%s) %c", pid_nr_ns(pid, ns), tcomm, state);
+	seq_put_decimal_ll(m, ' ', ppid);
+	seq_put_decimal_ll(m, ' ', pgid);
+	seq_put_decimal_ll(m, ' ', sid);
+	seq_put_decimal_ll(m, ' ', tty_nr);
+	seq_put_decimal_ll(m, ' ', tty_pgrp);
+	seq_put_decimal_ull(m, ' ', task->flags);
+	seq_put_decimal_ull(m, ' ', min_flt);
+	seq_put_decimal_ull(m, ' ', cmin_flt);
+	seq_put_decimal_ull(m, ' ', maj_flt);
+	seq_put_decimal_ull(m, ' ', cmaj_flt);
+	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(utime));
+	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(stime));
+	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cutime));
+	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cstime));
+	seq_put_decimal_ll(m, ' ', priority);
+	seq_put_decimal_ll(m, ' ', nice);
+	seq_put_decimal_ll(m, ' ', num_threads);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ull(m, ' ', start_time);
+	seq_put_decimal_ull(m, ' ', vsize);
+	seq_put_decimal_ll(m, ' ', mm ? get_mm_rss(mm) : 0);
+	seq_put_decimal_ull(m, ' ', rsslim);
+	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->start_code : 1) : 0);
+	seq_put_decimal_ull(m, ' ', mm ? (permitted ? mm->end_code : 1) : 0);
+	seq_put_decimal_ull(m, ' ', (permitted && mm) ? mm->start_stack : 0);
+	seq_put_decimal_ull(m, ' ', esp);
+	seq_put_decimal_ull(m, ' ', eip);
+	/* The signal information here is obsolete.
+	 * It must be decimal for Linux 2.0 compatibility.
+	 * Use /proc/#/status for real-time signals.
+	 */
+	seq_put_decimal_ull(m, ' ', task->pending.signal.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', task->blocked.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', sigign.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', sigcatch.sig[0] & 0x7fffffffUL);
+	seq_put_decimal_ull(m, ' ', wchan);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ll(m, ' ', task->exit_signal);
+	seq_put_decimal_ll(m, ' ', task_cpu(task));
+	seq_put_decimal_ull(m, ' ', task->rt_priority);
+	seq_put_decimal_ull(m, ' ', task->policy);
+	seq_put_decimal_ull(m, ' ', delayacct_blkio_ticks(task));
+	seq_put_decimal_ull(m, ' ', cputime_to_clock_t(gtime));
+	seq_put_decimal_ll(m, ' ', cputime_to_clock_t(cgtime));
+	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_data : 0);
+	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->end_data : 0);
+	seq_put_decimal_ull(m, ' ', (mm && permitted) ? mm->start_brk : 0);
+	seq_putc(m, '\n');
 	if (mm)
 		mmput(mm);
 	return 0;
@@ -542,8 +539,20 @@ int proc_pid_statm(struct seq_file *m, s
 		size = task_statm(mm, &shared, &text, &data, &resident);
 		mmput(mm);
 	}
-	seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
-			size, resident, shared, text, data);
+	/*
+	 * For quick read, open code by putting numbers directly
+	 * expected format is
+	 * seq_printf(m, "%lu %lu %lu %lu 0 %lu 0\n",
+	 *               size, resident, shared, text, data);
+	 */
+	seq_put_decimal_ull(m, 0, size);
+	seq_put_decimal_ull(m, ' ', resident);
+	seq_put_decimal_ull(m, ' ', shared);
+	seq_put_decimal_ull(m, ' ', text);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_put_decimal_ull(m, ' ', text);
+	seq_put_decimal_ull(m, ' ', 0);
+	seq_putc(m, '\n');
 
 	return 0;
 }
diff -puN fs/seq_file.c~procfs-speed-up-proc-pid-stat-statm fs/seq_file.c
--- a/fs/seq_file.c~procfs-speed-up-proc-pid-stat-statm
+++ a/fs/seq_file.c
@@ -659,7 +659,8 @@ int seq_put_decimal_ull(struct seq_file 
 	if (m->count + 2 >= m->size) /* we'll write 2 bytes at least */
 		goto overflow;
 
-	m->buf[m->count++] = delimiter;
+	if (delimiter)
+		m->buf[m->count++] = delimiter;
 
 	if (num < 10) {
 		m->buf[m->count++] = num + '0';
@@ -677,6 +678,24 @@ overflow:
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
 
+int seq_put_decimal_ll(struct seq_file *m, char delimiter,
+			long long num)
+{
+	if (num < 0) {
+		if (m->count + 3 >= m->size) {
+			m->count = m->size;
+			return -1;
+		}
+		if (delimiter)
+			m->buf[m->count++] = delimiter;
+		num = -num;
+		delimiter = '-';
+	}
+	return seq_put_decimal_ull(m, delimiter, num);
+
+}
+EXPORT_SYMBOL(seq_put_decimal_ll);
+
 /**
  * seq_write - write arbitrary data to buffer
  * @seq: seq_file identifying the buffer to which data should be written
diff -puN include/linux/seq_file.h~procfs-speed-up-proc-pid-stat-statm include/linux/seq_file.h
--- a/include/linux/seq_file.h~procfs-speed-up-proc-pid-stat-statm
+++ a/include/linux/seq_file.h
@@ -123,6 +123,8 @@ int seq_open_private(struct file *, cons
 int seq_release_private(struct inode *, struct file *);
 int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 			unsigned long long num);
+int seq_put_decimal_ll(struct seq_file *m, char delimiter,
+			long long num);
 
 #define SEQ_START_TOKEN ((void *)1)
 /*
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

