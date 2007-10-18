From: akpm@linux-foundation.org
Subject: - softlockup-watchdog-style-cleanups.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:49 -0700
Message-ID: <200710180652.l9I6qnTb030317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146AbXJRHhv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup watchdog: style cleanups
has been removed from the -mm tree.  Its filename was
     softlockup-watchdog-style-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: softlockup watchdog: style cleanups
From: Ingo Molnar <mingo@elte.hu>

kernel/softirq.c grew a few style uncleanlinesses in the past few
months, clean that up. No functional changes:

   text    data     bss     dec     hex filename
   1126      76       4    1206     4b6 softlockup.o.before
   1129      76       4    1209     4b9 softlockup.o.after

( the 3 bytes .text increase is due to the "<1>" appended to one of
  the printk messages. )

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN kernel/softlockup.c~softlockup-watchdog-style-cleanups kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-watchdog-style-cleanups
+++ a/kernel/softlockup.c
@@ -23,7 +23,7 @@ static DEFINE_PER_CPU(unsigned long, tou
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
-static int did_panic = 0;
+static int did_panic;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -121,7 +121,7 @@ void softlockup_tick(void)
 /*
  * The watchdog thread - runs every second and touches the timestamp.
  */
-static int watchdog(void * __bind_cpu)
+static int watchdog(void *__bind_cpu)
 {
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
@@ -159,13 +159,13 @@ cpu_callback(struct notifier_block *nfb,
 		BUG_ON(per_cpu(watchdog_task, hotcpu));
 		p = kthread_create(watchdog, hcpu, "watchdog/%d", hotcpu);
 		if (IS_ERR(p)) {
-			printk("watchdog for %i failed\n", hotcpu);
+			printk(KERN_ERR "watchdog for %i failed\n", hotcpu);
 			return NOTIFY_BAD;
 		}
-  		per_cpu(touch_timestamp, hotcpu) = 0;
-  		per_cpu(watchdog_task, hotcpu) = p;
+		per_cpu(touch_timestamp, hotcpu) = 0;
+		per_cpu(watchdog_task, hotcpu) = p;
 		kthread_bind(p, hotcpu);
- 		break;
+		break;
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		wake_up_process(per_cpu(watchdog_task, hotcpu));
@@ -185,7 +185,7 @@ cpu_callback(struct notifier_block *nfb,
 		kthread_stop(p);
 		break;
 #endif /* CONFIG_HOTPLUG_CPU */
- 	}
+	}
 	return NOTIFY_OK;
 }
 
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
