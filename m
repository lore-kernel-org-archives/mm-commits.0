From: akpm@linux-foundation.org
Subject: + reboot-checkpatchpl-the-new-kernel-rebootc-file.patch added to -mm tree
Date: Wed, 08 May 2013 13:45:19 -0700
Message-ID: <20130508204519.EBCA031C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:34823 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3EHUpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:45:21 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so222347qen.0
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:45:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de


The patch titled
     Subject: reboot: checkpatch.pl the new kernel/reboot.c file.
has been added to the -mm tree.  Its filename is
     reboot-checkpatchpl-the-new-kernel-rebootc-file.patch

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
Subject: reboot: checkpatch.pl the new kernel/reboot.c file.

Get the new file to pass scripts/checkpatch.pl

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    2 +-
 kernel/reboot.c        |   28 +++++++++++++---------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff -puN include/linux/reboot.h~reboot-checkpatchpl-the-new-kernel-rebootc-file include/linux/reboot.h
--- a/include/linux/reboot.h~reboot-checkpatchpl-the-new-kernel-rebootc-file
+++ a/include/linux/reboot.h
@@ -26,7 +26,7 @@ extern void machine_shutdown(void);
 struct pt_regs;
 extern void machine_crash_shutdown(struct pt_regs *);
 
-/* 
+/*
  * Architecture independent implemenations of sys_reboot commands.
  */
 
diff -puN kernel/reboot.c~reboot-checkpatchpl-the-new-kernel-rebootc-file kernel/reboot.c
--- a/kernel/reboot.c~reboot-checkpatchpl-the-new-kernel-rebootc-file
+++ a/kernel/reboot.c
@@ -4,6 +4,8 @@
  *  Copyright (C) 2013  Linus Torvalds
  */
 
+#define pr_fmt(fmt)	"reboot: " fmt
+
 #include <linux/export.h>
 #include <linux/kexec.h>
 #include <linux/kmod.h>
@@ -114,9 +116,9 @@ void kernel_restart(char *cmd)
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
-		printk(KERN_EMERG "Restarting system.\n");
+		pr_emerg("Restarting system\n");
 	else
-		printk(KERN_EMERG "Restarting system with command '%s'.\n", cmd);
+		pr_emerg("Restarting system with command '%s'\n", cmd);
 	kmsg_dump(KMSG_DUMP_RESTART);
 	machine_restart(cmd);
 }
@@ -125,7 +127,7 @@ EXPORT_SYMBOL_GPL(kernel_restart);
 static void kernel_shutdown_prepare(enum system_states state)
 {
 	blocking_notifier_call_chain(&reboot_notifier_list,
-		(state == SYSTEM_HALT)?SYS_HALT:SYS_POWER_OFF, NULL);
+		(state == SYSTEM_HALT) ? SYS_HALT : SYS_POWER_OFF, NULL);
 	system_state = state;
 	usermodehelper_disable();
 	device_shutdown();
@@ -140,11 +142,10 @@ void kernel_halt(void)
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	printk(KERN_EMERG "System halted.\n");
+	pr_emerg("System halted\n");
 	kmsg_dump(KMSG_DUMP_HALT);
 	machine_halt();
 }
-
 EXPORT_SYMBOL_GPL(kernel_halt);
 
 /**
@@ -159,7 +160,7 @@ void kernel_power_off(void)
 		pm_power_off_prepare();
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
-	printk(KERN_EMERG "Power down.\n");
+	pr_emerg("Power down\n");
 	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
 }
@@ -188,10 +189,10 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 
 	/* For safety, we require "magic" arguments. */
 	if (magic1 != LINUX_REBOOT_MAGIC1 ||
-	    (magic2 != LINUX_REBOOT_MAGIC2 &&
-	                magic2 != LINUX_REBOOT_MAGIC2A &&
+			(magic2 != LINUX_REBOOT_MAGIC2 &&
+			magic2 != LINUX_REBOOT_MAGIC2A &&
 			magic2 != LINUX_REBOOT_MAGIC2B &&
-	                magic2 != LINUX_REBOOT_MAGIC2C))
+			magic2 != LINUX_REBOOT_MAGIC2C))
 		return -EINVAL;
 
 	/*
@@ -234,7 +235,8 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 		break;
 
 	case LINUX_REBOOT_CMD_RESTART2:
-		if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0) {
+		ret = strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1);
+		if (ret < 0) {
 			ret = -EFAULT;
 			break;
 		}
@@ -283,7 +285,6 @@ void ctrl_alt_del(void)
 		kill_cad_pid(SIGINT, 1);
 }
 
-
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 
 static int __orderly_poweroff(bool force)
@@ -301,14 +302,11 @@ static int __orderly_poweroff(bool force
 		ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 		argv_free(argv);
 	} else {
-		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
-					 __func__, poweroff_cmd);
 		ret = -ENOMEM;
 	}
 
 	if (ret && force) {
-		printk(KERN_WARNING "Failed to start orderly shutdown: "
-					"forcing the issue\n");
+		pr_warn("Failed to start orderly shutdown: forcing the issue\n");
 		/*
 		 * I guess this should try to kick off some daemon to sync and
 		 * poweroff asap.  Or not even bother syncing if we're doing an
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
migrate-shutdown-reboot-to-boot-cpu.patch
kernel-sysc-remove-stable-friendly-pf_thread_bound-define.patch
reboot-move-shutdown-reboot-related-functions-to-kernel-rebootc.patch
reboot-checkpatchpl-the-new-kernel-rebootc-file.patch
reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch
reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch

