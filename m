Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D821025CC80
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 22:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740608748; cv=none; b=Xd4i9VUS0ZEAxbqTMkpn9JEFndnCu35yn+y7EISvWqe1nRlDxV+/bxxL0gXYaoW7QPQbPyAWhWbhv7x5EoJM7ku1pY6fmvugg4bKWl77pziouMgwRf4al2iZhiVFjesZR3MpMqNPtWYU87MQdgyQY262zb0rkxK48AgsPX/JEas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740608748; c=relaxed/simple;
	bh=gxvht1MW+q4Em89gZCkT693qJ36dwtAjnR1nOpZXvpo=;
	h=Date:To:From:Subject:Message-Id; b=PGJUJtYDw7BzawwbZyloljk/EQSKshxoO/rxX7eupp+Ub+RYtDOgUYasNqn+G1Dqpb0CssXBMyyKGqhPvewA89+v8GLGXlHqf9MHPEzqCec0CWVTfDK3xNIYjh3Dis6eoa1K4z6/AJWkwYhV1JAYGIRIgTT92oD64UsWuZBgbLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xv6iQW/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xv6iQW/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAEAC4CED6;
	Wed, 26 Feb 2025 22:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740608748;
	bh=gxvht1MW+q4Em89gZCkT693qJ36dwtAjnR1nOpZXvpo=;
	h=Date:To:From:Subject:From;
	b=Xv6iQW/6lCGUUVnkIywVOy8kFR1hqrNgKKXIGSCipozUEoyxRKnloQMn9kSNXU6Wv
	 6VZgU16hIwkb3T1ts42IcMkhdMdogL9+OF7mnZcGyuF0F/E0tebX306HEaxNu4oTSC
	 Ssd8xcb0vx6gKs96Fvht0+aIeSVFz8PfGnqQJQO4=
Date: Wed, 26 Feb 2025 14:25:47 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tglx@linutronix.de,steven.price@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,mpe@ellerman.id.au,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,maddy@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,corbet@lwn.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-generic_ptdump-and-ptdump_core.patch added to mm-unstable branch
Message-Id: <20250226222548.4EAEAC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename GENERIC_PTDUMP and PTDUMP_CORE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-generic_ptdump-and-ptdump_core.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-generic_ptdump-and-ptdump_core.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: rename GENERIC_PTDUMP and PTDUMP_CORE
Date: Wed, 26 Feb 2025 17:54:04 +0530

Platforms subscribe into generic ptdump implementation via GENERIC_PTDUMP.
But generic ptdump gets enabled via PTDUMP_CORE.  These configs
combination is confusing as they sound very similar and does not
differentiate between platform's feature subscription and feature
enablement for ptdump.  Rename the configs as ARCH_HAS_PTDUMP and PTDUMP
making it more clear and improve readability.

Link: https://lkml.kernel.org/r/20250226122404.1927473-6-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu> (powerpc)
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig              |    2 +-
 arch/arm64/include/asm/ptdump.h |    4 ++--
 arch/arm64/kvm/Kconfig          |    4 ++--
 arch/arm64/mm/Makefile          |    2 +-
 arch/powerpc/Kconfig            |    2 +-
 arch/powerpc/mm/Makefile        |    2 +-
 arch/riscv/Kconfig              |    2 +-
 arch/riscv/mm/Makefile          |    2 +-
 arch/s390/Kconfig               |    2 +-
 arch/s390/mm/Makefile           |    2 +-
 arch/x86/Kconfig                |    2 +-
 arch/x86/Kconfig.debug          |    2 +-
 arch/x86/mm/Makefile            |    2 +-
 mm/Kconfig.debug                |   12 ++++++------
 mm/Makefile                     |    2 +-
 15 files changed, 22 insertions(+), 22 deletions(-)

--- a/arch/arm64/include/asm/ptdump.h~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/arm64/include/asm/ptdump.h
@@ -7,7 +7,7 @@
 
 #include <linux/ptdump.h>
 
-#ifdef CONFIG_PTDUMP_CORE
+#ifdef CONFIG_PTDUMP
 
 #include <linux/mm_types.h>
 #include <linux/seq_file.h>
