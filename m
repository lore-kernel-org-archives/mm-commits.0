From: akpm@linux-foundation.org
Subject: + fix-offset2lib-issue-for-x86-arm-powerpc-and-mips.patch added
 to -mm tree
Date: Thu, 26 Feb 2015 14:38:59 -0800
Message-ID: <54efa083.BKQYXl+Nx/aJMByK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbbBZWjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 17:39:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hecmargi@upv.es, benh@kernel.crashing.org, catalin.marinas@arm.com, hpa@zytor.com, iripoll@upv.es, keescook@chromium.org, mingo@kernel.org, ralf@linux-mips.org, rmk@arm.linux.org.uk, tglx@linutronix.de, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ASLP: fix offset2lib issue for x86*, ARM*, PowerPC and MIPS
has been added to the -mm tree.  Its filename is
     fix-offset2lib-issue-for-x86-arm-powerpc-and-mips.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-offset2lib-issue-for-x86-arm-powerpc-and-mips.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-offset2lib-issue-for-x86-arm-powerpc-and-mips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hector Marco Gisbert <hecmargi@upv.es>
Subject: ASLP: fix offset2lib issue for x86*, ARM*, PowerPC and MIPS

The issue appears on PIE linked executables when all memory areas of a
process are randomized.  In this case, the attack "offset2lib"
de-randomizes all library areas on 64 bit Linux systems in less than one
second.

Further details of the PoC attack at:
http://cybersecurity.upv.es/attacks/offset2lib/offset2lib.html

This patch loads the PIE linked executable in a different area than the
libraries.  The successful fix can be tested with a simple pie compiled
application:

$ ./show_mmaps_pie
54859ccd6000-54859ccd7000 r-xp  ...  /tmp/show_mmaps_pie
54859ced6000-54859ced7000 r--p  ...  /tmp/show_mmaps_pie
54859ced7000-54859ced8000 rw-p  ...  /tmp/show_mmaps_pie
7f75be764000-7f75be91f000 r-xp  ...  /lib/x86_64-linux-gnu/libc.so.6
7f75be91f000-7f75beb1f000 ---p  ...  /lib/x86_64-linux-gnu/libc.so.6
7f75beb1f000-7f75beb23000 r--p  ...  /lib/x86_64-linux-gnu/libc.so.6
7f75beb23000-7f75beb25000 rw-p  ...  /lib/x86_64-linux-gnu/libc.so.6
7f75beb25000-7f75beb2a000 rw-p  ...
7f75beb2a000-7f75beb4d000 r-xp  ...  /lib64/ld-linux-x86-64.so.2
7f75bed45000-7f75bed46000 rw-p  ...
7f75bed46000-7f75bed47000 r-xp  ...
7f75bed47000-7f75bed4c000 rw-p  ...
7f75bed4c000-7f75bed4d000 r--p  ...  /lib64/ld-linux-x86-64.so.2
7f75bed4d000-7f75bed4e000 rw-p  ...  /lib64/ld-linux-x86-64.so.2
7f75bed4e000-7f75bed4f000 rw-p  ...
7fffb3741000-7fffb3762000 rw-p  ...  [stack]
7fffb377b000-7fffb377d000 r--p  ...  [vvar]
7fffb377d000-7fffb377f000 r-xp  ...  [vdso]

Once corrected, the PIE linked application is loaded in a different area.

We updated the "Fixing Offset2lib weakness" page:
http://cybersecurity.upv.es/solutions/aslrv2/aslrv2.html

Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Ismael Ripoll <iripoll@upv.es>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig               |    1 -
 arch/arm/include/asm/elf.h     |    3 ++-
 arch/arm/mm/mmap.c             |   21 +++++++++++++++++++++
 arch/arm64/Kconfig             |    1 -
 arch/arm64/include/asm/elf.h   |    4 ++--
 arch/arm64/mm/mmap.c           |   10 ++++++++++
 arch/mips/Kconfig              |    1 -
 arch/mips/include/asm/elf.h    |    3 ++-
 arch/mips/mm/mmap.c            |   10 ++++++++++
 arch/powerpc/Kconfig           |    1 -
 arch/powerpc/include/asm/elf.h |    3 ++-
 arch/powerpc/mm/mmap.c         |   10 ++++++++++
 arch/x86/Kconfig               |    1 -
 arch/x86/include/asm/elf.h     |    3 ++-
 arch/x86/mm/mmap.c             |    9 +++++++++
 fs/Kconfig.binfmt              |    2 --
 fs/binfmt_elf.c                |   14 --------------
 17 files changed, 70 insertions(+), 27 deletions(-)

