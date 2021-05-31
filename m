Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4BDC47082
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBBB61287
	for <mm-commits@archiver.kernel.org>; Mon, 31 May 2021 23:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaXOt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 19:14:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231240AbhEaXOt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 19:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED3496124B;
        Mon, 31 May 2021 23:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622502789;
        bh=7HtQIF8I78ID9+juPKd3waAT5WRffwl+RjnTHgiergE=;
        h=Date:From:To:Subject:From;
        b=wtM9h+HhVZEWPumaQzr9SzlQy/FrC3fpm8B5fpsjVt12RaAeUvpSsK6GFACdsuRGx
         nsA9V1ulVvRVYC+V0rqhp6f57AayUhgKbqcfkrMUFZZrbXBEU2Rkr5MSE9HDfzM/Y8
         u0hL5bVVySKyr8+JaJcBh1CcvT+Wy70fwmYhpzjU=
Date:   Mon, 31 May 2021 16:13:08 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, catalin.marinas@arm.com, davem@davemloft.net,
        geert@linux-m68k.org, linux@armlinux.org.uk,
        michal.simek@xilinx.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, palmerdabbelt@google.com,
        rppt@linux.ibm.com, rth@twiddle.net, tsbogend@alpha.franken.de,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  + mm-generalize-zone_.patch added to -mm tree
Message-ID: <20210531231308.zgEII4YEw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalize ZONE_[DMA|DMA32]
has been added to the -mm tree.  Its filename is
     mm-generalize-zone_.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-generalize-zone_.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-generalize-zone_.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: generalize ZONE_[DMA|DMA32]

ZONE_[DMA|DMA32] configs have duplicate definitions on platforms that
subscribe to them.  Instead, just make them generic options which can be
selected on applicable platforms.

Also only x86/arm64 architectures could enable both ZONE_DMA and
ZONE_DMA32 if EXPERT, add ARCH_HAS_ZONE_DMA_SET to make dma zone
configurable and visible on the two architectures.

Link: https://lkml.kernel.org/r/20210528074557.17768-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>	[m68k]
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>	[RISC-V]
Acked-by: Michal Simek <michal.simek@xilinx.com>	[microblaze]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig                     |    5 +----
 arch/arm/Kconfig                       |    3 ---
 arch/arm64/Kconfig                     |    9 +--------
 arch/ia64/Kconfig                      |    4 +---
 arch/m68k/Kconfig                      |    5 +----
 arch/microblaze/Kconfig                |    4 +---
 arch/mips/Kconfig                      |    7 -------
 arch/powerpc/Kconfig                   |    4 ----
 arch/powerpc/platforms/Kconfig.cputype |    1 +
 arch/riscv/Kconfig                     |    5 +----
 arch/s390/Kconfig                      |    4 +---
 arch/sparc/Kconfig                     |    5 +----
 arch/x86/Kconfig                       |   15 ++-------------
 mm/Kconfig                             |   12 ++++++++++++
 14 files changed, 23 insertions(+), 60 deletions(-)

--- a/arch/alpha/Kconfig~mm-generalize-zone_
+++ a/arch/alpha/Kconfig
@@ -40,6 +40,7 @@ config ALPHA
 	select MMU_GATHER_NO_RANGE
 	select SET_FS
 	select SPARSEMEM_EXTREME if SPARSEMEM
+	select ZONE_DMA
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -65,10 +66,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config ZONE_DMA
-	bool
-	default y
-
 config GENERIC_ISA_DMA
 	bool
 	default y
--- a/arch/arm64/Kconfig~mm-generalize-zone_
+++ a/arch/arm64/Kconfig
@@ -42,6 +42,7 @@ config ARM64
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_TEARDOWN_DMA_OPS if IOMMU_SUPPORT
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_ELF_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_INLINE_READ_LOCK if !PREEMPTION
@@ -307,14 +308,6 @@ config GENERIC_CSUM
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ZONE_DMA
-	bool "Support DMA zone" if EXPERT
-	default y
-
-config ZONE_DMA32
-	bool "Support DMA32 zone" if EXPERT
-	default y
-
 config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	def_bool y
 
