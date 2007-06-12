From: akpm@linux-foundation.org
Subject: + make-disable_console_suspend-runtime-configurable.patch added to -mm tree
Date: Tue, 12 Jun 2007 12:34:39 -0700
Message-ID: <200706121934.l5CJYdC3019603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57819 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752910AbXFLTfP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 15:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seife@suse.de, nigel@nigel.suspend2.net, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     make disable_console_suspend runtime configurable
has been added to the -mm tree.  Its filename is
     make-disable_console_suspend-runtime-configurable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make disable_console_suspend runtime configurable
From: Stefan Seyfried <seife@suse.de>

I hate having to recompile the kernel, just to be able to debug suspend. 
Remove CONFIG_DISABLE_CONSOLE_SUSPEND, replace it by a sysctl in
/proc/sys/kernel/disable_console_suspend.

Signed-off-by: Stefan Seyfried <seife@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/basic-pm-debugging.txt |   16 +++++++++-------
 drivers/serial/serial_core.c               |    8 ++------
 include/linux/console.h                    |    7 ++-----
 include/linux/sysctl.h                     |    1 +
 kernel/power/Kconfig                       |   11 -----------
 kernel/printk.c                            |    7 +++++--
 kernel/sysctl.c                            |    9 +++++++++
 7 files changed, 28 insertions(+), 31 deletions(-)

diff -puN Documentation/power/basic-pm-debugging.txt~make-disable_console_suspend-runtime-configurable Documentation/power/basic-pm-debugging.txt
--- a/Documentation/power/basic-pm-debugging.txt~make-disable_console_suspend-runtime-configurable
+++ a/Documentation/power/basic-pm-debugging.txt
@@ -78,13 +78,15 @@ c) Advanced debugging
 In case the STD does not work on your system even in the minimal configuration
 and compiling more drivers as modules is not practical or some modules cannot
 be unloaded, you can use one of the more advanced debugging techniques to find
