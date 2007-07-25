From: akpm@linux-foundation.org
Subject: + blktrace-use-cpu_clock-instead-of-sched_clock.patch added to -mm tree
Date: Wed, 25 Jul 2007 02:27:50 -0700
Message-ID: <200707250927.l6P9RolO027259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbXGYJ2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 05:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, axboe@kernel.dk


The patch titled
     blktrace: use cpu_clock() instead of sched_clock()
has been added to the -mm tree.  Its filename is
     blktrace-use-cpu_clock-instead-of-sched_clock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: blktrace: use cpu_clock() instead of sched_clock()
From: Ingo Molnar <mingo@elte.hu>

use cpu_clock() instead of sched_clock(). (the latter is not a proper
clock-source)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blktrace.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN block/blktrace.c~blktrace-use-cpu_clock-instead-of-sched_clock block/blktrace.c
--- a/block/blktrace.c~blktrace-use-cpu_clock-instead-of-sched_clock
+++ a/block/blktrace.c
@@ -41,7 +41,7 @@ static void trace_note(struct blk_trace 
 		const int cpu = smp_processor_id();
 
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
-		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
+		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
 		t->device = bt->dev;
 		t->action = action;
 		t->pid = pid;
@@ -159,7 +159,7 @@ void __blk_add_trace(struct blk_trace *b
 
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
 		t->sequence = ++(*sequence);
-		t->time = sched_clock() - per_cpu(blk_trace_cpu_offset, cpu);
+		t->time = cpu_clock(cpu) - per_cpu(blk_trace_cpu_offset, cpu);
 		t->sector = sector;
 		t->bytes = bytes;
 		t->action = what;
@@ -488,17 +488,17 @@ void blk_trace_shutdown(struct request_q
 }
 
 /*
- * Average offset over two calls to sched_clock() with a gettimeofday()
+ * Average offset over two calls to cpu_clock() with a gettimeofday()
  * in the middle
  */
-static void blk_check_time(unsigned long long *t)
+static void blk_check_time(unsigned long long *t, int this_cpu)
 {
 	unsigned long long a, b;
 	struct timeval tv;
 
-	a = sched_clock();
+	a = cpu_clock(this_cpu);
 	do_gettimeofday(&tv);
-	b = sched_clock();
+	b = cpu_clock(this_cpu);
 
 	*t = tv.tv_sec * 1000000000 + tv.tv_usec * 1000;
 	*t -= (a + b) / 2;
@@ -510,16 +510,16 @@ static void blk_check_time(unsigned long
 static void blk_trace_check_cpu_time(void *data)
 {
 	unsigned long long *t;
-	int cpu = get_cpu();
+	int this_cpu = get_cpu();
 
-	t = &per_cpu(blk_trace_cpu_offset, cpu);
+	t = &per_cpu(blk_trace_cpu_offset, this_cpu);
 
 	/*
 	 * Just call it twice, hopefully the second call will be cache hot
 	 * and a little more precise
 	 */
-	blk_check_time(t);
-	blk_check_time(t);
+	blk_check_time(t, this_cpu);
+	blk_check_time(t, this_cpu);
 
 	put_cpu();
 }
_

Patches currently in -mm which might be from mingo@elte.hu are

git-acpi.patch
git-kvm.patch
fix-theoretical-ccids_readwrite_lock-race.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
softlockup-use-cpu_clock-instead-of-sched_clock.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
blktrace-use-cpu_clock-instead-of-sched_clock.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
mark-sysrq_sched_debug_show-static.patch
cfs-mark-print_cfs_stats-static.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
time-simplify-smp_call_function_single-call-sequence.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