@@ -70,6 +70,6 @@ static inline void ptdump_debugfs_regist
 #else
 static inline void note_page(struct ptdump_state *pt_st, unsigned long addr,
 			     int level, u64 val) { }
-#endif /* CONFIG_PTDUMP_CORE */
+#endif /* CONFIG_PTDUMP */
 
 #endif /* __ASM_PTDUMP_H */
--- a/arch/arm64/Kconfig~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/arm64/Kconfig
@@ -41,6 +41,7 @@ config ARM64
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG
@@ -157,7 +158,6 @@ config ARM64
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
 	select GENERIC_PCI_IOMAP
-	select GENERIC_PTDUMP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
--- a/arch/arm64/kvm/Kconfig~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/arm64/kvm/Kconfig
@@ -71,8 +71,8 @@ config PTDUMP_STAGE2_DEBUGFS
 	depends on KVM
 	depends on DEBUG_KERNEL
 	depends on DEBUG_FS
-	depends on GENERIC_PTDUMP
-	select PTDUMP_CORE
+	depends on ARCH_HAS_PTDUMP
+	select PTDUMP
 	default n
 	help
 	  Say Y here if you want to show the stage-2 kernel pagetables
--- a/arch/arm64/mm/Makefile~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/arm64/mm/Makefile
@@ -5,7 +5,7 @@ obj-y				:= dma-mapping.o extable.o faul
 				   context.o proc.o pageattr.o fixmap.o
 obj-$(CONFIG_ARM64_CONTPTE)	+= contpte.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE)	+= ptdump.o
+obj-$(CONFIG_PTDUMP)		+= ptdump.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= ptdump_debugfs.o
 obj-$(CONFIG_TRANS_TABLE)	+= trans_pgd.o
 obj-$(CONFIG_TRANS_TABLE)	+= trans_pgd-asm.o
--- a/arch/powerpc/Kconfig~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/powerpc/Kconfig
@@ -148,6 +148,7 @@ config PPC
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_PREEMPT_LAZY
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_DEVMAP		if PPC_BOOK3S_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
@@ -206,7 +207,6 @@ config PPC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_PCI_IOMAP		if PCI
-	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_VDSO_TIME_NS
--- a/arch/powerpc/mm/Makefile~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/powerpc/mm/Makefile
@@ -15,5 +15,5 @@ obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_NOT_COHERENT_CACHE) += dma-noncoherent.o
 obj-$(CONFIG_PPC_COPRO_BASE)	+= copro_fault.o
-obj-$(CONFIG_PTDUMP_CORE)	+= ptdump/
+obj-$(CONFIG_PTDUMP)		+= ptdump/
 obj-$(CONFIG_KASAN)		+= kasan/
--- a/arch/riscv/Kconfig~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/riscv/Kconfig
@@ -43,6 +43,7 @@ config RISCV
 	select ARCH_HAS_PMEM_API
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
+	select ARCH_HAS_PTDUMP if MMU
 	select ARCH_HAS_PTE_DEVMAP if 64BIT && MMU
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SET_DIRECT_MAP if MMU
@@ -112,7 +113,6 @@ config RISCV
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_LIB_DEVMEM_IS_ALLOWED
 	select GENERIC_PCI_IOMAP
-	select GENERIC_PTDUMP if MMU
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL if MMU && 64BIT
--- a/arch/riscv/mm/Makefile~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/riscv/mm/Makefile
@@ -19,7 +19,7 @@ obj-y += context.o
 obj-y += pmem.o
 
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE) += ptdump.o
+obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_KASAN)   += kasan_init.o
 
 ifdef CONFIG_KASAN
--- a/arch/s390/Kconfig~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/s390/Kconfig
@@ -96,6 +96,7 @@ config S390
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_PREEMPT_LAZY
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SCALED_CPUTIME
 	select ARCH_HAS_SET_DIRECT_MAP
@@ -163,7 +164,6 @@ config S390
 	select GENERIC_CPU_VULNERABILITIES
 	select GENERIC_ENTRY
 	select GENERIC_GETTIMEOFDAY
