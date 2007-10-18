From: akpm@linux-foundation.org
Subject: - softlockup-improve-debug-output.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:46 -0700
Message-ID: <200710180652.l9I6qkiq030314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932724AbXJRHlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, satyam@infradead.org, mm-commits@vger.kernel.org


The patch titled
     softlockup: improve debug output
has been removed from the -mm tree.  Its filename was
     softlockup-improve-debug-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: softlockup: improve debug output
From: Ingo Molnar <mingo@elte.hu>

Improve the debuggability of kernel lockups by enhancing the debug
output of the softlockup detector: print the task that causes the lockup
and try to print a more intelligent backtrace.

The old format was:

  BUG: soft lockup detected on CPU#1!
   [<c0105e4a>] show_trace_log_lvl+0x19/0x2e
   [<c0105f43>] show_trace+0x12/0x14
   [<c0105f59>] dump_stack+0x14/0x16
   [<c015f6bc>] softlockup_tick+0xbe/0xd0
   [<c013457d>] run_local_timers+0x12/0x14
   [<c01346b8>] update_process_times+0x3e/0x63
   [<c0145fb8>] tick_sched_timer+0x7c/0xc0
   [<c0140a75>] hrtimer_interrupt+0x135/0x1ba
   [<c011bde7>] smp_apic_timer_interrupt+0x6e/0x80
   [<c0105aa3>] apic_timer_interrupt+0x33/0x38
   [<c0104f8a>] syscall_call+0x7/0xb
   =======================

The new format is:

  BUG: soft lockup detected on CPU#1! [prctl:2363]

  Pid: 2363, comm:                prctl
  EIP: 0060:[<c013915f>] CPU: 1
  EIP is at sys_prctl+0x24/0x18c
   EFLAGS: 00000213    Not tainted  (2.6.22-cfs-v20 #26)
  EAX: 00000001 EBX: 000003e7 ECX: 00000001 EDX: f6df0000
  ESI: 000003e7 EDI: 000003e7 EBP: f6df0fb0 DS: 007b ES: 007b FS: 00d8
  CR0: 8005003b CR2: 4d8c3340 CR3: 3731d000 CR4: 000006d0
   [<c0105e4a>] show_trace_log_lvl+0x19/0x2e
   [<c0105f43>] show_trace+0x12/0x14
   [<c01040be>] show_regs+0x1ab/0x1b3
   [<c015f807>] softlockup_tick+0xef/0x108
   [<c013457d>] run_local_timers+0x12/0x14
   [<c01346b8>] update_process_times+0x3e/0x63
   [<c0145fcc>] tick_sched_timer+0x7c/0xc0
   [<c0140a89>] hrtimer_interrupt+0x135/0x1ba
   [<c011bde7>] smp_apic_timer_interrupt+0x6e/0x80
   [<c0105aa3>] apic_timer_interrupt+0x33/0x38
   [<c0104f8a>] syscall_call+0x7/0xb
   =======================

Note that in the old format we only knew that some system call locked
up, we didnt know _which_. With the new format we know that it's at a
specific place in sys_prctl(). [which was where i created an artificial
kernel lockup to test the new format.]

This is also useful if the lockup happens in user-space - the user-space
EIP (and other registers) will be printed too. (such a lockup would
either suggest that the task was running at SCHED_FIFO:99 and looping
for more than 10 seconds, or that the softlockup detector has a
false-positive.)

The task name is printed too first, just in case we dont manage to print
a useful backtrace.

[satyam@infradead.org: fix warning]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Satyam Sharma <satyam@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN kernel/softlockup.c~softlockup-improve-debug-output kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-improve-debug-output
+++ a/kernel/softlockup.c
@@ -15,6 +15,8 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 
+#include <asm/irq_regs.h>
+
 static DEFINE_SPINLOCK(print_lock);
 
 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
@@ -72,6 +74,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
+	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
@@ -101,15 +104,18 @@ void softlockup_tick(void)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (now > (touch_timestamp + 10)) {
-		per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+	if (now <= (touch_timestamp + 10))
+		return;
 
-		spin_lock(&print_lock);
-		printk(KERN_ERR "BUG: soft lockup detected on CPU#%d!\n",
-			this_cpu);
+	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
+
+	spin_lock(&print_lock);
+	printk(KERN_ERR "BUG: soft lockup detected on CPU#%d!\n", this_cpu);
+	if (regs)
+		show_regs(regs);
+	else
 		dump_stack();
-		spin_unlock(&print_lock);
-	}
+	spin_unlock(&print_lock);
 }
 
 /*
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
net-dccp-fix-link-error-with-config_sysctl.patch
git-netdev-all.patch
fix-build-breakage-if-sysfs-fix.patch
git-x86.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
i386-paravirt-boot-sequence.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
uninline-find_task_by_xxx-set-of-functions.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpuset-sched_load_balance-kmalloc-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
