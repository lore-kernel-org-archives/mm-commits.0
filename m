From: akpm@linux-foundation.org
Subject: - pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2.patch removed from -mm tree
Date: Fri, 11 Jan 2008 16:49:29 -0800
Message-ID: <200801120049.m0C0nTdP006366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762774AbYALAuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:50:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ak@suse.de, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, mingo@elte.hu, pavel@suse.cz, stern@rowland.harvard.edu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     PM: Do not destroy/create devices while suspended in msr.c (rev. 2)
has been removed from the -mm tree.  Its filename was
     pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: Do not destroy/create devices while suspended in msr.c (rev. 2)
From: Rafael J. Wysocki <rjw@sisk.pl>

The MSR driver should not attempt to destroy/create a device while suspended,
unless this device corresponds to a nonboot CPU that failed to go online
during a resume, in which case the PM core should be asked to remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Len Brown <lenb@kernel.org>
Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/msr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/msr.c~pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2 arch/x86/kernel/msr.c
--- a/arch/x86/kernel/msr.c~pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2
+++ a/arch/x86/kernel/msr.c
@@ -155,15 +155,15 @@ static int __cpuinit msr_class_cpu_callb
 
 	switch (action) {
 	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 		err = msr_device_create(cpu);
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
 		msr_device_destroy(cpu);
 		break;
+	case CPU_UP_CANCELED_FROZEN:
+		destroy_suspended_device(msr_class, MKDEV(MSR_MAJOR, cpu));
+		break;
 	}
 	return err ? NOTIFY_BAD : NOTIFY_OK;
 }
_

Patches currently in -mm which might be from rjw@sisk.pl are

reintroduce-run-time-configurable-max_cstate-for-cpu_idle-case.patch
git-acpi.patch
suspend-introduce-begin-and-end-callbacks.patch
acpi-separate-invocations-of-_gts-and-_bfs-from-_pts-and-_wak.patch
acpi-separate-disabling-of-gpes-from-_pts.patch
acpi-suspend-call-_pts-before-suspending-devices.patch
hibernation-introduce-begin-and-end-callbacks.patch
acpi-hibernation-call-_pts-before-suspending-devices.patch
acpi-print-message-before-calling-_pts.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
pm-do-not-destroy-create-devices-while-suspended-in-msrc-rev-2.patch
pm-do-not-destroy-create-devices-while-suspended-in-mce_64c.patch
pm-do-not-destroy-create-devices-while-suspended-in-cpuidc.patch
pm-acquire-device-locks-on-suspend-rev-3.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
git-x86.patch
git-xfs.patch
cpufreq-initialise-default-governor-before-use.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
remove-obsolete-sys-devices-power-state-docs.patch
pnp-do-not-stop-start-devices-in-suspend-resume-path.patch
proc-fix-the-threaded-proc-self.patch
shrink_slab-handle-bad-shrinkers.patch
