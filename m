Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F19C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF0CD61424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhEHWvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhEHWvE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:51:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFCC461402;
        Sat,  8 May 2021 22:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514202;
        bh=plNNJvAPYsDpOJG4Dz8NzA45u4KrKRHC+IZ8B7ySUvw=;
        h=Date:From:To:Subject:From;
        b=Ziwa+elUU4+fgAMnJIp0S2AJ5uFzmBlNr/nbyV44T2Erq/Wn9KUV5K/Dbd9CxDHqs
         CuowTRVFIL+EBlC4818YRX3p7VME+Q50Q2//zPJVNLgw7aShX+YXFCJnjUOaCX6Y5u
         vBJ7CJOyd6m88s3HZmL9WoxFz3DNo/1k2YrsPbjc=
Date:   Sat, 08 May 2021 15:50:01 -0700
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, aou@eecs.berkeley.edu, arnd@arndb.de,
        benh@kernel.crashing.org, borntraeger@de.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, dalias@libc.org, deller@gmx.de,
        gor@linux.ibm.com, hca@linux.ibm.com, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, linux@armlinux.org.uk,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        palmerdabbelt@google.com, paul.walmsley@sifive.com,
        paulus@samba.org, tglx@linutronix.de, tsbogend@alpha.franken.de,
        vgupta@synopsys.com, viro@zeniv.linux.org.uk, will@kernel.org,
        ysato@users.sourceforge.jp
Subject:  [merged]
 =?US-ASCII?Q?mm-generalize-sys=5Fsupports=5Fhugetlbfs-rename-as-arch=5F?=
 =?US-ASCII?Q?supports=5Fhugetlbfs.patch?= removed from -mm tree
Message-ID: <20210508225001.tNZLoDCnf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: generalize SYS_SUPPORTS_HUGETLBFS (rename as ARCH_SUPPORTS_HUGETLBFS)
has been removed from the -mm tree.  Its filename was
     mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: generalize SYS_SUPPORTS_HUGETLBFS (rename as ARCH_SUPPORTS_HUGETLBFS)

SYS_SUPPORTS_HUGETLBFS config has duplicate definitions on platforms that
subscribe it.  Instead, just make it a generic option which can be
selected on applicable platforms.  Also rename it as
ARCH_SUPPORTS_HUGETLBFS instead.  This reduces code duplication and makes
it cleaner.

Link: https://lkml.kernel.org/r/1617259448-22529-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>	[riscv]
Acked-by: Michael Ellerman <mpe@ellerman.id.au>		[powerpc]
Cc: Russell King <linux@armlinux.org.uk>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                       |    5 +----
 arch/arm64/Kconfig                     |    4 +---
 arch/mips/Kconfig                      |    6 +-----
 arch/parisc/Kconfig                    |    5 +----
 arch/powerpc/Kconfig                   |    3 ---
 arch/powerpc/platforms/Kconfig.cputype |    6 +++---
 arch/riscv/Kconfig                     |    5 +----
 arch/sh/Kconfig                        |    5 +----
 fs/Kconfig                             |    5 ++++-
 9 files changed, 13 insertions(+), 31 deletions(-)

--- a/arch/arm64/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/arm64/Kconfig
@@ -73,6 +73,7 @@ config ARM64
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
 	select ARCH_SUPPORTS_LTO_CLANG if CPU_LITTLE_ENDIAN
@@ -1072,9 +1073,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config SYS_SUPPORTS_HUGETLBFS
-	def_bool y
-
 config ARCH_HAS_FILTER_PGPROT
 	def_bool y
 
--- a/arch/arm/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/arm/Kconfig
@@ -31,6 +31,7 @@ config ARM
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT if CPU_V7
 	select ARCH_SUPPORTS_ATOMIC_RMW
+	select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_MEMTEST
@@ -1511,10 +1512,6 @@ config HW_PERF_EVENTS
 	def_bool y
 	depends on ARM_PMU
 
-config SYS_SUPPORTS_HUGETLBFS
-       def_bool y
-       depends on ARM_LPAE
-
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
        def_bool y
        depends on ARM_LPAE
--- a/arch/mips/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/mips/Kconfig
@@ -19,6 +19,7 @@ config MIPS
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
+	select ARCH_SUPPORTS_HUGETLBFS if CPU_SUPPORTS_HUGEPAGES
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_WANT_LD_ORPHAN_WARN
@@ -1287,11 +1288,6 @@ config SYS_SUPPORTS_BIG_ENDIAN
 config SYS_SUPPORTS_LITTLE_ENDIAN
 	bool
 
