From: akpm@linux-foundation.org
Subject: + add-common-orderly_poweroff.patch added to -mm tree
Date: Fri, 11 May 2007 12:27:09 -0700
Message-ID: <200705111927.l4BJR9i1024508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759623AbXEKTaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, akpm@linux-foundation.org, arnd@arndb.de, chrisw@sous-sol.org, davem@davemloft.net, jeremy@xensource.com, lenb@kernel.org, randy.dunlap@oracle.com, rjw@sisk.pl, viro@zeniv.linux.org.uk


The patch titled
     Add common orderly_poweroff()
has been added to the -mm tree.  Its filename is
     add-common-orderly_poweroff.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add common orderly_poweroff()
From: Jeremy Fitzhardinge <jeremy@goop.org>

Various pieces of code around the kernel want to be able to trigger an orderly
poweroff.  This pulls them together into a single implementation.

By default the poweroff command is /sbin/poweroff, but it can be set via
sysctl: kernel/poweroff_cmd.  This is split at whitespace, so it can include
command-line arguments.

This patch replaces four other instances of invoking either "poweroff" or
"shutdown -h now": one sparc64, two sbus drivers, and acpi thermal management.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Len Brown <lenb@kernel.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/power.c     |   40 +-------------------
 drivers/acpi/thermal.c          |   24 +-----------
 drivers/sbus/char/bbc_envctrl.c |    5 +-
 drivers/sbus/char/envctrl.c     |    7 +--
 include/linux/reboot.h          |    5 ++
 include/linux/sysctl.h          |    1 
 kernel/sys.c                    |   58 ++++++++++++++++++++++++++++++
 kernel/sysctl.c                 |   10 +++++
 8 files changed, 82 insertions(+), 68 deletions(-)

diff -puN arch/sparc64/kernel/power.c~add-common-orderly_poweroff arch/sparc64/kernel/power.c
--- a/arch/sparc64/kernel/power.c~add-common-orderly_poweroff
+++ a/arch/sparc64/kernel/power.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/pm.h>
 #include <linux/syscalls.h>
+#include <linux/reboot.h>
 
 #include <asm/system.h>
 #include <asm/auxio.h>
@@ -32,14 +33,13 @@ int scons_pwroff = 1; 
 #include <linux/pci.h>
 static void __iomem *power_reg;
 