-the problem.  First, if there is a serial port in your box, you can set the
-CONFIG_DISABLE_CONSOLE_SUSPEND kernel configuration option and try to log kernel
-messages using the serial console.  This may provide you with some information
-about the reasons of the suspend (resume) failure.  Alternatively, it may be
-possible to use a FireWire port for debugging with firescope
-(ftp://ftp.firstfloor.org/pub/ak/firescope/).  On i386 it is also possible to
-use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
+the problem.  First, if there is a serial port in your box, you can
+
+# echo 1 > /proc/sys/kernel/disable_console_suspend
+
+and try to log kernel messages using the serial console.  This may provide you
+with some information about the reasons of the suspend (resume) failure.
+Alternatively, it may be possible to use a FireWire port for debugging with
+firescope (ftp://ftp.firstfloor.org/pub/ak/firescope/).  On i386 it is also
+possible to use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
 
 2. Testing suspend to RAM (STR)
 
diff -puN drivers/serial/serial_core.c~make-disable_console_suspend-runtime-configurable drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~make-disable_console_suspend-runtime-configurable
+++ a/drivers/serial/serial_core.c
@@ -1948,12 +1948,10 @@ int uart_suspend_port(struct uart_driver
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (disable_console_suspend && uart_console(port)) {
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	if (state->info && state->info->flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
@@ -1996,12 +1994,10 @@ int uart_resume_port(struct uart_driver 
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (disable_console_suspend && uart_console(port)) {
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	uart_change_pm(state, 0);
 
diff -puN include/linux/console.h~make-disable_console_suspend-runtime-configurable include/linux/console.h
--- a/include/linux/console.h~make-disable_console_suspend-runtime-configurable
+++ a/include/linux/console.h
@@ -64,6 +64,8 @@ extern const struct consw vga_con;	/* VG
 extern const struct consw newport_con;	/* SGI Newport console  */
 extern const struct consw prom_con;	/* SPARC PROM console */
 
+extern int disable_console_suspend;
+
 int con_is_bound(const struct consw *csw);
 int register_con_driver(const struct consw *csw, int first, int last);
 int unregister_con_driver(const struct consw *csw);
@@ -122,14 +124,9 @@ extern void console_stop(struct console 
 extern void console_start(struct console *);
 extern int is_console_locked(void);
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
 /* Suspend and resume console messages over PM events */
 extern void suspend_console(void);
 extern void resume_console(void);
-#else
-static inline void suspend_console(void) {}
-static inline void resume_console(void) {}
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 int mda_console_init(void);
 void prom_con_init(void);
diff -puN include/linux/sysctl.h~make-disable_console_suspend-runtime-configurable include/linux/sysctl.h
--- a/include/linux/sysctl.h~make-disable_console_suspend-runtime-configurable
+++ a/include/linux/sysctl.h
@@ -166,6 +166,7 @@ enum
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
 	KERN_POWEROFF_CMD=77,	/* string: poweroff command line */
+	KERN_CONSOLE_SUSPEND=78, /* int: disable consoles on system suspend */
 };
 
 
diff -puN kernel/power/Kconfig~make-disable_console_suspend-runtime-configurable kernel/power/Kconfig
--- a/kernel/power/Kconfig~make-disable_console_suspend-runtime-configurable
+++ a/kernel/power/Kconfig
@@ -44,17 +44,6 @@ config PM_VERBOSE
 	---help---
 	This option enables verbose messages from the Power Management code.
 
-config DISABLE_CONSOLE_SUSPEND
-	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
-	depends on PM_DEBUG
-	default n
-	---help---
-	This option turns off the console suspend mechanism that prevents
-	debug messages from reaching the console during the suspend/resume
-	operations.  This may be helpful when debugging device drivers'
-	suspend/resume routines, but may itself lead to problems, for example
-	if netconsole is used.
-
 config PM_TRACE
 	bool "Suspend/resume event tracing"
 	depends on PM_DEBUG && X86 && EXPERIMENTAL
diff -puN kernel/printk.c~make-disable_console_suspend-runtime-configurable kernel/printk.c
--- a/kernel/printk.c~make-disable_console_suspend-runtime-configurable
+++ a/kernel/printk.c
@@ -76,6 +76,7 @@ struct console *console_drivers;
  * locked without the console sempahore held
  */
 static int console_locked, console_suspended;
+int disable_console_suspend;
 
 /*
  * logbuf_lock protects log_buf, log_start, log_end, con_start and logged_chars
@@ -745,7 +746,6 @@ int __init update_console_cmdline(char *
 	return -1;
 }
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
 /**
  * suspend_console - suspend the console subsystem
  *
@@ -753,6 +753,8 @@ int __init update_console_cmdline(char *
  */
 void suspend_console(void)
 {
+	if (disable_console_suspend)
+		return;
 	printk("Suspending console(s)\n");
 	acquire_console_sem();
 	console_suspended = 1;
@@ -760,10 +762,11 @@ void suspend_console(void)
 
 void resume_console(void)
 {
+	if (disable_console_suspend)
+		return;
 	console_suspended = 0;
 	release_console_sem();
 }
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 /**
  * acquire_console_sem - lock the console system for exclusive use.
diff -puN kernel/sysctl.c~make-disable_console_suspend-runtime-configurable kernel/sysctl.c
--- a/kernel/sysctl.c~make-disable_console_suspend-runtime-configurable
+++ a/kernel/sysctl.c
@@ -46,6 +46,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/console.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -585,6 +586,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
 #endif
+	{
+		.ctl_name	= KERN_CONSOLE_SUSPEND,
+		.procname	= "disable_console_suspend",
+		.data		= &disable_console_suspend,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_IA64
 	{
 		.ctl_name	= KERN_IA64_UNALIGNED,
_

Patches currently in -mm which might be from seife@suse.de are

make-disable_console_suspend-runtime-configurable.patch
make-disable_console_suspend-runtime-configurable-fix.patch