diff -puN arch/arm/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/arm/Kconfig
--- a/arch/arm/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/arm/Kconfig
@@ -1,7 +1,6 @@
 config ARM
 	bool
 	default y
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
diff -puN arch/arm/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/arm/include/asm/elf.h
--- a/arch/arm/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/arm/include/asm/elf.h
@@ -115,7 +115,8 @@ int dump_task_regs(struct task_struct *t
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-#define ELF_ET_DYN_BASE	(2 * TASK_SIZE / 3)
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE / 3))
 
 /* When the program starts, a1 contains a pointer to a function to be 
    registered with atexit, as per the SVR4 ABI.  A value of 0 means we 
diff -puN arch/arm/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/arm/mm/mmap.c
@@ -30,6 +30,17 @@ static int mmap_is_legacy(void)
 	return sysctl_legacy_va_layout;
 }
 
+static unsigned long mmap_rnd(void)
+{
+	unsigned long rnd = 0;
+
+	/* 8 bits of randomness in 20 address space bits */
+	if (current->flags & PF_RANDOMIZE)
+		rnd = (long)get_random_int() % (1 << 8);
+
+	return rnd << PAGE_SHIFT;
+}
+
 static unsigned long mmap_base(unsigned long rnd)
 {
 	unsigned long gap = rlimit(RLIMIT_STACK);
@@ -230,3 +241,13 @@ int devmem_is_allowed(unsigned long pfn)
 }
 
 #endif
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) ||
+		!(current->flags & PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
diff -puN arch/arm64/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/arm64/Kconfig
@@ -1,6 +1,5 @@
 config ARM64
 	def_bool y
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SG_CHAIN
diff -puN arch/arm64/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/arm64/include/asm/elf.h
--- a/arch/arm64/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/arm64/include/asm/elf.h
@@ -126,7 +126,7 @@ typedef struct user_fpsimd_state elf_fpr
  * that it will "exec", and that there is sufficient room for the brk.
  */
 extern unsigned long randomize_et_dyn(unsigned long base);
-#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
+#define ELF_ET_DYN_BASE	(randomize_et_dyn(2 * TASK_SIZE_64 / 3))
 
 /*
  * When the program starts, a1 contains a pointer to a function to be
@@ -169,7 +169,7 @@ extern unsigned long arch_randomize_brk(
 #define COMPAT_ELF_PLATFORM		("v8l")
 #endif
 
-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
+#define COMPAT_ELF_ET_DYN_BASE		(randomize_et_dyn(2 * TASK_SIZE_32 / 3))
 
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
diff -puN arch/arm64/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/arm64/mm/mmap.c
@@ -89,6 +89,16 @@ void arch_pick_mmap_layout(struct mm_str
 }
 EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
 
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) ||
+		!(current->flags & PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
+
 
 /*
  * You really shouldn't be using read() or write() on /dev/mem.  This might go
diff -puN arch/mips/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/mips/Kconfig
--- a/arch/mips/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/mips/Kconfig
@@ -23,7 +23,6 @@ config MIPS
 	select HAVE_KRETPROBES
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_SYSCALL_TRACEPOINTS
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES && 64BIT
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
diff -puN arch/mips/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/mips/include/asm/elf.h
--- a/arch/mips/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/mips/include/asm/elf.h
@@ -402,7 +402,8 @@ extern const char *__elf_platform;
    that it will "exec", and that there is sufficient room for the brk.	*/
 
 #ifndef ELF_ET_DYN_BASE
-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE		(randomize_et_dyn(TASK_SIZE / 3 * 2))
 #endif
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
diff -puN arch/mips/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/mips/mm/mmap.c
@@ -196,3 +196,13 @@ int __virt_addr_valid(const volatile voi
 	return pfn_valid(PFN_DOWN(virt_to_phys(kaddr)));
 }
 EXPORT_SYMBOL_GPL(__virt_addr_valid);
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) ||
+		!(current->flags & PF_RANDOMIZE))
+		return base;
+	ret = base + brk_rnd();
+	return (ret > base) ? ret : base;
+}
diff -puN arch/powerpc/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/powerpc/Kconfig
@@ -88,7 +88,6 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select OF
 	select OF_EARLY_FLATTREE
 	select OF_RESERVED_MEM
