Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63273C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbiBVDOq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:14:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239792AbiBVDOp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:14:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0741116F
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABF0C61539
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCF5C340E9;
        Tue, 22 Feb 2022 03:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499655;
        bh=hnZbvE01as6IvxFSACWeuJLU9KcHV4R5COPMd37gJiM=;
        h=Date:To:From:Subject:From;
        b=ykNNOTcNNlFpUBkigzY5gufXiSdnmT5F1qVukZi0rHg2AFbN9Cn5SmRHZ2/gcPudV
         Z2uaGJdzPWpYW/VVKvAQmjsH107mP5Bw69RxgtUvRzwSiCtBSJHmHuqfDX3dBDhcqq
         qlghj6wAMdKh/G4dHfuR8GZ96pBv3cP+bDmI+m9w=
Date:   Mon, 21 Feb 2022 19:14:14 -0800
To:     mm-commits@vger.kernel.org, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-drop-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031415.0BCF5C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: drop ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     mm-mmap-drop-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-drop-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-drop-arch_has_vm_get_page_prot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/mmap: drop ARCH_HAS_VM_GET_PAGE_PROT

All platforms now define their own vm_get_page_prot() and also there is no
generic version left to fallback on.  Hence drop ARCH_HAS_GET_PAGE_PROT.

Link: https://lkml.kernel.org/r/1645425519-9034-31-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig      |    1 -
 arch/arc/Kconfig        |    1 -
 arch/arm/Kconfig        |    1 -
 arch/arm64/Kconfig      |    1 -
 arch/csky/Kconfig       |    1 -
 arch/hexagon/Kconfig    |    1 -
 arch/ia64/Kconfig       |    1 -
 arch/m68k/Kconfig       |    1 -
 arch/microblaze/Kconfig |    1 -
 arch/mips/Kconfig       |    1 -
 arch/nds32/Kconfig      |    1 -
 arch/nios2/Kconfig      |    1 -
 arch/openrisc/Kconfig   |    1 -
 arch/parisc/Kconfig     |    1 -
 arch/powerpc/Kconfig    |    1 -
 arch/riscv/Kconfig      |    1 -
 arch/s390/Kconfig       |    1 -
 arch/sh/Kconfig         |    1 -
 arch/sparc/Kconfig      |    2 --
 arch/um/Kconfig         |    1 -
 arch/x86/Kconfig        |    1 -
 arch/xtensa/Kconfig     |    1 -
 mm/Kconfig              |    3 ---
 mm/mmap.c               |   23 -----------------------
 24 files changed, 49 deletions(-)

--- a/arch/alpha/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/alpha/Kconfig
@@ -2,7 +2,6 @@
 config ALPHA
 	bool
 	default y
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
--- a/arch/arc/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/arc/Kconfig
@@ -13,7 +13,6 @@ config ARC
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_SUPPORTS_ATOMIC_RMW if ARC_HAS_LLSC
 	select ARCH_32BIT_OFF_T
 	select BUILDTIME_TABLE_SORT
--- a/arch/arm64/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/arm64/Kconfig
@@ -43,7 +43,6 @@ config ARM64
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_TEARDOWN_DMA_OPS if IOMMU_SUPPORT
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_ELF_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
--- a/arch/arm/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/arm/Kconfig
@@ -23,7 +23,6 @@ config ARM
 	select ARCH_HAS_SYNC_DMA_FOR_CPU if SWIOTLB || !MMU
 	select ARCH_HAS_TEARDOWN_DMA_OPS if MMU
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if CPU_V7 || CPU_V7M || CPU_V6K
 	select ARCH_HAS_GCOV_PROFILE_ALL
--- a/arch/csky/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/csky/Kconfig
@@ -6,7 +6,6 @@ config CSKY
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_WANT_FRAME_POINTERS if !CPU_CK610 && $(cc-option,-mbacktrace)
--- a/arch/hexagon/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/hexagon/Kconfig
@@ -6,7 +6,6 @@ config HEXAGON
 	def_bool y
 	select ARCH_32BIT_OFF_T
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_NO_PREEMPT
 	select DMA_GLOBAL_POOL
 	# Other pending projects/to-do items.
--- a/arch/ia64/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/ia64/Kconfig
@@ -11,7 +11,6 @@ config IA64
 	select ARCH_HAS_DMA_MARK_CLEAN
 	select ARCH_HAS_STRNCPY_FROM_USER
 	select ARCH_HAS_STRNLEN_USER
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ACPI
--- a/arch/m68k/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/m68k/Kconfig
@@ -11,7 +11,6 @@ config M68K
 	select ARCH_NO_PREEMPT if !COLDFIRE
 	select ARCH_USE_MEMTEST if MMU_MOTOROLA
 	select ARCH_WANT_IPC_PARSE_VERSION
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select BINFMT_FLAT_ARGVP_ENVP_ON_STACK
 	select DMA_DIRECT_REMAP if HAS_DMA && MMU && !COLDFIRE
 	select GENERIC_ATOMIC64
--- a/arch/microblaze/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/microblaze/Kconfig
@@ -7,7 +7,6 @@ config MICROBLAZE
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_TABLE_SORT
--- a/arch/mips/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/mips/Kconfig
@@ -13,7 +13,6 @@ config MIPS
 	select ARCH_HAS_STRNLEN_USER
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_SUPPORTS_UPROBES
--- a/arch/nds32/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/nds32/Kconfig
@@ -10,7 +10,6 @@ config NDS32
 	select ARCH_HAS_DMA_PREP_COHERENT
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_WANT_FRAME_POINTERS if FTRACE
 	select CLKSRC_MMIO
 	select CLONE_BACKWARDS
