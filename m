From: akpm@linux-foundation.org
Subject: + um-set-__have_arch_gate_area-for-i386.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:55:17 -0700
Message-ID: <201107222255.p6MMtHgm020038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421Ab1GVWzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at


The patch titled
     um: Set __HAVE_ARCH_GATE_AREA for i386
has been added to the -mm tree.  Its filename is
     um-set-__have_arch_gate_area-for-i386.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
um-clean-up-vm-flagsh.patch
um-exec-remove-redundant-set_fsuser_ds.patch
um-clean-up-delay-functions-v2.patch
um-fix-_fortify_source=2-support-for-kernel-modules.patch
um-add-netpoll-support.patch
um-reinstate-kernel-version-in-generated-config.patch
uml-drivers-net_userc-memory-leak-fix.patch
uml-cow_userc-warning-corrections.patch
uml-helperc-warning-corrections.patch
uml-drivers-slip_userc-memory-leak-fix.patch
uml-free-resources.patch
um-disable-scan_elf_aux-on-x86_64.patch
um-set-__have_arch_gate_area-for-i386.patch
um-set-__have_arch_gate_area-for-x86_64.patch
um-implement-a-x86_64-vdso.patch
um-ajdust-size-of-pid_buf.patch
um-remove-dead-code.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

