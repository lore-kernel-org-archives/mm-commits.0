From: akpm@linux-foundation.org
Subject: [merged]
 kernel-add-support-for-kernel-restart-handler-call-chain.patch removed from -mm tree
Date: Tue, 30 Sep 2014 14:20:47 -0700
Message-ID: <542b1eaf.hVf2hdmsNJP/pdO7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54734 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaI3VUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 17:20:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel: add support for kernel restart handler call chain
has been removed from the -mm tree.  Its filename was
     kernel-add-support-for-kernel-restart-handler-call-chain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: kernel: add support for kernel restart handler call chain

Various drivers implement architecture and/or device specific means to
restart (reset) the system.  Various mechanisms have been implemented to
support those schemes.  The best known mechanism is arm_pm_restart, which
is a function pointer to be set either from platform specific code or from
drivers.  Another mechanism is to use hardware watchdogs to issue a reset;
this mechanism is used if there is no other method available to reset a
board or system.  Two examples are alim7101_wdt, which currently uses the
reboot notifier to trigger a reset, and moxart_wdt, which registers the
arm_pm_restart function.

The existing mechanisms have a number of drawbacks.  Typically only one
scheme to restart the system is supported (at least if arm_pm_restart is
used).  At least in theory there can be multiple means to restart the
system, some of which may be less desirable (for example one mechanism may
only reset the CPU, while another may reset the entire system).  Using
arm_pm_restart can also be racy if the function pointer is set from a
driver, as the driver may be in the process of being unloaded when
arm_pm_restart is called.  Using the reboot notifier is always racy, as it
is unknown if and when other functions using the reboot notifier have
completed execution by the time the watchdog fires.

Introduce a system restart handler call chain to solve the described
problems.  This call chain is expected to be executed from the
architecture specific machine_restart() function.  Drivers providing
system restart functionality (such as the watchdog drivers mentioned
above) are expected to register with this call chain.  By using the
priority field in the notifier block, callers can control restart handler
execution sequence and thus ensure that the restart handler with the
optimal restart capabilities for a given system is called first.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reboot.h |    3 +
 kernel/reboot.c        |   81 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff -puN include/linux/reboot.h~kernel-add-support-for-kernel-restart-handler-call-chain include/linux/reboot.h
--- a/include/linux/reboot.h~kernel-add-support-for-kernel-restart-handler-call-chain
+++ a/include/linux/reboot.h
@@ -38,6 +38,9 @@ extern int reboot_force;
 extern int register_reboot_notifier(struct notifier_block *);
 extern int unregister_reboot_notifier(struct notifier_block *);
 
+extern int register_restart_handler(struct notifier_block *);
+extern int unregister_restart_handler(struct notifier_block *);
+extern void do_kernel_restart(char *cmd);
 
 /*
  * Architecture-specific implementations of sys_reboot commands.
diff -puN kernel/reboot.c~kernel-add-support-for-kernel-restart-handler-call-chain kernel/reboot.c
--- a/kernel/reboot.c~kernel-add-support-for-kernel-restart-handler-call-chain
+++ a/kernel/reboot.c
@@ -104,6 +104,87 @@ int unregister_reboot_notifier(struct no
 }
 EXPORT_SYMBOL(unregister_reboot_notifier);
 
+/*
+ *	Notifier list for kernel code which wants to be called
+ *	to restart the system.
+ */
+static ATOMIC_NOTIFIER_HEAD(restart_handler_list);
+
+/**
+ *	register_restart_handler - Register function to be called to reset
+ *				   the system
+ *	@nb: Info about handler function to be called
+ *	@nb->priority:	Handler priority. Handlers should follow the
+ *			following guidelines for setting priorities.
+ *			0:	Restart handler of last resort,
+ *				with limited restart capabilities
+ *			128:	Default restart handler; use if no other
+ *				restart handler is expected to be available,
+ *				and/or if restart functionality is
+ *				sufficient to restart the entire system
+ *			255:	Highest priority restart handler, will
+ *				preempt all other restart handlers
+ *
+ *	Registers a function with code to be called to restart the
+ *	system.
+ *
+ *	Registered functions will be called from machine_restart as last
+ *	step of the restart sequence (if the architecture specific
+ *	machine_restart function calls do_kernel_restart - see below
+ *	for details).
+ *	Registered functions are expected to restart the system immediately.
+ *	If more than one function is registered, the restart handler priority
+ *	selects which function will be called first.
+ *
+ *	Restart handlers are expected to be registered from non-architecture
+ *	code, typically from drivers. A typical use case would be a system
+ *	where restart functionality is provided through a watchdog. Multiple
+ *	restart handlers may exist; for example, one restart handler might
+ *	restart the entire system, while another only restarts the CPU.
+ *	In such cases, the restart handler which only restarts part of the
+ *	hardware is expected to register with low priority to ensure that
+ *	it only runs if no other means to restart the system is available.
+ *
+ *	Currently always returns zero, as atomic_notifier_chain_register()
+ *	always returns zero.
+ */
+int register_restart_handler(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&restart_handler_list, nb);
+}
+EXPORT_SYMBOL(register_restart_handler);
+
+/**
+ *	unregister_restart_handler - Unregister previously registered
+ *				     restart handler
+ *	@nb: Hook to be unregistered
+ *
+ *	Unregisters a previously registered restart handler function.
+ *
+ *	Returns zero on success, or %-ENOENT on failure.
+ */
+int unregister_restart_handler(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(&restart_handler_list, nb);
+}
+EXPORT_SYMBOL(unregister_restart_handler);
+
+/**
+ *	do_kernel_restart - Execute kernel restart handler call chain
+ *
+ *	Calls functions registered with register_restart_handler.
+ *
+ *	Expected to be called from machine_restart as last step of the restart
+ *	sequence.
+ *
+ *	Restarts the system immediately if a restart handler function has been
+ *	registered. Otherwise does nothing.
+ */
+void do_kernel_restart(char *cmd)
+{
+	atomic_notifier_call_chain(&restart_handler_list, reboot_mode, cmd);
+}
+
 void migrate_to_reboot_cpu(void)
 {
 	/* The boot cpu is always logical cpu 0 */
_

Patches currently in -mm which might be from linux@roeck-us.net are

documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch
rtc-ds1307-add-trickle-charger-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-device-tree-binding.patch
linux-next.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch

