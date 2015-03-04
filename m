From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch removed from
 -mm tree
Date: Wed, 04 Mar 2015 13:34:18 -0800
Message-ID: <54f77a5a.V/H0BN4Y7PbSguNu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbbCDVeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:34:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a.ryabinin@samsung.com, achandran@mvista.com, alex@alex-smith.me.uk, behanw@converseincode.com, ben@decadent.org.uk, benh@kernel.crashing.org, catalin.marinas@arm.com, dave.long@linaro.org, dl9pf@gmx.de, hecmargi@upv.es, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, iripoll@upv.es, jeffbailey@google.com, linux@arm.linux.org.uk, luto@amacapital.net, markos.chandras@imgtec.com, mingo@kernel.org, mpe@ellerman.id.au, oleg@redhat.com, orca.chen@gmail.com, paul.burton@imgtec.com, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, vvijayan@mvista.com, will.deacon@arm.com, ydroneaud@opteya.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fold arch_randomize_brk into ARCH_HAS_ELF_RANDOMIZE
has been removed from the -mm tree.  Its filename was
     mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: fold arch_randomize_brk into ARCH_HAS_ELF_RANDOMIZE

arch_randomize_brk() is used on several architectures, even those that
don't support ET_DYN ASLR.  To avoid bulky extern/#define tricks,
consolidate the support under CONFIG_ARCH_HAS_ELF_RANDOMIZE for the
architectures that support it, while still handling CONFIG_COMPAT_BRK.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Russell King <linux@arm.linux.org.uk>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Arun Chandran <achandran@mvista.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Min-Hua Chen <orca.chen@gmail.com>
Cc: Paul Burton <paul.burton@imgtec.com>
Cc: Alex Smith <alex@alex-smith.me.uk>
Cc: Markos Chandras <markos.chandras@imgtec.com>
Cc: Vineeth Vijayan <vvijayan@mvista.com>
Cc: Jeff Bailey <jeffbailey@google.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Behan Webster <behanw@converseincode.com>
Cc: Ismael Ripoll <iripoll@upv.es>
Cc: Jan-Simon Mller <dl9pf@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                   |    1 +
 arch/arm/include/asm/elf.h     |    4 ----
 arch/arm64/include/asm/elf.h   |    4 ----
 arch/mips/include/asm/elf.h    |    4 ----
 arch/powerpc/include/asm/elf.h |    4 ----
 arch/s390/include/asm/elf.h    |    3 ---
 arch/x86/include/asm/elf.h     |    3 ---
 fs/binfmt_elf.c                |    4 +---
 include/linux/elf-randomize.h  |   12 ++++++++++++
 9 files changed, 14 insertions(+), 25 deletions(-)

diff -puN arch/Kconfig~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize arch/Kconfig
--- a/arch/Kconfig~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/arch/Kconfig
@@ -494,6 +494,7 @@ config ARCH_HAS_ELF_RANDOMIZE
 	  An architecture supports choosing randomized locations for
 	  stack, mmap, brk, and ET_DYN. Defined functions:
 	  - arch_mmap_rnd(), must respect (current->flags & PF_RANDOMIZE)
+	  - arch_randomize_brk()
 
 #
 # ABI hall of shame