--- a/arch/arm/Kconfig~mm-generalize-zone_
+++ a/arch/arm/Kconfig
@@ -218,9 +218,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
-config ZONE_DMA
-	bool
-
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
--- a/arch/ia64/Kconfig~mm-generalize-zone_
+++ a/arch/ia64/Kconfig
@@ -60,6 +60,7 @@ config IA64
 	select NUMA if !FLATMEM
 	select PCI_MSI_ARCH_FALLBACKS if PCI_MSI
 	select SET_FS
+	select ZONE_DMA32
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -72,9 +73,6 @@ config 64BIT
 	select ATA_NONSTANDARD if ATA
 	default y
 
-config ZONE_DMA32
-	def_bool y
-
 config MMU
 	bool
 	default y
--- a/arch/m68k/Kconfig~mm-generalize-zone_
+++ a/arch/m68k/Kconfig
@@ -34,6 +34,7 @@ config M68K
 	select SET_FS
 	select UACCESS_MEMCPY if !MMU
 	select VIRT_TO_BUS
+	select ZONE_DMA
 
 config CPU_BIG_ENDIAN
 	def_bool y
@@ -62,10 +63,6 @@ config TIME_LOW_RES
 config NO_IOPORT_MAP
 	def_bool y
 
-config ZONE_DMA
-	bool
-	default y
-
 config HZ
 	int
 	default 1000 if CLEOPATRA
--- a/arch/microblaze/Kconfig~mm-generalize-zone_
+++ a/arch/microblaze/Kconfig
@@ -43,6 +43,7 @@ config MICROBLAZE
 	select MMU_GATHER_NO_RANGE
 	select SPARSE_IRQ
 	select SET_FS
+	select ZONE_DMA
 
 # Endianness selection
 choice
@@ -60,9 +61,6 @@ config CPU_LITTLE_ENDIAN
 
 endchoice
 
-config ZONE_DMA
-	def_bool y
-
 config ARCH_HAS_ILOG2_U32
 	def_bool n
 
--- a/arch/mips/Kconfig~mm-generalize-zone_
+++ a/arch/mips/Kconfig
@@ -3274,13 +3274,6 @@ config I8253
 	select CLKSRC_I8253
 	select CLKEVT_I8253
 	select MIPS_EXTERNAL_TIMER
-
-config ZONE_DMA
-	bool
-
-config ZONE_DMA32
-	bool
-
 endmenu
 
 config TRAD_SIGNALS
--- a/arch/powerpc/Kconfig~mm-generalize-zone_
+++ a/arch/powerpc/Kconfig
@@ -403,10 +403,6 @@ config PPC_ADV_DEBUG_DAC_RANGE
 config PPC_DAWR
 	bool
 
-config ZONE_DMA
-	bool
-	default y if PPC_BOOK3E_64
-
 config PGTABLE_LEVELS
 	int
 	default 2 if !PPC64
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-generalize-zone_
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -113,6 +113,7 @@ config PPC_BOOK3E_64
 	select PPC_FPU # Make it a choice ?
 	select PPC_SMP_MUXED_IPI
 	select PPC_DOORBELL
+	select ZONE_DMA
 
 endchoice
 
--- a/arch/riscv/Kconfig~mm-generalize-zone_
+++ a/arch/riscv/Kconfig
@@ -104,6 +104,7 @@ config RISCV
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
 	select UACCESS_MEMCPY if !MMU
+	select ZONE_DMA32 if 64BIT
 
 config ARCH_MMAP_RND_BITS_MIN
 	default 18 if 64BIT
@@ -133,10 +134,6 @@ config MMU
 	  Select if you want MMU-based virtualised addressing space
 	  support by paged memory management. If unsure, say 'Y'.
 
