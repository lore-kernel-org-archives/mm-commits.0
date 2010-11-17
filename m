From: akpm@linux-foundation.org
Subject: + kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths.patch added to -mm tree
Date: Wed, 17 Nov 2010 12:45:30 -0800
Message-ID: <201011172045.oAHKjU75004242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933011Ab0KQUqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Nov 2010 15:46:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seiji.aguchi@hds.com, dwmw2@infradead.org, marco.stornelli@gmail.com


The patch titled
     kmsg_dump: add kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart paths
has been added to the -mm tree.  Its filename is
     kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kmsg_dump: add kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart paths
From: Seiji Aguchi <seiji.aguchi@hds.com>

We need to know the reason why system rebooted in support service. 
However, we can't inform our customers of the reason because final
messages are lost on current Linux kernel.

This patch improves the situation above because the final messages are
saved by adding kmsg_dump() to reboot, halt, poweroff and
emergency_restart path.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmsg_dump.h |    4 ++++
 kernel/printk.c           |    4 ++++
 kernel/sys.c              |    6 ++++++
 3 files changed, 14 insertions(+)

diff -puN include/linux/kmsg_dump.h~kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths include/linux/kmsg_dump.h
--- a/include/linux/kmsg_dump.h~kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths
+++ a/include/linux/kmsg_dump.h
@@ -18,6 +18,10 @@ enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
 	KMSG_DUMP_KEXEC,
+	KMSG_DUMP_RESTART,
+	KMSG_DUMP_HALT,
+	KMSG_DUMP_POWEROFF,
+	KMSG_DUMP_EMERG,
 };
 
 /**
diff -puN kernel/printk.c~kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths kernel/printk.c
--- a/kernel/printk.c~kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths
+++ a/kernel/printk.c
@@ -1529,6 +1529,10 @@ static const char * const kmsg_reasons[]
 	[KMSG_DUMP_OOPS]	= "oops",
 	[KMSG_DUMP_PANIC]	= "panic",
 	[KMSG_DUMP_KEXEC]	= "kexec",
+	[KMSG_DUMP_RESTART]	= "restart",
+	[KMSG_DUMP_HALT]	= "halt",
+	[KMSG_DUMP_POWEROFF]	= "poweroff",
+	[KMSG_DUMP_EMERG]	= "emergency_restart",
 };
 
 static const char *kmsg_to_str(enum kmsg_dump_reason reason)
diff -puN kernel/sys.c~kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths kernel/sys.c
--- a/kernel/sys.c~kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths
+++ a/kernel/sys.c
@@ -43,6 +43,8 @@
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
 
+#include <linux/kmsg_dump.h>
+
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/unistd.h>
@@ -285,6 +287,7 @@ out_unlock:
  */
 void emergency_restart(void)
 {
+	kmsg_dump(KMSG_DUMP_EMERG);
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
@@ -312,6 +315,7 @@ void kernel_restart(char *cmd)
 		printk(KERN_EMERG "Restarting system.\n");
 	else
 		printk(KERN_EMERG "Restarting system with command '%s'.\n", cmd);
+	kmsg_dump(KMSG_DUMP_RESTART);
 	machine_restart(cmd);
 }
 EXPORT_SYMBOL_GPL(kernel_restart);
@@ -333,6 +337,7 @@ void kernel_halt(void)
 	kernel_shutdown_prepare(SYSTEM_HALT);
 	sysdev_shutdown();
 	printk(KERN_EMERG "System halted.\n");
+	kmsg_dump(KMSG_DUMP_HALT);
 	machine_halt();
 }
 
@@ -351,6 +356,7 @@ void kernel_power_off(void)
 	disable_nonboot_cpus();
 	sysdev_shutdown();
 	printk(KERN_EMERG "Power down.\n");
+	kmsg_dump(KMSG_DUMP_POWEROFF);
 	machine_power_off();
 }
 EXPORT_SYMBOL_GPL(kernel_power_off);
_

Patches currently in -mm which might be from seiji.aguchi@hds.com are

kmsg_dump-constrain-mtdoops-and-ramoops-to-perform-their-actions-only-for-kmsg_dump_panic.patch
kmsg_dump-add-kmsg_dump-calls-to-the-reboot-halt-poweroff-and-emergency_restart-paths.patch

