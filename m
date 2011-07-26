From: akpm@linux-foundation.org
Subject: [merged] um-set-__have_arch_gate_area-for-i386.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:47 -0700
Message-ID: <201107260753.p6Q7roSv003270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab1GZHyo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: Set __HAVE_ARCH_GATE_AREA for i386
has been removed from the -mm tree.  Its filename was
     um-set-__have_arch_gate_area-for-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: Set __HAVE_ARCH_GATE_AREA for i386
From: Richard Weinberger <richard@nod.at>

When UML is unable to reuse the host's vDSO FIXADDR_USER_START is zero. 
To handle this special case correclty we have to implement custom gate
area helper methods.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/Makefile  |    2 -
 arch/um/sys-i386/asm/elf.h |    2 +
 arch/um/sys-i386/mem.c     |   62 +++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+), 1 deletion(-)

diff -puN arch/um/sys-i386/Makefile~um-set-__have_arch_gate_area-for-i386 arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~um-set-__have_arch_gate_area-for-i386
+++ a/arch/um/sys-i386/Makefile
@@ -4,7 +4,7 @@
 
 obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
-	sys_call_table.o tls.o atomic64_cx8_32.o
+	sys_call_table.o tls.o atomic64_cx8_32.o mem.o
 
 obj-$(CONFIG_BINFMT_ELF) += elfcore.o
 
diff -puN arch/um/sys-i386/asm/elf.h~um-set-__have_arch_gate_area-for-i386 arch/um/sys-i386/asm/elf.h
--- a/arch/um/sys-i386/asm/elf.h~um-set-__have_arch_gate_area-for-i386
+++ a/arch/um/sys-i386/asm/elf.h
@@ -105,6 +105,8 @@ extern unsigned long __kernel_vsyscall;
 #define FIXADDR_USER_START      VSYSCALL_BASE
 #define FIXADDR_USER_END        VSYSCALL_END
 
+#define __HAVE_ARCH_GATE_AREA 1
+
 /*
  * Architecture-neutral AT_ values in 0-17, leave some room
  * for more of them, start the x86-specific ones at 32.
diff -puN /dev/null arch/um/sys-i386/mem.c
--- /dev/null
+++ a/arch/um/sys-i386/mem.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2011 Richard Weinberger <richrd@nod.at>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <asm/mman.h>
+
+static struct vm_area_struct gate_vma;
+
+static int __init gate_vma_init(void)
+{
+	if (!FIXADDR_USER_START)
+		return 0;
+
+	gate_vma.vm_mm = NULL;
+	gate_vma.vm_start = FIXADDR_USER_START;
+	gate_vma.vm_end = FIXADDR_USER_END;
+	gate_vma.vm_flags = VM_READ | VM_MAYREAD | VM_EXEC | VM_MAYEXEC;
+	gate_vma.vm_page_prot = __P101;
+
+	/*
+	 * Make sure the vDSO gets into every core dump.
+	 * Dumping its contents makes post-mortem fully interpretable later
+	 * without matching up the same kernel and hardware config to see
+	 * what PC values meant.
+	 */
+	gate_vma.vm_flags |= VM_ALWAYSDUMP;
+
+	return 0;
+}
+__initcall(gate_vma_init);
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return FIXADDR_USER_START ? &gate_vma : NULL;
+}
+
+int in_gate_area_no_mm(unsigned long addr)
+{
+	if (!FIXADDR_USER_START)
+		return 0;
+
+	if ((addr >= FIXADDR_USER_START) && (addr < FIXADDR_USER_END))
+		return 1;
+
+	return 0;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	struct vm_area_struct *vma = get_gate_vma(mm);
+
+	if (!vma)
+		return 0;
+
+	return (addr >= vma->vm_start) && (addr < vma->vm_end);
+}
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