-	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_VDSO_TIME_NS
--- a/arch/s390/mm/Makefile~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/s390/mm/Makefile
@@ -9,6 +9,6 @@ obj-y		+= page-states.o pageattr.o pgtab
 obj-$(CONFIG_CMM)		+= cmm.o
 obj-$(CONFIG_DEBUG_VIRTUAL)	+= physaddr.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE)	+= dump_pagetables.o
+obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PGSTE)		+= gmap.o
 obj-$(CONFIG_PFAULT)		+= pfault.o
--- a/arch/x86/Kconfig~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/x86/Kconfig
@@ -26,6 +26,7 @@ config X86_64
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
 	select ARCH_HAS_GIGANTIC_PAGE
+	select ARCH_HAS_PTDUMP
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
@@ -175,7 +176,6 @@ config X86
 	select GENERIC_IRQ_RESERVATION_MODE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PENDING_IRQ		if SMP
-	select GENERIC_PTDUMP
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_GETTIMEOFDAY
--- a/arch/x86/Kconfig.debug~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/x86/Kconfig.debug
@@ -59,7 +59,7 @@ config EARLY_PRINTK_USB_XDBC
 config EFI_PGT_DUMP
 	bool "Dump the EFI pagetable"
 	depends on EFI
-	select PTDUMP_CORE
+	select PTDUMP
 	help
 	  Enable this if you want to dump the EFI page table before
 	  enabling virtual mode. This can be used to debug miscellaneous
--- a/arch/x86/mm/Makefile~mm-rename-generic_ptdump-and-ptdump_core
+++ a/arch/x86/mm/Makefile
@@ -39,7 +39,7 @@ CFLAGS_fault.o := -I $(src)/../include/a
 obj-$(CONFIG_X86_32)		+= pgtable_32.o iomap_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
-obj-$(CONFIG_PTDUMP_CORE)	+= dump_pagetables.o
+obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PTDUMP_DEBUGFS)	+= debug_pagetables.o
 
 obj-$(CONFIG_HIGHMEM)		+= highmem_32.o
--- a/mm/Kconfig.debug~mm-rename-generic_ptdump-and-ptdump_core
+++ a/mm/Kconfig.debug
@@ -186,9 +186,9 @@ config ARCH_HAS_DEBUG_WX
 config DEBUG_WX
 	bool "Warn on W+X mappings at boot"
 	depends on ARCH_HAS_DEBUG_WX
-	depends on GENERIC_PTDUMP
+	depends on ARCH_HAS_PTDUMP
 	depends on MMU
-	select PTDUMP_CORE
+	select PTDUMP
 	help
 	  Generate a warning if any W+X mappings are found at boot.
 
@@ -213,18 +213,18 @@ config DEBUG_WX
 
 	  If in doubt, say "Y".
 
-config GENERIC_PTDUMP
+config ARCH_HAS_PTDUMP
 	bool
 
-config PTDUMP_CORE
+config PTDUMP
 	bool
 
 config PTDUMP_DEBUGFS
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
 	depends on DEBUG_FS
-	depends on GENERIC_PTDUMP
-	select PTDUMP_CORE
+	depends on ARCH_HAS_PTDUMP
+	select PTDUMP
 	help
 	  Say Y here if you want to show the kernel pagetable layout in a
 	  debugfs file. This information is only useful for kernel developers
--- a/mm/Makefile~mm-rename-generic_ptdump-and-ptdump_core
+++ a/mm/Makefile
@@ -139,7 +139,7 @@ obj-$(CONFIG_ZONE_DEVICE) += memremap.o
 obj-$(CONFIG_HMM_MIRROR) += hmm.o
 obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
-obj-$(CONFIG_PTDUMP_CORE) += ptdump.o
+obj-$(CONFIG_PTDUMP) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
 obj-$(CONFIG_IO_MAPPING) += io-mapping.o
 obj-$(CONFIG_HAVE_BOOTMEM_INFO_NODE) += bootmem_info.o
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

configs-drop-generic_ptdump-from-debugconfig.patch
arch-powerpc-drop-generic_ptdump-from-mpc885_ads_defconfig.patch
docs-arm64-drop-ptdump-config-options-from-ptdumprst.patch
mm-make-debug_wx-depdendent-on-generic_ptdump.patch
mm-rename-generic_ptdump-and-ptdump_core.patch

