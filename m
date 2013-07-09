From: akpm@linux-foundation.org
Subject: [merged] reboot-checkpatchpl-the-new-kernel-rebootc-file.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:22:12 -0700
Message-ID: <51dc9b24.mB+JYoro6/Yvcoxo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab3GIXWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:22:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rmk+kernel@arm.linux.org.uk, rja@sgi.com, mingo@kernel.org, hpa@zytor.com, gxt@mprc.pku.edu.cn, holt@sgi.com

Subject: [merged] reboot-checkpatchpl-the-new-kernel-rebootc-file.patch removed from -mm tree
To: holt@sgi.com,gxt@mprc.pku.edu.cn,hpa@zytor.com,mingo@kernel.org,rja@sgi.com,rmk+kernel@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:22:12 -0700


The patch titled
     Subject: reboot: checkpatch.pl the new kernel/reboot.c file
has been removed from the -mm tree.  Its filename was
     reboot-checkpatchpl-the-new-kernel-rebootc-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: checkpatch.pl the new kernel/reboot.c file

Get the new file to pass scripts/checkpatch.pl

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    2 +-
 kernel/reboot.c        |   27 +++++++++++++--------------
 2 files changed, 14 insertions(+), 15 deletions(-)

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
@@ -300,14 +302,11 @@ static int __orderly_poweroff(bool force
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

