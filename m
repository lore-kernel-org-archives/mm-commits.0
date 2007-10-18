From: akpm@linux-foundation.org
Subject: - fix-the-softlockup-watchdog-to-actually-work.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:40 -0700
Message-ID: <200710180652.l9I6qeZb030308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932509AbXJRHoE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:44:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, jeremy@goop.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix the softlockup watchdog to actually work
has been removed from the -mm tree.  Its filename was
     fix-the-softlockup-watchdog-to-actually-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix the softlockup watchdog to actually work
From: Ingo Molnar <mingo@elte.hu>

this Xen related commit:

   commit 966812dc98e6a7fcdf759cbfa0efab77500a8868
   Author: Jeremy Fitzhardinge <jeremy@goop.org>
   Date:   Tue May 8 00:28:02 2007 -0700

       Ignore stolen time in the softlockup watchdog

broke the softlockup watchdog to never report any lockups. (!)

print_timestamp defaults to 0, this makes the following condition
always true:

	if (print_timestamp < (touch_timestamp + 1) ||

and we'll in essence never report soft lockups.

apparently the functionality of the soft lockup watchdog was never
actually tested with that patch applied ...

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/softlockup.c~fix-the-softlockup-watchdog-to-actually-work kernel/softlockup.c
--- a/kernel/softlockup.c~fix-the-softlockup-watchdog-to-actually-work
+++ a/kernel/softlockup.c
@@ -82,10 +82,11 @@ void softlockup_tick(void)
 	print_timestamp = per_cpu(print_timestamp, this_cpu);
 
 	/* report at most once a second */
-	if (print_timestamp < (touch_timestamp + 1) ||
-		did_panic ||
-			!per_cpu(watchdog_task, this_cpu))
+	if ((print_timestamp >= touch_timestamp &&
+			print_timestamp < (touch_timestamp + 1)) ||
+			did_panic || !per_cpu(watchdog_task, this_cpu)) {
 		return;
+	}
 
 	/* do not print during early bootup: */
 	if (unlikely(system_state != SYSTEM_RUNNING)) {
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
