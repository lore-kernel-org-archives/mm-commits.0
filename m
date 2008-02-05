From: akpm@linux-foundation.org
Subject: - uml-install-panic-notifier-earlier.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:33 -0800
Message-ID: <200802052237.m15MbE9u012838@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761003AbYBEWlv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: install panic notifier earlier
has been removed from the -mm tree.  Its filename was
     uml-install-panic-notifier-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: install panic notifier earlier
From: Jeff Dike <jdike@addtoit.com>

It turns out that if there's a panic early enough, UML will just sit there in
the LED-blinking loop because the panic notifier hadn't been installed yet.

This patch installs it earlier.

It also fixes the problem which exposed the hang, namely that if you give UML
a zero-sized initrd, it will ask alloc_bootmem for zero bytes, and that will
cause the panic.

While I was in initrd.c, I gave it a style makeover.

Prompted by checkpatch, I moved a couple extern declarations of uml_exitcode
to kern_util.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/kern_util.h |    2 +
 arch/um/kernel/initrd.c     |   29 ++++++++++++++++--------
 arch/um/kernel/um_arch.c    |   41 ++++++++++++++++------------------
 arch/um/os-Linux/main.c     |    2 -
 4 files changed, 42 insertions(+), 32 deletions(-)

diff -puN arch/um/include/kern_util.h~uml-install-panic-notifier-earlier arch/um/include/kern_util.h
--- a/arch/um/include/kern_util.h~uml-install-panic-notifier-earlier
+++ a/arch/um/include/kern_util.h
@@ -9,6 +9,8 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/faultinfo.h"
 
+extern int uml_exitcode;
+
 extern int ncpus;
 extern int kmalloc_ok;
 extern int nsyscalls;
diff -puN arch/um/kernel/initrd.c~uml-install-panic-notifier-earlier arch/um/kernel/initrd.c
--- a/arch/um/kernel/initrd.c~uml-install-panic-notifier-earlier
+++ a/arch/um/kernel/initrd.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000, 2001, 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -20,18 +20,27 @@ static int __init read_initrd(void)
 	long long size;
 	int err;
 
-	if(initrd == NULL)
+	if (initrd == NULL)
 		return 0;
 
 	err = os_file_size(initrd, &size);
-	if(err)
+	if (err)
 		return 0;
 
+	/*
+	 * This is necessary because alloc_bootmem craps out if you
+	 * ask for no memory.
+	 */
+	if (size == 0) {
+		printk(KERN_ERR "\"%\" is a zero-size initrd\n");
+		return 0;
+	}
+
 	area = alloc_bootmem(size);
-	if(area == NULL)
+	if (area == NULL)
 		return 0;
 
-	if(load_initrd(initrd, area, size) == -1)
+	if (load_initrd(initrd, area, size) == -1)
 		return 0;
 
 	initrd_start = (unsigned long) area;
@@ -58,13 +67,15 @@ int load_initrd(char *filename, void *bu
 	int fd, n;
 
 	fd = os_open_file(filename, of_read(OPENFLAGS()), 0);
-	if(fd < 0){
-		printk("Opening '%s' failed - err = %d\n", filename, -fd);
+	if (fd < 0) {
+		printk(KERN_ERR "Opening '%s' failed - err = %d\n", filename,
+		       -fd);
 		return -1;
 	}
 	n = os_read_file(fd, buf, size);
-	if(n != size){
-		printk("Read of %d bytes from '%s' failed, err = %d\n", size,
+	if (n != size) {
+		printk(KERN_ERR "Read of %d bytes from '%s' failed, "
+		       "err = %d\n", size,
 		       filename, -n);
 		return -1;
 	}
diff -puN arch/um/kernel/um_arch.c~uml-install-panic-notifier-earlier arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-install-panic-notifier-earlier
+++ a/arch/um/kernel/um_arch.c
@@ -223,6 +223,23 @@ static void __init uml_postsetup(void)
 	return;
 }
 
+static int panic_exit(struct notifier_block *self, unsigned long unused1,
+		      void *unused2)
+{
+	bust_spinlocks(1);
+	show_regs(&(current->thread.regs));
+	bust_spinlocks(0);
+	uml_exitcode = 1;
+	os_dump_core();
+	return 0;
+}
+
+static struct notifier_block panic_exit_notifier = {
+	.notifier_call 		= panic_exit,
+	.next 			= NULL,
+	.priority 		= 0
+};
+
 /* Set during early boot */
 unsigned long brk_start;
 unsigned long end_iomem;
@@ -327,6 +344,9 @@ int __init linux_main(int argc, char **a
 		printf("Kernel virtual memory size shrunk to %lu bytes\n",
 		       virtmem_size);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &panic_exit_notifier);
+
 	uml_postsetup();
 
 	stack_protections((unsigned long) &init_thread_info);
@@ -335,29 +355,8 @@ int __init linux_main(int argc, char **a
 	return start_uml();
 }
 
-extern int uml_exitcode;
-
-static int panic_exit(struct notifier_block *self, unsigned long unused1,
-		      void *unused2)
-{
-	bust_spinlocks(1);
-	show_regs(&(current->thread.regs));
-	bust_spinlocks(0);
-	uml_exitcode = 1;
-	os_dump_core();
-	return 0;
-}
-
-static struct notifier_block panic_exit_notifier = {
-	.notifier_call 		= panic_exit,
-	.next 			= NULL,
-	.priority 		= 0
-};
-
 void __init setup_arch(char **cmdline_p)
 {
-	atomic_notifier_chain_register(&panic_notifier_list,
-			&panic_exit_notifier);
 	paging_init();
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
diff -puN arch/um/os-Linux/main.c~uml-install-panic-notifier-earlier arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-install-panic-notifier-earlier
+++ a/arch/um/os-Linux/main.c
@@ -111,8 +111,6 @@ static void setup_env_path(void)
 	}
 }
 
-extern int uml_exitcode;
-
 extern void scan_elf_aux( char **envp);
 
 int __init main(int argc, char **argv, char **envp)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
