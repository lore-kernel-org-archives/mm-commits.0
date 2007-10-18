From: akpm@linux-foundation.org
Subject: - softlockup-use-cpu_clock-instead-of-sched_clock.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:38 -0700
Message-ID: <200710180652.l9I6qc83030305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932153AbXJRHhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup: use cpu_clock() instead of sched_clock()
has been removed from the -mm tree.  Its filename was
     softlockup-use-cpu_clock-instead-of-sched_clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: softlockup: use cpu_clock() instead of sched_clock()
From: Ingo Molnar <mingo@elte.hu>

sched_clock() is not a reliable time-source, use cpu_clock() instead.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/softlockup.c~softlockup-use-cpu_clock-instead-of-sched_clock kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-use-cpu_clock-instead-of-sched_clock
+++ a/kernel/softlockup.c
@@ -40,14 +40,16 @@ static struct notifier_block panic_block
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(void)
+static unsigned long get_timestamp(int this_cpu)
 {
-	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
+	int this_cpu = raw_smp_processor_id();
+
+	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -91,7 +93,7 @@ void softlockup_tick(void)
 		return;
 	}
 
-	now = get_timestamp();
+	now = get_timestamp(this_cpu);
 
 	/* Wake up the high-prio watchdog task every second: */
 	if (now > (touch_timestamp + 1))
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
