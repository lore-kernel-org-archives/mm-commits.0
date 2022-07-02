Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24288C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 00:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiGBAI3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Jul 2022 20:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiGBAIG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2022 20:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D098735B8
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 17:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C69E6248C
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 00:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703FAC3411E;
        Sat,  2 Jul 2022 00:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656720482;
        bh=Crut4R5vWDdVlX3AzQqKVgo0ZnTHHZfWixzTGSYbvwg=;
        h=Date:To:From:Subject:From;
        b=wdeTjp9XqzpipG6H1Qi3tEtakoGK+1LbyM5C2wvNjE2psIB/x6UyfMtoEsrnrUhgm
         XTGKipjWv+cs4t/zmxiuQiVqj8BMSuo2YOhpN5SJWRkfbJRxbRIAGMMU3ikN/I4Yim
         5VmWbGPMEeCnH35ZJygZLoqWviLee/X5idyQbecI=
Date:   Fri, 01 Jul 2022 17:08:00 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de,
        christophe.leroy@csgroup.eu, anshuman.khandual@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-drop-arch_has_vm_get_page_prot.patch added to mm-unstable branch
Message-Id: <20220702000802.703FAC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: drop ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-drop-arch_has_vm_get_page_prot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-drop-arch_has_vm_get_page_prot.patch

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
Subject: mm/mmap: drop ARCH_HAS_VM_GET_PAGE_PROT
Date: Thu, 30 Jun 2022 10:46:30 +0530

Now all the platforms enable ARCH_HAS_GET_PAGE_PROT.  They define and
export own vm_get_page_prot() whether custom or standard
DECLARE_VM_GET_PAGE_PROT.  Hence there is no need for default generic
fallback for vm_get_page_prot().  Just drop this fallback and also
ARCH_HAS_GET_PAGE_PROT mechanism.

Link: https://lkml.kernel.org/r/20220630051630.1718927-27-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig      |    1 -
 arch/arc/Kconfig        |    1 -
 arch/arm/Kconfig        |    1 -
 arch/arm64/Kconfig      |    1 -
 arch/csky/Kconfig       |    1 -
 arch/hexagon/Kconfig    |    1 -
 arch/ia64/Kconfig       |    1 -
 arch/loongarch/Kconfig  |    1 -
 arch/m68k/Kconfig       |    1 -
 arch/microblaze/Kconfig |    1 -
 arch/mips/Kconfig       |    1 -
 arch/nios2/Kconfig      |    1 -
 arch/openrisc/Kconfig   |    1 -
 arch/parisc/Kconfig     |    1 -
 arch/powerpc/Kconfig    |    1 -
 arch/riscv/Kconfig      |    1 -
 arch/s390/Kconfig       |    1 -
 arch/sh/Kconfig         |    1 -
 arch/sparc/Kconfig      |    1 -
 arch/um/Kconfig         |    1 -
 arch/x86/Kconfig        |    1 -
 arch/xtensa/Kconfig     |    1 -
 include/linux/mm.h      |    3 ---
 mm/Kconfig              |    3 ---
 mm/mmap.c               |   22 ----------------------
 25 files changed, 50 deletions(-)

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
@@ -45,7 +45,6 @@ config ARM64
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_TEARDOWN_DMA_OPS if IOMMU_SUPPORT
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_ELF_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
--- a/arch/arm/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/arm/Kconfig
@@ -24,7 +24,6 @@ config ARM
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
@@ -12,7 +12,6 @@ config IA64
 	select ARCH_HAS_DMA_MARK_CLEAN
 	select ARCH_HAS_STRNCPY_FROM_USER
 	select ARCH_HAS_STRNLEN_USER
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ACPI
--- a/arch/loongarch/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/loongarch/Kconfig
@@ -9,7 +9,6 @@ config LOONGARCH
 	select ARCH_HAS_ACPI_TABLE_UPGRADE	if ACPI
 	select ARCH_HAS_PHYS_TO_DMA
 	select ARCH_HAS_PTE_SPECIAL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_INLINE_READ_LOCK if !PREEMPTION
 	select ARCH_INLINE_READ_LOCK_BH if !PREEMPTION
--- a/arch/m68k/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/m68k/Kconfig
@@ -7,7 +7,6 @@ config M68K
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DMA_PREP_COHERENT if HAS_DMA && MMU && !COLDFIRE
 	select ARCH_HAS_SYNC_DMA_FOR_DEVICE if HAS_DMA
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select ARCH_MIGHT_HAVE_PC_PARPORT if ISA
 	select ARCH_NO_PREEMPT if !COLDFIRE
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
@@ -14,7 +14,6 @@ config MIPS
 	select ARCH_HAS_STRNLEN_USER
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_SUPPORTS_UPROBES
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
@@ -12,7 +12,6 @@ config PARISC
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_NO_SG_CHAIN
 	select ARCH_SUPPORTS_HUGETLBFS if PA20
--- a/arch/powerpc/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/powerpc/Kconfig
@@ -140,7 +140,6 @@ config PPC
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
--- a/arch/riscv/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/riscv/Kconfig
@@ -32,7 +32,6 @@ config RISCV
 	select ARCH_HAS_STRICT_MODULE_RWX if MMU && !XIP_KERNEL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
 	select ARCH_STACKWALK
--- a/arch/s390/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/s390/Kconfig
@@ -81,7 +81,6 @@ config S390
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_VDSO_DATA
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_INLINE_READ_LOCK
 	select ARCH_INLINE_READ_LOCK_BH