-config ZONE_DMA32
-	bool
-	default y if 64BIT
-
 config VA_BITS
 	int
 	default 32 if 32BIT
--- a/arch/s390/Kconfig~mm-generalize-zone_
+++ a/arch/s390/Kconfig
@@ -2,9 +2,6 @@
 config MMU
 	def_bool y
 
-config ZONE_DMA
-	def_bool y
-
 config CPU_BIG_ENDIAN
 	def_bool y
 
@@ -210,6 +207,7 @@ config S390
 	select THREAD_INFO_IN_TASK
 	select TTY
 	select VIRT_CPU_ACCOUNTING
+	select ZONE_DMA
 	# Note: keep the above list sorted alphabetically
 
 config SCHED_OMIT_FRAME_POINTER
--- a/arch/sparc/Kconfig~mm-generalize-zone_
+++ a/arch/sparc/Kconfig
@@ -59,6 +59,7 @@ config SPARC32
 	select CLZ_TAB
 	select HAVE_UID16
 	select OLD_SIGACTION
+	select ZONE_DMA
 
 config SPARC64
 	def_bool 64BIT
@@ -141,10 +142,6 @@ config HIGHMEM
 	default y if SPARC32
 	select KMAP_LOCAL
 
-config ZONE_DMA
-	bool
-	default y if SPARC32
-
 config GENERIC_ISA_DMA
 	bool
 	default y if SPARC32
--- a/arch/x86/Kconfig~mm-generalize-zone_
+++ a/arch/x86/Kconfig
@@ -33,6 +33,7 @@ config X86_64
 	select NEED_DMA_MAP_STATE
 	select SWIOTLB
 	select ARCH_HAS_ELFCORE_COMPAT
+	select ZONE_DMA32
 
 config FORCE_DYNAMIC_FTRACE
 	def_bool y
@@ -93,6 +94,7 @@ config X86
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_DEBUG_WX
+	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_MIGHT_HAVE_ACPI_PDC		if ACPI
 	select ARCH_MIGHT_HAVE_PC_PARPORT
@@ -343,9 +345,6 @@ config ARCH_SUSPEND_POSSIBLE
 config ARCH_WANT_GENERAL_HUGETLB
 	def_bool y
 
-config ZONE_DMA32
-	def_bool y if X86_64
-
 config AUDIT_ARCH
 	def_bool y if X86_64
 
@@ -393,16 +392,6 @@ config CC_HAS_SANE_STACKPROTECTOR
 
 menu "Processor type and features"
 
-config ZONE_DMA
-	bool "DMA memory allocation support" if EXPERT
-	default y
-	help
-	  DMA memory allocation support allows devices with less than 32-bit
-	  addressing to allocate within the first 16MB of address space.
-	  Disable if no such devices will be used.
-
-	  If unsure, say Y.
-
 config SMP
 	bool "Symmetric multi-processing support"
 	help
--- a/mm/Kconfig~mm-generalize-zone_
+++ a/mm/Kconfig
@@ -792,6 +792,18 @@ config ARCH_HAS_CACHE_LINE_SIZE
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
+config ARCH_HAS_ZONE_DMA_SET
+	bool
+
+config ZONE_DMA
+	bool "Support DMA zone" if ARCH_HAS_ZONE_DMA_SET
+	default y if ARM64 || X86
+
+config ZONE_DMA32
+	bool "Support DMA32 zone" if ARCH_HAS_ZONE_DMA_SET
+	depends on !X86_32
+	default y if ARM64
+
 config ZONE_DEVICE
 	bool "Device memory (pmem, HMM, etc...) hotplug support"
 	depends on MEMORY_HOTPLUG
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page-writeback-kill-get_writeback_state-comments.patch
mm-move-holes_in_zone-into-mm.patch
mm-generalize-zone_.patch

