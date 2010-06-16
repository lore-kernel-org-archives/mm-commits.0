From: akpm@linux-foundation.org
Subject: + cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch added to -mm tree
Date: Wed, 16 Jun 2010 13:41:22 -0700
Message-ID: <201006162041.o5GKfNLC026748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756256Ab0FPUmW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jun 2010 16:42:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sergey.senozhatsky@gmail.com, arjan@infradead.org, jslaby@suse.cz, len.brown@intel.com, maximlevitsky@gmail.com, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     cpuidle: avoid using smp_processor_id() in preemptible code (nr_iowait_cpu)
has been added to the -mm tree.  Its filename is
     cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuidle: avoid using smp_processor_id() in preemptible code (nr_iowait_cpu)
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Fix

 BUG: using smp_processor_id() in preemptible [00000000] code: s2disk/3392
 caller is nr_iowait_cpu+0xe/0x1e
 Pid: 3392, comm: s2disk Not tainted 2.6.35-rc3-dbg-00106-ga75e02b #2
 Call Trace:
 [<c1184c55>] debug_smp_processor_id+0xa5/0xbc
 [<c10282a5>] nr_iowait_cpu+0xe/0x1e
 [<c104ab7c>] update_ts_time_stats+0x32/0x6c
 [<c104ac73>] get_cpu_idle_time_us+0x36/0x58
 [<c124229b>] get_cpu_idle_time+0x12/0x74
 [<c1242963>] cpufreq_governor_dbs+0xc3/0x2dc
 [<c1240437>] __cpufreq_governor+0x51/0x85
 [<c1241190>] __cpufreq_set_policy+0x10c/0x13d
 [<c12413d3>] cpufreq_add_dev_interface+0x212/0x233
 [<c1241b1e>] ? handle_update+0x0/0xd
 [<c1241a18>] cpufreq_add_dev+0x34b/0x35a
 [<c103c973>] ? schedule_delayed_work_on+0x11/0x13
 [<c12c14db>] cpufreq_cpu_callback+0x59/0x63
 [<c1042f39>] notifier_call_chain+0x26/0x48
 [<c1042f7d>] __raw_notifier_call_chain+0xe/0x10
 [<c102efb9>] __cpu_notify+0x15/0x29
 [<c102efda>] cpu_notify+0xd/0xf
 [<c12bfb30>] _cpu_up+0xaf/0xd2
 [<c12b3ad4>] enable_nonboot_cpus+0x3d/0x94
 [<c1055eef>] hibernation_snapshot+0x104/0x1a2
 [<c1058b49>] snapshot_ioctl+0x24b/0x53e
 [<c1028ad1>] ? sub_preempt_count+0x7c/0x89
 [<c10ab91d>] vfs_ioctl+0x2e/0x8c
 [<c10588fe>] ? snapshot_ioctl+0x0/0x53e
 [<c10ac2c7>] do_vfs_ioctl+0x42f/0x45a
 [<c10a0ba5>] ? fsnotify_modify+0x4f/0x5a
 [<c11e9dc3>] ? tty_write+0x0/0x1d0
 [<c10a12d6>] ? vfs_write+0xa2/0xda
 [<c10ac333>] sys_ioctl+0x41/0x62
 [<c10027d3>] sysenter_do_call+0x12/0x2d

The initial fix was to use get_cpu/put_cpu in nr_iowait_cpu.  However,
Arjan stated that "the bug is that it needs to be nr_iowait_cpu(int cpu)".

This patch introduces nr_iowait_cpu(int cpu) and changes to it callers.

akpm: addresses about 30,000,000 different bug reports.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   10 ++++++++--
 include/linux/sched.h            |    2 +-
 kernel/sched.c                   |    4 ++--
 kernel/time/tick-sched.c         |    4 +++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/drivers/cpuidle/governors/menu.c
@@ -137,15 +137,18 @@ static inline int which_bucket(unsigned 
 {
 	int bucket = 0;
 
+	int cpu = get_cpu();
 	/*
 	 * We keep two groups of stats; one with no
 	 * IO pending, one without.
 	 * This allows us to calculate
 	 * E(duration)|iowait
 	 */
-	if (nr_iowait_cpu())
+	if (nr_iowait_cpu(cpu))
 		bucket = BUCKETS/2;
 
+	put_cpu();
+
 	if (duration < 10)
 		return bucket;
 	if (duration < 100)
@@ -169,13 +172,16 @@ static inline int which_bucket(unsigned 
 static inline int performance_multiplier(void)
 {
 	int mult = 1;
+	int cpu = get_cpu();
 
 	/* for higher loadavg, we are more reluctant */
 
 	mult += 2 * get_loadavg();
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu();
+	mult += 10 * nr_iowait_cpu(cpu);
+
+	put_cpu();
 
 	return mult;
 }
diff -puN include/linux/sched.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu include/linux/sched.h
--- a/include/linux/sched.h~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/include/linux/sched.h
@@ -139,7 +139,7 @@ extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
-extern unsigned long nr_iowait_cpu(void);
+extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
diff -puN kernel/sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu kernel/sched.c
--- a/kernel/sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/kernel/sched.c
@@ -2864,9 +2864,9 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
-unsigned long nr_iowait_cpu(void)
+unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = this_rq();
+	struct rq *this = cpu_rq(cpu);
 	return atomic_read(&this->nr_iowait);
 }
 
diff -puN kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu
+++ a/kernel/time/tick-sched.c
@@ -159,10 +159,12 @@ update_ts_time_stats(struct tick_sched *
 	ktime_t delta;
 
 	if (ts->idle_active) {
+		int cpu = get_cpu();
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-		if (nr_iowait_cpu() > 0)
+		if (nr_iowait_cpu(cpu) > 0)
 			ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
+		put_cpu();
 		ts->idle_entrytime = now;
 	}
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch

