From: akpm@linux-foundation.org
Subject: + um-mdd-support-for-64-bit-atomic-operations.patch added to -mm tree
Date: Thu, 21 Apr 2011 12:26:00 -0700
Message-ID: <201104211926.p3LJQ0PL025368@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab1DUT0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Apr 2011 15:26:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, stable@kernel.org, walch.martin@web.de


The patch titled
     um: mdd support for 64 bit atomic operations
has been added to the -mm tree.  Its filename is
     um-mdd-support-for-64-bit-atomic-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: um: mdd support for 64 bit atomic operations
=46rom: Richard Weinberger <richard@nod.at>

This adds support for 64 bit atomic operations on 32 bit UML systems.  =
XFS
needs them since 2.6.38.

$ make ARCH=3Dum SUBARCH=3Di386
=2E..
  LD      .tmp_vmlinux1
fs/built-in.o: In function `xlog_regrant_reserve_log_space':
xfs_log.c:(.text+0xd8584): undefined reference to `atomic64_read_386'
xfs_log.c:(.text+0xd85ac): undefined reference to `cmpxchg8b_emu'
=2E..

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D32812

Reported-by: Martin Walch <walch.martin@web.de>
Tested-by: Martin Walch <walch.martin@web.de>
Cc: Martin Walch <walch.martin@web.de>
Cc: <stable@kernel.org> [2.6.38.x 084189a: um: disable CONFIG_CMPXCHG_L=
OCAL]
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/sys-i386/Makefile          |    2=20
 arch/um/sys-i386/atomic64_cx8_32.S |  225 +++++++++++++++++++++++++++
 2 files changed, 226 insertions(+), 1 deletion(-)

diff -puN arch/um/sys-i386/Makefile~um-mdd-support-for-64-bit-atomic-op=
erations arch/um/sys-i386/Makefile
--- a/arch/um/sys-i386/Makefile~um-mdd-support-for-64-bit-atomic-operat=
ions
+++ a/arch/um/sys-i386/Makefile
@@ -4,7 +4,7 @@
=20
 obj-y =3D bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace=
=2Eo \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o=
 \
-	sys_call_table.o tls.o
+	sys_call_table.o tls.o atomic64_cx8_32.o
=20
 obj-$(CONFIG_BINFMT_ELF) +=3D elfcore.o
=20
diff -puN /dev/null arch/um/sys-i386/atomic64_cx8_32.S
--- /dev/null
+++ a/arch/um/sys-i386/atomic64_cx8_32.S
@@ -0,0 +1,225 @@
+/*
+ * atomic64_t for 586+
+ *
+ * Copied from arch/x86/lib/atomic64_cx8_32.S
+ *
+ * Copyright =C2=A9 2010  Luca Barbieri
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/alternative-asm.h>
+#include <asm/dwarf2.h>
+
+.macro SAVE reg
+	pushl_cfi %\reg
+	CFI_REL_OFFSET \reg, 0
+.endm
+
+.macro RESTORE reg
+	popl_cfi %\reg
+	CFI_RESTORE \reg
+.endm
+
+.macro read64 reg
+	movl %ebx, %eax
+	movl %ecx, %edx
+/* we need LOCK_PREFIX since otherwise cmpxchg8b always does the write=
 */
+	LOCK_PREFIX
+	cmpxchg8b (\reg)
+.endm
+
+ENTRY(atomic64_read_cx8)
+	CFI_STARTPROC
+
+	read64 %ecx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_read_cx8)
+
+ENTRY(atomic64_set_cx8)
+	CFI_STARTPROC
+
+1:
+/* we don't need LOCK_PREFIX since aligned 64-bit writes
+ * are atomic on 586 and newer */
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_set_cx8)
+
+ENTRY(atomic64_xchg_cx8)
+	CFI_STARTPROC
+
+	movl %ebx, %eax
+	movl %ecx, %edx
+1:
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_xchg_cx8)
+
+.macro addsub_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+	SAVE esi
+	SAVE edi
+
+	movl %eax, %esi
+	movl %edx, %edi
+	movl %ecx, %ebp
+
+	read64 %ebp
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l %esi, %ebx
+	\insc\()l %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE edi
+	RESTORE esi
+	RESTORE ebx
+	RESTORE ebp
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+addsub_return add add adc
+addsub_return sub sub sbb
+
+.macro incdec_return func ins insc
+ENTRY(atomic64_\func\()_return_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	\ins\()l $1, %ebx
+	\insc\()l $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+10:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_\func\()_return_cx8)
+.endm
+
+incdec_return inc add adc
+incdec_return dec sub sbb
+
+ENTRY(atomic64_dec_if_positive_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	subl $1, %ebx
+	sbb $0, %ecx
+	js 2f
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+2:
+	movl %ebx, %eax
+	movl %ecx, %edx
+	RESTORE ebx
+	ret
+	CFI_ENDPROC
+ENDPROC(atomic64_dec_if_positive_cx8)
+
+ENTRY(atomic64_add_unless_cx8)
+	CFI_STARTPROC
+	SAVE ebp
+	SAVE ebx
+/* these just push these two parameters on the stack */
+	SAVE edi
+	SAVE esi
+
+	movl %ecx, %ebp
+	movl %eax, %esi
+	movl %edx, %edi
+
+	read64 %ebp
+1:
+	cmpl %eax, 0(%esp)
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl %esi, %ebx
+	adcl %edi, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%ebp)
+	jne 1b
+
+	movl $1, %eax
+3:
+	addl $8, %esp
+	CFI_ADJUST_CFA_OFFSET -8
+	RESTORE ebx
+	RESTORE ebp
+	ret
+4:
+	cmpl %edx, 4(%esp)
+	jne 2b
+	xorl %eax, %eax
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_add_unless_cx8)
+
+ENTRY(atomic64_inc_not_zero_cx8)
+	CFI_STARTPROC
+	SAVE ebx
+
+	read64 %esi
+1:
+	testl %eax, %eax
+	je 4f
+2:
+	movl %eax, %ebx
+	movl %edx, %ecx
+	addl $1, %ebx
+	adcl $0, %ecx
+	LOCK_PREFIX
+	cmpxchg8b (%esi)
+	jne 1b
+
+	movl $1, %eax
+3:
+	RESTORE ebx
+	ret
+4:
+	testl %edx, %edx
+	jne 2b
+	jmp 3b
+	CFI_ENDPROC
+ENDPROC(atomic64_inc_not_zero_cx8)
_

Patches currently in -mm which might be from richard@nod.at are

um-adjust-current_thread_info-for-gcc-46.patch
um-mdd-support-for-64-bit-atomic-operations.patch
uml-fix-hppfs-build.patch
mm-mmu_gather-rework.patch
powerpc-mmu_gather-rework.patch
sparc-mmu_gather-rework.patch
s390-mmu_gather-rework.patch
arm-mmu_gather-rework.patch
sh-mmu_gather-rework.patch
ia64-mmu_gather-rework.patch
um-mmu_gather-rework.patch
mm-now-that-all-old-mmu_gather-code-is-gone-remove-the-storage.patch
mm-powerpc-move-the-rcu-page-table-freeing-into-generic-code.patch
mm-extended-batches-for-generic-mmu_gather.patch
lockdep-mutex-provide-mutex_lock_nest_lock.patch
mm-remove-i_mmap_lock-lockbreak.patch
mm-convert-i_mmap_lock-to-a-mutex.patch
mm-revert-page_lock_anon_vma-lock-annotation.patch
mm-improve-page_lock_anon_vma-comment.patch
mm-use-refcounts-for-page_lock_anon_vma.patch
mm-convert-anon_vma-lock-to-a-mutex.patch
mm-optimize-page_lock_anon_vma-fast-path.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
