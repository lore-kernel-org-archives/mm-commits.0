From: akpm@linux-foundation.org
Subject: - uml-redo-the-calculation-of-nr_syscalls.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:39:00 -0800
Message-ID: <200802052238.m15McfBn012975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761128AbYBEWmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:42:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: redo the calculation of NR_syscalls 
has been removed from the -mm tree.  Its filename was
     uml-redo-the-calculation-of-nr_syscalls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: redo the calculation of NR_syscalls 
From: Jeff Dike <jdike@addtoit.com>

Redo the calculation of NR_syscalls since that disappeared from i386 and
use a similar mechanism on x86_64.

We now figure out the size of the system call table in arch code and stick
that in syscall_table_size.  arch/um/kernel/skas/syscall.c defines
NR_syscalls in terms of that since its the only thing that needs to know
how many system calls there are.

The old mechananism that was used on x86_64 is gone.

arch/um/include/sysdep-i386/syscalls.h got some formatting since I was
looking at it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/sysdep-i386/syscalls.h         |    5 ++-
 arch/um/include/sysdep-x86_64/kernel-offsets.h |    9 ------
 arch/um/include/sysdep-x86_64/syscalls.h       |    2 -
 arch/um/kernel/skas/syscall.c                  |    3 ++
 arch/um/sys-i386/sys_call_table.S              |    5 +++
 arch/um/sys-x86_64/syscall_table.c             |   20 ++++++++++-----
 6 files changed, 25 insertions(+), 19 deletions(-)

diff -puN arch/um/include/sysdep-i386/syscalls.h~uml-redo-the-calculation-of-nr_syscalls arch/um/include/sysdep-i386/syscalls.h
--- a/arch/um/include/sysdep-i386/syscalls.h~uml-redo-the-calculation-of-nr_syscalls
+++ a/arch/um/include/sysdep-i386/syscalls.h
@@ -1,5 +1,5 @@
 /* 
- * Copyright (C) 2000 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2000 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -18,7 +18,8 @@ extern syscall_handler_t old_mmap_i386;
 extern syscall_handler_t *sys_call_table[];
 
 #define EXECUTE_SYSCALL(syscall, regs) \
-	((long (*)(struct syscall_args)) (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
+	((long (*)(struct syscall_args)) \
+	 (*sys_call_table[syscall]))(SYSCALL_ARGS(&regs->regs))
 
 extern long sys_mmap2(unsigned long addr, unsigned long len,
 		      unsigned long prot, unsigned long flags,
diff -puN arch/um/include/sysdep-x86_64/kernel-offsets.h~uml-redo-the-calculation-of-nr_syscalls arch/um/include/sysdep-x86_64/kernel-offsets.h
--- a/arch/um/include/sysdep-x86_64/kernel-offsets.h~uml-redo-the-calculation-of-nr_syscalls
+++ a/arch/um/include/sysdep-x86_64/kernel-offsets.h
@@ -17,16 +17,7 @@
 #define OFFSET(sym, str, mem) \
 	DEFINE(sym, offsetof(struct str, mem));
 
-#define __NO_STUBS 1
-#undef __SYSCALL
-#undef _ASM_X86_64_UNISTD_H_
-#define __SYSCALL(nr, sym) [nr] = 1,
-static char syscalls[] = {
-#include <asm/arch/unistd.h>
-};
-
 void foo(void)
 {
 #include <common-offsets.h>
-DEFINE(UM_NR_syscall_max, sizeof(syscalls) - 1);
 }
diff -puN arch/um/include/sysdep-x86_64/syscalls.h~uml-redo-the-calculation-of-nr_syscalls arch/um/include/sysdep-x86_64/syscalls.h
--- a/arch/um/include/sysdep-x86_64/syscalls.h~uml-redo-the-calculation-of-nr_syscalls
+++ a/arch/um/include/sysdep-x86_64/syscalls.h
@@ -30,6 +30,4 @@ extern long old_mmap(unsigned long addr,
 extern syscall_handler_t sys_modify_ldt;
 extern syscall_handler_t sys_arch_prctl;
 
-#define NR_syscalls (UM_NR_syscall_max + 1)
-
 #endif
diff -puN arch/um/kernel/skas/syscall.c~uml-redo-the-calculation-of-nr_syscalls arch/um/kernel/skas/syscall.c
--- a/arch/um/kernel/skas/syscall.c~uml-redo-the-calculation-of-nr_syscalls
+++ a/arch/um/kernel/skas/syscall.c
@@ -9,6 +9,9 @@
 #include "sysdep/ptrace.h"
 #include "sysdep/syscalls.h"
 
+extern int syscall_table_size;
+#define NR_syscalls (syscall_table_size / sizeof(void *))
+
 void handle_syscall(struct uml_pt_regs *r)
 {
 	struct pt_regs *regs = container_of(r, struct pt_regs, regs);
diff -puN arch/um/sys-i386/sys_call_table.S~uml-redo-the-calculation-of-nr_syscalls arch/um/sys-i386/sys_call_table.S
--- a/arch/um/sys-i386/sys_call_table.S~uml-redo-the-calculation-of-nr_syscalls
+++ a/arch/um/sys-i386/sys_call_table.S
@@ -9,4 +9,9 @@
 
 #define old_mmap old_mmap_i386
 
+.section .rodata,"a"
+
 #include "../../x86/kernel/syscall_table_32.S"
+
+ENTRY(syscall_table_size)
+.long .-sys_call_table
diff -puN arch/um/sys-x86_64/syscall_table.c~uml-redo-the-calculation-of-nr_syscalls arch/um/sys-x86_64/syscall_table.c
--- a/arch/um/sys-x86_64/syscall_table.c~uml-redo-the-calculation-of-nr_syscalls
+++ a/arch/um/sys-x86_64/syscall_table.c
@@ -52,11 +52,19 @@ typedef void (*sys_call_ptr_t)(void);
 
 extern void sys_ni_syscall(void);
 
-sys_call_ptr_t sys_call_table[UM_NR_syscall_max+1] __cacheline_aligned = {
-	/*
-	 * Smells like a like a compiler bug -- it doesn't work when the &
-	 * below is removed.
-	 */
-	[0 ... UM_NR_syscall_max] = &sys_ni_syscall,
+/*
+ * We used to have a trick here which made sure that holes in the
+ * x86_64 table were filled in with sys_ni_syscall, but a comment in
+ * unistd_64.h says that holes aren't allowed, so the trick was
+ * removed.
+ * The trick looked like this
+ *	[0 ... UM_NR_syscall_max] = &sys_ni_syscall
+ * before including unistd_64.h - the later initializations overwrote
+ * the sys_ni_syscall filler.
+ */
+
+sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 #include <asm-x86/unistd_64.h>
 };
+
+int syscall_table_size = sizeof(sys_call_table);
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
