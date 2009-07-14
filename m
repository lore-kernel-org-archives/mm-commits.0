From: akpm@linux-foundation.org
Subject: [merged] kernel-printkc-handle-more-than-one-con_boot.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:31 -0700
Message-ID: <200907142033.n6EKXVAo013687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408AbZGNUfJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:35:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgetz@blackfin.uclinux.org, lethal@linux-sh.org, mingo@elte.hu, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     kernel/printk.c: handle more than one CON_BOOT
has been removed from the -mm tree.  Its filename was
     kernel-printkc-handle-more-than-one-con_boot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/printk.c: handle more than one CON_BOOT
From: Robin Getz <rgetz@blackfin.uclinux.org>

Today, register_console() assumes the following usage:

  - The first console to register with a flag set to CON_BOOT is the
    one and only bootconsole.
  - If another register_console() is called with an additional CON_BOOT,
    it is silently rejected.
  - As soon as a console without the CON_BOOT set calls registers
    the bootconsole is automatically unregistered.
  - Once there is a "real" console - register_console() will silently
    reject any consoles with it's CON_BOOT flag set.

In many systems (alpha, blackfin, microblaze, mips, powerpc, sh, & x86),
there are early_printk implementations, which use the CON_BOOT which come
out serial ports, vga, usb, & memory buffers.  In many embedded systems,
it would be nice to have two - in case the primary fails, you always have
access to a backup memory buffer - but this requires at least two CON_BOOT
consoles.

This changeset allows multiple boot consoles, and changes the functionality
to, be mostly the same as the above.

 - Any number CON_BOOT consoles of can be registered
 - A "real" console will unregister all the CON_BOOT consoles
 - Once a "real" console is registered, no more CON_BOOT consoles
   can be added (still silently rejected)

With the changeset, on boot you get:

root:/> dmesg | grep console
bootconsole [early_shadow0] enabled
bootconsole [early_BFuart0] enabled
Kernel command line: root=/dev/mtdblock0 rw earlyprintk=serial,uart0,57600 earlyprintk=shadow console=ttyBF0,57600
console handover:boot [early_BFuart0] boot [early_shadow0]  -> real [ttyBF0]

or

root:/> dmesg | grep console
Kernel command line: root=/dev/mtdblock0 rw console=ttyBF0,57600
console [ttyBF0] enabled

Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |  127 +++++++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 52 deletions(-)

diff -puN kernel/printk.c~kernel-printkc-handle-more-than-one-con_boot kernel/printk.c
--- a/kernel/printk.c~kernel-printkc-handle-more-than-one-con_boot
+++ a/kernel/printk.c
@@ -37,6 +37,12 @@
 #include <asm/uaccess.h>
 
 /*
+ * for_each_console() allows you to iterate on each console
+ */
+#define for_each_console(con) \
+	for (con = console_drivers; con != NULL; con = con->next)
+
+/*
  * Architectures can override it:
  */
 void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
@@ -410,7 +416,7 @@ static void __call_console_drivers(unsig
 {
 	struct console *con;
 
-	for (con = console_drivers; con; con = con->next) {
+	for_each_console(con) {
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
@@ -542,7 +548,7 @@ static int have_callable_console(void)
 {
 	struct console *con;
 
-	for (con = console_drivers; con; con = con->next)
+	for_each_console(con)
 		if (con->flags & CON_ANYTIME)
 			return 1;
 
@@ -1095,7 +1101,7 @@ void console_unblank(void)
 
 	console_locked = 1;
 	console_may_schedule = 0;
-	for (c = console_drivers; c != NULL; c = c->next)
+	for_each_console(c)
 		if ((c->flags & CON_ENABLED) && c->unblank)
 			c->unblank();
 	release_console_sem();
@@ -1110,7 +1116,7 @@ struct tty_driver *console_device(int *i
 	struct tty_driver *driver = NULL;
 
 	acquire_console_sem();
-	for (c = console_drivers; c != NULL; c = c->next) {
+	for_each_console(c) {
 		if (!c->device)
 			continue;
 		driver = c->device(c, index);
@@ -1148,24 +1154,33 @@ EXPORT_SYMBOL(console_start);
  * print any messages that were printed by the kernel before the
  * console driver was initialized.
  */
-void register_console(struct console *console)
+void register_console(struct console *newcon)
 {
 	int i;
 	unsigned long flags;
-	struct console *bootconsole = NULL;
+	struct console *bcon = NULL;
 
+	/*
+	 * before we register a new CON_BOOT console, make sure we don't
+	 * already have a valid console
+	 */
 	if (console_drivers) {
-		if (console->flags & CON_BOOT)
-			return;
+		if (newcon->flags & CON_BOOT) {
+			/* find the last or real console */
+			for_each_console(bcon) {
+				if (!(bcon->flags & CON_BOOT))
+					return;
+			}
+		}
 		if (console_drivers->flags & CON_BOOT)
-			bootconsole = console_drivers;
+			bcon = console_drivers;
 	}
 
-	if (preferred_console < 0 || bootconsole || !console_drivers)
+	if (preferred_console < 0 || bcon || !console_drivers)
 		preferred_console = selected_console;
 
-	if (console->early_setup)
-		console->early_setup();
+	if (newcon->early_setup)
+		newcon->early_setup();
 
 	/*
 	 *	See if we want to use this console driver. If we
@@ -1173,13 +1188,13 @@ void register_console(struct console *co
 	 *	that registers here.
 	 */
 	if (preferred_console < 0) {
-		if (console->index < 0)
-			console->index = 0;
-		if (console->setup == NULL ||
-		    console->setup(console, NULL) == 0) {
-			console->flags |= CON_ENABLED;
-			if (console->device) {
-				console->flags |= CON_CONSDEV;
+		if (newcon->index < 0)
+			newcon->index = 0;
+		if (newcon->setup == NULL ||
+		    newcon->setup(newcon, NULL) == 0) {
+			newcon->flags |= CON_ENABLED;
+			if (newcon->device) {
+				newcon->flags |= CON_CONSDEV;
 				preferred_console = 0;
 			}
 		}
@@ -1191,47 +1206,53 @@ void register_console(struct console *co
 	 */
 	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0];
 			i++) {
-		if (strcmp(console_cmdline[i].name, console->name) != 0)
+		if (strcmp(console_cmdline[i].name, newcon->name) != 0)
 			continue;
-		if (console->index >= 0 &&
-		    console->index != console_cmdline[i].index)
+		if (newcon->index >= 0 &&
+		    newcon->index != console_cmdline[i].index)
 			continue;
-		if (console->index < 0)
-			console->index = console_cmdline[i].index;
+		if (newcon->index < 0)
+			newcon->index = console_cmdline[i].index;
 #ifdef CONFIG_A11Y_BRAILLE_CONSOLE
 		if (console_cmdline[i].brl_options) {
-			console->flags |= CON_BRL;
-			braille_register_console(console,
+			newcon->flags |= CON_BRL;
+			braille_register_console(newcon,
 					console_cmdline[i].index,
 					console_cmdline[i].options,
 					console_cmdline[i].brl_options);
 			return;
 		}
 #endif
-		if (console->setup &&
-		    console->setup(console, console_cmdline[i].options) != 0)
+		if (newcon->setup &&
+		    newcon->setup(newcon, console_cmdline[i].options) != 0)
 			break;
-		console->flags |= CON_ENABLED;
-		console->index = console_cmdline[i].index;
+		newcon->flags |= CON_ENABLED;
+		newcon->index = console_cmdline[i].index;
 		if (i == selected_console) {
-			console->flags |= CON_CONSDEV;
+			newcon->flags |= CON_CONSDEV;
 			preferred_console = selected_console;
 		}
 		break;
 	}
 
-	if (!(console->flags & CON_ENABLED))
+	if (!(newcon->flags & CON_ENABLED))
 		return;
 
-	if (bootconsole && (console->flags & CON_CONSDEV)) {
-		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
-		       bootconsole->name, bootconsole->index,
-		       console->name, console->index);
-		unregister_console(bootconsole);
-		console->flags &= ~CON_PRINTBUFFER;
+	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV)) {
+		/* we need to iterate through twice, to make sure we print
+		 * everything out, before we unregister the console(s)
+		 */
+		printk(KERN_INFO "console handover:");
+		for_each_console(bcon)
+			printk("boot [%s%d] ", bcon->name, bcon->index);
+		printk(" -> real [%s%d]\n", newcon->name, newcon->index);
+		for_each_console(bcon)
+			unregister_console(bcon);
+		newcon->flags &= ~CON_PRINTBUFFER;
 	} else {
-		printk(KERN_INFO "console [%s%d] enabled\n",
-		       console->name, console->index);
+		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+			(newcon->flags & CON_BOOT) ? "boot" : "" ,
+			newcon->name, newcon->index);
 	}
 
 	/*
@@ -1239,16 +1260,16 @@ void register_console(struct console *co
 	 *	preferred driver at the head of the list.
 	 */
 	acquire_console_sem();
-	if ((console->flags & CON_CONSDEV) || console_drivers == NULL) {
-		console->next = console_drivers;
-		console_drivers = console;
-		if (console->next)
-			console->next->flags &= ~CON_CONSDEV;
+	if ((newcon->flags & CON_CONSDEV) || console_drivers == NULL) {
+		newcon->next = console_drivers;
+		console_drivers = newcon;
+		if (newcon->next)
+			newcon->next->flags &= ~CON_CONSDEV;
 	} else {
-		console->next = console_drivers->next;
-		console_drivers->next = console;
+		newcon->next = console_drivers->next;
+		console_drivers->next = newcon;
 	}
-	if (console->flags & CON_PRINTBUFFER) {
+	if (newcon->flags & CON_PRINTBUFFER) {
 		/*
 		 * release_console_sem() will print out the buffered messages
 		 * for us.
@@ -1300,11 +1321,13 @@ EXPORT_SYMBOL(unregister_console);
 
 static int __init disable_boot_consoles(void)
 {
-	if (console_drivers != NULL) {
-		if (console_drivers->flags & CON_BOOT) {
+	struct console *con;
+
+	for_each_console(con) {
+		if (con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
-				console_drivers->name, console_drivers->index);
-			return unregister_console(console_drivers);
+				con->name, con->index);
+			return unregister_console(con);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from rgetz@blackfin.uclinux.org are

linux-next.patch
asm-sections-add-text-data-checking-functions-for-arches-to-override.patch
kallsyms-use-new-arch_is_kernel_text.patch
lockdep-use-new-arch_is_kernel_data.patch
blackfin-override-text-data-checking-functions.patch

