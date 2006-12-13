From: akpm@osdl.org
Subject: - xtensa-remove-extra-header-files.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:51:40 -0800
Message-ID: <200612130651.kBD6pe6b030365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964964AbWLMGv5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:51:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: czankel@tensilica.com, chris@zankel.net, mm-commits@vger.kernel.org


The patch titled
     xtensa: remove extra header files
has been removed from the -mm tree.  Its filename was
     xtensa-remove-extra-header-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xtensa: remove extra header files
From: Chris Zankel <czankel@tensilica.com>

The Xtensa port contained many header files that were never needed.  This
rather lengthy patch removes all those files.  Unfortunately, there were
many dependencies that needed to be updated, so this patch touches quite a
few source files.

Signed-off-by: Chris Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/xtensa/Kconfig                                 |   21 
 arch/xtensa/Makefile                                |   25 
 arch/xtensa/boot/boot-elf/bootstrap.S               |    3 
 arch/xtensa/boot/boot-redboot/bootstrap.S           |   37 
 arch/xtensa/configs/iss_defconfig                   |    6 
 arch/xtensa/kernel/align.S                          |   42 
 arch/xtensa/kernel/coprocessor.S                    |    2 
 arch/xtensa/kernel/entry.S                          |   28 
 arch/xtensa/kernel/head.S                           |   53 
 arch/xtensa/kernel/pci-dma.c                        |   46 
 arch/xtensa/kernel/process.c                        |   37 
 arch/xtensa/kernel/ptrace.c                         |    2 
 arch/xtensa/kernel/setup.c                          |   41 
 arch/xtensa/kernel/signal.c                         |   16 
 arch/xtensa/kernel/syscalls.c                       |    4 
 arch/xtensa/kernel/traps.c                          |   56 
 arch/xtensa/kernel/vectors.S                        |   12 
 arch/xtensa/kernel/vmlinux.lds.S                    |   27 
 arch/xtensa/lib/checksum.S                          |    3 
 arch/xtensa/lib/memcopy.S                           |    2 
 arch/xtensa/lib/memset.S                            |    2 
 arch/xtensa/lib/strncpy_user.S                      |    2 
 arch/xtensa/lib/strnlen_user.S                      |    2 
 arch/xtensa/lib/usercopy.S                          |    2 
 arch/xtensa/mm/fault.c                              |   10 
 arch/xtensa/mm/init.c                               |    6 
 arch/xtensa/mm/misc.S                               |  265 --
 arch/xtensa/mm/tlb.c                                |  445 ---
 arch/xtensa/platform-iss/console.c                  |    8 
 arch/xtensa/platform-iss/network.c                  |    2 
 include/asm-xtensa/asmmacro.h                       |  153 +
 include/asm-xtensa/byteorder.h                      |    1 
 include/asm-xtensa/cache.h                          |   22 
 include/asm-xtensa/cacheasm.h                       |  177 +
 include/asm-xtensa/cacheflush.h                     |    2 
 include/asm-xtensa/checksum.h                       |    2 
 include/asm-xtensa/coprocessor.h                    |   13 
 include/asm-xtensa/dma.h                            |    5 
 include/asm-xtensa/elf.h                            |    9 
 include/asm-xtensa/fixmap.h                         |  252 -
 include/asm-xtensa/io.h                             |   64 
 include/asm-xtensa/irq.h                            |    8 
 include/asm-xtensa/mmu_context.h                    |  269 --
 include/asm-xtensa/page.h                           |   10 
 include/asm-xtensa/param.h                          |    2 
 include/asm-xtensa/pgtable.h                        |   41 
 include/asm-xtensa/platform-iss/hardware.h          |   10 
 include/asm-xtensa/platform-iss/simcall.h           |   62 
 include/asm-xtensa/processor.h                      |   24 
 include/asm-xtensa/ptrace.h                         |    2 
 include/asm-xtensa/regs.h                           |  138 +
 include/asm-xtensa/sembuf.h                         |    2 
 include/asm-xtensa/system.h                         |    2 
 include/asm-xtensa/timex.h                          |   17 
 include/asm-xtensa/tlbflush.h                       |   42 
 include/asm-xtensa/variant-fsf/core.h               |  359 ++
 include/asm-xtensa/variant-fsf/tie.h                |   22 
 include/asm-xtensa/xtensa/cacheasm.h                |  708 -----
 include/asm-xtensa/xtensa/cacheattrasm.h            |  432 ---
 include/asm-xtensa/xtensa/config-linux_be/core.h    | 1270 ----------
 include/asm-xtensa/xtensa/config-linux_be/defs.h    |  270 --
 include/asm-xtensa/xtensa/config-linux_be/specreg.h |   99 
 include/asm-xtensa/xtensa/config-linux_be/system.h  |  198 -
 include/asm-xtensa/xtensa/config-linux_be/tie.h     |  275 --
 include/asm-xtensa/xtensa/coreasm.h                 |  526 ----
 include/asm-xtensa/xtensa/corebits.h                |   77 
 include/asm-xtensa/xtensa/hal.h                     |  822 ------
 include/asm-xtensa/xtensa/simcall.h                 |  130 -
 include/asm-xtensa/xtensa/xt2000-uart.h             |  155 -
 include/asm-xtensa/xtensa/xt2000.h                  |  408 ---
 include/asm-xtensa/xtensa/xtboard.h                 |  120 
 71 files changed, 1362 insertions(+), 7045 deletions(-)

diff -puN arch/xtensa/Kconfig~xtensa-remove-extra-header-files arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~xtensa-remove-extra-header-files
+++ a/arch/xtensa/Kconfig
@@ -48,25 +48,10 @@ menu "Processor type and features"
 
 choice
 	prompt "Xtensa Processor Configuration"
-	default XTENSA_CPU_LINUX_BE
+	default XTENSA_VARIANT_FSF
 
-config XTENSA_CPU_LINUX_BE
-	bool "linux_be"
-	---help---
-	  The linux_be processor configuration is the baseline Xtensa
-	  configurations included in this kernel and also used by
-	  binutils, gcc, and gdb. It contains no TIE, no coprocessors,
-	  and the following configuration options:
-
-	  Code Density Option                2 Misc Special Registers
-	  NSA/NSAU Instructions              128-bit Data Bus Width
-	  Processor ID                       8K, 2-way I and D Caches
-	  Zero-Overhead Loops                2 Inst Address Break Registers
-	  Big Endian                         2 Data Address Break Registers
-	  64 General-Purpose Registers       JTAG Interface and Trace Port
-	  17 Interrupts                      MMU w/ TLBs and Autorefill
-	  3 Interrupt Levels                 8 Autorefill Ways (I/D TLBs)
-	  3 Timers                           Unaligned Exceptions
+config XTENSA_VARIANT_FSF
+	bool "fsf"
 endchoice
 
 config MMU
diff -puN arch/xtensa/Makefile~xtensa-remove-extra-header-files arch/xtensa/Makefile
--- a/arch/xtensa/Makefile~xtensa-remove-extra-header-files
+++ a/arch/xtensa/Makefile
@@ -11,13 +11,13 @@
 # this architecture
 
 # Core configuration.
-# (Use CPU=<xtensa_config> to use another default compiler.)
+# (Use VAR=<xtensa_config> to use another default compiler.)
 
-cpu-$(CONFIG_XTENSA_CPU_LINUX_BE)	:= linux_be
-cpu-$(CONFIG_XTENSA_CPU_LINUX_CUSTOM)	:= linux_custom
+variant-$(CONFIG_XTENSA_VARIANT_FSF)		:= fsf
+variant-$(CONFIG_XTENSA_VARIANT_LINUX_CUSTOM)	:= custom
 
-CPU = $(cpu-y)
-export CPU
+VARIANT = $(variant-y)
+export VARIANT
 
 # Platform configuration
 
@@ -27,8 +27,6 @@ platform-$(CONFIG_XTENSA_PLATFORM_ISS)		
 PLATFORM = $(platform-y)
 export PLATFORM
 
-CPPFLAGS	+= $(if $(KBUILD_SRC),-I$(srctree)/include/asm-xtensa/)
-CPPFLAGS	+= -Iinclude/asm
 CFLAGS		+= -pipe -mlongcalls
 
 KBUILD_DEFCONFIG := iss_defconfig
@@ -41,12 +39,12 @@ core-$(CONFIG_EMBEDDED_RAMDISK)	+= arch/
 
 # Test for cross compiling
 
-ifneq ($(CPU),)
+ifneq ($(VARIANT),)
   COMPILE_ARCH = $(shell uname -m)
 
   ifneq ($(COMPILE_ARCH), xtensa)
     ifndef CROSS_COMPILE
-      CROSS_COMPILE = xtensa_$(CPU)-
+      CROSS_COMPILE = xtensa_$(VARIANT)-
     endif
   endif
 endif
@@ -68,14 +66,13 @@ archinc		:= include/asm-xtensa
 
 archprepare: $(archinc)/.platform
 
-# Update machine cpu and platform symlinks if something which affects
+# Update processor variant and platform symlinks if something which affects
 # them changed.
 
 $(archinc)/.platform: $(wildcard include/config/arch/*.h) include/config/auto.conf
-	@echo '  SYMLINK $(archinc)/xtensa/config -> $(archinc)/xtensa/config-$(CPU)'
+	@echo '  SYMLINK $(archinc)/variant -> $(archinc)/variant-$(VARIANT)'
 	$(Q)mkdir -p $(archinc)
-	$(Q)mkdir -p $(archinc)/xtensa
-	$(Q)ln -fsn $(srctree)/$(archinc)/xtensa/config-$(CPU) $(archinc)/xtensa/config
+	$(Q)ln -fsn $(srctree)/$(archinc)/variant-$(VARIANT) $(archinc)/variant
 	@echo '  SYMLINK $(archinc)/platform -> $(archinc)/platform-$(PLATFORM)'
 	$(Q)ln -fsn $(srctree)/$(archinc)/platform-$(PLATFORM) $(archinc)/platform
 	@touch $@
@@ -89,7 +86,7 @@ zImage zImage.initrd: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $@
 
 CLEAN_FILES	+= arch/xtensa/vmlinux.lds                      \
-		   $(archinc)/platform $(archinc)/xtensa/config \
+		   $(archinc)/platform $(archinc)/variant	\
 		   $(archinc)/.platform
 
 define archhelp
diff -puN arch/xtensa/boot/boot-elf/bootstrap.S~xtensa-remove-extra-header-files arch/xtensa/boot/boot-elf/bootstrap.S
--- a/arch/xtensa/boot/boot-elf/bootstrap.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/boot/boot-elf/bootstrap.S
@@ -1,7 +1,4 @@
 
-#include <xtensa/config/specreg.h>
-#include <xtensa/config/core.h>
-
 #include <asm/bootparam.h>
 
 
diff -puN arch/xtensa/boot/boot-redboot/bootstrap.S~xtensa-remove-extra-header-files arch/xtensa/boot/boot-redboot/bootstrap.S
--- a/arch/xtensa/boot/boot-redboot/bootstrap.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/boot/boot-redboot/bootstrap.S
@@ -1,9 +1,7 @@
-
-#define _ASMLANGUAGE
-#include <xtensa/config/specreg.h>
-#include <xtensa/config/core.h>
-#include <xtensa/cacheasm.h>
-
+#include <asm/variant/core.h>
+#include <asm/regs.h>
+#include <asm/asmmacro.h>
+#include <asm/cacheasm.h>
 	/*
 	 * RB-Data: RedBoot data/bss
 	 * P:	    Boot-Parameters
@@ -77,8 +75,14 @@ _start:
 	/* Note: The assembler cannot relax "addi a0, a0, ..." to an
 	   l32r, so we load to a4 first. */
 
-	addi	a4, a0, __start - __start_a0
-	mov	a0, a4
+	# addi	a4, a0, __start - __start_a0
+	# mov	a0, a4
+
+	movi	a4, __start
+	movi	a5, __start_a0
+	add	a4, a0, a4
+	sub	a0, a4, a5
+
 	movi	a4, __start
 	movi	a5, __reloc_end
 
@@ -106,9 +110,13 @@ _start:
 	/* We have to flush and invalidate the caches here before we jump. */
 
 #if XCHAL_DCACHE_IS_WRITEBACK
-	dcache_writeback_all  a5, a6
+
+	___flush_dcache_all a5 a6
+
 #endif
-	icache_invalidate_all a5, a6
+
+	___invalidate_icache_all a5 a6
+	isync
 
 	movi	a11, _reloc
 	jx	a11
@@ -209,9 +217,14 @@ _reloc:
 	/* jump to the kernel */
 2:
 #if XCHAL_DCACHE_IS_WRITEBACK
-	dcache_writeback_all a5, a6
+
+	___flush_dcache_all a5 a6
+
 #endif
-	icache_invalidate_all a5, a6
+
+	___invalidate_icache_all a5 a6
+
+	isync
 
 	movi	a5, __start
 	movi	a3, boot_initrd_start
diff -puN arch/xtensa/configs/iss_defconfig~xtensa-remove-extra-header-files arch/xtensa/configs/iss_defconfig
--- a/arch/xtensa/configs/iss_defconfig~xtensa-remove-extra-header-files
+++ a/arch/xtensa/configs/iss_defconfig
@@ -53,11 +53,7 @@ CONFIG_CC_ALIGN_JUMPS=0
 #
 # Processor type and features
 #
-CONFIG_XTENSA_ARCH_LINUX_BE=y
-# CONFIG_XTENSA_ARCH_LINUX_LE is not set
-# CONFIG_XTENSA_ARCH_LINUX_TEST is not set
-# CONFIG_XTENSA_ARCH_S5 is not set
-# CONFIG_XTENSA_CUSTOM is not set
+CONFIG_XTENSA_VARIANT_FSF=y
 CONFIG_MMU=y
 # CONFIG_XTENSA_UNALIGNED_USER is not set
 # CONFIG_PREEMPT is not set
diff -puN arch/xtensa/kernel/align.S~xtensa-remove-extra-header-files arch/xtensa/kernel/align.S
--- a/arch/xtensa/kernel/align.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/align.S
@@ -16,14 +16,9 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/ptrace.h>
-#include <asm/ptrace.h>
 #include <asm/current.h>
 #include <asm/asm-offsets.h>
-#include <asm/pgtable.h>
 #include <asm/processor.h>
-#include <asm/page.h>
-#include <asm/thread_info.h>
 
 #if XCHAL_UNALIGNED_LOAD_EXCEPTION || XCHAL_UNALIGNED_STORE_EXCEPTION
 
@@ -216,7 +211,7 @@ ENTRY(fast_unaligned)
 
 	extui	a5, a4, INSN_OP0, 4	# get insn.op0 nibble
 
-#if XCHAL_HAVE_NARROW
+#if XCHAL_HAVE_DENSITY
 	_beqi	a5, OP0_L32I_N, .Lload	# L32I.N, jump
 	addi	a6, a5, -OP0_S32I_N
 	_beqz	a6, .Lstore		# S32I.N, do a store
@@ -251,7 +246,7 @@ ENTRY(fast_unaligned)
 #endif
 	__src_b	a3, a5, a6		# a3 has the data word
 
-#if XCHAL_HAVE_NARROW
+#if XCHAL_HAVE_DENSITY
 	addi	a7, a7, 2		# increment PC (assume 16-bit insn)
 
 	extui	a5, a4, INSN_OP0, 4
@@ -279,14 +274,14 @@ ENTRY(fast_unaligned)
 
 1:
 
-#if XCHAL_HAVE_LOOP
-	rsr	a3, LEND		# check if we reached LEND
-	bne	a7, a3, 1f
-	rsr	a3, LCOUNT		# and LCOUNT != 0
-	beqz	a3, 1f
-	addi	a3, a3, -1		# decrement LCOUNT and set
+#if XCHAL_HAVE_LOOPS
+	rsr	a5, LEND		# check if we reached LEND
+	bne	a7, a5, 1f
+	rsr	a5, LCOUNT		# and LCOUNT != 0
+	beqz	a5, 1f
+	addi	a5, a5, -1		# decrement LCOUNT and set
 	rsr	a7, LBEG		# set PC to LBEGIN
-	wsr	a3, LCOUNT
+	wsr	a5, LCOUNT
 #endif
 
 1:	wsr	a7, EPC_1		# skip load instruction
@@ -336,7 +331,7 @@ ENTRY(fast_unaligned)
 
 	movi	a6, 0			# mask: ffffffff:00000000
 
-#if XCHAL_HAVE_NARROW
+#if XCHAL_HAVE_DENSITY
 	addi	a7, a7, 2		# incr. PC,assume 16-bit instruction
 
 	extui	a5, a4, INSN_OP0, 4	# extract OP0
@@ -359,14 +354,14 @@ ENTRY(fast_unaligned)
 	/* Get memory address */
 
 1:
-#if XCHAL_HAVE_LOOP
-	rsr	a3, LEND		# check if we reached LEND
-	bne	a7, a3, 1f
-	rsr	a3, LCOUNT		# and LCOUNT != 0
-	beqz	a3, 1f
-	addi	a3, a3, -1		# decrement LCOUNT and set
+#if XCHAL_HAVE_LOOPS
+	rsr	a4, LEND		# check if we reached LEND
+	bne	a7, a4, 1f
+	rsr	a4, LCOUNT		# and LCOUNT != 0
+	beqz	a4, 1f
+	addi	a4, a4, -1		# decrement LCOUNT and set
 	rsr	a7, LBEG		# set PC to LBEGIN
-	wsr	a3, LCOUNT
+	wsr	a4, LCOUNT
 #endif
 
 1:	wsr	a7, EPC_1		# skip store instruction
@@ -416,6 +411,7 @@ ENTRY(fast_unaligned)
 
 	/* Restore working register */
 
+	l32i	a8, a2, PT_AREG8
 	l32i	a7, a2, PT_AREG7
 	l32i	a6, a2, PT_AREG6
 	l32i	a5, a2, PT_AREG5
@@ -446,7 +442,7 @@ ENTRY(fast_unaligned)
 	mov	a1, a2
 
 	rsr	a0, PS
-        bbsi.l  a2, PS_UM_SHIFT, 1f     # jump if user mode
+        bbsi.l  a2, PS_UM_BIT, 1f     # jump if user mode
 
 	movi	a0, _kernel_exception
 	jx	a0
diff -puN arch/xtensa/kernel/coprocessor.S~xtensa-remove-extra-header-files arch/xtensa/kernel/coprocessor.S
--- a/arch/xtensa/kernel/coprocessor.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/coprocessor.S
@@ -90,7 +90,6 @@ ENTRY(enable_coprocessor)
 	rsync
 	retw
 
-#endif
 
 ENTRY(save_coprocessor_extra)
 	entry	sp, 16
@@ -197,4 +196,5 @@ _xtensa_reginfo_tables:
 	XCHAL_CP7_SA_CONTENTS_LIBDB
 	.word	0xFC000000	/* invalid register number,marks end of table*/
 _xtensa_reginfo_table_end:
+#endif
 
diff -puN arch/xtensa/kernel/entry.S~xtensa-remove-extra-header-files arch/xtensa/kernel/entry.S
--- a/arch/xtensa/kernel/entry.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/entry.S
@@ -24,7 +24,7 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/signal.h>
-#include <xtensa/coreasm.h>
+#include <asm/tlbflush.h>
 
 /* Unimplemented features. */
 
@@ -364,7 +364,7 @@ common_exception:
 	movi	a2, 1
 	extui	a3, a3, 0, 1		# a3 = PS.INTLEVEL[0]
 	moveqz	a3, a2, a0		# a3 = 1 iff interrupt exception
-	movi	a2, PS_WOE_MASK
+	movi	a2, 1 << PS_WOE_BIT
 	or	a3, a3, a2
 	rsr	a0, EXCCAUSE
 	xsr	a3, PS
@@ -399,7 +399,7 @@ common_exception_return:
 	/* Jump if we are returning from kernel exceptions. */
 
 1:	l32i	a3, a1, PT_PS
-	_bbsi.l	a3, PS_UM_SHIFT, 2f
+	_bbsi.l	a3, PS_UM_BIT, 2f
 	j	kernel_exception_exit
 
 	/* Specific to a user exception exit:
@@ -422,7 +422,7 @@ common_exception_return:
 	 *       (Hint: There is only one user exception frame on stack)
 	 */
 
-	movi	a3, PS_WOE_MASK
+	movi	a3, 1 << PS_WOE_BIT
 
 	_bbsi.l	a4, TIF_NEED_RESCHED, 3f
 	_bbci.l	a4, TIF_SIGPENDING, 4f
@@ -694,7 +694,7 @@ common_exception_exit:
 ENTRY(debug_exception)
 
 	rsr	a0, EPS + XCHAL_DEBUGLEVEL
-	bbsi.l	a0, PS_EXCM_SHIFT, 1f	# exception mode
+	bbsi.l	a0, PS_EXCM_BIT, 1f	# exception mode
 
 	/* Set EPC_1 and EXCCAUSE */
 
@@ -707,7 +707,7 @@ ENTRY(debug_exception)
 
 	/* Restore PS to the value before the debug exc but with PS.EXCM set.*/
 
-	movi	a2, 1 << PS_EXCM_SHIFT
+	movi	a2, 1 << PS_EXCM_BIT
 	or	a2, a0, a2
 	movi	a0, debug_exception	# restore a3, debug jump vector
 	wsr	a2, PS
@@ -715,7 +715,7 @@ ENTRY(debug_exception)
 
 	/* Switch to kernel/user stack, restore jump vector, and save a0 */
 
-	bbsi.l	a2, PS_UM_SHIFT, 2f	# jump if user mode
+	bbsi.l	a2, PS_UM_BIT, 2f	# jump if user mode
 
 	addi	a2, a1, -16-PT_SIZE	# assume kernel stack
 	s32i	a0, a2, PT_AREG0
@@ -778,7 +778,7 @@ ENTRY(unrecoverable_exception)
 	wsr	a1, WINDOWBASE
 	rsync
 
-	movi	a1, PS_WOE_MASK | 1
+	movi	a1, (1 << PS_WOE_BIT) | 1
 	wsr	a1, PS
 	rsync
 
@@ -1491,7 +1491,7 @@ ENTRY(_spill_registers)
 	 */
 
 	rsr	a0, PS
-	_bbci.l	a0, PS_UM_SHIFT, 1f
+	_bbci.l	a0, PS_UM_BIT, 1f
 
  	/* User space: Setup a dummy frame and kill application.
 	 * Note: We assume EXC_TABLE_KSTK contains a valid stack pointer.
@@ -1510,7 +1510,7 @@ ENTRY(_spill_registers)
 	l32i	a1, a3, EXC_TABLE_KSTK
 	wsr	a3, EXCSAVE_1
 
-	movi	a4, PS_WOE_MASK | 1
+	movi	a4, (1 << PS_WOE_BIT) | 1
 	wsr	a4, PS
 	rsync
 
@@ -1612,7 +1612,7 @@ ENTRY(fast_second_level_miss)
 	rsr	a1, PTEVADDR
 	srli	a1, a1, PAGE_SHIFT
 	slli	a1, a1, PAGE_SHIFT	# ptevaddr & PAGE_MASK
-	addi	a1, a1, DTLB_WAY_PGTABLE	# ... + way_number
+	addi	a1, a1, DTLB_WAY_PGD	# ... + way_number
 
 	wdtlb	a0, a1
 	dsync
@@ -1654,7 +1654,7 @@ ENTRY(fast_second_level_miss)
 	mov	a1, a2
 
 	rsr	a2, PS
-	bbsi.l	a2, PS_UM_SHIFT, 1f
+	bbsi.l	a2, PS_UM_BIT, 1f
 	j	_kernel_exception
 1:	j	_user_exception
 
@@ -1753,7 +1753,7 @@ ENTRY(fast_store_prohibited)
 	mov	a1, a2
 
 	rsr	a2, PS
-	bbsi.l	a2, PS_UM_SHIFT, 1f
+	bbsi.l	a2, PS_UM_BIT, 1f
 	j	_kernel_exception
 1:	j	_user_exception
 
@@ -1924,7 +1924,7 @@ ENTRY(_switch_to)
 
 	/* Disable ints while we manipulate the stack pointer; spill regs. */
 
-	movi	a5, PS_EXCM_MASK | LOCKLEVEL
+	movi	a5, (1 << PS_EXCM_BIT) | LOCKLEVEL
 	xsr	a5, PS
 	rsr	a3, EXCSAVE_1
 	rsync
diff -puN arch/xtensa/kernel/head.S~xtensa-remove-extra-header-files arch/xtensa/kernel/head.S
--- a/arch/xtensa/kernel/head.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/head.S
@@ -15,9 +15,9 @@
  * Kevin Chea
  */
 
-#include <xtensa/cacheasm.h>
 #include <asm/processor.h>
 #include <asm/page.h>
+#include <asm/cacheasm.h>
 
 /*
  * This module contains the entry code for kernel images. It performs the
@@ -32,13 +32,6 @@
  *
  */
 
-	.macro	iterate	from, to , cmd
-		.ifeq	((\to - \from) & ~0xfff)
-			\cmd	\from
-			iterate "(\from+1)", \to, \cmd
-		.endif
-	.endm
-
 /*
  *  _start
  *
@@ -64,7 +57,7 @@ _startup:
 
 	/* Disable interrupts and exceptions. */
 
-	movi	a0, XCHAL_PS_EXCM_MASK
+	movi	a0, LOCKLEVEL
 	wsr	a0, PS
 
 	/* Preserve the pointer to the boot parameter list in EXCSAVE_1 */
@@ -91,11 +84,11 @@ _startup:
 	movi	a1, 15
 	wsr	a0, ICOUNTLEVEL
 
-	.macro reset_dbreak num
-	wsr	a0, DBREAKC + \num
-	.endm
-
-        iterate 0, XCHAL_NUM_IBREAK-1, reset_dbreak
+	.set	_index, 0
+	.rept	XCHAL_NUM_DBREAK - 1
+	wsr	a0, DBREAKC + _index
+	.set	_index, _index + 1
+	.endr
 #endif
 
 	/* Clear CCOUNT (not really necessary, but nice) */
@@ -110,10 +103,11 @@ _startup:
 
 	/* Disable all timers. */
 
-	.macro	reset_timer	num
-	wsr	a0, CCOMPARE_0 + \num
-	.endm
-	iterate	0, XCHAL_NUM_TIMERS-1, reset_timer
+	.set	_index, 0
+	.rept	XCHAL_NUM_TIMERS - 1
+	wsr	a0, CCOMPARE + _index
+	.set	_index, _index + 1
+	.endr
 
 	/* Interrupt initialization. */
 
@@ -139,12 +133,21 @@ _startup:
 	rsync
 
 	/*  Initialize the caches.
-	 *  Does not include flushing writeback d-cache.
-	 *  a6, a7 are just working registers (clobbered).
+	 *  a2, a3 are just working registers (clobbered).
 	 */
 
-	icache_reset  a2, a3
-	dcache_reset  a2, a3
+#if XCHAL_DCACHE_LINE_LOCKABLE
+	___unlock_dcache_all a2 a3
+#endif
+
+#if XCHAL_ICACHE_LINE_LOCKABLE
+	___unlock_icache_all a2 a3
+#endif
+
+	___invalidate_dcache_all a2 a3
+	___invalidate_icache_all a2 a3
+
+	isync
 
 	/* Unpack data sections
 	 *
@@ -181,9 +184,9 @@ _startup:
 	movi	a2, _bss_start	# start of BSS
 	movi	a3, _bss_end	# end of BSS
 
-1:	addi	a2, a2, 4
+	__loopt	a2, a3, a4, 2
 	s32i	a0, a2, 0
-	blt	a2, a3, 1b
+	__endla	a2, a4, 4
 
 #if XCHAL_DCACHE_IS_WRITEBACK
 
@@ -191,7 +194,7 @@ _startup:
 	 * instructions/data are available.
 	 */
 
-	dcache_writeback_all	a2, a3
+	___flush_dcache_all a2 a3
 #endif
 
 	/* Setup stack and enable window exceptions (keep irqs disabled) */
diff -puN arch/xtensa/kernel/pci-dma.c~xtensa-remove-extra-header-files arch/xtensa/kernel/pci-dma.c
--- a/arch/xtensa/kernel/pci-dma.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/pci-dma.c
@@ -1,5 +1,5 @@
 /*
- * arch/xtensa/kernel/pci-dma.c
+ * arch/xtensa/pci-dma.c
  *
  * DMA coherent memory allocation.
  *
@@ -29,28 +29,48 @@
  */
 
 void *
-dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp)
+dma_alloc_coherent(struct device *dev,size_t size,dma_addr_t *handle,gfp_t flag)
 {
-	void *ret;
+	unsigned long ret;
+	unsigned long uncached = 0;
 
 	/* ignore region speicifiers */
-	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM);
 
-	if (dev == NULL || (*dev->dma_mask < 0xffffffff))
-		gfp |= GFP_DMA;
-	ret = (void *)__get_free_pages(gfp, get_order(size));
-
-	if (ret != NULL) {
-		memset(ret, 0, size);
-		*handle = virt_to_bus(ret);
+	flag &= ~(__GFP_DMA | __GFP_HIGHMEM);
+
+	if (dev == NULL || (dev->coherent_dma_mask < 0xffffffff))
+		flag |= GFP_DMA;
+	ret = (unsigned long)__get_free_pages(flag, get_order(size));
+
+	if (ret == 0)
+		return NULL;
+
+	/* We currently don't support coherent memory outside KSEG */
+
+	if (ret < XCHAL_KSEG_CACHED_VADDR
+	    || ret >= XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_SIZE)
+		BUG();
+
+
+	if (ret != 0) {
+		memset((void*) ret, 0, size);
+		uncached = ret+XCHAL_KSEG_BYPASS_VADDR-XCHAL_KSEG_CACHED_VADDR;
+		*handle = virt_to_bus((void*)ret);
+		__flush_invalidate_dcache_range(ret, size);
 	}
-	return (void*) BYPASS_ADDR((unsigned long)ret);
+
+	return (void*)uncached;
 }
 
 void dma_free_coherent(struct device *hwdev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle)
 {
-	free_pages(CACHED_ADDR((unsigned long)vaddr), get_order(size));
+	long addr=(long)vaddr+XCHAL_KSEG_CACHED_VADDR-XCHAL_KSEG_BYPASS_VADDR;
+
+	if (addr < 0 || addr >= XCHAL_KSEG_SIZE)
+		BUG();
+
+	free_pages(addr, get_order(size));
 }
 
 
diff -puN arch/xtensa/kernel/process.c~xtensa-remove-extra-header-files arch/xtensa/kernel/process.c
--- a/arch/xtensa/kernel/process.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/process.c
@@ -1,4 +1,3 @@
-// TODO	verify coprocessor handling
 /*
  * arch/xtensa/kernel/process.c
  *
@@ -43,7 +42,7 @@
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/asm-offsets.h>
-#include <asm/coprocessor.h>
+#include <asm/regs.h>
 
 extern void ret_from_fork(void);
 
@@ -67,25 +66,6 @@ void (*pm_power_off)(void) = NULL;
 EXPORT_SYMBOL(pm_power_off);
 
 
-#if XCHAL_CP_NUM > 0
-
-/*
- * Coprocessor ownership.
- */
-
-coprocessor_info_t coprocessor_info[] = {
-	{ 0, XTENSA_CPE_CP0_OFFSET },
-	{ 0, XTENSA_CPE_CP1_OFFSET },
-	{ 0, XTENSA_CPE_CP2_OFFSET },
-	{ 0, XTENSA_CPE_CP3_OFFSET },
-	{ 0, XTENSA_CPE_CP4_OFFSET },
-	{ 0, XTENSA_CPE_CP5_OFFSET },
-	{ 0, XTENSA_CPE_CP6_OFFSET },
-	{ 0, XTENSA_CPE_CP7_OFFSET },
-};
-
-#endif
-
 /*
  * Powermanagement idle function, if any is provided by the platform.
  */
@@ -110,12 +90,10 @@ void cpu_idle(void)
 
 void exit_thread(void)
 {
-	release_coprocessors(current);	/* Empty macro if no CPs are defined */
 }
 
 void flush_thread(void)
 {
-	release_coprocessors(current);	/* Empty macro if no CPs are defined */
 }
 
 /*
@@ -275,7 +253,7 @@ void do_copy_regs (xtensa_gregset_t *elf
 	 */
 
 	elfregs->pc		= regs->pc;
-	elfregs->ps		= (regs->ps & ~XCHAL_PS_EXCM_MASK);
+	elfregs->ps		= (regs->ps & ~(1 << PS_EXCM_BIT));
 	elfregs->exccause	= regs->exccause;
 	elfregs->excvaddr	= regs->excvaddr;
 	elfregs->windowbase	= regs->windowbase;
@@ -325,7 +303,7 @@ void do_restore_regs (xtensa_gregset_t *
 	 */
 
 	regs->pc		= elfregs->pc;
-	regs->ps		= (elfregs->ps | XCHAL_PS_EXCM_MASK);
+	regs->ps		= (elfregs->ps | (1 << PS_EXCM_BIT));
 	regs->exccause		= elfregs->exccause;
 	regs->excvaddr		= elfregs->excvaddr;
 	regs->windowbase	= elfregs->windowbase;
@@ -459,16 +437,7 @@ int  do_restore_fpregs (elf_fpregset_t *
 int
 dump_task_fpu(struct pt_regs *regs, struct task_struct *task, elf_fpregset_t *r)
 {
-/* see asm/coprocessor.h for this magic number 16 */
-#if XTENSA_CP_EXTRA_SIZE > 16
-	do_save_fpregs (r, regs, task);
-
-	/*  For now, bit 16 means some extra state may be present:  */
-// FIXME!! need to track to return more accurate mask
-	return 0x10000 | XCHAL_CP_MASK;
-#else
 	return 0;	/* no coprocessors active on this processor */
-#endif
 }
 
 /*
diff -puN arch/xtensa/kernel/ptrace.c~xtensa-remove-extra-header-files arch/xtensa/kernel/ptrace.c
--- a/arch/xtensa/kernel/ptrace.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/ptrace.c
@@ -96,7 +96,7 @@ long arch_ptrace(struct task_struct *chi
 			/* Note:  PS.EXCM is not set while user task is running;
 			 * its being set in regs is for exception handling
 			 * convenience.  */
-			tmp = (regs->ps & ~XCHAL_PS_EXCM_MASK);
+			tmp = (regs->ps & ~(1 << PS_EXCM_BIT));
 			break;
 		case REG_WB:
 			tmp = regs->windowbase;
diff -puN arch/xtensa/kernel/setup.c~xtensa-remove-extra-header-files arch/xtensa/kernel/setup.c
--- a/arch/xtensa/kernel/setup.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/setup.c
@@ -42,8 +42,6 @@
 #include <asm/page.h>
 #include <asm/setup.h>
 
-#include <xtensa/config/system.h>
-
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
 struct screen_info screen_info = { 0, 24, 0, 0, 0, 80, 0, 0, 0, 24, 1, 16};
 #endif
@@ -336,7 +334,7 @@ c_show(struct seq_file *f, void *slot)
 	/* high-level stuff */
 	seq_printf(f,"processor\t: 0\n"
 		     "vendor_id\t: Tensilica\n"
-		     "model\t\t: Xtensa " XCHAL_HW_RELEASE_NAME "\n"
+		     "model\t\t: Xtensa " XCHAL_HW_VERSION_NAME "\n"
 		     "core ID\t\t: " XCHAL_CORE_ID "\n"
 		     "build ID\t: 0x%x\n"
 		     "byte order\t: %s\n"
@@ -420,25 +418,6 @@ c_show(struct seq_file *f, void *slot)
 		     XCHAL_NUM_TIMERS,
 		     XCHAL_DEBUGLEVEL);
 
-	/* Coprocessors */
-#if XCHAL_HAVE_CP
-	seq_printf(f, "coprocessors\t: %d\n", XCHAL_CP_NUM);
-#else
-	seq_printf(f, "coprocessors\t: none\n");
-#endif
-
-	/* {I,D}{RAM,ROM} and XLMI */
-	seq_printf(f,"inst ROMs\t: %d\n"
-		     "inst RAMs\t: %d\n"
-		     "data ROMs\t: %d\n"
-		     "data RAMs\t: %d\n"
-		     "XLMI ports\t: %d\n",
-		     XCHAL_NUM_IROM,
-		     XCHAL_NUM_IRAM,
-		     XCHAL_NUM_DROM,
-		     XCHAL_NUM_DRAM,
-		     XCHAL_NUM_XLMI);
-
 	/* Cache */
 	seq_printf(f,"icache line size: %d\n"
 		     "icache ways\t: %d\n"
@@ -466,24 +445,6 @@ c_show(struct seq_file *f, void *slot)
 		     XCHAL_DCACHE_WAYS,
 		     XCHAL_DCACHE_SIZE);
 
-	/* MMU */
-	seq_printf(f,"ASID bits\t: %d\n"
-		     "ASID invalid\t: %d\n"
-		     "ASID kernel\t: %d\n"
-		     "rings\t\t: %d\n"
-		     "itlb ways\t: %d\n"
-		     "itlb AR ways\t: %d\n"
-		     "dtlb ways\t: %d\n"
-		     "dtlb AR ways\t: %d\n",
-		     XCHAL_MMU_ASID_BITS,
-		     XCHAL_MMU_ASID_INVALID,
-		     XCHAL_MMU_ASID_KERNEL,
-		     XCHAL_MMU_RINGS,
-		     XCHAL_ITLB_WAYS,
-		     XCHAL_ITLB_ARF_WAYS,
-		     XCHAL_DTLB_WAYS,
-		     XCHAL_DTLB_ARF_WAYS);
-
 	return 0;
 }
 
diff -puN arch/xtensa/kernel/signal.c~xtensa-remove-extra-header-files arch/xtensa/kernel/signal.c
--- a/arch/xtensa/kernel/signal.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/signal.c
@@ -12,8 +12,8 @@
  *
  */
 
-#include <xtensa/config/core.h>
-#include <xtensa/hal.h>
+#include <asm/variant/core.h>
+#include <asm/coprocessor.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
@@ -216,8 +216,8 @@ restore_sigcontext(struct pt_regs *regs,
 	 * handler, or the user mode value doesn't matter (e.g. PS.OWB).
 	 */
 	err |= __get_user(ps, &sc->sc_ps);
-	regs->ps = (regs->ps & ~XCHAL_PS_CALLINC_MASK)
-		| (ps & XCHAL_PS_CALLINC_MASK);
+	regs->ps = (regs->ps & ~PS_CALLINC_MASK)
+		| (ps & PS_CALLINC_MASK);
 
 	/* Additional corruption checks */
 
@@ -280,7 +280,7 @@ flush_my_cpstate(struct task_struct *tsk
 static int
 save_cpextra (struct _cpstate *buf)
 {
-#if (XCHAL_EXTRA_SA_SIZE == 0) && (XCHAL_CP_NUM == 0)
+#if XCHAL_CP_NUM == 0
 	return 0;
 #else
 
@@ -497,8 +497,10 @@ gen_return_code(unsigned char *codemem, 
 
 	/* Flush generated code out of the data cache */
 
-	if (err == 0)
-		__flush_invalidate_cache_range((unsigned long)codemem, 6UL);
+	if (err == 0) {
+		__invalidate_icache_range((unsigned long)codemem, 6UL);
+		__flush_invalidate_dcache_range((unsigned long)codemem, 6UL);
+	}
 
 	return err;
 }
diff -puN arch/xtensa/kernel/syscalls.c~xtensa-remove-extra-header-files arch/xtensa/kernel/syscalls.c
--- a/arch/xtensa/kernel/syscalls.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/syscalls.c
@@ -175,8 +175,8 @@ void system_call (struct pt_regs *regs)
 	 * interrupts in the first place:
 	 */
 	local_save_flags (ps);
-	local_irq_restore((ps & ~XCHAL_PS_INTLEVEL_MASK) |
-			  (regs->ps & XCHAL_PS_INTLEVEL_MASK) );
+	local_irq_restore((ps & ~PS_INTLEVEL_MASK) |
+			  (regs->ps & PS_INTLEVEL_MASK) );
 
 	if (syscallnr > __NR_Linux_syscalls) {
 		regs->areg[2] = -ENOSYS;
diff -puN arch/xtensa/kernel/traps.c~xtensa-remove-extra-header-files arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/traps.c
@@ -75,7 +75,7 @@ extern void system_call (struct pt_regs*
 #define USER		0x02
 
 #define COPROCESSOR(x)							\
-{ XCHAL_EXCCAUSE_COPROCESSOR ## x ## _DISABLED, USER, fast_coprocessor }
+{ EXCCAUSE_COPROCESSOR ## x ## _DISABLED, USER, fast_coprocessor }
 
 typedef struct {
 	int cause;
@@ -85,38 +85,38 @@ typedef struct {
 
 dispatch_init_table_t __init dispatch_init_table[] = {
 
-{ XCHAL_EXCCAUSE_ILLEGAL_INSTRUCTION,	0,	   do_illegal_instruction},
-{ XCHAL_EXCCAUSE_SYSTEM_CALL,		KRNL,	   fast_syscall_kernel },
-{ XCHAL_EXCCAUSE_SYSTEM_CALL,		USER,	   fast_syscall_user },
-{ XCHAL_EXCCAUSE_SYSTEM_CALL,		0,	   system_call },
-/* XCHAL_EXCCAUSE_INSTRUCTION_FETCH unhandled */
-/* XCHAL_EXCCAUSE_LOAD_STORE_ERROR unhandled*/
-{ XCHAL_EXCCAUSE_LEVEL1_INTERRUPT,	0,	   do_interrupt },
-{ XCHAL_EXCCAUSE_ALLOCA,		USER|KRNL, fast_alloca },
-/* XCHAL_EXCCAUSE_INTEGER_DIVIDE_BY_ZERO unhandled */
-/* XCHAL_EXCCAUSE_PRIVILEGED unhandled */
+{ EXCCAUSE_ILLEGAL_INSTRUCTION,	0,	   do_illegal_instruction},
+{ EXCCAUSE_SYSTEM_CALL,		KRNL,	   fast_syscall_kernel },
+{ EXCCAUSE_SYSTEM_CALL,		USER,	   fast_syscall_user },
+{ EXCCAUSE_SYSTEM_CALL,		0,	   system_call },
+/* EXCCAUSE_INSTRUCTION_FETCH unhandled */
+/* EXCCAUSE_LOAD_STORE_ERROR unhandled*/
+{ EXCCAUSE_LEVEL1_INTERRUPT,	0,	   do_interrupt },
+{ EXCCAUSE_ALLOCA,		USER|KRNL, fast_alloca },
+/* EXCCAUSE_INTEGER_DIVIDE_BY_ZERO unhandled */
+/* EXCCAUSE_PRIVILEGED unhandled */
 #if XCHAL_UNALIGNED_LOAD_EXCEPTION || XCHAL_UNALIGNED_STORE_EXCEPTION
 #ifdef CONFIG_UNALIGNED_USER
-{ XCHAL_EXCCAUSE_UNALIGNED,		USER,	   fast_unaligned },
+{ EXCCAUSE_UNALIGNED,		USER,	   fast_unaligned },
 #else
-{ XCHAL_EXCCAUSE_UNALIGNED,		0,	   do_unaligned_user },
+{ EXCCAUSE_UNALIGNED,		0,	   do_unaligned_user },
 #endif
-{ XCHAL_EXCCAUSE_UNALIGNED,		KRNL,	   fast_unaligned },
+{ EXCCAUSE_UNALIGNED,		KRNL,	   fast_unaligned },
 #endif
-{ XCHAL_EXCCAUSE_ITLB_MISS,		0,	   do_page_fault },
-{ XCHAL_EXCCAUSE_ITLB_MISS,		USER|KRNL, fast_second_level_miss},
-{ XCHAL_EXCCAUSE_ITLB_MULTIHIT,		0,	   do_multihit },
-{ XCHAL_EXCCAUSE_ITLB_PRIVILEGE,	0,	   do_page_fault },
-/* XCHAL_EXCCAUSE_SIZE_RESTRICTION unhandled */
-{ XCHAL_EXCCAUSE_FETCH_CACHE_ATTRIBUTE,	0,	   do_page_fault },
-{ XCHAL_EXCCAUSE_DTLB_MISS,		USER|KRNL, fast_second_level_miss},
-{ XCHAL_EXCCAUSE_DTLB_MISS,		0,	   do_page_fault },
-{ XCHAL_EXCCAUSE_DTLB_MULTIHIT,		0,	   do_multihit },
-{ XCHAL_EXCCAUSE_DTLB_PRIVILEGE,	0,	   do_page_fault },
-/* XCHAL_EXCCAUSE_DTLB_SIZE_RESTRICTION unhandled */
-{ XCHAL_EXCCAUSE_STORE_CACHE_ATTRIBUTE,	USER|KRNL, fast_store_prohibited },
-{ XCHAL_EXCCAUSE_STORE_CACHE_ATTRIBUTE,	0,	   do_page_fault },
-{ XCHAL_EXCCAUSE_LOAD_CACHE_ATTRIBUTE,	0,	   do_page_fault },
+{ EXCCAUSE_ITLB_MISS,		0,	   do_page_fault },
+{ EXCCAUSE_ITLB_MISS,		USER|KRNL, fast_second_level_miss},
+{ EXCCAUSE_ITLB_MULTIHIT,		0,	   do_multihit },
+{ EXCCAUSE_ITLB_PRIVILEGE,	0,	   do_page_fault },
+/* EXCCAUSE_SIZE_RESTRICTION unhandled */
+{ EXCCAUSE_FETCH_CACHE_ATTRIBUTE,	0,	   do_page_fault },
+{ EXCCAUSE_DTLB_MISS,		USER|KRNL, fast_second_level_miss},
+{ EXCCAUSE_DTLB_MISS,		0,	   do_page_fault },
+{ EXCCAUSE_DTLB_MULTIHIT,		0,	   do_multihit },
+{ EXCCAUSE_DTLB_PRIVILEGE,	0,	   do_page_fault },
+/* EXCCAUSE_DTLB_SIZE_RESTRICTION unhandled */
+{ EXCCAUSE_STORE_CACHE_ATTRIBUTE,	USER|KRNL, fast_store_prohibited },
+{ EXCCAUSE_STORE_CACHE_ATTRIBUTE,	0,	   do_page_fault },
+{ EXCCAUSE_LOAD_CACHE_ATTRIBUTE,	0,	   do_page_fault },
 /* XCCHAL_EXCCAUSE_FLOATING_POINT unhandled */
 #if (XCHAL_CP_MASK & 1)
 COPROCESSOR(0),
diff -puN arch/xtensa/kernel/vectors.S~xtensa-remove-extra-header-files arch/xtensa/kernel/vectors.S
--- a/arch/xtensa/kernel/vectors.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/vectors.S
@@ -53,6 +53,8 @@
 #include <asm/thread_info.h>
 #include <asm/processor.h>
 
+#define WINDOW_VECTORS_SIZE   0x180
+
 
 /*
  * User exception vector. (Exceptions with PS.UM == 1, PS.EXCM == 0)
@@ -210,7 +212,7 @@ ENTRY(_DoubleExceptionVector)
 	/* Check for kernel double exception (usually fatal). */
 
 	rsr	a3, PS
-	_bbci.l	a3, PS_UM_SHIFT, .Lksp
+	_bbci.l	a3, PS_UM_BIT, .Lksp
 
 	/* Check if we are currently handling a window exception. */
 	/* Note: We don't need to indicate that we enter a critical section. */
@@ -219,7 +221,7 @@ ENTRY(_DoubleExceptionVector)
 
 	movi	a3, XCHAL_WINDOW_VECTORS_VADDR
 	_bltu	a0, a3, .Lfixup
-	addi	a3, a3, XSHAL_WINDOW_VECTORS_SIZE
+	addi	a3, a3, WINDOW_VECTORS_SIZE
 	_bgeu	a0, a3, .Lfixup
 
 	/* Window overflow/underflow exception. Get stack pointer. */
@@ -245,7 +247,7 @@ ENTRY(_DoubleExceptionVector)
 
 	wsr	a2, DEPC		# save stack pointer temporarily
 	rsr	a0, PS
-	extui	a0, a0, XCHAL_PS_OWB_SHIFT, XCHAL_PS_OWB_BITS
+	extui	a0, a0, PS_OWB_SHIFT, 4
 	wsr	a0, WINDOWBASE
 	rsync
 
@@ -312,8 +314,8 @@ ENTRY(_DoubleExceptionVector)
 .Lksp:	/* a0: a0, a1: a1, a2: a2, a3: trashed, depc: depc, excsave: a3 */
 
 	rsr	a3, EXCCAUSE
-	beqi	a3, XCHAL_EXCCAUSE_ITLB_MISS, 1f
-	addi	a3, a3, -XCHAL_EXCCAUSE_DTLB_MISS
+	beqi	a3, EXCCAUSE_ITLB_MISS, 1f
+	addi	a3, a3, -EXCCAUSE_DTLB_MISS
 	bnez	a3, .Lunrecoverable
 1:	movi	a3, fast_second_level_miss_double_kernel
 	jx	a3
diff -puN arch/xtensa/kernel/vmlinux.lds.S~xtensa-remove-extra-header-files arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -16,20 +16,17 @@
 
 #include <asm-generic/vmlinux.lds.h>
 
-#define _NOCLANGUAGE
-#undef __ASSEMBLER__
-#include <xtensa/config/core.h>
-#include <xtensa/config/system.h>
+#include <asm/variant/core.h>
 OUTPUT_ARCH(xtensa)
 ENTRY(_start)
 
-#if XCHAL_MEMORY_ORDER == XTHAL_BIGENDIAN
+#ifdef __XTENSA_EB__
 jiffies = jiffies_64 + 4;
 #else
 jiffies = jiffies_64;
 #endif
 
-#define KERNELOFFSET 0x1000
+#define KERNELOFFSET 0xd0001000
 
 /* Note: In the following macros, it would be nice to specify only the
    vector name and section kind and construct "sym" and "section" using
@@ -76,7 +73,7 @@ jiffies = jiffies_64;
 
 SECTIONS
 {
-  . = XCHAL_KSEG_CACHED_VADDR + KERNELOFFSET;
+  . = KERNELOFFSET;
   /* .text section */
 
   _text = .;
@@ -160,7 +157,7 @@ SECTIONS
 
   /* Initialization code and data: */
 
-  . = ALIGN(1<<XCHAL_MMU_MIN_PTE_PAGE_SIZE);
+  . = ALIGN(1 << 12);
   __init_begin = .;
   .init.text : {
   	_sinittext = .;
@@ -224,32 +221,32 @@ SECTIONS
 		  .dummy)
   SECTION_VECTOR (_DebugInterruptVector_literal,
 		  .DebugInterruptVector.literal,
-		  XCHAL_INTLEVEL_VECTOR_VADDR(XCHAL_DEBUGLEVEL) - 4,
+		  XCHAL_DEBUG_VECTOR_VADDR - 4,
 		  SIZEOF(.WindowVectors.text),
 		  .WindowVectors.text)
   SECTION_VECTOR (_DebugInterruptVector_text,
 		  .DebugInterruptVector.text,
-		  XCHAL_INTLEVEL_VECTOR_VADDR(XCHAL_DEBUGLEVEL),
+		  XCHAL_DEBUG_VECTOR_VADDR,
 		  4,
 		  .DebugInterruptVector.literal)
   SECTION_VECTOR (_KernelExceptionVector_literal,
 		  .KernelExceptionVector.literal,
-		  XCHAL_KERNELEXC_VECTOR_VADDR - 4,
+		  XCHAL_KERNEL_VECTOR_VADDR - 4,
 		  SIZEOF(.DebugInterruptVector.text),
 		  .DebugInterruptVector.text)
   SECTION_VECTOR (_KernelExceptionVector_text,
 		  .KernelExceptionVector.text,
-		  XCHAL_KERNELEXC_VECTOR_VADDR,
+		  XCHAL_KERNEL_VECTOR_VADDR,
 		  4,
 		  .KernelExceptionVector.literal)
   SECTION_VECTOR (_UserExceptionVector_literal,
 		  .UserExceptionVector.literal,
-		  XCHAL_USEREXC_VECTOR_VADDR - 4,
+		  XCHAL_USER_VECTOR_VADDR - 4,
 		  SIZEOF(.KernelExceptionVector.text),
 		  .KernelExceptionVector.text)
   SECTION_VECTOR (_UserExceptionVector_text,
 		  .UserExceptionVector.text,
-		  XCHAL_USEREXC_VECTOR_VADDR,
+		  XCHAL_USER_VECTOR_VADDR,
 		  4,
 		  .UserExceptionVector.literal)
   SECTION_VECTOR (_DoubleExceptionVector_literal,
@@ -264,7 +261,7 @@ SECTIONS
 		  .DoubleExceptionVector.literal)
 
   . = (LOADADDR( .DoubleExceptionVector.text ) + SIZEOF( .DoubleExceptionVector.text ) + 3) & ~ 3;
-  . = ALIGN(1<<XCHAL_MMU_MIN_PTE_PAGE_SIZE);
+  . = ALIGN(1 << 12);
 
   __init_end = .;
 
diff -puN arch/xtensa/lib/checksum.S~xtensa-remove-extra-header-files arch/xtensa/lib/checksum.S
--- a/arch/xtensa/lib/checksum.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/lib/checksum.S
@@ -16,8 +16,7 @@
 
 #include <asm/errno.h>
 #include <linux/linkage.h>
-#define _ASMLANGUAGE
-#include <xtensa/config/core.h>
+#include <asm/variant/core.h>
 
 /*
  * computes a partial checksum, e.g. for TCP/UDP fragments
diff -puN arch/xtensa/lib/memcopy.S~xtensa-remove-extra-header-files arch/xtensa/lib/memcopy.S
--- a/arch/xtensa/lib/memcopy.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/lib/memcopy.S
@@ -9,7 +9,7 @@
  * Copyright (C) 2002 - 2005 Tensilica Inc.
  */
 
-#include <xtensa/coreasm.h>
+#include <asm/variant/core.h>
 
 	.macro	src_b	r, w0, w1
 #ifdef __XTENSA_EB__
diff -puN arch/xtensa/lib/memset.S~xtensa-remove-extra-header-files arch/xtensa/lib/memset.S
--- a/arch/xtensa/lib/memset.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/lib/memset.S
@@ -11,7 +11,7 @@
  *  Copyright (C) 2002 Tensilica Inc.
  */
 
-#include <xtensa/coreasm.h>
+#include <asm/variant/core.h>
 
 /*
  * void *memset(void *dst, int c, size_t length)
diff -puN arch/xtensa/lib/strncpy_user.S~xtensa-remove-extra-header-files arch/xtensa/lib/strncpy_user.S
--- a/arch/xtensa/lib/strncpy_user.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/lib/strncpy_user.S
@@ -11,7 +11,7 @@
  *  Copyright (C) 2002 Tensilica Inc.
  */
 
-#include <xtensa/coreasm.h>
+#include <asm/variant/core.h>
 #include <linux/errno.h>
 
 /* Load or store instructions that may cause exceptions use the EX macro. */
diff -puN arch/xtensa/lib/strnlen_user.S~xtensa-remove-extra-header-files arch/xtensa/lib/strnlen_user.S
--- a/arch/xtensa/lib/strnlen_user.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/lib/strnlen_user.S
@@ -11,7 +11,7 @@
  *  Copyright (C) 2002 Tensilica Inc.
  */
 
-#include <xtensa/coreasm.h>
+#include <asm/variant/core.h>
 
 /* Load or store instructions that may cause exceptions use the EX macro. */
 
diff -puN arch/xtensa/lib/usercopy.S~xtensa-remove-extra-header-files arch/xtensa/lib/usercopy.S
--- a/arch/xtensa/lib/usercopy.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/lib/usercopy.S
@@ -53,7 +53,7 @@
  *	a11/ original length
  */
 
-#include <xtensa/coreasm.h>
+#include <asm/variant/core.h>
 
 #ifdef __XTENSA_EB__
 #define ALIGN(R, W0, W1) src	R, W0, W1
diff -puN arch/xtensa/mm/fault.c~xtensa-remove-extra-header-files arch/xtensa/mm/fault.c
--- a/arch/xtensa/mm/fault.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/mm/fault.c
@@ -21,7 +21,7 @@
 #include <asm/system.h>
 #include <asm/pgalloc.h>
 
-unsigned long asid_cache = ASID_FIRST_VERSION;
+unsigned long asid_cache = ASID_USER_FIRST;
 void bad_page_fault(struct pt_regs*, unsigned long, int);
 
 /*
@@ -58,10 +58,10 @@ void do_page_fault(struct pt_regs *regs)
 		return;
 	}
 
-	is_write = (exccause == XCHAL_EXCCAUSE_STORE_CACHE_ATTRIBUTE) ? 1 : 0;
-	is_exec =  (exccause == XCHAL_EXCCAUSE_ITLB_PRIVILEGE ||
-		    exccause == XCHAL_EXCCAUSE_ITLB_MISS ||
-		    exccause == XCHAL_EXCCAUSE_FETCH_CACHE_ATTRIBUTE) ? 1 : 0;
+	is_write = (exccause == EXCCAUSE_STORE_CACHE_ATTRIBUTE) ? 1 : 0;
+	is_exec =  (exccause == EXCCAUSE_ITLB_PRIVILEGE ||
+		    exccause == EXCCAUSE_ITLB_MISS ||
+		    exccause == EXCCAUSE_FETCH_CACHE_ATTRIBUTE) ? 1 : 0;
 
 #if 0
 	printk("[%s:%d:%08x:%d:%08x:%s%s]\n", current->comm, current->pid,
diff -puN arch/xtensa/mm/init.c~xtensa-remove-extra-header-files arch/xtensa/mm/init.c
--- a/arch/xtensa/mm/init.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/mm/init.c
@@ -141,8 +141,8 @@ void __init bootmem_init(void)
 	if (min_low_pfn > max_pfn)
 		panic("No memory found!\n");
 
-	max_low_pfn = max_pfn < MAX_LOW_MEMORY >> PAGE_SHIFT ?
-		max_pfn : MAX_LOW_MEMORY >> PAGE_SHIFT;
+	max_low_pfn = max_pfn < MAX_MEM_PFN >> PAGE_SHIFT ?
+		max_pfn : MAX_MEM_PFN >> PAGE_SHIFT;
 
 	/* Find an area to use for the bootmem bitmap. */
 
@@ -215,7 +215,7 @@ void __init init_mmu (void)
 
 	/* Set rasid register to a known value. */
 
-	set_rasid_register (ASID_ALL_RESERVED);
+	set_rasid_register (ASID_USER_FIRST);
 
 	/* Set PTEVADDR special register to the start of the page
 	 * table, which is in kernel mappable space (ie. not
diff -puN arch/xtensa/mm/misc.S~xtensa-remove-extra-header-files arch/xtensa/mm/misc.S
--- a/arch/xtensa/mm/misc.S~xtensa-remove-extra-header-files
+++ a/arch/xtensa/mm/misc.S
@@ -19,9 +19,8 @@
 #include <linux/linkage.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-
-#include <xtensa/cacheasm.h>
-#include <xtensa/cacheattrasm.h>
+#include <asm/asmmacro.h>
+#include <asm/cacheasm.h>
 
 /* clear_page (page) */
 
@@ -74,104 +73,66 @@ ENTRY(copy_page)
 
 	retw
 
-
 /*
- * void __flush_invalidate_cache_all(void)
+ * void __invalidate_icache_page(ulong start)
  */
 
-ENTRY(__flush_invalidate_cache_all)
+ENTRY(__invalidate_icache_page)
 	entry	sp, 16
-	dcache_writeback_inv_all a2, a3
-	icache_invalidate_all a2, a3
-	retw
 
-/*
- * void __invalidate_icache_all(void)
- */
+	___invalidate_icache_page a2 a3
+	isync
 
-ENTRY(__invalidate_icache_all)
-	entry	sp, 16
-	icache_invalidate_all a2, a3
 	retw
 
 /*
- * void __flush_invalidate_dcache_all(void)
+ * void __invalidate_dcache_page(ulong start)
  */
 
-ENTRY(__flush_invalidate_dcache_all)
+ENTRY(__invalidate_dcache_page)
 	entry	sp, 16
-	dcache_writeback_inv_all a2, a3
-	retw
-
 
-/*
- * void __flush_invalidate_cache_range(ulong start, ulong size)
- */
+	___invalidate_dcache_page a2 a3
+	dsync
 
-ENTRY(__flush_invalidate_cache_range)
-	entry	sp, 16
-	mov	a4, a2
-	mov	a5, a3
-	dcache_writeback_inv_region a4, a5, a6
-	icache_invalidate_region a2, a3, a4
 	retw
 
 /*
- * void __invalidate_icache_page(ulong start)
+ * void __flush_invalidate_dcache_page(ulong start)
  */
 
-ENTRY(__invalidate_icache_page)
+ENTRY(__flush_invalidate_dcache_page)
 	entry	sp, 16
-	movi	a3, PAGE_SIZE
-	icache_invalidate_region a2, a3, a4
-	retw
 
-/*
- * void __invalidate_dcache_page(ulong start)
- */
+	___flush_invalidate_dcache_page a2 a3
 
-ENTRY(__invalidate_dcache_page)
-	entry	sp, 16
-	movi	a3, PAGE_SIZE
-	dcache_invalidate_region a2, a3, a4
+	dsync
 	retw
 
 /*
- * void __invalidate_icache_range(ulong start, ulong size)
+ * void __flush_dcache_page(ulong start)
  */
 
-ENTRY(__invalidate_icache_range)
+ENTRY(__flush_dcache_page)
 	entry	sp, 16
-	icache_invalidate_region a2, a3, a4
-	retw
 
-/*
- * void __invalidate_dcache_range(ulong start, ulong size)
- */
+	___flush_dcache_page a2 a3
 
-ENTRY(__invalidate_dcache_range)
-	entry	sp, 16
-	dcache_invalidate_region a2, a3, a4
+	dsync
 	retw
 
-/*
- * void __flush_dcache_page(ulong start)
- */
 
-ENTRY(__flush_dcache_page)
-	entry	sp, 16
-	movi	a3, PAGE_SIZE
-	dcache_writeback_region a2, a3, a4
-	retw
 
 /*
- * void __flush_invalidate_dcache_page(ulong start)
+ * void __invalidate_icache_range(ulong start, ulong size)
  */
 
-ENTRY(__flush_invalidate_dcache_page)
+ENTRY(__invalidate_icache_range)
 	entry	sp, 16
-	movi	a3, PAGE_SIZE
-	dcache_writeback_inv_region a2, a3, a4
+
+	___invalidate_icache_range a2 a3 a4
+	isync
+
 	retw
 
 /*
@@ -180,195 +141,69 @@ ENTRY(__flush_invalidate_dcache_page)
 
 ENTRY(__flush_invalidate_dcache_range)
 	entry	sp, 16
-	dcache_writeback_inv_region a2, a3, a4
-	retw
 
-/*
- * void __invalidate_dcache_all(void)
- */
+	___flush_invalidate_dcache_range a2 a3 a4
+	dsync
 
-ENTRY(__invalidate_dcache_all)
-	entry	sp, 16
-	dcache_invalidate_all a2, a3
 	retw
 
 /*
- * void __flush_invalidate_dcache_page_phys(ulong start)
+ * void _flush_dcache_range(ulong start, ulong size)
  */
 
-ENTRY(__flush_invalidate_dcache_page_phys)
+ENTRY(__flush_dcache_range)
 	entry	sp, 16
 
-	movi	a3, XCHAL_DCACHE_SIZE
-	movi	a4, PAGE_MASK | 1
-	addi	a2, a2, 1
-
-1:	addi	a3, a3, -XCHAL_DCACHE_LINESIZE
-
-	ldct	a6, a3
+	___flush_dcache_range a2 a3 a4
 	dsync
-	and	a6, a6, a4
-	beq	a6, a2, 2f
-	bgeui	a3, 2, 1b
-	retw
 
-2:	diwbi	a3, 0
-	bgeui	a3, 2, 1b
 	retw
 
-ENTRY(check_dcache_low0)
-	entry	sp, 16
-
-	movi	a3, XCHAL_DCACHE_SIZE / 4
-	movi	a4, PAGE_MASK | 1
-	addi	a2, a2, 1
-
-1:	addi	a3, a3, -XCHAL_DCACHE_LINESIZE
-
-	ldct	a6, a3
-	dsync
-	and	a6, a6, a4
-	beq	a6, a2, 2f
-	bgeui	a3, 2, 1b
-	retw
-
-2:	j 2b
-
-ENTRY(check_dcache_high0)
-	entry	sp, 16
-
-	movi	a5, XCHAL_DCACHE_SIZE / 4
-	movi	a3, XCHAL_DCACHE_SIZE / 2
-	movi	a4, PAGE_MASK | 1
-	addi	a2, a2, 1
-
-1:	addi	a3, a3, -XCHAL_DCACHE_LINESIZE
-	addi	a5, a5, -XCHAL_DCACHE_LINESIZE
-
-	ldct	a6, a3
-	dsync
-	and	a6, a6, a4
-	beq	a6, a2, 2f
-	bgeui	a5, 2, 1b
-	retw
-
-2:	j 2b
+/*
+ * void _invalidate_dcache_range(ulong start, ulong size)
+ */
 
-ENTRY(check_dcache_low1)
+ENTRY(__invalidate_dcache_range)
 	entry	sp, 16
 
-	movi	a5, XCHAL_DCACHE_SIZE / 4
-	movi	a3, XCHAL_DCACHE_SIZE * 3 / 4
-	movi	a4, PAGE_MASK | 1
-	addi	a2, a2, 1
+	___invalidate_dcache_range a2 a3 a4
 
-1:	addi	a3, a3, -XCHAL_DCACHE_LINESIZE
-	addi	a5, a5, -XCHAL_DCACHE_LINESIZE
 
-	ldct	a6, a3
-	dsync
-	and	a6, a6, a4
-	beq	a6, a2, 2f
-	bgeui	a5, 2, 1b
 	retw
 
-2:	j 2b
+/*
+ * void _invalidate_icache_all(void)
+ */
 
-ENTRY(check_dcache_high1)
+ENTRY(__invalidate_icache_all)
 	entry	sp, 16
 
-	movi	a5, XCHAL_DCACHE_SIZE / 4
-	movi	a3, XCHAL_DCACHE_SIZE
-	movi	a4, PAGE_MASK | 1
-	addi	a2, a2, 1
-
-1:	addi	a3, a3, -XCHAL_DCACHE_LINESIZE
-	addi	a5, a5, -XCHAL_DCACHE_LINESIZE
+	___invalidate_icache_all a2 a3
+	isync
 
-	ldct	a6, a3
-	dsync
-	and	a6, a6, a4
-	beq	a6, a2, 2f
-	bgeui	a5, 2, 1b
 	retw
 
-2:	j 2b
-
-
 /*
- * void __invalidate_icache_page_phys(ulong start)
+ * void _flush_invalidate_dcache_all(void)
  */
 
-ENTRY(__invalidate_icache_page_phys)
+ENTRY(__flush_invalidate_dcache_all)
 	entry	sp, 16
 
-	movi	a3, XCHAL_ICACHE_SIZE
-	movi	a4, PAGE_MASK | 1
-	addi	a2, a2, 1
-
-1:	addi	a3, a3, -XCHAL_ICACHE_LINESIZE
-
-	lict	a6, a3
-	isync
-	and	a6, a6, a4
-	beq	a6, a2, 2f
-	bgeui	a3, 2, 1b
-	retw
+	___flush_invalidate_dcache_all a2 a3
+	dsync
 
-2:	iii	a3, 0
-	bgeui	a3, 2, 1b
 	retw
 
+/*
+ * void _invalidate_dcache_all(void)
+ */
 
-#if 0
-
-	movi	a3, XCHAL_DCACHE_WAYS - 1
-	movi	a4, PAGE_SIZE
-
-1:	mov	a5, a2
-	add	a6, a2, a4
-
-2:	diwbi	a5, 0
-	diwbi	a5, XCHAL_DCACHE_LINESIZE
-	diwbi	a5, XCHAL_DCACHE_LINESIZE * 2
-	diwbi	a5, XCHAL_DCACHE_LINESIZE * 3
-
-	addi	a5, a5, XCHAL_DCACHE_LINESIZE * 4
-	blt	a5, a6, 2b
-
-	addi	a3, a3, -1
-	addi	a2, a2, XCHAL_DCACHE_SIZE / XCHAL_DCACHE_WAYS
-	bgez	a3, 1b
-
-	retw
-
-ENTRY(__invalidate_icache_page_index)
+ENTRY(__invalidate_dcache_all)
 	entry	sp, 16
 
-	movi	a3, XCHAL_ICACHE_WAYS - 1
-	movi	a4, PAGE_SIZE
-
-1:	mov	a5, a2
-	add	a6, a2, a4
-
-2:	iii	a5, 0
-	iii	a5, XCHAL_ICACHE_LINESIZE
-	iii	a5, XCHAL_ICACHE_LINESIZE * 2
-	iii	a5, XCHAL_ICACHE_LINESIZE * 3
-
-	addi	a5, a5, XCHAL_ICACHE_LINESIZE * 4
-	blt	a5, a6, 2b
-
-	addi	a3, a3, -1
-	addi	a2, a2, XCHAL_ICACHE_SIZE / XCHAL_ICACHE_WAYS
-	bgez	a3, 2b
+	___invalidate_dcache_all a2 a3
+	dsync
 
 	retw
 
-#endif
-
-
-
-
-
-
diff -puN arch/xtensa/mm/tlb.c~xtensa-remove-extra-header-files arch/xtensa/mm/tlb.c
--- a/arch/xtensa/mm/tlb.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/mm/tlb.c
@@ -24,12 +24,12 @@
 
 static inline void __flush_itlb_all (void)
 {
-	int way, index;
+	int w, i;
 
-	for (way = 0; way < XCHAL_ITLB_ARF_WAYS; way++) {
-		for (index = 0; index < ITLB_ENTRIES_PER_ARF_WAY; index++) {
-			int entry = way + (index << PAGE_SHIFT);
-			invalidate_itlb_entry_no_isync (entry);
+	for (w = 0; w < ITLB_ARF_WAYS; w++) {
+		for (i = 0; i < (1 << XCHAL_ITLB_ARF_ENTRIES_LOG2); i++) {
+			int e = w + (i << PAGE_SHIFT);
+			invalidate_itlb_entry_no_isync(e);
 		}
 	}
 	asm volatile ("isync\n");
@@ -37,12 +37,12 @@ static inline void __flush_itlb_all (voi
 
 static inline void __flush_dtlb_all (void)
 {
-	int way, index;
+	int w, i;
 
-	for (way = 0; way < XCHAL_DTLB_ARF_WAYS; way++) {
-		for (index = 0; index < DTLB_ENTRIES_PER_ARF_WAY; index++) {
-			int entry = way + (index << PAGE_SHIFT);
-			invalidate_dtlb_entry_no_isync (entry);
+	for (w = 0; w < DTLB_ARF_WAYS; w++) {
+		for (i = 0; i < (1 << XCHAL_DTLB_ARF_ENTRIES_LOG2); i++) {
+			int e = w + (i << PAGE_SHIFT);
+			invalidate_dtlb_entry_no_isync(e);
 		}
 	}
 	asm volatile ("isync\n");
@@ -63,21 +63,25 @@ void flush_tlb_all (void)
 
 void flush_tlb_mm(struct mm_struct *mm)
 {
-#if 0
-	printk("[tlbmm<%lx>]\n", (unsigned long)mm->context);
-#endif
-
 	if (mm == current->active_mm) {
 		int flags;
 		local_save_flags(flags);
-		get_new_mmu_context(mm, asid_cache);
-		set_rasid_register(ASID_INSERT(mm->context));
+		__get_new_mmu_context(mm);
+		__load_mmu_context(mm);
 		local_irq_restore(flags);
 	}
 	else
 		mm->context = 0;
 }
 
+#define _ITLB_ENTRIES (ITLB_ARF_WAYS << XCHAL_ITLB_ARF_ENTRIES_LOG2)
+#define _DTLB_ENTRIES (DTLB_ARF_WAYS << XCHAL_DTLB_ARF_ENTRIES_LOG2)
+#if _ITLB_ENTRIES > _DTLB_ENTRIES
+# define _TLB_ENTRIES _ITLB_ENTRIES
+#else
+# define _TLB_ENTRIES _DTLB_ENTRIES
+#endif
+
 void flush_tlb_range (struct vm_area_struct *vma,
     		      unsigned long start, unsigned long end)
 {
@@ -93,7 +97,7 @@ void flush_tlb_range (struct vm_area_str
 #endif
 	local_save_flags(flags);
 
-	if (end-start + (PAGE_SIZE-1) <= SMALLEST_NTLB_ENTRIES << PAGE_SHIFT) {
+	if (end-start + (PAGE_SIZE-1) <= _TLB_ENTRIES << PAGE_SHIFT) {
 		int oldpid = get_rasid_register();
 		set_rasid_register (ASID_INSERT(mm->context));
 		start &= PAGE_MASK;
@@ -111,9 +115,7 @@ void flush_tlb_range (struct vm_area_str
 
 		set_rasid_register(oldpid);
 	} else {
-		get_new_mmu_context(mm, asid_cache);
-		if (mm == current->active_mm)
-			set_rasid_register(ASID_INSERT(mm->context));
+		flush_tlb_mm(mm);
 	}
 	local_irq_restore(flags);
 }
@@ -123,10 +125,6 @@ void flush_tlb_page (struct vm_area_stru
 	struct mm_struct* mm = vma->vm_mm;
 	unsigned long flags;
 	int oldpid;
-#if 0
-	printk("[tlbpage<%02lx,%08lx>]\n",
-			(unsigned long)mm->context, page);
-#endif
 
 	if(mm->context == NO_CONTEXT)
 		return;
@@ -142,404 +140,5 @@ void flush_tlb_page (struct vm_area_stru
 	set_rasid_register(oldpid);
 
 	local_irq_restore(flags);
-
-#if 0
-	flush_tlb_all();
-	return;
-#endif
-}
-
-
-#ifdef DEBUG_TLB
-
-#define USE_ITLB  0
-#define USE_DTLB  1
-
-struct way_config_t {
-	int indicies;
-	int indicies_log2;
-	int pgsz_log2;
-	int arf;
-};
-
-static struct way_config_t itlb[XCHAL_ITLB_WAYS] =
-{
-	{ XCHAL_ITLB_SET(XCHAL_ITLB_WAY0_SET, ENTRIES),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY0_SET, ENTRIES_LOG2),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY0_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY0_SET, ARF)
-	},
-	{ XCHAL_ITLB_SET(XCHAL_ITLB_WAY1_SET, ENTRIES),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY1_SET, ENTRIES_LOG2),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY1_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY1_SET, ARF)
-	},
-	{ XCHAL_ITLB_SET(XCHAL_ITLB_WAY2_SET, ENTRIES),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY2_SET, ENTRIES_LOG2),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY2_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY2_SET, ARF)
-	},
-	{ XCHAL_ITLB_SET(XCHAL_ITLB_WAY3_SET, ENTRIES),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY3_SET, ENTRIES_LOG2),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY3_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY3_SET, ARF)
-	},
-	{ XCHAL_ITLB_SET(XCHAL_ITLB_WAY4_SET, ENTRIES),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY4_SET, ENTRIES_LOG2),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY4_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY4_SET, ARF)
-	},
-	{ XCHAL_ITLB_SET(XCHAL_ITLB_WAY5_SET, ENTRIES),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY5_SET, ENTRIES_LOG2),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY5_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY5_SET, ARF)
-	},
-	{ XCHAL_ITLB_SET(XCHAL_ITLB_WAY6_SET, ENTRIES),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY6_SET, ENTRIES_LOG2),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY6_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_ITLB_SET(XCHAL_ITLB_WAY6_SET, ARF)
-	}
-};
-
-static struct way_config_t dtlb[XCHAL_DTLB_WAYS] =
-{
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY0_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY0_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY0_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY0_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY1_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY1_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY1_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY1_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY2_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY2_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY2_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY2_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY3_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY3_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY3_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY3_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY4_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY4_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY4_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY4_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY5_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY5_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY5_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY5_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY6_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY6_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY6_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY6_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY7_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY7_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY7_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY7_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY8_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY8_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY8_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY8_SET, ARF)
-	},
-	{ XCHAL_DTLB_SET(XCHAL_DTLB_WAY9_SET, ENTRIES),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY9_SET, ENTRIES_LOG2),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY9_SET, PAGESZ_LOG2_MIN),
-	  XCHAL_DTLB_SET(XCHAL_DTLB_WAY9_SET, ARF)
-	}
-};
-
-/*  Total number of entries:  */
-#define ITLB_TOTAL_ENTRIES	\
-		XCHAL_ITLB_SET(XCHAL_ITLB_WAY0_SET, ENTRIES) + \
-		XCHAL_ITLB_SET(XCHAL_ITLB_WAY1_SET, ENTRIES) + \
-		XCHAL_ITLB_SET(XCHAL_ITLB_WAY2_SET, ENTRIES) + \
-		XCHAL_ITLB_SET(XCHAL_ITLB_WAY3_SET, ENTRIES) + \
-		XCHAL_ITLB_SET(XCHAL_ITLB_WAY4_SET, ENTRIES) + \
-		XCHAL_ITLB_SET(XCHAL_ITLB_WAY5_SET, ENTRIES) + \
-		XCHAL_ITLB_SET(XCHAL_ITLB_WAY6_SET, ENTRIES)
-#define DTLB_TOTAL_ENTRIES	\
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY0_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY1_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY2_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY3_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY4_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY5_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY6_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY7_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY8_SET, ENTRIES) + \
-		XCHAL_DTLB_SET(XCHAL_DTLB_WAY9_SET, ENTRIES)
-
-
-typedef struct {
-    unsigned		va;
-    unsigned		pa;
-    unsigned char	asid;
-    unsigned char	ca;
-    unsigned char	way;
-    unsigned char	index;
-    unsigned char	pgsz_log2;	/* 0 .. 32 */
-    unsigned char	type;		/* 0=ITLB 1=DTLB */
-} tlb_dump_entry_t;
-
-/*  Return -1 if a precedes b, +1 if a follows b, 0 if same:  */
-int cmp_tlb_dump_info( tlb_dump_entry_t *a, tlb_dump_entry_t *b )
-{
-    if (a->asid < b->asid) return -1;
-    if (a->asid > b->asid) return  1;
-    if (a->va < b->va) return -1;
-    if (a->va > b->va) return  1;
-    if (a->pa < b->pa) return -1;
-    if (a->pa > b->pa) return  1;
-    if (a->ca < b->ca) return -1;
-    if (a->ca > b->ca) return  1;
-    if (a->way < b->way) return -1;
-    if (a->way > b->way) return  1;
-    if (a->index < b->index) return -1;
-    if (a->index > b->index) return  1;
-    return 0;
-}
-
-void sort_tlb_dump_info( tlb_dump_entry_t *t, int n )
-{
-    int i, j;
-    /*  Simple O(n*n) sort:  */
-    for (i = 0; i < n-1; i++)
-	for (j = i+1; j < n; j++)
-	    if (cmp_tlb_dump_info(t+i, t+j) > 0) {
-		tlb_dump_entry_t tmp = t[i];
-		t[i] = t[j];
-		t[j] = tmp;
-	    }
-}
-
-
-static tlb_dump_entry_t itlb_dump_info[ITLB_TOTAL_ENTRIES];
-static tlb_dump_entry_t dtlb_dump_info[DTLB_TOTAL_ENTRIES];
-
-
-static inline char *way_type (int type)
-{
-	return type ? "autorefill" : "non-autorefill";
-}
-
-void print_entry (struct way_config_t *way_info,
-		  unsigned int way,
-		  unsigned int index,
-		  unsigned int virtual,
-		  unsigned int translation)
-{
-	char valid_chr;
-	unsigned int va, pa, asid, ca;
-
-	va = virtual &
-	  	~((1 << (way_info->pgsz_log2 + way_info->indicies_log2)) - 1);
-	asid = virtual & ((1 << XCHAL_MMU_ASID_BITS) - 1);
-	pa = translation & ~((1 << way_info->pgsz_log2) - 1);
-	ca = translation & ((1 << XCHAL_MMU_CA_BITS) - 1);
-	valid_chr = asid ? 'V' : 'I';
-
-	/* Compute and incorporate the effect of the index bits on the
-	 * va.  It's more useful for kernel debugging, since we always
-	 * want to know the effective va anyway. */
-
-	va += index << way_info->pgsz_log2;
-
-	printk ("\t[%d,%d] (%c) vpn 0x%.8x  ppn 0x%.8x  asid 0x%.2x  am 0x%x\n",
-		way, index, valid_chr, va, pa, asid, ca);
-}
-
-void print_itlb_entry (struct way_config_t *way_info, int way, int index)
-{
-	print_entry (way_info, way, index,
-		     read_itlb_virtual (way + (index << way_info->pgsz_log2)),
-		     read_itlb_translation (way + (index << way_info->pgsz_log2)));
-}
-
-void print_dtlb_entry (struct way_config_t *way_info, int way, int index)
-{
-	print_entry (way_info, way, index,
-		     read_dtlb_virtual (way + (index << way_info->pgsz_log2)),
-		     read_dtlb_translation (way + (index << way_info->pgsz_log2)));
-}
-
-void dump_itlb (void)
-{
-	int way, index;
-
-	printk ("\nITLB: ways = %d\n", XCHAL_ITLB_WAYS);
-
-	for (way = 0; way < XCHAL_ITLB_WAYS; way++) {
-		printk ("\nWay: %d, Entries: %d, MinPageSize: %d, Type: %s\n",
-			way, itlb[way].indicies,
-			itlb[way].pgsz_log2, way_type(itlb[way].arf));
-		for (index = 0; index < itlb[way].indicies; index++) {
-			print_itlb_entry(&itlb[way], way, index);
-		}
-	}
-}
-
-void dump_dtlb (void)
-{
-	int way, index;
-
-	printk ("\nDTLB: ways = %d\n", XCHAL_DTLB_WAYS);
-
-	for (way = 0; way < XCHAL_DTLB_WAYS; way++) {
-		printk ("\nWay: %d, Entries: %d, MinPageSize: %d, Type: %s\n",
-			way, dtlb[way].indicies,
-			dtlb[way].pgsz_log2, way_type(dtlb[way].arf));
-		for (index = 0; index < dtlb[way].indicies; index++) {
-			print_dtlb_entry(&dtlb[way], way, index);
-		}
-	}
-}
-
-void dump_tlb (tlb_dump_entry_t *tinfo, struct way_config_t *config,
-		int entries, int ways, int type, int show_invalid)
-{
-    tlb_dump_entry_t *e = tinfo;
-    int way, i;
-
-    /*  Gather all info:  */
-    for (way = 0; way < ways; way++) {
-	struct way_config_t *cfg = config + way;
-	for (i = 0; i < cfg->indicies; i++) {
-	    unsigned wayindex = way + (i << cfg->pgsz_log2);
-	    unsigned vv = (type ? read_dtlb_virtual (wayindex)
-		    		: read_itlb_virtual (wayindex));
-	    unsigned pp = (type ? read_dtlb_translation (wayindex)
-		    		: read_itlb_translation (wayindex));
-
-	    /* Compute and incorporate the effect of the index bits on the
-	     * va.  It's more useful for kernel debugging, since we always
-	     * want to know the effective va anyway. */
-
-	    e->va = (vv & ~((1 << (cfg->pgsz_log2 + cfg->indicies_log2)) - 1));
-	    e->va += (i << cfg->pgsz_log2);
-	    e->pa = (pp & ~((1 << cfg->pgsz_log2) - 1));
-	    e->asid = (vv & ((1 << XCHAL_MMU_ASID_BITS) - 1));
-	    e->ca = (pp & ((1 << XCHAL_MMU_CA_BITS) - 1));
-	    e->way = way;
-	    e->index = i;
-	    e->pgsz_log2 = cfg->pgsz_log2;
-	    e->type = type;
-	    e++;
-	}
-    }
-#if 1
-    /*  Sort by ASID and VADDR:  */
-    sort_tlb_dump_info (tinfo, entries);
-#endif
-
-    /*  Display all sorted info:  */
-    printk ("\n%cTLB dump:\n", (type ? 'D' : 'I'));
-    for (e = tinfo, i = 0; i < entries; i++, e++) {
-#if 0
-	if (e->asid == 0 && !show_invalid)
-	    continue;
-#endif
-	printk ("%c way=%d i=%d  ASID=%02X V=%08X -> P=%08X CA=%X (%d %cB)\n",
-		(e->type ? 'D' : 'I'), e->way, e->index,
-		e->asid, e->va, e->pa, e->ca,
-		(1 << (e->pgsz_log2 % 10)),
-		" kMG"[e->pgsz_log2 / 10]
-		);
-    }
-}
-
-void dump_tlbs2 (int showinv)
-{
-    dump_tlb (itlb_dump_info, itlb, ITLB_TOTAL_ENTRIES, XCHAL_ITLB_WAYS, 0, showinv);
-    dump_tlb (dtlb_dump_info, dtlb, DTLB_TOTAL_ENTRIES, XCHAL_DTLB_WAYS, 1, showinv);
-}
-
-void dump_all_tlbs (void)
-{
-    dump_tlbs2 (1);
-}
-
-void dump_valid_tlbs (void)
-{
-    dump_tlbs2 (0);
 }
 
-
-void dump_tlbs (void)
-{
-	dump_itlb();
-	dump_dtlb();
-}
-
-void dump_cache_tag(int dcache, int idx)
-{
-	int w, i, s, e;
-	unsigned long tag, index;
-	unsigned long num_lines, num_ways, cache_size, line_size;
-
-	num_ways = dcache ? XCHAL_DCACHE_WAYS : XCHAL_ICACHE_WAYS;
-	cache_size = dcache ? XCHAL_DCACHE_SIZE : XCHAL_ICACHE_SIZE;
-	line_size = dcache ? XCHAL_DCACHE_LINESIZE : XCHAL_ICACHE_LINESIZE;
-
-	num_lines = cache_size / num_ways;
-
-	s = 0; e = num_lines;
-
-	if (idx >= 0)
-		e = (s = idx * line_size) + 1;
-
-	for (i = s; i < e; i+= line_size) {
-		printk("\nline %#08x:", i);
-		for (w = 0; w < num_ways; w++) {
-			index = w * num_lines + i;
-			if (dcache)
-				__asm__ __volatile__("ldct %0, %1\n\t"
-						: "=a"(tag) : "a"(index));
-			else
-				__asm__ __volatile__("lict %0, %1\n\t"
-						: "=a"(tag) : "a"(index));
-
-			printk(" %#010lx", tag);
-		}
-	}
-	printk ("\n");
-}
-
-void dump_icache(int index)
-{
-	unsigned long data, addr;
-	int w, i;
-
-	const unsigned long num_ways = XCHAL_ICACHE_WAYS;
-	const unsigned long cache_size = XCHAL_ICACHE_SIZE;
-	const unsigned long line_size = XCHAL_ICACHE_LINESIZE;
-	const unsigned long num_lines = cache_size / num_ways / line_size;
-
-	for (w = 0; w < num_ways; w++) {
-		printk ("\nWay %d", w);
-
-		for (i = 0; i < line_size; i+= 4) {
-			addr = w * num_lines + index * line_size + i;
-			__asm__ __volatile__("licw %0, %1\n\t"
-					: "=a"(data) : "a"(addr));
-			printk(" %#010lx", data);
-		}
-	}
-	printk ("\n");
-}
-
-void dump_cache_tags(void)
-{
-	printk("Instruction cache\n");
-	dump_cache_tag(0, -1);
-	printk("Data cache\n");
-	dump_cache_tag(1, -1);
-}
-
-#endif
diff -puN arch/xtensa/platform-iss/console.c~xtensa-remove-extra-header-files arch/xtensa/platform-iss/console.c
--- a/arch/xtensa/platform-iss/console.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/platform-iss/console.c
@@ -25,11 +25,15 @@
 #include <asm/uaccess.h>
 #include <asm/irq.h>
 
-#include <xtensa/simcall.h>
+#include <asm/platform/simcall.h>
 
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 
+#ifdef SERIAL_INLINE
+#define _INLINE_ inline
+#endif
+
 #define SERIAL_MAX_NUM_LINES 1
 #define SERIAL_TIMER_VALUE (20 * HZ)
 
@@ -191,7 +195,7 @@ static int rs_read_proc(char *page, char
 }
 
 
-static const struct tty_operations serial_ops = {
+static struct tty_operations serial_ops = {
 	.open = rs_open,
 	.close = rs_close,
 	.write = rs_write,
diff -puN arch/xtensa/platform-iss/network.c~xtensa-remove-extra-header-files arch/xtensa/platform-iss/network.c
--- a/arch/xtensa/platform-iss/network.c~xtensa-remove-extra-header-files
+++ a/arch/xtensa/platform-iss/network.c
@@ -34,7 +34,7 @@
 #include <linux/timer.h>
 #include <linux/platform_device.h>
 
-#include <xtensa/simcall.h>
+#include <asm/platform/simcall.h>
 
 #define DRIVER_NAME "iss-netdev"
 #define ETH_MAX_PACKET 1500
diff -puN /dev/null include/asm-xtensa/asmmacro.h
--- /dev/null
+++ a/include/asm-xtensa/asmmacro.h
@@ -0,0 +1,153 @@
+/*
+ * include/asm-xtensa/asmmacro.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2005 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_ASMMACRO_H
+#define _XTENSA_ASMMACRO_H
+
+#include <asm/variant/core.h>
+
+/*
+ * Some little helpers for loops. Use zero-overhead-loops
+ * where applicable and if supported by the processor.
+ *
+ * __loopi ar, at, size, inc
+ *         ar	register initialized with the start address
+ *	   at	scratch register used by macro
+ *	   size	size immediate value
+ *	   inc	increment
+ *
+ * __loops ar, as, at, inc_log2[, mask_log2][, cond][, ncond]
+ *	   ar	register initialized with the start address
+ *	   as	register initialized with the size
+ *	   at	scratch register use by macro
+ *	   inc_log2	increment [in log2]
+ *	   mask_log2	mask [in log2]
+ *	   cond		true condition (used in loop'cond')
+ *	   ncond	false condition (used in b'ncond')
+ *
+ * __loop  as
+ *	   restart loop. 'as' register must not have been modified!
+ *
+ * __endla ar, at, incr
+ *	   ar	start address (modified)
+ *	   as	scratch register used by macro
+ *	   inc	increment
+ */
+
+/*
+ * loop for given size as immediate
+ */
+
+	.macro	__loopi ar, at, size, incr
+
+#if XCHAL_HAVE_LOOPS
+		movi	\at, ((\size + \incr - 1) / (\incr))
+		loop	\at, 99f
+#else
+		addi	\at, \ar, \size
+		98:
+#endif
+
+	.endm
+
+/*
+ * loop for given size in register
+ */
+
+	.macro	__loops	ar, as, at, incr_log2, mask_log2, cond, ncond
+
+#if XCHAL_HAVE_LOOPS
+		.ifgt \incr_log2 - 1
+			addi	\at, \as, (1 << \incr_log2) - 1
+			.ifnc \mask_log2,
+				extui	\at, \at, \incr_log2, \mask_log2
+			.else
+				srli	\at, \at, \incr_log2
+			.endif
+		.endif
+		loop\cond	\at, 99f
+#else
+		.ifnc \mask_log2,
+			extui	\at, \as, \incr_log2, \mask_log2
+		.else
+			.ifnc \ncond,
+				srli	\at, \as, \incr_log2
+			.endif
+		.endif
+		.ifnc \ncond,
+			b\ncond	\at, 99f
+
+		.endif
+		.ifnc \mask_log2,
+			slli	\at, \at, \incr_log2
+			add	\at, \ar, \at
+		.else
+			add	\at, \ar, \as
+		.endif
+#endif
+		98:
+
+	.endm
+
+/*
+ * loop from ar to ax
+ */
+
+	.macro	__loopt	ar, as, at, incr_log2
+
+#if XCHAL_HAVE_LOOPS
+		sub	\at, \as, \ar
+		.ifgt	\incr_log2 - 1
+			addi	\at, \at, (1 << \incr_log2) - 1
+			srli	\at, \at, \incr_log2
+		.endif
+		loop	\at, 99f
+#else
+		98:
+#endif
+
+	.endm
+
+/*
+ * restart loop. registers must be unchanged
+ */
+
+	.macro	__loop	as
+
+#if XCHAL_HAVE_LOOPS
+		loop	\as, 99f
+#else
+		98:
+#endif
+
+	.endm
+
+/*
+ * end of loop with no increment of the address.
+ */
+
+	.macro	__endl	ar, as
+#if !XCHAL_HAVE_LOOPS
+		bltu	\ar, \as, 98b
+#endif
+		99:
+	.endm
+
+/*
+ * end of loop with increment of the address.
+ */
+
+	.macro	__endla	ar, as, incr
+		addi	\ar, \ar, \incr
+		__endl	\ar \as
+	.endm
+
+
+#endif /* _XTENSA_ASMMACRO_H */
diff -puN include/asm-xtensa/byteorder.h~xtensa-remove-extra-header-files include/asm-xtensa/byteorder.h
--- a/include/asm-xtensa/byteorder.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/byteorder.h
@@ -11,7 +11,6 @@
 #ifndef _XTENSA_BYTEORDER_H
 #define _XTENSA_BYTEORDER_H
 
-#include <asm/processor.h>
 #include <asm/types.h>
 
 static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
diff -puN include/asm-xtensa/cache.h~xtensa-remove-extra-header-files include/asm-xtensa/cache.h
--- a/include/asm-xtensa/cache.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/cache.h
@@ -4,7 +4,6 @@
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
- * 2 of the License, or (at your option) any later version.
  *
  * (C) 2001 - 2005 Tensilica Inc.
  */
@@ -12,21 +11,14 @@
 #ifndef _XTENSA_CACHE_H
 #define _XTENSA_CACHE_H
 
-#include <xtensa/config/core.h>
+#include <asm/variant/core.h>
 
-#if XCHAL_ICACHE_SIZE > 0
-# if (XCHAL_ICACHE_SIZE % (XCHAL_ICACHE_LINESIZE*XCHAL_ICACHE_WAYS*4)) != 0
-#  error cache configuration outside expected/supported range!
-# endif
-#endif
-
-#if XCHAL_DCACHE_SIZE > 0
-# if (XCHAL_DCACHE_SIZE % (XCHAL_DCACHE_LINESIZE*XCHAL_DCACHE_WAYS*4)) != 0
-#  error cache configuration outside expected/supported range!
-# endif
-#endif
+#define L1_CACHE_SHIFT	XCHAL_DCACHE_LINEWIDTH
+#define L1_CACHE_BYTES	XCHAL_DCACHE_LINESIZE
+#define SMP_CACHE_BYTES	L1_CACHE_BYTES
+
+#define DCACHE_WAY_SIZE	(XCHAL_DCACHE_SIZE/XCHAL_DCACHE_WAYS)
+#define ICACHE_WAY_SIZE	(XCHAL_ICACHE_SIZE/XCHAL_ICACHE_WAYS)
 
-#define L1_CACHE_SHIFT		XCHAL_CACHE_LINEWIDTH_MAX
-#define L1_CACHE_BYTES		XCHAL_CACHE_LINESIZE_MAX
 
 #endif	/* _XTENSA_CACHE_H */
diff -puN /dev/null include/asm-xtensa/cacheasm.h
--- /dev/null
+++ a/include/asm-xtensa/cacheasm.h
@@ -0,0 +1,177 @@
+/*
+ * include/asm-xtensa/cacheasm.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Tensilica Inc.
+ */
+
+#include <asm/cache.h>
+#include <asm/asmmacro.h>
+#include <linux/stringify.h>
+
+/*
+ * Define cache functions as macros here so that they can be used
+ * by the kernel and boot loader. We should consider moving them to a
+ * library that can be linked by both.
+ *
+ * Locking
+ *
+ *   ___unlock_dcache_all
+ *   ___unlock_icache_all
+ *
+ * Flush and invaldating
+ *
+ *   ___flush_invalidate_dcache_{all|range|page}
+ *   ___flush_dcache_{all|range|page}
+ *   ___invalidate_dcache_{all|range|page}
+ *   ___invalidate_icache_{all|range|page}
+ *
+ */
+
+	.macro	__loop_cache_all ar at insn size line_width
+
+	movi	\ar, 0
+
+	__loopi	\ar, \at, \size, (4 << (\line_width))
+	\insn	\ar, 0 << (\line_width)
+	\insn	\ar, 1 << (\line_width)
+	\insn	\ar, 2 << (\line_width)
+	\insn	\ar, 3 << (\line_width)
+	__endla	\ar, \at, 4 << (\line_width)
+
+	.endm
+
+
+	.macro	__loop_cache_range ar as at insn line_width
+
+	extui	\at, \ar, 0, \line_width
+	add	\as, \as, \at
+
+	__loops	\ar, \as, \at, \line_width
+	\insn	\ar, 0
+	__endla	\ar, \at, (1 << (\line_width))
+
+	.endm
+
+
+	.macro	__loop_cache_page ar at insn line_width
+
+	__loopi	\ar, \at, PAGE_SIZE, 4 << (\line_width)
+	\insn	\ar, 0 << (\line_width)
+	\insn	\ar, 1 << (\line_width)
+	\insn	\ar, 2 << (\line_width)
+	\insn	\ar, 3 << (\line_width)
+	__endla	\ar, \at, 4 << (\line_width)
+
+	.endm
+
+
+#if XCHAL_DCACHE_LINE_LOCKABLE
+
+	.macro	___unlock_dcache_all ar at
+
+	__loop_cache_all \ar \at diu XCHAL_DCACHE_SIZE XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+#endif
+
+#if XCHAL_ICACHE_LINE_LOCKABLE
+
+	.macro	___unlock_icache_all ar at
+
+	__loop_cache_all \ar \at iiu XCHAL_ICACHE_SIZE XCHAL_ICACHE_LINEWIDTH
+
+	.endm
+#endif
+
+	.macro	___flush_invalidate_dcache_all ar at
+
+	__loop_cache_all \ar \at diwbi XCHAL_DCACHE_SIZE XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___flush_dcache_all ar at
+
+	__loop_cache_all \ar \at diwb XCHAL_DCACHE_SIZE XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___invalidate_dcache_all ar at
+
+	__loop_cache_all \ar \at dii __stringify(DCACHE_WAY_SIZE) \
+			 XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___invalidate_icache_all ar at
+
+	__loop_cache_all \ar \at iii __stringify(ICACHE_WAY_SIZE) \
+			 XCHAL_ICACHE_LINEWIDTH
+
+	.endm
+
+
+
+	.macro	___flush_invalidate_dcache_range ar as at
+
+	__loop_cache_range \ar \as \at dhwbi XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___flush_dcache_range ar as at
+
+	__loop_cache_range \ar \as \at dhwb XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___invalidate_dcache_range ar as at
+
+	__loop_cache_range \ar \as \at dhi XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___invalidate_icache_range ar as at
+
+	__loop_cache_range \ar \as \at ihi XCHAL_ICACHE_LINEWIDTH
+
+	.endm
+
+
+
+	.macro	___flush_invalidate_dcache_page ar as
+
+	__loop_cache_page \ar \as dhwbi XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro ___flush_dcache_page ar as
+
+	__loop_cache_page \ar \as dhwb XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___invalidate_dcache_page ar as
+
+	__loop_cache_page \ar \as dhi XCHAL_DCACHE_LINEWIDTH
+
+	.endm
+
+
+	.macro	___invalidate_icache_page ar as
+
+	__loop_cache_page \ar \as ihi XCHAL_ICACHE_LINEWIDTH
+
+	.endm
+
diff -puN include/asm-xtensa/cacheflush.h~xtensa-remove-extra-header-files include/asm-xtensa/cacheflush.h
--- a/include/asm-xtensa/cacheflush.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/cacheflush.h
@@ -5,7 +5,7 @@
  * License.  See the file "COPYING" in the main directory of this archive
  * for more details.
  *
- * (C) 2001 - 2005 Tensilica Inc.
+ * (C) 2001 - 2006 Tensilica Inc.
  */
 
 #ifndef _XTENSA_CACHEFLUSH_H
diff -puN include/asm-xtensa/checksum.h~xtensa-remove-extra-header-files include/asm-xtensa/checksum.h
--- a/include/asm-xtensa/checksum.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/checksum.h
@@ -12,7 +12,7 @@
 #define _XTENSA_CHECKSUM_H
 
 #include <linux/in6.h>
-#include <xtensa/config/core.h>
+#include <asm/variant/core.h>
 
 /*
  * computes the checksum of a memory block at buff, length len,
diff -puN include/asm-xtensa/coprocessor.h~xtensa-remove-extra-header-files include/asm-xtensa/coprocessor.h
--- a/include/asm-xtensa/coprocessor.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/coprocessor.h
@@ -11,7 +11,16 @@
 #ifndef _XTENSA_COPROCESSOR_H
 #define _XTENSA_COPROCESSOR_H
 
-#include <xtensa/config/core.h>
+#include <asm/variant/core.h>
+#include <asm/variant/tie.h>
+
+#if !XCHAL_HAVE_CP
+
+#define XTENSA_CP_EXTRA_OFFSET 	0
+#define XTENSA_CP_EXTRA_ALIGN	1	/* must be a power of 2 */
+#define XTENSA_CP_EXTRA_SIZE	0
+
+#else
 
 #define XTOFS(last_start,last_size,align) \
 	((last_start+last_size+align-1) & -align)
@@ -67,4 +76,6 @@ extern void save_coprocessor_registers(v
 # endif
 #endif
 
+#endif
+
 #endif	/* _XTENSA_COPROCESSOR_H */
diff -puN include/asm-xtensa/dma.h~xtensa-remove-extra-header-files include/asm-xtensa/dma.h
--- a/include/asm-xtensa/dma.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/dma.h
@@ -12,7 +12,6 @@
 #define _XTENSA_DMA_H
 
 #include <asm/io.h>		/* need byte IO */
-#include <xtensa/config/core.h>
 
 /*
  * This is only to be defined if we have PC-like DMA.
@@ -44,7 +43,9 @@
  *	enters another area, and virt_to_phys() may not return
  *	the value desired).
  */
-#define MAX_DMA_ADDRESS		(PAGE_OFFSET + XCHAL_KSEG_CACHED_SIZE - 1)
+
+#define MAX_DMA_ADDRESS		(PAGE_OFFSET + XCHAL_KIO_SIZE - 1)
+
 
 /* Reserve and release a DMA channel */
 extern int request_dma(unsigned int dmanr, const char * device_id);
diff -puN include/asm-xtensa/elf.h~xtensa-remove-extra-header-files include/asm-xtensa/elf.h
--- a/include/asm-xtensa/elf.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/elf.h
@@ -13,9 +13,8 @@
 #ifndef _XTENSA_ELF_H
 #define _XTENSA_ELF_H
 
+#include <asm/variant/core.h>
 #include <asm/ptrace.h>
-#include <asm/coprocessor.h>
-#include <xtensa/config/core.h>
 
 /* Xtensa processor ELF architecture-magic number */
 
@@ -118,11 +117,15 @@ typedef elf_greg_t elf_gregset_t[ELF_NGR
  * using memcpy().  But we do allow space for such alignment,
  * to allow optimizations of layout and copying.
  */
-
+#if 0
 #define TOTAL_FPREGS_SIZE						\
   	(4 + XTENSA_CPE_LTABLE_SIZE + XTENSA_CP_EXTRA_SIZE)
 #define ELF_NFPREG							\
 	((TOTAL_FPREGS_SIZE + sizeof(elf_fpreg_t) - 1) / sizeof(elf_fpreg_t))
+#else
+#define TOTAL_FPREGS_SIZE	0
+#define ELF_NFPREG		0
+#endif
 
 typedef unsigned int elf_fpreg_t;
 typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
diff -puN include/asm-xtensa/fixmap.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/fixmap.h
+++ /dev/null
@@ -1,252 +0,0 @@
-/*
- * include/asm-xtensa/fixmap.h
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- */
-
-#ifndef _XTENSA_FIXMAP_H
-#define _XTENSA_FIXMAP_H
-
-#include <asm/processor.h>
-
-#ifdef CONFIG_MMU
-
-/*
- * Here we define all the compile-time virtual addresses.
- */
-
-#if XCHAL_SEG_MAPPABLE_VADDR != 0
-# error "Current port requires virtual user space starting at 0"
-#endif
-#if XCHAL_SEG_MAPPABLE_SIZE < 0x80000000
-# error "Current port requires at least 0x8000000 bytes for user space"
-#endif
-
-/* Verify instruction/data ram/rom and xlmi don't overlay vmalloc space. */
-
-#define __IN_VMALLOC(addr)						\
-	(((addr) >= VMALLOC_START) && ((addr) < VMALLOC_END))
-#define __SPAN_VMALLOC(start,end)					\
-	(((start) < VMALLOC_START) && ((end) >= VMALLOC_END))
-#define INSIDE_VMALLOC(start,end) 					\
-	(__IN_VMALLOC((start)) || __IN_VMALLOC(end) || __SPAN_VMALLOC((start),(end)))
-
-#if XCHAL_NUM_INSTROM
-# if XCHAL_NUM_INSTROM == 1
-#  if INSIDE_VMALLOC(XCHAL_INSTROM0_VADDR,XCHAL_INSTROM0_VADDR+XCHAL_INSTROM0_SIZE)
-#   error vmalloc range conflicts with instrom0
-#  endif
-# endif
-# if XCHAL_NUM_INSTROM == 2
-#  if INSIDE_VMALLOC(XCHAL_INSTROM1_VADDR,XCHAL_INSTROM1_VADDR+XCHAL_INSTROM1_SIZE)
-#   error vmalloc range conflicts with instrom1
-#  endif
-# endif
-#endif
-
-#if XCHAL_NUM_INSTRAM
-# if XCHAL_NUM_INSTRAM == 1
-#  if INSIDE_VMALLOC(XCHAL_INSTRAM0_VADDR,XCHAL_INSTRAM0_VADDR+XCHAL_INSTRAM0_SIZE)
-#   error vmalloc range conflicts with instram0
-#  endif
-# endif
-# if XCHAL_NUM_INSTRAM == 2
-#  if INSIDE_VMALLOC(XCHAL_INSTRAM1_VADDR,XCHAL_INSTRAM1_VADDR+XCHAL_INSTRAM1_SIZE)
-#   error vmalloc range conflicts with instram1
-#  endif
-# endif
-#endif
-
-#if XCHAL_NUM_DATAROM
-# if XCHAL_NUM_DATAROM == 1
-#  if INSIDE_VMALLOC(XCHAL_DATAROM0_VADDR,XCHAL_DATAROM0_VADDR+XCHAL_DATAROM0_SIZE)
-#   error vmalloc range conflicts with datarom0
-#  endif
-# endif
-# if XCHAL_NUM_DATAROM == 2
-#  if INSIDE_VMALLOC(XCHAL_DATAROM1_VADDR,XCHAL_DATAROM1_VADDR+XCHAL_DATAROM1_SIZE)
-#   error vmalloc range conflicts with datarom1
-#  endif
-# endif
-#endif
-
-#if XCHAL_NUM_DATARAM
-# if XCHAL_NUM_DATARAM == 1
-#  if INSIDE_VMALLOC(XCHAL_DATARAM0_VADDR,XCHAL_DATARAM0_VADDR+XCHAL_DATARAM0_SIZE)
-#   error vmalloc range conflicts with dataram0
-#  endif
-# endif
-# if XCHAL_NUM_DATARAM == 2
-#  if INSIDE_VMALLOC(XCHAL_DATARAM1_VADDR,XCHAL_DATARAM1_VADDR+XCHAL_DATARAM1_SIZE)
-#   error vmalloc range conflicts with dataram1
-#  endif
-# endif
-#endif
-
-#if XCHAL_NUM_XLMI
-# if XCHAL_NUM_XLMI == 1
-#  if INSIDE_VMALLOC(XCHAL_XLMI0_VADDR,XCHAL_XLMI0_VADDR+XCHAL_XLMI0_SIZE)
-#   error vmalloc range conflicts with xlmi0
-#  endif
-# endif
-# if XCHAL_NUM_XLMI == 2
-#  if INSIDE_VMALLOC(XCHAL_XLMI1_VADDR,XCHAL_XLMI1_VADDR+XCHAL_XLMI1_SIZE)
-#   error vmalloc range conflicts with xlmi1
-#  endif
-# endif
-#endif
-
-#if (XCHAL_NUM_INSTROM > 2) || \
-    (XCHAL_NUM_INSTRAM > 2) || \
-    (XCHAL_NUM_DATARAM > 2) || \
-    (XCHAL_NUM_DATAROM > 2) || \
-    (XCHAL_NUM_XLMI    > 2)
-# error Insufficient checks on vmalloc above for more than 2 devices
-#endif
-
-/*
- * USER_VM_SIZE does not necessarily equal TASK_SIZE.  We bumped
- * TASK_SIZE down to 0x4000000 to simplify the handling of windowed
- * call instructions (currently limited to a range of 1 GByte).  User
- * tasks may very well reclaim the VM space from 0x40000000 to
- * 0x7fffffff in the future, so we do not want the kernel becoming
- * accustomed to having any of its stuff (e.g., page tables) in this
- * region.  This VM region is no-man's land for now.
- */
-
-#define USER_VM_START		XCHAL_SEG_MAPPABLE_VADDR
-#define USER_VM_SIZE		0x80000000
-
-/*  Size of page table:  */
-
-#define PGTABLE_SIZE_BITS	(32 - XCHAL_MMU_MIN_PTE_PAGE_SIZE + 2)
-#define PGTABLE_SIZE		(1L << PGTABLE_SIZE_BITS)
-
-/*  All kernel-mappable space:  */
-
-#define KERNEL_ALLMAP_START	(USER_VM_START + USER_VM_SIZE)
-#define KERNEL_ALLMAP_SIZE	(XCHAL_SEG_MAPPABLE_SIZE - KERNEL_ALLMAP_START)
-
-/*  Carve out page table at start of kernel-mappable area:  */
-
-#if KERNEL_ALLMAP_SIZE < PGTABLE_SIZE
-#error "Gimme some space for page table!"
-#endif
-#define PGTABLE_START		KERNEL_ALLMAP_START
-
-/*  Remaining kernel-mappable space:  */
-
-#define KERNEL_MAPPED_START	(KERNEL_ALLMAP_START + PGTABLE_SIZE)
-#define KERNEL_MAPPED_SIZE	(KERNEL_ALLMAP_SIZE - PGTABLE_SIZE)
-
-#if KERNEL_MAPPED_SIZE < 0x01000000	/* 16 MB is arbitrary for now */
-# error "Shouldn't the kernel have at least *some* mappable space?"
-#endif
-
-#define MAX_LOW_MEMORY		XCHAL_KSEG_CACHED_SIZE
-
-#endif
-
-/*
- *  Some constants used elsewhere, but perhaps only in Xtensa header
- *  files, so maybe we can get rid of some and access compile-time HAL
- *  directly...
- *
- *  Note:  We assume that system RAM is located at the very start of the
- *  	   kernel segments !!
- */
-#define KERNEL_VM_LOW           XCHAL_KSEG_CACHED_VADDR
-#define KERNEL_VM_HIGH          XCHAL_KSEG_BYPASS_VADDR
-#define KERNEL_SPACE            XCHAL_KSEG_CACHED_VADDR
-
-/*
- * Returns the physical/virtual addresses of the kernel space
- * (works with the cached kernel segment only, which is the
- *  one normally used for kernel operation).
- */
-
-/*			PHYSICAL	BYPASS		CACHED
- *
- *  bypass vaddr	bypass paddr	*		cached vaddr
- *  cached vaddr	cached paddr	bypass vaddr	*
- *  bypass paddr	*		bypass vaddr	cached vaddr
- *  cached paddr	*		bypass vaddr	cached vaddr
- *  other		*		*		*
- */
-
-#define PHYSADDR(a)							      \
-(((unsigned)(a) >= XCHAL_KSEG_BYPASS_VADDR				      \
-  && (unsigned)(a) < XCHAL_KSEG_BYPASS_VADDR + XCHAL_KSEG_BYPASS_SIZE) ?      \
-    (unsigned)(a) - XCHAL_KSEG_BYPASS_VADDR + XCHAL_KSEG_BYPASS_PADDR :       \
-    ((unsigned)(a) >= XCHAL_KSEG_CACHED_VADDR				      \
-     && (unsigned)(a) < XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_CACHED_SIZE) ?   \
-        (unsigned)(a) - XCHAL_KSEG_CACHED_VADDR + XCHAL_KSEG_CACHED_PADDR :   \
-	(unsigned)(a))
-
-#define BYPASS_ADDR(a)							      \
-(((unsigned)(a) >= XCHAL_KSEG_BYPASS_PADDR				      \
-  && (unsigned)(a) < XCHAL_KSEG_BYPASS_PADDR + XCHAL_KSEG_BYPASS_SIZE) ?      \
-    (unsigned)(a) - XCHAL_KSEG_BYPASS_PADDR + XCHAL_KSEG_BYPASS_VADDR :       \
-    ((unsigned)(a) >= XCHAL_KSEG_CACHED_PADDR				      \
-     && (unsigned)(a) < XCHAL_KSEG_CACHED_PADDR + XCHAL_KSEG_CACHED_SIZE) ?   \
-        (unsigned)(a) - XCHAL_KSEG_CACHED_PADDR + XCHAL_KSEG_BYPASS_VADDR :   \
-        ((unsigned)(a) >= XCHAL_KSEG_CACHED_VADDR			      \
-         && (unsigned)(a) < XCHAL_KSEG_CACHED_VADDR+XCHAL_KSEG_CACHED_SIZE)?  \
-            (unsigned)(a) - XCHAL_KSEG_CACHED_VADDR+XCHAL_KSEG_BYPASS_VADDR:  \
-	    (unsigned)(a))
-
-#define CACHED_ADDR(a)							      \
-(((unsigned)(a) >= XCHAL_KSEG_BYPASS_PADDR				      \
-  && (unsigned)(a) < XCHAL_KSEG_BYPASS_PADDR + XCHAL_KSEG_BYPASS_SIZE) ?      \
-    (unsigned)(a) - XCHAL_KSEG_BYPASS_PADDR + XCHAL_KSEG_CACHED_VADDR :       \
-    ((unsigned)(a) >= XCHAL_KSEG_CACHED_PADDR			              \
-     && (unsigned)(a) < XCHAL_KSEG_CACHED_PADDR + XCHAL_KSEG_CACHED_SIZE) ?   \
-        (unsigned)(a) - XCHAL_KSEG_CACHED_PADDR + XCHAL_KSEG_CACHED_VADDR :   \
-        ((unsigned)(a) >= XCHAL_KSEG_BYPASS_VADDR			      \
-         && (unsigned)(a) < XCHAL_KSEG_BYPASS_VADDR+XCHAL_KSEG_BYPASS_SIZE) ? \
-            (unsigned)(a) - XCHAL_KSEG_BYPASS_VADDR+XCHAL_KSEG_CACHED_VADDR : \
-	    (unsigned)(a))
-
-#define PHYSADDR_IO(a)							      \
-(((unsigned)(a) >= XCHAL_KIO_BYPASS_VADDR				      \
-  && (unsigned)(a) < XCHAL_KIO_BYPASS_VADDR + XCHAL_KIO_BYPASS_SIZE) ?	      \
-    (unsigned)(a) - XCHAL_KIO_BYPASS_VADDR + XCHAL_KIO_BYPASS_PADDR :	      \
-    ((unsigned)(a) >= XCHAL_KIO_CACHED_VADDR				      \
-     && (unsigned)(a) < XCHAL_KIO_CACHED_VADDR + XCHAL_KIO_CACHED_SIZE) ?     \
-        (unsigned)(a) - XCHAL_KIO_CACHED_VADDR + XCHAL_KIO_CACHED_PADDR :     \
-	(unsigned)(a))
-
-#define BYPASS_ADDR_IO(a)						      \
-(((unsigned)(a) >= XCHAL_KIO_BYPASS_PADDR				      \
-  && (unsigned)(a) < XCHAL_KIO_BYPASS_PADDR + XCHAL_KIO_BYPASS_SIZE) ?	      \
-    (unsigned)(a) - XCHAL_KIO_BYPASS_PADDR + XCHAL_KIO_BYPASS_VADDR :	      \
-    ((unsigned)(a) >= XCHAL_KIO_CACHED_PADDR				      \
-     && (unsigned)(a) < XCHAL_KIO_CACHED_PADDR + XCHAL_KIO_CACHED_SIZE) ?     \
-        (unsigned)(a) - XCHAL_KIO_CACHED_PADDR + XCHAL_KIO_BYPASS_VADDR :     \
-        ((unsigned)(a) >= XCHAL_KIO_CACHED_VADDR			      \
-         && (unsigned)(a) < XCHAL_KIO_CACHED_VADDR + XCHAL_KIO_CACHED_SIZE) ? \
-            (unsigned)(a) - XCHAL_KIO_CACHED_VADDR + XCHAL_KIO_BYPASS_VADDR : \
-	    (unsigned)(a))
-
-#define CACHED_ADDR_IO(a)						      \
-(((unsigned)(a) >= XCHAL_KIO_BYPASS_PADDR				      \
-  && (unsigned)(a) < XCHAL_KIO_BYPASS_PADDR + XCHAL_KIO_BYPASS_SIZE) ?	      \
-    (unsigned)(a) - XCHAL_KIO_BYPASS_PADDR + XCHAL_KIO_CACHED_VADDR :	      \
-    ((unsigned)(a) >= XCHAL_KIO_CACHED_PADDR				      \
-     && (unsigned)(a) < XCHAL_KIO_CACHED_PADDR + XCHAL_KIO_CACHED_SIZE) ?     \
-        (unsigned)(a) - XCHAL_KIO_CACHED_PADDR + XCHAL_KIO_CACHED_VADDR :     \
-        ((unsigned)(a) >= XCHAL_KIO_BYPASS_VADDR			      \
-         && (unsigned)(a) < XCHAL_KIO_BYPASS_VADDR + XCHAL_KIO_BYPASS_SIZE) ? \
-            (unsigned)(a) - XCHAL_KIO_BYPASS_VADDR + XCHAL_KIO_CACHED_VADDR : \
-	    (unsigned)(a))
-
-#endif /* _XTENSA_ADDRSPACE_H */
-
-
-
-
-
diff -puN include/asm-xtensa/io.h~xtensa-remove-extra-header-files include/asm-xtensa/io.h
--- a/include/asm-xtensa/io.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/io.h
@@ -1,5 +1,5 @@
 /*
- * linux/include/asm-xtensa/io.h
+ * include/asm-xtensa/io.h
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
@@ -15,10 +15,11 @@
 #include <asm/byteorder.h>
 
 #include <linux/types.h>
-#include <asm/fixmap.h>
-
-#define _IO_BASE 0
 
+#define XCHAL_KIO_CACHED_VADDR	0xf0000000
+#define XCHAL_KIO_BYPASS_VADDR	0xf8000000
+#define XCHAL_KIO_PADDR		0xf0000000
+#define XCHAL_KIO_SIZE		0x08000000
 
 /*
  * swap functions to change byte order from little-endian to big-endian and
@@ -42,40 +43,43 @@ static inline unsigned int _swapl (unsig
 
 static inline unsigned long virt_to_phys(volatile void * address)
 {
-	return PHYSADDR((unsigned long)address);
+	return __pa(address);
 }
 
 static inline void * phys_to_virt(unsigned long address)
 {
-	return (void*) CACHED_ADDR(address);
+	return __va(address);
 }
 
 /*
- * IO bus memory addresses are also 1:1 with the physical address
+ * virt_to_bus and bus_to_virt are deprecated.
  */
 
-static inline unsigned long virt_to_bus(volatile void * address)
-{
-	return PHYSADDR((unsigned long)address);
-}
-
-static inline void * bus_to_virt (unsigned long address)
-{
-	return (void *) CACHED_ADDR(address);
-}
+#define virt_to_bus(x)	virt_to_phys(x)
+#define bus_to_virt(x)	phys_to_virt(x)
 
 /*
- * Change "struct page" to physical address.
+ * Return the virtual (cached) address for the specified bus memory.
+ * Note that we currently don't support any address outside the KIO segment.
  */
 
 static inline void *ioremap(unsigned long offset, unsigned long size)
 {
-        return (void *) CACHED_ADDR_IO(offset);
+	if (offset >= XCHAL_KIO_PADDR
+	    && offset < XCHAL_KIO_PADDR + XCHAL_KIO_SIZE)
+		return (void*)(offset-XCHAL_KIO_PADDR+XCHAL_KIO_BYPASS_VADDR);
+
+	else
+		BUG();
 }
 
 static inline void *ioremap_nocache(unsigned long offset, unsigned long size)
 {
-        return (void *) BYPASS_ADDR_IO(offset);
+	if (offset >= XCHAL_KIO_PADDR
+	    && offset < XCHAL_KIO_PADDR + XCHAL_KIO_SIZE)
+		return (void*)(offset-XCHAL_KIO_PADDR+XCHAL_KIO_CACHED_VADDR);
+	else
+		BUG();
 }
 
 static inline void iounmap(void *addr)
@@ -121,9 +125,6 @@ static inline void __raw_writel(__u32 b,
           *(__force volatile __u32 *)(addr) = b;
 }
 
-
-
-
 /* These are the definitions for the x86 IO instructions
  * inb/inw/inl/outb/outw/outl, the "string" versions
  * insb/insw/insl/outsb/outsw/outsl, and the "pausing" versions
@@ -131,11 +132,11 @@ static inline void __raw_writel(__u32 b,
  * The macros don't do byte-swapping.
  */
 
-#define inb(port)		readb((u8 *)((port)+_IO_BASE))
-#define outb(val, port)		writeb((val),(u8 *)((unsigned long)(port)+_IO_BASE))
-#define inw(port)		readw((u16 *)((port)+_IO_BASE))
-#define outw(val, port)		writew((val),(u16 *)((unsigned long)(port)+_IO_BASE))
-#define inl(port)		readl((u32 *)((port)+_IO_BASE))
+#define inb(port)		readb((u8 *)((port)))
+#define outb(val, port)		writeb((val),(u8 *)((unsigned long)(port)))
+#define inw(port)		readw((u16 *)((port)))
+#define outw(val, port)		writew((val),(u16 *)((unsigned long)(port)))
+#define inl(port)		readl((u32 *)((port)))
 #define outl(val, port)		writel((val),(u32 *)((unsigned long)(port)))
 
 #define inb_p(port)		inb((port))
@@ -180,14 +181,13 @@ extern void outsl (unsigned long port, c
 
 
 /*
- *  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- *   * access
- *    */
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem access
+ */
 #define xlate_dev_mem_ptr(p)    __va(p)
 
 /*
- *  * Convert a virtual cached pointer to an uncached pointer
- *   */
+ * Convert a virtual cached pointer to an uncached pointer
+ */
 #define xlate_dev_kmem_ptr(p)   p
 
 
diff -puN include/asm-xtensa/irq.h~xtensa-remove-extra-header-files include/asm-xtensa/irq.h
--- a/include/asm-xtensa/irq.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/irq.h
@@ -12,8 +12,7 @@
 #define _XTENSA_IRQ_H
 
 #include <asm/platform/hardware.h>
-
-#include <xtensa/config/core.h>
+#include <asm/variant/core.h>
 
 #ifndef PLATFORM_NR_IRQS
 # define PLATFORM_NR_IRQS 0
@@ -27,10 +26,5 @@ static __inline__ int irq_canonicalize(i
 }
 
 struct irqaction;
-#if 0 // FIXME
-extern void disable_irq_nosync(unsigned int);
-extern void disable_irq(unsigned int);
-extern void enable_irq(unsigned int);
-#endif
 
 #endif	/* _XTENSA_IRQ_H */
diff -puN include/asm-xtensa/mmu_context.h~xtensa-remove-extra-header-files include/asm-xtensa/mmu_context.h
--- a/include/asm-xtensa/mmu_context.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/mmu_context.h
@@ -16,187 +16,32 @@
 #include <linux/stringify.h>
 
 #include <asm/pgtable.h>
-#include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-/*
- * Linux was ported to Xtensa assuming all auto-refill ways in set 0
- * had the same properties (a very likely assumption).  Multiple sets
- * of auto-refill ways will still work properly, but not as optimally
- * as the Xtensa designer may have assumed.
- *
- * We make this case a hard #error, killing the kernel build, to alert
- * the developer to this condition (which is more likely an error).
- * You super-duper clever developers can change it to a warning or
- * remove it altogether if you think you know what you're doing.  :)
- */
+#define XCHAL_MMU_ASID_BITS	8
 
 #if (XCHAL_HAVE_TLBS != 1)
 # error "Linux must have an MMU!"
 #endif
 
-#if ((XCHAL_ITLB_ARF_WAYS == 0) || (XCHAL_DTLB_ARF_WAYS == 0))
-# error "MMU must have auto-refill ways"
-#endif
-
-#if ((XCHAL_ITLB_ARF_SETS != 1) || (XCHAL_DTLB_ARF_SETS != 1))
-# error Linux may not use all auto-refill ways as efficiently as you think
-#endif
-
-#if (XCHAL_MMU_MAX_PTE_PAGE_SIZE != XCHAL_MMU_MIN_PTE_PAGE_SIZE)
-# error Only one page size allowed!
-#endif
-
 extern unsigned long asid_cache;
-extern pgd_t *current_pgd;
-
-/*
- * Define the number of entries per auto-refill way in set 0 of both I and D
- * TLBs.  We deal only with set 0 here (an assumption further explained in
- * assertions.h).  Also, define the total number of ARF entries in both TLBs.
- */
-
-#define ITLB_ENTRIES_PER_ARF_WAY  (XCHAL_ITLB_SET(XCHAL_ITLB_ARF_SET0,ENTRIES))
-#define DTLB_ENTRIES_PER_ARF_WAY  (XCHAL_DTLB_SET(XCHAL_DTLB_ARF_SET0,ENTRIES))
-
-#define ITLB_ENTRIES							\
- 	(ITLB_ENTRIES_PER_ARF_WAY * (XCHAL_ITLB_SET(XCHAL_ITLB_ARF_SET0,WAYS)))
-#define DTLB_ENTRIES							\
-	(DTLB_ENTRIES_PER_ARF_WAY * (XCHAL_DTLB_SET(XCHAL_DTLB_ARF_SET0,WAYS)))
-
-
-/*
- * SMALLEST_NTLB_ENTRIES is the smaller of ITLB_ENTRIES and DTLB_ENTRIES.
- * In practice, they are probably equal.  This macro simplifies function
- * flush_tlb_range().
- */
-
-#if (DTLB_ENTRIES < ITLB_ENTRIES)
-# define SMALLEST_NTLB_ENTRIES  DTLB_ENTRIES
-#else
-# define SMALLEST_NTLB_ENTRIES  ITLB_ENTRIES
-#endif
-
-
-/*
- * asid_cache tracks only the ASID[USER_RING] field of the RASID special
- * register, which is the current user-task asid allocation value.
- * mm->context has the same meaning.  When it comes time to write the
- * asid_cache or mm->context values to the RASID special register, we first
- * shift the value left by 8, then insert the value.
- * ASID[0] always contains the kernel's asid value, and we reserve three
- * other asid values that we never assign to user tasks.
- */
-
-#define ASID_INC	0x1
-#define ASID_MASK	((1 << XCHAL_MMU_ASID_BITS) - 1)
-
-/*
- * XCHAL_MMU_ASID_INVALID is a configurable Xtensa processor constant
- * indicating invalid address space.  XCHAL_MMU_ASID_KERNEL is a configurable
- * Xtensa processor constant indicating the kernel address space.  They can
- * be arbitrary values.
- *
- * We identify three more unique, reserved ASID values to use in the unused
- * ring positions.  No other user process will be assigned these reserved
- * ASID values.
- *
- * For example, given that
- *
- *	XCHAL_MMU_ASID_INVALID == 0
- *	XCHAL_MMU_ASID_KERNEL  == 1
- *
- * the following maze of #if statements would generate
- *
- *	ASID_RESERVED_1        == 2
- *	ASID_RESERVED_2        == 3
- *	ASID_RESERVED_3        == 4
- *	ASID_FIRST_NONRESERVED == 5
- */
-
-#if (XCHAL_MMU_ASID_INVALID != XCHAL_MMU_ASID_KERNEL + 1)
-# define ASID_RESERVED_1         ((XCHAL_MMU_ASID_KERNEL + 1) & ASID_MASK)
-#else
-# define ASID_RESERVED_1         ((XCHAL_MMU_ASID_KERNEL + 2) & ASID_MASK)
-#endif
-
-#if (XCHAL_MMU_ASID_INVALID != ASID_RESERVED_1 + 1)
-# define ASID_RESERVED_2         ((ASID_RESERVED_1 + 1) & ASID_MASK)
-#else
-# define ASID_RESERVED_2         ((ASID_RESERVED_1 + 2) & ASID_MASK)
-#endif
-
-#if (XCHAL_MMU_ASID_INVALID != ASID_RESERVED_2 + 1)
-# define ASID_RESERVED_3         ((ASID_RESERVED_2 + 1) & ASID_MASK)
-#else
-# define ASID_RESERVED_3         ((ASID_RESERVED_2 + 2) & ASID_MASK)
-#endif
-
-#if (XCHAL_MMU_ASID_INVALID != ASID_RESERVED_3 + 1)
-# define ASID_FIRST_NONRESERVED  ((ASID_RESERVED_3 + 1) & ASID_MASK)
-#else
-# define ASID_FIRST_NONRESERVED  ((ASID_RESERVED_3 + 2) & ASID_MASK)
-#endif
-
-#define ASID_ALL_RESERVED ( ((ASID_RESERVED_1) << 24) + \
-                            ((ASID_RESERVED_2) << 16) + \
-                            ((ASID_RESERVED_3) <<  8) + \
-                            ((XCHAL_MMU_ASID_KERNEL))   )
-
 
 /*
  * NO_CONTEXT is the invalid ASID value that we don't ever assign to
- * any user or kernel context.  NO_CONTEXT is a better mnemonic than
- * XCHAL_MMU_ASID_INVALID, so we use it in code instead.
- */
-
-#define NO_CONTEXT   XCHAL_MMU_ASID_INVALID
-
-#if (KERNEL_RING != 0)
-# error The KERNEL_RING really should be zero.
-#endif
-
-#if (USER_RING >= XCHAL_MMU_RINGS)
-# error USER_RING cannot be greater than the highest numbered ring.
-#endif
-
-#if (USER_RING == KERNEL_RING)
-# error The user and kernel rings really should not be equal.
-#endif
-
-#if (USER_RING == 1)
-#define ASID_INSERT(x) ( ((ASID_RESERVED_1)   << 24) + \
-                         ((ASID_RESERVED_2)   << 16) + \
-                         (((x) & (ASID_MASK)) <<  8) + \
-                         ((XCHAL_MMU_ASID_KERNEL))   )
-
-#elif (USER_RING == 2)
-#define ASID_INSERT(x) ( ((ASID_RESERVED_1)   << 24) + \
-                         (((x) & (ASID_MASK)) << 16) + \
-                         ((ASID_RESERVED_2)   <<  8) + \
-                         ((XCHAL_MMU_ASID_KERNEL))   )
-
-#elif (USER_RING == 3)
-#define ASID_INSERT(x) ( (((x) & (ASID_MASK)) << 24) + \
-			 ((ASID_RESERVED_1)   << 16) + \
-                         ((ASID_RESERVED_2)   <<  8) + \
-                         ((XCHAL_MMU_ASID_KERNEL))   )
-
-#else
-#error Goofy value for USER_RING
-
-#endif /* USER_RING == 1 */
-
-
-/*
- *  All unused by hardware upper bits will be considered
- *  as a software asid extension.
+ * any user or kernel context.
+ *
+ * 0 invalid
+ * 1 kernel
+ * 2 reserved
+ * 3 reserved
+ * 4...255 available
  */
 
-#define ASID_VERSION_MASK  ((unsigned long)~(ASID_MASK|(ASID_MASK-1)))
-#define ASID_FIRST_VERSION						\
-	((unsigned long)(~ASID_VERSION_MASK) + 1 + ASID_FIRST_NONRESERVED)
+#define NO_CONTEXT	0
+#define ASID_USER_FIRST	4
+#define ASID_MASK	((1 << XCHAL_MMU_ASID_BITS) - 1)
+#define ASID_INSERT(x)	(0x03020001 | (((x) & ASID_MASK) << 8))
 
 static inline void set_rasid_register (unsigned long val)
 {
@@ -207,67 +52,28 @@ static inline void set_rasid_register (u
 static inline unsigned long get_rasid_register (void)
 {
 	unsigned long tmp;
-	__asm__ __volatile__ (" rsr %0, "__stringify(RASID)"\n\t" : "=a" (tmp));
+	__asm__ __volatile__ (" rsr %0,"__stringify(RASID)"\n\t" : "=a" (tmp));
 	return tmp;
 }
 
-
-#if ((XCHAL_MMU_ASID_INVALID == 0) && (XCHAL_MMU_ASID_KERNEL == 1))
-
 static inline void
-get_new_mmu_context(struct mm_struct *mm, unsigned long asid)
+__get_new_mmu_context(struct mm_struct *mm)
 {
 	extern void flush_tlb_all(void);
-	if (! ((asid += ASID_INC) & ASID_MASK) ) {
+	if (! (++asid_cache & ASID_MASK) ) {
 		flush_tlb_all(); /* start new asid cycle */
-		if (!asid)      /* fix version if needed */
-			asid = ASID_FIRST_VERSION - ASID_FIRST_NONRESERVED;
-		asid += ASID_FIRST_NONRESERVED;
+		asid_cache += ASID_USER_FIRST;
 	}
-	mm->context = asid_cache = asid;
-}
-
-#else
-#warning ASID_{INVALID,KERNEL} values impose non-optimal get_new_mmu_context implementation
-
-/* XCHAL_MMU_ASID_INVALID == 0 and XCHAL_MMU_ASID_KERNEL ==1 are
-   really the best, but if you insist... */
-
-static inline int validate_asid (unsigned long asid)
-{
-	switch (asid) {
-	case XCHAL_MMU_ASID_INVALID:
-	case XCHAL_MMU_ASID_KERNEL:
-	case ASID_RESERVED_1:
-	case ASID_RESERVED_2:
-	case ASID_RESERVED_3:
-		return 0; /* can't use these values as ASIDs */
-	}
-	return 1; /* valid */
+	mm->context = asid_cache;
 }
 
 static inline void
-get_new_mmu_context(struct mm_struct *mm, unsigned long asid)
+__load_mmu_context(struct mm_struct *mm)
 {
-	extern void flush_tlb_all(void);
-	while (1) {
-		asid += ASID_INC;
-		if ( ! (asid & ASID_MASK) ) {
-			flush_tlb_all(); /* start new asid cycle */
-			if (!asid)      /* fix version if needed */
-				asid = ASID_FIRST_VERSION - ASID_FIRST_NONRESERVED;
-			asid += ASID_FIRST_NONRESERVED;
-			break; /* no need to validate here */
-		}
-		if (validate_asid (asid & ASID_MASK))
-			break;
-	}
-	mm->context = asid_cache = asid;
+	set_rasid_register(ASID_INSERT(mm->context));
+	invalidate_page_directory();
 }
 
-#endif
-
-
 /*
  * Initialize the context related info for a new mm_struct
  * instance.
@@ -280,6 +86,20 @@ init_new_context(struct task_struct *tsk
 	return 0;
 }
 
+/*
+ * After we have set current->mm to a new value, this activates
+ * the context for the new mm so we see the new mappings.
+ */
+static inline void
+activate_mm(struct mm_struct *prev, struct mm_struct *next)
+{
+	/* Unconditionally get a new ASID.  */
+
+	__get_new_mmu_context(next);
+	__load_mmu_context(next);
+}
+
+
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
                              struct task_struct *tsk)
 {
@@ -287,11 +107,10 @@ static inline void switch_mm(struct mm_s
 
 	/* Check if our ASID is of an older version and thus invalid */
 
-	if ((next->context ^ asid) & ASID_VERSION_MASK)
-		get_new_mmu_context(next, asid);
+	if (next->context == NO_CONTEXT || ((next->context^asid) & ~ASID_MASK))
+		__get_new_mmu_context(next);
 
-	set_rasid_register (ASID_INSERT(next->context));
-	invalidate_page_directory();
+	__load_mmu_context(next);
 }
 
 #define deactivate_mm(tsk, mm)	do { } while(0)
@@ -302,20 +121,6 @@ static inline void switch_mm(struct mm_s
  */
 static inline void destroy_context(struct mm_struct *mm)
 {
-	/* Nothing to do. */
-}
-
-/*
- * After we have set current->mm to a new value, this activates
- * the context for the new mm so we see the new mappings.
- */
-static inline void
-activate_mm(struct mm_struct *prev, struct mm_struct *next)
-{
-	/* Unconditionally get a new ASID.  */
-
-	get_new_mmu_context(next, asid_cache);
-	set_rasid_register (ASID_INSERT(next->context));
 	invalidate_page_directory();
 }
 
diff -puN include/asm-xtensa/page.h~xtensa-remove-extra-header-files include/asm-xtensa/page.h
--- a/include/asm-xtensa/page.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/page.h
@@ -15,18 +15,24 @@
 
 #include <asm/processor.h>
 
+#define XCHAL_KSEG_CACHED_VADDR 0xd0000000
+#define XCHAL_KSEG_BYPASS_VADDR 0xd8000000
+#define XCHAL_KSEG_PADDR        0x00000000
+#define XCHAL_KSEG_SIZE         0x08000000
+
 /*
  * PAGE_SHIFT determines the page size
  * PAGE_ALIGN(x) aligns the pointer to the (next) page boundary
  */
 
-#define PAGE_SHIFT		XCHAL_MMU_MIN_PTE_PAGE_SIZE
+#define PAGE_SHIFT		12
 #define PAGE_SIZE		(1 << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 #define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE - 1) & PAGE_MASK)
 
-#define DCACHE_WAY_SIZE		(XCHAL_DCACHE_SIZE / XCHAL_DCACHE_WAYS)
 #define PAGE_OFFSET		XCHAL_KSEG_CACHED_VADDR
+#define MAX_MEM_PFN             XCHAL_KSEG_SIZE
+#define PGTABLE_START           0x80000000
 
 #ifdef __ASSEMBLY__
 
diff -puN include/asm-xtensa/param.h~xtensa-remove-extra-header-files include/asm-xtensa/param.h
--- a/include/asm-xtensa/param.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/param.h
@@ -11,7 +11,7 @@
 #ifndef _XTENSA_PARAM_H
 #define _XTENSA_PARAM_H
 
-#include <xtensa/config/core.h>
+#include <asm/variant/core.h>
 
 #ifdef __KERNEL__
 # define HZ		100		/* internal timer frequency */
diff -puN include/asm-xtensa/pgtable.h~xtensa-remove-extra-header-files include/asm-xtensa/pgtable.h
--- a/include/asm-xtensa/pgtable.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/pgtable.h
@@ -14,45 +14,6 @@
 #include <asm-generic/pgtable-nopmd.h>
 #include <asm/page.h>
 
-/* Assertions. */
-
-#ifdef CONFIG_MMU
-
-
-#if (XCHAL_MMU_RINGS < 2)
-# error Linux build assumes at least 2 ring levels.
-#endif
-
-#if (XCHAL_MMU_CA_BITS != 4)
-# error We assume exactly four bits for CA.
-#endif
-
-#if (XCHAL_MMU_SR_BITS != 0)
-# error We have no room for SR bits.
-#endif
-
-/*
- * Use the first min-wired way for mapping page-table pages.
- * Page coloring requires a second min-wired way.
- */
-
-#if (XCHAL_DTLB_MINWIRED_SETS == 0)
-# error Need a min-wired way for mapping page-table pages
-#endif
-
-#define DTLB_WAY_PGTABLE XCHAL_DTLB_SET(XCHAL_DTLB_MINWIRED_SET0, WAY)
-
-#if (DCACHE_WAY_SIZE > PAGE_SIZE) && XCHAL_DCACHE_IS_WRITEBACK
-# if XCHAL_DTLB_SET(XCHAL_DTLB_MINWIRED_SET0, WAYS) >= 2
-#  define DTLB_WAY_DCACHE_ALIAS0 (DTLB_WAY_PGTABLE + 1)
-#  define DTLB_WAY_DCACHE_ALIAS1 (DTLB_WAY_PGTABLE + 2)
-# else
-#  error Page coloring requires its own wired dtlb way!
-# endif
-#endif
-
-#endif /* CONFIG_MMU */
-
 /*
  * We only use two ring levels, user and kernel space.
  */
@@ -97,7 +58,7 @@
 #define PGD_ORDER		0
 #define PMD_ORDER		0
 #define USER_PTRS_PER_PGD	(TASK_SIZE/PGDIR_SIZE)
-#define FIRST_USER_ADDRESS      XCHAL_SEG_MAPPABLE_VADDR
+#define FIRST_USER_ADDRESS      0
 #define FIRST_USER_PGD_NR	(FIRST_USER_ADDRESS >> PGDIR_SHIFT)
 
 /* virtual memory area. We keep a distance to other memory regions to be
diff -puN include/asm-xtensa/platform-iss/hardware.h~xtensa-remove-extra-header-files include/asm-xtensa/platform-iss/hardware.h
--- a/include/asm-xtensa/platform-iss/hardware.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/platform-iss/hardware.h
@@ -12,18 +12,18 @@
  * This file contains the default configuration of ISS.
  */
 
-#ifndef __ASM_XTENSA_ISS_HARDWARE
-#define __ASM_XTENSA_ISS_HARDWARE
+#ifndef _XTENSA_PLATFORM_ISS_HARDWARE_H
+#define _XTENSA_PLATFORM_ISS_HARDWARE_H
 
 /*
  * Memory configuration.
  */
 
-#define PLATFORM_DEFAULT_MEM_START XSHAL_RAM_PADDR
-#define PLATFORM_DEFAULT_MEM_SIZE XSHAL_RAM_VSIZE
+#define PLATFORM_DEFAULT_MEM_START	0x00000000
+#define PLATFORM_DEFAULT_MEM_SIZE	0x08000000
 
 /*
  * Interrupt configuration.
  */
 
-#endif /* __ASM_XTENSA_ISS_HARDWARE */
+#endif /* _XTENSA_PLATFORM_ISS_HARDWARE_H */
diff -puN /dev/null include/asm-xtensa/platform-iss/simcall.h
--- /dev/null
+++ a/include/asm-xtensa/platform-iss/simcall.h
@@ -0,0 +1,62 @@
+/*
+ * include/asm-xtensa/platform-iss/hardware.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2001 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_PLATFORM_ISS_SIMCALL_H
+#define _XTENSA_PLATFORM_ISS_SIMCALL_H
+
+
+/*
+ *  System call like services offered by the simulator host.
+ */
+
+#define SYS_nop		0	/* unused */
+#define SYS_exit	1	/*x*/
+#define SYS_fork	2
+#define SYS_read	3	/*x*/
+#define SYS_write	4	/*x*/
+#define SYS_open	5	/*x*/
+#define SYS_close	6	/*x*/
+#define SYS_rename	7	/*x 38 - waitpid */
+#define SYS_creat	8	/*x*/
+#define SYS_link	9	/*x (not implemented on WIN32) */
+#define SYS_unlink	10	/*x*/
+#define SYS_execv	11	/* n/a - execve */
+#define SYS_execve	12	/* 11 - chdir */
+#define SYS_pipe	13	/* 42 - time */
+#define SYS_stat	14	/* 106 - mknod */
+#define SYS_chmod	15
+#define SYS_chown	16	/* 202 - lchown */
+#define SYS_utime	17	/* 30 - break */
+#define SYS_wait	18	/* n/a - oldstat */
+#define SYS_lseek	19	/*x*/
+#define SYS_getpid	20
+#define SYS_isatty	21	/* n/a - mount */
+#define SYS_fstat	22	/* 108 - oldumount */
+#define SYS_time	23	/* 13 - setuid */
+#define SYS_gettimeofday 24	/*x 78 - getuid (not implemented on WIN32) */
+#define SYS_times	25	/*X 43 - stime (Xtensa-specific implementation) */
+#define SYS_socket      26
+#define SYS_sendto      27
+#define SYS_recvfrom    28
+#define SYS_select_one  29      /* not compitible select, one file descriptor at the time */
+#define SYS_bind        30
+#define SYS_ioctl	31
+
+/*
+ * SYS_select_one specifiers
+ */
+
+#define  XTISS_SELECT_ONE_READ    1
+#define  XTISS_SELECT_ONE_WRITE   2
+#define  XTISS_SELECT_ONE_EXCEPT  3
+
+
+#endif /* _XTENSA_PLATFORM_ISS_SIMCALL_H */
+
diff -puN include/asm-xtensa/processor.h~xtensa-remove-extra-header-files include/asm-xtensa/processor.h
--- a/include/asm-xtensa/processor.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/processor.h
@@ -11,24 +11,18 @@
 #ifndef _XTENSA_PROCESSOR_H
 #define _XTENSA_PROCESSOR_H
 
-#ifdef __ASSEMBLY__
-#define _ASMLANGUAGE
-#endif
-
-#include <xtensa/config/core.h>
-#include <xtensa/config/specreg.h>
-#include <xtensa/config/tie.h>
-#include <xtensa/config/system.h>
+#include <asm/variant/core.h>
+#include <asm/coprocessor.h>
 
 #include <linux/compiler.h>
 #include <asm/ptrace.h>
 #include <asm/types.h>
-#include <asm/coprocessor.h>
+#include <asm/regs.h>
 
 /* Assertions. */
 
 #if (XCHAL_HAVE_WINDOWED != 1)
-#error Linux requires the Xtensa Windowed Registers Option.
+# error Linux requires the Xtensa Windowed Registers Option.
 #endif
 
 /*
@@ -145,11 +139,11 @@ struct thread_struct {
  * Note: We set-up ps as if we did a call4 to the new pc.
  *       set_thread_state in signal.c depends on it.
  */
-#define USER_PS_VALUE ( (1 << XCHAL_PS_WOE_SHIFT) + \
-                        (1 << XCHAL_PS_CALLINC_SHIFT) + \
-                        (USER_RING << XCHAL_PS_RING_SHIFT) + \
-                        (1 << XCHAL_PS_PROGSTACK_SHIFT) + \
-                        (1 << XCHAL_PS_EXCM_SHIFT) )
+#define USER_PS_VALUE ((1 << PS_WOE_BIT) |				\
+                       (1 << PS_CALLINC_SHIFT) |			\
+                       (USER_RING << PS_RING_SHIFT) |			\
+                       (1 << PS_UM_BIT) |				\
+                       (1 << PS_EXCM_BIT))
 
 /* Clearing a0 terminates the backtrace. */
 #define start_thread(regs, new_pc, new_sp) \
diff -puN include/asm-xtensa/ptrace.h~xtensa-remove-extra-header-files include/asm-xtensa/ptrace.h
--- a/include/asm-xtensa/ptrace.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/ptrace.h
@@ -11,7 +11,7 @@
 #ifndef _XTENSA_PTRACE_H
 #define _XTENSA_PTRACE_H
 
-#include <xtensa/config/core.h>
+#include <asm/variant/core.h>
 
 /*
  * Kernel stack
diff -puN /dev/null include/asm-xtensa/regs.h
--- /dev/null
+++ a/include/asm-xtensa/regs.h
@@ -0,0 +1,138 @@
+/*
+ * Copyright (c) 2006 Tensilica, Inc.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2.1 of the GNU Lesser General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Further, this software is distributed without any warranty that it is
+ * free of the rightful claim of any third person regarding infringement
+ * or the like.  Any license provided herein, whether implied or
+ * otherwise, applies only to this software file.  Patent licenses, if
+ * any, provided herein do not apply to combinations of this program with
+ * other software, or any other product whatsoever.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not, write the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
+ * USA.
+ */
+
+#ifndef _XTENSA_REGS_H
+#define _XTENSA_REGS_H
+
+/*  Special registers.  */
+
+#define LBEG		0
+#define LEND		1
+#define LCOUNT		2
+#define SAR		3
+#define BR		4
+#define SCOMPARE1	12
+#define ACCHI		16
+#define ACCLO		17
+#define MR		32
+#define WINDOWBASE	72
+#define WINDOWSTART	73
+#define PTEVADDR	83
+#define RASID		90
+#define ITLBCFG		91
+#define DTLBCFG		92
+#define IBREAKENABLE	96
+#define DDR		104
+#define IBREAKA		128
+#define DBREAKA		144
+#define DBREAKC		160
+#define EPC		176
+#define EPC_1		177
+#define DEPC		192
+#define EPS		192
+#define EPS_1		193
+#define EXCSAVE		208
+#define EXCSAVE_1	209
+#define INTERRUPT	226
+#define INTENABLE	228
+#define PS		230
+#define THREADPTR	231
+#define EXCCAUSE	232
+#define DEBUGCAUSE	233
+#define CCOUNT		234
+#define PRID		235
+#define ICOUNT		236
+#define ICOUNTLEVEL	237
+#define EXCVADDR	238
+#define CCOMPARE	240
+#define MISC		244
+
+/*  Special names for read-only and write-only interrupt registers.  */
+
+#define INTREAD		226
+#define INTSET		226
+#define INTCLEAR	227
+
+/*  EXCCAUSE register fields  */
+
+#define EXCCAUSE_EXCCAUSE_SHIFT	0
+#define EXCCAUSE_EXCCAUSE_MASK	0x3F
+
+#define EXCCAUSE_ILLEGAL_INSTRUCTION		0
+#define EXCCAUSE_SYSTEM_CALL			1
+#define EXCCAUSE_INSTRUCTION_FETCH_ERROR	2
+#define EXCCAUSE_LOAD_STORE_ERROR		3
+#define EXCCAUSE_LEVEL1_INTERRUPT		4
+#define EXCCAUSE_ALLOCA				5
+#define EXCCAUSE_INTEGER_DIVIDE_BY_ZERO		6
+#define EXCCAUSE_SPECULATION			7
+#define EXCCAUSE_PRIVILEGED			8
+#define EXCCAUSE_UNALIGNED			9
+#define EXCCAUSE_ITLB_MISS			16
+#define EXCCAUSE_ITLB_MULTIHIT			17
+#define EXCCAUSE_ITLB_PRIVILEGE			18
+#define EXCCAUSE_ITLB_SIZE_RESTRICTION		19
+#define EXCCAUSE_FETCH_CACHE_ATTRIBUTE		20
+#define EXCCAUSE_DTLB_MISS			24
+#define EXCCAUSE_DTLB_MULTIHIT			25
+#define EXCCAUSE_DTLB_PRIVILEGE			26
+#define EXCCAUSE_DTLB_SIZE_RESTRICTION		27
+#define EXCCAUSE_LOAD_CACHE_ATTRIBUTE		28
+#define EXCCAUSE_STORE_CACHE_ATTRIBUTE		29
+#define EXCCAUSE_FLOATING_POINT			40
+
+/*  PS register fields.  */
+
+#define PS_WOE_BIT		18
+#define PS_CALLINC_SHIFT	16
+#define PS_CALLINC_MASK		0x00030000
+#define PS_OWB_SHIFT		8
+#define PS_OWB_MASK		0x00000F00
+#define PS_RING_SHIFT		6
+#define PS_RING_MASK		0x000000C0
+#define PS_UM_BIT		5
+#define PS_EXCM_BIT		4
+#define PS_INTLEVEL_SHIFT	0
+#define PS_INTLEVEL_MASK	0x0000000F
+
+/*  DBREAKCn register fields.  */
+
+#define DBREAKC_MASK_BIT		0
+#define DBREAKC_MASK_MASK		0x0000003F
+#define DBREAKC_LOAD_BIT		30
+#define DBREAKC_LOAD_MASK		0x40000000
+#define DBREAKC_STOR_BIT		31
+#define DBREAKC_STOR_MASK		0x80000000
+
+/*  DEBUGCAUSE register fields.  */
+
+#define DEBUGCAUSE_DEBUGINT_BIT		5	/* External debug interrupt */
+#define DEBUGCAUSE_BREAKN_BIT		4	/* BREAK.N instruction */
+#define DEBUGCAUSE_BREAK_BIT		3	/* BREAK instruction */
+#define DEBUGCAUSE_DBREAK_BIT		2	/* DBREAK match */
+#define DEBUGCAUSE_IBREAK_BIT		1	/* IBREAK match */
+#define DEBUGCAUSE_ICOUNT_BIT		0	/* ICOUNT would incr. to zero */
+
+#endif /* _XTENSA_SPECREG_H */
+
diff -puN include/asm-xtensa/sembuf.h~xtensa-remove-extra-header-files include/asm-xtensa/sembuf.h
--- a/include/asm-xtensa/sembuf.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/sembuf.h
@@ -25,7 +25,7 @@
 
 struct semid64_ds {
 	struct ipc64_perm sem_perm;		/* permissions .. see ipc.h */
-#if XCHAL_HAVE_LE
+#ifdef __XTENSA_EL__
 	__kernel_time_t	sem_otime;		/* last semop time */
 	unsigned long	__unused1;
 	__kernel_time_t	sem_ctime;		/* last change time */
diff -puN include/asm-xtensa/system.h~xtensa-remove-extra-header-files include/asm-xtensa/system.h
--- a/include/asm-xtensa/system.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/system.h
@@ -213,7 +213,7 @@ static inline void spill_registers(void)
 	unsigned int a0, ps;
 
 	__asm__ __volatile__ (
-		"movi	a14," __stringify (PS_EXCM_MASK) " | 1\n\t"
+		"movi	a14," __stringify (PS_EXCM_BIT) " | 1\n\t"
 		"mov	a12, a0\n\t"
 		"rsr	a13," __stringify(SAR) "\n\t"
 		"xsr	a14," __stringify(PS) "\n\t"
diff -puN include/asm-xtensa/timex.h~xtensa-remove-extra-header-files include/asm-xtensa/timex.h
--- a/include/asm-xtensa/timex.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/timex.h
@@ -16,17 +16,22 @@
 #include <asm/processor.h>
 #include <linux/stringify.h>
 
-#if XCHAL_INT_LEVEL(XCHAL_TIMER0_INTERRUPT) == 1
+#define _INTLEVEL(x)	XCHAL_INT ## x ## _LEVEL
+#define INTLEVEL(x)	_INTLEVEL(x)
+
+#if INTLEVEL(XCHAL_TIMER0_INTERRUPT) == 1
 # define LINUX_TIMER     0
-#elif XCHAL_INT_LEVEL(XCHAL_TIMER1_INTERRUPT) == 1
+# define LINUX_TIMER_INT XCHAL_TIMER0_INTERRUPT
+#elif INTLEVEL(XCHAL_TIMER1_INTERRUPT) == 1
 # define LINUX_TIMER     1
-#elif XCHAL_INT_LEVEL(XCHAL_TIMER2_INTERRUPT) == 1
+# define LINUX_TIMER_INT XCHAL_TIMER1_INTERRUPT
+#elif INTLEVEL(XCHAL_TIMER2_INTERRUPT) == 1
 # define LINUX_TIMER     2
+# define LINUX_TIMER_INT XCHAL_TIMER2_INTERRUPT
 #else
 # error "Bad timer number for Linux configurations!"
 #endif
 
-#define LINUX_TIMER_INT         XCHAL_TIMER_INTERRUPT(LINUX_TIMER)
 #define LINUX_TIMER_MASK        (1L << LINUX_TIMER_INT)
 
 #define CLOCK_TICK_RATE 	1193180	/* (everyone is using this value) */
@@ -60,8 +65,8 @@ extern cycles_t cacheflush_time;
 
 #define WSR_CCOUNT(r)	  __asm__("wsr %0,"__stringify(CCOUNT) :: "a" (r))
 #define RSR_CCOUNT(r)	  __asm__("rsr %0,"__stringify(CCOUNT) : "=a" (r))
-#define WSR_CCOMPARE(x,r) __asm__("wsr %0,"__stringify(CCOMPARE_0)"+"__stringify(x) :: "a"(r))
-#define RSR_CCOMPARE(x,r) __asm__("rsr %0,"__stringify(CCOMPARE_0)"+"__stringify(x) : "=a"(r))
+#define WSR_CCOMPARE(x,r) __asm__("wsr %0,"__stringify(CCOMPARE)"+"__stringify(x) :: "a"(r))
+#define RSR_CCOMPARE(x,r) __asm__("rsr %0,"__stringify(CCOMPARE)"+"__stringify(x) : "=a"(r))
 
 static inline unsigned long get_ccount (void)
 {
diff -puN include/asm-xtensa/tlbflush.h~xtensa-remove-extra-header-files include/asm-xtensa/tlbflush.h
--- a/include/asm-xtensa/tlbflush.h~xtensa-remove-extra-header-files
+++ a/include/asm-xtensa/tlbflush.h
@@ -11,12 +11,20 @@
 #ifndef _XTENSA_TLBFLUSH_H
 #define _XTENSA_TLBFLUSH_H
 
-#define DEBUG_TLB
-
 #ifdef __KERNEL__
 
-#include <asm/processor.h>
 #include <linux/stringify.h>
+#include <asm/processor.h>
+
+#define DTLB_WAY_PGD	7
+
+#define ITLB_ARF_WAYS	4
+#define DTLB_ARF_WAYS	4
+
+#define ITLB_HIT_BIT	3
+#define DTLB_HIT_BIT	4
+
+#ifndef __ASSEMBLY__
 
 /* TLB flushing:
  *
@@ -46,11 +54,6 @@ static inline void flush_tlb_pgtables(st
 
 /* TLB operations. */
 
-#define ITLB_WAYS_LOG2      XCHAL_ITLB_WAY_BITS
-#define DTLB_WAYS_LOG2      XCHAL_DTLB_WAY_BITS
-#define ITLB_PROBE_SUCCESS  (1 << ITLB_WAYS_LOG2)
-#define DTLB_PROBE_SUCCESS  (1 << DTLB_WAYS_LOG2)
-
 static inline unsigned long itlb_probe(unsigned long addr)
 {
 	unsigned long tmp;
@@ -131,29 +134,30 @@ static inline void write_itlb_entry (pte
 
 static inline void invalidate_page_directory (void)
 {
-	invalidate_dtlb_entry (DTLB_WAY_PGTABLE);
+	invalidate_dtlb_entry (DTLB_WAY_PGD);
+	invalidate_dtlb_entry (DTLB_WAY_PGD+1);
+	invalidate_dtlb_entry (DTLB_WAY_PGD+2);
 }
 
 static inline void invalidate_itlb_mapping (unsigned address)
 {
 	unsigned long tlb_entry;
-	while ((tlb_entry = itlb_probe (address)) & ITLB_PROBE_SUCCESS)
-		invalidate_itlb_entry (tlb_entry);
+	if (((tlb_entry = itlb_probe(address)) & (1 << ITLB_HIT_BIT)) != 0)
+		invalidate_itlb_entry(tlb_entry);
 }
 
 static inline void invalidate_dtlb_mapping (unsigned address)
 {
 	unsigned long tlb_entry;
-	while ((tlb_entry = dtlb_probe (address)) & DTLB_PROBE_SUCCESS)
-		invalidate_dtlb_entry (tlb_entry);
+	if (((tlb_entry = dtlb_probe(address)) & (1 << DTLB_HIT_BIT)) != 0)
+		invalidate_dtlb_entry(tlb_entry);
 }
 
 #define check_pgt_cache()	do { } while (0)
 
 
-#ifdef DEBUG_TLB
-
-/* DO NOT USE THESE FUNCTIONS.  These instructions aren't part of the Xtensa
+/*
+ * DO NOT USE THESE FUNCTIONS.  These instructions aren't part of the Xtensa
  * ISA and exist only for test purposes..
  * You may find it helpful for MMU debugging, however.
  *
@@ -193,8 +197,6 @@ static inline unsigned long read_itlb_tr
 	return tmp;
 }
 
-#endif	/* DEBUG_TLB */
-
-
+#endif	/* __ASSEMBLY__ */
 #endif	/* __KERNEL__ */
-#endif	/* _XTENSA_PGALLOC_H */
+#endif	/* _XTENSA_TLBFLUSH_H */
diff -puN /dev/null include/asm-xtensa/variant-fsf/core.h
--- /dev/null
+++ a/include/asm-xtensa/variant-fsf/core.h
@@ -0,0 +1,359 @@
+/*
+ * Xtensa processor core configuration information.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1999-2006 Tensilica Inc.
+ */
+
+#ifndef _XTENSA_CORE_H
+#define _XTENSA_CORE_H
+
+
+/****************************************************************************
+	    Parameters Useful for Any Code, USER or PRIVILEGED
+ ****************************************************************************/
+
+/*
+ *  Note:  Macros of the form XCHAL_HAVE_*** have a value of 1 if the option is
+ *  configured, and a value of 0 otherwise.  These macros are always defined.
+ */
+
+
+/*----------------------------------------------------------------------
+				ISA
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_BE			1	/* big-endian byte ordering */
+#define XCHAL_HAVE_WINDOWED		1	/* windowed registers option */
+#define XCHAL_NUM_AREGS			64	/* num of physical addr regs */
+#define XCHAL_NUM_AREGS_LOG2		6	/* log2(XCHAL_NUM_AREGS) */
+#define XCHAL_MAX_INSTRUCTION_SIZE	3	/* max instr bytes (3..8) */
+#define XCHAL_HAVE_DEBUG		1	/* debug option */
+#define XCHAL_HAVE_DENSITY		1	/* 16-bit instructions */
+#define XCHAL_HAVE_LOOPS		1	/* zero-overhead loops */
+#define XCHAL_HAVE_NSA			1	/* NSA/NSAU instructions */
+#define XCHAL_HAVE_MINMAX		0	/* MIN/MAX instructions */
+#define XCHAL_HAVE_SEXT			0	/* SEXT instruction */
+#define XCHAL_HAVE_CLAMPS		0	/* CLAMPS instruction */
+#define XCHAL_HAVE_MUL16		0	/* MUL16S/MUL16U instructions */
+#define XCHAL_HAVE_MUL32		0	/* MULL instruction */
+#define XCHAL_HAVE_MUL32_HIGH		0	/* MULUH/MULSH instructions */
+#define XCHAL_HAVE_L32R			1	/* L32R instruction */
+#define XCHAL_HAVE_ABSOLUTE_LITERALS	1	/* non-PC-rel (extended) L32R */
+#define XCHAL_HAVE_CONST16		0	/* CONST16 instruction */
+#define XCHAL_HAVE_ADDX			1	/* ADDX#/SUBX# instructions */
+#define XCHAL_HAVE_WIDE_BRANCHES	0	/* B*.W18 or B*.W15 instr's */
+#define XCHAL_HAVE_PREDICTED_BRANCHES	0	/* B[EQ/EQZ/NE/NEZ]T instr's */
+#define XCHAL_HAVE_CALL4AND12		1	/* (obsolete option) */
+#define XCHAL_HAVE_ABS			1	/* ABS instruction */
+/*#define XCHAL_HAVE_POPC		0*/	/* POPC instruction */
+/*#define XCHAL_HAVE_CRC		0*/	/* CRC instruction */
+#define XCHAL_HAVE_RELEASE_SYNC		0	/* L32AI/S32RI instructions */
+#define XCHAL_HAVE_S32C1I		0	/* S32C1I instruction */
+#define XCHAL_HAVE_SPECULATION		0	/* speculation */
+#define XCHAL_HAVE_FULL_RESET		1	/* all regs/state reset */
+#define XCHAL_NUM_CONTEXTS		1	/* */
+#define XCHAL_NUM_MISC_REGS		2	/* num of scratch regs (0..4) */
+#define XCHAL_HAVE_TAP_MASTER		0	/* JTAG TAP control instr's */
+#define XCHAL_HAVE_PRID			1	/* processor ID register */
+#define XCHAL_HAVE_THREADPTR		1	/* THREADPTR register */
+#define XCHAL_HAVE_BOOLEANS		0	/* boolean registers */
+#define XCHAL_HAVE_CP			0	/* CPENABLE reg (coprocessor) */
+#define XCHAL_CP_MAXCFG			0	/* max allowed cp id plus one */
+#define XCHAL_HAVE_MAC16		0	/* MAC16 package */
+#define XCHAL_HAVE_VECTORFPU2005	0	/* vector floating-point pkg */
+#define XCHAL_HAVE_FP			0	/* floating point pkg */
+#define XCHAL_HAVE_VECTRA1		0	/* Vectra I  pkg */
+#define XCHAL_HAVE_VECTRALX		0	/* Vectra LX pkg */
+#define XCHAL_HAVE_HIFI2		0	/* HiFi2 Audio Engine pkg */
+
+
+/*----------------------------------------------------------------------
+				MISC
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_NUM_WRITEBUFFER_ENTRIES	4	/* size of write buffer */
+#define XCHAL_INST_FETCH_WIDTH		4	/* instr-fetch width in bytes */
+#define XCHAL_DATA_WIDTH		4	/* data width in bytes */
+/*  In T1050, applies to selected core load and store instructions (see ISA): */
+#define XCHAL_UNALIGNED_LOAD_EXCEPTION	1	/* unaligned loads cause exc. */
+#define XCHAL_UNALIGNED_STORE_EXCEPTION	1	/* unaligned stores cause exc.*/
+
+#define XCHAL_CORE_ID			"fsf"	/* alphanum core name
+						   (CoreID) set in the Xtensa
+						   Processor Generator */
+
+#define XCHAL_BUILD_UNIQUE_ID		0x00006700	/* 22-bit sw build ID */
+
+/*
+ *  These definitions describe the hardware targeted by this software.
+ */
+#define XCHAL_HW_CONFIGID0		0xC103C3FF	/* ConfigID hi 32 bits*/
+#define XCHAL_HW_CONFIGID1		0x0C006700	/* ConfigID lo 32 bits*/
+#define XCHAL_HW_VERSION_NAME		"LX2.0.0"	/* full version name */
+#define XCHAL_HW_VERSION_MAJOR		2200	/* major ver# of targeted hw */
+#define XCHAL_HW_VERSION_MINOR		0	/* minor ver# of targeted hw */
+#define XTHAL_HW_REL_LX2		1
+#define XTHAL_HW_REL_LX2_0		1
+#define XTHAL_HW_REL_LX2_0_0		1
+#define XCHAL_HW_CONFIGID_RELIABLE	1
+/*  If software targets a *range* of hardware versions, these are the bounds: */
+#define XCHAL_HW_MIN_VERSION_MAJOR	2200	/* major v of earliest tgt hw */
+#define XCHAL_HW_MIN_VERSION_MINOR	0	/* minor v of earliest tgt hw */
+#define XCHAL_HW_MAX_VERSION_MAJOR	2200	/* major v of latest tgt hw */
+#define XCHAL_HW_MAX_VERSION_MINOR	0	/* minor v of latest tgt hw */
+
+
+/*----------------------------------------------------------------------
+				CACHE
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_ICACHE_LINESIZE		16	/* I-cache line size in bytes */
+#define XCHAL_DCACHE_LINESIZE		16	/* D-cache line size in bytes */
+#define XCHAL_ICACHE_LINEWIDTH		4	/* log2(I line size in bytes) */
+#define XCHAL_DCACHE_LINEWIDTH		4	/* log2(D line size in bytes) */
+
+#define XCHAL_ICACHE_SIZE		8192	/* I-cache size in bytes or 0 */
+#define XCHAL_DCACHE_SIZE		8192	/* D-cache size in bytes or 0 */
+
+#define XCHAL_DCACHE_IS_WRITEBACK	0	/* writeback feature */
+
+
+
+
+/****************************************************************************
+    Parameters Useful for PRIVILEGED (Supervisory or Non-Virtualized) Code
+ ****************************************************************************/
+
+
+#ifndef XTENSA_HAL_NON_PRIVILEGED_ONLY
+
+/*----------------------------------------------------------------------
+				CACHE
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_PIF			1	/* any outbound PIF present */
+
+/*  If present, cache size in bytes == (ways * 2^(linewidth + setwidth)).  */
+
+/*  Number of cache sets in log2(lines per way):  */
+#define XCHAL_ICACHE_SETWIDTH		8
+#define XCHAL_DCACHE_SETWIDTH		8
+
+/*  Cache set associativity (number of ways):  */
+#define XCHAL_ICACHE_WAYS		2
+#define XCHAL_DCACHE_WAYS		2
+
+/*  Cache features:  */
+#define XCHAL_ICACHE_LINE_LOCKABLE	0
+#define XCHAL_DCACHE_LINE_LOCKABLE	0
+#define XCHAL_ICACHE_ECC_PARITY		0
+#define XCHAL_DCACHE_ECC_PARITY		0
+
+/*  Number of encoded cache attr bits (see <xtensa/hal.h> for decoded bits):  */
+#define XCHAL_CA_BITS			4
+
+
+/*----------------------------------------------------------------------
+			INTERNAL I/D RAM/ROMs and XLMI
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_NUM_INSTROM		0	/* number of core instr. ROMs */
+#define XCHAL_NUM_INSTRAM		0	/* number of core instr. RAMs */
+#define XCHAL_NUM_DATAROM		0	/* number of core data ROMs */
+#define XCHAL_NUM_DATARAM		0	/* number of core data RAMs */
+#define XCHAL_NUM_URAM			0	/* number of core unified RAMs*/
+#define XCHAL_NUM_XLMI			0	/* number of core XLMI ports */
+
+
+/*----------------------------------------------------------------------
+			INTERRUPTS and TIMERS
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_INTERRUPTS		1	/* interrupt option */
+#define XCHAL_HAVE_HIGHPRI_INTERRUPTS	1	/* med/high-pri. interrupts */
+#define XCHAL_HAVE_NMI			0	/* non-maskable interrupt */
+#define XCHAL_HAVE_CCOUNT		1	/* CCOUNT reg. (timer option) */
+#define XCHAL_NUM_TIMERS		3	/* number of CCOMPAREn regs */
+#define XCHAL_NUM_INTERRUPTS		17	/* number of interrupts */
+#define XCHAL_NUM_INTERRUPTS_LOG2	5	/* ceil(log2(NUM_INTERRUPTS)) */
+#define XCHAL_NUM_EXTINTERRUPTS		10	/* num of external interrupts */
+#define XCHAL_NUM_INTLEVELS		4	/* number of interrupt levels
+						   (not including level zero) */
+#define XCHAL_EXCM_LEVEL		1	/* level masked by PS.EXCM */
+	/* (always 1 in XEA1; levels 2 .. EXCM_LEVEL are "medium priority") */
+
+/*  Masks of interrupts at each interrupt level:  */
+#define XCHAL_INTLEVEL1_MASK		0x000064F9
+#define XCHAL_INTLEVEL2_MASK		0x00008902
+#define XCHAL_INTLEVEL3_MASK		0x00011204
+#define XCHAL_INTLEVEL4_MASK		0x00000000
+#define XCHAL_INTLEVEL5_MASK		0x00000000
+#define XCHAL_INTLEVEL6_MASK		0x00000000
+#define XCHAL_INTLEVEL7_MASK		0x00000000
+
+/*  Masks of interrupts at each range 1..n of interrupt levels:  */
+#define XCHAL_INTLEVEL1_ANDBELOW_MASK	0x000064F9
+#define XCHAL_INTLEVEL2_ANDBELOW_MASK	0x0000EDFB
+#define XCHAL_INTLEVEL3_ANDBELOW_MASK	0x0001FFFF
+#define XCHAL_INTLEVEL4_ANDBELOW_MASK	0x0001FFFF
+#define XCHAL_INTLEVEL5_ANDBELOW_MASK	0x0001FFFF
+#define XCHAL_INTLEVEL6_ANDBELOW_MASK	0x0001FFFF
+#define XCHAL_INTLEVEL7_ANDBELOW_MASK	0x0001FFFF
+
+/*  Level of each interrupt:  */
+#define XCHAL_INT0_LEVEL		1
+#define XCHAL_INT1_LEVEL		2
+#define XCHAL_INT2_LEVEL		3
+#define XCHAL_INT3_LEVEL		1
+#define XCHAL_INT4_LEVEL		1
+#define XCHAL_INT5_LEVEL		1
+#define XCHAL_INT6_LEVEL		1
+#define XCHAL_INT7_LEVEL		1
+#define XCHAL_INT8_LEVEL		2
+#define XCHAL_INT9_LEVEL		3
+#define XCHAL_INT10_LEVEL		1
+#define XCHAL_INT11_LEVEL		2
+#define XCHAL_INT12_LEVEL		3
+#define XCHAL_INT13_LEVEL		1
+#define XCHAL_INT14_LEVEL		1
+#define XCHAL_INT15_LEVEL		2
+#define XCHAL_INT16_LEVEL		3
+#define XCHAL_DEBUGLEVEL		4	/* debug interrupt level */
+#define XCHAL_HAVE_DEBUG_EXTERN_INT	0	/* OCD external db interrupt */
+
+/*  Type of each interrupt:  */
+#define XCHAL_INT0_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT1_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT2_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT3_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT4_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT5_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT6_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
+#define XCHAL_INT7_TYPE 	XTHAL_INTTYPE_EXTERN_EDGE
+#define XCHAL_INT8_TYPE 	XTHAL_INTTYPE_EXTERN_EDGE
+#define XCHAL_INT9_TYPE 	XTHAL_INTTYPE_EXTERN_EDGE
+#define XCHAL_INT10_TYPE 	XTHAL_INTTYPE_TIMER
+#define XCHAL_INT11_TYPE 	XTHAL_INTTYPE_TIMER
+#define XCHAL_INT12_TYPE 	XTHAL_INTTYPE_TIMER
+#define XCHAL_INT13_TYPE 	XTHAL_INTTYPE_SOFTWARE
+#define XCHAL_INT14_TYPE 	XTHAL_INTTYPE_SOFTWARE
+#define XCHAL_INT15_TYPE 	XTHAL_INTTYPE_SOFTWARE
+#define XCHAL_INT16_TYPE 	XTHAL_INTTYPE_SOFTWARE
+
+/*  Masks of interrupts for each type of interrupt:  */
+#define XCHAL_INTTYPE_MASK_UNCONFIGURED	0xFFFE0000
+#define XCHAL_INTTYPE_MASK_SOFTWARE	0x0001E000
+#define XCHAL_INTTYPE_MASK_EXTERN_EDGE	0x00000380
+#define XCHAL_INTTYPE_MASK_EXTERN_LEVEL	0x0000007F
+#define XCHAL_INTTYPE_MASK_TIMER	0x00001C00
+#define XCHAL_INTTYPE_MASK_NMI		0x00000000
+#define XCHAL_INTTYPE_MASK_WRITE_ERROR	0x00000000
+
+/*  Interrupt numbers assigned to specific interrupt sources:  */
+#define XCHAL_TIMER0_INTERRUPT		10	/* CCOMPARE0 */
+#define XCHAL_TIMER1_INTERRUPT		11	/* CCOMPARE1 */
+#define XCHAL_TIMER2_INTERRUPT		12	/* CCOMPARE2 */
+#define XCHAL_TIMER3_INTERRUPT		XTHAL_TIMER_UNCONFIGURED
+
+/*  Interrupt numbers for levels at which only one interrupt is configured:  */
+/*  (There are many interrupts each at level(s) 1, 2, 3.)  */
+
+
+/*
+ *  External interrupt vectors/levels.
+ *  These macros describe how Xtensa processor interrupt numbers
+ *  (as numbered internally, eg. in INTERRUPT and INTENABLE registers)
+ *  map to external BInterrupt<n> pins, for those interrupts
+ *  configured as external (level-triggered, edge-triggered, or NMI).
+ *  See the Xtensa processor databook for more details.
+ */
+
+/*  Core interrupt numbers mapped to each EXTERNAL interrupt number:  */
+#define XCHAL_EXTINT0_NUM		0	/* (intlevel 1) */
+#define XCHAL_EXTINT1_NUM		1	/* (intlevel 2) */
+#define XCHAL_EXTINT2_NUM		2	/* (intlevel 3) */
+#define XCHAL_EXTINT3_NUM		3	/* (intlevel 1) */
+#define XCHAL_EXTINT4_NUM		4	/* (intlevel 1) */
+#define XCHAL_EXTINT5_NUM		5	/* (intlevel 1) */
+#define XCHAL_EXTINT6_NUM		6	/* (intlevel 1) */
+#define XCHAL_EXTINT7_NUM		7	/* (intlevel 1) */
+#define XCHAL_EXTINT8_NUM		8	/* (intlevel 2) */
+#define XCHAL_EXTINT9_NUM		9	/* (intlevel 3) */
+
+
+/*----------------------------------------------------------------------
+			EXCEPTIONS and VECTORS
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_XEA_VERSION		2	/* Xtensa Exception Architecture
+						   number: 1 == XEA1 (old)
+							   2 == XEA2 (new)
+							   0 == XEAX (extern) */
+#define XCHAL_HAVE_XEA1			0	/* Exception Architecture 1 */
+#define XCHAL_HAVE_XEA2			1	/* Exception Architecture 2 */
+#define XCHAL_HAVE_XEAX			0	/* External Exception Arch. */
+#define XCHAL_HAVE_EXCEPTIONS		1	/* exception option */
+#define XCHAL_HAVE_MEM_ECC_PARITY	0	/* local memory ECC/parity */
+
+#define XCHAL_RESET_VECTOR_VADDR	0xFE000020
+#define XCHAL_RESET_VECTOR_PADDR	0xFE000020
+#define XCHAL_USER_VECTOR_VADDR		0xD0000220
+#define XCHAL_USER_VECTOR_PADDR		0x00000220
+#define XCHAL_KERNEL_VECTOR_VADDR	0xD0000200
+#define XCHAL_KERNEL_VECTOR_PADDR	0x00000200
+#define XCHAL_DOUBLEEXC_VECTOR_VADDR	0xD0000290
+#define XCHAL_DOUBLEEXC_VECTOR_PADDR	0x00000290
+#define XCHAL_WINDOW_VECTORS_VADDR	0xD0000000
+#define XCHAL_WINDOW_VECTORS_PADDR	0x00000000
+#define XCHAL_INTLEVEL2_VECTOR_VADDR	0xD0000240
+#define XCHAL_INTLEVEL2_VECTOR_PADDR	0x00000240
+#define XCHAL_INTLEVEL3_VECTOR_VADDR	0xD0000250
+#define XCHAL_INTLEVEL3_VECTOR_PADDR	0x00000250
+#define XCHAL_INTLEVEL4_VECTOR_VADDR	0xFE000520
+#define XCHAL_INTLEVEL4_VECTOR_PADDR	0xFE000520
+#define XCHAL_DEBUG_VECTOR_VADDR	XCHAL_INTLEVEL4_VECTOR_VADDR
+#define XCHAL_DEBUG_VECTOR_PADDR	XCHAL_INTLEVEL4_VECTOR_PADDR
+
+
+/*----------------------------------------------------------------------
+				DEBUG
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_HAVE_OCD			1	/* OnChipDebug option */
+#define XCHAL_NUM_IBREAK		2	/* number of IBREAKn regs */
+#define XCHAL_NUM_DBREAK		2	/* number of DBREAKn regs */
+#define XCHAL_HAVE_OCD_DIR_ARRAY	1	/* faster OCD option */
+
+
+/*----------------------------------------------------------------------
+				MMU
+  ----------------------------------------------------------------------*/
+
+/*  See <xtensa/config/core-matmap.h> header file for more details.  */
+
+#define XCHAL_HAVE_TLBS			1	/* inverse of HAVE_CACHEATTR */
+#define XCHAL_HAVE_SPANNING_WAY		0	/* one way maps I+D 4GB vaddr */
+#define XCHAL_HAVE_IDENTITY_MAP		0	/* vaddr == paddr always */
+#define XCHAL_HAVE_CACHEATTR		0	/* CACHEATTR register present */
+#define XCHAL_HAVE_MIMIC_CACHEATTR	0	/* region protection */
+#define XCHAL_HAVE_XLT_CACHEATTR	0	/* region prot. w/translation */
+#define XCHAL_HAVE_PTP_MMU		1	/* full MMU (with page table
+						   [autorefill] and protection)
+						   usable for an MMU-based OS */
+/*  If none of the above last 4 are set, it's a custom TLB configuration.  */
+#define XCHAL_ITLB_ARF_ENTRIES_LOG2	2	/* log2(autorefill way size) */
+#define XCHAL_DTLB_ARF_ENTRIES_LOG2	2	/* log2(autorefill way size) */
+
+#define XCHAL_MMU_ASID_BITS		8	/* number of bits in ASIDs */
+#define XCHAL_MMU_RINGS			4	/* number of rings (1..4) */
+#define XCHAL_MMU_RING_BITS		2	/* num of bits in RING field */
+
+#endif /* !XTENSA_HAL_NON_PRIVILEGED_ONLY */
+
+
+#endif /* _XTENSA_CORE_CONFIGURATION_H */
+
diff -puN /dev/null include/asm-xtensa/variant-fsf/tie.h
--- /dev/null
+++ a/include/asm-xtensa/variant-fsf/tie.h
@@ -0,0 +1,22 @@
+/*
+ * Xtensa processor core configuration information.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 1999-2006 Tensilica Inc.
+ */
+
+#ifndef XTENSA_TIE_H
+#define XTENSA_TIE_H
+
+/*----------------------------------------------------------------------
+			COPROCESSORS and EXTRA STATE
+  ----------------------------------------------------------------------*/
+
+#define XCHAL_CP_NUM			0	/* number of coprocessors */
+#define XCHAL_CP_MASK			0x00
+
+#endif /*XTENSA_CONFIG_TIE_H*/
+
diff -puN include/asm-xtensa/xtensa/cacheasm.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/cacheasm.h
+++ /dev/null
@@ -1,708 +0,0 @@
-#ifndef XTENSA_CACHEASM_H
-#define XTENSA_CACHEASM_H
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * include/asm-xtensa/xtensa/cacheasm.h -- assembler-specific cache
- * related definitions that depend on CORE configuration.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-#include <xtensa/coreasm.h>
-
-
-/*
- *  This header file defines assembler macros of the form:
- *	<x>cache_<func>
- *  where <x> is 'i' or 'd' for instruction and data caches,
- *  and <func> indicates the function of the macro.
- *
- *  The following functions <func> are defined,
- *  and apply only to the specified cache (I or D):
- *
- *  reset
- *	Resets the cache.
- *
- *  sync
- *	Makes sure any previous cache instructions have been completed;
- *	ie. makes sure any previous cache control operations
- *	have had full effect and been synchronized to memory.
- *	Eg. any invalidate completed [so as not to generate a hit],
- *	any writebacks or other pipelined writes written to memory, etc.
- *
- *  invalidate_line		(single cache line)
- *  invalidate_region		(specified memory range)
- *  invalidate_all		(entire cache)
- *	Invalidates all cache entries that cache
- *	data from the specified memory range.
- *	NOTE: locked entries are not invalidated.
- *
- *  writeback_line		(single cache line)
- *  writeback_region		(specified memory range)
- *  writeback_all		(entire cache)
- *	Writes back to memory all dirty cache entries
- *	that cache data from the specified memory range,
- *	and marks these entries as clean.
- *	NOTE: on some future implementations, this might
- *		also invalidate.
- *	NOTE: locked entries are written back, but never invalidated.
- *	NOTE: instruction caches never implement writeback.
- *
- *  writeback_inv_line		(single cache line)
- *  writeback_inv_region	(specified memory range)
- *  writeback_inv_all		(entire cache)
- *	Writes back to memory all dirty cache entries
- *	that cache data from the specified memory range,
- *	and invalidates these entries (including all clean
- *	cache entries that cache data from that range).
- *	NOTE: locked entries are written back but not invalidated.
- *	NOTE: instruction caches never implement writeback.
- *
- *  lock_line			(single cache line)
- *  lock_region			(specified memory range)
- *	Prefetch and lock the specified memory range into cache.
- *	NOTE:  if any part of the specified memory range cannot
- *	be locked, a ??? exception occurs.  These macros don't
- *	do anything special (yet anyway) to handle this situation.
- *
- *  unlock_line			(single cache line)
- *  unlock_region		(specified memory range)
- *  unlock_all			(entire cache)
- *	Unlock cache entries that cache the specified memory range.
- *	Entries not already locked are unaffected.
- */
-
-
-
-/***************************   GENERIC -- ALL CACHES   ***************************/
-
-
-/*
- *  The following macros assume the following cache size/parameter limits
- *  in the current Xtensa core implementation:
- *	cache size:	1024 bytes minimum
- *	line size:	16 - 64 bytes
- *	way count:	1 - 4
- *
- *  Minimum entries per way (ie. per associativity) = 1024 / 64 / 4 = 4
- *  Hence the assumption that each loop can execute four cache instructions.
- *
- *  Correspondingly, the offset range of instructions is assumed able to cover
- *  four lines, ie. offsets {0,1,2,3} * line_size are assumed valid for
- *  both hit and indexed cache instructions.  Ie. these offsets are all
- *  valid:  0, 16, 32, 48, 64, 96, 128, 192 (for line sizes 16, 32, 64).
- *  This is true of all original cache instructions
- *  (dhi, ihi, dhwb, dhwbi, dii, iii) which have offsets
- *  of 0 to 1020 in multiples of 4 (ie. 8 bits shifted by 2).
- *  This is also true of subsequent cache instructions
- *  (dhu, ihu, diu, iiu, diwb, diwbi, dpfl, ipfl) which have offsets
- *  of 0 to 240 in multiples of 16 (ie. 4 bits shifted by 4).
- *
- *  (Maximum cache size, currently 32k, doesn't affect the following macros.
- *  Cache ways > MMU min page size cause aliasing but that's another matter.)
- */
-
-
-
-/*
- *  Macro to apply an 'indexed' cache instruction to the entire cache.
- *
- *  Parameters:
- *	cainst		instruction/ that takes an address register parameter
- *			and an offset parameter (in range 0 .. 3*linesize).
- *	size		size of cache in bytes
- *	linesize	size of cache line in bytes
- *	assoc_or1	number of associativities (ways/sets) in cache
- *			if all sets affected by cainst,
- *			or 1 if only one set (or not all sets) of the cache
- *			is affected by cainst (eg. DIWB or DIWBI [not yet ISA defined]).
- *	aa, ab		unique address registers (temporaries)
- */
-
-	.macro	cache_index_all		cainst, size, linesize, assoc_or1, aa, ab
-
-	//  Sanity-check on cache parameters:
-	.ifne	(\size % (\linesize * \assoc_or1 * 4))
-	.err	//  cache configuration outside expected/supported range!
-	.endif
-
-	//  \size byte cache, \linesize byte lines, \assoc_or1 way(s) affected by each \cainst.
-	movi	\aa, (\size / (\linesize * \assoc_or1 * 4))
-	// Possible improvement: need only loop if \aa > 1 ;
-	// however that particular condition is highly unlikely.
-	movi	\ab, 0		// to iterate over cache
-	floop		\aa, cachex\@
-	\cainst		\ab, 0*\linesize
-	\cainst		\ab, 1*\linesize
-	\cainst		\ab, 2*\linesize
-	\cainst		\ab, 3*\linesize
-	addi		\ab, \ab, 4*\linesize	// move to next line
-	floopend	\aa, cachex\@
-
-	.endm
-
-
-/*
- *  Macro to apply a 'hit' cache instruction to a memory region,
- *  ie. to any cache entries that cache a specified portion (region) of memory.
- *  Takes care of the unaligned cases, ie. may apply to one
- *  more cache line than $asize / lineSize if $aaddr is not aligned.
- *
- *
- *  Parameters are:
- *	cainst	instruction/macro that takes an address register parameter
- *		and an offset parameter (currently always zero)
- *		and generates a cache instruction (eg. "dhi", "dhwb", "ihi", etc.)
- *	linesize_log2	log2(size of cache line in bytes)
- *	addr	register containing start address of region (clobbered)
- *	asize	register containing size of the region in bytes (clobbered)
- *	askew	unique register used as temporary
- *
- * !?!?! 2DO: optimization: iterate max(cache_size and \asize) / linesize
- */
-
-	.macro	cache_hit_region	cainst, linesize_log2, addr, asize, askew
-
-	//  Make \asize the number of iterations:
-	extui	\askew, \addr, 0, \linesize_log2	// get unalignment amount of \addr
-	add	\asize, \asize, \askew			// ... and add it to \asize
-	addi	\asize, \asize, (1 << \linesize_log2) - 1	// round up!
-	srli	\asize, \asize, \linesize_log2
-
-	//  Iterate over region:
-	floopnez	\asize, cacheh\@
-	\cainst		\addr, 0
-	addi		\addr, \addr, (1 << \linesize_log2)	// move to next line
-	floopend	\asize, cacheh\@
-
-	.endm
-
-
-
-
-
-/***************************   INSTRUCTION CACHE   ***************************/
-
-
-/*
- *  Reset/initialize the instruction cache by simply invalidating it:
- *  (need to unlock first also, if cache locking implemented):
- *
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	icache_reset	aa, ab
-	icache_unlock_all	\aa, \ab
-	icache_invalidate_all	\aa, \ab
-	.endm
-
-
-/*
- * Synchronize after an instruction cache operation,
- * to be sure everything is in sync with memory as to be
- * expected following any previous instruction cache control operations.
- *
- * Parameters are:
- *	ar	an address register (temporary) (currently unused, but may be used in future)
- */
-	.macro	icache_sync	ar
-#if XCHAL_ICACHE_SIZE > 0
-	isync
-#endif
-	.endm
-
-
-
-/*
- *  Invalidate a single line of the instruction cache.
- *  Parameters are:
- *	ar	address register that contains (virtual) address to invalidate
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	(optional) offset to add to \ar to compute effective address to invalidate
- *		(note: some number of lsbits are ignored)
- */
-	.macro	icache_invalidate_line	ar, offset
-#if XCHAL_ICACHE_SIZE > 0
-	ihi	\ar, \offset		// invalidate icache line
-	/*
-	 *  NOTE:  in some version of the silicon [!!!SHOULD HAVE BEEN DOCUMENTED!!!]
-	 *  'ihi' doesn't work, so it had been replaced with 'iii'
-	 *  (which would just invalidate more than it should,
-	 *  which should be okay other than the performance hit
-	 *  because cache locking did not exist in that version,
-	 *  unless user somehow relies on something being cached).
-	 *  [WHAT VERSION IS IT!!?!?
-	 *  IS THERE ANY WAY TO TEST FOR THAT HERE, TO OUTPUT 'III' ONLY IF NEEDED!?!?].
-	 *
-	 *	iii	\ar, \offset
-	 */
-	icache_sync	\ar
-#endif
-	.endm
-
-
-
-
-/*
- *  Invalidate instruction  cache entries that cache a specified portion of memory.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	icache_invalidate_region	astart, asize, ac
-#if XCHAL_ICACHE_SIZE > 0
-	//  Instruction cache region invalidation:
-	cache_hit_region	ihi, XCHAL_ICACHE_LINEWIDTH, \astart, \asize, \ac
-	icache_sync	\ac
-	//  End of instruction cache region invalidation
-#endif
-	.endm
-
-
-
-/*
- *  Invalidate entire instruction cache.
- *
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	icache_invalidate_all	aa, ab
-#if XCHAL_ICACHE_SIZE > 0
-	//  Instruction cache invalidation:
-	cache_index_all		iii, XCHAL_ICACHE_SIZE, XCHAL_ICACHE_LINESIZE, XCHAL_ICACHE_WAYS, \aa, \ab
-	icache_sync	\aa
-	//  End of instruction cache invalidation
-#endif
-	.endm
-
-
-
-/*
- *  Lock (prefetch & lock) a single line of the instruction cache.
- *
- *  Parameters are:
- *	ar	address register that contains (virtual) address to lock
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	offset to add to \ar to compute effective address to lock
- *		(note: some number of lsbits are ignored)
- */
-	.macro	icache_lock_line	ar, offset
-#if XCHAL_ICACHE_SIZE > 0 && XCHAL_ICACHE_LINE_LOCKABLE
-	ipfl	\ar, \offset	/* prefetch and lock icache line */
-	icache_sync	\ar
-#endif
-	.endm
-
-
-
-/*
- *  Lock (prefetch & lock) a specified portion of memory into the instruction cache.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	icache_lock_region	astart, asize, ac
-#if XCHAL_ICACHE_SIZE > 0 && XCHAL_ICACHE_LINE_LOCKABLE
-	//  Instruction cache region lock:
-	cache_hit_region	ipfl, XCHAL_ICACHE_LINEWIDTH, \astart, \asize, \ac
-	icache_sync	\ac
-	//  End of instruction cache region lock
-#endif
-	.endm
-
-
-
-/*
- *  Unlock a single line of the instruction cache.
- *
- *  Parameters are:
- *	ar	address register that contains (virtual) address to unlock
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	offset to add to \ar to compute effective address to unlock
- *		(note: some number of lsbits are ignored)
- */
-	.macro	icache_unlock_line	ar, offset
-#if XCHAL_ICACHE_SIZE > 0 && XCHAL_ICACHE_LINE_LOCKABLE
-	ihu	\ar, \offset	/* unlock icache line */
-	icache_sync	\ar
-#endif
-	.endm
-
-
-
-/*
- *  Unlock a specified portion of memory from the instruction cache.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	icache_unlock_region	astart, asize, ac
-#if XCHAL_ICACHE_SIZE > 0 && XCHAL_ICACHE_LINE_LOCKABLE
-	//  Instruction cache region unlock:
-	cache_hit_region	ihu, XCHAL_ICACHE_LINEWIDTH, \astart, \asize, \ac
-	icache_sync	\ac
-	//  End of instruction cache region unlock
-#endif
-	.endm
-
-
-
-/*
- *  Unlock entire instruction cache.
- *
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	icache_unlock_all	aa, ab
-#if XCHAL_ICACHE_SIZE > 0 && XCHAL_ICACHE_LINE_LOCKABLE
-	//  Instruction cache unlock:
-	cache_index_all		iiu, XCHAL_ICACHE_SIZE, XCHAL_ICACHE_LINESIZE, 1, \aa, \ab
-	icache_sync	\aa
-	//  End of instruction cache unlock
-#endif
-	.endm
-
-
-
-
-
-/***************************   DATA CACHE   ***************************/
-
-
-
-/*
- *  Reset/initialize the data cache by simply invalidating it
- *  (need to unlock first also, if cache locking implemented):
- *
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	dcache_reset	aa, ab
-	dcache_unlock_all	\aa, \ab
-	dcache_invalidate_all	\aa, \ab
-	.endm
-
-
-
-
-/*
- * Synchronize after a data cache operation,
- * to be sure everything is in sync with memory as to be
- * expected following any previous data cache control operations.
- *
- * Parameters are:
- *	ar	an address register (temporary) (currently unused, but may be used in future)
- */
-	.macro	dcache_sync	ar
-#if XCHAL_DCACHE_SIZE > 0
-	//  This previous sequence errs on the conservative side (too much so); a DSYNC should be sufficient:
-	//memw		// synchronize data cache changes relative to subsequent memory accesses
-	//isync		// be conservative and ISYNC as well (just to be sure)
-
-	dsync
-#endif
-	.endm
-
-
-
-/*
- * Synchronize after a data store operation,
- * to be sure the stored data is completely off the processor
- * (and assuming there is no buffering outside the processor,
- *  that the data is in memory).  This may be required to
- * ensure that the processor's write buffers are emptied.
- * A MEMW followed by a read guarantees this, by definition.
- * We also try to make sure the read itself completes.
- *
- * Parameters are:
- *	ar	an address register (temporary)
- */
-	.macro	write_sync	ar
-	memw			// ensure previous memory accesses are complete prior to subsequent memory accesses
-	l32i	\ar, sp, 0	// completing this read ensures any previous write has completed, because of MEMW
-	//slot
-	add	\ar, \ar, \ar	// use the result of the read to help ensure the read completes (in future architectures)
-	.endm
-
-
-/*
- *  Invalidate a single line of the data cache.
- *  Parameters are:
- *	ar	address register that contains (virtual) address to invalidate
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	(optional) offset to add to \ar to compute effective address to invalidate
- *		(note: some number of lsbits are ignored)
- */
-	.macro	dcache_invalidate_line	ar, offset
-#if XCHAL_DCACHE_SIZE > 0
-	dhi	\ar, \offset
-	dcache_sync	\ar
-#endif
-	.endm
-
-
-
-
-
-/*
- *  Invalidate data cache entries that cache a specified portion of memory.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	dcache_invalidate_region	astart, asize, ac
-#if XCHAL_DCACHE_SIZE > 0
-	//  Data cache region invalidation:
-	cache_hit_region	dhi, XCHAL_DCACHE_LINEWIDTH, \astart, \asize, \ac
-	dcache_sync	\ac
-	//  End of data cache region invalidation
-#endif
-	.endm
-
-
-
-#if 0
-/*
- *  This is a work-around for a bug in SiChip1 (???).
- *  There should be a proper mechanism for not outputting
- *  these instructions when not needed.
- *  To enable work-around, uncomment this and replace 'dii'
- *  with 'dii_s1' everywhere, eg. in dcache_invalidate_all
- *  macro below.
- */
-	.macro	dii_s1	ar, offset
-	dii	\ar, \offset
-	or	\ar, \ar, \ar
-	or	\ar, \ar, \ar
-	or	\ar, \ar, \ar
-	or	\ar, \ar, \ar
-	.endm
-#endif
-
-
-/*
- *  Invalidate entire data cache.
- *
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	dcache_invalidate_all	aa, ab
-#if XCHAL_DCACHE_SIZE > 0
-	//  Data cache invalidation:
-	cache_index_all		dii, XCHAL_DCACHE_SIZE, XCHAL_DCACHE_LINESIZE, XCHAL_DCACHE_WAYS, \aa, \ab
-	dcache_sync	\aa
-	//  End of data cache invalidation
-#endif
-	.endm
-
-
-
-/*
- *  Writeback a single line of the data cache.
- *  Parameters are:
- *	ar	address register that contains (virtual) address to writeback
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	offset to add to \ar to compute effective address to writeback
- *		(note: some number of lsbits are ignored)
- */
-	.macro	dcache_writeback_line	ar, offset
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_IS_WRITEBACK
-	dhwb	\ar, \offset
-	dcache_sync	\ar
-#endif
-	.endm
-
-
-
-/*
- *  Writeback dirty data cache entries that cache a specified portion of memory.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	dcache_writeback_region		astart, asize, ac
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_IS_WRITEBACK
-	//  Data cache region writeback:
-	cache_hit_region	dhwb, XCHAL_DCACHE_LINEWIDTH, \astart, \asize, \ac
-	dcache_sync	\ac
-	//  End of data cache region writeback
-#endif
-	.endm
-
-
-
-/*
- *  Writeback entire data cache.
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	dcache_writeback_all	aa, ab
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_IS_WRITEBACK
-	//  Data cache writeback:
-	cache_index_all		diwb, XCHAL_DCACHE_SIZE, XCHAL_DCACHE_LINESIZE, 1, \aa, \ab
-	dcache_sync	\aa
-	//  End of data cache writeback
-#endif
-	.endm
-
-
-
-/*
- *  Writeback and invalidate a single line of the data cache.
- *  Parameters are:
- *	ar	address register that contains (virtual) address to writeback and invalidate
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	offset to add to \ar to compute effective address to writeback and invalidate
- *		(note: some number of lsbits are ignored)
- */
-	.macro	dcache_writeback_inv_line	ar, offset
-#if XCHAL_DCACHE_SIZE > 0
-	dhwbi	\ar, \offset	/* writeback and invalidate dcache line */
-	dcache_sync	\ar
-#endif
-	.endm
-
-
-
-/*
- *  Writeback and invalidate data cache entries that cache a specified portion of memory.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	dcache_writeback_inv_region	astart, asize, ac
-#if XCHAL_DCACHE_SIZE > 0
-	//  Data cache region writeback and invalidate:
-	cache_hit_region	dhwbi, XCHAL_DCACHE_LINEWIDTH, \astart, \asize, \ac
-	dcache_sync	\ac
-	//  End of data cache region writeback and invalidate
-#endif
-	.endm
-
-
-
-/*
- *  Writeback and invalidate entire data cache.
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	dcache_writeback_inv_all	aa, ab
-#if XCHAL_DCACHE_SIZE > 0
-	//  Data cache writeback and invalidate:
-#if XCHAL_DCACHE_IS_WRITEBACK
-	cache_index_all		diwbi, XCHAL_DCACHE_SIZE, XCHAL_DCACHE_LINESIZE, 1, \aa, \ab
-	dcache_sync	\aa
-#else /*writeback*/
-	//  Data cache does not support writeback, so just invalidate: */
-	dcache_invalidate_all	\aa, \ab
-#endif /*writeback*/
-	//  End of data cache writeback and invalidate
-#endif
-	.endm
-
-
-
-
-/*
- *  Lock (prefetch & lock) a single line of the data cache.
- *
- *  Parameters are:
- *	ar	address register that contains (virtual) address to lock
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	offset to add to \ar to compute effective address to lock
- *		(note: some number of lsbits are ignored)
- */
-	.macro	dcache_lock_line	ar, offset
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_LINE_LOCKABLE
-	dpfl	\ar, \offset	/* prefetch and lock dcache line */
-	dcache_sync	\ar
-#endif
-	.endm
-
-
-
-/*
- *  Lock (prefetch & lock) a specified portion of memory into the data cache.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	dcache_lock_region	astart, asize, ac
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_LINE_LOCKABLE
-	//  Data cache region lock:
-	cache_hit_region	dpfl, XCHAL_DCACHE_LINEWIDTH, \astart, \asize, \ac
-	dcache_sync	\ac
-	//  End of data cache region lock
-#endif
-	.endm
-
-
-
-/*
- *  Unlock a single line of the data cache.
- *
- *  Parameters are:
- *	ar	address register that contains (virtual) address to unlock
- *		(may get clobbered in a future implementation, but not currently)
- *	offset	offset to add to \ar to compute effective address to unlock
- *		(note: some number of lsbits are ignored)
- */
-	.macro	dcache_unlock_line	ar, offset
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_LINE_LOCKABLE
-	dhu	\ar, \offset	/* unlock dcache line */
-	dcache_sync	\ar
-#endif
-	.endm
-
-
-
-/*
- *  Unlock a specified portion of memory from the data cache.
- *  Parameters are:
- *	astart	start address (register gets clobbered)
- *	asize	size of the region in bytes (register gets clobbered)
- *	ac	unique register used as temporary
- */
-	.macro	dcache_unlock_region	astart, asize, ac
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_LINE_LOCKABLE
-	//  Data cache region unlock:
-	cache_hit_region	dhu, XCHAL_DCACHE_LINEWIDTH, \astart, \asize, \ac
-	dcache_sync	\ac
-	//  End of data cache region unlock
-#endif
-	.endm
-
-
-
-/*
- *  Unlock entire data cache.
- *
- *  Parameters:
- *	aa, ab		unique address registers (temporaries)
- */
-	.macro	dcache_unlock_all	aa, ab
-#if XCHAL_DCACHE_SIZE > 0 && XCHAL_DCACHE_LINE_LOCKABLE
-	//  Data cache unlock:
-	cache_index_all		diu, XCHAL_DCACHE_SIZE, XCHAL_DCACHE_LINESIZE, 1, \aa, \ab
-	dcache_sync	\aa
-	//  End of data cache unlock
-#endif
-	.endm
-
-
-#endif /*XTENSA_CACHEASM_H*/
-
diff -puN include/asm-xtensa/xtensa/cacheattrasm.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/cacheattrasm.h
+++ /dev/null
@@ -1,432 +0,0 @@
-#ifndef XTENSA_CACHEATTRASM_H
-#define XTENSA_CACHEATTRASM_H
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * include/asm-xtensa/xtensa/cacheattrasm.h -- assembler-specific
- * CACHEATTR register related definitions that depend on CORE
- * configuration.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-#include <xtensa/coreasm.h>
-
-
-/*
- *  This header file defines assembler macros of the form:
- *	<x>cacheattr_<func>
- *  where:
- *	<x> is 'i', 'd' or absent for instruction, data
- *		or both caches; and
- *	<func> indicates the function of the macro.
- *
- *  The following functions are defined:
- *
- *  icacheattr_get
- *	Reads I-cache CACHEATTR into a2 (clobbers a3-a5).
- *
- *  dcacheattr_get
- *	Reads D-cache CACHEATTR into a2 (clobbers a3-a5).
- *	(Note:  for configs with a real CACHEATTR register, the
- *	 above two macros are identical.)
- *
- *  cacheattr_set
- *	Writes both I-cache and D-cache CACHEATTRs from a2 (a3-a8 clobbered).
- *	Works even when changing one's own code's attributes.
- *
- *  icacheattr_is_enabled  label
- *	Branches to \label if I-cache appears to have been enabled
- *	(eg. if CACHEATTR contains a cache-enabled attribute).
- *	(clobbers a2-a5,SAR)
- *
- *  dcacheattr_is_enabled  label
- *	Branches to \label if D-cache appears to have been enabled
- *	(eg. if CACHEATTR contains a cache-enabled attribute).
- *	(clobbers a2-a5,SAR)
- *
- *  cacheattr_is_enabled  label
- *	Branches to \label if either I-cache or D-cache appears to have been enabled
- *	(eg. if CACHEATTR contains a cache-enabled attribute).
- *	(clobbers a2-a5,SAR)
- *
- *  The following macros are only defined under certain conditions:
- *
- *  icacheattr_set	(if XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR)
- *	Writes I-cache CACHEATTR from a2 (a3-a8 clobbered).
- *
- *  dcacheattr_set	(if XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR)
- *	Writes D-cache CACHEATTR from a2 (a3-a8 clobbered).
- */
-
-
-
-/***************************   GENERIC -- ALL CACHES   ***************************/
-
-/*
- *  _cacheattr_get
- *
- *  (Internal macro.)
- *  Returns value of CACHEATTR register (or closest equivalent) in a2.
- *
- *  Entry:
- *	(none)
- *  Exit:
- *	a2	value read from CACHEATTR
- *	a3-a5	clobbered (temporaries)
- */
-	.macro	_cacheattr_get	tlb
-#if XCHAL_HAVE_CACHEATTR
-	rsr	a2, CACHEATTR
-#elif XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR
-	//  We have a config that "mimics" CACHEATTR using a simplified
-	//  "MMU" composed of a single statically-mapped way.
-	//  DTLB and ITLB are independent, so there's no single
-	//  cache attribute that can describe both.  So for now
-	//  just return the DTLB state.
-	movi	a5, 0xE0000000
-	movi	a2, 0
-	movi	a3, 0
-1:	add	a3, a3, a5	// next segment
-	r&tlb&1	a4, a3		// get PPN+CA of segment at 0xE0000000, 0xC0000000, ..., 0
-	dsync	// interlock???
-	slli	a2, a2, 4
-	extui	a4, a4, 0, 4	// extract CA
-	or	a2, a2, a4
-	bnez	a3, 1b
-#else
-	//  This macro isn't applicable to arbitrary MMU configurations.
-	//  Just return zero.
-	movi	a2, 0
-#endif
-	.endm
-
-	.macro	icacheattr_get
-	_cacheattr_get	itlb
-	.endm
-
-	.macro	dcacheattr_get
-	_cacheattr_get	dtlb
-	.endm
-
-
-#define XCHAL_CACHEATTR_ALL_BYPASS	0x22222222	/* default (powerup/reset) value of CACHEATTR, all BYPASS
-							   mode (ie. disabled/bypassed caches) */
-
-#if XCHAL_HAVE_CACHEATTR || XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR
-
-#define XCHAL_FCA_ENAMASK	0x001A	/* bitmap of fetch attributes that require enabled icache */
-#define XCHAL_LCA_ENAMASK	0x0003	/* bitmap of load  attributes that require enabled dcache */
-#define XCHAL_SCA_ENAMASK	0x0003	/* bitmap of store attributes that require enabled dcache */
-#define XCHAL_LSCA_ENAMASK	(XCHAL_LCA_ENAMASK|XCHAL_SCA_ENAMASK)	/* l/s attrs requiring enabled dcache */
-#define XCHAL_ALLCA_ENAMASK	(XCHAL_FCA_ENAMASK|XCHAL_LSCA_ENAMASK)	/* all attrs requiring enabled caches */
-
-/*
- *  _cacheattr_is_enabled
- *
- *  (Internal macro.)
- *  Branches to \label if CACHEATTR in a2 indicates an enabled
- *  cache, using mask in a3.
- *
- *  Parameters:
- *	label	where to branch to if cache is enabled
- *  Entry:
- *	a2	contains CACHEATTR value used to determine whether
- *		caches are enabled
- *	a3	16-bit constant where each bit correspond to
- *		one of the 16 possible CA values (in a CACHEATTR mask);
- *		CA values that indicate the cache is enabled
- *		have their corresponding bit set in this mask
- *		(eg. use XCHAL_xCA_ENAMASK , above)
- *  Exit:
- *	a2,a4,a5	clobbered
- *	SAR		clobbered
- */
-	.macro	_cacheattr_is_enabled	label
-	movi	a4, 8		// loop 8 times
-.Lcaife\@:
-	extui	a5, a2, 0, 4	// get CA nibble
-	ssr	a5		// index into mask according to CA...
-	srl	a5, a3		// ...and get CA's mask bit in a5 bit 0
-	bbsi.l	a5, 0, \label	// if CA indicates cache enabled, jump to label
-	srli	a2, a2, 4	// next nibble
-	addi	a4, a4, -1
-	bnez	a4, .Lcaife\@	// loop for each nibble
-	.endm
-
-#else /* XCHAL_HAVE_CACHEATTR || XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR */
-	.macro	_cacheattr_is_enabled	label
-	j	\label		// macro not applicable, assume caches always enabled
-	.endm
-#endif /* XCHAL_HAVE_CACHEATTR || XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR */
-
-
-
-/*
- *  icacheattr_is_enabled
- *
- *  Branches to \label if I-cache is enabled.
- *
- *  Parameters:
- *	label	where to branch to if icache is enabled
- *  Entry:
- *	(none)
- *  Exit:
- *	a2-a5, SAR	clobbered (temporaries)
- */
-	.macro	icacheattr_is_enabled	label
-#if XCHAL_HAVE_CACHEATTR || XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR
-	icacheattr_get
-	movi	a3, XCHAL_FCA_ENAMASK
-#endif
-	_cacheattr_is_enabled	\label
-	.endm
-
-/*
- *  dcacheattr_is_enabled
- *
- *  Branches to \label if D-cache is enabled.
- *
- *  Parameters:
- *	label	where to branch to if dcache is enabled
- *  Entry:
- *	(none)
- *  Exit:
- *	a2-a5, SAR	clobbered (temporaries)
- */
-	.macro	dcacheattr_is_enabled	label
-#if XCHAL_HAVE_CACHEATTR || XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR
-	dcacheattr_get
-	movi	a3, XCHAL_LSCA_ENAMASK
-#endif
-	_cacheattr_is_enabled	\label
-	.endm
-
-/*
- *  cacheattr_is_enabled
- *
- *  Branches to \label if either I-cache or D-cache is enabled.
- *
- *  Parameters:
- *	label	where to branch to if a cache is enabled
- *  Entry:
- *	(none)
- *  Exit:
- *	a2-a5, SAR	clobbered (temporaries)
- */
-	.macro	cacheattr_is_enabled	label
-#if XCHAL_HAVE_CACHEATTR
-	rsr	a2, CACHEATTR
-	movi	a3, XCHAL_ALLCA_ENAMASK
-#elif XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR
-	icacheattr_get
-	movi	a3, XCHAL_FCA_ENAMASK
-	_cacheattr_is_enabled	\label
-	dcacheattr_get
-	movi	a3, XCHAL_LSCA_ENAMASK
-#endif
-	_cacheattr_is_enabled	\label
-	.endm
-
-
-
-/*
- *  The ISA does not have a defined way to change the
- *  instruction cache attributes of the running code,
- *  ie. of the memory area that encloses the current PC.
- *  However, each micro-architecture (or class of
- *  configurations within a micro-architecture)
- *  provides a way to deal with this issue.
- *
- *  Here are a few macros used to implement the relevant
- *  approach taken.
- */
-
-#if XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR
-	//  We have a config that "mimics" CACHEATTR using a simplified
-	//  "MMU" composed of a single statically-mapped way.
-
-/*
- *  icacheattr_set
- *
- *  Entry:
- *	a2		cacheattr value to set
- *  Exit:
- *	a2		unchanged
- *	a3-a8		clobbered (temporaries)
- */
-	.macro	icacheattr_set
-
-	movi	a5, 0xE0000000	// mask of upper 3 bits
-	movi	a6, 3f		// PC where ITLB is set
-	movi	a3, 0		// start at region 0 (0 .. 7)
-	and	a6, a6, a5	// upper 3 bits of local PC area
-	mov	a7, a2		// copy a2 so it doesn't get clobbered
-	j	3f
-
-# if XCHAL_HAVE_XLT_CACHEATTR
-	//  Can do translations, use generic method:
-1:	sub	a6, a3, a5	// address of some other segment
-	ritlb1	a8, a6		// save its PPN+CA
-	dsync	// interlock??
-	witlb	a4, a6		// make it translate to this code area
-	movi	a6, 5f		// where to jump into it
-	isync
-	sub	a6, a6, a5	// adjust jump address within that other segment
-	jx	a6
-
-	//  Note that in the following code snippet, which runs at a different virtual
-	//  address than it is assembled for, we avoid using literals (eg. via movi/l32r)
-	//  just in case literals end up in a different 512 MB segment, and we avoid
-	//  instructions that rely on the current PC being what is expected.
-	//
-	.align	4
-	_j	6f		// this is at label '5' minus 4 bytes
-	.align	4
-5:	witlb	a4, a3		// we're in other segment, now can write previous segment's CA
-	isync
-	add	a6, a6, a5	// back to previous segment
-	addi	a6, a6, -4	// next jump label
-	jx	a6
-
-6:	sub	a6, a3, a5	// address of some other segment
-	witlb	a8, a6		// restore PPN+CA of other segment
-	mov	a6, a3		// restore a6
-	isync
-# else /* XCHAL_HAVE_XLT_CACHEATTR */
-	//  Use micro-architecture specific method.
-	//  The following 4-instruction sequence is aligned such that
-	//  it all fits within a single I-cache line.  Sixteen byte
-	//  alignment is sufficient for this (using XCHAL_ICACHE_LINESIZE
-	//  actually causes problems because that can be greater than
-	//  the alignment of the reset vector, where this macro is often
-	//  invoked, which would cause the linker to align the reset
-	//  vector code away from the reset vector!!).
-	.align	16 /*XCHAL_ICACHE_LINESIZE*/
-1:	_witlb	a4, a3		// write wired PTE (CA, no PPN) of 512MB segment to ITLB
-	_isync
-	nop
-	nop
-# endif /* XCHAL_HAVE_XLT_CACHEATTR */
-	beq	a3, a5, 4f	// done?
-
-	//  Note that in the WITLB loop, we don't do any load/stores
-	//  (may not be an issue here, but it is important in the DTLB case).
-2:	srli	a7, a7, 4	// next CA
-	sub	a3, a3, a5	// next segment (add 0x20000000)
-3:
-# if XCHAL_HAVE_XLT_CACHEATTR	/* if have translation, preserve it */
-	ritlb1	a8, a3		// get current PPN+CA of segment
-	dsync	// interlock???
-	extui	a4, a7, 0, 4	// extract CA to set
-	srli	a8, a8, 4	// clear CA but keep PPN ...
-	slli	a8, a8, 4	// ...
-	add	a4, a4, a8	// combine new CA with PPN to preserve
-# else
-	extui	a4, a7, 0, 4	// extract CA
-# endif
-	beq	a3, a6, 1b	// current PC's region? if so, do it in a safe way
-	witlb	a4, a3		// write wired PTE (CA [+PPN]) of 512MB segment to ITLB
-	bne	a3, a5, 2b
-	isync			// make sure all ifetch changes take effect
-4:
-	.endm	// icacheattr_set
-
-
-/*
- *  dcacheattr_set
- *
- *  Entry:
- *	a2		cacheattr value to set
- *  Exit:
- *	a2		unchanged
- *	a3-a8		clobbered (temporaries)
- */
-
-	.macro	dcacheattr_set
-
-	movi	a5, 0xE0000000	// mask of upper 3 bits
-	movi	a3, 0		// start at region 0 (0 .. 7)
-	mov	a7, a2		// copy a2 so it doesn't get clobbered
-	j	3f
-	//  Note that in the WDTLB loop, we don't do any load/stores
-	//  (including implicit l32r via movi) because it isn't safe.
-2:	srli	a7, a7, 4	// next CA
-	sub	a3, a3, a5	// next segment (add 0x20000000)
-3:
-# if XCHAL_HAVE_XLT_CACHEATTR	/* if have translation, preserve it */
-	rdtlb1	a8, a3		// get current PPN+CA of segment
-	dsync	// interlock???
-	extui	a4, a7, 0, 4	// extract CA to set
-	srli	a8, a8, 4	// clear CA but keep PPN ...
-	slli	a8, a8, 4	// ...
-	add	a4, a4, a8	// combine new CA with PPN to preserve
-# else
-	extui	a4, a7, 0, 4	// extract CA to set
-# endif
-	wdtlb	a4, a3		// write wired PTE (CA [+PPN]) of 512MB segment to DTLB
-	bne	a3, a5, 2b
-	dsync			// make sure all data path changes take effect
-	.endm	// dcacheattr_set
-
-#endif /* XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR */
-
-
-
-/*
- *  cacheattr_set
- *
- *  Macro that sets the current CACHEATTR safely
- *  (both i and d) according to the current contents of a2.
- *  It works even when changing the cache attributes of
- *  the currently running code.
- *
- *  Entry:
- *	a2		cacheattr value to set
- *  Exit:
- *	a2		unchanged
- *	a3-a8		clobbered (temporaries)
- */
-	.macro	cacheattr_set
-
-#if XCHAL_HAVE_CACHEATTR
-# if XCHAL_ICACHE_LINESIZE < 4
-	//  No i-cache, so can always safely write to CACHEATTR:
-	wsr	a2, CACHEATTR
-# else
-	//  The Athens micro-architecture, when using the old
-	//  exception architecture option (ie. with the CACHEATTR register)
-	//  allows changing the cache attributes of the running code
-	//  using the following exact sequence aligned to be within
-	//  an instruction cache line.  (NOTE: using XCHAL_ICACHE_LINESIZE
-	//  alignment actually causes problems because that can be greater
-	//  than the alignment of the reset vector, where this macro is often
-	//  invoked, which would cause the linker to align the reset
-	//  vector code away from the reset vector!!).
-	j	1f
-	.align	16 /*XCHAL_ICACHE_LINESIZE*/	// align to within an I-cache line
-1:	_wsr	a2, CACHEATTR
-	_isync
-	nop
-	nop
-# endif
-#elif XCHAL_HAVE_MIMIC_CACHEATTR || XCHAL_HAVE_XLT_CACHEATTR
-	//  DTLB and ITLB are independent, but to keep semantics
-	//  of this macro we simply write to both.
-	icacheattr_set
-	dcacheattr_set
-#else
-	//  This macro isn't applicable to arbitrary MMU configurations.
-	//  Do nothing in this case.
-#endif
-	.endm
-
-
-#endif /*XTENSA_CACHEATTRASM_H*/
-
diff -puN include/asm-xtensa/xtensa/config-linux_be/core.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/config-linux_be/core.h
+++ /dev/null
@@ -1,1270 +0,0 @@
-/*
- * xtensa/config/core.h -- HAL definitions that are dependent on CORE configuration
- *
- *  This header file is sometimes referred to as the "compile-time HAL" or CHAL.
- *  It was generated for a specific Xtensa processor configuration.
- *
- *  Source for configuration-independent binaries (which link in a
- *  configuration-specific HAL library) must NEVER include this file.
- *  It is perfectly normal, however, for the HAL source itself to include this file.
- */
-
-/*
- * Copyright (c) 2003 Tensilica, Inc.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2.1 of the GNU Lesser General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * Further, this software is distributed without any warranty that it is
- * free of the rightful claim of any third person regarding infringement
- * or the like.  Any license provided herein, whether implied or
- * otherwise, applies only to this software file.  Patent licenses, if
- * any, provided herein do not apply to combinations of this program with
- * other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
- * USA.
- */
-
-
-#ifndef XTENSA_CONFIG_CORE_H
-#define XTENSA_CONFIG_CORE_H
-
-#include <xtensa/hal.h>
-
-
-/*----------------------------------------------------------------------
-				GENERAL
-  ----------------------------------------------------------------------*/
-
-/*
- *  Separators for macros that expand into arrays.
- *  These can be predefined by files that #include this one,
- *  when different separators are required.
- */
-/*  Element separator for macros that expand into 1-dimensional arrays:  */
-#ifndef XCHAL_SEP
-#define XCHAL_SEP			,
-#endif
-/*  Array separator for macros that expand into 2-dimensional arrays:  */
-#ifndef XCHAL_SEP2
-#define XCHAL_SEP2			},{
-#endif
-
-
-/*----------------------------------------------------------------------
-				ENDIANNESS
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_BE			1
-#define XCHAL_HAVE_LE			0
-#define XCHAL_MEMORY_ORDER		XTHAL_BIGENDIAN
-
-
-/*----------------------------------------------------------------------
-				REGISTER WINDOWS
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_WINDOWED		1	/* 1 if windowed registers option configured, 0 otherwise */
-#define XCHAL_NUM_AREGS			64	/* number of physical address regs */
-#define XCHAL_NUM_AREGS_LOG2		6	/* log2(XCHAL_NUM_AREGS) */
-
-
-/*----------------------------------------------------------------------
-				ADDRESS ALIGNMENT
-  ----------------------------------------------------------------------*/
-
-/*  These apply to a selected set of core load and store instructions only (see ISA):  */
-#define XCHAL_UNALIGNED_LOAD_EXCEPTION	1	/* 1 if unaligned loads cause an exception, 0 otherwise */
-#define XCHAL_UNALIGNED_STORE_EXCEPTION	1	/* 1 if unaligned stores cause an exception, 0 otherwise */
-
-
-/*----------------------------------------------------------------------
-				INTERRUPTS
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_INTERRUPTS		1	/* 1 if interrupt option configured, 0 otherwise */
-#define XCHAL_HAVE_HIGHPRI_INTERRUPTS	1	/* 1 if high-priority interrupt option configured, 0 otherwise */
-#define XCHAL_HAVE_HIGHLEVEL_INTERRUPTS	XCHAL_HAVE_HIGHPRI_INTERRUPTS
-#define XCHAL_HAVE_NMI			0	/* 1 if NMI option configured, 0 otherwise */
-#define XCHAL_NUM_INTERRUPTS		17	/* number of interrupts */
-#define XCHAL_NUM_INTERRUPTS_LOG2	5	/* number of bits to hold an interrupt number: roundup(log2(number of interrupts)) */
-#define XCHAL_NUM_EXTINTERRUPTS		10	/* number of external interrupts */
-#define XCHAL_NUM_INTLEVELS		4	/* number of interrupt levels (not including level zero!) */
-#define XCHAL_NUM_LOWPRI_LEVELS		1			/* number of low-priority interrupt levels (always 1) */
-#define XCHAL_FIRST_HIGHPRI_LEVEL	(XCHAL_NUM_LOWPRI_LEVELS+1)	/* level of first high-priority interrupt (always 2) */
-#define XCHAL_EXCM_LEVEL		1			/* level of interrupts masked by PS.EXCM (XEA2 only; always 1 in T10xx);
-								   for XEA1, where there is no PS.EXCM, this is always 1;
-								   interrupts at levels FIRST_HIGHPRI <= n <= EXCM_LEVEL, if any,
-								   are termed "medium priority" interrupts (post T10xx only) */
-/*  Note:  1 <= LOWPRI_LEVELS <= EXCM_LEVEL < DEBUGLEVEL <= NUM_INTLEVELS < NMILEVEL <= 15  */
-
-/*  Masks of interrupts at each interrupt level:  */
-#define XCHAL_INTLEVEL0_MASK		0x00000000
-#define XCHAL_INTLEVEL1_MASK		0x000064F9
-#define XCHAL_INTLEVEL2_MASK		0x00008902
-#define XCHAL_INTLEVEL3_MASK		0x00011204
-#define XCHAL_INTLEVEL4_MASK		0x00000000
-#define XCHAL_INTLEVEL5_MASK		0x00000000
-#define XCHAL_INTLEVEL6_MASK		0x00000000
-#define XCHAL_INTLEVEL7_MASK		0x00000000
-#define XCHAL_INTLEVEL8_MASK		0x00000000
-#define XCHAL_INTLEVEL9_MASK		0x00000000
-#define XCHAL_INTLEVEL10_MASK		0x00000000
-#define XCHAL_INTLEVEL11_MASK		0x00000000
-#define XCHAL_INTLEVEL12_MASK		0x00000000
-#define XCHAL_INTLEVEL13_MASK		0x00000000
-#define XCHAL_INTLEVEL14_MASK		0x00000000
-#define XCHAL_INTLEVEL15_MASK		0x00000000
-/*  As an array of entries (eg. for C constant arrays):  */
-#define XCHAL_INTLEVEL_MASKS		0x00000000	XCHAL_SEP \
-					0x000064F9	XCHAL_SEP \
-					0x00008902	XCHAL_SEP \
-					0x00011204	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000	XCHAL_SEP \
-					0x00000000
-
-/*  Masks of interrupts at each range 1..n of interrupt levels:  */
-#define XCHAL_INTLEVEL0_ANDBELOW_MASK	0x00000000
-#define XCHAL_INTLEVEL1_ANDBELOW_MASK	0x000064F9
-#define XCHAL_INTLEVEL2_ANDBELOW_MASK	0x0000EDFB
-#define XCHAL_INTLEVEL3_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL4_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL5_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL6_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL7_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL8_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL9_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL10_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL11_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL12_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL13_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL14_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_INTLEVEL15_ANDBELOW_MASK	0x0001FFFF
-#define XCHAL_LOWPRI_MASK		XCHAL_INTLEVEL1_ANDBELOW_MASK	/* mask of all low-priority interrupts */
-#define XCHAL_EXCM_MASK			XCHAL_INTLEVEL1_ANDBELOW_MASK	/* mask of all interrupts masked by PS.EXCM (or CEXCM) */
-/*  As an array of entries (eg. for C constant arrays):  */
-#define XCHAL_INTLEVEL_ANDBELOW_MASKS	0x00000000	XCHAL_SEP \
-					0x000064F9	XCHAL_SEP \
-					0x0000EDFB	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF	XCHAL_SEP \
-					0x0001FFFF
-
-/*  Interrupt numbers for each interrupt level at which only one interrupt was configured:  */
-/*#define XCHAL_INTLEVEL1_NUM		...more than one interrupt at this level...*/
-/*#define XCHAL_INTLEVEL2_NUM		...more than one interrupt at this level...*/
-/*#define XCHAL_INTLEVEL3_NUM		...more than one interrupt at this level...*/
-
-/*  Level of each interrupt:  */
-#define XCHAL_INT0_LEVEL		1
-#define XCHAL_INT1_LEVEL		2
-#define XCHAL_INT2_LEVEL		3
-#define XCHAL_INT3_LEVEL		1
-#define XCHAL_INT4_LEVEL		1
-#define XCHAL_INT5_LEVEL		1
-#define XCHAL_INT6_LEVEL		1
-#define XCHAL_INT7_LEVEL		1
-#define XCHAL_INT8_LEVEL		2
-#define XCHAL_INT9_LEVEL		3
-#define XCHAL_INT10_LEVEL		1
-#define XCHAL_INT11_LEVEL		2
-#define XCHAL_INT12_LEVEL		3
-#define XCHAL_INT13_LEVEL		1
-#define XCHAL_INT14_LEVEL		1
-#define XCHAL_INT15_LEVEL		2
-#define XCHAL_INT16_LEVEL		3
-#define XCHAL_INT17_LEVEL		0
-#define XCHAL_INT18_LEVEL		0
-#define XCHAL_INT19_LEVEL		0
-#define XCHAL_INT20_LEVEL		0
-#define XCHAL_INT21_LEVEL		0
-#define XCHAL_INT22_LEVEL		0
-#define XCHAL_INT23_LEVEL		0
-#define XCHAL_INT24_LEVEL		0
-#define XCHAL_INT25_LEVEL		0
-#define XCHAL_INT26_LEVEL		0
-#define XCHAL_INT27_LEVEL		0
-#define XCHAL_INT28_LEVEL		0
-#define XCHAL_INT29_LEVEL		0
-#define XCHAL_INT30_LEVEL		0
-#define XCHAL_INT31_LEVEL		0
-/*  As an array of entries (eg. for C constant arrays):  */
-#define XCHAL_INT_LEVELS		1	XCHAL_SEP \
-					2	XCHAL_SEP \
-					3	XCHAL_SEP \
-					1	XCHAL_SEP \
-					1	XCHAL_SEP \
-					1	XCHAL_SEP \
-					1	XCHAL_SEP \
-					1	XCHAL_SEP \
-					2	XCHAL_SEP \
-					3	XCHAL_SEP \
-					1	XCHAL_SEP \
-					2	XCHAL_SEP \
-					3	XCHAL_SEP \
-					1	XCHAL_SEP \
-					1	XCHAL_SEP \
-					2	XCHAL_SEP \
-					3	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0	XCHAL_SEP \
-					0
-
-/*  Type of each interrupt:  */
-#define XCHAL_INT0_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
-#define XCHAL_INT1_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
-#define XCHAL_INT2_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
-#define XCHAL_INT3_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
-#define XCHAL_INT4_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
-#define XCHAL_INT5_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
-#define XCHAL_INT6_TYPE 	XTHAL_INTTYPE_EXTERN_LEVEL
-#define XCHAL_INT7_TYPE 	XTHAL_INTTYPE_EXTERN_EDGE
-#define XCHAL_INT8_TYPE 	XTHAL_INTTYPE_EXTERN_EDGE
-#define XCHAL_INT9_TYPE 	XTHAL_INTTYPE_EXTERN_EDGE
-#define XCHAL_INT10_TYPE 	XTHAL_INTTYPE_TIMER
-#define XCHAL_INT11_TYPE 	XTHAL_INTTYPE_TIMER
-#define XCHAL_INT12_TYPE 	XTHAL_INTTYPE_TIMER
-#define XCHAL_INT13_TYPE 	XTHAL_INTTYPE_SOFTWARE
-#define XCHAL_INT14_TYPE 	XTHAL_INTTYPE_SOFTWARE
-#define XCHAL_INT15_TYPE 	XTHAL_INTTYPE_SOFTWARE
-#define XCHAL_INT16_TYPE 	XTHAL_INTTYPE_SOFTWARE
-#define XCHAL_INT17_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT18_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT19_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT20_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT21_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT22_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT23_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT24_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT25_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT26_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT27_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT28_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT29_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT30_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-#define XCHAL_INT31_TYPE 	XTHAL_INTTYPE_UNCONFIGURED
-/*  As an array of entries (eg. for C constant arrays):  */
-#define XCHAL_INT_TYPES		XTHAL_INTTYPE_EXTERN_LEVEL     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_LEVEL     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_LEVEL     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_LEVEL     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_LEVEL     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_LEVEL     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_LEVEL     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_EDGE     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_EDGE     	XCHAL_SEP \
-				XTHAL_INTTYPE_EXTERN_EDGE     	XCHAL_SEP \
-				XTHAL_INTTYPE_TIMER     	XCHAL_SEP \
-				XTHAL_INTTYPE_TIMER     	XCHAL_SEP \
-				XTHAL_INTTYPE_TIMER     	XCHAL_SEP \
-				XTHAL_INTTYPE_SOFTWARE     	XCHAL_SEP \
-				XTHAL_INTTYPE_SOFTWARE     	XCHAL_SEP \
-				XTHAL_INTTYPE_SOFTWARE     	XCHAL_SEP \
-				XTHAL_INTTYPE_SOFTWARE     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED     	XCHAL_SEP \
-				XTHAL_INTTYPE_UNCONFIGURED
-
-/*  Masks of interrupts for each type of interrupt:  */
-#define XCHAL_INTTYPE_MASK_UNCONFIGURED	0xFFFE0000
-#define XCHAL_INTTYPE_MASK_SOFTWARE	0x0001E000
-#define XCHAL_INTTYPE_MASK_EXTERN_EDGE	0x00000380
-#define XCHAL_INTTYPE_MASK_EXTERN_LEVEL	0x0000007F
-#define XCHAL_INTTYPE_MASK_TIMER	0x00001C00
-#define XCHAL_INTTYPE_MASK_NMI		0x00000000
-/*  As an array of entries (eg. for C constant arrays):  */
-#define XCHAL_INTTYPE_MASKS		0xFFFE0000	XCHAL_SEP \
-					0x0001E000	XCHAL_SEP \
-					0x00000380	XCHAL_SEP \
-					0x0000007F	XCHAL_SEP \
-					0x00001C00	XCHAL_SEP \
-					0x00000000
-
-/*  Interrupts assigned to each timer (CCOMPARE0 to CCOMPARE3), -1 if unassigned  */
-#define XCHAL_TIMER0_INTERRUPT	10
-#define XCHAL_TIMER1_INTERRUPT	11
-#define XCHAL_TIMER2_INTERRUPT	12
-#define XCHAL_TIMER3_INTERRUPT	XTHAL_TIMER_UNCONFIGURED
-/*  As an array of entries (eg. for C constant arrays):  */
-#define XCHAL_TIMER_INTERRUPTS	10	XCHAL_SEP \
-				11	XCHAL_SEP \
-				12	XCHAL_SEP \
-				XTHAL_TIMER_UNCONFIGURED
-
-/*  Indexing macros:  */
-#define _XCHAL_INTLEVEL_MASK(n)		XCHAL_INTLEVEL ## n ## _MASK
-#define XCHAL_INTLEVEL_MASK(n)		_XCHAL_INTLEVEL_MASK(n)		/* n = 0 .. 15 */
-#define _XCHAL_INTLEVEL_ANDBELOWMASK(n)	XCHAL_INTLEVEL ## n ## _ANDBELOW_MASK
-#define XCHAL_INTLEVEL_ANDBELOW_MASK(n)	_XCHAL_INTLEVEL_ANDBELOWMASK(n)	/* n = 0 .. 15 */
-#define _XCHAL_INT_LEVEL(n)		XCHAL_INT ## n ## _LEVEL
-#define XCHAL_INT_LEVEL(n)		_XCHAL_INT_LEVEL(n)		/* n = 0 .. 31 */
-#define _XCHAL_INT_TYPE(n)		XCHAL_INT ## n ## _TYPE
-#define XCHAL_INT_TYPE(n)		_XCHAL_INT_TYPE(n)		/* n = 0 .. 31 */
-#define _XCHAL_TIMER_INTERRUPT(n)	XCHAL_TIMER ## n ## _INTERRUPT
-#define XCHAL_TIMER_INTERRUPT(n)	_XCHAL_TIMER_INTERRUPT(n)	/* n = 0 .. 3 */
-
-
-
-/*
- *  External interrupt vectors/levels.
- *  These macros describe how Xtensa processor interrupt numbers
- *  (as numbered internally, eg. in INTERRUPT and INTENABLE registers)
- *  map to external BInterrupt<n> pins, for those interrupts
- *  configured as external (level-triggered, edge-triggered, or NMI).
- *  See the Xtensa processor databook for more details.
- */
-
-/*  Core interrupt numbers mapped to each EXTERNAL interrupt number:  */
-#define XCHAL_EXTINT0_NUM		0	/* (intlevel 1) */
-#define XCHAL_EXTINT1_NUM		1	/* (intlevel 2) */
-#define XCHAL_EXTINT2_NUM		2	/* (intlevel 3) */
-#define XCHAL_EXTINT3_NUM		3	/* (intlevel 1) */
-#define XCHAL_EXTINT4_NUM		4	/* (intlevel 1) */
-#define XCHAL_EXTINT5_NUM		5	/* (intlevel 1) */
-#define XCHAL_EXTINT6_NUM		6	/* (intlevel 1) */
-#define XCHAL_EXTINT7_NUM		7	/* (intlevel 1) */
-#define XCHAL_EXTINT8_NUM		8	/* (intlevel 2) */
-#define XCHAL_EXTINT9_NUM		9	/* (intlevel 3) */
-
-/*  Corresponding interrupt masks:  */
-#define XCHAL_EXTINT0_MASK		0x00000001
-#define XCHAL_EXTINT1_MASK		0x00000002
-#define XCHAL_EXTINT2_MASK		0x00000004
-#define XCHAL_EXTINT3_MASK		0x00000008
-#define XCHAL_EXTINT4_MASK		0x00000010
-#define XCHAL_EXTINT5_MASK		0x00000020
-#define XCHAL_EXTINT6_MASK		0x00000040
-#define XCHAL_EXTINT7_MASK		0x00000080
-#define XCHAL_EXTINT8_MASK		0x00000100
-#define XCHAL_EXTINT9_MASK		0x00000200
-
-/*  Core config interrupt levels mapped to each external interrupt:  */
-#define XCHAL_EXTINT0_LEVEL		1	/* (int number 0) */
-#define XCHAL_EXTINT1_LEVEL		2	/* (int number 1) */
-#define XCHAL_EXTINT2_LEVEL		3	/* (int number 2) */
-#define XCHAL_EXTINT3_LEVEL		1	/* (int number 3) */
-#define XCHAL_EXTINT4_LEVEL		1	/* (int number 4) */
-#define XCHAL_EXTINT5_LEVEL		1	/* (int number 5) */
-#define XCHAL_EXTINT6_LEVEL		1	/* (int number 6) */
-#define XCHAL_EXTINT7_LEVEL		1	/* (int number 7) */
-#define XCHAL_EXTINT8_LEVEL		2	/* (int number 8) */
-#define XCHAL_EXTINT9_LEVEL		3	/* (int number 9) */
-
-
-/*----------------------------------------------------------------------
-			EXCEPTIONS and VECTORS
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_EXCEPTIONS		1	/* 1 if exception option configured, 0 otherwise */
-
-#define XCHAL_XEA_VERSION		2	/* Xtensa Exception Architecture number: 1 for XEA1 (old), 2 for XEA2 (new) */
-#define XCHAL_HAVE_XEA1			0	/* 1 if XEA1, 0 otherwise */
-#define XCHAL_HAVE_XEA2			1	/* 1 if XEA2, 0 otherwise */
-/*  For backward compatibility ONLY -- DO NOT USE (will be removed in future release):  */
-#define XCHAL_HAVE_OLD_EXC_ARCH		XCHAL_HAVE_XEA1	/* (DEPRECATED) 1 if old exception architecture (XEA1), 0 otherwise (eg. XEA2) */
-#define XCHAL_HAVE_EXCM			XCHAL_HAVE_XEA2	/* (DEPRECATED) 1 if PS.EXCM bit exists (currently equals XCHAL_HAVE_TLBS) */
-
-#define XCHAL_RESET_VECTOR_VADDR	0xFE000020
-#define XCHAL_RESET_VECTOR_PADDR	0xFE000020
-#define XCHAL_USER_VECTOR_VADDR		0xD0000220
-#define XCHAL_PROGRAMEXC_VECTOR_VADDR	XCHAL_USER_VECTOR_VADDR		/* for backward compatibility */
-#define XCHAL_USEREXC_VECTOR_VADDR	XCHAL_USER_VECTOR_VADDR		/* for backward compatibility */
-#define XCHAL_USER_VECTOR_PADDR		0x00000220
-#define XCHAL_PROGRAMEXC_VECTOR_PADDR	XCHAL_USER_VECTOR_PADDR		/* for backward compatibility */
-#define XCHAL_USEREXC_VECTOR_PADDR	XCHAL_USER_VECTOR_PADDR		/* for backward compatibility */
-#define XCHAL_KERNEL_VECTOR_VADDR	0xD0000200
-#define XCHAL_STACKEDEXC_VECTOR_VADDR	XCHAL_KERNEL_VECTOR_VADDR	/* for backward compatibility */
-#define XCHAL_KERNELEXC_VECTOR_VADDR	XCHAL_KERNEL_VECTOR_VADDR	/* for backward compatibility */
-#define XCHAL_KERNEL_VECTOR_PADDR	0x00000200
-#define XCHAL_STACKEDEXC_VECTOR_PADDR	XCHAL_KERNEL_VECTOR_PADDR	/* for backward compatibility */
-#define XCHAL_KERNELEXC_VECTOR_PADDR	XCHAL_KERNEL_VECTOR_PADDR	/* for backward compatibility */
-#define XCHAL_DOUBLEEXC_VECTOR_VADDR	0xD0000290
-#define XCHAL_DOUBLEEXC_VECTOR_PADDR	0x00000290
-#define XCHAL_WINDOW_VECTORS_VADDR	0xD0000000
-#define XCHAL_WINDOW_VECTORS_PADDR	0x00000000
-#define XCHAL_INTLEVEL2_VECTOR_VADDR	0xD0000240
-#define XCHAL_INTLEVEL2_VECTOR_PADDR	0x00000240
-#define XCHAL_INTLEVEL3_VECTOR_VADDR	0xD0000250
-#define XCHAL_INTLEVEL3_VECTOR_PADDR	0x00000250
-#define XCHAL_INTLEVEL4_VECTOR_VADDR	0xFE000520
-#define XCHAL_INTLEVEL4_VECTOR_PADDR	0xFE000520
-#define XCHAL_DEBUG_VECTOR_VADDR	XCHAL_INTLEVEL4_VECTOR_VADDR
-#define XCHAL_DEBUG_VECTOR_PADDR	XCHAL_INTLEVEL4_VECTOR_PADDR
-
-/*  Indexing macros:  */
-#define _XCHAL_INTLEVEL_VECTOR_VADDR(n)		XCHAL_INTLEVEL ## n ## _VECTOR_VADDR
-#define XCHAL_INTLEVEL_VECTOR_VADDR(n)		_XCHAL_INTLEVEL_VECTOR_VADDR(n)		/* n = 0 .. 15 */
-
-/*
- *  General Exception Causes
- *  (values of EXCCAUSE special register set by general exceptions,
- *   which vector to the user, kernel, or double-exception vectors):
- */
-#define XCHAL_EXCCAUSE_ILLEGAL_INSTRUCTION		0	/* Illegal Instruction (IllegalInstruction) */
-#define XCHAL_EXCCAUSE_SYSTEM_CALL			1	/* System Call (SystemCall) */
-#define XCHAL_EXCCAUSE_INSTRUCTION_FETCH_ERROR		2	/* Instruction Fetch Error (InstructionFetchError) */
-#define XCHAL_EXCCAUSE_LOAD_STORE_ERROR			3	/* Load Store Error (LoadStoreError) */
-#define XCHAL_EXCCAUSE_LEVEL1_INTERRUPT			4	/* Level 1 Interrupt (Level1Interrupt) */
-#define XCHAL_EXCCAUSE_ALLOCA				5	/* Stack Extension Assist (Alloca) */
-#define XCHAL_EXCCAUSE_INTEGER_DIVIDE_BY_ZERO		6	/* Integer Divide by Zero (IntegerDivideByZero) */
-#define XCHAL_EXCCAUSE_SPECULATION			7	/* Speculation (Speculation) */
-#define XCHAL_EXCCAUSE_PRIVILEGED			8	/* Privileged Instruction (Privileged) */
-#define XCHAL_EXCCAUSE_UNALIGNED			9	/* Unaligned Load Store (Unaligned) */
-#define XCHAL_EXCCAUSE_ITLB_MISS			16	/* ITlb Miss Exception (ITlbMiss) */
-#define XCHAL_EXCCAUSE_ITLB_MULTIHIT			17	/* ITlb Mutltihit Exception (ITlbMultihit) */
-#define XCHAL_EXCCAUSE_ITLB_PRIVILEGE			18	/* ITlb Privilege Exception (ITlbPrivilege) */
-#define XCHAL_EXCCAUSE_ITLB_SIZE_RESTRICTION		19	/* ITlb Size Restriction Exception (ITlbSizeRestriction) */
-#define XCHAL_EXCCAUSE_FETCH_CACHE_ATTRIBUTE		20	/* Fetch Cache Attribute Exception (FetchCacheAttribute) */
-#define XCHAL_EXCCAUSE_DTLB_MISS			24	/* DTlb Miss Exception (DTlbMiss) */
-#define XCHAL_EXCCAUSE_DTLB_MULTIHIT			25	/* DTlb Multihit Exception (DTlbMultihit) */
-#define XCHAL_EXCCAUSE_DTLB_PRIVILEGE			26	/* DTlb Privilege Exception (DTlbPrivilege) */
-#define XCHAL_EXCCAUSE_DTLB_SIZE_RESTRICTION		27	/* DTlb Size Restriction Exception (DTlbSizeRestriction) */
-#define XCHAL_EXCCAUSE_LOAD_CACHE_ATTRIBUTE		28	/* Load Cache Attribute Exception (LoadCacheAttribute) */
-#define XCHAL_EXCCAUSE_STORE_CACHE_ATTRIBUTE		29	/* Store Cache Attribute Exception (StoreCacheAttribute) */
-#define XCHAL_EXCCAUSE_FLOATING_POINT			40	/* Floating Point Exception (FloatingPoint) */
-
-
-
-/*----------------------------------------------------------------------
-				TIMERS
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_CCOUNT		1	/* 1 if have CCOUNT, 0 otherwise */
-/*#define XCHAL_HAVE_TIMERS		XCHAL_HAVE_CCOUNT*/
-#define XCHAL_NUM_TIMERS		3	/* number of CCOMPAREn regs */
-
-
-
-/*----------------------------------------------------------------------
-				DEBUG
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_DEBUG		1	/* 1 if debug option configured, 0 otherwise */
-#define XCHAL_HAVE_OCD			1	/* 1 if OnChipDebug option configured, 0 otherwise */
-#define XCHAL_NUM_IBREAK		2	/* number of IBREAKn regs */
-#define XCHAL_NUM_DBREAK		2	/* number of DBREAKn regs */
-#define XCHAL_DEBUGLEVEL		4	/* debug interrupt level */
-/*DebugExternalInterrupt		0		0|1*/
-/*DebugUseDIRArray			0		0|1*/
-
-
-
-
-/*----------------------------------------------------------------------
-			COPROCESSORS and EXTRA STATE
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_CP			0	/* 1 if coprocessor option configured (CPENABLE present) */
-#define XCHAL_CP_MAXCFG			0	/* max allowed cp id plus one (per cfg) */
-
-#include <xtensa/config/tie.h>
-
-
-
-
-/*----------------------------------------------------------------------
-			INTERNAL I/D RAM/ROMs and XLMI
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_NUM_INSTROM		0	/* number of core instruction ROMs configured */
-#define XCHAL_NUM_INSTRAM		0	/* number of core instruction RAMs configured */
-#define XCHAL_NUM_DATAROM		0	/* number of core data ROMs configured */
-#define XCHAL_NUM_DATARAM		0	/* number of core data RAMs configured */
-#define XCHAL_NUM_XLMI			0	/* number of core XLMI ports configured */
-#define  XCHAL_NUM_IROM			XCHAL_NUM_INSTROM	/* (DEPRECATED) */
-#define  XCHAL_NUM_IRAM			XCHAL_NUM_INSTRAM	/* (DEPRECATED) */
-#define  XCHAL_NUM_DROM			XCHAL_NUM_DATAROM	/* (DEPRECATED) */
-#define  XCHAL_NUM_DRAM			XCHAL_NUM_DATARAM	/* (DEPRECATED) */
-
-
-
-/*----------------------------------------------------------------------
-				CACHE
-  ----------------------------------------------------------------------*/
-
-/*  Size of the cache lines in log2(bytes):  */
-#define XCHAL_ICACHE_LINEWIDTH		4
-#define XCHAL_DCACHE_LINEWIDTH		4
-/*  Size of the cache lines in bytes:  */
-#define XCHAL_ICACHE_LINESIZE		16
-#define XCHAL_DCACHE_LINESIZE		16
-/*  Max for both I-cache and D-cache (used for general alignment):  */
-#define XCHAL_CACHE_LINEWIDTH_MAX	4
-#define XCHAL_CACHE_LINESIZE_MAX	16
-
-/*  Number of cache sets in log2(lines per way):  */
-#define XCHAL_ICACHE_SETWIDTH		8
-#define XCHAL_DCACHE_SETWIDTH		8
-/*  Max for both I-cache and D-cache (used for general cache-coherency page alignment):  */
-#define XCHAL_CACHE_SETWIDTH_MAX	8
-#define XCHAL_CACHE_SETSIZE_MAX		256
-
-/*  Cache set associativity (number of ways):  */
-#define XCHAL_ICACHE_WAYS		2
-#define XCHAL_DCACHE_WAYS		2
-
-/*  Size of the caches in bytes (ways * 2^(linewidth + setwidth)):  */
-#define XCHAL_ICACHE_SIZE		8192
-#define XCHAL_DCACHE_SIZE		8192
-
-/*  Cache features:  */
-#define XCHAL_DCACHE_IS_WRITEBACK	0
-/*  Whether cache locking feature is available:  */
-#define XCHAL_ICACHE_LINE_LOCKABLE	0
-#define XCHAL_DCACHE_LINE_LOCKABLE	0
-
-/*  Number of (encoded) cache attribute bits:  */
-#define XCHAL_CA_BITS			4	/* number of bits needed to hold cache attribute encoding */
-/*  (The number of access mode bits (decoded cache attribute bits) is defined by the architecture; see xtensa/hal.h?)  */
-
-
-/*  Cache Attribute encodings -- lists of access modes for each cache attribute:  */
-#define XCHAL_FCA_LIST		XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_BYPASS	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_BYPASS	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_CACHED	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_CACHED	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_CACHED	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_CACHED	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_FAM_EXCEPTION
-#define XCHAL_LCA_LIST		XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_BYPASSG	XCHAL_SEP \
-				XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_BYPASSG	XCHAL_SEP \
-				XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_CACHED	XCHAL_SEP \
-				XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_CACHED	XCHAL_SEP \
-				XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_NACACHED	XCHAL_SEP \
-				XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_NACACHED	XCHAL_SEP \
-				XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_ISOLATE	XCHAL_SEP \
-				XTHAL_LAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_LAM_CACHED
-#define XCHAL_SCA_LIST		XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_BYPASS	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_WRITETHRU	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_WRITETHRU	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_ISOLATE	XCHAL_SEP \
-				XTHAL_SAM_EXCEPTION	XCHAL_SEP \
-				XTHAL_SAM_WRITETHRU
-
-/*  Test:
-	read/only: 0 + 1 + 2 + 4 + 5 + 6 + 8 + 9 + 10 + 12 + 14
-	read/only: 0 + 1 + 2 + 4 + 5 + 6 + 8 + 9 + 10 + 12 + 14
-	all:       0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 + 11 + 12 + 13 + 14 + 15
-	fault:     0 + 2 + 4 + 6 + 8 + 10 + 12 + 14
-	r/w/x cached:
-	r/w/x dcached:
-	I-bypass:  1 + 3
-
-	load guard bit set: 1 + 3
-	load guard bit clr: 0 + 2 + 4 + 5 + 6 + 7 + 8 + 9 + 10 + 11 + 12 + 13 + 14 + 15
-	hit-cache r/w/x: 7 + 11
-
-	fams: 5
-	fams: 0 / 6 / 18 / 1 / 2
-	fams: Bypass / Isolate / Cached / Exception / NACached
-
-        MMU okay:  yes
-*/
-
-
-/*----------------------------------------------------------------------
-				MMU
-  ----------------------------------------------------------------------*/
-
-/*
- *  General notes on MMU parameters.
- *
- *  Terminology:
- *	ASID = address-space ID (acts as an "extension" of virtual addresses)
- *	VPN  = virtual page number
- *	PPN  = physical page number
- *	CA   = encoded cache attribute (access modes)
- *	TLB  = translation look-aside buffer (term is stretched somewhat here)
- *	I    = instruction (fetch accesses)
- *	D    = data (load and store accesses)
- *	way  = each TLB (ITLB and DTLB) consists of a number of "ways"
- *		that simultaneously match the virtual address of an access;
- *		a TLB successfully translates a virtual address if exactly
- *		one way matches the vaddr; if none match, it is a miss;
- *		if multiple match, one gets a "multihit" exception;
- *		each way can be independently configured in terms of number of
- *		entries, page sizes, which fields are writable or constant, etc.
- *	set  = group of contiguous ways with exactly identical parameters
- *	ARF  = auto-refill; hardware services a 1st-level miss by loading a PTE
- *		from the page table and storing it in one of the auto-refill ways;
- *		if this PTE load also misses, a miss exception is posted for s/w.
- *	min-wired = a "min-wired" way can be used to map a single (minimum-sized)
- * 		page arbitrarily under program control; it has a single entry,
- *		is non-auto-refill (some other way(s) must be auto-refill),
- *		all its fields (VPN, PPN, ASID, CA) are all writable, and it
- *		supports the XCHAL_MMU_MIN_PTE_PAGE_SIZE page size (a current
- *		restriction is that this be the only page size it supports).
- *
- *  TLB way entries are virtually indexed.
- *  TLB ways that support multiple page sizes:
- *	- must have all writable VPN and PPN fields;
- *	- can only use one page size at any given time (eg. setup at startup),
- *	  selected by the respective ITLBCFG or DTLBCFG special register,
- *	  whose bits n*4+3 .. n*4 index the list of page sizes for way n
- *	  (XCHAL_xTLB_SETm_PAGESZ_LOG2_LIST for set m corresponding to way n);
- *	  this list may be sparse for auto-refill ways because auto-refill
- *	  ways have independent lists of supported page sizes sharing a
- *	  common encoding with PTE entries; the encoding is the index into
- *	  this list; unsupported sizes for a given way are zero in the list;
- *	  selecting unsupported sizes results in undefined hardware behaviour;
- *	- is only possible for ways 0 thru 7 (due to ITLBCFG/DTLBCFG definition).
- */
-
-#define XCHAL_HAVE_CACHEATTR		0	/* 1 if CACHEATTR register present, 0 if TLBs present instead */
-#define XCHAL_HAVE_TLBS			1	/* 1 if TLBs present, 0 if CACHEATTR present instead */
-#define XCHAL_HAVE_MMU			XCHAL_HAVE_TLBS	/* (DEPRECATED; use XCHAL_HAVE_TLBS instead; will be removed in future release) */
-#define XCHAL_HAVE_SPANNING_WAY		0	/* 1 if single way maps entire virtual address space in I+D */
-#define XCHAL_HAVE_IDENTITY_MAP		0	/* 1 if virtual addr == physical addr always, 0 otherwise */
-#define XCHAL_HAVE_MIMIC_CACHEATTR	0	/* 1 if have MMU that mimics a CACHEATTR config (CaMMU) */
-#define XCHAL_HAVE_XLT_CACHEATTR	0	/* 1 if have MMU that mimics a CACHEATTR config, but with translation (CaXltMMU) */
-
-#define XCHAL_MMU_ASID_BITS		8	/* number of bits in ASIDs (address space IDs) */
-#define XCHAL_MMU_ASID_INVALID		0	/* ASID value indicating invalid address space */
-#define XCHAL_MMU_ASID_KERNEL		1	/* ASID value indicating kernel (ring 0) address space */
-#define XCHAL_MMU_RINGS			4	/* number of rings supported (1..4) */
-#define XCHAL_MMU_RING_BITS		2	/* number of bits needed to hold ring number */
-#define XCHAL_MMU_SR_BITS		0	/* number of size-restriction bits supported */
-#define XCHAL_MMU_CA_BITS		4	/* number of bits needed to hold cache attribute encoding */
-#define XCHAL_MMU_MAX_PTE_PAGE_SIZE	12	/* max page size in a PTE structure (log2) */
-#define XCHAL_MMU_MIN_PTE_PAGE_SIZE	12	/* min page size in a PTE structure (log2) */
-
-
-/***  Instruction TLB:  ***/
-
-#define XCHAL_ITLB_WAY_BITS		3	/* number of bits holding the ways */
-#define XCHAL_ITLB_WAYS			7	/* number of ways (n-way set-associative TLB) */
-#define XCHAL_ITLB_ARF_WAYS		4	/* number of auto-refill ways */
-#define XCHAL_ITLB_SETS			4	/* number of sets (groups of ways with identical settings) */
-
-/*  Way set to which each way belongs:  */
-#define XCHAL_ITLB_WAY0_SET		0
-#define XCHAL_ITLB_WAY1_SET		0
-#define XCHAL_ITLB_WAY2_SET		0
-#define XCHAL_ITLB_WAY3_SET		0
-#define XCHAL_ITLB_WAY4_SET		1
-#define XCHAL_ITLB_WAY5_SET		2
-#define XCHAL_ITLB_WAY6_SET		3
-
-/*  Ways sets that are used by hardware auto-refill (ARF):  */
-#define XCHAL_ITLB_ARF_SETS		1	/* number of auto-refill sets */
-#define XCHAL_ITLB_ARF_SET0		0	/* index of n'th auto-refill set */
-
-/*  Way sets that are "min-wired" (see terminology comment above):  */
-#define XCHAL_ITLB_MINWIRED_SETS	0	/* number of "min-wired" sets */
-
-
-/*  ITLB way set 0 (group of ways 0 thru 3):  */
-#define XCHAL_ITLB_SET0_WAY			0	/* index of first way in this way set */
-#define XCHAL_ITLB_SET0_WAYS			4	/* number of (contiguous) ways in this way set */
-#define XCHAL_ITLB_SET0_ENTRIES_LOG2		2	/* log2(number of entries in this way) */
-#define XCHAL_ITLB_SET0_ENTRIES			4	/* number of entries in this way (always a power of 2) */
-#define XCHAL_ITLB_SET0_ARF			1	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_ITLB_SET0_PAGESIZES		1	/* number of supported page sizes in this way */
-#define XCHAL_ITLB_SET0_PAGESZ_BITS		0	/* number of bits to encode the page size */
-#define XCHAL_ITLB_SET0_PAGESZ_LOG2_MIN		12	/* log2(minimum supported page size) */
-#define XCHAL_ITLB_SET0_PAGESZ_LOG2_MAX		12	/* log2(maximum supported page size) */
-#define XCHAL_ITLB_SET0_PAGESZ_LOG2_LIST	12	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_ITLB_SET0_ASID_CONSTMASK		0	/* constant ASID bits; 0 if all writable */
-#define XCHAL_ITLB_SET0_VPN_CONSTMASK		0	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET0_PPN_CONSTMASK		0	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET0_CA_CONSTMASK		0	/* constant CA bits; 0 if all writable */
-#define XCHAL_ITLB_SET0_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET0_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET0_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET0_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-
-/*  ITLB way set 1 (group of ways 4 thru 4):  */
-#define XCHAL_ITLB_SET1_WAY			4	/* index of first way in this way set */
-#define XCHAL_ITLB_SET1_WAYS			1	/* number of (contiguous) ways in this way set */
-#define XCHAL_ITLB_SET1_ENTRIES_LOG2		2	/* log2(number of entries in this way) */
-#define XCHAL_ITLB_SET1_ENTRIES			4	/* number of entries in this way (always a power of 2) */
-#define XCHAL_ITLB_SET1_ARF			0	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_ITLB_SET1_PAGESIZES		4	/* number of supported page sizes in this way */
-#define XCHAL_ITLB_SET1_PAGESZ_BITS		2	/* number of bits to encode the page size */
-#define XCHAL_ITLB_SET1_PAGESZ_LOG2_MIN		20	/* log2(minimum supported page size) */
-#define XCHAL_ITLB_SET1_PAGESZ_LOG2_MAX		26	/* log2(maximum supported page size) */
-#define XCHAL_ITLB_SET1_PAGESZ_LOG2_LIST	20 XCHAL_SEP 22 XCHAL_SEP 24 XCHAL_SEP 26	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_ITLB_SET1_ASID_CONSTMASK		0	/* constant ASID bits; 0 if all writable */
-#define XCHAL_ITLB_SET1_VPN_CONSTMASK		0	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET1_PPN_CONSTMASK		0	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET1_CA_CONSTMASK		0	/* constant CA bits; 0 if all writable */
-#define XCHAL_ITLB_SET1_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET1_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET1_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET1_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-
-/*  ITLB way set 2 (group of ways 5 thru 5):  */
-#define XCHAL_ITLB_SET2_WAY			5	/* index of first way in this way set */
-#define XCHAL_ITLB_SET2_WAYS			1	/* number of (contiguous) ways in this way set */
-#define XCHAL_ITLB_SET2_ENTRIES_LOG2		1	/* log2(number of entries in this way) */
-#define XCHAL_ITLB_SET2_ENTRIES			2	/* number of entries in this way (always a power of 2) */
-#define XCHAL_ITLB_SET2_ARF			0	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_ITLB_SET2_PAGESIZES		1	/* number of supported page sizes in this way */
-#define XCHAL_ITLB_SET2_PAGESZ_BITS		0	/* number of bits to encode the page size */
-#define XCHAL_ITLB_SET2_PAGESZ_LOG2_MIN		27	/* log2(minimum supported page size) */
-#define XCHAL_ITLB_SET2_PAGESZ_LOG2_MAX		27	/* log2(maximum supported page size) */
-#define XCHAL_ITLB_SET2_PAGESZ_LOG2_LIST	27	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_ITLB_SET2_ASID_CONSTMASK		0xFF	/* constant ASID bits; 0 if all writable */
-#define XCHAL_ITLB_SET2_VPN_CONSTMASK		0xF0000000	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET2_PPN_CONSTMASK		0xF8000000	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET2_CA_CONSTMASK		0x0000000F	/* constant CA bits; 0 if all writable */
-#define XCHAL_ITLB_SET2_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET2_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET2_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET2_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-/*  Constant ASID values for each entry of ITLB way set 2 (because ASID_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET2_E0_ASID_CONST		0x01
-#define XCHAL_ITLB_SET2_E1_ASID_CONST		0x01
-/*  Constant VPN values for each entry of ITLB way set 2 (because VPN_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET2_E0_VPN_CONST		0xD0000000
-#define XCHAL_ITLB_SET2_E1_VPN_CONST		0xD8000000
-/*  Constant PPN values for each entry of ITLB way set 2 (because PPN_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET2_E0_PPN_CONST		0x00000000
-#define XCHAL_ITLB_SET2_E1_PPN_CONST		0x00000000
-/*  Constant CA values for each entry of ITLB way set 2 (because CA_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET2_E0_CA_CONST		0x07
-#define XCHAL_ITLB_SET2_E1_CA_CONST		0x03
-
-/*  ITLB way set 3 (group of ways 6 thru 6):  */
-#define XCHAL_ITLB_SET3_WAY			6	/* index of first way in this way set */
-#define XCHAL_ITLB_SET3_WAYS			1	/* number of (contiguous) ways in this way set */
-#define XCHAL_ITLB_SET3_ENTRIES_LOG2		1	/* log2(number of entries in this way) */
-#define XCHAL_ITLB_SET3_ENTRIES			2	/* number of entries in this way (always a power of 2) */
-#define XCHAL_ITLB_SET3_ARF			0	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_ITLB_SET3_PAGESIZES		1	/* number of supported page sizes in this way */
-#define XCHAL_ITLB_SET3_PAGESZ_BITS		0	/* number of bits to encode the page size */
-#define XCHAL_ITLB_SET3_PAGESZ_LOG2_MIN		28	/* log2(minimum supported page size) */
-#define XCHAL_ITLB_SET3_PAGESZ_LOG2_MAX		28	/* log2(maximum supported page size) */
-#define XCHAL_ITLB_SET3_PAGESZ_LOG2_LIST	28	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_ITLB_SET3_ASID_CONSTMASK		0xFF	/* constant ASID bits; 0 if all writable */
-#define XCHAL_ITLB_SET3_VPN_CONSTMASK		0xE0000000	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET3_PPN_CONSTMASK		0xF0000000	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_ITLB_SET3_CA_CONSTMASK		0x0000000F	/* constant CA bits; 0 if all writable */
-#define XCHAL_ITLB_SET3_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET3_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET3_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_ITLB_SET3_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-/*  Constant ASID values for each entry of ITLB way set 3 (because ASID_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET3_E0_ASID_CONST		0x01
-#define XCHAL_ITLB_SET3_E1_ASID_CONST		0x01
-/*  Constant VPN values for each entry of ITLB way set 3 (because VPN_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET3_E0_VPN_CONST		0xE0000000
-#define XCHAL_ITLB_SET3_E1_VPN_CONST		0xF0000000
-/*  Constant PPN values for each entry of ITLB way set 3 (because PPN_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET3_E0_PPN_CONST		0xF0000000
-#define XCHAL_ITLB_SET3_E1_PPN_CONST		0xF0000000
-/*  Constant CA values for each entry of ITLB way set 3 (because CA_CONSTMASK is non-zero):  */
-#define XCHAL_ITLB_SET3_E0_CA_CONST		0x07
-#define XCHAL_ITLB_SET3_E1_CA_CONST		0x03
-
-/*  Indexing macros:  */
-#define _XCHAL_ITLB_SET(n,_what)	XCHAL_ITLB_SET ## n ## _what
-#define XCHAL_ITLB_SET(n,what)		_XCHAL_ITLB_SET(n, _ ## what )
-#define _XCHAL_ITLB_SET_E(n,i,_what)	XCHAL_ITLB_SET ## n ## _E ## i ## _what
-#define XCHAL_ITLB_SET_E(n,i,what)	_XCHAL_ITLB_SET_E(n,i, _ ## what )
-/*
- *  Example use:  XCHAL_ITLB_SET(XCHAL_ITLB_ARF_SET0,ENTRIES)
- *	to get the value of XCHAL_ITLB_SET<n>_ENTRIES where <n> is the first auto-refill set.
- */
-
-
-/***  Data TLB:  ***/
-
-#define XCHAL_DTLB_WAY_BITS		4	/* number of bits holding the ways */
-#define XCHAL_DTLB_WAYS			10	/* number of ways (n-way set-associative TLB) */
-#define XCHAL_DTLB_ARF_WAYS		4	/* number of auto-refill ways */
-#define XCHAL_DTLB_SETS			5	/* number of sets (groups of ways with identical settings) */
-
-/*  Way set to which each way belongs:  */
-#define XCHAL_DTLB_WAY0_SET		0
-#define XCHAL_DTLB_WAY1_SET		0
-#define XCHAL_DTLB_WAY2_SET		0
-#define XCHAL_DTLB_WAY3_SET		0
-#define XCHAL_DTLB_WAY4_SET		1
-#define XCHAL_DTLB_WAY5_SET		2
-#define XCHAL_DTLB_WAY6_SET		3
-#define XCHAL_DTLB_WAY7_SET		4
-#define XCHAL_DTLB_WAY8_SET		4
-#define XCHAL_DTLB_WAY9_SET		4
-
-/*  Ways sets that are used by hardware auto-refill (ARF):  */
-#define XCHAL_DTLB_ARF_SETS		1	/* number of auto-refill sets */
-#define XCHAL_DTLB_ARF_SET0		0	/* index of n'th auto-refill set */
-
-/*  Way sets that are "min-wired" (see terminology comment above):  */
-#define XCHAL_DTLB_MINWIRED_SETS	1	/* number of "min-wired" sets */
-#define XCHAL_DTLB_MINWIRED_SET0	4	/* index of n'th "min-wired" set */
-
-
-/*  DTLB way set 0 (group of ways 0 thru 3):  */
-#define XCHAL_DTLB_SET0_WAY			0	/* index of first way in this way set */
-#define XCHAL_DTLB_SET0_WAYS			4	/* number of (contiguous) ways in this way set */
-#define XCHAL_DTLB_SET0_ENTRIES_LOG2		2	/* log2(number of entries in this way) */
-#define XCHAL_DTLB_SET0_ENTRIES			4	/* number of entries in this way (always a power of 2) */
-#define XCHAL_DTLB_SET0_ARF			1	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_DTLB_SET0_PAGESIZES		1	/* number of supported page sizes in this way */
-#define XCHAL_DTLB_SET0_PAGESZ_BITS		0	/* number of bits to encode the page size */
-#define XCHAL_DTLB_SET0_PAGESZ_LOG2_MIN		12	/* log2(minimum supported page size) */
-#define XCHAL_DTLB_SET0_PAGESZ_LOG2_MAX		12	/* log2(maximum supported page size) */
-#define XCHAL_DTLB_SET0_PAGESZ_LOG2_LIST	12	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_DTLB_SET0_ASID_CONSTMASK		0	/* constant ASID bits; 0 if all writable */
-#define XCHAL_DTLB_SET0_VPN_CONSTMASK		0	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET0_PPN_CONSTMASK		0	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET0_CA_CONSTMASK		0	/* constant CA bits; 0 if all writable */
-#define XCHAL_DTLB_SET0_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET0_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET0_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET0_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-
-/*  DTLB way set 1 (group of ways 4 thru 4):  */
-#define XCHAL_DTLB_SET1_WAY			4	/* index of first way in this way set */
-#define XCHAL_DTLB_SET1_WAYS			1	/* number of (contiguous) ways in this way set */
-#define XCHAL_DTLB_SET1_ENTRIES_LOG2		2	/* log2(number of entries in this way) */
-#define XCHAL_DTLB_SET1_ENTRIES			4	/* number of entries in this way (always a power of 2) */
-#define XCHAL_DTLB_SET1_ARF			0	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_DTLB_SET1_PAGESIZES		4	/* number of supported page sizes in this way */
-#define XCHAL_DTLB_SET1_PAGESZ_BITS		2	/* number of bits to encode the page size */
-#define XCHAL_DTLB_SET1_PAGESZ_LOG2_MIN		20	/* log2(minimum supported page size) */
-#define XCHAL_DTLB_SET1_PAGESZ_LOG2_MAX		26	/* log2(maximum supported page size) */
-#define XCHAL_DTLB_SET1_PAGESZ_LOG2_LIST	20 XCHAL_SEP 22 XCHAL_SEP 24 XCHAL_SEP 26	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_DTLB_SET1_ASID_CONSTMASK		0	/* constant ASID bits; 0 if all writable */
-#define XCHAL_DTLB_SET1_VPN_CONSTMASK		0	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET1_PPN_CONSTMASK		0	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET1_CA_CONSTMASK		0	/* constant CA bits; 0 if all writable */
-#define XCHAL_DTLB_SET1_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET1_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET1_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET1_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-
-/*  DTLB way set 2 (group of ways 5 thru 5):  */
-#define XCHAL_DTLB_SET2_WAY			5	/* index of first way in this way set */
-#define XCHAL_DTLB_SET2_WAYS			1	/* number of (contiguous) ways in this way set */
-#define XCHAL_DTLB_SET2_ENTRIES_LOG2		1	/* log2(number of entries in this way) */
-#define XCHAL_DTLB_SET2_ENTRIES			2	/* number of entries in this way (always a power of 2) */
-#define XCHAL_DTLB_SET2_ARF			0	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_DTLB_SET2_PAGESIZES		1	/* number of supported page sizes in this way */
-#define XCHAL_DTLB_SET2_PAGESZ_BITS		0	/* number of bits to encode the page size */
-#define XCHAL_DTLB_SET2_PAGESZ_LOG2_MIN		27	/* log2(minimum supported page size) */
-#define XCHAL_DTLB_SET2_PAGESZ_LOG2_MAX		27	/* log2(maximum supported page size) */
-#define XCHAL_DTLB_SET2_PAGESZ_LOG2_LIST	27	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_DTLB_SET2_ASID_CONSTMASK		0xFF	/* constant ASID bits; 0 if all writable */
-#define XCHAL_DTLB_SET2_VPN_CONSTMASK		0xF0000000	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET2_PPN_CONSTMASK		0xF8000000	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET2_CA_CONSTMASK		0x0000000F	/* constant CA bits; 0 if all writable */
-#define XCHAL_DTLB_SET2_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET2_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET2_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET2_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-/*  Constant ASID values for each entry of DTLB way set 2 (because ASID_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET2_E0_ASID_CONST		0x01
-#define XCHAL_DTLB_SET2_E1_ASID_CONST		0x01
-/*  Constant VPN values for each entry of DTLB way set 2 (because VPN_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET2_E0_VPN_CONST		0xD0000000
-#define XCHAL_DTLB_SET2_E1_VPN_CONST		0xD8000000
-/*  Constant PPN values for each entry of DTLB way set 2 (because PPN_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET2_E0_PPN_CONST		0x00000000
-#define XCHAL_DTLB_SET2_E1_PPN_CONST		0x00000000
-/*  Constant CA values for each entry of DTLB way set 2 (because CA_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET2_E0_CA_CONST		0x07
-#define XCHAL_DTLB_SET2_E1_CA_CONST		0x03
-
-/*  DTLB way set 3 (group of ways 6 thru 6):  */
-#define XCHAL_DTLB_SET3_WAY			6	/* index of first way in this way set */
-#define XCHAL_DTLB_SET3_WAYS			1	/* number of (contiguous) ways in this way set */
-#define XCHAL_DTLB_SET3_ENTRIES_LOG2		1	/* log2(number of entries in this way) */
-#define XCHAL_DTLB_SET3_ENTRIES			2	/* number of entries in this way (always a power of 2) */
-#define XCHAL_DTLB_SET3_ARF			0	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_DTLB_SET3_PAGESIZES		1	/* number of supported page sizes in this way */
-#define XCHAL_DTLB_SET3_PAGESZ_BITS		0	/* number of bits to encode the page size */
-#define XCHAL_DTLB_SET3_PAGESZ_LOG2_MIN		28	/* log2(minimum supported page size) */
-#define XCHAL_DTLB_SET3_PAGESZ_LOG2_MAX		28	/* log2(maximum supported page size) */
-#define XCHAL_DTLB_SET3_PAGESZ_LOG2_LIST	28	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_DTLB_SET3_ASID_CONSTMASK		0xFF	/* constant ASID bits; 0 if all writable */
-#define XCHAL_DTLB_SET3_VPN_CONSTMASK		0xE0000000	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET3_PPN_CONSTMASK		0xF0000000	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET3_CA_CONSTMASK		0x0000000F	/* constant CA bits; 0 if all writable */
-#define XCHAL_DTLB_SET3_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET3_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET3_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET3_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-/*  Constant ASID values for each entry of DTLB way set 3 (because ASID_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET3_E0_ASID_CONST		0x01
-#define XCHAL_DTLB_SET3_E1_ASID_CONST		0x01
-/*  Constant VPN values for each entry of DTLB way set 3 (because VPN_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET3_E0_VPN_CONST		0xE0000000
-#define XCHAL_DTLB_SET3_E1_VPN_CONST		0xF0000000
-/*  Constant PPN values for each entry of DTLB way set 3 (because PPN_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET3_E0_PPN_CONST		0xF0000000
-#define XCHAL_DTLB_SET3_E1_PPN_CONST		0xF0000000
-/*  Constant CA values for each entry of DTLB way set 3 (because CA_CONSTMASK is non-zero):  */
-#define XCHAL_DTLB_SET3_E0_CA_CONST		0x07
-#define XCHAL_DTLB_SET3_E1_CA_CONST		0x03
-
-/*  DTLB way set 4 (group of ways 7 thru 9):  */
-#define XCHAL_DTLB_SET4_WAY			7	/* index of first way in this way set */
-#define XCHAL_DTLB_SET4_WAYS			3	/* number of (contiguous) ways in this way set */
-#define XCHAL_DTLB_SET4_ENTRIES_LOG2		0	/* log2(number of entries in this way) */
-#define XCHAL_DTLB_SET4_ENTRIES			1	/* number of entries in this way (always a power of 2) */
-#define XCHAL_DTLB_SET4_ARF			0	/* 1=autorefill by h/w, 0=non-autorefill (wired/constant/static) */
-#define XCHAL_DTLB_SET4_PAGESIZES		1	/* number of supported page sizes in this way */
-#define XCHAL_DTLB_SET4_PAGESZ_BITS		0	/* number of bits to encode the page size */
-#define XCHAL_DTLB_SET4_PAGESZ_LOG2_MIN		12	/* log2(minimum supported page size) */
-#define XCHAL_DTLB_SET4_PAGESZ_LOG2_MAX		12	/* log2(maximum supported page size) */
-#define XCHAL_DTLB_SET4_PAGESZ_LOG2_LIST	12	/* list of log2(page size)s, separated by XCHAL_SEP;
-							   2^PAGESZ_BITS entries in list, unsupported entries are zero */
-#define XCHAL_DTLB_SET4_ASID_CONSTMASK		0	/* constant ASID bits; 0 if all writable */
-#define XCHAL_DTLB_SET4_VPN_CONSTMASK		0	/* constant VPN bits, not including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET4_PPN_CONSTMASK		0	/* constant PPN bits, including entry index bits; 0 if all writable */
-#define XCHAL_DTLB_SET4_CA_CONSTMASK		0	/* constant CA bits; 0 if all writable */
-#define XCHAL_DTLB_SET4_ASID_RESET		0	/* 1 if ASID reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET4_VPN_RESET		0	/* 1 if VPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET4_PPN_RESET		0	/* 1 if PPN reset values defined (and all writable); 0 otherwise */
-#define XCHAL_DTLB_SET4_CA_RESET		0	/* 1 if CA reset values defined (and all writable); 0 otherwise */
-
-/*  Indexing macros:  */
-#define _XCHAL_DTLB_SET(n,_what)	XCHAL_DTLB_SET ## n ## _what
-#define XCHAL_DTLB_SET(n,what)		_XCHAL_DTLB_SET(n, _ ## what )
-#define _XCHAL_DTLB_SET_E(n,i,_what)	XCHAL_DTLB_SET ## n ## _E ## i ## _what
-#define XCHAL_DTLB_SET_E(n,i,what)	_XCHAL_DTLB_SET_E(n,i, _ ## what )
-/*
- *  Example use:  XCHAL_DTLB_SET(XCHAL_DTLB_ARF_SET0,ENTRIES)
- *	to get the value of XCHAL_DTLB_SET<n>_ENTRIES where <n> is the first auto-refill set.
- */
-
-
-/*
- *  Determine whether we have a full MMU (with Page Table and Protection)
- *  usable for an MMU-based OS:
- */
-#if XCHAL_HAVE_TLBS && !XCHAL_HAVE_SPANNING_WAY && XCHAL_ITLB_ARF_WAYS > 0 && XCHAL_DTLB_ARF_WAYS > 0 && XCHAL_MMU_RINGS >= 2
-# define XCHAL_HAVE_PTP_MMU		1	/* have full MMU (with page table [autorefill] and protection) */
-#else
-# define XCHAL_HAVE_PTP_MMU		0	/* don't have full MMU */
-#endif
-
-/*
- *  For full MMUs, report kernel RAM segment and kernel I/O segment static page mappings:
- */
-#if XCHAL_HAVE_PTP_MMU
-#define XCHAL_KSEG_CACHED_VADDR		0xD0000000	/* virt.addr of kernel RAM cached static map */
-#define XCHAL_KSEG_CACHED_PADDR		0x00000000	/* phys.addr of kseg_cached */
-#define XCHAL_KSEG_CACHED_SIZE		0x08000000	/* size in bytes of kseg_cached (assumed power of 2!!!) */
-#define XCHAL_KSEG_BYPASS_VADDR		0xD8000000	/* virt.addr of kernel RAM bypass (uncached) static map */
-#define XCHAL_KSEG_BYPASS_PADDR		0x00000000	/* phys.addr of kseg_bypass */
-#define XCHAL_KSEG_BYPASS_SIZE		0x08000000	/* size in bytes of kseg_bypass (assumed power of 2!!!) */
-
-#define XCHAL_KIO_CACHED_VADDR		0xE0000000	/* virt.addr of kernel I/O cached static map */
-#define XCHAL_KIO_CACHED_PADDR		0xF0000000	/* phys.addr of kio_cached */
-#define XCHAL_KIO_CACHED_SIZE		0x10000000	/* size in bytes of kio_cached (assumed power of 2!!!) */
-#define XCHAL_KIO_BYPASS_VADDR		0xF0000000	/* virt.addr of kernel I/O bypass (uncached) static map */
-#define XCHAL_KIO_BYPASS_PADDR		0xF0000000	/* phys.addr of kio_bypass */
-#define XCHAL_KIO_BYPASS_SIZE		0x10000000	/* size in bytes of kio_bypass (assumed power of 2!!!) */
-
-#define XCHAL_SEG_MAPPABLE_VADDR	0x00000000	/* start of largest non-static-mapped virtual addr area */
-#define XCHAL_SEG_MAPPABLE_SIZE		0xD0000000	/* size in bytes of  "  */
-/* define XCHAL_SEG_MAPPABLE2_xxx if more areas present, sorted in order of descending size.  */
-#endif
-
-
-/*----------------------------------------------------------------------
-				MISC
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_NUM_WRITEBUFFER_ENTRIES	4	/* number of write buffer entries */
-
-#define XCHAL_CORE_ID			"linux_be"	/* configuration's alphanumeric core identifier
-							   (CoreID) set in the Xtensa Processor Generator */
-
-#define XCHAL_BUILD_UNIQUE_ID		0x00003256	/* software build-unique ID (22-bit) */
-
-/*  These definitions describe the hardware targeted by this software:  */
-#define XCHAL_HW_CONFIGID0		0xC103D1FF	/* config ID reg 0 value (upper 32 of 64 bits) */
-#define XCHAL_HW_CONFIGID1		0x00803256	/* config ID reg 1 value (lower 32 of 64 bits) */
-#define XCHAL_CONFIGID0			XCHAL_HW_CONFIGID0	/* for backward compatibility only -- don't use! */
-#define XCHAL_CONFIGID1			XCHAL_HW_CONFIGID1	/* for backward compatibility only -- don't use! */
-#define XCHAL_HW_RELEASE_MAJOR		1050	/* major release of targeted hardware */
-#define XCHAL_HW_RELEASE_MINOR		1	/* minor release of targeted hardware */
-#define XCHAL_HW_RELEASE_NAME		"T1050.1"	/* full release name of targeted hardware */
-#define XTHAL_HW_REL_T1050	1
-#define XTHAL_HW_REL_T1050_1	1
-#define XCHAL_HW_CONFIGID_RELIABLE	1
-
-
-/*
- *  Miscellaneous special register fields:
- */
-
-
-/*  DBREAKC (special register number 160):  */
-#define XCHAL_DBREAKC_VALIDMASK	0xC000003F	/* bits of DBREAKC that are defined */
-/*  MASK field:  */
-#define XCHAL_DBREAKC_MASK_BITS 	6		/* number of bits in MASK field */
-#define XCHAL_DBREAKC_MASK_NUM  	64		/* max number of possible causes (2^bits) */
-#define XCHAL_DBREAKC_MASK_SHIFT	0		/* position of MASK bits in DBREAKC, starting from lsbit */
-#define XCHAL_DBREAKC_MASK_MASK 	0x0000003F	/* mask of bits in MASK field of DBREAKC */
-/*  LOADBREAK field:  */
-#define XCHAL_DBREAKC_LOADBREAK_BITS 	1		/* number of bits in LOADBREAK field */
-#define XCHAL_DBREAKC_LOADBREAK_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DBREAKC_LOADBREAK_SHIFT	30		/* position of LOADBREAK bits in DBREAKC, starting from lsbit */
-#define XCHAL_DBREAKC_LOADBREAK_MASK 	0x40000000	/* mask of bits in LOADBREAK field of DBREAKC */
-/*  STOREBREAK field:  */
-#define XCHAL_DBREAKC_STOREBREAK_BITS 	1		/* number of bits in STOREBREAK field */
-#define XCHAL_DBREAKC_STOREBREAK_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DBREAKC_STOREBREAK_SHIFT	31		/* position of STOREBREAK bits in DBREAKC, starting from lsbit */
-#define XCHAL_DBREAKC_STOREBREAK_MASK 	0x80000000	/* mask of bits in STOREBREAK field of DBREAKC */
-
-/*  PS (special register number 230):  */
-#define XCHAL_PS_VALIDMASK	0x00070FFF	/* bits of PS that are defined */
-/*  INTLEVEL field:  */
-#define XCHAL_PS_INTLEVEL_BITS 	4		/* number of bits in INTLEVEL field */
-#define XCHAL_PS_INTLEVEL_NUM  	16		/* max number of possible causes (2^bits) */
-#define XCHAL_PS_INTLEVEL_SHIFT	0		/* position of INTLEVEL bits in PS, starting from lsbit */
-#define XCHAL_PS_INTLEVEL_MASK 	0x0000000F	/* mask of bits in INTLEVEL field of PS */
-/*  EXCM field:  */
-#define XCHAL_PS_EXCM_BITS 	1		/* number of bits in EXCM field */
-#define XCHAL_PS_EXCM_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_PS_EXCM_SHIFT	4		/* position of EXCM bits in PS, starting from lsbit */
-#define XCHAL_PS_EXCM_MASK 	0x00000010	/* mask of bits in EXCM field of PS */
-/*  PROGSTACK field:  */
-#define XCHAL_PS_PROGSTACK_BITS 	1		/* number of bits in PROGSTACK field */
-#define XCHAL_PS_PROGSTACK_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_PS_PROGSTACK_SHIFT	5		/* position of PROGSTACK bits in PS, starting from lsbit */
-#define XCHAL_PS_PROGSTACK_MASK 	0x00000020	/* mask of bits in PROGSTACK field of PS */
-/*  RING field:  */
-#define XCHAL_PS_RING_BITS 	2		/* number of bits in RING field */
-#define XCHAL_PS_RING_NUM  	4		/* max number of possible causes (2^bits) */
-#define XCHAL_PS_RING_SHIFT	6		/* position of RING bits in PS, starting from lsbit */
-#define XCHAL_PS_RING_MASK 	0x000000C0	/* mask of bits in RING field of PS */
-/*  OWB field:  */
-#define XCHAL_PS_OWB_BITS 	4		/* number of bits in OWB field */
-#define XCHAL_PS_OWB_NUM  	16		/* max number of possible causes (2^bits) */
-#define XCHAL_PS_OWB_SHIFT	8		/* position of OWB bits in PS, starting from lsbit */
-#define XCHAL_PS_OWB_MASK 	0x00000F00	/* mask of bits in OWB field of PS */
-/*  CALLINC field:  */
-#define XCHAL_PS_CALLINC_BITS 	2		/* number of bits in CALLINC field */
-#define XCHAL_PS_CALLINC_NUM  	4		/* max number of possible causes (2^bits) */
-#define XCHAL_PS_CALLINC_SHIFT	16		/* position of CALLINC bits in PS, starting from lsbit */
-#define XCHAL_PS_CALLINC_MASK 	0x00030000	/* mask of bits in CALLINC field of PS */
-/*  WOE field:  */
-#define XCHAL_PS_WOE_BITS 	1		/* number of bits in WOE field */
-#define XCHAL_PS_WOE_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_PS_WOE_SHIFT	18		/* position of WOE bits in PS, starting from lsbit */
-#define XCHAL_PS_WOE_MASK 	0x00040000	/* mask of bits in WOE field of PS */
-
-/*  EXCCAUSE (special register number 232):  */
-#define XCHAL_EXCCAUSE_VALIDMASK	0x0000003F	/* bits of EXCCAUSE that are defined */
-/*  EXCCAUSE field:  */
-#define XCHAL_EXCCAUSE_BITS 		6		/* number of bits in EXCCAUSE register */
-#define XCHAL_EXCCAUSE_NUM  		64		/* max number of possible causes (2^bits) */
-#define XCHAL_EXCCAUSE_SHIFT		0		/* position of EXCCAUSE bits in register, starting from lsbit */
-#define XCHAL_EXCCAUSE_MASK 		0x0000003F	/* mask of bits in EXCCAUSE register */
-
-/*  DEBUGCAUSE (special register number 233):  */
-#define XCHAL_DEBUGCAUSE_VALIDMASK	0x0000003F	/* bits of DEBUGCAUSE that are defined */
-/*  ICOUNT field:  */
-#define XCHAL_DEBUGCAUSE_ICOUNT_BITS 	1		/* number of bits in ICOUNT field */
-#define XCHAL_DEBUGCAUSE_ICOUNT_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DEBUGCAUSE_ICOUNT_SHIFT	0		/* position of ICOUNT bits in DEBUGCAUSE, starting from lsbit */
-#define XCHAL_DEBUGCAUSE_ICOUNT_MASK 	0x00000001	/* mask of bits in ICOUNT field of DEBUGCAUSE */
-/*  IBREAK field:  */
-#define XCHAL_DEBUGCAUSE_IBREAK_BITS 	1		/* number of bits in IBREAK field */
-#define XCHAL_DEBUGCAUSE_IBREAK_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DEBUGCAUSE_IBREAK_SHIFT	1		/* position of IBREAK bits in DEBUGCAUSE, starting from lsbit */
-#define XCHAL_DEBUGCAUSE_IBREAK_MASK 	0x00000002	/* mask of bits in IBREAK field of DEBUGCAUSE */
-/*  DBREAK field:  */
-#define XCHAL_DEBUGCAUSE_DBREAK_BITS 	1		/* number of bits in DBREAK field */
-#define XCHAL_DEBUGCAUSE_DBREAK_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DEBUGCAUSE_DBREAK_SHIFT	2		/* position of DBREAK bits in DEBUGCAUSE, starting from lsbit */
-#define XCHAL_DEBUGCAUSE_DBREAK_MASK 	0x00000004	/* mask of bits in DBREAK field of DEBUGCAUSE */
-/*  BREAK field:  */
-#define XCHAL_DEBUGCAUSE_BREAK_BITS 	1		/* number of bits in BREAK field */
-#define XCHAL_DEBUGCAUSE_BREAK_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DEBUGCAUSE_BREAK_SHIFT	3		/* position of BREAK bits in DEBUGCAUSE, starting from lsbit */
-#define XCHAL_DEBUGCAUSE_BREAK_MASK 	0x00000008	/* mask of bits in BREAK field of DEBUGCAUSE */
-/*  BREAKN field:  */
-#define XCHAL_DEBUGCAUSE_BREAKN_BITS 	1		/* number of bits in BREAKN field */
-#define XCHAL_DEBUGCAUSE_BREAKN_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DEBUGCAUSE_BREAKN_SHIFT	4		/* position of BREAKN bits in DEBUGCAUSE, starting from lsbit */
-#define XCHAL_DEBUGCAUSE_BREAKN_MASK 	0x00000010	/* mask of bits in BREAKN field of DEBUGCAUSE */
-/*  DEBUGINT field:  */
-#define XCHAL_DEBUGCAUSE_DEBUGINT_BITS 	1		/* number of bits in DEBUGINT field */
-#define XCHAL_DEBUGCAUSE_DEBUGINT_NUM  	2		/* max number of possible causes (2^bits) */
-#define XCHAL_DEBUGCAUSE_DEBUGINT_SHIFT	5		/* position of DEBUGINT bits in DEBUGCAUSE, starting from lsbit */
-#define XCHAL_DEBUGCAUSE_DEBUGINT_MASK 	0x00000020	/* mask of bits in DEBUGINT field of DEBUGCAUSE */
-
-
-
-/*----------------------------------------------------------------------
-				ISA
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_HAVE_DENSITY		1	/* 1 if density option configured, 0 otherwise */
-#define XCHAL_HAVE_LOOPS		1	/* 1 if zero-overhead loops option configured, 0 otherwise */
-/*  Misc instructions:  */
-#define XCHAL_HAVE_NSA			0	/* 1 if NSA/NSAU instructions option configured, 0 otherwise */
-#define XCHAL_HAVE_MINMAX		0	/* 1 if MIN/MAX instructions option configured, 0 otherwise */
-#define XCHAL_HAVE_SEXT			0	/* 1 if sign-extend instruction option configured, 0 otherwise */
-#define XCHAL_HAVE_CLAMPS		0	/* 1 if CLAMPS instruction option configured, 0 otherwise */
-#define XCHAL_HAVE_MAC16		0	/* 1 if MAC16 option configured, 0 otherwise */
-#define XCHAL_HAVE_MUL16		0	/* 1 if 16-bit integer multiply option configured, 0 otherwise */
-/*#define XCHAL_HAVE_POPC		0*/	/* 1 if CRC instruction option configured, 0 otherwise */
-/*#define XCHAL_HAVE_CRC		0*/	/* 1 if POPC instruction option configured, 0 otherwise */
-
-#define XCHAL_HAVE_SPECULATION		0	/* 1 if speculation option configured, 0 otherwise */
-/*#define XCHAL_HAVE_MP_SYNC		0*/	/* 1 if multiprocessor sync. option configured, 0 otherwise */
-#define XCHAL_HAVE_PRID			0	/* 1 if processor ID register configured, 0 otherwise */
-
-#define XCHAL_NUM_MISC_REGS		2	/* number of miscellaneous registers (0..4) */
-
-/*  These relate a bit more to TIE:  */
-#define XCHAL_HAVE_BOOLEANS		0	/* 1 if booleans option configured, 0 otherwise */
-#define XCHAL_HAVE_MUL32		0	/* 1 if 32-bit integer multiply option configured, 0 otherwise */
-#define XCHAL_HAVE_MUL32_HIGH		0	/* 1 if MUL32 option includes MULUH and MULSH, 0 otherwise */
-#define XCHAL_HAVE_FP			0	/* 1 if floating point option configured, 0 otherwise */
-
-
-/*----------------------------------------------------------------------
-				DERIVED
-  ----------------------------------------------------------------------*/
-
-#if XCHAL_HAVE_BE
-#define XCHAL_INST_ILLN			0xD60F		/* 2-byte illegal instruction, msb-first */
-#define XCHAL_INST_ILLN_BYTE0		0xD6		/* 2-byte illegal instruction, 1st byte */
-#define XCHAL_INST_ILLN_BYTE1		0x0F		/* 2-byte illegal instruction, 2nd byte */
-#else
-#define XCHAL_INST_ILLN			0xF06D		/* 2-byte illegal instruction, lsb-first */
-#define XCHAL_INST_ILLN_BYTE0		0x6D		/* 2-byte illegal instruction, 1st byte */
-#define XCHAL_INST_ILLN_BYTE1		0xF0		/* 2-byte illegal instruction, 2nd byte */
-#endif
-/*  Belongs in xtensa/hal.h:  */
-#define XTHAL_INST_ILL			0x000000	/* 3-byte illegal instruction */
-
-
-/*
- *  Because information as to exactly which hardware release is targeted
- *  by a given software build is not always available, compile-time HAL
- *  Hardware-Release "_AT" macros are fuzzy (return 0, 1, or XCHAL_MAYBE):
- */
-#ifndef XCHAL_HW_RELEASE_MAJOR
-# define XCHAL_HW_CONFIGID_RELIABLE	0
-#endif
-#if XCHAL_HW_CONFIGID_RELIABLE
-# define XCHAL_HW_RELEASE_AT_OR_BELOW(major,minor)	(XTHAL_REL_LE( XCHAL_HW_RELEASE_MAJOR,XCHAL_HW_RELEASE_MINOR, major,minor ) ? 1 : 0)
-# define XCHAL_HW_RELEASE_AT_OR_ABOVE(major,minor)	(XTHAL_REL_GE( XCHAL_HW_RELEASE_MAJOR,XCHAL_HW_RELEASE_MINOR, major,minor ) ? 1 : 0)
-# define XCHAL_HW_RELEASE_AT(major,minor)		(XTHAL_REL_EQ( XCHAL_HW_RELEASE_MAJOR,XCHAL_HW_RELEASE_MINOR, major,minor ) ? 1 : 0)
-# define XCHAL_HW_RELEASE_MAJOR_AT(major)		((XCHAL_HW_RELEASE_MAJOR == (major)) ? 1 : 0)
-#else
-# define XCHAL_HW_RELEASE_AT_OR_BELOW(major,minor)	( ((major) < 1040 && XCHAL_HAVE_XEA2) ? 0 \
-							: ((major) > 1050 && XCHAL_HAVE_XEA1) ? 1 \
-							: XTHAL_MAYBE )
-# define XCHAL_HW_RELEASE_AT_OR_ABOVE(major,minor)	( ((major) >= 2000 && XCHAL_HAVE_XEA1) ? 0 \
-							: (XTHAL_REL_LE(major,minor, 1040,0) && XCHAL_HAVE_XEA2) ? 1 \
-							: XTHAL_MAYBE )
-# define XCHAL_HW_RELEASE_AT(major,minor)		( (((major) < 1040 && XCHAL_HAVE_XEA2) || \
-							   ((major) >= 2000 && XCHAL_HAVE_XEA1)) ? 0 : XTHAL_MAYBE)
-# define XCHAL_HW_RELEASE_MAJOR_AT(major)		XCHAL_HW_RELEASE_AT(major,0)
-#endif
-
-/*
- *  Specific errata:
- */
-
-/*
- *  Erratum T1020.H13, T1030.H7, T1040.H10, T1050.H4 (fixed in T1040.3 and T1050.1;
- *  relevant only in XEA1, kernel-vector mode, level-one interrupts and overflows enabled):
- */
-#define XCHAL_MAYHAVE_ERRATUM_XEA1KWIN	(XCHAL_HAVE_XEA1 && \
-					 (XCHAL_HW_RELEASE_AT_OR_BELOW(1040,2) != 0 \
-					  || XCHAL_HW_RELEASE_AT(1050,0)))
-
-
-
-#endif /*XTENSA_CONFIG_CORE_H*/
-
diff -puN include/asm-xtensa/xtensa/config-linux_be/defs.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/config-linux_be/defs.h
+++ /dev/null
@@ -1,270 +0,0 @@
-/* Definitions for Xtensa instructions, types, and protos. */
-
-/*
- * Copyright (c) 2003 Tensilica, Inc.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2.1 of the GNU Lesser General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * Further, this software is distributed without any warranty that it is
- * free of the rightful claim of any third person regarding infringement
- * or the like.  Any license provided herein, whether implied or
- * otherwise, applies only to this software file.  Patent licenses, if
- * any, provided herein do not apply to combinations of this program with
- * other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
- * USA.
- */
-
-/* Do not modify. This is automatically generated.*/
-
-#ifndef _XTENSA_BASE_HEADER
-#define _XTENSA_BASE_HEADER
-
-#ifdef __XTENSA__
-#if defined(__GNUC__) && !defined(__XCC__)
-
-#define L8UI_ASM(arr, ars, imm) { \
-  __asm__ volatile("l8ui %0, %1, %2" : "=a" (arr) : "a" (ars) , "i" (imm)); \
-}
-
-#define XT_L8UI(ars, imm) \
-({ \
-  unsigned char _arr; \
-  const unsigned char *_ars = ars; \
-  L8UI_ASM(_arr, _ars, imm); \
-  _arr; \
-})
-
-#define L16UI_ASM(arr, ars, imm) { \
-  __asm__ volatile("l16ui %0, %1, %2" : "=a" (arr) : "a" (ars) , "i" (imm)); \
-}
-
-#define XT_L16UI(ars, imm) \
-({ \
-  unsigned short _arr; \
-  const unsigned short *_ars = ars; \
-  L16UI_ASM(_arr, _ars, imm); \
-  _arr; \
-})
-
-#define L16SI_ASM(arr, ars, imm) {\
-  __asm__ volatile("l16si %0, %1, %2" : "=a" (arr) : "a" (ars) , "i" (imm)); \
-}
-
-#define XT_L16SI(ars, imm) \
-({ \
-  signed short _arr; \
-  const signed short *_ars = ars; \
-  L16SI_ASM(_arr, _ars, imm); \
-  _arr; \
-})
-
-#define L32I_ASM(arr, ars, imm) { \
-  __asm__ volatile("l32i %0, %1, %2" : "=a" (arr) : "a" (ars) , "i" (imm)); \
-}
-
-#define XT_L32I(ars, imm) \
-({ \
-  unsigned _arr; \
-  const unsigned *_ars = ars; \
-  L32I_ASM(_arr, _ars, imm); \
-  _arr; \
-})
-
-#define S8I_ASM(arr, ars, imm) {\
-  __asm__ volatile("s8i %0, %1, %2" : : "a" (arr), "a" (ars) , "i" (imm) : "memory" ); \
-}
-
-#define XT_S8I(arr, ars, imm) \
-({ \
-  signed char _arr = arr; \
-  const signed char *_ars = ars; \
-  S8I_ASM(_arr, _ars, imm); \
-})
-
-#define S16I_ASM(arr, ars, imm) {\
-  __asm__ volatile("s16i %0, %1, %2" : : "a" (arr), "a" (ars) , "i" (imm) : "memory" ); \
-}
-
-#define XT_S16I(arr, ars, imm) \
-({ \
-  signed short _arr = arr; \
-  const signed short *_ars = ars; \
-  S16I_ASM(_arr, _ars, imm); \
-})
-
-#define S32I_ASM(arr, ars, imm) { \
-  __asm__ volatile("s32i %0, %1, %2" : : "a" (arr), "a" (ars) , "i" (imm) : "memory" ); \
-}
-
-#define XT_S32I(arr, ars, imm) \
-({ \
-  signed int _arr = arr; \
-  const signed int *_ars = ars; \
-  S32I_ASM(_arr, _ars, imm); \
-})
-
-#define ADDI_ASM(art, ars, imm) {\
-   __asm__ ("addi %0, %1, %2" : "=a" (art) : "a" (ars), "i" (imm)); \
-}
-
-#define XT_ADDI(ars, imm) \
-({ \
-   unsigned _art; \
-   unsigned _ars = ars; \
-   ADDI_ASM(_art, _ars, imm); \
-   _art; \
-})
-
-#define ABS_ASM(arr, art) {\
-   __asm__ ("abs %0, %1" : "=a" (arr) : "a" (art)); \
-}
-
-#define XT_ABS(art) \
-({ \
-   unsigned _arr; \
-   signed _art = art; \
-   ABS_ASM(_arr, _art); \
-   _arr; \
-})
-
-/* Note: In the following macros that reference SAR, the magic "state"
-   register is used to capture the dependency on SAR.  This is because
-   SAR is a 5-bit register and thus there are no C types that can be
-   used to represent it.  It doesn't appear that the SAR register is
-   even relevant to GCC, but it is marked as "clobbered" just in
-   case.  */
-
-#define SRC_ASM(arr, ars, art) {\
-   register int _xt_sar __asm__ ("state"); \
-   __asm__ ("src %0, %1, %2" \
-	    : "=a" (arr) : "a" (ars), "a" (art), "t" (_xt_sar)); \
-}
-
-#define XT_SRC(ars, art) \
-({ \
-   unsigned _arr; \
-   unsigned _ars = ars; \
-   unsigned _art = art; \
-   SRC_ASM(_arr, _ars, _art); \
-   _arr; \
-})
-
-#define SSR_ASM(ars) {\
-   register int _xt_sar __asm__ ("state"); \
-   __asm__ ("ssr %1" : "=t" (_xt_sar) : "a" (ars) : "sar"); \
-}
-
-#define XT_SSR(ars) \
-({ \
-   unsigned _ars = ars; \
-   SSR_ASM(_ars); \
-})
-
-#define SSL_ASM(ars) {\
-   register int _xt_sar __asm__ ("state"); \
-   __asm__ ("ssl %1" : "=t" (_xt_sar) : "a" (ars) : "sar"); \
-}
-
-#define XT_SSL(ars) \
-({ \
-   unsigned _ars = ars; \
-   SSL_ASM(_ars); \
-})
-
-#define SSA8B_ASM(ars) {\
-   register int _xt_sar __asm__ ("state"); \
-   __asm__ ("ssa8b %1" : "=t" (_xt_sar) : "a" (ars) : "sar"); \
-}
-
-#define XT_SSA8B(ars) \
-({ \
-   unsigned _ars = ars; \
-   SSA8B_ASM(_ars); \
-})
-
-#define SSA8L_ASM(ars) {\
-   register int _xt_sar __asm__ ("state"); \
-   __asm__ ("ssa8l %1" : "=t" (_xt_sar) : "a" (ars) : "sar"); \
-}
-
-#define XT_SSA8L(ars) \
-({ \
-   unsigned _ars = ars; \
-   SSA8L_ASM(_ars); \
-})
-
-#define SSAI_ASM(imm) {\
-   register int _xt_sar __asm__ ("state"); \
-   __asm__ ("ssai %1" : "=t" (_xt_sar) : "i" (imm) : "sar"); \
-}
-
-#define XT_SSAI(imm) \
-({ \
-   SSAI_ASM(imm); \
-})
-
-
-
-
-
-
-
-
-#endif /* __GNUC__ && !__XCC__ */
-
-#ifdef __XCC__
-
-/* Core load/store instructions */
-extern unsigned char _TIE_L8UI(const unsigned char * ars, immediate imm);
-extern unsigned short _TIE_L16UI(const unsigned short * ars, immediate imm);
-extern signed short _TIE_L16SI(const signed short * ars, immediate imm);
-extern unsigned _TIE_L32I(const unsigned * ars, immediate imm);
-extern void _TIE_S8I(unsigned char arr, unsigned char * ars, immediate imm);
-extern void _TIE_S16I(unsigned short arr, unsigned short * ars, immediate imm);
-extern void _TIE_S32I(unsigned arr, unsigned * ars, immediate imm);
-
-#define XT_L8UI  _TIE_L8UI
-#define XT_L16UI _TIE_L16UI
-#define XT_L16SI _TIE_L16SI
-#define XT_L32I  _TIE_L32I
-#define XT_S8I   _TIE_S8I
-#define XT_S16I  _TIE_S16I
-#define XT_S32I  _TIE_S32I
-
-/* Add-immediate instruction */
-extern unsigned _TIE_ADDI(unsigned ars, immediate imm);
-#define XT_ADDI  _TIE_ADDI
-
-/* Absolute value instruction */
-extern unsigned _TIE_ABS(int art);
-#define XT_ABS _TIE_ABS
-
-/* funnel shift instructions */
-extern unsigned _TIE_SRC(unsigned ars, unsigned art);
-#define XT_SRC _TIE_SRC
-extern void _TIE_SSR(unsigned ars);
-#define XT_SSR _TIE_SSR
-extern void _TIE_SSL(unsigned ars);
-#define XT_SSL _TIE_SSL
-extern void _TIE_SSA8B(unsigned ars);
-#define XT_SSA8B _TIE_SSA8B
-extern void _TIE_SSA8L(unsigned ars);
-#define XT_SSA8L _TIE_SSA8L
-extern void _TIE_SSAI(immediate imm);
-#define XT_SSAI _TIE_SSAI
-
-
-#endif /* __XCC__ */
-
-#endif /* __XTENSA__ */
-#endif /* !_XTENSA_BASE_HEADER */
diff -puN include/asm-xtensa/xtensa/config-linux_be/specreg.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/config-linux_be/specreg.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * Xtensa Special Register symbolic names
- */
-
-/* $Id: specreg.h,v 1.2 2003/03/07 19:15:18 joetaylor Exp $ */
-
-/*
- * Copyright (c) 2003 Tensilica, Inc.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2.1 of the GNU Lesser General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * Further, this software is distributed without any warranty that it is
- * free of the rightful claim of any third person regarding infringement
- * or the like.  Any license provided herein, whether implied or
- * otherwise, applies only to this software file.  Patent licenses, if
- * any, provided herein do not apply to combinations of this program with
- * other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
- * USA.
- */
-
-#ifndef XTENSA_SPECREG_H
-#define XTENSA_SPECREG_H
-
-/*  Include these special register bitfield definitions, for historical reasons:  */
-#include <xtensa/corebits.h>
-
-
-/*  Special registers:  */
-#define LBEG		0
-#define LEND		1
-#define LCOUNT		2
-#define SAR		3
-#define WINDOWBASE	72
-#define WINDOWSTART	73
-#define PTEVADDR	83
-#define RASID		90
-#define ITLBCFG		91
-#define DTLBCFG		92
-#define IBREAKENABLE	96
-#define DDR		104
-#define IBREAKA_0	128
-#define IBREAKA_1	129
-#define DBREAKA_0	144
-#define DBREAKA_1	145
-#define DBREAKC_0	160
-#define DBREAKC_1	161
-#define EPC_1		177
-#define EPC_2		178
-#define EPC_3		179
-#define EPC_4		180
-#define DEPC		192
-#define EPS_2		194
-#define EPS_3		195
-#define EPS_4		196
-#define EXCSAVE_1	209
-#define EXCSAVE_2	210
-#define EXCSAVE_3	211
-#define EXCSAVE_4	212
-#define INTERRUPT	226
-#define INTENABLE	228
-#define PS		230
-#define EXCCAUSE	232
-#define DEBUGCAUSE	233
-#define CCOUNT		234
-#define ICOUNT		236
-#define ICOUNTLEVEL	237
-#define EXCVADDR	238
-#define CCOMPARE_0	240
-#define CCOMPARE_1	241
-#define CCOMPARE_2	242
-#define MISC_REG_0	244
-#define MISC_REG_1	245
-
-/*  Special cases (bases of special register series):  */
-#define IBREAKA		128
-#define DBREAKA		144
-#define DBREAKC		160
-#define EPC		176
-#define EPS		192
-#define EXCSAVE		208
-#define CCOMPARE	240
-
-/*  Special names for read-only and write-only interrupt registers:  */
-#define INTREAD		226
-#define INTSET		226
-#define INTCLEAR	227
-
-#endif /* XTENSA_SPECREG_H */
-
diff -puN include/asm-xtensa/xtensa/config-linux_be/system.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/config-linux_be/system.h
+++ /dev/null
@@ -1,198 +0,0 @@
-/*
- * xtensa/config/system.h -- HAL definitions that are dependent on SYSTEM configuration
- *
- *  NOTE: The location and contents of this file are highly subject to change.
- *
- *  Source for configuration-independent binaries (which link in a
- *  configuration-specific HAL library) must NEVER include this file.
- *  The HAL itself has historically included this file in some instances,
- *  but this is not appropriate either, because the HAL is meant to be
- *  core-specific but system independent.
- */
-
-/*
- * Copyright (c) 2003 Tensilica, Inc.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2.1 of the GNU Lesser General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * Further, this software is distributed without any warranty that it is
- * free of the rightful claim of any third person regarding infringement
- * or the like.  Any license provided herein, whether implied or
- * otherwise, applies only to this software file.  Patent licenses, if
- * any, provided herein do not apply to combinations of this program with
- * other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
- * USA.
- */
-
-
-#ifndef XTENSA_CONFIG_SYSTEM_H
-#define XTENSA_CONFIG_SYSTEM_H
-
-/*#include <xtensa/hal.h>*/
-
-
-
-/*----------------------------------------------------------------------
-				DEVICE ADDRESSES
-  ----------------------------------------------------------------------*/
-
-/*
- *  Strange place to find these, but the configuration GUI
- *  allows moving these around to account for various core
- *  configurations.  Specific boards (and their BSP software)
- *  will have specific meanings for these components.
- */
-
-/*  I/O Block areas:  */
-#define XSHAL_IOBLOCK_CACHED_VADDR	0xE0000000
-#define XSHAL_IOBLOCK_CACHED_PADDR	0xF0000000
-#define XSHAL_IOBLOCK_CACHED_SIZE	0x0E000000
-
-#define XSHAL_IOBLOCK_BYPASS_VADDR	0xF0000000
-#define XSHAL_IOBLOCK_BYPASS_PADDR	0xF0000000
-#define XSHAL_IOBLOCK_BYPASS_SIZE	0x0E000000
-
-/*  System ROM:  */
-#define XSHAL_ROM_VADDR		0xEE000000
-#define XSHAL_ROM_PADDR		0xFE000000
-#define XSHAL_ROM_SIZE		0x00400000
-/*  Largest available area (free of vectors):  */
-#define XSHAL_ROM_AVAIL_VADDR	0xEE00052C
-#define XSHAL_ROM_AVAIL_VSIZE	0x003FFAD4
-
-/*  System RAM:  */
-#define XSHAL_RAM_VADDR		0xD0000000
-#define XSHAL_RAM_PADDR		0x00000000
-#define XSHAL_RAM_VSIZE		0x08000000
-#define XSHAL_RAM_PSIZE		0x10000000
-#define XSHAL_RAM_SIZE		XSHAL_RAM_PSIZE
-/*  Largest available area (free of vectors):  */
-#define XSHAL_RAM_AVAIL_VADDR	0xD0000370
-#define XSHAL_RAM_AVAIL_VSIZE	0x07FFFC90
-
-/*
- *  Shadow system RAM (same device as system RAM, at different address).
- *  (Emulation boards need this for the SONIC Ethernet driver
- *   when data caches are configured for writeback mode.)
- *  NOTE: on full MMU configs, this points to the BYPASS virtual address
- *  of system RAM, ie. is the same as XSHAL_RAM_* except that virtual
- *  addresses are viewed through the BYPASS static map rather than
- *  the CACHED static map.
- */
-#define XSHAL_RAM_BYPASS_VADDR		0xD8000000
-#define XSHAL_RAM_BYPASS_PADDR		0x00000000
-#define XSHAL_RAM_BYPASS_PSIZE		0x08000000
-
-/*  Alternate system RAM (different device than system RAM):  */
-#define XSHAL_ALTRAM_VADDR		0xCEE00000
-#define XSHAL_ALTRAM_PADDR		0xC0000000
-#define XSHAL_ALTRAM_SIZE		0x00200000
-
-
-/*----------------------------------------------------------------------
- *			DEVICE-ADDRESS DEPENDENT...
- *
- *  Values written to CACHEATTR special register (or its equivalent)
- *  to enable and disable caches in various modes.
- *----------------------------------------------------------------------*/
-
-/*----------------------------------------------------------------------
-			BACKWARD COMPATIBILITY ...
-  ----------------------------------------------------------------------*/
-
-/*
- *  NOTE:  the following two macros are DEPRECATED.  Use the latter
- *  board-specific macros instead, which are specially tuned for the
- *  particular target environments' memory maps.
- */
-#define XSHAL_CACHEATTR_BYPASS		XSHAL_XT2000_CACHEATTR_BYPASS	/* disable caches in bypass mode */
-#define XSHAL_CACHEATTR_DEFAULT		XSHAL_XT2000_CACHEATTR_DEFAULT	/* default setting to enable caches (no writeback!) */
-
-/*----------------------------------------------------------------------
-			ISS (Instruction Set Simulator) SPECIFIC ...
-  ----------------------------------------------------------------------*/
-
-#define XSHAL_ISS_CACHEATTR_WRITEBACK	0x1122222F	/* enable caches in write-back mode */
-#define XSHAL_ISS_CACHEATTR_WRITEALLOC	0x1122222F	/* enable caches in write-allocate mode */
-#define XSHAL_ISS_CACHEATTR_WRITETHRU	0x1122222F	/* enable caches in write-through mode */
-#define XSHAL_ISS_CACHEATTR_BYPASS	0x2222222F	/* disable caches in bypass mode */
-#define XSHAL_ISS_CACHEATTR_DEFAULT	XSHAL_ISS_CACHEATTR_WRITEBACK	/* default setting to enable caches */
-
-/*  For Coware only:  */
-#define XSHAL_COWARE_CACHEATTR_WRITEBACK	0x11222222	/* enable caches in write-back mode */
-#define XSHAL_COWARE_CACHEATTR_WRITEALLOC	0x11222222	/* enable caches in write-allocate mode */
-#define XSHAL_COWARE_CACHEATTR_WRITETHRU	0x11222222	/* enable caches in write-through mode */
-#define XSHAL_COWARE_CACHEATTR_BYPASS		0x22222222	/* disable caches in bypass mode */
-#define XSHAL_COWARE_CACHEATTR_DEFAULT		XSHAL_COWARE_CACHEATTR_WRITEBACK	/* default setting to enable caches */
-
-/*  For BFM and other purposes:  */
-#define XSHAL_ALLVALID_CACHEATTR_WRITEBACK	0x11222222	/* enable caches without any invalid regions */
-#define XSHAL_ALLVALID_CACHEATTR_DEFAULT	XSHAL_ALLVALID_CACHEATTR_WRITEBACK	/* default setting for caches without any invalid regions */
-
-#define XSHAL_ISS_PIPE_REGIONS	0
-#define XSHAL_ISS_SDRAM_REGIONS	0
-
-
-/*----------------------------------------------------------------------
-			XT2000 BOARD SPECIFIC ...
-  ----------------------------------------------------------------------*/
-
-#define XSHAL_XT2000_CACHEATTR_WRITEBACK	0x22FFFFFF	/* enable caches in write-back mode */
-#define XSHAL_XT2000_CACHEATTR_WRITEALLOC	0x22FFFFFF	/* enable caches in write-allocate mode */
-#define XSHAL_XT2000_CACHEATTR_WRITETHRU	0x22FFFFFF	/* enable caches in write-through mode */
-#define XSHAL_XT2000_CACHEATTR_BYPASS		0x22FFFFFF	/* disable caches in bypass mode */
-#define XSHAL_XT2000_CACHEATTR_DEFAULT		XSHAL_XT2000_CACHEATTR_WRITEBACK	/* default setting to enable caches */
-
-#define XSHAL_XT2000_PIPE_REGIONS	0x00001000	/* BusInt pipeline regions */
-#define XSHAL_XT2000_SDRAM_REGIONS	0x00000005	/* BusInt SDRAM regions */
-
-
-/*----------------------------------------------------------------------
-				VECTOR SIZES
-  ----------------------------------------------------------------------*/
-
-/*
- *  Sizes allocated to vectors by the system (memory map) configuration.
- *  These sizes are constrained by core configuration (eg. one vector's
- *  code cannot overflow into another vector) but are dependent on the
- *  system or board (or LSP) memory map configuration.
- *
- *  Whether or not each vector happens to be in a system ROM is also
- *  a system configuration matter, sometimes useful, included here also:
- */
-#define XSHAL_RESET_VECTOR_SIZE	0x000004E0
-#define XSHAL_RESET_VECTOR_ISROM	1
-#define XSHAL_USER_VECTOR_SIZE	0x0000001C
-#define XSHAL_USER_VECTOR_ISROM	0
-#define XSHAL_PROGRAMEXC_VECTOR_SIZE	XSHAL_USER_VECTOR_SIZE	/* for backward compatibility */
-#define XSHAL_USEREXC_VECTOR_SIZE	XSHAL_USER_VECTOR_SIZE	/* for backward compatibility */
-#define XSHAL_KERNEL_VECTOR_SIZE	0x0000001C
-#define XSHAL_KERNEL_VECTOR_ISROM	0
-#define XSHAL_STACKEDEXC_VECTOR_SIZE	XSHAL_KERNEL_VECTOR_SIZE	/* for backward compatibility */
-#define XSHAL_KERNELEXC_VECTOR_SIZE	XSHAL_KERNEL_VECTOR_SIZE	/* for backward compatibility */
-#define XSHAL_DOUBLEEXC_VECTOR_SIZE	0x000000E0
-#define XSHAL_DOUBLEEXC_VECTOR_ISROM	0
-#define XSHAL_WINDOW_VECTORS_SIZE	0x00000180
-#define XSHAL_WINDOW_VECTORS_ISROM	0
-#define XSHAL_INTLEVEL2_VECTOR_SIZE	0x0000000C
-#define XSHAL_INTLEVEL2_VECTOR_ISROM	0
-#define XSHAL_INTLEVEL3_VECTOR_SIZE	0x0000000C
-#define XSHAL_INTLEVEL3_VECTOR_ISROM	0
-#define XSHAL_INTLEVEL4_VECTOR_SIZE	0x0000000C
-#define XSHAL_INTLEVEL4_VECTOR_ISROM	1
-#define XSHAL_DEBUG_VECTOR_SIZE		XSHAL_INTLEVEL4_VECTOR_SIZE
-#define XSHAL_DEBUG_VECTOR_ISROM	XSHAL_INTLEVEL4_VECTOR_ISROM
-
-
-#endif /*XTENSA_CONFIG_SYSTEM_H*/
-
diff -puN include/asm-xtensa/xtensa/config-linux_be/tie.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/config-linux_be/tie.h
+++ /dev/null
@@ -1,275 +0,0 @@
-/*
- * xtensa/config/tie.h -- HAL definitions that are dependent on CORE and TIE configuration
- *
- *  This header file is sometimes referred to as the "compile-time HAL" or CHAL.
- *  It was generated for a specific Xtensa processor configuration,
- *  and furthermore for a specific set of TIE source files that extend
- *  basic core functionality.
- *
- *  Source for configuration-independent binaries (which link in a
- *  configuration-specific HAL library) must NEVER include this file.
- *  It is perfectly normal, however, for the HAL source itself to include this file.
- */
-
-/*
- * Copyright (c) 2003 Tensilica, Inc.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2.1 of the GNU Lesser General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * Further, this software is distributed without any warranty that it is
- * free of the rightful claim of any third person regarding infringement
- * or the like.  Any license provided herein, whether implied or
- * otherwise, applies only to this software file.  Patent licenses, if
- * any, provided herein do not apply to combinations of this program with
- * other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307,
- * USA.
- */
-
-
-#ifndef XTENSA_CONFIG_TIE_H
-#define XTENSA_CONFIG_TIE_H
-
-#include <xtensa/hal.h>
-
-
-/*----------------------------------------------------------------------
-				GENERAL
-  ----------------------------------------------------------------------*/
-
-/*
- *  Separators for macros that expand into arrays.
- *  These can be predefined by files that #include this one,
- *  when different separators are required.
- */
-/*  Element separator for macros that expand into 1-dimensional arrays:  */
-#ifndef XCHAL_SEP
-#define XCHAL_SEP			,
-#endif
-/*  Array separator for macros that expand into 2-dimensional arrays:  */
-#ifndef XCHAL_SEP2
-#define XCHAL_SEP2			},{
-#endif
-
-
-
-
-
-
-/*----------------------------------------------------------------------
-			COPROCESSORS and EXTRA STATE
-  ----------------------------------------------------------------------*/
-
-#define XCHAL_CP_NUM			0	/* number of coprocessors */
-#define XCHAL_CP_MAX			0	/* max coprocessor id plus one (0 if none) */
-#define XCHAL_CP_MASK			0x00	/* bitmask of coprocessors by id */
-
-/*  Space for coprocessors' state save areas:  */
-#define XCHAL_CP0_SA_SIZE		0
-#define XCHAL_CP1_SA_SIZE		0
-#define XCHAL_CP2_SA_SIZE		0
-#define XCHAL_CP3_SA_SIZE		0
-#define XCHAL_CP4_SA_SIZE		0
-#define XCHAL_CP5_SA_SIZE		0
-#define XCHAL_CP6_SA_SIZE		0
-#define XCHAL_CP7_SA_SIZE		0
-/*  Minimum required alignments of CP state save areas:  */
-#define XCHAL_CP0_SA_ALIGN		1
-#define XCHAL_CP1_SA_ALIGN		1
-#define XCHAL_CP2_SA_ALIGN		1
-#define XCHAL_CP3_SA_ALIGN		1
-#define XCHAL_CP4_SA_ALIGN		1
-#define XCHAL_CP5_SA_ALIGN		1
-#define XCHAL_CP6_SA_ALIGN		1
-#define XCHAL_CP7_SA_ALIGN		1
-
-/*  Indexing macros:  */
-#define _XCHAL_CP_SA_SIZE(n)		XCHAL_CP ## n ## _SA_SIZE
-#define XCHAL_CP_SA_SIZE(n)		_XCHAL_CP_SA_SIZE(n)	/* n = 0 .. 7 */
-#define _XCHAL_CP_SA_ALIGN(n)		XCHAL_CP ## n ## _SA_ALIGN
-#define XCHAL_CP_SA_ALIGN(n)		_XCHAL_CP_SA_ALIGN(n)	/* n = 0 .. 7 */
-
-
-/*  Space for "extra" state (user special registers and non-cp TIE) save area:  */
-#define XCHAL_EXTRA_SA_SIZE		0
-#define XCHAL_EXTRA_SA_ALIGN		1
-
-/*  Total save area size (extra + all coprocessors)  */
-/*  (not useful until xthal_{save,restore}_all_extra() is implemented,  */
-/*   but included for Tor2 beta; doesn't account for alignment!):  */
-#define XCHAL_CPEXTRA_SA_SIZE_TOR2	0	/* Tor2Beta temporary definition -- do not use */
-
-/*  Combined required alignment for all CP and EXTRA state save areas  */
-/*  (does not include required alignment for any base config registers):  */
-#define XCHAL_CPEXTRA_SA_ALIGN		1
-
-/* ... */
-
-
-#ifdef __ASSEMBLER__
-/*
- *  Assembly-language specific definitions (assembly macros, etc.).
- */
-#include <xtensa/config/specreg.h>
-
-/********************
- *  Macros to save and restore the non-coprocessor TIE portion of EXTRA state.
- */
-
-/* (none) */
-
-
-/********************
- *  Macros to create functions that save and restore all EXTRA (non-coprocessor) state
- *  (does not include zero-overhead loop registers and non-optional registers).
- */
-
-	/*
-	 *  Macro that expands to the body of a function that
-	 *  stores the extra (non-coprocessor) optional/custom state.
-	 *	Entry:	a2 = ptr to save area in which to save extra state
-	 *	Exit:	any register a2-a15 (?) may have been clobbered.
-	 */
-	.macro	xchal_extra_store_funcbody
-	.endm
-
-
-	/*
-	 *  Macro that expands to the body of a function that
-	 *  loads the extra (non-coprocessor) optional/custom state.
-	 *	Entry:	a2 = ptr to save area from which to restore extra state
-	 *	Exit:	any register a2-a15 (?) may have been clobbered.
-	 */
-	.macro	xchal_extra_load_funcbody
-	.endm
-
-
-/********************
- *  Macros to save and restore the state of each TIE coprocessor.
- */
-
-
-
-/********************
- *  Macros to create functions that save and restore the state of *any* TIE coprocessor.
- */
-
-	/*
-	 *  Macro that expands to the body of a function
-	 *  that stores the selected coprocessor's state (registers etc).
-	 *	Entry:	a2 = ptr to save area in which to save cp state
-	 *		a3 = coprocessor number
-	 *	Exit:	any register a2-a15 (?) may have been clobbered.
-	 */
-	.macro	xchal_cpi_store_funcbody
-	.endm
-
-
-	/*
-	 *  Macro that expands to the body of a function
-	 *  that loads the selected coprocessor's state (registers etc).
-	 *	Entry:	a2 = ptr to save area from which to restore cp state
-	 *		a3 = coprocessor number
-	 *	Exit:	any register a2-a15 (?) may have been clobbered.
-	 */
-	.macro	xchal_cpi_load_funcbody
-	.endm
-
-#endif /*_ASMLANGUAGE*/
-
-
-/*
- *  Contents of save areas in terms of libdb register numbers.
- *  NOTE:  CONTENTS_LIBDB_{UREG,REGF} macros are not defined in this file;
- *  it is up to the user of this header file to define these macros
- *  usefully before each expansion of the CONTENTS_LIBDB macros.
- *  (Fields rsv[123] are reserved for future additions; they are currently
- *   set to zero but may be set to some useful values in the future.)
- *
- *	CONTENTS_LIBDB_SREG(libdbnum, offset, size, align, rsv1, name, sregnum, bitmask, rsv2, rsv3)
- *	CONTENTS_LIBDB_UREG(libdbnum, offset, size, align, rsv1, name, uregnum, bitmask, rsv2, rsv3)
- *	CONTENTS_LIBDB_REGF(libdbnum, offset, size, align, rsv1, name, index, numentries, contentsize, regname_base, regfile_name, rsv2, rsv3)
- */
-
-#define XCHAL_EXTRA_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_EXTRA_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP0_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP0_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP1_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP1_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP2_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP2_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP3_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP3_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP4_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP4_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP5_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP5_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP6_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP6_SA_CONTENTS_LIBDB	/* empty */
-
-#define XCHAL_CP7_SA_CONTENTS_LIBDB_NUM	0
-#define XCHAL_CP7_SA_CONTENTS_LIBDB	/* empty */
-
-
-
-
-
-
-/*----------------------------------------------------------------------
-				MISC
-  ----------------------------------------------------------------------*/
-
-#if 0	/* is there something equivalent for user TIE? */
-#define XCHAL_CORE_ID			"linux_be"	/* configuration's alphanumeric core identifier
-							   (CoreID) set in the Xtensa Processor Generator */
-
-#define XCHAL_BUILD_UNIQUE_ID		0x00003256	/* software build-unique ID (22-bit) */
-
-/*  These definitions describe the hardware targeted by this software:  */
-#define XCHAL_HW_CONFIGID0		0xC103D1FF	/* config ID reg 0 value (upper 32 of 64 bits) */
-#define XCHAL_HW_CONFIGID1		0x00803256	/* config ID reg 1 value (lower 32 of 64 bits) */
-#define XCHAL_CONFIGID0			XCHAL_HW_CONFIGID0	/* for backward compatibility only -- don't use! */
-#define XCHAL_CONFIGID1			XCHAL_HW_CONFIGID1	/* for backward compatibility only -- don't use! */
-#define XCHAL_HW_RELEASE_MAJOR		1050	/* major release of targeted hardware */
-#define XCHAL_HW_RELEASE_MINOR		1	/* minor release of targeted hardware */
-#define XCHAL_HW_RELEASE_NAME		"T1050.1"	/* full release name of targeted hardware */
-#define XTHAL_HW_REL_T1050	1
-#define XTHAL_HW_REL_T1050_1	1
-#define XCHAL_HW_CONFIGID_RELIABLE	1
-#endif /*0*/
-
-
-
-/*----------------------------------------------------------------------
-				ISA
-  ----------------------------------------------------------------------*/
-
-#if 0	/* these probably don't belong here, but are related to or implemented using TIE */
-#define XCHAL_HAVE_BOOLEANS		0	/* 1 if booleans option configured, 0 otherwise */
-/*  Misc instructions:  */
-#define XCHAL_HAVE_MUL32		0	/* 1 if 32-bit integer multiply option configured, 0 otherwise */
-#define XCHAL_HAVE_MUL32_HIGH		0	/* 1 if MUL32 option includes MULUH and MULSH, 0 otherwise */
-
-#define XCHAL_HAVE_FP			0	/* 1 if floating point option configured, 0 otherwise */
-#endif /*0*/
-
-
-#endif /*XTENSA_CONFIG_TIE_H*/
-
diff -puN include/asm-xtensa/xtensa/coreasm.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/coreasm.h
+++ /dev/null
@@ -1,526 +0,0 @@
-#ifndef XTENSA_COREASM_H
-#define XTENSA_COREASM_H
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * include/asm-xtensa/xtensa/coreasm.h -- assembler-specific
- * definitions that depend on CORE configuration.
- *
- * Source for configuration-independent binaries (which link in a
- * configuration-specific HAL library) must NEVER include this file.
- * It is perfectly normal, however, for the HAL itself to include this
- * file.
- *
- * This file must NOT include xtensa/config/system.h.  Any assembler
- * header file that depends on system information should likely go in
- * a new systemasm.h (or sysasm.h) header file.
- *
- *  NOTE: macro beqi32 is NOT configuration-dependent, and is placed
- *        here til we will have configuration-independent header file.
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License.  See the file "COPYING" in the main directory of
- * this archive for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-#include <xtensa/config/core.h>
-#include <xtensa/config/specreg.h>
-
-/*
- *  Assembly-language specific definitions (assembly macros, etc.).
- */
-
-/*----------------------------------------------------------------------
- *  find_ms_setbit
- *
- *  This macro finds the most significant bit that is set in <as>
- *  and return its index + <base> in <ad>, or <base> - 1 if <as> is zero.
- *  The index counts starting at zero for the lsbit, so the return
- *  value ranges from <base>-1 (no bit set) to <base>+31 (msbit set).
- *
- *  Parameters:
- *	<ad>	destination address register (any register)
- *	<as>	source address register
- *	<at>	temporary address register (must be different than <as>)
- *	<base>	constant value added to result (usually 0 or 1)
- *  On entry:
- *	<ad> = undefined if different than <as>
- *	<as> = value whose most significant set bit is to be found
- *	<at> = undefined
- *	no other registers are used by this macro.
- *  On exit:
- *	<ad> = <base> + index of msbit set in original <as>,
- *	     = <base> - 1 if original <as> was zero.
- *	<as> clobbered (if not <ad>)
- *	<at> clobbered (if not <ad>)
- *  Example:
- *	find_ms_setbit a0, a4, a0, 0		-- return in a0 index of msbit set in a4
- */
-
-	.macro	find_ms_setbit ad, as, at, base
-#if XCHAL_HAVE_NSA
-	movi	\at, 31+\base
-	nsau	\as, \as	// get index of \as, numbered from msbit (32 if absent)
-	sub	\ad, \at, \as	// get numbering from lsbit (0..31, -1 if absent)
-#else /* XCHAL_HAVE_NSA */
-	movi	\at, \base	// start with result of 0 (point to lsbit of 32)
-
-	beqz	\as, 2f		// special case for zero argument: return -1
-	bltui	\as, 0x10000, 1f	// is it one of the 16 lsbits? (if so, check lower 16 bits)
-	addi	\at, \at, 16	// no, increment result to upper 16 bits (of 32)
-	//srli	\as, \as, 16	// check upper half (shift right 16 bits)
-	extui	\as, \as, 16, 16	// check upper half (shift right 16 bits)
-1:	bltui	\as, 0x100, 1f	// is it one of the 8 lsbits? (if so, check lower 8 bits)
-	addi	\at, \at, 8	// no, increment result to upper 8 bits (of 16)
-	srli	\as, \as, 8	// shift right to check upper 8 bits
-1:	bltui	\as, 0x10, 1f	// is it one of the 4 lsbits? (if so, check lower 4 bits)
-	addi	\at, \at, 4	// no, increment result to upper 4 bits (of 8)
-	srli	\as, \as, 4	// shift right 4 bits to check upper half
-1:	bltui	\as, 0x4, 1f	// is it one of the 2 lsbits? (if so, check lower 2 bits)
-	addi	\at, \at, 2	// no, increment result to upper 2 bits (of 4)
-	srli	\as, \as, 2	// shift right 2 bits to check upper half
-1:	bltui	\as, 0x2, 1f	// is it the lsbit?
-	addi	\at, \at, 2	// no, increment result to upper bit (of 2)
-2:	addi	\at, \at, -1	// (from just above: add 1;  from beqz: return -1)
-	//srli	\as, \as, 1
-1:				// done! \at contains index of msbit set (or -1 if none set)
-	.if	0x\ad - 0x\at	// destination different than \at ? (works because regs are a0-a15)
-	mov	\ad, \at	// then move result to \ad
-	.endif
-#endif /* XCHAL_HAVE_NSA */
-	.endm	// find_ms_setbit
-
-/*----------------------------------------------------------------------
- *  find_ls_setbit
- *
- *  This macro finds the least significant bit that is set in <as>,
- *  and return its index in <ad>.
- *  Usage is the same as for the find_ms_setbit macro.
- *  Example:
- *	find_ls_setbit a0, a4, a0, 0	-- return in a0 index of lsbit set in a4
- */
-
-	.macro	find_ls_setbit ad, as, at, base
-	neg	\at, \as	// keep only the least-significant bit that is set...
-	and	\as, \at, \as	// ... in \as
-	find_ms_setbit	\ad, \as, \at, \base
-	.endm	// find_ls_setbit
-
-/*----------------------------------------------------------------------
- *  find_ls_one
- *
- *  Same as find_ls_setbit with base zero.
- *  Source (as) and destination (ad) registers must be different.
- *  Provided for backward compatibility.
- */
-
-	.macro	find_ls_one ad, as
-	find_ls_setbit	\ad, \as, \ad, 0
-	.endm	// find_ls_one
-
-/*----------------------------------------------------------------------
- *  floop, floopnez, floopgtz, floopend
- *
- *  These macros are used for fast inner loops that
- *  work whether or not the Loops options is configured.
- *  If the Loops option is configured, they simply use
- *  the zero-overhead LOOP instructions; otherwise
- *  they use explicit decrement and branch instructions.
- *
- *  They are used in pairs, with floop, floopnez or floopgtz
- *  at the beginning of the loop, and floopend at the end.
- *
- *  Each pair of loop macro calls must be given the loop count
- *  address register and a unique label for that loop.
- *
- *  Example:
- *
- *	movi	 a3, 16     // loop 16 times
- *	floop    a3, myloop1
- *	:
- *	bnez     a7, end1	// exit loop if a7 != 0
- *	:
- *	floopend a3, myloop1
- *  end1:
- *
- *  Like the LOOP instructions, these macros cannot be
- *  nested, must include at least one instruction,
- *  cannot call functions inside the loop, etc.
- *  The loop can be exited by jumping to the instruction
- *  following floopend (or elsewhere outside the loop),
- *  or continued by jumping to a NOP instruction placed
- *  immediately before floopend.
- *
- *  Unlike LOOP instructions, the register passed to floop*
- *  cannot be used inside the loop, because it is used as
- *  the loop counter if the Loops option is not configured.
- *  And its value is undefined after exiting the loop.
- *  And because the loop counter register is active inside
- *  the loop, you can't easily use this construct to loop
- *  across a register file using ROTW as you might with LOOP
- *  instructions, unless you copy the loop register along.
- */
-
-	/*  Named label version of the macros:  */
-
-	.macro	floop		ar, endlabel
-	floop_		\ar, .Lfloopstart_\endlabel, .Lfloopend_\endlabel
-	.endm
-
-	.macro	floopnez	ar, endlabel
-	floopnez_	\ar, .Lfloopstart_\endlabel, .Lfloopend_\endlabel
-	.endm
-
-	.macro	floopgtz	ar, endlabel
-	floopgtz_	\ar, .Lfloopstart_\endlabel, .Lfloopend_\endlabel
-	.endm
-
-	.macro	floopend	ar, endlabel
-	floopend_	\ar, .Lfloopstart_\endlabel, .Lfloopend_\endlabel
-	.endm
-
-	/*  Numbered local label version of the macros:  */
-#if 0 /*UNTESTED*/
-	.macro	floop89		ar
-	floop_		\ar, 8, 9f
-	.endm
-
-	.macro	floopnez89	ar
-	floopnez_	\ar, 8, 9f
-	.endm
-
-	.macro	floopgtz89	ar
-	floopgtz_	\ar, 8, 9f
-	.endm
-
-	.macro	floopend89	ar
-	floopend_	\ar, 8b, 9
-	.endm
-#endif /*0*/
-
-	/*  Underlying version of the macros:  */
-
-	.macro	floop_	ar, startlabel, endlabelref
-	.ifdef	_infloop_
-	.if	_infloop_
-	.err	// Error: floop cannot be nested
-	.endif
-	.endif
-	.set	_infloop_, 1
-#if XCHAL_HAVE_LOOPS
-	loop	\ar, \endlabelref
-#else /* XCHAL_HAVE_LOOPS */
-\startlabel:
-	addi	\ar, \ar, -1
-#endif /* XCHAL_HAVE_LOOPS */
-	.endm	// floop_
-
-	.macro	floopnez_	ar, startlabel, endlabelref
-	.ifdef	_infloop_
-	.if	_infloop_
-	.err	// Error: floopnez cannot be nested
-	.endif
-	.endif
-	.set	_infloop_, 1
-#if XCHAL_HAVE_LOOPS
-	loopnez	\ar, \endlabelref
-#else /* XCHAL_HAVE_LOOPS */
-	beqz	\ar, \endlabelref
-\startlabel:
-	addi	\ar, \ar, -1
-#endif /* XCHAL_HAVE_LOOPS */
-	.endm	// floopnez_
-
-	.macro	floopgtz_	ar, startlabel, endlabelref
-	.ifdef	_infloop_
-	.if	_infloop_
-	.err	// Error: floopgtz cannot be nested
-	.endif
-	.endif
-	.set	_infloop_, 1
-#if XCHAL_HAVE_LOOPS
-	loopgtz	\ar, \endlabelref
-#else /* XCHAL_HAVE_LOOPS */
-	bltz	\ar, \endlabelref
-	beqz	\ar, \endlabelref
-\startlabel:
-	addi	\ar, \ar, -1
-#endif /* XCHAL_HAVE_LOOPS */
-	.endm	// floopgtz_
-
-
-	.macro	floopend_	ar, startlabelref, endlabel
-	.ifndef	_infloop_
-	.err	// Error: floopend without matching floopXXX
-	.endif
-	.ifeq	_infloop_
-	.err	// Error: floopend without matching floopXXX
-	.endif
-	.set	_infloop_, 0
-#if ! XCHAL_HAVE_LOOPS
-	bnez	\ar, \startlabelref
-#endif /* XCHAL_HAVE_LOOPS */
-\endlabel:
-	.endm	// floopend_
-
-/*----------------------------------------------------------------------
- *  crsil  --  conditional RSIL (read/set interrupt level)
- *
- *  Executes the RSIL instruction if it exists, else just reads PS.
- *  The RSIL instruction does not exist in the new exception architecture
- *  if the interrupt option is not selected.
- */
-
-	.macro	crsil	ar, newlevel
-#if XCHAL_HAVE_OLD_EXC_ARCH || XCHAL_HAVE_INTERRUPTS
-	rsil	\ar, \newlevel
-#else
-	rsr	\ar, PS
-#endif
-	.endm	// crsil
-
-/*----------------------------------------------------------------------
- *  window_spill{4,8,12}
- *
- *  These macros spill callers' register windows to the stack.
- *  They work for both privileged and non-privileged tasks.
- *  Must be called from a windowed ABI context, eg. within
- *  a windowed ABI function (ie. valid stack frame, window
- *  exceptions enabled, not in exception mode, etc).
- *
- *  This macro requires a single invocation of the window_spill_common
- *  macro in the same assembly unit and section.
- *
- *  Note that using window_spill{4,8,12} macros is more efficient
- *  than calling a function implemented using window_spill_function,
- *  because the latter needs extra code to figure out the size of
- *  the call to the spilling function.
- *
- *  Example usage:
- *
- *		.text
- *		.align	4
- *		.global	some_function
- *		.type	some_function,@function
- *	some_function:
- *		entry	a1, 16
- *		:
- *		:
- *
- *		window_spill4	// spill windows of some_function's callers; preserves a0..a3 only;
- *				// to use window_spill{8,12} in this example function we'd have
- *				// to increase space allocated by the entry instruction, because
- *				// 16 bytes only allows call4; 32 or 48 bytes (+locals) are needed
- *				// for call8/window_spill8 or call12/window_spill12 respectively.
- *		:
- *
- *		retw
- *
- *		window_spill_common	// instantiates code used by window_spill4
- *
- *
- *  On entry:
- *	none (if window_spill4)
- *	stack frame has enough space allocated for call8 (if window_spill8)
- *	stack frame has enough space allocated for call12 (if window_spill12)
- *  On exit:
- *	 a4..a15 clobbered (if window_spill4)
- *	 a8..a15 clobbered (if window_spill8)
- *	a12..a15 clobbered (if window_spill12)
- *	no caller windows are in live registers
- */
-
-	.macro	window_spill4
-#if XCHAL_HAVE_WINDOWED
-# if XCHAL_NUM_AREGS == 16
-	movi	a15, 0			// for 16-register files, no need to call to reach the end
-# elif XCHAL_NUM_AREGS == 32
-	call4	.L__wdwspill_assist28	// call deep enough to clear out any live callers
-# elif XCHAL_NUM_AREGS == 64
-	call4	.L__wdwspill_assist60	// call deep enough to clear out any live callers
-# endif
-#endif
-	.endm	// window_spill4
-
-	.macro	window_spill8
-#if XCHAL_HAVE_WINDOWED
-# if XCHAL_NUM_AREGS == 16
-	movi	a15, 0			// for 16-register files, no need to call to reach the end
-# elif XCHAL_NUM_AREGS == 32
-	call8	.L__wdwspill_assist24	// call deep enough to clear out any live callers
-# elif XCHAL_NUM_AREGS == 64
-	call8	.L__wdwspill_assist56	// call deep enough to clear out any live callers
-# endif
-#endif
-	.endm	// window_spill8
-
-	.macro	window_spill12
-#if XCHAL_HAVE_WINDOWED
-# if XCHAL_NUM_AREGS == 16
-	movi	a15, 0			// for 16-register files, no need to call to reach the end
-# elif XCHAL_NUM_AREGS == 32
-	call12	.L__wdwspill_assist20	// call deep enough to clear out any live callers
-# elif XCHAL_NUM_AREGS == 64
-	call12	.L__wdwspill_assist52	// call deep enough to clear out any live callers
-# endif
-#endif
-	.endm	// window_spill12
-
-/*----------------------------------------------------------------------
- *  window_spill_function
- *
- *  This macro outputs a function that will spill its caller's callers'
- *  register windows to the stack.  Eg. it could be used to implement
- *  a version of xthal_window_spill() that works in non-privileged tasks.
- *  This works for both privileged and non-privileged tasks.
- *
- *  Typical usage:
- *
- *		.text
- *		.align	4
- *		.global	my_spill_function
- *		.type	my_spill_function,@function
- *	my_spill_function:
- *		window_spill_function
- *
- *  On entry to resulting function:
- *	none
- *  On exit from resulting function:
- *	none (no caller windows are in live registers)
- */
-
-	.macro	window_spill_function
-#if XCHAL_HAVE_WINDOWED
-# if XCHAL_NUM_AREGS == 32
-	entry	sp, 48
-	bbci.l	a0, 31, 1f		// branch if called with call4
-	bbsi.l	a0, 30, 2f		// branch if called with call12
-	call8	.L__wdwspill_assist16	// called with call8, only need another 8
-	retw
-1:	call12	.L__wdwspill_assist16	// called with call4, only need another 12
-	retw
-2:	call4	.L__wdwspill_assist16	// called with call12, only need another 4
-	retw
-# elif XCHAL_NUM_AREGS == 64
-	entry	sp, 48
-	bbci.l	a0, 31, 1f		// branch if called with call4
-	bbsi.l	a0, 30, 2f		// branch if called with call12
-	call4	.L__wdwspill_assist52	// called with call8, only need a call4
-	retw
-1:	call8	.L__wdwspill_assist52	// called with call4, only need a call8
-	retw
-2:	call12	.L__wdwspill_assist40	// called with call12, can skip a call12
-	retw
-# elif XCHAL_NUM_AREGS == 16
-	entry	sp, 16
-	bbci.l	a0, 31, 1f	// branch if called with call4
-	bbsi.l	a0, 30, 2f	// branch if called with call12
-	movi	a7, 0		// called with call8
-	retw
-1:	movi	a11, 0		// called with call4
-2:	retw			// if called with call12, everything already spilled
-
-//	movi	a15, 0		// trick to spill all but the direct caller
-//	j	1f
-//	//  The entry instruction is magical in the assembler (gets auto-aligned)
-//	//  so we have to jump to it to avoid falling through the padding.
-//	//  We need entry/retw to know where to return.
-//1:	entry	sp, 16
-//	retw
-# else
-#  error "unrecognized address register file size"
-# endif
-#endif /* XCHAL_HAVE_WINDOWED */
-	window_spill_common
-	.endm	// window_spill_function
-
-/*----------------------------------------------------------------------
- *  window_spill_common
- *
- *  Common code used by any number of invocations of the window_spill##
- *  and window_spill_function macros.
- *
- *  Must be instantiated exactly once within a given assembly unit,
- *  within call/j range of and same section as window_spill##
- *  macro invocations for that assembly unit.
- *  (Is automatically instantiated by the window_spill_function macro.)
- */
-
-	.macro	window_spill_common
-#if XCHAL_HAVE_WINDOWED && (XCHAL_NUM_AREGS == 32 || XCHAL_NUM_AREGS == 64)
-	.ifndef	.L__wdwspill_defined
-# if XCHAL_NUM_AREGS >= 64
-.L__wdwspill_assist60:
-	entry	sp, 32
-	call8	.L__wdwspill_assist52
-	retw
-.L__wdwspill_assist56:
-	entry	sp, 16
-	call4	.L__wdwspill_assist52
-	retw
-.L__wdwspill_assist52:
-	entry	sp, 48
-	call12	.L__wdwspill_assist40
-	retw
-.L__wdwspill_assist40:
-	entry	sp, 48
-	call12	.L__wdwspill_assist28
-	retw
-# endif
-.L__wdwspill_assist28:
-	entry	sp, 48
-	call12	.L__wdwspill_assist16
-	retw
-.L__wdwspill_assist24:
-	entry	sp, 32
-	call8	.L__wdwspill_assist16
-	retw
-.L__wdwspill_assist20:
-	entry	sp, 16
-	call4	.L__wdwspill_assist16
-	retw
-.L__wdwspill_assist16:
-	entry	sp, 16
-	movi	a15, 0
-	retw
-	.set	.L__wdwspill_defined, 1
-	.endif
-#endif /* XCHAL_HAVE_WINDOWED with 32 or 64 aregs */
-	.endm	// window_spill_common
-
-/*----------------------------------------------------------------------
- *  beqi32
- *
- *  macro implements version of beqi for arbitrary 32-bit immidiate value
- *
- *     beqi32 ax, ay, imm32, label
- *
- *  Compares value in register ax with imm32 value and jumps to label if
- *  equal. Clobberes register ay if needed
- *
- */
-   .macro beqi32	ax, ay, imm, label
-    .ifeq ((\imm-1) & ~7)	// 1..8 ?
-		beqi	\ax, \imm, \label
-    .else
-      .ifeq (\imm+1)		// -1 ?
-		beqi	\ax, \imm, \label
-      .else
-        .ifeq (\imm)		// 0 ?
-		beqz	\ax, \label
-        .else
-		//  We could also handle immediates 10,12,16,32,64,128,256
-		//  but it would be a long macro...
-		movi	\ay, \imm
-		beq	\ax, \ay, \label
-        .endif
-      .endif
-    .endif
-   .endm // beqi32
-
-#endif /*XTENSA_COREASM_H*/
-
diff -puN include/asm-xtensa/xtensa/corebits.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/corebits.h
+++ /dev/null
@@ -1,77 +0,0 @@
-#ifndef XTENSA_COREBITS_H
-#define XTENSA_COREBITS_H
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * xtensa/corebits.h - Xtensa Special Register field positions and masks.
- *
- * (In previous releases, these were defined in specreg.h, a generated file.
- *  This file is not generated, i.e. it is processor configuration independent.)
- */
-
-
-/*  EXCCAUSE register fields:  */
-#define EXCCAUSE_EXCCAUSE_SHIFT	0
-#define EXCCAUSE_EXCCAUSE_MASK	0x3F
-/*  Exception causes (mostly incomplete!):  */
-#define EXCCAUSE_ILLEGAL		0
-#define EXCCAUSE_SYSCALL		1
-#define EXCCAUSE_IFETCHERROR		2
-#define EXCCAUSE_LOADSTOREERROR		3
-#define EXCCAUSE_LEVEL1INTERRUPT	4
-#define EXCCAUSE_ALLOCA			5
-
-/*  PS register fields:  */
-#define PS_WOE_SHIFT		18
-#define PS_WOE_MASK		0x00040000
-#define PS_WOE			PS_WOE_MASK
-#define PS_CALLINC_SHIFT	16
-#define PS_CALLINC_MASK		0x00030000
-#define PS_CALLINC(n)		(((n)&3)<<PS_CALLINC_SHIFT)	/* n = 0..3 */
-#define PS_OWB_SHIFT		8
-#define PS_OWB_MASK		0x00000F00
-#define PS_OWB(n)		(((n)&15)<<PS_OWB_SHIFT)	/* n = 0..15 (or 0..7) */
-#define PS_RING_SHIFT		6
-#define PS_RING_MASK		0x000000C0
-#define PS_RING(n)		(((n)&3)<<PS_RING_SHIFT)	/* n = 0..3 */
-#define PS_UM_SHIFT		5
-#define PS_UM_MASK		0x00000020
-#define PS_UM			PS_UM_MASK
-#define PS_EXCM_SHIFT		4
-#define PS_EXCM_MASK		0x00000010
-#define PS_EXCM			PS_EXCM_MASK
-#define PS_INTLEVEL_SHIFT	0
-#define PS_INTLEVEL_MASK	0x0000000F
-#define PS_INTLEVEL(n)		((n)&PS_INTLEVEL_MASK)		/* n = 0..15 */
-/*  Backward compatibility (deprecated):  */
-#define PS_PROGSTACK_SHIFT	PS_UM_SHIFT
-#define PS_PROGSTACK_MASK	PS_UM_MASK
-#define PS_PROG_SHIFT		PS_UM_SHIFT
-#define PS_PROG_MASK		PS_UM_MASK
-#define PS_PROG			PS_UM
-
-/*  DBREAKCn register fields:  */
-#define DBREAKC_MASK_SHIFT		0
-#define DBREAKC_MASK_MASK		0x0000003F
-#define DBREAKC_LOADBREAK_SHIFT		30
-#define DBREAKC_LOADBREAK_MASK		0x40000000
-#define DBREAKC_STOREBREAK_SHIFT	31
-#define DBREAKC_STOREBREAK_MASK		0x80000000
-
-/*  DEBUGCAUSE register fields:  */
-#define DEBUGCAUSE_DEBUGINT_SHIFT	5
-#define DEBUGCAUSE_DEBUGINT_MASK	0x20	/* debug interrupt */
-#define DEBUGCAUSE_BREAKN_SHIFT		4
-#define DEBUGCAUSE_BREAKN_MASK		0x10	/* BREAK.N instruction */
-#define DEBUGCAUSE_BREAK_SHIFT		3
-#define DEBUGCAUSE_BREAK_MASK		0x08	/* BREAK instruction */
-#define DEBUGCAUSE_DBREAK_SHIFT		2
-#define DEBUGCAUSE_DBREAK_MASK		0x04	/* DBREAK match */
-#define DEBUGCAUSE_IBREAK_SHIFT		1
-#define DEBUGCAUSE_IBREAK_MASK		0x02	/* IBREAK match */
-#define DEBUGCAUSE_ICOUNT_SHIFT		0
-#define DEBUGCAUSE_ICOUNT_MASK		0x01	/* ICOUNT would increment to zero */
-
-#endif /*XTENSA_COREBITS_H*/
-
diff -puN include/asm-xtensa/xtensa/hal.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/hal.h
+++ /dev/null
@@ -1,822 +0,0 @@
-#ifndef XTENSA_HAL_H
-#define XTENSA_HAL_H
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * include/asm-xtensa/xtensa/hal.h -- contains a definition of the
- * Core HAL interface.
- *
- * All definitions in this header file are independent of any specific
- * Xtensa processor configuration.  Thus an OS or other software can
- * include this header file and be compiled into configuration-
- * independent objects that can be distributed and eventually linked
- * to the HAL library (libhal.a) to create a configuration-specific
- * final executable.
- *
- * Certain definitions, however, are release-specific -- such as the
- * XTHAL_RELEASE_xxx macros (or additions made in later releases).
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-/*----------------------------------------------------------------------
-  			 Constant Definitions
-			(shared with assembly)
-  ----------------------------------------------------------------------*/
-
-/*  Software release information (not configuration-specific!):  */
-#define XTHAL_RELEASE_MAJOR	1050
-#define XTHAL_RELEASE_MINOR	0
-#define XTHAL_RELEASE_NAME	"T1050.0-2002-08-06-eng0"
-#define XTHAL_RELEASE_INTERNAL	"2002-08-06-eng0"
-#define XTHAL_REL_T1050	1
-#define XTHAL_REL_T1050_0	1
-#define XTHAL_REL_T1050_0_2002	1
-#define XTHAL_REL_T1050_0_2002_08	1
-#define XTHAL_REL_T1050_0_2002_08_06	1
-#define XTHAL_REL_T1050_0_2002_08_06_ENG0	1
-
-/*  HAL version numbers (these names are for backward compatibility):  */
-#define XTHAL_MAJOR_REV		XTHAL_RELEASE_MAJOR
-#define XTHAL_MINOR_REV		XTHAL_RELEASE_MINOR
-/*
- *  A bit of software release history on values of XTHAL_{MAJOR,MINOR}_REV:
- *
- *	Release		MAJOR	MINOR		Comment
- *	=======		=====	=====		=======
- *	T1015.n		n/a	n/a		(HAL not yet available)
- *	T1020.{0,1,2}	0	1		(HAL beta)
- *	T1020.{3,4}	0	2		First release.
- *	T1020.n (n>4)	0	2 or >3		(TBD)
- *	T1030.0		0	1		(HAL beta)
- *	T1030.{1,2}	0	3		Equivalent to first release.
- *	T1030.n (n>=3)	0	>= 3		(TBD)
- *	T1040.n		1040	n		Full CHAL available from T1040.2
- *	T1050.n		1050	n		Current release.
- *
- *
- *  Note:  there is a distinction between the software release with
- *  which something is compiled (accessible using XTHAL_RELEASE_* macros)
- *  and the software release with which the HAL library was compiled
- *  (accessible using Xthal_release_* global variables).  This
- *  distinction is particularly relevant for vendors that distribute
- *  configuration-independent binaries (eg. an OS), where their customer
- *  might link it with a HAL of a different Xtensa software release.
- *  In this case, it may be appropriate for the OS to verify at run-time
- *  whether XTHAL_RELEASE_* and Xthal_release_* are compatible.
- *  [Guidelines as to which release is compatible with which are not
- *  currently provided explicitly, but might be inferred from reading
- *  OSKit documentation for all releases -- compatibility is also highly
- *  dependent on which HAL features are used.  Each release is usually
- *  backward compatible, with very few exceptions if any.]
- *
- *  Notes:
- *	Tornado 2.0 supported in T1020.3+, T1030.1+, and T1040.{0,1} only.
- *	Tornado 2.0.2 supported in T1040.2+, and T1050.
- *	Compile-time HAL port of NucleusPlus supported by T1040.2+ and T1050.
- */
-
-
-/*
- *  Architectural limits, independent of configuration.
- *  Note that these are ISA-defined limits, not micro-architecture implementation
- *  limits enforced by the Xtensa Processor Generator (which may be stricter than
- *  these below).
- */
-#define XTHAL_MAX_CPS		8	/* max number of coprocessors (0..7) */
-#define XTHAL_MAX_INTERRUPTS	32	/* max number of interrupts (0..31) */
-#define XTHAL_MAX_INTLEVELS	16	/* max number of interrupt levels (0..15) */
-					/* (as of T1040, implementation limit is 7: 0..6) */
-#define XTHAL_MAX_TIMERS	4	/* max number of timers (CCOMPARE0..CCOMPARE3) */
-					/* (as of T1040, implementation limit is 3: 0..2) */
-
-/*  Misc:  */
-#define XTHAL_LITTLEENDIAN		0
-#define XTHAL_BIGENDIAN			1
-
-
-/*  Interrupt types:  */
-#define XTHAL_INTTYPE_UNCONFIGURED	0
-#define XTHAL_INTTYPE_SOFTWARE		1
-#define XTHAL_INTTYPE_EXTERN_EDGE	2
-#define XTHAL_INTTYPE_EXTERN_LEVEL	3
-#define XTHAL_INTTYPE_TIMER		4
-#define XTHAL_INTTYPE_NMI		5
-#define XTHAL_MAX_INTTYPES		6	/* number of interrupt types */
-
-/*  Timer related:  */
-#define XTHAL_TIMER_UNCONFIGURED	-1	/* Xthal_timer_interrupt[] value for non-existent timers */
-#define XTHAL_TIMER_UNASSIGNED	XTHAL_TIMER_UNCONFIGURED	/* (for backwards compatibility only) */
-
-
-/*  Access Mode bits (tentative):  */	/* bit abbr unit short_name       PPC equ - Description */
-#define XTHAL_AMB_EXCEPTION	0	/* 001 E EX fls: EXception        none    - generate exception on any access (aka "illegal") */
-#define XTHAL_AMB_HITCACHE	1	/* 002 C CH fls: use Cache on Hit ~(I CI) - use cache on hit -- way from tag match [or H HC, or U UC] (ISA: same, except for Isolate case) */
-#define XTHAL_AMB_ALLOCATE	2	/* 004 A AL fl?: ALlocate         none    - refill cache on miss -- way from LRU [or F FI fill] (ISA: Read/Write Miss Refill) */
-#define XTHAL_AMB_WRITETHRU	3	/* 008 W WT --s: WriteThrough     W WT    - store immediately to memory (ISA: same) */
-#define XTHAL_AMB_ISOLATE	4	/* 010 I IS fls: ISolate          none    - use cache regardless of hit-vs-miss -- way from vaddr (ISA: use-cache-on-miss+hit) */
-#define XTHAL_AMB_GUARD		5	/* 020 G GU ?l?: GUard            G *     - non-speculative; spec/replay refs not permitted */
-#if 0
-#define XTHAL_AMB_ORDERED	x	/* 000 O OR fls: ORdered          G *     - mem accesses cannot be out of order */
-#define XTHAL_AMB_FUSEWRITES	x	/* 000 F FW --s: FuseWrites       none    - allow combining/merging multiple writes (to same datapath data unit) into one (implied by writeback) */
-#define XTHAL_AMB_COHERENT	x	/* 000 M MC fl?: Mem/MP Coherent  M       - on reads, other CPUs/bus-masters may need to supply data */
-#define XTHAL_AMB_TRUSTED	x	/* 000 T TR ?l?: TRusted          none    - memory will not bus error (if it does, handle as fatal imprecise interrupt) */
-#define XTHAL_AMB_PREFETCH	x	/* 000 P PR fl?: PRefetch         none    - on refill, read line+1 into prefetch buffers */
-#define XTHAL_AMB_STREAM	x	/* 000 S ST ???: STreaming        none    - access one of N stream buffers */
-#endif /*0*/
-
-#define XTHAL_AM_EXCEPTION	(1<<XTHAL_AMB_EXCEPTION)
-#define XTHAL_AM_HITCACHE	(1<<XTHAL_AMB_HITCACHE)
-#define XTHAL_AM_ALLOCATE	(1<<XTHAL_AMB_ALLOCATE)
-#define XTHAL_AM_WRITETHRU	(1<<XTHAL_AMB_WRITETHRU)
-#define XTHAL_AM_ISOLATE	(1<<XTHAL_AMB_ISOLATE)
-#define XTHAL_AM_GUARD		(1<<XTHAL_AMB_GUARD)
-#if 0
-#define XTHAL_AM_ORDERED	(1<<XTHAL_AMB_ORDERED)
-#define XTHAL_AM_FUSEWRITES	(1<<XTHAL_AMB_FUSEWRITES)
-#define XTHAL_AM_COHERENT	(1<<XTHAL_AMB_COHERENT)
-#define XTHAL_AM_TRUSTED	(1<<XTHAL_AMB_TRUSTED)
-#define XTHAL_AM_PREFETCH	(1<<XTHAL_AMB_PREFETCH)
-#define XTHAL_AM_STREAM		(1<<XTHAL_AMB_STREAM)
-#endif /*0*/
-
-/*
- *  Allowed Access Modes (bit combinations).
- *
- *  Columns are:
- *  "FOGIWACE"
- *	Access mode bits (see XTHAL_AMB_xxx above).
- *	<letter> = bit is set
- *	'-'      = bit is clear
- *	'.'      = bit is irrelevant / don't care, as follows:
- *			E=1 makes all others irrelevant
- *			W,F relevant only for stores
- *  "2345"
- *	Indicates which Xtensa releases support the corresponding
- *	access mode.  Releases for each character column are:
- *		2 = prior to T1020.2:   T1015 (V1.5), T1020.0, T1020.1
- *		3 = T1020.2 and later:  T1020.2+, T1030
- *		4 = T1040
- *		5 = T1050 (maybe)
- *	And the character column contents are:
- *		<number> = support by release(s)
- *		"." = unsupported by release(s)
- *		"?" = support unknown
- */
-					/* FOGIWACE 2345 */
-/*  For instruction fetch:  */
-#define XTHAL_FAM_EXCEPTION	0x001	/* .......E 2345 exception */
-#define XTHAL_FAM_ISOLATE	0x012	/* .--I.-C- .... isolate */
-#define XTHAL_FAM_BYPASS	0x000	/* .---.--- 2345 bypass */
-#define XTHAL_FAM_NACACHED	0x002	/* .---.-C- .... cached no-allocate (frozen) */
-#define XTHAL_FAM_CACHED	0x006	/* .---.AC- 2345 cached */
-/*  For data load:  */
-#define XTHAL_LAM_EXCEPTION	0x001	/* .......E 2345 exception */
-#define XTHAL_LAM_ISOLATE	0x012	/* .--I.-C- 2345 isolate */
-#define XTHAL_LAM_BYPASS	0x000	/* .O--.--- 2... bypass speculative */
-#define XTHAL_LAM_BYPASSG	0x020	/* .OG-.--- .345 bypass guarded */
-#define XTHAL_LAM_NACACHED	0x002	/* .O--.-C- 2... cached no-allocate speculative */
-#define XTHAL_LAM_NACACHEDG	0x022	/* .OG-.-C- .345 cached no-allocate guarded */
-#define XTHAL_LAM_CACHED	0x006	/* .---.AC- 2345 cached speculative */
-#define XTHAL_LAM_CACHEDG	0x026	/* .?G-.AC- .... cached guarded */
-/*  For data store:  */
-#define XTHAL_SAM_EXCEPTION	0x001	/* .......E 2345 exception */
-#define XTHAL_SAM_ISOLATE	0x032	/* .-GI--C- 2345 isolate */
-#define XTHAL_SAM_BYPASS	0x028	/* -OG-W--- 2345 bypass */
-/*efine XTHAL_SAM_BYPASSF	0x028*/	/* F-G-W--- ...? bypass write-combined */
-#define XTHAL_SAM_WRITETHRU	0x02A	/* -OG-W-C- 234? writethrough */
-/*efine XTHAL_SAM_WRITETHRUF	0x02A*/	/* F-G-W-C- ...5 writethrough write-combined */
-#define XTHAL_SAM_WRITEALLOC	0x02E	/* -OG-WAC- ...? writethrough-allocate */
-/*efine XTHAL_SAM_WRITEALLOCF	0x02E*/	/* F-G-WAC- ...? writethrough-allocate write-combined */
-#define XTHAL_SAM_WRITEBACK	0x026	/* F-G--AC- ...5 writeback */
-
-#if 0
-/*
-    Cache attribute encoding for CACHEATTR (per ISA):
-    (Note:  if this differs from ISA Ref Manual, ISA has precedence)
-
-	Inst-fetches	Loads		Stores
-	-------------	------------	-------------
-0x0	FCA_EXCEPTION  ?LCA_NACACHED_G*	SCA_WRITETHRU	"uncached"
-0x1	FCA_CACHED	LCA_CACHED	SCA_WRITETHRU	cached
-0x2	FCA_BYPASS	LCA_BYPASS_G*	SCA_BYPASS	bypass
-0x3	FCA_CACHED	LCA_CACHED	SCA_WRITEALLOCF	write-allocate
-		     or LCA_EXCEPTION	SCA_EXCEPTION	(if unimplemented)
-0x4	FCA_CACHED	LCA_CACHED	SCA_WRITEBACK	write-back
-		     or LCA_EXCEPTION	SCA_EXCEPTION	(if unimplemented)
-0x5..D	FCA_EXCEPTION	LCA_EXCEPTION	SCA_EXCEPTION	(reserved)
-0xE	FCA_EXCEPTION	LCA_ISOLATE	SCA_ISOLATE	isolate
-0xF	FCA_EXCEPTION	LCA_EXCEPTION	SCA_EXCEPTION	illegal
-     *  Prior to T1020.2?, guard feature not supported, this defaulted to speculative (no _G)
-*/
-#endif /*0*/
-
-
-#if !defined(__ASSEMBLY__) && !defined(_NOCLANGUAGE)
-#ifdef __cplusplus
-extern "C" {
-#endif
-
-/*----------------------------------------------------------------------
-  			     HAL
-  ----------------------------------------------------------------------*/
-
-/* Constant to be checked in build = (XTHAL_MAJOR_REV<<16)|XTHAL_MINOR_REV */
-extern const unsigned int Xthal_rev_no;
-
-
-/*----------------------------------------------------------------------
-  			Processor State
-  ----------------------------------------------------------------------*/
-/* save & restore the extra processor state */
-extern void xthal_save_extra(void *base);
-extern void xthal_restore_extra(void *base);
-
-extern void xthal_save_cpregs(void *base, int);
-extern void xthal_restore_cpregs(void *base, int);
-
-/*extern void xthal_save_all_extra(void *base);*/
-/*extern void xthal_restore_all_extra(void *base);*/
-
-/* space for processor state */
-extern const unsigned int Xthal_extra_size;
-extern const unsigned int Xthal_extra_align;
-/* space for TIE register files */
-extern const unsigned int Xthal_cpregs_size[XTHAL_MAX_CPS];
-extern const unsigned int Xthal_cpregs_align[XTHAL_MAX_CPS];
-
-/* total of space for the processor state (for Tor2) */
-extern const unsigned int Xthal_all_extra_size;
-extern const unsigned int Xthal_all_extra_align;
-
-/* initialize the extra processor */
-/*extern void xthal_init_extra(void);*/
-/* initialize the TIE coprocessor */
-/*extern void xthal_init_cp(int);*/
-
-/* initialize the extra processor */
-extern void xthal_init_mem_extra(void *);
-/* initialize the TIE coprocessor */
-extern void xthal_init_mem_cp(void *, int);
-
-/* validate & invalidate the TIE register file */
-extern void xthal_validate_cp(int);
-extern void xthal_invalidate_cp(int);
-
-/* the number of TIE coprocessors contiguous from zero (for Tor2) */
-extern const unsigned int Xthal_num_coprocessors;
-
-/* actual number of coprocessors */
-extern const unsigned char Xthal_cp_num;
-/* index of highest numbered coprocessor, plus one */
-extern const unsigned char Xthal_cp_max;
-/* index of highest allowed coprocessor number, per cfg, plus one */
-/*extern const unsigned char Xthal_cp_maxcfg;*/
-/* bitmask of which coprocessors are present */
-extern const unsigned int  Xthal_cp_mask;
-
-/* read and write cpenable register */
-extern void xthal_set_cpenable(unsigned);
-extern unsigned xthal_get_cpenable(void);
-
-/* read & write extra state register */
-/*extern int xthal_read_extra(void *base, unsigned reg, unsigned *value);*/
-/*extern int xthal_write_extra(void *base, unsigned reg, unsigned value);*/
-
-/* read & write a TIE coprocessor register */
-/*extern int xthal_read_cpreg(void *base, int cp, unsigned reg, unsigned *value);*/
-/*extern int xthal_write_cpreg(void *base, int cp, unsigned reg, unsigned value);*/
-
-/* return coprocessor number based on register */
-/*extern int xthal_which_cp(unsigned reg);*/
-
-/*----------------------------------------------------------------------
-   				Interrupts
-  ----------------------------------------------------------------------*/
-
-/* the number of interrupt levels */
-extern const unsigned char Xthal_num_intlevels;
-/* the number of interrupts */
-extern const unsigned char Xthal_num_interrupts;
-
-/* mask for level of interrupts */
-extern const unsigned int Xthal_intlevel_mask[XTHAL_MAX_INTLEVELS];
-/* mask for level 0 to N interrupts */
-extern const unsigned int Xthal_intlevel_andbelow_mask[XTHAL_MAX_INTLEVELS];
-
-/* level of each interrupt */
-extern const unsigned char Xthal_intlevel[XTHAL_MAX_INTERRUPTS];
-
-/* type per interrupt */
-extern const unsigned char Xthal_inttype[XTHAL_MAX_INTERRUPTS];
-
-/* masks of each type of interrupt */
-extern const unsigned int Xthal_inttype_mask[XTHAL_MAX_INTTYPES];
-
-/* interrupt numbers assigned to each timer interrupt */
-extern const int Xthal_timer_interrupt[XTHAL_MAX_TIMERS];
-
-/***  Virtual interrupt prioritization:  ***/
-
-/*  Convert between interrupt levels (as per PS.INTLEVEL) and virtual interrupt priorities:  */
-extern unsigned	xthal_vpri_to_intlevel(unsigned vpri);
-extern unsigned	xthal_intlevel_to_vpri(unsigned intlevel);
-
-/*  Enables/disables given set (mask) of interrupts; returns previous enabled-mask of all ints:  */
-extern unsigned	xthal_int_enable(unsigned);
-extern unsigned	xthal_int_disable(unsigned);
-
-/*  Set/get virtual priority of an interrupt:  */
-extern int	xthal_set_int_vpri(int intnum, int vpri);
-extern int	xthal_get_int_vpri(int intnum);
-
-/*  Set/get interrupt lockout level for exclusive access to virtual priority data structures:  */
-extern void	xthal_set_vpri_locklevel(unsigned intlevel);
-extern unsigned	xthal_get_vpri_locklevel(void);
-
-/*  Set/get current virtual interrupt priority:  */
-extern unsigned	xthal_set_vpri(unsigned vpri);
-extern unsigned	xthal_get_vpri(unsigned vpri);
-extern unsigned	xthal_set_vpri_intlevel(unsigned intlevel);
-extern unsigned	xthal_set_vpri_lock(void);
-
-
-
-/*----------------------------------------------------------------------
-   			Generic Interrupt Trampolining Support
-  ----------------------------------------------------------------------*/
-
-typedef void (XtHalVoidFunc)(void);
-
-/*
- *  Bitmask of interrupts currently trampolining down:
- */
-extern unsigned Xthal_tram_pending;
-
-/*
- *  Bitmask of which interrupts currently trampolining down
- *  synchronously are actually enabled; this bitmask is necessary
- *  because INTENABLE cannot hold that state (sync-trampolining
- *  interrupts must be kept disabled while trampolining);
- *  in the current implementation, any bit set here is not set
- *  in INTENABLE, and vice-versa; once a sync-trampoline is
- *  handled (at level one), its enable bit must be moved from
- *  here to INTENABLE:
- */
-extern unsigned Xthal_tram_enabled;
-
-/*
- *  Bitmask of interrupts configured for sync trampolining:
- */
-extern unsigned Xthal_tram_sync;
-
-
-/*  Trampoline support functions:  */
-extern unsigned  xthal_tram_pending_to_service( void );
-extern void      xthal_tram_done( unsigned serviced_mask );
-extern int       xthal_tram_set_sync( int intnum, int sync );
-extern XtHalVoidFunc* xthal_set_tram_trigger_func( XtHalVoidFunc *trigger_fn );
-
-/*  INTENABLE,INTREAD,INTSET,INTCLEAR register access functions:  */
-extern unsigned  xthal_get_intenable( void );
-extern void      xthal_set_intenable( unsigned );
-extern unsigned  xthal_get_intread( void );
-extern void      xthal_set_intset( unsigned );
-extern void      xthal_set_intclear( unsigned );
-
-
-/*----------------------------------------------------------------------
-   				Register Windows
-  ----------------------------------------------------------------------*/
-
-/* number of registers in register window */
-extern const unsigned int  Xthal_num_aregs;
-extern const unsigned char Xthal_num_aregs_log2;
-
-/*  This spill any live register windows (other than the caller's):  */
-extern void      xthal_window_spill( void );
-
-
-/*----------------------------------------------------------------------
-   				Cache
-  ----------------------------------------------------------------------*/
-
-/* size of the cache lines in log2(bytes) */
-extern const unsigned char Xthal_icache_linewidth;
-extern const unsigned char Xthal_dcache_linewidth;
-/* size of the cache lines in bytes */
-extern const unsigned short Xthal_icache_linesize;
-extern const unsigned short Xthal_dcache_linesize;
-/* number of cache sets in log2(lines per way) */
-extern const unsigned char Xthal_icache_setwidth;
-extern const unsigned char Xthal_dcache_setwidth;
-/* cache set associativity (number of ways) */
-extern const unsigned int  Xthal_icache_ways;
-extern const unsigned int  Xthal_dcache_ways;
-/* size of the caches in bytes (ways * 2^(linewidth + setwidth)) */
-extern const unsigned int  Xthal_icache_size;
-extern const unsigned int  Xthal_dcache_size;
-/* cache features */
-extern const unsigned char Xthal_dcache_is_writeback;
-extern const unsigned char Xthal_icache_line_lockable;
-extern const unsigned char Xthal_dcache_line_lockable;
-
-/* cache attribute register control (used by other HAL routines) */
-extern unsigned xthal_get_cacheattr( void );
-extern unsigned xthal_get_icacheattr( void );
-extern unsigned xthal_get_dcacheattr( void );
-extern void     xthal_set_cacheattr( unsigned );
-extern void     xthal_set_icacheattr( unsigned );
-extern void     xthal_set_dcacheattr( unsigned );
-
-/* initialize cache support (must be called once at startup, before all other cache calls) */
-/*extern void xthal_cache_startinit( void );*/
-/* reset caches */
-/*extern void xthal_icache_reset( void );*/
-/*extern void xthal_dcache_reset( void );*/
-/* enable caches */
-extern void xthal_icache_enable( void );	/* DEPRECATED */
-extern void xthal_dcache_enable( void );	/* DEPRECATED */
-/* disable caches */
-extern void xthal_icache_disable( void );	/* DEPRECATED */
-extern void xthal_dcache_disable( void );	/* DEPRECATED */
-
-/* invalidate the caches */
-extern void xthal_icache_all_invalidate( void );
-extern void xthal_dcache_all_invalidate( void );
-extern void xthal_icache_region_invalidate( void *addr, unsigned size );
-extern void xthal_dcache_region_invalidate( void *addr, unsigned size );
-extern void xthal_icache_line_invalidate(void *addr);
-extern void xthal_dcache_line_invalidate(void *addr);
-/* write dirty data back */
-extern void xthal_dcache_all_writeback( void );
-extern void xthal_dcache_region_writeback( void *addr, unsigned size );
-extern void xthal_dcache_line_writeback(void *addr);
-/* write dirty data back and invalidate */
-extern void xthal_dcache_all_writeback_inv( void );
-extern void xthal_dcache_region_writeback_inv( void *addr, unsigned size );
-extern void xthal_dcache_line_writeback_inv(void *addr);
-/* prefetch and lock specified memory range into cache */
-extern void xthal_icache_region_lock( void *addr, unsigned size );
-extern void xthal_dcache_region_lock( void *addr, unsigned size );
-extern void xthal_icache_line_lock(void *addr);
-extern void xthal_dcache_line_lock(void *addr);
-/* unlock from cache */
-extern void xthal_icache_all_unlock( void );
-extern void xthal_dcache_all_unlock( void );
-extern void xthal_icache_region_unlock( void *addr, unsigned size );
-extern void xthal_dcache_region_unlock( void *addr, unsigned size );
-extern void xthal_icache_line_unlock(void *addr);
-extern void xthal_dcache_line_unlock(void *addr);
-
-
-/* sync icache and memory */
-extern void xthal_icache_sync( void );
-/* sync dcache and memory */
-extern void xthal_dcache_sync( void );
-
-/*----------------------------------------------------------------------
-   				Debug
-  ----------------------------------------------------------------------*/
-
-/*  1 if debug option configured, 0 if not:  */
-extern const int Xthal_debug_configured;
-
-/*  Number of instruction and data break registers:  */
-extern const int Xthal_num_ibreak;
-extern const int Xthal_num_dbreak;
-
-/*  Set (plant) and remove software breakpoint, both synchronizing cache:  */
-extern unsigned int xthal_set_soft_break(void *addr);
-extern void         xthal_remove_soft_break(void *addr, unsigned int);
-
-
-/*----------------------------------------------------------------------
-   				Disassembler
-  ----------------------------------------------------------------------*/
-
-/*  Max expected size of the return buffer for a disassembled instruction (hint only):  */
-#define XTHAL_DISASM_BUFSIZE	80
-
-/*  Disassembly option bits for selecting what to return:  */
-#define XTHAL_DISASM_OPT_ADDR	0x0001	/* display address */
-#define XTHAL_DISASM_OPT_OPHEX	0x0002	/* display opcode bytes in hex */
-#define XTHAL_DISASM_OPT_OPCODE	0x0004	/* display opcode name (mnemonic) */
-#define XTHAL_DISASM_OPT_PARMS	0x0008	/* display parameters */
-#define XTHAL_DISASM_OPT_ALL	0x0FFF	/* display everything */
-
-/* routine to get a string for the disassembled instruction */
-extern int xthal_disassemble( unsigned char *instr_buf, void *tgt_addr,
-		       char *buffer, unsigned buflen, unsigned options );
-
-/* routine to get the size of the next instruction. Returns 0 for
-   illegal instruction */
-extern int xthal_disassemble_size( unsigned char *instr_buf );
-
-
-/*----------------------------------------------------------------------
-   				Core Counter
-  ----------------------------------------------------------------------*/
-
-/* counter info */
-extern const unsigned char Xthal_have_ccount;	/* set if CCOUNT register present */
-extern const unsigned char Xthal_num_ccompare;	/* number of CCOMPAREn registers */
-
-/* get CCOUNT register (if not present return 0) */
-extern unsigned xthal_get_ccount(void);
-
-/* set and get CCOMPAREn registers (if not present, get returns 0) */
-extern void     xthal_set_ccompare(int, unsigned);
-extern unsigned xthal_get_ccompare(int);
-
-
-/*----------------------------------------------------------------------
-			Instruction/Data RAM/ROM Access
-  ----------------------------------------------------------------------*/
-
-extern void* xthal_memcpy(void *dst, const void *src, unsigned len);
-extern void* xthal_bcopy(const void *src, void *dst, unsigned len);
-
-/*----------------------------------------------------------------------
-                           MP Synchronization
-  ----------------------------------------------------------------------*/
-extern int      xthal_compare_and_set( int *addr, int test_val, int compare_val );
-extern unsigned xthal_get_prid( void );
-
-/*extern const char  Xthal_have_s32c1i;*/
-extern const unsigned char Xthal_have_prid;
-
-
-/*----------------------------------------------------------------------
-                             Miscellaneous
-  ----------------------------------------------------------------------*/
-
-extern const unsigned int  Xthal_release_major;
-extern const unsigned int  Xthal_release_minor;
-extern const char * const  Xthal_release_name;
-extern const char * const  Xthal_release_internal;
-
-extern const unsigned char Xthal_memory_order;
-extern const unsigned char Xthal_have_windowed;
-extern const unsigned char Xthal_have_density;
-extern const unsigned char Xthal_have_booleans;
-extern const unsigned char Xthal_have_loops;
-extern const unsigned char Xthal_have_nsa;
-extern const unsigned char Xthal_have_minmax;
-extern const unsigned char Xthal_have_sext;
-extern const unsigned char Xthal_have_clamps;
-extern const unsigned char Xthal_have_mac16;
-extern const unsigned char Xthal_have_mul16;
-extern const unsigned char Xthal_have_fp;
-extern const unsigned char Xthal_have_speculation;
-extern const unsigned char Xthal_have_exceptions;
-extern const unsigned char Xthal_xea_version;
-extern const unsigned char Xthal_have_interrupts;
-extern const unsigned char Xthal_have_highlevel_interrupts;
-extern const unsigned char Xthal_have_nmi;
-
-extern const unsigned short Xthal_num_writebuffer_entries;
-
-extern const unsigned int  Xthal_build_unique_id;
-/*  Release info for hardware targeted by software upgrades:  */
-extern const unsigned int  Xthal_hw_configid0;
-extern const unsigned int  Xthal_hw_configid1;
-extern const unsigned int  Xthal_hw_release_major;
-extern const unsigned int  Xthal_hw_release_minor;
-extern const char * const  Xthal_hw_release_name;
-extern const char * const  Xthal_hw_release_internal;
-
-
-/*  Internal memories...  */
-
-extern const unsigned char Xthal_num_instrom;
-extern const unsigned char Xthal_num_instram;
-extern const unsigned char Xthal_num_datarom;
-extern const unsigned char Xthal_num_dataram;
-extern const unsigned char Xthal_num_xlmi;
-extern const unsigned int  Xthal_instrom_vaddr[1];
-extern const unsigned int  Xthal_instrom_paddr[1];
-extern const unsigned int  Xthal_instrom_size [1];
-extern const unsigned int  Xthal_instram_vaddr[1];
-extern const unsigned int  Xthal_instram_paddr[1];
-extern const unsigned int  Xthal_instram_size [1];
-extern const unsigned int  Xthal_datarom_vaddr[1];
-extern const unsigned int  Xthal_datarom_paddr[1];
-extern const unsigned int  Xthal_datarom_size [1];
-extern const unsigned int  Xthal_dataram_vaddr[1];
-extern const unsigned int  Xthal_dataram_paddr[1];
-extern const unsigned int  Xthal_dataram_size [1];
-extern const unsigned int  Xthal_xlmi_vaddr[1];
-extern const unsigned int  Xthal_xlmi_paddr[1];
-extern const unsigned int  Xthal_xlmi_size [1];
-
-
-
-/*----------------------------------------------------------------------
-                         Memory Management Unit
-  ----------------------------------------------------------------------*/
-
-extern const unsigned char Xthal_have_spanning_way;
-extern const unsigned char Xthal_have_identity_map;
-extern const unsigned char Xthal_have_mimic_cacheattr;
-extern const unsigned char Xthal_have_xlt_cacheattr;
-extern const unsigned char Xthal_have_cacheattr;
-extern const unsigned char Xthal_have_tlbs;
-
-extern const unsigned char Xthal_mmu_asid_bits;		/* 0 .. 8 */
-extern const unsigned char Xthal_mmu_asid_kernel;
-extern const unsigned char Xthal_mmu_rings;		/* 1 .. 4 (perhaps 0 if no MMU and/or no protection?) */
-extern const unsigned char Xthal_mmu_ring_bits;
-extern const unsigned char Xthal_mmu_sr_bits;
-extern const unsigned char Xthal_mmu_ca_bits;
-extern const unsigned int  Xthal_mmu_max_pte_page_size;
-extern const unsigned int  Xthal_mmu_min_pte_page_size;
-
-extern const unsigned char Xthal_itlb_way_bits;
-extern const unsigned char Xthal_itlb_ways;
-extern const unsigned char Xthal_itlb_arf_ways;
-extern const unsigned char Xthal_dtlb_way_bits;
-extern const unsigned char Xthal_dtlb_ways;
-extern const unsigned char Xthal_dtlb_arf_ways;
-
-/*  Convert between virtual and physical addresses (through static maps only):  */
-/*** WARNING: these two functions may go away in a future release; don't depend on them! ***/
-extern int  xthal_static_v2p( unsigned vaddr, unsigned *paddrp );
-extern int  xthal_static_p2v( unsigned paddr, unsigned *vaddrp, unsigned cached );
-
-#if 0
-/*******************   EXPERIMENTAL AND TENTATIVE ONLY   ********************/
-
-#define XTHAL_MMU_PAGESZ_COUNT_MAX	8	/* maximum number of different page sizes */
-extern const char	Xthal_mmu_pagesz_count;		/* 0 .. 8		number of different page sizes configured */
-
-/*  Note:  the following table doesn't necessarily have page sizes in increasing order: */
-extern const char	Xthal_mmu_pagesz_log2[XTHAL_MMU_PAGESZ_COUNT_MAX];	/* 10 .. 28 (0 past count) */
-
-/*  Sorted (increasing) table of page sizes, that indexes into the above table: */
-extern const char	Xthal_mmu_pagesz_sorted[XTHAL_MMU_PAGESZ_COUNT_MAX];	/* 0 .. 7 (0 past count) */
-
-/*u32	Xthal_virtual_exceptions;*/	/* bitmask of which exceptions execute in virtual mode... */
-
-extern const char	Xthal_mmu_pte_pagesz_log2_min;	/* ?? minimum page size in PTEs */
-extern const char	Xthal_mmu_pte_pagesz_log2_max;	/* ?? maximum page size in PTEs */
-
-/*  Cache Attribute Bits Implemented by the Cache (part of the cache abstraction) */
-extern const char	Xthal_icache_fca_bits_implemented;	/* ITLB/UTLB only! */
-extern const char	Xthal_dcache_lca_bits_implemented;	/* DTLB/UTLB only! */
-extern const char	Xthal_dcache_sca_bits_implemented; 	/* DTLB/UTLB only! */
-
-/*  Per TLB Parameters (Instruction, Data, Unified)  */
-struct XtHalMmuTlb	Xthal_itlb;	/* description of MMU I-TLB generic features */
-struct XtHalMmuTlb	Xthal_dtlb;	/* description of MMU D-TLB generic features */
-struct XtHalMmuTlb	Xthal_utlb;	/* description of MMU U-TLB generic features */
-
-#define XTHAL_MMU_WAYS_MAX	8	/* maximum number of ways (associativities) for each TLB */
-
-/*  Structure for common information described for each possible TLB (instruction, data and unified): */
-typedef struct XtHalMmuTlb {
-    u8  	va_bits;		/* 32		(number of virtual address bits) */
-    u8  	pa_bits;		/* 32		(number of physical address bits) */
-    bool	tlb_va_indexed;		/* 1	(set if TLB is indexed by virtual address) */
-    bool	tlb_va_tagged;		/* 0	(set if TLB is tagged by virtual address) */
-    bool	cache_va_indexed;	/* 1	(set if cache is indexed by virtual address) */
-    bool	cache_va_tagged;	/* 0	(set if cache is tagged by virtual address) */
-    /*bool	(whether page tables are traversed in vaddr sorted order, paddr sorted order, ...) */
-    /*u8	(set of available page attribute bits, other than cache attribute bits defined above) */
-    /*u32	(various masks for pages, MMU table/TLB entries, etc.) */
-    u8  	way_count;		/* 0 .. 8	(number of ways, a.k.a. associativities, for this TLB) */
-    XtHalMmuTlbWay *	ways[XTHAL_MMU_WAYS_MAX];	/* pointers to per-way parms for each way */
-} XtHalMmuTlb;
-
-/*  Per TLB Way (Per Associativity) Parameters  */
-typedef struct XtHalMmuTlbWay {
-     u32	index_count_log2;	/* 0 .. 4 */
-     u32	pagesz_mask;		/* 0 .. 2^pagesz_count - 1	(each bit corresponds to a size */
-					/*		defined in the Xthal_mmu_pagesz_log2[] table) */
-     u32	vpn_const_mask;
-     u32	vpn_const_value;
-     u64	ppn_const_mask;		/* future may support pa_bits > 32 */
-     u64	ppn_const_value;
-     u32	ppn_id_mask;		/* paddr bits taken directly from vaddr */
-     bool	backgnd_match;		/* 0 or 1 */
-     /*  These are defined in terms of the XTHAL_CACHE_xxx bits: */
-     u8 	fca_const_mask;		/* ITLB/UTLB only! */
-     u8 	fca_const_value;	/* ITLB/UTLB only! */
-     u8 	lca_const_mask;		/* DTLB/UTLB only! */
-     u8 	lca_const_value; 	/* DTLB/UTLB only! */
-     u8 	sca_const_mask; 	/* DTLB/UTLB only! */
-     u8 	sca_const_value; 	/* DTLB/UTLB only! */
-     /*  These define an encoding that map 5 bits in TLB and PTE entries to */
-     /*  8 bits (FCA, ITLB), 16 bits (LCA+SCA, DTLB) or 24 bits (FCA+LCA+SCA, UTLB): */
-     /*  (they may be moved to struct XtHalMmuTlb) */
-     u8		ca_bits;		/* number of bits in TLB/PTE entries for cache attributes */
-     u32 *	ca_map;			/* pointer to array of 2^ca_bits entries of FCA+LCA+SCA bits */
-} XtHalMmuTlbWay;
-
-/*
- *  The way to determine whether protection support is present in core
- *  is to [look at Xthal_mmu_rings ???].
- *  Give info on memory requirements for MMU tables and other in-memory
- *  data structures (globally, per task, base and per page, etc.) - whatever bounds can be calculated.
- */
-
-
-/*  Default vectors:  */
-xthal_immu_fetch_miss_vector
-xthal_dmmu_load_miss_vector
-xthal_dmmu_store_miss_vector
-
-/*  Functions called when a fault is detected:  */
-typedef void (XtHalMmuFaultFunc)( unsigned vaddr, ...context... );
-/*  Or, */
-/*	a? = vaddr */
-/*	a? = context... */
-/*	PS.xxx = xxx */
-XtHalMMuFaultFunc *Xthal_immu_fetch_fault_func;
-XtHalMMuFaultFunc *Xthal_dmmu_load_fault_func;
-XtHalMMuFaultFunc *Xthal_dmmu_store_fault_func;
-
-/*  Default Handlers:  */
-/*  The user and/or kernel exception handlers may jump to these handlers to handle the relevant exceptions,
- *  according to the value of EXCCAUSE.  The exact register state on entry to these handlers is TBD.  */
-/*  When multiple TLB entries match (hit) on the same access:  */
-xthal_immu_fetch_multihit_handler
-xthal_dmmu_load_multihit_handler
-xthal_dmmu_store_multihit_handler
-/*  Protection violations according to cache attributes, and other cache attribute mismatches:  */
-xthal_immu_fetch_attr_handler
-xthal_dmmu_load_attr_handler
-xthal_dmmu_store_attr_handler
-/*  Protection violations due to insufficient ring level:  */
-xthal_immu_fetch_priv_handler
-xthal_dmmu_load_priv_handler
-xthal_dmmu_store_priv_handler
-/*  Alignment exception handlers (if supported by the particular Xtensa MMU configuration):  */
-xthal_dmmu_load_align_handler
-xthal_dmmu_store_align_handler
-
-/*  Or, alternatively, the OS user and/or kernel exception handlers may simply jump to the
- *  following entry points which will handle any values of EXCCAUSE not handled by the OS:  */
-xthal_user_exc_default_handler
-xthal_kernel_exc_default_handler
-
-#endif /*0*/
-
-#ifdef INCLUDE_DEPRECATED_HAL_CODE
-extern const unsigned char Xthal_have_old_exc_arch;
-extern const unsigned char Xthal_have_mmu;
-extern const unsigned int  Xthal_num_regs;
-extern const unsigned char Xthal_num_iroms;
-extern const unsigned char Xthal_num_irams;
-extern const unsigned char Xthal_num_droms;
-extern const unsigned char Xthal_num_drams;
-extern const unsigned int  Xthal_configid0;
-extern const unsigned int  Xthal_configid1;
-#endif
-
-#ifdef INCLUDE_DEPRECATED_HAL_DEBUG_CODE
-#define XTHAL_24_BIT_BREAK		0x80000000
-#define XTHAL_16_BIT_BREAK		0x40000000
-extern const unsigned short	Xthal_ill_inst_16[16];
-#define XTHAL_DEST_REG		0xf0000000	/* Mask for destination register */
-#define XTHAL_DEST_REG_INST	0x08000000	/* Branch address is in register */
-#define XTHAL_DEST_REL_INST	0x04000000	/* Branch address is relative */
-#define XTHAL_RFW_INST		0x00000800
-#define XTHAL_RFUE_INST		0x00000400
-#define XTHAL_RFI_INST		0x00000200
-#define XTHAL_RFE_INST		0x00000100
-#define XTHAL_RET_INST		0x00000080
-#define XTHAL_BREAK_INST	0x00000040
-#define XTHAL_SYSCALL_INST	0x00000020
-#define XTHAL_LOOP_END		0x00000010	/* Not set by xthal_inst_type */
-#define XTHAL_JUMP_INST		0x00000008	/* Call or jump instruction */
-#define XTHAL_BRANCH_INST	0x00000004	/* Branch instruction */
-#define XTHAL_24_BIT_INST	0x00000002
-#define XTHAL_16_BIT_INST   0x00000001
-typedef struct xthal_state {
-    unsigned	pc;
-    unsigned	ar[16];
-    unsigned	lbeg;
-    unsigned	lend;
-    unsigned	lcount;
-    unsigned	extra_ptr;
-    unsigned	cpregs_ptr[XTHAL_MAX_CPS];
-} XTHAL_STATE;
-extern unsigned int xthal_inst_type(void *addr);
-extern unsigned int xthal_branch_addr(void *addr);
-extern unsigned int xthal_get_npc(XTHAL_STATE *user_state);
-#endif /* INCLUDE_DEPRECATED_HAL_DEBUG_CODE */
-
-#ifdef __cplusplus
-}
-#endif
-#endif /*!__ASSEMBLY__ */
-
-#endif /*XTENSA_HAL_H*/
-
diff -puN include/asm-xtensa/xtensa/simcall.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/simcall.h
+++ /dev/null
@@ -1,130 +0,0 @@
-#ifndef SIMCALL_INCLUDED
-#define SIMCALL_INCLUDED
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * include/asm-xtensa/xtensa/simcall.h  -  Simulator call numbers
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License.  See the file "COPYING" in the main directory of
- * this archive for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-/*
- *  System call like services offered by the simulator host.
- *  These are modeled after the Linux 2.4 kernel system calls
- *  for Xtensa processors.  However not all system calls and
- *  not all functionality of a given system call are implemented,
- *  or necessarily have well defined or equivalent semantics in
- *  the context of a simulation (as opposed to a Unix kernel).
- *
- *  These services behave largely as if they had been invoked
- *  as a task in the simulator host's operating system
- *  (eg. files accessed are those of the simulator host).
- *  However, these SIMCALLs model a virtual operating system
- *  so that various definitions, bit assignments etc
- *  (eg. open mode bits, errno values, etc) are independent
- *  of the host operating system used to run the simulation.
- *  Rather these definitions are specific to the Xtensa ISS.
- *  This way Xtensa ISA code written to use these SIMCALLs
- *  can (in principle) be simulated on any host.
- *
- *  Up to 6 parameters are passed in registers a3 to a8
- *  (note the 6th parameter isn't passed on the stack,
- *   unlike windowed function calling conventions).
- *  The return value is in a2.  A negative value in the
- *  range -4096 to -1 indicates a negated error code to be
- *  reported in errno with a return value of -1, otherwise
- *  the value in a2 is returned as is.
- */
-
-/* These #defines need to match what's in Xtensa/OS/vxworks/xtiss/simcalls.c */
-
-#define SYS_nop		0	/* n/a - setup; used to flush register windows */
-#define SYS_exit	1	/*x*/
-#define SYS_fork	2
-#define SYS_read	3	/*x*/
-#define SYS_write	4	/*x*/
-#define SYS_open	5	/*x*/
-#define SYS_close	6	/*x*/
-#define SYS_rename	7	/*x 38 - waitpid */
-#define SYS_creat	8	/*x*/
-#define SYS_link	9	/*x (not implemented on WIN32) */
-#define SYS_unlink	10	/*x*/
-#define SYS_execv	11	/* n/a - execve */
-#define SYS_execve	12	/* 11 - chdir */
-#define SYS_pipe	13	/* 42 - time */
-#define SYS_stat	14	/* 106 - mknod */
-#define SYS_chmod	15
-#define SYS_chown	16	/* 202 - lchown */
-#define SYS_utime	17	/* 30 - break */
-#define SYS_wait	18	/* n/a - oldstat */
-#define SYS_lseek	19	/*x*/
-#define SYS_getpid	20
-#define SYS_isatty	21	/* n/a - mount */
-#define SYS_fstat	22	/* 108 - oldumount */
-#define SYS_time	23	/* 13 - setuid */
-#define SYS_gettimeofday 24	/*x 78 - getuid (not implemented on WIN32) */
-#define SYS_times	25	/*X 43 - stime (Xtensa-specific implementation) */
-#define SYS_socket      26
-#define SYS_sendto      27
-#define SYS_recvfrom    28
-#define SYS_select_one  29      /* not compitible select, one file descriptor at the time */
-#define SYS_bind        30
-#define SYS_ioctl	31
-
-/*
- *  Other...
- */
-#define SYS_iss_argc      1000	/* returns value of argc */
-#define SYS_iss_argv_size 1001	/* bytes needed for argv & arg strings */
-#define SYS_iss_set_argv  1002	/* saves argv & arg strings at given addr */
-
-/*
- * SIMCALLs for the ferret memory debugger. All are invoked by
- * libferret.a ...  ( Xtensa/Target-Libs/ferret )
- */
-#define SYS_ferret           1010
-#define SYS_malloc           1011
-#define SYS_free             1012
-#define SYS_more_heap        1013
-#define SYS_no_heap          1014
-
-
-/*
- *  Extra SIMCALLs for GDB:
- */
-#define SYS_gdb_break         -1	/* invoked by XTOS on user exceptions if EPC points
-					   to a break.n/break, regardless of cause! */
-#define SYS_xmon_out          -2	/* invoked by XMON: ... */
-#define SYS_xmon_in           -3	/* invoked by XMON: ... */
-#define SYS_xmon_flush        -4	/* invoked by XMON: ... */
-#define SYS_gdb_abort         -5	/* invoked by XTOS in _xtos_panic() */
-#define SYS_gdb_illegal_inst  -6	/* invoked by XTOS for illegal instructions (too deeply) */
-#define SYS_xmon_init         -7	/* invoked by XMON: ... */
-#define SYS_gdb_enter_sktloop -8	/* invoked by XTOS on debug exceptions */
-
-/*
- *  SIMCALLs for vxWorks xtiss BSP:
- */
-#define SYS_setup_ppp_pipes   -83
-#define SYS_log_msg           -84
-
-/*
- *  Test SIMCALLs:
- */
-#define SYS_test_write_state  -100
-#define SYS_test_read_state   -101
-
-/*
- * SYS_select_one specifiers
- */
-#define  XTISS_SELECT_ONE_READ    1
-#define  XTISS_SELECT_ONE_WRITE   2
-#define  XTISS_SELECT_ONE_EXCEPT  3
-
-#endif /* !SIMCALL_INCLUDED */
diff -puN include/asm-xtensa/xtensa/xt2000-uart.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/xt2000-uart.h
+++ /dev/null
@@ -1,155 +0,0 @@
-#ifndef _uart_h_included_
-#define _uart_h_included_
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * include/asm-xtensa/xtensa/xt2000-uart.h -- NatSemi PC16552D DUART
- * definitions
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-#include <xtensa/xt2000.h>
-
-
-/* 16550 UART DEVICE REGISTERS
-   The XT2000 board aligns each register to a 32-bit word but the UART device only uses
-   one byte of the word, which is the least-significant byte regardless of the
-   endianness of the core (ie. byte offset 0 for little-endian and 3 for big-endian).
-   So if using word accesses then endianness doesn't matter.
-   The macros provided here do that.
-*/
-struct uart_dev_s {
-  union {
-    unsigned int rxb;	/* DLAB=0: receive buffer, read-only */
-    unsigned int txb;	/* DLAB=0: transmit buffer, write-only */
-    unsigned int dll;	/* DLAB=1: divisor, least-significant byte latch (was write-only?) */
-  } w0;
-  union {
-    unsigned int ier;	/* DLAB=0: interrupt-enable register (was write-only?) */
-    unsigned int dlm;	/* DLAB=1: divisor, most-significant byte latch (was write-only?) */
-  } w1;
-
-  union {
-    unsigned int isr;	/* DLAB=0: interrupt status register, read-only */
-    unsigned int fcr;	/* DLAB=0: FIFO control register, write-only */
-    unsigned int afr;	/* DLAB=1: alternate function register */
-  } w2;
-
-  unsigned int lcr;	/* line control-register, write-only */
-  unsigned int mcr;	/* modem control-regsiter, write-only */
-  unsigned int lsr;	/* line status register, read-only */
-  unsigned int msr;	/* modem status register, read-only */
-  unsigned int scr;	/* scratch regsiter, read/write */
-};
-
-#define _RXB(u) ((u)->w0.rxb)
-#define _TXB(u) ((u)->w0.txb)
-#define _DLL(u) ((u)->w0.dll)
-#define _IER(u) ((u)->w1.ier)
-#define _DLM(u) ((u)->w1.dlm)
-#define _ISR(u) ((u)->w2.isr)
-#define _FCR(u) ((u)->w2.fcr)
-#define _AFR(u) ((u)->w2.afr)
-#define _LCR(u) ((u)->lcr)
-#define _MCR(u) ((u)->mcr)
-#define _LSR(u) ((u)->lsr)
-#define _MSR(u) ((u)->msr)
-#define _SCR(u) ((u)->scr)
-
-typedef volatile struct uart_dev_s uart_dev_t;
-
-/* IER bits */
-#define RCVR_DATA_REG_INTENABLE 0x01
-#define XMIT_HOLD_REG_INTENABLE    0x02
-#define RCVR_STATUS_INTENABLE   0x04
-#define MODEM_STATUS_INTENABLE     0x08
-
-/* FCR bits */
-#define _FIFO_ENABLE      0x01
-#define RCVR_FIFO_RESET  0x02
-#define XMIT_FIFO_RESET  0x04
-#define DMA_MODE_SELECT  0x08
-#define RCVR_TRIGGER_LSB 0x40
-#define RCVR_TRIGGER_MSB 0x80
-
-/* AFR bits */
-#define AFR_CONC_WRITE	0x01
-#define AFR_BAUDOUT_SEL	0x02
-#define AFR_RXRDY_SEL	0x04
-
-/* ISR bits */
-#define INT_STATUS(r)   ((r)&1)
-#define INT_PRIORITY(r) (((r)>>1)&0x7)
-
-/* LCR bits */
-#define WORD_LENGTH(n)  (((n)-5)&0x3)
-#define STOP_BIT_ENABLE 0x04
-#define PARITY_ENABLE   0x08
-#define EVEN_PARITY     0x10
-#define FORCE_PARITY    0x20
-#define XMIT_BREAK      0x40
-#define DLAB_ENABLE     0x80
-
-/* MCR bits */
-#define _DTR 0x01
-#define _RTS 0x02
-#define _OP1 0x04
-#define _OP2 0x08
-#define LOOP_BACK 0x10
-
-/* LSR Bits */
-#define RCVR_DATA_READY 0x01
-#define OVERRUN_ERROR   0x02
-#define PARITY_ERROR    0x04
-#define FRAMING_ERROR   0x08
-#define BREAK_INTERRUPT 0x10
-#define XMIT_HOLD_EMPTY 0x20
-#define XMIT_EMPTY      0x40
-#define FIFO_ERROR      0x80
-#define RCVR_READY(u)   (_LSR(u)&RCVR_DATA_READY)
-#define XMIT_READY(u)   (_LSR(u)&XMIT_HOLD_EMPTY)
-
-/* MSR bits */
-#define _RDR       0x01
-#define DELTA_DSR 0x02
-#define DELTA_RI  0x04
-#define DELTA_CD  0x08
-#define _CTS       0x10
-#define _DSR       0x20
-#define _RI        0x40
-#define _CD        0x80
-
-/* prototypes */
-void uart_init( uart_dev_t *u, int bitrate );
-void uart_out( uart_dev_t *u, char c );
-void uart_puts( uart_dev_t *u, char *s );
-char uart_in( uart_dev_t *u );
-void uart_enable_rcvr_int( uart_dev_t *u );
-void uart_disable_rcvr_int( uart_dev_t *u );
-
-#ifdef DUART16552_1_VADDR
-/*  DUART present.  */
-#define DUART_1_BASE	(*(uart_dev_t*)DUART16552_1_VADDR)
-#define DUART_2_BASE	(*(uart_dev_t*)DUART16552_2_VADDR)
-#define UART1_PUTS(s)	uart_puts( &DUART_1_BASE, s )
-#define UART2_PUTS(s)	uart_puts( &DUART_2_BASE, s )
-#else
-/*  DUART not configured, use dummy placeholders to allow compiles to work.  */
-#define DUART_1_BASE	(*(uart_dev_t*)0)
-#define DUART_2_BASE	(*(uart_dev_t*)0)
-#define UART1_PUTS(s)
-#define UART2_PUTS(s)
-#endif
-
-/*  Compute 16-bit divisor for baudrate generator, with rounding:  */
-#define DUART_DIVISOR(crystal,speed)	(((crystal)/16 + (speed)/2)/(speed))
-
-#endif /*_uart_h_included_*/
-
diff -puN include/asm-xtensa/xtensa/xt2000.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/xt2000.h
+++ /dev/null
@@ -1,408 +0,0 @@
-#ifndef _INC_XT2000_H_
-#define _INC_XT2000_H_
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- * include/asm-xtensa/xtensa/xt2000.h - Definitions specific to the
- * Tensilica XT2000 Emulation Board
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-#include <xtensa/config/core.h>
-#include <xtensa/config/system.h>
-
-
-/*
- *  Default assignment of XT2000 devices to external interrupts.
- */
-
-/*  Ethernet interrupt:  */
-#ifdef XCHAL_EXTINT3_NUM
-#define SONIC83934_INTNUM	XCHAL_EXTINT3_NUM
-#define SONIC83934_INTLEVEL	XCHAL_EXTINT3_LEVEL
-#define SONIC83934_INTMASK	XCHAL_EXTINT3_MASK
-#else
-#define SONIC83934_INTMASK	0
-#endif
-
-/*  DUART channel 1 interrupt (P1 - console):  */
-#ifdef XCHAL_EXTINT4_NUM
-#define DUART16552_1_INTNUM	XCHAL_EXTINT4_NUM
-#define DUART16552_1_INTLEVEL	XCHAL_EXTINT4_LEVEL
-#define DUART16552_1_INTMASK	XCHAL_EXTINT4_MASK
-#else
-#define DUART16552_1_INTMASK	0
-#endif
-
-/*  DUART channel 2 interrupt (P2 - 2nd serial port):  */
-#ifdef XCHAL_EXTINT5_NUM
-#define DUART16552_2_INTNUM	XCHAL_EXTINT5_NUM
-#define DUART16552_2_INTLEVEL	XCHAL_EXTINT5_LEVEL
-#define DUART16552_2_INTMASK	XCHAL_EXTINT5_MASK
-#else
-#define DUART16552_2_INTMASK	0
-#endif
-
-/*  FPGA-combined PCI/etc interrupts:  */
-#ifdef XCHAL_EXTINT6_NUM
-#define XT2000_FPGAPCI_INTNUM	XCHAL_EXTINT6_NUM
-#define XT2000_FPGAPCI_INTLEVEL	XCHAL_EXTINT6_LEVEL
-#define XT2000_FPGAPCI_INTMASK	XCHAL_EXTINT6_MASK
-#else
-#define XT2000_FPGAPCI_INTMASK	0
-#endif
-
-
-
-/*
- *  Device addresses.
- *
- *  Note:  for endianness-independence, use 32-bit loads and stores for all
- *  register accesses to Ethernet, DUART and LED devices.  Undefined bits
- *  may need to be masked out if needed when reading if the actual register
- *  size is smaller than 32 bits.
- *
- *  Note:  XT2000 bus byte lanes are defined in terms of msbyte and lsbyte
- *  relative to the processor.  So 32-bit registers are accessed consistently
- *  from both big and little endian processors.  However, this means byte
- *  sequences are not consistent between big and little endian processors.
- *  This is fine for RAM, and for ROM if ROM is created for a specific
- *  processor (and thus has correct byte sequences).  However this may be
- *  unexpected for Flash, which might contain a file-system that one wants
- *  to use for multiple processor configurations (eg. the Flash might contain
- *  the Ethernet card's address, endianness-independent application data, etc).
- *  That is, byte sequences written in Flash by a core of a given endianness
- *  will be byte-swapped when seen by a core of the other endianness.
- *  Someone implementing an endianness-independent Flash file system will
- *  likely handle this byte-swapping issue in the Flash driver software.
- */
-
-#define DUART16552_XTAL_FREQ	18432000	/* crystal frequency in Hz */
-#define XTBOARD_FLASH_MAXSIZE	0x4000000	/* 64 MB (max; depends on what is socketed!) */
-#define XTBOARD_EPROM_MAXSIZE	0x0400000	/* 4 MB (max; depends on what is socketed!) */
-#define XTBOARD_EEPROM_MAXSIZE	0x0080000	/* 512 kB (max; depends on what is socketed!) */
-#define XTBOARD_ASRAM_SIZE	0x0100000	/* 1 MB */
-#define XTBOARD_PCI_MEM_SIZE	0x8000000	/* 128 MB (allocated) */
-#define XTBOARD_PCI_IO_SIZE	0x1000000	/* 16 MB (allocated) */
-
-#ifdef XSHAL_IOBLOCK_BYPASS_PADDR
-/*  PCI memory space:  */
-# define XTBOARD_PCI_MEM_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0x0000000)
-/*  Socketed Flash (eg. 2 x 16-bit devices):  */
-# define XTBOARD_FLASH_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0x8000000)
-/*  PCI I/O space:  */
-# define XTBOARD_PCI_IO_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xC000000)
-/*  V3 PCI interface chip register/config space:  */
-# define XTBOARD_V3PCI_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD000000)
-/*  Bus Interface registers:  */
-# define XTBOARD_BUSINT_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD010000)
-/*  FPGA registers:  */
-# define XT2000_FPGAREGS_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD020000)
-/*  SONIC SN83934 Ethernet controller/transceiver:  */
-# define SONIC83934_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD030000)
-/*  8-character bitmapped LED display:  */
-# define XTBOARD_LED_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD040000)
-/*  National-Semi PC16552D DUART:  */
-# define DUART16552_1_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD050020)	/* channel 1 (P1 - console) */
-# define DUART16552_2_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD050000)	/* channel 2 (P2) */
-/*  Asynchronous Static RAM:  */
-# define XTBOARD_ASRAM_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD400000)
-/*  8-bit EEPROM:  */
-# define XTBOARD_EEPROM_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD600000)
-/*  2 x 16-bit EPROMs:  */
-# define XTBOARD_EPROM_PADDR	(XSHAL_IOBLOCK_BYPASS_PADDR+0xD800000)
-#endif /* XSHAL_IOBLOCK_BYPASS_PADDR */
-
-/*  These devices might be accessed cached:  */
-#ifdef XSHAL_IOBLOCK_CACHED_PADDR
-# define XTBOARD_PCI_MEM_CACHED_PADDR	(XSHAL_IOBLOCK_CACHED_PADDR+0x0000000)
-# define XTBOARD_FLASH_CACHED_PADDR	(XSHAL_IOBLOCK_CACHED_PADDR+0x8000000)
-# define XTBOARD_ASRAM_CACHED_PADDR	(XSHAL_IOBLOCK_CACHED_PADDR+0xD400000)
-# define XTBOARD_EEPROM_CACHED_PADDR	(XSHAL_IOBLOCK_CACHED_PADDR+0xD600000)
-# define XTBOARD_EPROM_CACHED_PADDR	(XSHAL_IOBLOCK_CACHED_PADDR+0xD800000)
-#endif /* XSHAL_IOBLOCK_CACHED_PADDR */
-
-
-/***  Same thing over again, this time with virtual addresses:  ***/
-
-#ifdef XSHAL_IOBLOCK_BYPASS_VADDR
-/*  PCI memory space:  */
-# define XTBOARD_PCI_MEM_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0x0000000)
-/*  Socketed Flash (eg. 2 x 16-bit devices):  */
-# define XTBOARD_FLASH_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0x8000000)
-/*  PCI I/O space:  */
-# define XTBOARD_PCI_IO_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xC000000)
-/*  V3 PCI interface chip register/config space:  */
-# define XTBOARD_V3PCI_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD000000)
-/*  Bus Interface registers:  */
-# define XTBOARD_BUSINT_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD010000)
-/*  FPGA registers:  */
-# define XT2000_FPGAREGS_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD020000)
-/*  SONIC SN83934 Ethernet controller/transceiver:  */
-# define SONIC83934_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD030000)
-/*  8-character bitmapped LED display:  */
-# define XTBOARD_LED_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD040000)
-/*  National-Semi PC16552D DUART:  */
-# define DUART16552_1_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD050020)	/* channel 1 (P1 - console) */
-# define DUART16552_2_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD050000)	/* channel 2 (P2) */
-/*  Asynchronous Static RAM:  */
-# define XTBOARD_ASRAM_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD400000)
-/*  8-bit EEPROM:  */
-# define XTBOARD_EEPROM_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD600000)
-/*  2 x 16-bit EPROMs:  */
-# define XTBOARD_EPROM_VADDR	(XSHAL_IOBLOCK_BYPASS_VADDR+0xD800000)
-#endif /* XSHAL_IOBLOCK_BYPASS_VADDR */
-
-/*  These devices might be accessed cached:  */
-#ifdef XSHAL_IOBLOCK_CACHED_VADDR
-# define XTBOARD_PCI_MEM_CACHED_VADDR	(XSHAL_IOBLOCK_CACHED_VADDR+0x0000000)
-# define XTBOARD_FLASH_CACHED_VADDR	(XSHAL_IOBLOCK_CACHED_VADDR+0x8000000)
-# define XTBOARD_ASRAM_CACHED_VADDR	(XSHAL_IOBLOCK_CACHED_VADDR+0xD400000)
-# define XTBOARD_EEPROM_CACHED_VADDR	(XSHAL_IOBLOCK_CACHED_VADDR+0xD600000)
-# define XTBOARD_EPROM_CACHED_VADDR	(XSHAL_IOBLOCK_CACHED_VADDR+0xD800000)
-#endif /* XSHAL_IOBLOCK_CACHED_VADDR */
-
-
-/*  System ROM:  */
-#define XTBOARD_ROM_SIZE		XSHAL_ROM_SIZE
-#ifdef XSHAL_ROM_VADDR
-#define XTBOARD_ROM_VADDR		XSHAL_ROM_VADDR
-#endif
-#ifdef XSHAL_ROM_PADDR
-#define XTBOARD_ROM_PADDR		XSHAL_ROM_PADDR
-#endif
-
-/*  System RAM:  */
-#define XTBOARD_RAM_SIZE		XSHAL_RAM_SIZE
-#ifdef XSHAL_RAM_VADDR
-#define XTBOARD_RAM_VADDR		XSHAL_RAM_VADDR
-#endif
-#ifdef XSHAL_RAM_PADDR
-#define XTBOARD_RAM_PADDR		XSHAL_RAM_PADDR
-#endif
-#define XTBOARD_RAM_BYPASS_VADDR	XSHAL_RAM_BYPASS_VADDR
-#define XTBOARD_RAM_BYPASS_PADDR	XSHAL_RAM_BYPASS_PADDR
-
-
-
-/*
- *  Things that depend on device addresses.
- */
-
-
-#define XTBOARD_CACHEATTR_WRITEBACK	XSHAL_XT2000_CACHEATTR_WRITEBACK
-#define XTBOARD_CACHEATTR_WRITEALLOC	XSHAL_XT2000_CACHEATTR_WRITEALLOC
-#define XTBOARD_CACHEATTR_WRITETHRU	XSHAL_XT2000_CACHEATTR_WRITETHRU
-#define XTBOARD_CACHEATTR_BYPASS	XSHAL_XT2000_CACHEATTR_BYPASS
-#define XTBOARD_CACHEATTR_DEFAULT	XSHAL_XT2000_CACHEATTR_DEFAULT
-
-#define XTBOARD_BUSINT_PIPE_REGIONS	XSHAL_XT2000_PIPE_REGIONS
-#define XTBOARD_BUSINT_SDRAM_REGIONS	XSHAL_XT2000_SDRAM_REGIONS
-
-
-
-/*
- *  BusLogic (FPGA) registers.
- *  All these registers are normally accessed using 32-bit loads/stores.
- */
-
-/*  Register offsets:  */
-#define XT2000_DATECD_OFS	0x00	/* date code (read-only) */
-#define XT2000_STSREG_OFS	0x04	/* status (read-only) */
-#define XT2000_SYSLED_OFS	0x08	/* system LED */
-#define XT2000_WRPROT_OFS	0x0C	/* write protect */
-#define XT2000_SWRST_OFS	0x10	/* software reset */
-#define XT2000_SYSRST_OFS	0x14	/* system (peripherals) reset */
-#define XT2000_IMASK_OFS	0x18	/* interrupt mask */
-#define XT2000_ISTAT_OFS	0x1C	/* interrupt status */
-#define XT2000_V3CFG_OFS	0x20	/* V3 config (V320 PCI) */
-
-/*  Physical register addresses:  */
-#ifdef XT2000_FPGAREGS_PADDR
-#define XT2000_DATECD_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_DATECD_OFS)
-#define XT2000_STSREG_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_STSREG_OFS)
-#define XT2000_SYSLED_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_SYSLED_OFS)
-#define XT2000_WRPROT_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_WRPROT_OFS)
-#define XT2000_SWRST_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_SWRST_OFS)
-#define XT2000_SYSRST_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_SYSRST_OFS)
-#define XT2000_IMASK_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_IMASK_OFS)
-#define XT2000_ISTAT_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_ISTAT_OFS)
-#define XT2000_V3CFG_PADDR	(XT2000_FPGAREGS_PADDR+XT2000_V3CFG_OFS)
-#endif
-
-/*  Virtual register addresses:  */
-#ifdef XT2000_FPGAREGS_VADDR
-#define XT2000_DATECD_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_DATECD_OFS)
-#define XT2000_STSREG_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_STSREG_OFS)
-#define XT2000_SYSLED_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_SYSLED_OFS)
-#define XT2000_WRPROT_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_WRPROT_OFS)
-#define XT2000_SWRST_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_SWRST_OFS)
-#define XT2000_SYSRST_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_SYSRST_OFS)
-#define XT2000_IMASK_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_IMASK_OFS)
-#define XT2000_ISTAT_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_ISTAT_OFS)
-#define XT2000_V3CFG_VADDR	(XT2000_FPGAREGS_VADDR+XT2000_V3CFG_OFS)
-/*  Register access (for C code):  */
-#define XT2000_DATECD_REG	(*(volatile unsigned*) XT2000_DATECD_VADDR)
-#define XT2000_STSREG_REG	(*(volatile unsigned*) XT2000_STSREG_VADDR)
-#define XT2000_SYSLED_REG	(*(volatile unsigned*) XT2000_SYSLED_VADDR)
-#define XT2000_WRPROT_REG	(*(volatile unsigned*) XT2000_WRPROT_VADDR)
-#define XT2000_SWRST_REG	(*(volatile unsigned*) XT2000_SWRST_VADDR)
-#define XT2000_SYSRST_REG	(*(volatile unsigned*) XT2000_SYSRST_VADDR)
-#define XT2000_IMASK_REG	(*(volatile unsigned*) XT2000_IMASK_VADDR)
-#define XT2000_ISTAT_REG	(*(volatile unsigned*) XT2000_ISTAT_VADDR)
-#define XT2000_V3CFG_REG	(*(volatile unsigned*) XT2000_V3CFG_VADDR)
-#endif
-
-/*  DATECD (date code) bit fields:  */
-
-/*  BCD-coded month (01..12):  */
-#define XT2000_DATECD_MONTH_SHIFT	24
-#define XT2000_DATECD_MONTH_BITS	8
-#define XT2000_DATECD_MONTH_MASK	0xFF000000
-/*  BCD-coded day (01..31):  */
-#define XT2000_DATECD_DAY_SHIFT		16
-#define XT2000_DATECD_DAY_BITS		8
-#define XT2000_DATECD_DAY_MASK		0x00FF0000
-/*  BCD-coded year (2001..9999):  */
-#define XT2000_DATECD_YEAR_SHIFT	0
-#define XT2000_DATECD_YEAR_BITS		16
-#define XT2000_DATECD_YEAR_MASK		0x0000FFFF
-
-/*  STSREG (status) bit fields:  */
-
-/*  Switch SW3 setting bit fields (0=off/up, 1=on/down):  */
-#define XT2000_STSREG_SW3_SHIFT		0
-#define XT2000_STSREG_SW3_BITS		4
-#define XT2000_STSREG_SW3_MASK		0x0000000F
-/*  Boot-select bits of switch SW3:  */
-#define XT2000_STSREG_BOOTSEL_SHIFT	0
-#define XT2000_STSREG_BOOTSEL_BITS	2
-#define XT2000_STSREG_BOOTSEL_MASK	0x00000003
-/*  Boot-select values:  */
-#define XT2000_STSREG_BOOTSEL_FLASH	0
-#define XT2000_STSREG_BOOTSEL_EPROM16	1
-#define XT2000_STSREG_BOOTSEL_PROM8	2
-#define XT2000_STSREG_BOOTSEL_ASRAM	3
-/*  User-defined bits of switch SW3:  */
-#define XT2000_STSREG_SW3_2_SHIFT	2
-#define XT2000_STSREG_SW3_2_MASK	0x00000004
-#define XT2000_STSREG_SW3_3_SHIFT	3
-#define XT2000_STSREG_SW3_3_MASK	0x00000008
-
-/*  SYSLED (system LED) bit fields:  */
-
-/*  LED control bit (0=off, 1=on):  */
-#define XT2000_SYSLED_LEDON_SHIFT	0
-#define XT2000_SYSLED_LEDON_MASK	0x00000001
-
-/*  WRPROT (write protect) bit fields (0=writable, 1=write-protected [default]):  */
-
-/*  Flash write protect:  */
-#define XT2000_WRPROT_FLWP_SHIFT	0
-#define XT2000_WRPROT_FLWP_MASK		0x00000001
-/*  Reserved but present write protect bits:  */
-#define XT2000_WRPROT_WRP_SHIFT		1
-#define XT2000_WRPROT_WRP_BITS		7
-#define XT2000_WRPROT_WRP_MASK		0x000000FE
-
-/*  SWRST (software reset; allows s/w to generate power-on equivalent reset):  */
-
-/*  Software reset bits:  */
-#define XT2000_SWRST_SWR_SHIFT		0
-#define XT2000_SWRST_SWR_BITS		16
-#define XT2000_SWRST_SWR_MASK		0x0000FFFF
-/*  Software reset value -- writing this value resets the board:  */
-#define XT2000_SWRST_RESETVALUE		0x0000DEAD
-
-/*  SYSRST (system reset; controls reset of individual peripherals):  */
-
-/*  All-device reset:  */
-#define XT2000_SYSRST_ALL_SHIFT		0
-#define XT2000_SYSRST_ALL_BITS		4
-#define XT2000_SYSRST_ALL_MASK		0x0000000F
-/*  HDSP-2534 LED display reset (1=reset, 0=nothing):  */
-#define XT2000_SYSRST_LED_SHIFT		0
-#define XT2000_SYSRST_LED_MASK		0x00000001
-/*  Sonic DP83934 Ethernet controller reset (1=reset, 0=nothing):  */
-#define XT2000_SYSRST_SONIC_SHIFT	1
-#define XT2000_SYSRST_SONIC_MASK	0x00000002
-/*  DP16552 DUART reset (1=reset, 0=nothing):  */
-#define XT2000_SYSRST_DUART_SHIFT	2
-#define XT2000_SYSRST_DUART_MASK	0x00000004
-/*  V3 V320 PCI bridge controller reset (1=reset, 0=nothing):  */
-#define XT2000_SYSRST_V3_SHIFT		3
-#define XT2000_SYSRST_V3_MASK		0x00000008
-
-/*  IMASK (interrupt mask; 0=disable, 1=enable):  */
-/*  ISTAT (interrupt status; 0=inactive, 1=pending):  */
-
-/*  PCI INTP interrupt:  */
-#define XT2000_INTMUX_PCI_INTP_SHIFT	2
-#define XT2000_INTMUX_PCI_INTP_MASK	0x00000004
-/*  PCI INTS interrupt:  */
-#define XT2000_INTMUX_PCI_INTS_SHIFT	3
-#define XT2000_INTMUX_PCI_INTS_MASK	0x00000008
-/*  PCI INTD interrupt:  */
-#define XT2000_INTMUX_PCI_INTD_SHIFT	4
-#define XT2000_INTMUX_PCI_INTD_MASK	0x00000010
-/*  V320 PCI controller interrupt:  */
-#define XT2000_INTMUX_V3_SHIFT		5
-#define XT2000_INTMUX_V3_MASK		0x00000020
-/*  PCI ENUM interrupt:  */
-#define XT2000_INTMUX_PCI_ENUM_SHIFT	6
-#define XT2000_INTMUX_PCI_ENUM_MASK	0x00000040
-/*  PCI DEG interrupt:  */
-#define XT2000_INTMUX_PCI_DEG_SHIFT	7
-#define XT2000_INTMUX_PCI_DEG_MASK	0x00000080
-
-/*  V3CFG (V3 config, V320 PCI controller):  */
-
-/*  V3 address control (0=pass-thru, 1=V3 address bits 31:28 set to 4'b0001 [default]):  */
-#define XT2000_V3CFG_V3ADC_SHIFT	0
-#define XT2000_V3CFG_V3ADC_MASK		0x00000001
-
-/* I2C Devices */
-
-#define	XT2000_I2C_RTC_ID		0x68
-#define	XT2000_I2C_NVRAM0_ID		0x56	/* 1st 256 byte block */
-#define	XT2000_I2C_NVRAM1_ID		0x57	/* 2nd 256 byte block */
-
-/*  NVRAM Board Info structure:  */
-
-#define XT2000_NVRAM_SIZE		512
-
-#define XT2000_NVRAM_BINFO_START	0x100
-#define XT2000_NVRAM_BINFO_SIZE		0x20
-#define XT2000_NVRAM_BINFO_VERSION	0x10	/* version 1.0 */
-#if 0
-#define XT2000_NVRAM_BINFO_VERSION_OFFSET	0x00
-#define XT2000_NVRAM_BINFO_VERSION_SIZE			0x1
-#define XT2000_NVRAM_BINFO_ETH_ADDR_OFFSET	0x02
-#define XT2000_NVRAM_BINFO_ETH_ADDR_SIZE		0x6
-#define XT2000_NVRAM_BINFO_SN_OFFSET		0x10
-#define XT2000_NVRAM_BINFO_SN_SIZE			0xE
-#define	XT2000_NVRAM_BINFO_CRC_OFFSET		0x1E
-#define	XT2000_NVRAM_BINFO_CRC_SIZE			0x2
-#endif /*0*/
-
-#if !defined(__ASSEMBLY__) && !defined(_NOCLANGUAGE)
-typedef struct xt2000_nvram_binfo {
-    unsigned char	version;
-    unsigned char	reserved1;
-    unsigned char	eth_addr[6];
-    unsigned char	reserved8[8];
-    unsigned char	serialno[14];
-    unsigned char	crc[2];		/* 16-bit CRC */
-} xt2000_nvram_binfo;
-#endif /*!__ASSEMBLY__ && !_NOCLANGUAGE*/
-
-
-#endif /*_INC_XT2000_H_*/
-
diff -puN include/asm-xtensa/xtensa/xtboard.h~xtensa-remove-extra-header-files /dev/null
--- a/include/asm-xtensa/xtensa/xtboard.h
+++ /dev/null
@@ -1,120 +0,0 @@
-#ifndef _xtboard_h_included_
-#define _xtboard_h_included_
-
-/*
- * THIS FILE IS GENERATED -- DO NOT MODIFY BY HAND
- *
- *  xtboard.h  --  Routines for getting useful information from the board.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002 Tensilica Inc.
- */
-
-
-#include <xtensa/xt2000.h>
-
-#define	XTBOARD_RTC_ERROR	-1
-#define	XTBOARD_RTC_STOPPED	-2
-
-
-/*  xt2000-i2cdev.c:  */
-typedef void XtboardDelayFunc( unsigned );
-extern XtboardDelayFunc* xtboard_set_nsdelay_func( XtboardDelayFunc *delay_fn );
-extern int xtboard_i2c_read (unsigned id, unsigned char *buf, unsigned addr, unsigned size);
-extern int xtboard_i2c_write(unsigned id, unsigned char *buf, unsigned addr, unsigned size);
-extern int xtboard_i2c_wait_nvram_ack(unsigned id, unsigned swtimer);
-
-/*  xtboard.c:  */
-extern int xtboard_nvram_read (unsigned addr, unsigned len, unsigned char *buf);
-extern int xtboard_nvram_write(unsigned addr, unsigned len, unsigned char *buf);
-extern int xtboard_nvram_binfo_read (xt2000_nvram_binfo *buf);
-extern int xtboard_nvram_binfo_write(xt2000_nvram_binfo *buf);
-extern int xtboard_nvram_binfo_valid(xt2000_nvram_binfo *buf);
-extern int xtboard_ethermac_get(unsigned char *buf);
-extern int xtboard_ethermac_set(unsigned char *buf);
-
-/*+*----------------------------------------------------------------------------
-/ Function: xtboard_get_rtc_time
-/
-/ Description:  Get time stored in real-time clock.
-/
-/ Returns: time in seconds stored in real-time clock.
-/-**----------------------------------------------------------------------------*/
-
-extern unsigned xtboard_get_rtc_time(void);
-
-/*+*----------------------------------------------------------------------------
-/ Function: xtboard_set_rtc_time
-/
-/ Description:  Set time stored in real-time clock.
-/
-/ Parameters: 	time -- time in seconds to store to real-time clock
-/
-/ Returns: 0 on success, xtboard_i2c_write() error code otherwise.
-/-**----------------------------------------------------------------------------*/
-
-extern int xtboard_set_rtc_time(unsigned time);
-
-
-/*  xtfreq.c:  */
-/*+*----------------------------------------------------------------------------
-/ Function: xtboard_measure_sys_clk
-/
-/ Description:  Get frequency of system clock.
-/
-/ Parameters:	none
-/
-/ Returns: frequency of system clock.
-/-**----------------------------------------------------------------------------*/
-
-extern unsigned xtboard_measure_sys_clk(void);
-
-
-#if 0	/* old stuff from xtboard.c: */
-
-/*+*----------------------------------------------------------------------------
-/ Function: xtboard_nvram valid
-/
-/ Description:  Determines if data in NVRAM is valid.
-/
-/ Parameters:	delay -- 10us delay function
-/
-/ Returns: 1 if NVRAM is valid, 0 otherwise
-/-**----------------------------------------------------------------------------*/
-
-extern unsigned xtboard_nvram_valid(void (*delay)( void ));
-
-/*+*----------------------------------------------------------------------------
-/ Function: xtboard_get_nvram_contents
-/
-/ Description:  Returns contents of NVRAM.
-/
-/ Parameters: 	buf -- buffer to NVRAM contents.
-/		delay -- 10us delay function
-/
-/ Returns: 1 if NVRAM is valid, 0 otherwise
-/-**----------------------------------------------------------------------------*/
-
-extern unsigned xtboard_get_nvram_contents(unsigned char *buf, void (*delay)( void ));
-
-/*+*----------------------------------------------------------------------------
-/ Function: xtboard_get_ether_addr
-/
-/ Description:  Returns ethernet address of board.
-/
-/ Parameters: 	buf -- buffer to store ethernet address
-/		delay -- 10us delay function
-/
-/ Returns: nothing.
-/-**----------------------------------------------------------------------------*/
-
-extern void xtboard_get_ether_addr(unsigned char *buf, void (*delay)( void ));
-
-#endif /*0*/
-
-
-#endif /*_xtboard_h_included_*/
-
_

Patches currently in -mm which might be from czankel@tensilica.com are

origin.patch
xtensa-add-ktermios-and-minor-filename-fix.patch