--- a/arch/nios2/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/nios2/Kconfig
@@ -6,7 +6,6 @@ config NIOS2
 	select ARCH_HAS_SYNC_DMA_FOR_CPU
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
 	select ARCH_HAS_DMA_SET_UNCACHED
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_NO_SWAP
 	select COMMON_CLK
 	select TIMER_OF
--- a/arch/openrisc/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/openrisc/Kconfig
@@ -10,7 +10,6 @@ config OPENRISC
 	select ARCH_HAS_DMA_SET_UNCACHED
 	select ARCH_HAS_DMA_CLEAR_UNCACHED
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select COMMON_CLK
 	select OF
 	select OF_EARLY_FLATTREE
--- a/arch/parisc/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/parisc/Kconfig
@@ -10,7 +10,6 @@ config PARISC
 	select ARCH_HAS_ELF_RANDOMIZE
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_NO_SG_CHAIN
 	select ARCH_SUPPORTS_HUGETLBFS if PA20
 	select ARCH_SUPPORTS_MEMORY_FAILURE
--- a/arch/powerpc/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/powerpc/Kconfig
@@ -135,7 +135,6 @@ config PPC
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
--- a/arch/riscv/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/riscv/Kconfig
@@ -31,7 +31,6 @@ config RISCV
 	select ARCH_HAS_STRICT_MODULE_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
 	select ARCH_STACKWALK
--- a/arch/s390/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/s390/Kconfig
@@ -78,7 +78,6 @@ config S390
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_VDSO_DATA
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_INLINE_READ_LOCK
 	select ARCH_INLINE_READ_LOCK_BH
--- a/arch/sh/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/sh/Kconfig
@@ -11,7 +11,6 @@ config SUPERH
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
--- a/arch/sparc/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/sparc/Kconfig
@@ -59,7 +59,6 @@ config SPARC32
 	select HAVE_UID16
 	select OLD_SIGACTION
 	select ZONE_DMA
-	select ARCH_HAS_VM_GET_PAGE_PROT
 
 config SPARC64
 	def_bool 64BIT
@@ -85,7 +84,6 @@ config SPARC64
 	select PERF_USE_VMALLOC
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_C_RECORDMCOUNT
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select HAVE_ARCH_AUDITSYSCALL
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
--- a/arch/um/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/um/Kconfig
@@ -9,7 +9,6 @@ config UML
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_STRNCPY_FROM_USER
 	select ARCH_HAS_STRNLEN_USER
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_NO_PREEMPT
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_SECCOMP_FILTER
--- a/arch/x86/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/x86/Kconfig
@@ -93,7 +93,6 @@ config X86
 	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
--- a/arch/xtensa/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/xtensa/Kconfig
@@ -9,7 +9,6 @@ config XTENSA
 	select ARCH_HAS_DMA_SET_UNCACHED if MMU
 	select ARCH_HAS_STRNCPY_FROM_USER if !KASAN
 	select ARCH_HAS_STRNLEN_USER
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
--- a/mm/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/mm/Kconfig
@@ -744,9 +744,6 @@ config IDLE_PAGE_TRACKING
 config ARCH_HAS_CACHE_LINE_SIZE
 	bool
 
-config ARCH_HAS_VM_GET_PAGE_PROT
-	bool
-
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
--- a/mm/mmap.c~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/mm/mmap.c
@@ -81,29 +81,6 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *vma, struct vm_area_struct *prev,
 		unsigned long start, unsigned long end);
 
-#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
-/* description of effects of mapping type and prot in current implementation.
- * this is due to the limited x86 page protection hardware.  The expected
- * behavior is in parens:
- *
- * map_type	prot
- *		PROT_NONE	PROT_READ	PROT_WRITE	PROT_EXEC
- * MAP_SHARED	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
- *		w: (no) no	w: (no) no	w: (yes) yes	w: (no) no
- *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
- *
- * MAP_PRIVATE	r: (no) no	r: (yes) yes	r: (no) yes	r: (no) yes
- *		w: (no) no	w: (no) no	w: (copy) copy	w: (no) no
- *		x: (no) no	x: (no) yes	x: (no) yes	x: (yes) yes
- *
- * On arm64, PROT_EXEC has the following behaviour for both MAP_SHARED and
- * MAP_PRIVATE (with Enhanced PAN supported):
- *								r: (no) no
- *								w: (no) no
- *								x: (yes) yes
- */
-#endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
-
 static pgprot_t vm_pgprot_modify(pgprot_t oldprot, unsigned long vm_flags)
 {
 	return pgprot_modify(oldprot, vm_get_page_prot(vm_flags));
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-generalize-arch_has_filter_pgprot.patch
mm-merge-pte_mkhuge-call-into-arch_make_huge_pte.patch
mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-protection_map.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
extensa-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
nds32-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-generic-vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch
mm-hugetlb-generalize-arch_want_general_hugetlb.patch
mm-migration-add-trace-events-for-thp-migrations.patch
mm-migration-add-trace-events-for-base-page-and-hugetlb-migrations.patch