-config SYS_SUPPORTS_HUGETLBFS
-	bool
-	depends on CPU_SUPPORTS_HUGEPAGES
-	default y
-
 config MIPS_HUGE_TLB_SUPPORT
 	def_bool HUGETLB_PAGE || TRANSPARENT_HUGEPAGE
 
--- a/arch/parisc/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/parisc/Kconfig
@@ -12,6 +12,7 @@ config PARISC
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_NO_SG_CHAIN
+	select ARCH_SUPPORTS_HUGETLBFS if PA20
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select DMA_OPS
 	select RTC_CLASS
@@ -138,10 +139,6 @@ config PGTABLE_LEVELS
 	default 3 if 64BIT && PARISC_PAGE_SIZE_4KB
 	default 2
 
-config SYS_SUPPORTS_HUGETLBFS
-	def_bool y if PA20
-
-
 menu "Processor type and features"
 
 choice
--- a/arch/powerpc/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/powerpc/Kconfig
@@ -697,9 +697,6 @@ config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 	depends on PPC_BOOK3S_64
 
-config SYS_SUPPORTS_HUGETLBFS
-	bool
-
 config ILLEGAL_POINTER_VALUE
 	hex
 	# This is roughly half way between the top of user space and the bottom
--- a/arch/powerpc/platforms/Kconfig.cputype~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -40,8 +40,8 @@ config PPC_85xx
 
 config PPC_8xx
 	bool "Freescale 8xx"
+	select ARCH_SUPPORTS_HUGETLBFS
 	select FSL_SOC
-	select SYS_SUPPORTS_HUGETLBFS
 	select PPC_HAVE_KUEP
 	select PPC_HAVE_KUAP
 	select HAVE_ARCH_VMAP_STACK
@@ -95,9 +95,9 @@ config PPC_BOOK3S_64
 	bool "Server processors"
 	select PPC_FPU
 	select PPC_HAVE_PMU_SUPPORT
-	select SYS_SUPPORTS_HUGETLBFS
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
+	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select IRQ_WORK
 	select PPC_MM_SLICES
@@ -278,9 +278,9 @@ config FSL_BOOKE
 # this is for common code between PPC32 & PPC64 FSL BOOKE
 config PPC_FSL_BOOK3E
 	bool
+	select ARCH_SUPPORTS_HUGETLBFS if PHYS_64BIT || PPC64
 	select FSL_EMB_PERFMON
 	select PPC_SMP_MUXED_IPI
-	select SYS_SUPPORTS_HUGETLBFS if PHYS_64BIT || PPC64
 	select PPC_DOORBELL
 	default y if FSL_BOOKE
 
--- a/arch/riscv/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/riscv/Kconfig
@@ -30,6 +30,7 @@ config RISCV
 	select ARCH_HAS_STRICT_KERNEL_RWX if MMU
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
+	select ARCH_SUPPORTS_HUGETLBFS if MMU
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
@@ -165,10 +166,6 @@ config ARCH_WANT_GENERAL_HUGETLB
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
-config SYS_SUPPORTS_HUGETLBFS
-	depends on MMU
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 
--- a/arch/sh/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/arch/sh/Kconfig
@@ -101,9 +101,6 @@ config SYS_SUPPORTS_APM_EMULATION
 	bool
 	select ARCH_SUSPEND_POSSIBLE
 
-config SYS_SUPPORTS_HUGETLBFS
-	bool
-
 config SYS_SUPPORTS_SMP
 	bool
 
@@ -175,12 +172,12 @@ config CPU_SH3
 
 config CPU_SH4
 	bool
+	select ARCH_SUPPORTS_HUGETLBFS if MMU
 	select CPU_HAS_INTEVT
 	select CPU_HAS_SR_RB
 	select CPU_HAS_FPU if !CPU_SH4AL_DSP
 	select SH_INTC
 	select SYS_SUPPORTS_SH_TMU
-	select SYS_SUPPORTS_HUGETLBFS if MMU
 
 config CPU_SH4A
 	bool
--- a/fs/Kconfig~mm-generalize-sys_supports_hugetlbfs-rename-as-arch_supports_hugetlbfs
+++ a/fs/Kconfig
@@ -223,10 +223,13 @@ config TMPFS_INODE64
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_HUGETLBFS
+	def_bool n
+
 config HUGETLBFS
 	bool "HugeTLB file system support"
 	depends on X86 || IA64 || SPARC64 || (S390 && 64BIT) || \
-		   SYS_SUPPORTS_HUGETLBFS || BROKEN
+		   ARCH_SUPPORTS_HUGETLBFS || BROKEN
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
 	  ramfs. For architectures that support it, say Y here and read
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


