From: akpm@linux-foundation.org
Subject: + pm-do-not-destroy-create-devices-while-suspended-in-mce_64c.patch added to -mm tree
Date: Fri, 11 Jan 2008 16:43:27 -0800
Message-ID: <200801120043.m0C0hRNl006077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46329 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbYALAoS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 19:44:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ak@suse.de, greg@kroah.com, kay.sievers@vrfy.org, lenb@kernel.org, mingo@elte.hu, pavel@suse.cz, stern@rowland.harvard.edu, tglx@linutronix.de


The patch titled
     PM: Do not destroy/create devices while suspended in mce_64.c
has been added to the -mm tree.  Its filename is
     pm-do-not-destroy-create-devices-while-suspended-in-mce_64c.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PM: Do not destroy/create devices while suspended in mce_64.c
From: Rafael J. Wysocki <rjw@sisk.pl>

The x86-64 MCE driver should not attempt to destroy/create a suspended device,
unless it corresponds to a nonboot CPU that failed to go online during a
resume.

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

 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce_64.c~pm-do-not-destroy-create-devices-while-suspended-in-mce_64c arch/x86/kernel/cpu/mcheck/mce_64.c
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c~pm-do-not-destroy-create-devices-while-suspended-in-mce_64c
+++ a/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -862,11 +862,10 @@ mce_cpu_callback(struct notifier_block *
 
 	switch (action) {
 	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
 		mce_create_device(cpu);
 		break;
 	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
+	case CPU_UP_CANCELED_FROZEN:
 		mce_remove_device(cpu);
 		break;
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
pm-introduce-destroy_suspended_device.patch
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
