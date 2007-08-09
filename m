From: akpm@linux-foundation.org
Subject: + serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:26:47 -0700
Message-ID: <200708092026.l79KQlDX017864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51588 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbXHIU21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, pavel@ucw.cz, rjw@sisk.pl


The patch titled
     serial: turn serial console suspend a boot rather than compile time option
has been added to the -mm tree.  Its filename is
     serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: serial: turn serial console suspend a boot rather than compile time option
From: Andres Salomon <dilinger@queued.net>

Currently, there's a CONFIG_DISABLE_CONSOLE_SUSPEND that allows one to stop
the serial console from being suspended when the rest of the machine goes
to sleep.  This is incredibly useful for debugging power management-related
things; however, having it as a compile-time option has proved to be
incredibly inconvenient for us (OLPC).  There are plenty of times that we
want serial console to not suspend, but for the most part we'd like serial
console to be suspended.

This drops CONFIG_DISABLE_CONSOLE_SUSPEND, and replaces it with a kernel
boot parameter (no_console_suspend).  By default, the serial console will
be suspended along with the rest of the system; by passing
'no_console_suspend' to the kernel during boot, serial console will remain
alive during suspend.

I have another version of this patch which keeps #ifdefs around; however,
it's uglier.  I prefer this version of the patch, and don't feel that it
increases bloat.  If people strongly disagree, let me know and I'll submit
the other patch.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt        |    8 ++++++++
 Documentation/power/basic-pm-debugging.txt |    4 ++--
 arch/powerpc/configs/pmac32_defconfig      |    1 -
 drivers/serial/serial_core.c               |   10 ++++------
 include/linux/console.h                    |    7 ++-----
 kernel/power/Kconfig                       |   11 -----------
 kernel/printk.c                            |   15 +++++++++++++--
 7 files changed, 29 insertions(+), 27 deletions(-)

diff -puN Documentation/kernel-parameters.txt~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option
+++ a/Documentation/kernel-parameters.txt
@@ -477,6 +477,14 @@ and is between 256 and 4096 characters. 
 			UART at the specified I/O port or MMIO address.
 			The options are the same as for ttyS, above.
 
+	no_console_suspend
+			[HW] Never suspend the serial console
+			Disable suspending the serial console during
+			suspend/resume operations.  If disabled, debugging
+			messages can reach the console while the rest of
+			the system is being put to sleep (ie, while
+			debugging driver suspend/resume hooks).
+
 	cpcihp_generic=	[HW,PCI] Generic port I/O CompactPCI driver
 			Format:
 			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
diff -puN Documentation/power/basic-pm-debugging.txt~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option Documentation/power/basic-pm-debugging.txt
--- a/Documentation/power/basic-pm-debugging.txt~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option
+++ a/Documentation/power/basic-pm-debugging.txt
@@ -78,8 +78,8 @@ c) Advanced debugging
 In case the STD does not work on your system even in the minimal configuration
 and compiling more drivers as modules is not practical or some modules cannot
 be unloaded, you can use one of the more advanced debugging techniques to find
-the problem.  First, if there is a serial port in your box, you can set the
-CONFIG_DISABLE_CONSOLE_SUSPEND kernel configuration option and try to log kernel
+the problem.  First, if there is a serial port in your box, you boot the
+kernel with the 'no_console_suspend' parameter and try to log kernel
 messages using the serial console.  This may provide you with some information
 about the reasons of the suspend (resume) failure.  Alternatively, it may be
 possible to use a FireWire port for debugging with firescope
diff -puN arch/powerpc/configs/pmac32_defconfig~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option arch/powerpc/configs/pmac32_defconfig
--- a/arch/powerpc/configs/pmac32_defconfig~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option
+++ a/arch/powerpc/configs/pmac32_defconfig
@@ -216,7 +216,6 @@ CONFIG_PROC_DEVICETREE=y
 CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 CONFIG_PM_DEBUG=y
-# CONFIG_DISABLE_CONSOLE_SUSPEND is not set
 CONFIG_PM_SYSFS_DEPRECATED=y
 CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
diff -puN drivers/serial/serial_core.c~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option drivers/serial/serial_core.c
--- a/drivers/serial/serial_core.c~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option
+++ a/drivers/serial/serial_core.c
@@ -1954,12 +1954,11 @@ int uart_suspend_port(struct uart_driver
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (!serial_console_suspend_enabled && uart_console(port)) {
+		/* we're going to avoid suspending serial console */
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	if (state->info && state->info->flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
@@ -2002,12 +2001,11 @@ int uart_resume_port(struct uart_driver 
 
 	mutex_lock(&state->mutex);
 
-#ifdef CONFIG_DISABLE_CONSOLE_SUSPEND
-	if (uart_console(port)) {
+	if (!serial_console_suspend_enabled && uart_console(port)) {
+		/* no need to resume serial console, it wasn't suspended */
 		mutex_unlock(&state->mutex);
 		return 0;
 	}
-#endif
 
 	uart_change_pm(state, 0);
 
diff -puN include/linux/console.h~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option include/linux/console.h
--- a/include/linux/console.h~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option
+++ a/include/linux/console.h
@@ -121,14 +121,11 @@ extern void console_stop(struct console 
 extern void console_start(struct console *);
 extern int is_console_locked(void);
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
+extern int serial_console_suspend_enabled;
+
 /* Suspend and resume console messages over PM events */
 extern void suspend_console(void);
 extern void resume_console(void);
-#else
-static inline void suspend_console(void) {}
-static inline void resume_console(void) {}
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 int mda_console_init(void);
 void prom_con_init(void);
diff -puN kernel/power/Kconfig~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option kernel/power/Kconfig
--- a/kernel/power/Kconfig~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option
+++ a/kernel/power/Kconfig
@@ -44,17 +44,6 @@ config PM_VERBOSE
 	---help---
 	This option enables verbose messages from the Power Management code.
 
-config DISABLE_CONSOLE_SUSPEND
-	bool "Keep console(s) enabled during suspend/resume (DANGEROUS)"
-	depends on PM_DEBUG && PM_SLEEP
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
 	depends on PM_DEBUG && X86 && PM_SLEEP && EXPERIMENTAL
diff -puN kernel/printk.c~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option kernel/printk.c
--- a/kernel/printk.c~serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option
+++ a/kernel/printk.c
@@ -810,7 +810,15 @@ int update_console_cmdline(char *name, i
 	return -1;
 }
 
-#ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
+int serial_console_suspend_enabled = 1;
+
+static int __init console_suspend_disable(char *str)
+{
+	serial_console_suspend_enabled = 0;
+	return 1;
+}
+__setup("no_console_suspend", console_suspend_disable);
+
 /**
  * suspend_console - suspend the console subsystem
  *
@@ -818,6 +826,8 @@ int update_console_cmdline(char *name, i
  */
 void suspend_console(void)
 {
+	if (!serial_console_suspend_enabled)
+		return;
 	printk("Suspending console(s)\n");
 	acquire_console_sem();
 	console_suspended = 1;
@@ -825,10 +835,11 @@ void suspend_console(void)
 
 void resume_console(void)
 {
+	if (!serial_console_suspend_enabled)
+		return;
 	console_suspended = 0;
 	release_console_sem();
 }
-#endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
 
 /**
  * acquire_console_sem - lock the console system for exclusive use.
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
