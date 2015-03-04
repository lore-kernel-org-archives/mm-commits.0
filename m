From: akpm@linux-foundation.org
Subject: + mm-expose-arch_mmap_rnd-when-available.patch added to -mm tree
Date: Wed, 04 Mar 2015 13:40:21 -0800
Message-ID: <54f77bc5.2I8x1YeUz5l5AY0J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbbCDVkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:40:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a.ryabinin@samsung.com, achandran@mvista.com, alex@alex-smith.me.uk, behanw@converseincode.com, ben@decadent.org.uk, benh@kernel.crashing.org, catalin.marinas@arm.com, dave.long@linaro.org, dl9pf@gmx.de, hecmargi@upv.es, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, iripoll@upv.es, jeffbailey@google.com, linux@arm.linux.org.uk, luto@amacapital.net, markos.chandras@imgtec.com, mingo@kernel.org, mpe@ellerman.id.au, oleg@redhat.com, orca.chen@gmail.com, paul.burton@imgtec.com, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, vvijayan@mvista.com, will.deacon@arm.com, ydroneaud@opteya.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: expose arch_mmap_rnd when available
has been added to the -mm tree.  Its filename is
     mm-expose-arch_mmap_rnd-when-available.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-expose-arch_mmap_rnd-when-available.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-expose-arch_mmap_rnd-when-available.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: expose arch_mmap_rnd when available

When an architecture fully supports randomizing the ELF load location,
a per-arch mmap_rnd() function is used to find a randomized mmap base.
In preparation for randomizing the location of ET_DYN binaries
separately from mmap, this renames and exports these functions as
arch_mmap_rnd(). Additionally introduces CONFIG_ARCH_HAS_ELF_RANDOMIZE
for describing this feature on architectures that support it
(which is a superset of ARCH_BINFMT_ELF_RANDOMIZE_PIE, since s390
already supports a separated ET_DYN ASLR from mmap ASLR without the
ARCH_BINFMT_ELF_RANDOMIZE_PIE logic).

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>
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

 arch/Kconfig                  |    7 +++++++
 arch/arm/Kconfig              |    1 +
 arch/arm/mm/mmap.c            |    4 ++--
 arch/arm64/Kconfig            |    1 +
 arch/arm64/mm/mmap.c          |    4 ++--
 arch/mips/Kconfig             |    1 +
 arch/mips/mm/mmap.c           |    4 ++--
 arch/powerpc/Kconfig          |    1 +
 arch/powerpc/mm/mmap.c        |    4 ++--
 arch/s390/Kconfig             |    1 +
 arch/s390/mm/mmap.c           |    8 ++++----
 arch/x86/Kconfig              |    1 +
 arch/x86/mm/mmap.c            |    4 ++--
 include/linux/elf-randomize.h |   10 ++++++++++
 14 files changed, 37 insertions(+), 14 deletions(-)

diff -puN arch/Kconfig~mm-expose-arch_mmap_rnd-when-available arch/Kconfig
--- a/arch/Kconfig~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/Kconfig
@@ -491,6 +491,13 @@ config PGTABLE_LEVELS
 	int
 	default 2
 
+config ARCH_HAS_ELF_RANDOMIZE
+	bool
+	help
+	  An architecture supports choosing randomized locations for
+	  stack, mmap, brk, and ET_DYN. Defined functions:
+	  - arch_mmap_rnd()
+
 #
 # ABI hall of shame
 #
diff -puN arch/arm/Kconfig~mm-expose-arch_mmap_rnd-when-available arch/arm/Kconfig
--- a/arch/arm/Kconfig~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/arm/Kconfig
@@ -3,6 +3,7 @@ config ARM
 	default y
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
diff -puN arch/arm/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available arch/arm/mm/mmap.c
--- a/arch/arm/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/arm/mm/mmap.c
@@ -169,7 +169,7 @@ arch_get_unmapped_area_topdown(struct fi
 	return addr;
 }
 
-static unsigned long mmap_rnd(void)
+unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
@@ -184,7 +184,7 @@ void arch_pick_mmap_layout(struct mm_str
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = mmap_rnd();
+		random_factor = arch_mmap_rnd();
 
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
diff -puN arch/arm64/Kconfig~mm-expose-arch_mmap_rnd-when-available arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/arm64/Kconfig
@@ -2,6 +2,7 @@ config ARM64
 	def_bool y
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
+	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
diff -puN arch/arm64/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available arch/arm64/mm/mmap.c
--- a/arch/arm64/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/arm64/mm/mmap.c
@@ -47,7 +47,7 @@ static int mmap_is_legacy(void)
 	return sysctl_legacy_va_layout;
 }
 
-static unsigned long mmap_rnd(void)
+unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
@@ -77,7 +77,7 @@ void arch_pick_mmap_layout(struct mm_str
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = mmap_rnd();
+		random_factor = arch_mmap_rnd();
 
 	/*
 	 * Fall back to the standard layout if the personality bit is set, or
diff -puN arch/mips/Kconfig~mm-expose-arch_mmap_rnd-when-available arch/mips/Kconfig
--- a/arch/mips/Kconfig~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/mips/Kconfig
@@ -24,6 +24,7 @@ config MIPS
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_SYSCALL_TRACEPOINTS
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
+	select ARCH_HAS_ELF_RANDOMIZE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES && 64BIT
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
diff -puN arch/mips/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/mips/mm/mmap.c
@@ -142,7 +142,7 @@ unsigned long arch_get_unmapped_area_top
 			addr0, len, pgoff, flags, DOWN);
 }
 
-static unsigned long mmap_rnd(void)
+unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
@@ -161,7 +161,7 @@ void arch_pick_mmap_layout(struct mm_str
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = mmap_rnd();
+		random_factor = arch_mmap_rnd();
 
 	if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
diff -puN arch/powerpc/Kconfig~mm-expose-arch_mmap_rnd-when-available arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/powerpc/Kconfig
@@ -89,6 +89,7 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
+	select ARCH_HAS_ELF_RANDOMIZE
 	select OF
 	select OF_EARLY_FLATTREE
 	select OF_RESERVED_MEM
diff -puN arch/powerpc/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available arch/powerpc/mm/mmap.c
--- a/arch/powerpc/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/powerpc/mm/mmap.c
@@ -53,7 +53,7 @@ static inline int mmap_is_legacy(void)
 	return sysctl_legacy_va_layout;
 }
 
-static unsigned long mmap_rnd(void)
+unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
@@ -87,7 +87,7 @@ void arch_pick_mmap_layout(struct mm_str
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = mmap_rnd();
+		random_factor = arch_mmap_rnd();
 
 	/*
 	 * Fall back to the standard layout if the personality
diff -puN arch/s390/Kconfig~mm-expose-arch_mmap_rnd-when-available arch/s390/Kconfig
--- a/arch/s390/Kconfig~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/s390/Kconfig
@@ -65,6 +65,7 @@ config S390
 	def_bool y
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SG_CHAIN
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/s390/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available arch/s390/mm/mmap.c
--- a/arch/s390/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/s390/mm/mmap.c
@@ -60,7 +60,7 @@ static inline int mmap_is_legacy(void)
 	return sysctl_legacy_va_layout;
 }
 
-static unsigned long mmap_rnd(void)
+unsigned long arch_mmap_rnd(void)
 {
 	if (is_32bit_task())
 		return (get_random_int() & 0x7ff) << PAGE_SHIFT;
@@ -187,7 +187,7 @@ unsigned long randomize_et_dyn(void)
 		base &= ~((1UL << 32) - 1);
 
 	if (current->flags & PF_RANDOMIZE)
-		base += mmap_rnd();
+		base += arch_mmap_rnd();
 
 	return base;
 }
@@ -203,7 +203,7 @@ void arch_pick_mmap_layout(struct mm_str
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = mmap_rnd();
+		random_factor = arch_mmap_rnd();
 
 	/*
 	 * Fall back to the standard layout if the personality
@@ -283,7 +283,7 @@ void arch_pick_mmap_layout(struct mm_str
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = mmap_rnd();
+		random_factor = arch_mmap_rnd();
 
 	/*
 	 * Fall back to the standard layout if the personality
diff -puN arch/x86/Kconfig~mm-expose-arch_mmap_rnd-when-available arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/x86/Kconfig
@@ -88,6 +88,7 @@ config X86
 	select HAVE_ARCH_KASAN if X86_64 && SPARSEMEM_VMEMMAP
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
+	select ARCH_HAS_ELF_RANDOMIZE
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select SPARSE_IRQ
diff -puN arch/x86/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available arch/x86/mm/mmap.c
--- a/arch/x86/mm/mmap.c~mm-expose-arch_mmap_rnd-when-available
+++ a/arch/x86/mm/mmap.c
@@ -65,7 +65,7 @@ static int mmap_is_legacy(void)
 	return sysctl_legacy_va_layout;
 }
 
-static unsigned long mmap_rnd(void)
+unsigned long arch_mmap_rnd(void)
 {
 	unsigned long rnd;
 
@@ -114,7 +114,7 @@ void arch_pick_mmap_layout(struct mm_str
 	unsigned long random_factor = 0UL;
 
 	if (current->flags & PF_RANDOMIZE)
-		random_factor = mmap_rnd();
+		random_factor = arch_mmap_rnd();
 
 	mm->mmap_legacy_base = mmap_legacy_base(random_factor);
 
diff -puN /dev/null include/linux/elf-randomize.h
--- /dev/null
+++ a/include/linux/elf-randomize.h
@@ -0,0 +1,10 @@
+#ifndef _ELF_RANDOMIZE_H
+#define _ELF_RANDOMIZE_H
+
+#ifndef CONFIG_ARCH_HAS_ELF_RANDOMIZE
+static inline unsigned long arch_mmap_rnd(void) { return 0; }
+#else
+extern unsigned long arch_mmap_rnd(void);
+#endif
+
+#endif
_

Patches currently in -mm which might be from keescook@chromium.org are

arm-factor-out-mmap-aslr-into-mmap_rnd.patch
x86-standardize-mmap_rnd-usage.patch
arm64-standardize-mmap_rnd-usage.patch
mips-extract-logic-for-mmap_rnd.patch
powerpc-standardize-mmap_rnd-usage.patch
s390-standardize-mmap_rnd-usage.patch
mm-expose-arch_mmap_rnd-when-available.patch
s390-redefine-randomize_et_dyn-for-elf_et_dyn_base.patch
mm-split-et_dyn-aslr-from-mmap-aslr.patch
mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