-static DECLARE_WAIT_QUEUE_HEAD(powerd_wait);
 static int button_pressed;
 
 static irqreturn_t power_handler(int irq, void *dev_id)
 {
 	if (button_pressed == 0) {
 		button_pressed = 1;
-		wake_up(&powerd_wait);
+		orderly_poweroff(true);
 	}
 
 	/* FIXME: Check registers for status... */
@@ -75,36 +75,6 @@ void (*pm_power_off)(void) = machine_pow
 EXPORT_SYMBOL(pm_power_off);
 
 #ifdef CONFIG_PCI
-static int powerd(void *__unused)
-{
-	static char *envp[] = { "HOME=/", "TERM=linux", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
-	char *argv[] = { "/sbin/shutdown", "-h", "now", NULL };
-	DECLARE_WAITQUEUE(wait, current);
-
-	daemonize("powerd");
-
-	add_wait_queue(&powerd_wait, &wait);
-again:
-	for (;;) {
-		set_task_state(current, TASK_INTERRUPTIBLE);
-		if (button_pressed)
-			break;
-		flush_signals(current);
-		schedule();
-	}
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&powerd_wait, &wait);
-
-	/* Ok, down we go... */
-	button_pressed = 0;
-	if (kernel_execve("/sbin/shutdown", argv, envp) < 0) {
-		printk("powerd: shutdown execution failed\n");
-		add_wait_queue(&powerd_wait, &wait);
-		goto again;
-	}
-	return 0;
-}
-
 static int __init has_button_interrupt(unsigned int irq, struct device_node *dp)
 {
 	if (irq == PCI_IRQ_NONE)
@@ -128,12 +98,6 @@ static int __devinit power_probe(struct 
 	poweroff_method = machine_halt;  /* able to use the standard halt */
 
 	if (has_button_interrupt(irq, op->node)) {
-		if (kernel_thread(powerd, NULL, CLONE_FS) < 0) {
-			printk("Failed to start power daemon.\n");
-			return 0;
-		}
-		printk("powerd running.\n");
-
 		if (request_irq(irq,
 				power_handler, 0, "power", NULL) < 0)
 			printk("power: Error, cannot register IRQ handler.\n");
diff -puN drivers/acpi/thermal.c~add-common-orderly_poweroff drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~add-common-orderly_poweroff
+++ a/drivers/acpi/thermal.c
@@ -40,6 +40,7 @@
 #include <linux/jiffies.h>
 #include <linux/kmod.h>
 #include <linux/seq_file.h>
+#include <linux/reboot.h>
 #include <asm/uaccess.h>
 
 #include <acpi/acpi_bus.h>
@@ -59,7 +60,6 @@
 #define ACPI_THERMAL_NOTIFY_CRITICAL	0xF0
 #define ACPI_THERMAL_NOTIFY_HOT		0xF1
 #define ACPI_THERMAL_MODE_ACTIVE	0x00
-#define ACPI_THERMAL_PATH_POWEROFF	"/sbin/poweroff"
 
 #define ACPI_THERMAL_MAX_ACTIVE	10
 #define ACPI_THERMAL_MAX_LIMIT_STR_LEN 65
@@ -419,26 +419,6 @@ static int acpi_thermal_get_devices(stru
 	return 0;
 }
 
-static int acpi_thermal_call_usermode(char *path)
-{
-	char *argv[2] = { NULL, NULL };
-	char *envp[3] = { NULL, NULL, NULL };
-
-
-	if (!path)
-		return -EINVAL;
-
-	argv[0] = path;
-
-	/* minimal command environment */
-	envp[0] = "HOME=/";
-	envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
-
-	call_usermodehelper(argv[0], argv, envp, 0);
-
-	return 0;
-}
-
 static int acpi_thermal_critical(struct acpi_thermal *tz)
 {
 	if (!tz || !tz->trips.critical.flags.valid)
@@ -456,7 +436,7 @@ static int acpi_thermal_critical(struct 
 	acpi_bus_generate_event(tz->device, ACPI_THERMAL_NOTIFY_CRITICAL,
 				tz->trips.critical.flags.enabled);
 
-	acpi_thermal_call_usermode(ACPI_THERMAL_PATH_POWEROFF);
+	orderly_poweroff(true);
 
 	return 0;
 }
diff -puN drivers/sbus/char/bbc_envctrl.c~add-common-orderly_poweroff drivers/sbus/char/bbc_envctrl.c
--- a/drivers/sbus/char/bbc_envctrl.c~add-common-orderly_poweroff
+++ a/drivers/sbus/char/bbc_envctrl.c
@@ -7,6 +7,7 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/kmod.h>
+#include <linux/reboot.h>
 #include <asm/oplib.h>
 #include <asm/ebus.h>
 
@@ -170,8 +171,6 @@ static void get_current_temps(struct bbc
 static void do_envctrl_shutdown(struct bbc_cpu_temperature *tp)
 {
 	static int shutting_down = 0;
-	static char *envp[] = { "HOME=/", "TERM=linux", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
-	char *argv[] = { "/sbin/shutdown", "-h", "now", NULL };
 	char *type = "???";
 	s8 val = -1;
 
@@ -195,7 +194,7 @@ static void do_envctrl_shutdown(struct b
 	printk(KERN_CRIT "kenvctrld: Shutting down the system now.\n");
 
 	shutting_down = 1;
-	if (call_usermodehelper("/sbin/shutdown", argv, envp, 0) < 0)
+	if (orderly_poweroff(true) < 0)
 		printk(KERN_CRIT "envctrl: shutdown execution failed\n");
 }
 
diff -puN drivers/sbus/char/envctrl.c~add-common-orderly_poweroff drivers/sbus/char/envctrl.c
--- a/drivers/sbus/char/envctrl.c~add-common-orderly_poweroff
+++ a/drivers/sbus/char/envctrl.c
@@ -26,6 +26,7 @@
 #include <linux/ioport.h>
 #include <linux/miscdevice.h>
 #include <linux/kmod.h>
+#include <linux/reboot.h>
 
 #include <asm/ebus.h>
 #include <asm/uaccess.h>
@@ -965,10 +966,6 @@ static struct i2c_child_t *envctrl_get_i
 static void envctrl_do_shutdown(void)
 {
 	static int inprog = 0;
-	static char *envp[] = {	
-		"HOME=/", "TERM=linux", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
-	char *argv[] = { 
-		"/sbin/shutdown", "-h", "now", NULL };	
 	int ret;
 
 	if (inprog != 0)
@@ -976,7 +973,7 @@ static void envctrl_do_shutdown(void)
 
 	inprog = 1;
 	printk(KERN_CRIT "kenvctrld: WARNING: Shutting down the system now.\n");
-	ret = call_usermodehelper("/sbin/shutdown", argv, envp, 0);
+	ret = orderly_poweroff(true);
 	if (ret < 0) {
 		printk(KERN_CRIT "kenvctrld: WARNING: system shutdown failed!\n"); 
 		inprog = 0;  /* unlikely to succeed, but we could try again */
diff -puN include/linux/reboot.h~add-common-orderly_poweroff include/linux/reboot.h
--- a/include/linux/reboot.h~add-common-orderly_poweroff
+++ a/include/linux/reboot.h
@@ -67,6 +67,11 @@ extern void kernel_power_off(void);
 
 void ctrl_alt_del(void);
 
+#define POWEROFF_CMD_PATH_LEN	256
+extern char poweroff_cmd[POWEROFF_CMD_PATH_LEN];
+
+extern int orderly_poweroff(bool force);
+
 /*
  * Emergency restart, callable from an interrupt handler.
  */
diff -puN include/linux/sysctl.h~add-common-orderly_poweroff include/linux/sysctl.h
--- a/include/linux/sysctl.h~add-common-orderly_poweroff
+++ a/include/linux/sysctl.h
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_POWEROFF_CMD=77,	/* string: poweroff command line */
 };
 
 
diff -puN kernel/sys.c~add-common-orderly_poweroff kernel/sys.c
--- a/kernel/sys.c~add-common-orderly_poweroff
+++ a/kernel/sys.c
@@ -2277,3 +2277,61 @@ asmlinkage long sys_getcpu(unsigned __us
 	}
 	return err ? -EFAULT : 0;
 }
+
+char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
+
+static void argv_cleanup(char **argv, char **envp)
+{
+	argv_free(argv);
+}
+
+/**
+ * Trigger an orderly system poweroff
+ * @force: force poweroff if command execution fails
+ *
+ * This may be called from any context to trigger a system shutdown.
+ * If the orderly shutdown fails, it will force an immediate shutdown.
+ */
+int orderly_poweroff(bool force)
+{
+	int argc;
+	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
+	static char *envp[] = {
+		"HOME=/",
+		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
+		NULL
+	};
+	int ret = -ENOMEM;
+	struct subprocess_info *info;
+
+	if (argv == NULL) {
+		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
+		       __func__, poweroff_cmd);
+		goto out;
+	}
+
+	info = call_usermodehelper_setup(argv[0], argv, envp);
+	if (info == NULL) {
+		argv_free(argv);
+		goto out;
+	}
+
+	call_usermodehelper_setcleanup(info, argv_cleanup);
+
+	ret = call_usermodehelper_exec(info, -1);
+
+  out:
+	if (ret && force) {
+		printk(KERN_WARNING "Failed to start orderly shutdown: "
+		       "forcing the issue\n");
+
+		/* I guess this should try to kick off some daemon to
+		   sync and poweroff asap.  Or not even bother syncing
+		   if we're doing an emergency shutdown? */
+		emergency_sync();
+		kernel_power_off();
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(orderly_poweroff);
diff -puN kernel/sysctl.c~add-common-orderly_poweroff kernel/sysctl.c
--- a/kernel/sysctl.c~add-common-orderly_poweroff
+++ a/kernel/sysctl.c
@@ -45,6 +45,7 @@
 #include <linux/syscalls.h>
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
+#include <linux/reboot.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -615,6 +616,15 @@ static ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= KERN_POWEROFF_CMD,
+		.procname	= "poweroff_cmd",
+		.data		= &poweroff_cmd,
+		.maxlen		= POWEROFF_CMD_PATH_LEN,
+		.mode		= 0644,
+		.proc_handler	= &proc_dostring,
+		.strategy	= &sysctl_string,
+	},
 
 	{ .ctl_name = 0 }
 };
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
loop_probe-fix-return-value.patch
x86-use-elfnoteh-to-generate-vsyscall-notes.patch
i386-move-common-parts-of-smp-into-their-own-file.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
add-kstrndup.patch
add-argv_split.patch
split-usermodehelper-setup-from-execution.patch
add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit.patch
lguest-the-guest-code.patch
