From: akpm@linux-foundation.org
Subject: - adjust-nosmp-handling.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:57:00 -0700
Message-ID: <200707162057.l6GKv09B002139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758560AbXGPVJx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:09:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     adjust nosmp handling
has been removed from the -mm tree.  Its filename was
     adjust-nosmp-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: adjust nosmp handling
From: "Jan Beulich" <jbeulich@novell.com>

Especially when !CONFIG_HOTPLUG_CPU, avoid needlessy allocating resources for
CPUs that can never become available.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff -puN init/main.c~adjust-nosmp-handling init/main.c
--- a/init/main.c~adjust-nosmp-handling
+++ a/init/main.c
@@ -132,20 +132,9 @@ static char *static_command_line;
 static char *execute_command;
 static char *ramdisk_execute_command;
 
+#ifdef CONFIG_SMP
 /* Setup configured maximum number of CPUs to activate */
-static unsigned int max_cpus = NR_CPUS;
-
-/*
- * If set, this is an indication to the drivers that reset the underlying
- * device before going ahead with the initialization otherwise driver might
- * rely on the BIOS and skip the reset operation.
- *
- * This is useful if kernel is booting in an unreliable environment.
- * For ex. kdump situaiton where previous kernel has crashed, BIOS has been
- * skipped and devices will be in unknown state.
- */
-unsigned int reset_devices;
-EXPORT_SYMBOL(reset_devices);
+static unsigned int __initdata max_cpus = NR_CPUS;
 
 /*
  * Setup routine for controlling SMP activation
@@ -160,10 +149,10 @@ EXPORT_SYMBOL(reset_devices);
 static int __init nosmp(char *str)
 {
 	max_cpus = 0;
-	return 1;
+	return 0;
 }
 
-__setup("nosmp", nosmp);
+early_param("nosmp", nosmp);
 
 static int __init maxcpus(char *str)
 {
@@ -172,6 +161,21 @@ static int __init maxcpus(char *str)
 }
 
 __setup("maxcpus=", maxcpus);
+#else
+#define max_cpus NR_CPUS
+#endif
+
+/*
+ * If set, this is an indication to the drivers that reset the underlying
+ * device before going ahead with the initialization otherwise driver might
+ * rely on the BIOS and skip the reset operation.
+ *
+ * This is useful if kernel is booting in an unreliable environment.
+ * For ex. kdump situaiton where previous kernel has crashed, BIOS has been
+ * skipped and devices will be in unknown state.
+ */
+unsigned int reset_devices;
+EXPORT_SYMBOL(reset_devices);
 
 static int __init set_reset_devices(char *str)
 {
@@ -385,6 +389,10 @@ static void __init smp_init(void)
 {
 	unsigned int cpu;
 
+#ifndef CONFIG_HOTPLUG_CPU
+	cpu_possible_map = cpu_present_map;
+#endif
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= max_cpus)
@@ -529,6 +537,10 @@ asmlinkage void __init start_kernel(void
 	setup_arch(&command_line);
 	setup_command_line(command_line);
 	unwind_setup();
+#ifndef CONFIG_HOTPLUG_CPU
+	if (max_cpus < 2)
+		cpu_possible_map = cpu_online_map;
+#endif
 	setup_per_cpu_areas();
 	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
modpost-white-list-pattern-adjustment.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
