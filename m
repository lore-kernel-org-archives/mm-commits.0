From: akpm@linux-foundation.org
Subject: + printk-fix-delayed-messages-from-cpu-hotplug-events.patch added to -mm tree
Date: Thu, 03 Jun 2010 22:59:01 -0700
Message-ID: <201006040558.o545wwVB009958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147Ab0FDF7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Jun 2010 01:59:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cernekee@gmail.com, lethal@linux-sh.org


The patch titled
     printk: fix delayed messages from CPU hotplug events
has been added to the -mm tree.  Its filename is
     printk-fix-delayed-messages-from-cpu-hotplug-events.patch

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
Subject: printk: fix delayed messages from CPU hotplug events
From: Kevin Cernekee <cernekee@gmail.com>

When a secondary CPU is being brought up, it is not uncommon for printk()
to be invoked when cpu_online(smp_processor_id()) == 0.  The case that I
witnessed personally was on MIPS:

http://lkml.org/lkml/2010/5/30/4

If (can_use_console() == 0), printk() will spool its output to log_buf and
it will be visible in "dmesg", but that output will NOT be echoed to the
console until somebody calls release_console_sem() from a CPU that is
online.  Therefore, the boot time messages from the new CPU can get stuck
in "limbo" for a long time, and might suddenly appear on the screen when a
completely unrelated event (e.g.  "eth0: link is down") occurs.

This patch modifies the console code so that any pending messages are
automatically flushed out to the console whenever a CPU hotplug operation
completes successfully or aborts.

The issue was seen on 2.6.34.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
Reviewed-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

diff -puN kernel/printk.c~printk-fix-delayed-messages-from-cpu-hotplug-events kernel/printk.c
--- a/kernel/printk.c~printk-fix-delayed-messages-from-cpu-hotplug-events
+++ a/kernel/printk.c
@@ -37,6 +37,8 @@
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
 #include <linux/syslog.h>
+#include <linux/cpu.h>
+#include <linux/notifier.h>
 
 #include <asm/uaccess.h>
 
@@ -985,6 +987,33 @@ void resume_console(void)
 }
 
 /**
+ * console_cpu_notify - print deferred console messages after CPU hotplug
+ * @self: notifier struct
+ * @action: CPU hotplug event
+ * @hcpu: unused
+ *
+ * If printk() is called from a CPU that is not online yet, the messages
+ * will be spooled but will not show up on the console.  This function is
+ * called when a new CPU comes online (or fails to come up), and ensures
+ * that any such output gets printed.
+ */
+static int __cpuinit console_cpu_notify(struct notifier_block *self,
+	unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_UP_CANCELED:
+		acquire_console_sem();
+		release_console_sem();
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata console_nb = {
+	.notifier_call		= console_cpu_notify,
+};
+
+/**
  * acquire_console_sem - lock the console system for exclusive use.
  *
  * Acquires a semaphore which guarantees that the caller has
@@ -1371,7 +1400,7 @@ int unregister_console(struct console *c
 }
 EXPORT_SYMBOL(unregister_console);
 
-static int __init disable_boot_consoles(void)
+static int __init printk_late_init(void)
 {
 	struct console *con;
 
@@ -1382,9 +1411,10 @@ static int __init disable_boot_consoles(
 			unregister_console(con);
 		}
 	}
+	register_hotcpu_notifier(&console_nb);
 	return 0;
 }
-late_initcall(disable_boot_consoles);
+late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
 
_

Patches currently in -mm which might be from cernekee@gmail.com are

printk-fix-delayed-messages-from-cpu-hotplug-events.patch
printk-fix-delayed-messages-from-cpu-hotplug-events-fix.patch

