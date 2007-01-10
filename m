From: akpm@osdl.org
Subject: - break-init-in-two-parts-to-avoid-modpost-warnings.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:03:24 -0800
Message-ID: <200701102303.l0AN3O9U010817@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33372 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965251AbXAJXDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Break init() in two parts to avoid MODPOST warnings
has been removed from the -mm tree.  Its filename was
     break-init-in-two-parts-to-avoid-modpost-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Break init() in two parts to avoid MODPOST warnings
From: Vivek Goyal <vgoyal@in.ibm.com>

o init() is a non __init function in .text section but it calls many
  functions which are in .init.text section. Hence MODPOST generates lots
  of cross reference warnings on i386 if compiled with CONFIG_RELOCATABLE=y

WARNING: vmlinux - Section mismatch: reference to .init.text:smp_prepare_cpus from .text between 'init' (at offset 0xc0101049) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to .init.text:migration_init from .text between 'init' (at offset 0xc010104e) and 'rest_init'
WARNING: vmlinux - Section mismatch: reference to .init.text:spawn_ksoftirqd from .text between 'init' (at offset 0xc0101053) and 'rest_init'

o This patch breaks down init() in two parts. One part which can go
  in .init.text section and can be freed and other part which has to
  be non __init(init_post()). Now init() calls init_post() and init_post()
  does not call any functions present in .init sections. Hence getting
  rid of warnings.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/main.c |   81 +++++++++++++++++++++++++++-----------------------
 1 files changed, 45 insertions(+), 36 deletions(-)

diff -puN init/main.c~break-init-in-two-parts-to-avoid-modpost-warnings init/main.c
--- a/init/main.c~break-init-in-two-parts-to-avoid-modpost-warnings
+++ a/init/main.c
@@ -721,7 +721,49 @@ static void run_init_process(char *init_
 	kernel_execve(init_filename, argv_init, envp_init);
 }
 
-static int init(void * unused)
+/* This is a non __init function. Force it to be noinline otherwise gcc
+ * makes it inline to init() and it becomes part of init.text section
+ */
+static int noinline init_post(void)
+{
+	free_initmem();
+	unlock_kernel();
+	mark_rodata_ro();
+	system_state = SYSTEM_RUNNING;
+	numa_default_policy();
+
+	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
+		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
+
+	(void) sys_dup(0);
+	(void) sys_dup(0);
+
+	if (ramdisk_execute_command) {
+		run_init_process(ramdisk_execute_command);
+		printk(KERN_WARNING "Failed to execute %s\n",
+				ramdisk_execute_command);
+	}
+
+	/*
+	 * We try each of these until one succeeds.
+	 *
+	 * The Bourne shell can be used instead of init if we are
+	 * trying to recover a really broken machine.
+	 */
+	if (execute_command) {
+		run_init_process(execute_command);
+		printk(KERN_WARNING "Failed to execute %s.  Attempting "
+					"defaults...\n", execute_command);
+	}
+	run_init_process("/sbin/init");
+	run_init_process("/etc/init");
+	run_init_process("/bin/init");
+	run_init_process("/bin/sh");
+
+	panic("No init found.  Try passing init= option to kernel.");
+}
+
+static int __init init(void * unused)
 {
 	lock_kernel();
 	/*
@@ -769,39 +811,6 @@ static int init(void * unused)
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
-	free_initmem();
-	unlock_kernel();
-	mark_rodata_ro();
-	system_state = SYSTEM_RUNNING;
-	numa_default_policy();
-
-	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
-		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
-
-	(void) sys_dup(0);
-	(void) sys_dup(0);
-
-	if (ramdisk_execute_command) {
-		run_init_process(ramdisk_execute_command);
-		printk(KERN_WARNING "Failed to execute %s\n",
-				ramdisk_execute_command);
-	}
-
-	/*
-	 * We try each of these until one succeeds.
-	 *
-	 * The Bourne shell can be used instead of init if we are 
-	 * trying to recover a really broken machine.
-	 */
-	if (execute_command) {
-		run_init_process(execute_command);
-		printk(KERN_WARNING "Failed to execute %s.  Attempting "
-					"defaults...\n", execute_command);
-	}
-	run_init_process("/sbin/init");
-	run_init_process("/etc/init");
-	run_init_process("/bin/init");
-	run_init_process("/bin/sh");
-
-	panic("No init found.  Try passing init= option to kernel.");
+	init_post();
+	return 0;
 }
_

Patches currently in -mm which might be from vgoyal@in.ibm.com are

change-cpu_up-and-co-from-__devinit-to-__cpuinit.patch
kdump-documentation-update-for-2620.patch
pci-quirks-modpost-warning-fix.patch
i386-sched_clock-using-init-data-tsc_disable-fix.patch
make-noirqdebug_setup-function-non-init-to-fix-modpost-warning.patch
scsi-megaraid_mmmbox-init-fix-for-kdump.patch
clockevents-i386-drivers.patch