diff -puN arch/arm/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize arch/arm/include/asm/elf.h
--- a/arch/arm/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/arch/arm/include/asm/elf.h
@@ -125,10 +125,6 @@ int dump_task_regs(struct task_struct *t
 extern void elf_set_personality(const struct elf32_hdr *);
 #define SET_PERSONALITY(ex)	elf_set_personality(&(ex))
 
-struct mm_struct;
-extern unsigned long arch_randomize_brk(struct mm_struct *mm);
-#define arch_randomize_brk arch_randomize_brk
-
 #ifdef CONFIG_MMU
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 struct linux_binprm;
diff -puN arch/arm64/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/arch/arm64/include/asm/elf.h
@@ -156,10 +156,6 @@ extern int arch_setup_additional_pages(s
 #define STACK_RND_MASK			(0x3ffff >> (PAGE_SHIFT - 12))
 #endif
 
-struct mm_struct;
-extern unsigned long arch_randomize_brk(struct mm_struct *mm);
-#define arch_randomize_brk arch_randomize_brk
-
 #ifdef CONFIG_COMPAT
 
 #ifdef __AARCH64EB__
diff -puN arch/mips/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize arch/mips/include/asm/elf.h
--- a/arch/mips/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/arch/mips/include/asm/elf.h
@@ -410,10 +410,6 @@ struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int uses_interp);
 
-struct mm_struct;
-extern unsigned long arch_randomize_brk(struct mm_struct *mm);
-#define arch_randomize_brk arch_randomize_brk
-
 struct arch_elf_state {
 	int fp_abi;
 	int interp_fp_abi;
diff -puN arch/powerpc/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize arch/powerpc/include/asm/elf.h
--- a/arch/powerpc/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/arch/powerpc/include/asm/elf.h
@@ -128,10 +128,6 @@ extern int arch_setup_additional_pages(s
 	(0x7ff >> (PAGE_SHIFT - 12)) : \
 	(0x3ffff >> (PAGE_SHIFT - 12)))
 
-extern unsigned long arch_randomize_brk(struct mm_struct *mm);
-#define arch_randomize_brk arch_randomize_brk
-
-
 #ifdef CONFIG_SPU_BASE
 /* Notes used in ET_CORE. Note name is "SPU/<fd>/<filename>". */
 #define NT_SPU		1
diff -puN arch/s390/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize arch/s390/include/asm/elf.h
--- a/arch/s390/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/arch/s390/include/asm/elf.h
@@ -226,9 +226,6 @@ struct linux_binprm;
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 int arch_setup_additional_pages(struct linux_binprm *, int);
 
-extern unsigned long arch_randomize_brk(struct mm_struct *mm);
-#define arch_randomize_brk arch_randomize_brk
-
 void *fill_cpu_elf_notes(void *ptr, struct save_area *sa, __vector128 *vxrs);
 
 #endif
diff -puN arch/x86/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize arch/x86/include/asm/elf.h
--- a/arch/x86/include/asm/elf.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/arch/x86/include/asm/elf.h
@@ -338,9 +338,6 @@ extern int compat_arch_setup_additional_
 					      int uses_interp);
 #define compat_arch_setup_additional_pages compat_arch_setup_additional_pages
 
-extern unsigned long arch_randomize_brk(struct mm_struct *mm);
-#define arch_randomize_brk arch_randomize_brk
-
 /*
  * True on X86_32 or when emulating IA32 on X86_64
  */
diff -puN fs/binfmt_elf.c~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/fs/binfmt_elf.c
@@ -1041,15 +1041,13 @@ static int load_elf_binary(struct linux_
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
-#ifdef arch_randomize_brk
 	if ((current->flags & PF_RANDOMIZE) && (randomize_va_space > 1)) {
 		current->mm->brk = current->mm->start_brk =
 			arch_randomize_brk(current->mm);
-#ifdef CONFIG_COMPAT_BRK
+#ifdef compat_brk_randomized
 		current->brk_randomized = 1;
 #endif
 	}
-#endif
 
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
diff -puN include/linux/elf-randomize.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize include/linux/elf-randomize.h
--- a/include/linux/elf-randomize.h~mm-fold-arch_randomize_brk-into-arch_has_elf_randomize
+++ a/include/linux/elf-randomize.h
@@ -1,10 +1,22 @@
 #ifndef _ELF_RANDOMIZE_H
 #define _ELF_RANDOMIZE_H
 
+struct mm_struct;
+
 #ifndef CONFIG_ARCH_HAS_ELF_RANDOMIZE
 static inline unsigned long arch_mmap_rnd(void) { return 0; }
+# if defined(arch_randomize_brk) && defined(CONFIG_COMPAT_BRK)
+#  define compat_brk_randomized
+# endif
+# ifndef arch_randomize_brk
+#  define arch_randomize_brk(mm)	(mm->brk)
+# endif
 #else
 extern unsigned long arch_mmap_rnd(void);
+extern unsigned long arch_randomize_brk(struct mm_struct *mm);
+# ifdef CONFIG_COMPAT_BRK
+#  define compat_brk_randomized
+# endif
 #endif
 
 #endif
_

Patches currently in -mm which might be from keescook@chromium.org are

lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