diff -puN arch/powerpc/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/powerpc/include/asm/elf.h
--- a/arch/powerpc/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/powerpc/include/asm/elf.h
@@ -28,7 +28,8 @@
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-#define ELF_ET_DYN_BASE	0x20000000
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE	(randomize_et_dyn(0x20000000))
 
 #define ELF_CORE_EFLAGS (is_elf2_task() ? 2 : 0)
 
diff -puN arch/powerpc/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/powerpc/mm/mmap.c
@@ -97,3 +97,13 @@ void arch_pick_mmap_layout(struct mm_str
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
+
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) ||
+		!(current->flags & PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
diff -puN arch/x86/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/x86/Kconfig
--- a/arch/x86/Kconfig~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/x86/Kconfig
@@ -87,7 +87,6 @@ config X86
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_ARCH_KASAN if X86_64 && SPARSEMEM_VMEMMAP
 	select HAVE_USER_RETURN_NOTIFIER
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select SPARSE_IRQ
diff -puN arch/x86/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/x86/include/asm/elf.h
--- a/arch/x86/include/asm/elf.h~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/x86/include/asm/elf.h
@@ -249,7 +249,8 @@ extern int force_personality32;
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+extern unsigned long randomize_et_dyn(unsigned long base);
+#define ELF_ET_DYN_BASE		(randomize_et_dyn(TASK_SIZE / 3 * 2))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports.  This could be done in user space,
diff -puN arch/x86/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/arch/x86/mm/mmap.c
@@ -122,3 +122,12 @@ void arch_pick_mmap_layout(struct mm_str
 		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
 	}
 }
+unsigned long randomize_et_dyn(unsigned long base)
+{
+	unsigned long ret;
+	if ((current->personality & ADDR_NO_RANDOMIZE) ||
+		!(current->flags & PF_RANDOMIZE))
+		return base;
+	ret = base + mmap_rnd();
+	return (ret > base) ? ret : base;
+}
diff -puN fs/Kconfig.binfmt~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/fs/Kconfig.binfmt
@@ -27,8 +27,6 @@ config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
 
-config ARCH_BINFMT_ELF_RANDOMIZE_PIE
-	bool
 
 config ARCH_BINFMT_ELF_STATE
 	bool
diff -puN fs/binfmt_elf.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~fix-offset2lib-issue-for-x86-arm-powerpc-and-mips
+++ a/fs/binfmt_elf.c
@@ -909,21 +909,7 @@ static int load_elf_binary(struct linux_
 			 * default mmap base, as well as whatever program they
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
-#ifdef CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE
-			/* Memory randomization might have been switched off
-			 * in runtime via sysctl or explicit setting of
-			 * personality flags.
-			 * If that is the case, retain the original non-zero
-			 * load_bias value in order to establish proper
-			 * non-randomized mappings.
-			 */
-			if (current->flags & PF_RANDOMIZE)
-				load_bias = 0;
-			else
-				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#endif
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
_

Patches currently in -mm which might be from hecmargi@upv.es are

mips-rename-brk_rnd-to-mmap_rnd.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips.patch
fix-offset2lib-issue-for-x86-arm-powerpc-and-mips-fix.patch

