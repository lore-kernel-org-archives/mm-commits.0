From: akpm@linux-foundation.org
Subject: + kernel-sysc-migrate-shutdown-reboot-to-boot-cpu.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:04:21 -0700
Message-ID: <20130424220421.E1B5A5A4034@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:36550 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421Ab3DXWEX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:04:23 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz11so251565vcb.4
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:04:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, hpa@zytor.com, mingo@redhat.com, rja@sgi.com, shawn.guo@linaro.org, stable@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: migrate shutdown/reboot to boot cpu.
has been added to the -mm tree.  Its filename is
     kernel-sysc-migrate-shutdown-reboot-to-boot-cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: kernel/sys.c: migrate shutdown/reboot to boot cpu.

We recently noticed that reboot of a 1024 cpu machine takes approx 16
minutes of just stopping the cpus.  The slowdown was tracked to commit
f96972f ("kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()").

The current implementation does all the work of hot removing the cpus
before halting the system.  We are switching to just migrating to the boot
cpu and then continuing with shutdown/reboot.

This also has the effect of not breaking x86's command line parameter for
specifying the reboot cpu.  Note, this code was shamelessly copied from
arch/x86/kernel/reboot.c with bits removed pertaining to the reboot_cpu
command line parameter.

Signed-off-by: Robin Holt <holt@sgi.com>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff -puN kernel/sys.c~kernel-sysc-migrate-shutdown-reboot-to-boot-cpu kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-migrate-shutdown-reboot-to-boot-cpu
+++ a/kernel/sys.c
@@ -362,6 +362,24 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+static void migrate_to_reboot_cpu(void)
+{
+	/* The boot cpu is always logical cpu 0 */
+	int reboot_cpu_id = 0;
+
+	cpu_hotplug_disable();
+
+	/* Make certain the cpu I'm about to reboot on is online */
+	if (!cpu_online(reboot_cpu_id))
+		reboot_cpu_id = cpumask_first(cpu_online_mask);
+
+	/* Prevent races with other tasks migrating this task */
+	current->flags |= PF_THREAD_BOUND;
+
+	/* Make certain I only run on the appropriate processor */
+	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
+}
+
 /**
  *	kernel_restart - reboot the system
  *	@cmd: pointer to buffer containing command to execute for restart
@@ -373,7 +391,7 @@ EXPORT_SYMBOL(unregister_reboot_notifier
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
 		printk(KERN_EMERG "Restarting system.\n");
@@ -400,7 +418,7 @@ static void kernel_shutdown_prepare(enum
 void kernel_halt(void)
 {
 	kernel_shutdown_prepare(SYSTEM_HALT);
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "System halted.\n");
 	kmsg_dump(KMSG_DUMP_HALT);
@@ -419,7 +437,7 @@ void kernel_power_off(void)
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
 	if (pm_power_off_prepare)
 		pm_power_off_prepare();
-	disable_nonboot_cpus();
+	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	printk(KERN_EMERG "Power down.\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
_

Patches currently in -mm which might be from holt@sgi.com are

cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
kernel-sysc-migrate-shutdown-reboot-to-boot-cpu.patch
kernel-sysc-move-shutdown-reboot-related-functions-to-kernel-rebootc.patch
kernel-rebootc-fix-checkpatch-warnings.patch
kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel.patch
ipc-sysv-shared-memory-limited-to-8tib.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch

