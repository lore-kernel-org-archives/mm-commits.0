From: akpm@linux-foundation.org
Subject: + uml-create-as-layouth.patch added to -mm tree
Date: Thu, 22 Mar 2007 14:44:35 -0700
Message-ID: <200703222144.l2MLiaeS031096@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161104AbXCVVok (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 17:44:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: mreate as-layout.h
has been added to the -mm tree.  Its filename is
     uml-create-as-layouth.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: mreate as-layout.h
From: Jeff Dike <jdike@addtoit.com>

This patch moves all the the symbols defined in um_arch.c, which are mostly
boundaries between different parts of the UML kernel address space, to a new
header, as-layout.h.  There are also a few things here which aren't really
related to address space layout, but which don't really have a better place to
go.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/as-layout.h   |   35 ++++++++++++++++++++++++++++++++
 arch/um/include/user_util.h   |   23 ---------------------
 arch/um/kernel/exec.c         |    1 
 arch/um/kernel/ksyms.c        |    1 
 arch/um/kernel/mem.c          |    1 
 arch/um/kernel/physmem.c      |    1 
 arch/um/kernel/process.c      |    1 
 arch/um/kernel/skas/process.c |    1 
 arch/um/kernel/tlb.c          |    1 
 arch/um/kernel/trap.c         |    1 
 arch/um/kernel/um_arch.c      |    1 
 arch/um/os-Linux/main.c       |    1 
 arch/um/os-Linux/skas/trap.c  |    1 
 13 files changed, 46 insertions(+), 23 deletions(-)

diff -puN /dev/null arch/um/include/as-layout.h
--- /dev/null
+++ a/arch/um/include/as-layout.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
+#ifndef __START_H__
+#define __START_H__
+
+#include "sysdep/ptrace.h"
+
+struct cpu_task {
+	int pid;
+	void *task;
+};
+
+extern struct cpu_task cpu_tasks[];
+
+extern unsigned long low_physmem;
+extern unsigned long high_physmem;
+extern unsigned long uml_physmem;
+extern unsigned long uml_reserved;
+extern unsigned long end_vm;
+extern unsigned long start_vm;
+extern unsigned long long highmem;
+
+extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
+extern unsigned long _unprotected_end;
+extern unsigned long brk_start;
+
+extern int linux_main(int argc, char **argv);
+extern void set_cmdline(char *cmd);
+
+extern void (*sig_info[])(int, union uml_pt_regs *);
+
+#endif
diff -puN arch/um/include/user_util.h~uml-create-as-layouth arch/um/include/user_util.h
--- a/arch/um/include/user_util.h~uml-create-as-layouth
+++ a/arch/um/include/user_util.h
@@ -30,30 +30,7 @@ extern int grantpt(int __fd);
 extern int unlockpt(int __fd);
 extern char *ptsname(int __fd);
 
-struct cpu_task {
-	int pid;
-	void *task;
-};
-
-extern struct cpu_task cpu_tasks[];
-
-extern void (*sig_info[])(int, union uml_pt_regs *);
-
-extern unsigned long low_physmem;
-extern unsigned long high_physmem;
-extern unsigned long uml_physmem;
-extern unsigned long uml_reserved;
-extern unsigned long end_vm;
-extern unsigned long start_vm;
-extern unsigned long long highmem;
-
-extern unsigned long _stext, _etext, _sdata, _edata, __bss_start, _end;
-extern unsigned long _unprotected_end;
-extern unsigned long brk_start;
-
 extern void *add_signal_handler(int sig, void (*handler)(int));
-extern int linux_main(int argc, char **argv);
-extern void set_cmdline(char *cmd);
 extern void input_cb(void (*proc)(void *), void *arg, int arg_len);
 extern int get_pty(void);
 extern int switcheroo(int fd, int prot, void *from, void *to, int size);
diff -puN arch/um/kernel/exec.c~uml-create-as-layouth arch/um/kernel/exec.c
--- a/arch/um/kernel/exec.c~uml-create-as-layouth
+++ a/arch/um/kernel/exec.c
@@ -12,6 +12,7 @@
 #include "asm/uaccess.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "mem_user.h"
 #include "kern.h"
 #include "irq_user.h"
diff -puN arch/um/kernel/ksyms.c~uml-create-as-layouth arch/um/kernel/ksyms.c
--- a/arch/um/kernel/ksyms.c~uml-create-as-layouth
+++ a/arch/um/kernel/ksyms.c
@@ -16,6 +16,7 @@
 #include "asm/page.h"
 #include "asm/tlbflush.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "user_util.h"
 #include "mem_user.h"
 #include "os.h"
diff -puN arch/um/kernel/mem.c~uml-create-as-layouth arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~uml-create-as-layouth
+++ a/arch/um/kernel/mem.c
@@ -15,6 +15,7 @@
 #include "asm/pgalloc.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "kern.h"
 #include "mem_user.h"
 #include "uml_uaccess.h"
diff -puN arch/um/kernel/physmem.c~uml-create-as-layouth arch/um/kernel/physmem.c
--- a/arch/um/kernel/physmem.c~uml-create-as-layouth
+++ a/arch/um/kernel/physmem.c
@@ -13,6 +13,7 @@
 #include "asm/types.h"
 #include "asm/pgtable.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "user_util.h"
 #include "mode_kern.h"
 #include "mem.h"
diff -puN arch/um/kernel/process.c~uml-create-as-layouth arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-create-as-layouth
+++ a/arch/um/kernel/process.c
@@ -34,6 +34,7 @@
 #include "asm/user.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "kern.h"
 #include "signal_kern.h"
 #include "init.h"
diff -puN arch/um/kernel/skas/process.c~uml-create-as-layouth arch/um/kernel/skas/process.c
--- a/arch/um/kernel/skas/process.c~uml-create-as-layouth
+++ a/arch/um/kernel/skas/process.c
@@ -13,6 +13,7 @@
 #include "asm/uaccess.h"
 #include "asm/atomic.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "skas.h"
 #include "os.h"
 #include "user_util.h"
diff -puN arch/um/kernel/tlb.c~uml-create-as-layouth arch/um/kernel/tlb.c
--- a/arch/um/kernel/tlb.c~uml-create-as-layouth
+++ a/arch/um/kernel/tlb.c
@@ -9,6 +9,7 @@
 #include "asm/tlbflush.h"
 #include "choose-mode.h"
 #include "mode_kern.h"
+#include "as-layout.h"
 #include "user_util.h"
 #include "tlb.h"
 #include "mem.h"
diff -puN arch/um/kernel/trap.c~uml-create-as-layouth arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~uml-create-as-layouth
+++ a/arch/um/kernel/trap.c
@@ -20,6 +20,7 @@
 #include "sysdep/sigcontext.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "arch.h"
 #include "kern.h"
 #include "chan_kern.h"
diff -puN arch/um/kernel/um_arch.c~uml-create-as-layouth arch/um/kernel/um_arch.c
--- a/arch/um/kernel/um_arch.c~uml-create-as-layouth
+++ a/arch/um/kernel/um_arch.c
@@ -28,6 +28,7 @@
 #include "asm/current.h"
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "arch.h"
 #include "kern.h"
 #include "mem_user.h"
diff -puN arch/um/os-Linux/main.c~uml-create-as-layouth arch/um/os-Linux/main.c
--- a/arch/um/os-Linux/main.c~uml-create-as-layouth
+++ a/arch/um/os-Linux/main.c
@@ -15,6 +15,7 @@
 #include <asm/page.h>
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "mem_user.h"
 #include "irq_user.h"
 #include "user.h"
diff -puN arch/um/os-Linux/skas/trap.c~uml-create-as-layouth arch/um/os-Linux/skas/trap.c
--- a/arch/um/os-Linux/skas/trap.c~uml-create-as-layouth
+++ a/arch/um/os-Linux/skas/trap.c
@@ -7,6 +7,7 @@
 #include <errno.h>
 #include "user_util.h"
 #include "kern_util.h"
+#include "as-layout.h"
 #include "task.h"
 #include "sigcontext.h"
 #include "skas.h"
_

Patches currently in -mm which might be from jdike@addtoit.com are

div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
