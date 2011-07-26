From: akpm@linux-foundation.org
Subject: [merged] um-set-__have_arch_gate_area-for-x86_64.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:54:49 -0700
Message-ID: <201107260753.p6Q7rqs7003278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1GZHyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     um: set __HAVE_ARCH_GATE_AREA for x86_64
has been removed from the -mm tree.  Its filename was
     um-set-__have_arch_gate_area-for-x86_64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: set __HAVE_ARCH_GATE_AREA for x86_64
From: Richard Weinberger <richard@nod.at>

Implement arch_vma_name() and make get_gate_vma(), in_gate_area() and
in_gate_area_no_mm() a nop.

We need arch_vma_name() to support vDSO.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-x86_64/Makefile  |    2 +-
 arch/um/sys-x86_64/asm/elf.h |   10 ++++++++++
 arch/um/sys-x86_64/mem.c     |   26 ++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff -puN arch/um/sys-x86_64/Makefile~um-set-__have_arch_gate_area-for-x86_64 arch/um/sys-x86_64/Makefile
--- a/arch/um/sys-x86_64/Makefile~um-set-__have_arch_gate_area-for-x86_64
+++ a/arch/um/sys-x86_64/Makefile
@@ -4,7 +4,7 @@
 # Licensed under the GPL
 #
 
-obj-y = bug.o bugs.o delay.o fault.o ldt.o ptrace.o ptrace_user.o \
+obj-y = bug.o bugs.o delay.o fault.o ldt.o ptrace.o ptrace_user.o mem.o \
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
diff -puN arch/um/sys-x86_64/asm/elf.h~um-set-__have_arch_gate_area-for-x86_64 arch/um/sys-x86_64/asm/elf.h
--- a/arch/um/sys-x86_64/asm/elf.h~um-set-__have_arch_gate_area-for-x86_64
+++ a/arch/um/sys-x86_64/asm/elf.h
@@ -119,4 +119,14 @@ extern long elf_aux_hwcap;
 
 #define SET_PERSONALITY(ex) do ; while(0)
 
+#define __HAVE_ARCH_GATE_AREA 1
+#define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
+struct linux_binprm;
+extern int arch_setup_additional_pages(struct linux_binprm *bprm,
+	int uses_interp);
+
+extern unsigned long um_vdso_addr;
+#define AT_SYSINFO_EHDR 33
+#define ARCH_DLINFO	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr)
+
 #endif
diff -puN /dev/null arch/um/sys-x86_64/mem.c
--- /dev/null
+++ a/arch/um/sys-x86_64/mem.c
@@ -0,0 +1,26 @@
+#include "linux/mm.h"
+#include "asm/page.h"
+#include "asm/mman.h"
+
+const char *arch_vma_name(struct vm_area_struct *vma)
+{
+	if (vma->vm_mm && vma->vm_start == um_vdso_addr)
+		return "[vdso]";
+
+	return NULL;
+}
+
+struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
+{
+	return NULL;
+}
+
+int in_gate_area(struct mm_struct *mm, unsigned long addr)
+{
+	return 0;
+}
+
+int in_gate_area_no_mm(unsigned long addr)
+{
+	return 0;
+}
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch
exec-do-not-call-request_module-twice-from-search_binary_handler.patch
exec-do-not-retry-load_binary-method-if-config_modules=n.patch
gcov-disable-constructors-for-uml.patch