--- a/arch/sh/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/sh/Kconfig
@@ -12,7 +12,6 @@ config SUPERH
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_WANT_IPC_PARSE_VERSION
--- a/arch/sparc/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/sparc/Kconfig
@@ -13,7 +13,6 @@ config 64BIT
 config SPARC
 	bool
 	default y
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_MIGHT_HAVE_PC_PARPORT if SPARC64 && PCI
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select DMA_OPS
--- a/arch/um/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/um/Kconfig
@@ -10,7 +10,6 @@ config UML
 	select ARCH_HAS_KCOV
 	select ARCH_HAS_STRNCPY_FROM_USER
 	select ARCH_HAS_STRNLEN_USER
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_NO_PREEMPT
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_SECCOMP_FILTER
--- a/arch/x86/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/x86/Kconfig
@@ -94,7 +94,6 @@ config X86
 	select ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_DEBUG_WX
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
--- a/arch/xtensa/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/arch/xtensa/Kconfig
@@ -11,7 +11,6 @@ config XTENSA
 	select ARCH_HAS_DMA_SET_UNCACHED if MMU
 	select ARCH_HAS_STRNCPY_FROM_USER if !KASAN
 	select ARCH_HAS_STRNLEN_USER
-	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_USE_MEMTEST
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
--- a/include/linux/mm.h~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/include/linux/mm.h
@@ -424,9 +424,6 @@ extern unsigned int kobjsize(const void
  * mapping from the currently active vm_flags protection bits (the
  * low four bits) to a page protection mask..
  */
-#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
-extern pgprot_t protection_map[16];
-#endif
 
 /*
  * The default fault flags that should be used by most of the
--- a/mm/Kconfig~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/mm/Kconfig
@@ -951,9 +951,6 @@ config ARCH_HAS_CURRENT_STACK_POINTER
 	  register alias named "current_stack_pointer", this config can be
 	  selected.
 
-config ARCH_HAS_VM_GET_PAGE_PROT
-	bool
-
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
--- a/mm/mmap.c~mm-mmap-drop-arch_has_vm_get_page_prot
+++ a/mm/mmap.c
@@ -80,28 +80,6 @@ static void unmap_region(struct mm_struc
 		struct vm_area_struct *next, unsigned long start,
 		unsigned long end);
 
-#ifndef CONFIG_ARCH_HAS_VM_GET_PAGE_PROT
-pgprot_t protection_map[16] __ro_after_init = {
-	[VM_NONE]					= __P000,
-	[VM_READ]					= __P001,
-	[VM_WRITE]					= __P010,
-	[VM_WRITE | VM_READ]				= __P011,
-	[VM_EXEC]					= __P100,
-	[VM_EXEC | VM_READ]				= __P101,
-	[VM_EXEC | VM_WRITE]				= __P110,
-	[VM_EXEC | VM_WRITE | VM_READ]			= __P111,
-	[VM_SHARED]					= __S000,
-	[VM_SHARED | VM_READ]				= __S001,
-	[VM_SHARED | VM_WRITE]				= __S010,
-	[VM_SHARED | VM_WRITE | VM_READ]		= __S011,
-	[VM_SHARED | VM_EXEC]				= __S100,
-	[VM_SHARED | VM_EXEC | VM_READ]			= __S101,
-	[VM_SHARED | VM_EXEC | VM_WRITE]		= __S110,
-	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= __S111
-};
-DECLARE_VM_GET_PAGE_PROT
-#endif	/* CONFIG_ARCH_HAS_VM_GET_PAGE_PROT */
-
 static pgprot_t vm_pgprot_modify(pgprot_t oldprot, unsigned long vm_flags)
 {
 	return pgprot_modify(oldprot, vm_get_page_prot(vm_flags));
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-mmap-build-protect-protection_map-with-__p000.patch
mm-mmap-define-declare_vm_get_page_prot.patch
powerpc-mm-move-protection_map-inside-the-platform.patch
sparc-mm-move-protection_map-inside-the-platform.patch
arm64-mm-move-protection_map-inside-the-platform.patch
x86-mm-move-protection_map-inside-the-platform.patch
mm-mmap-build-protect-protection_map-with-arch_has_vm_get_page_prot.patch
microblaze-mm-enable-arch_has_vm_get_page_prot.patch
loongarch-mm-enable-arch_has_vm_get_page_prot.patch
openrisc-mm-enable-arch_has_vm_get_page_prot.patch
xtensa-mm-enable-arch_has_vm_get_page_prot.patch
hexagon-mm-enable-arch_has_vm_get_page_prot.patch
parisc-mm-enable-arch_has_vm_get_page_prot.patch
alpha-mm-enable-arch_has_vm_get_page_prot.patch
nios2-mm-enable-arch_has_vm_get_page_prot.patch
riscv-mm-enable-arch_has_vm_get_page_prot.patch
csky-mm-enable-arch_has_vm_get_page_prot.patch
s390-mm-enable-arch_has_vm_get_page_prot.patch
ia64-mm-enable-arch_has_vm_get_page_prot.patch
mips-mm-enable-arch_has_vm_get_page_prot.patch
m68k-mm-enable-arch_has_vm_get_page_prot.patch
arc-mm-enable-arch_has_vm_get_page_prot.patch
arm-mm-enable-arch_has_vm_get_page_prot.patch
um-mm-enable-arch_has_vm_get_page_prot.patch
sh-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_has_vm_get_page_prot.patch

