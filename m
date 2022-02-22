Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC87C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 22 Feb 2022 03:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiBVDNt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Feb 2022 22:13:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiBVDNp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Feb 2022 22:13:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F855FA8
        for <mm-commits@vger.kernel.org>; Mon, 21 Feb 2022 19:13:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AFC5B80AEA
        for <mm-commits@vger.kernel.org>; Tue, 22 Feb 2022 03:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3142C340E9;
        Tue, 22 Feb 2022 03:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645499595;
        bh=txIyhDYraol6lXpsFxEcDcVfHaYhcdhDfU+UzEeVidA=;
        h=Date:To:From:Subject:From;
        b=jU14ViIS0n3Uu5J1GKJ2eRTmE1Z1P1WT/6xCJNiVXxnUD3ZaMSsAXA9Jfdu2o1WZA
         3+CLkL1ZiEo73zHKagUVrS8HwbSdfuHrExynFwwI1cOgM3hP6TTBOq6Tvb1w2w6fne
         OoXaEvsXV1v8e3esQzlz7GmPPFYwbK9CXC6OkEHs=
Date:   Mon, 21 Feb 2022 19:13:14 -0800
To:     mm-commits@vger.kernel.org, linux@armlinux.org.uk, arnd@arndb.de,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220222031314.D3142C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     arm-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: arm/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT.  Subsequently all __SXXX and __PXXX
macros can be dropped which are no longer needed.

Link: https://lkml.kernel.org/r/1645425519-9034-10-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig                   |    1 
 arch/arm/include/asm/pgtable.h     |   18 -----------
 arch/arm/lib/uaccess_with_memcpy.c |    2 -
 arch/arm/mm/mmu.c                  |   44 +++++++++++++++++++++++----
 4 files changed, 40 insertions(+), 25 deletions(-)

--- a/arch/arm/include/asm/pgtable.h~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/include/asm/pgtable.h
@@ -137,24 +137,6 @@ extern pgprot_t phys_mem_access_prot(str
  *  2) If we could do execute protection, then read is implied
  *  3) write implies read permissions
  */
-#define __P000  __PAGE_NONE
-#define __P001  __PAGE_READONLY
-#define __P010  __PAGE_COPY
-#define __P011  __PAGE_COPY
-#define __P100  __PAGE_READONLY_EXEC
-#define __P101  __PAGE_READONLY_EXEC
-#define __P110  __PAGE_COPY_EXEC
-#define __P111  __PAGE_COPY_EXEC
-
-#define __S000  __PAGE_NONE
-#define __S001  __PAGE_READONLY
-#define __S010  __PAGE_SHARED
-#define __S011  __PAGE_SHARED
-#define __S100  __PAGE_READONLY_EXEC
-#define __S101  __PAGE_READONLY_EXEC
-#define __S110  __PAGE_SHARED_EXEC
-#define __S111  __PAGE_SHARED_EXEC
-
 #ifndef __ASSEMBLY__
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
--- a/arch/arm/Kconfig~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/Kconfig
@@ -23,6 +23,7 @@ config ARM
 	select ARCH_HAS_SYNC_DMA_FOR_CPU if SWIOTLB || !MMU
 	select ARCH_HAS_TEARDOWN_DMA_OPS if MMU
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if CPU_V7 || CPU_V7M || CPU_V6K
 	select ARCH_HAS_GCOV_PROFILE_ALL
--- a/arch/arm/lib/uaccess_with_memcpy.c~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -247,7 +247,7 @@ static int __init test_size_treshold(voi
 	if (!dst_page)
 		goto no_dst;
 	kernel_ptr = page_address(src_page);
-	user_ptr = vmap(&dst_page, 1, VM_IOREMAP, __pgprot(__P010));
+	user_ptr = vmap(&dst_page, 1, VM_IOREMAP, __pgprot(__PAGE_COPY));
 	if (!user_ptr)
 		goto no_vmap;
 
--- a/arch/arm/mm/mmu.c~arm-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm/mm/mmu.c
@@ -403,6 +403,8 @@ void __set_fixmap(enum fixed_addresses i
 	local_flush_tlb_kernel_range(vaddr, vaddr + PAGE_SIZE);
 }
 
+static pteval_t user_pgprot;
+
 /*
  * Adjust the PMD section entries according to the CPU in use.
  */
@@ -410,7 +412,7 @@ static void __init build_mem_type_table(
 {
 	struct cachepolicy *cp;
 	unsigned int cr = get_cr();
-	pteval_t user_pgprot, kern_pgprot, vecs_pgprot;
+	pteval_t kern_pgprot, vecs_pgprot;
 	int cpu_arch = cpu_architecture();
 	int i;
 
@@ -627,11 +629,6 @@ static void __init build_mem_type_table(
 	user_pgprot |= PTE_EXT_PXN;
 #endif
 
-	for (i = 0; i < 16; i++) {
-		pteval_t v = pgprot_val(protection_map[i]);
-		protection_map[i] = __pgprot(v | user_pgprot);
-	}
-
 	mem_types[MT_LOW_VECTORS].prot_pte |= vecs_pgprot;
 	mem_types[MT_HIGH_VECTORS].prot_pte |= vecs_pgprot;
 
@@ -670,6 +667,41 @@ static void __init build_mem_type_table(
 	}
 }
 
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	switch (vm_flags & (VM_READ | VM_WRITE | VM_EXEC | VM_SHARED)) {
+	case VM_NONE:
+		return __pgprot(pgprot_val(__PAGE_NONE) | user_pgprot);
+	case VM_READ:
+		return __pgprot(pgprot_val(__PAGE_READONLY) | user_pgprot);
+	case VM_WRITE:
+	case VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(__PAGE_COPY) | user_pgprot);
+	case VM_EXEC:
+	case VM_EXEC | VM_READ:
+		return __pgprot(pgprot_val(__PAGE_READONLY_EXEC) | user_pgprot);
+	case VM_EXEC | VM_WRITE:
+	case VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(__PAGE_COPY_EXEC) | user_pgprot);
+	case VM_SHARED:
+		return __pgprot(pgprot_val(__PAGE_NONE) | user_pgprot);
+	case VM_SHARED | VM_READ:
+		return __pgprot(pgprot_val(__PAGE_READONLY) | user_pgprot);
+	case VM_SHARED | VM_WRITE:
+	case VM_SHARED | VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(__PAGE_SHARED) | user_pgprot);
+	case VM_SHARED | VM_EXEC:
+	case VM_SHARED | VM_EXEC | VM_READ:
+		return __pgprot(pgprot_val(__PAGE_READONLY_EXEC) | user_pgprot);
+	case VM_SHARED | VM_EXEC | VM_WRITE:
+	case VM_SHARED | VM_EXEC | VM_WRITE | VM_READ:
+		return __pgprot(pgprot_val(__PAGE_SHARED_EXEC) | user_pgprot);
+	default:
+		BUILD_BUG();
+	}
+}
+EXPORT_SYMBOL(vm_get_page_prot);
+
 #ifdef CONFIG_ARM_DMA_MEM_BUFFERABLE
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
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

