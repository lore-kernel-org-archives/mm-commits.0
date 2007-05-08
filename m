From: akpm@linux-foundation.org
Subject: - uml-comment-early-boot-locking.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:51 -0700
Message-ID: <200705080006.l4806p6P009230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967408AbXEHAHV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: comment early boot locking
has been removed from the -mm tree.  Its filename was
     uml-comment-early-boot-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: comment early boot locking
From: Jeff Dike <jdike@addtoit.com>

Commentary about missing locking.

Also got rid of uml_start because it was pointless.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/um_arch.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN arch/um/kernel/um_arch.c~uml-comment-early-boot-locking arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-comment-early-boot-locking
+++ a/arch/um/kernel/um_arch.c
@@ -44,7 +44,7 @@
 
 #define DEFAULT_COMMAND_LINE "root=98:0"
 
-/* Changed in linux_main and setup_arch, which run before SMP is started */
+/* Changed in add_arg and setup_arch, which run before SMP is started */
 static char __initdata command_line[COMMAND_LINE_SIZE] = { 0 };
 
 static void __init add_arg(char *arg)
@@ -58,7 +58,12 @@ static void __init add_arg(char *arg)
 	strcat(command_line, arg);
 }
 
-struct cpuinfo_um boot_cpu_data = { 
+/*
+ * These fields are initialized at boot time and not changed.
+ * XXX This structure is used only in the non-SMP case.  Maybe this
+ * should be moved to smp.c.
+ */
+struct cpuinfo_um boot_cpu_data = {
 	.loops_per_jiffy	= 0,
 	.ipi_pipe		= { -1, -1 }
 };
@@ -119,14 +124,12 @@ const struct seq_operations cpuinfo_op =
 /* Set in linux_main */
 unsigned long host_task_size;
 unsigned long task_size;
-
-unsigned long uml_start;
-
-/* Set in early boot */
 unsigned long uml_physmem;
-unsigned long uml_reserved;
+unsigned long uml_reserved; /* Also modified in mem_init */
 unsigned long start_vm;
 unsigned long end_vm;
+
+/* Set in uml_ncpus_setup */
 int ncpus = 1;
 
 #ifdef CONFIG_CMDLINE_ON_HOST
@@ -140,6 +143,8 @@ static char *argv1_end = NULL;
 
 /* Set in early boot */
 static int have_root __initdata = 0;
+
+/* Set in uml_mem_setup and modified in linux_main */
 long long physmem_size = 32 * 1024 * 1024;
 
 void set_cmdline(char *cmd)
@@ -378,7 +383,6 @@ int __init linux_main(int argc, char **a
 
 	printf("UML running in %s mode\n", mode);
 
-	uml_start = (unsigned long) &__binary_start;
 	host_task_size = CHOOSE_MODE_PROC(set_task_sizes_tt,
 					  set_task_sizes_skas, &task_size);
 
@@ -400,7 +404,7 @@ int __init linux_main(int argc, char **a
 		physmem_size += UML_ROUND_UP(brk_start) - UML_ROUND_UP(&_end);
 	}
 
-	uml_physmem = uml_start & PAGE_MASK;
+	uml_physmem = (unsigned long) &__binary_start & PAGE_MASK;
 
 	/* Reserve up to 4M after the current brk */
 	uml_reserved = ROUND_4M(brk_start) + (1 << 22);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
