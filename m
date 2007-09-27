From: akpm@linux-foundation.org
Subject: + i386-and-x86_64-randomize-brk-2.patch added to -mm tree
Date: Thu, 27 Sep 2007 15:13:26 -0700
Message-ID: <200709272213.l8RMDQFk030480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34321 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757326AbXI0WO1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 18:14:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, apw@shadowen.org, arjan@infradead.org, kamalesh@linux.vnet.ibm.com, vagabon.xyz@gmail.com


The patch titled
     i386 and x86_64: randomize brk()
has been added to the -mm tree.  Its filename is
     i386-and-x86_64-randomize-brk-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 and x86_64: randomize brk()
From: Jiri Kosina <jkosina@suse.cz>
This patch randomizes the location of the heap (brk) for i386 and x86_64.
The range is randomized in the range starting at current brk location up
to 0x02000000 offset for both architectures. This, together with
pie-executable-randomization.patch and
pie-executable-randomization-fix.patch, should make the address space
randomization on i386 and x86_64 complete.

The empty stubs are not added for architectures that don't support ELF
binaries, namely blackfin, h8300, m68knommu and v850.

Arjan says:

This is known to break older versions of some emacs variants, whose dumper
code assumed that the last variable declared in the program is equal to
the start of the dynamically allocated memory region.

(The dumper is the code where emacs effectively dumps core at the end of
it's compilation stage; this coredump is then loaded as the main program
during normal use)

iirc this was 5 years or so; we found this way back when I was at RH and
we first did the security stuff there (including this brk randomization).
It wasn't all variants of emacs, and it got fixed as a result (I vaguely
remember that emacs already had code to deal with it for other archs/oses,
just ifdeffed wrongly).

It's a rare and wrong assumption as a general thing, just on x86 it mostly
happened to be true (but to be honest, it'll break too if gcc does
something fancy or if the linker does a non-standard order).  Still its
something we should at least document.

