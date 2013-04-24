From: akpm@linux-foundation.org
Subject: [to-be-updated] kernel-sysc-migrate-shutdown-reboot-to-boot-cpu.patch removed from -mm tree
Date: Wed, 24 Apr 2013 15:18:16 -0700
Message-ID: <20130424221816.8A5575A4034__36747.8919135921$1366841902$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:54988 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab3DXWSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:18:17 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so252898ggm.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:18:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, hpa@zytor.com, mingo@redhat.com, rja@sgi.com, shawn.guo@linaro.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/sys.c: migrate shutdown/reboot to boot cpu.
has been removed from the -mm tree.  Its filename was
     kernel-sysc-migrate-shutdown-reboot-to-boot-cpu.patch

This patch was dropped because an updated version will be merged

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

kernel-sysc-move-shutdown-reboot-related-functions-to-kernel-rebootc.patch
kernel-rebootc-fix-checkpatch-warnings.patch
kernel-rebootc-move-arch-x86-reboot=-handling-to-generic-kernel.patch
ipc-sysv-shared-memory-limited-to-8tib.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch

