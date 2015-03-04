From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-split-et_dyn-aslr-from-mmap-aslr.patch removed from -mm tree
Date: Wed, 04 Mar 2015 13:34:15 -0800
Message-ID: <54f77a57.jysJPplN7sr30x8U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbCDVeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 16:34:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a.ryabinin@samsung.com, achandran@mvista.com, alex@alex-smith.me.uk, behanw@converseincode.com, ben@decadent.org.uk, benh@kernel.crashing.org, catalin.marinas@arm.com, dave.long@linaro.org, dl9pf@gmx.de, hecmargi@upv.es, heiko.carstens@de.ibm.com, holzheu@linux.vnet.ibm.com, iripoll@upv.es, jeffbailey@google.com, linux@arm.linux.org.uk, luto@amacapital.net, markos.chandras@imgtec.com, mingo@kernel.org, mpe@ellerman.id.au, oleg@redhat.com, orca.chen@gmail.com, paul.burton@imgtec.com, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, vvijayan@mvista.com, will.deacon@arm.com, ydroneaud@opteya.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: split ET_DYN ASLR from mmap ASLR
has been removed from the -mm tree.  Its filename was
     mm-split-et_dyn-aslr-from-mmap-aslr.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: split ET_DYN ASLR from mmap ASLR

This fixes the "offset2lib" weakness in ASLR for arm, arm64, mips,
powerpc, and x86.  The problem is that if there is a leak of ASLR from the
executable (ET_DYN), it means a leak of shared library offset as well
(mmap), and vice versa.  Further details and a PoC of this attack are
available here:
http://cybersecurity.upv.es/attacks/offset2lib/offset2lib.html

With this patch, a PIE linked executable (ET_DYN) has its own ASLR region:

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

The change is to add a call the newly created arch_mmap_rnd() into the ELF
loader for handling ET_DYN ASLR in a separate region from mmap ASLR, as
already done on s390.  Removes CONFIG_BINFMT_ELF_RANDOMIZE_PIE, which is
no longer needed.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Hector Marco-Gisbert <hecmargi@upv.es>
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

 arch/arm/Kconfig            |    1 -
 arch/arm64/Kconfig          |    1 -
 arch/mips/Kconfig           |    1 -
 arch/powerpc/Kconfig        |    1 -
 arch/s390/include/asm/elf.h |    4 ++--
 arch/x86/Kconfig            |    1 -
 fs/Kconfig.binfmt           |    3 ---
 fs/binfmt_elf.c             |   17 ++---------------
 8 files changed, 4 insertions(+), 25 deletions(-)

diff -puN arch/arm/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr arch/arm/Kconfig
--- a/arch/arm/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/arch/arm/Kconfig
@@ -1,7 +1,6 @@
 config ARM
 	bool
 	default y
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
diff -puN arch/arm64/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/arch/arm64/Kconfig
@@ -1,6 +1,5 @@
 config ARM64
 	def_bool y
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
diff -puN arch/mips/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr arch/mips/Kconfig
--- a/arch/mips/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/arch/mips/Kconfig
@@ -23,7 +23,6 @@ config MIPS
 	select HAVE_KRETPROBES
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_SYSCALL_TRACEPOINTS
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if CPU_SUPPORTS_HUGEPAGES && 64BIT
 	select RTC_LIB if !MACH_LOONGSON
diff -puN arch/powerpc/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/arch/powerpc/Kconfig
@@ -88,7 +88,6 @@ config PPC
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select BINFMT_ELF
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select OF
 	select OF_EARLY_FLATTREE
diff -puN arch/s390/include/asm/elf.h~mm-split-et_dyn-aslr-from-mmap-aslr arch/s390/include/asm/elf.h
--- a/arch/s390/include/asm/elf.h~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/arch/s390/include/asm/elf.h
@@ -163,9 +163,9 @@ extern unsigned int vdso_enabled;
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk. 64-bit
    tasks are aligned to 4GB. */
-#define ELF_ET_DYN_BASE (arch_mmap_rnd() + (is_32bit_task() ? \
+#define ELF_ET_DYN_BASE	(is_32bit_task() ? \
 				(STACK_TOP / 3 * 2) : \
-				(STACK_TOP / 3 * 2) & ~((1UL << 32) - 1)))
+				(STACK_TOP / 3 * 2) & ~((1UL << 32) - 1))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports. */
diff -puN arch/x86/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/arch/x86/Kconfig
@@ -87,7 +87,6 @@ config X86
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_ARCH_KASAN if X86_64 && SPARSEMEM_VMEMMAP
 	select HAVE_USER_RETURN_NOTIFIER
-	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select ARCH_HAS_ELF_RANDOMIZE
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
diff -puN fs/Kconfig.binfmt~mm-split-et_dyn-aslr-from-mmap-aslr fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/fs/Kconfig.binfmt
@@ -27,9 +27,6 @@ config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
 
-config ARCH_BINFMT_ELF_RANDOMIZE_PIE
-	bool
-
 config ARCH_BINFMT_ELF_STATE
 	bool
 
diff -puN fs/binfmt_elf.c~mm-split-et_dyn-aslr-from-mmap-aslr fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~mm-split-et_dyn-aslr-from-mmap-aslr
+++ a/fs/binfmt_elf.c
@@ -910,21 +910,8 @@ static int load_elf_binary(struct linux_
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
-			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
-#endif
+			load_bias = ELF_ET_DYN_BASE + arch_mmap_rnd() - vaddr;
+			load_bias = ELF_PAGESTART(load_bias);
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-fold-arch_randomize_brk-into-arch_has_elf_randomize.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