Note 2: afaik it only broke the emacs *build*.  I'm not 100% sure about
that (it IS 5 years ago) though.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/i386/kernel/process.c~i386-and-x86_64-randomize-brk-2 arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~i386-and-x86_64-randomize-brk-2
+++ a/arch/i386/kernel/process.c
@@ -973,3 +973,17 @@ unsigned long arch_align_stack(unsigned 
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(void)
+{
+	unsigned long new_brk;
+	unsigned long range_start;
+	unsigned long range_end;
+
+	range_start = current->mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		current->mm->brk = current->mm->start_brk = new_brk;
+}
+
diff -puN arch/x86_64/ia32/ia32_binfmt.c~i386-and-x86_64-randomize-brk-2 arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~i386-and-x86_64-randomize-brk-2
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -227,6 +227,7 @@ static void elf32_init(struct pt_regs *)
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 #define arch_setup_additional_pages syscall32_setup_pages
 extern int syscall32_setup_pages(struct linux_binprm *, int exstack);
+extern void arch_randomize_brk(void);
 
 #include "../../../fs/binfmt_elf.c" 
 
diff -puN arch/x86_64/kernel/process.c~i386-and-x86_64-randomize-brk-2 arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~i386-and-x86_64-randomize-brk-2
+++ a/arch/x86_64/kernel/process.c
@@ -905,3 +905,17 @@ unsigned long arch_align_stack(unsigned 
 		sp -= get_random_int() % 8192;
 	return sp & ~0xf;
 }
+
+void arch_randomize_brk(void)
+{
+	unsigned long new_brk;
+	unsigned long range_start;
+	unsigned long range_end;
+
+	range_start = current->mm->brk;
+	range_end = range_start + 0x02000000;
+	new_brk = randomize_range(range_start, range_end, 0);
+	if (new_brk)
+		current->mm->brk = current->mm->start_brk = new_brk;
+}
+
diff -puN fs/binfmt_elf.c~i386-and-x86_64-randomize-brk-2 fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~i386-and-x86_64-randomize-brk-2
+++ a/fs/binfmt_elf.c
@@ -1081,6 +1081,9 @@ static int load_elf_binary(struct linux_
 	current->mm->end_data = end_data;
 	current->mm->start_stack = bprm->p;
 
+	if (current->flags & PF_RANDOMIZE)
+		arch_randomize_brk();
+
 	if (current->personality & MMAP_PAGE_ZERO) {
 		/* Why this, you ask???  Well SVr4 maps page 0 as read-only,
 		   and some applications "depend" upon this behavior.
diff -puN include/asm-alpha/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-alpha/elf.h
--- a/include/asm-alpha/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-alpha/elf.h
@@ -163,5 +163,9 @@ extern int alpha_l3_cacheshape;
     NEW_AUX_ENT(AT_L3_CACHESHAPE, alpha_l3_cacheshape);		\
   } while (0)
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_ALPHA_ELF_H */
diff -puN include/asm-arm/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-arm/elf.h
--- a/include/asm-arm/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-arm/elf.h
@@ -116,4 +116,8 @@ extern char elf_platform[];
 
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff -puN include/asm-avr32/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-avr32/elf.h
--- a/include/asm-avr32/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-avr32/elf.h
@@ -107,4 +107,8 @@ typedef struct user_fpu_struct elf_fpreg
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __ASM_AVR32_ELF_H */
diff -puN include/asm-cris/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-cris/elf.h
--- a/include/asm-cris/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-cris/elf.h
@@ -93,4 +93,8 @@ typedef unsigned long elf_fpregset_t;
 
 #endif /* __KERNEL__ */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff -puN include/asm-frv/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-frv/elf.h
--- a/include/asm-frv/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-frv/elf.h
@@ -141,4 +141,8 @@ do {											\
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff -puN include/asm-i386/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-i386/elf.h
--- a/include/asm-i386/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-i386/elf.h
@@ -160,4 +160,6 @@ do if (vdso_enabled) {							\
 
 #endif
 
+extern void arch_randomize_brk(void);
+
 #endif
diff -puN include/asm-ia64/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-ia64/elf.h
--- a/include/asm-ia64/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-ia64/elf.h
@@ -249,4 +249,8 @@ do {									\
 
 #endif /* __KERNEL__ */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* _ASM_IA64_ELF_H */
diff -puN include/asm-m32r/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-m32r/elf.h
--- a/include/asm-m32r/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-m32r/elf.h
@@ -133,4 +133,8 @@ typedef elf_fpreg_t elf_fpregset_t;
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif  /* _ASM_M32R__ELF_H */
diff -puN include/asm-m68k/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-m68k/elf.h
--- a/include/asm-m68k/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-m68k/elf.h
@@ -118,4 +118,8 @@ typedef struct user_m68kfp_struct elf_fp
 #define SET_PERSONALITY(ex, ibcs2) set_personality((ibcs2)?PER_SVR4:PER_LINUX)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff -puN include/asm-mips/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-mips/elf.h
--- a/include/asm-mips/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-mips/elf.h
@@ -372,4 +372,8 @@ extern int dump_task_fpu(struct task_str
 #define ELF_ET_DYN_BASE         (TASK_SIZE / 3 * 2)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* _ASM_ELF_H */
diff -puN include/asm-parisc/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-parisc/elf.h
--- a/include/asm-parisc/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-parisc/elf.h
@@ -344,4 +344,8 @@ struct pt_regs;	/* forward declaration..
 #define ELF_HWCAP	0
 /* (boot_cpu_data.x86_capability) */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff -puN include/asm-powerpc/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-powerpc/elf.h
--- a/include/asm-powerpc/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-powerpc/elf.h
@@ -419,4 +419,8 @@ do {									\
 
 #endif /* CONFIG_SPU_BASE */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* _ASM_POWERPC_ELF_H */
diff -puN include/asm-s390/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-s390/elf.h
--- a/include/asm-s390/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-s390/elf.h
@@ -216,4 +216,8 @@ do {							\
 #endif /* __s390x__ */
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff -puN include/asm-sh/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-sh/elf.h
--- a/include/asm-sh/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-sh/elf.h
@@ -140,4 +140,8 @@ do {								\
 } while (0)
 #endif /* CONFIG_VSYSCALL */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __ASM_SH_ELF_H */
diff -puN include/asm-sh64/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-sh64/elf.h
--- a/include/asm-sh64/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-sh64/elf.h
@@ -104,4 +104,8 @@ typedef struct user_fpu_struct elf_fpreg
 #define SET_PERSONALITY(ex, ibcs2) set_personality(PER_LINUX_32BIT)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* __ASM_SH64_ELF_H */
diff -puN include/asm-sparc/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-sparc/elf.h
--- a/include/asm-sparc/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-sparc/elf.h
@@ -168,4 +168,8 @@ do {	unsigned long *dest = &(__elf_regs[
 
 #endif /* __KERNEL__ */
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* !(__ASMSPARC_ELF_H) */
diff -puN include/asm-sparc64/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-sparc64/elf.h
--- a/include/asm-sparc64/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-sparc64/elf.h
@@ -196,4 +196,8 @@ do {	unsigned long new_flags = current_t
 } while (0)
 #endif
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif /* !(__ASM_SPARC64_ELF_H) */
diff -puN include/asm-um/elf-x86_64.h~i386-and-x86_64-randomize-brk-2 include/asm-um/elf-x86_64.h
--- a/include/asm-um/elf-x86_64.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-um/elf-x86_64.h
@@ -122,4 +122,8 @@ extern long elf_aux_hwcap;
 
 #define SET_PERSONALITY(ex, ibcs2) do ; while(0)
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif
diff -puN include/asm-x86_64/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-x86_64/elf.h
--- a/include/asm-x86_64/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-x86_64/elf.h
@@ -177,4 +177,6 @@ do if (vdso_enabled) {						\
 
 #endif
 
+extern void arch_randomize_brk(void);
+
 #endif
diff -puN include/asm-xtensa/elf.h~i386-and-x86_64-randomize-brk-2 include/asm-xtensa/elf.h
--- a/include/asm-xtensa/elf.h~i386-and-x86_64-randomize-brk-2
+++ a/include/asm-xtensa/elf.h
@@ -272,5 +272,9 @@ extern void do_save_fpregs (elf_fpregset
 extern int do_restore_fpregs (elf_fpregset_t*, struct pt_regs*,
 			      struct task_struct*);
 
+static inline void arch_randomize_brk(void)
+{
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _XTENSA_ELF_H */
_

Patches currently in -mm which might be from jkosina@suse.cz are

git-hid.patch
drivers-hid-hid-debugc-add-kern_debug-prefix-fix-typo-constify-fix.patch
adbhid-produce-all-capslock-key-events.patch
keyboard-capsshift-lock.patch
console-keyboard-events-and-accessibility.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
make-wistron-btns-recognize-special-keys-on-medion-wim2160-notebooks.patch
git-ipwireless_cs.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
i386-and-x86_64-randomize-brk-2.patch
i386-and-x86_64-randomize-brk-fix.patch
add-config_vt_unicode.patch
get-rid-of-input-bit-duplicate-defines.patch
