Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45266C35273
	for <mm-commits@archiver.kernel.org>; Thu, 14 Apr 2022 21:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346820AbiDNVMh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Apr 2022 17:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346811AbiDNVMg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Apr 2022 17:12:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6A3483B1
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 14:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EBA061FF2
        for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2022 21:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F212EC385A5;
        Thu, 14 Apr 2022 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649970609;
        bh=d5yBZ0yJSyxDTzWqZZDpkNTWhJR0HxLJ/7cDfoHBRLo=;
        h=Date:To:From:Subject:From;
        b=gRR03QrzfmMl4xApWYSOS5cjwGYw5CphEXHrvYZuawAznf+oxd2Zbh6WR3jGymDYk
         Pjvf8aGI0iX0gkHPxuRbMkny76yWhD0TO/zKOHyW+8XTvLulgKSfe/BbWJMbwv4Bn9
         rJ9rAwEb9WLqpGVTIujgeC/WWjLYhsp4xTAbIysk=
Date:   Thu, 14 Apr 2022 14:10:08 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
        paulus@samba.org, mpe@ellerman.id.au, mingo@redhat.com,
        khalid.aziz@oracle.com, hch@infradead.org, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-enable-arch_has_vm_get_page_prot.patch added to -mm tree
Message-Id: <20220414211008.F212EC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/mm: enable ARCH_HAS_VM_GET_PAGE_PROT
has been added to the -mm tree.  Its filename is
     arm64-mm-enable-arch_has_vm_get_page_prot.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-enable-arch_has_vm_get_page_prot.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-enable-arch_has_vm_get_page_prot.patch

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
Subject: arm64/mm: enable ARCH_HAS_VM_GET_PAGE_PROT

This defines and exports a platform specific custom vm_get_page_prot() via
subscribing ARCH_HAS_VM_GET_PAGE_PROT. It localizes arch_vm_get_page_prot()
and moves it near vm_get_page_prot().

Link: https://lkml.kernel.org/r/20220414062125.609297-4-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/arm64/include/asm/mman.h~arm64-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm64/include/asm/mman.h
@@ -35,30 +35,6 @@ static inline unsigned long arch_calc_vm
 }
 #define arch_calc_vm_flag_bits(flags) arch_calc_vm_flag_bits(flags)
 
-static inline pgprot_t arch_vm_get_page_prot(unsigned long vm_flags)
-{
-	pteval_t prot = 0;
-
-	if (vm_flags & VM_ARM64_BTI)
-		prot |= PTE_GP;
-
-	/*
-	 * There are two conditions required for returning a Normal Tagged
-	 * memory type: (1) the user requested it via PROT_MTE passed to
-	 * mmap() or mprotect() and (2) the corresponding vma supports MTE. We
-	 * register (1) as VM_MTE in the vma->vm_flags and (2) as
-	 * VM_MTE_ALLOWED. Note that the latter can only be set during the
-	 * mmap() call since mprotect() does not accept MAP_* flags.
-	 * Checking for VM_MTE only is sufficient since arch_validate_flags()
-	 * does not permit (VM_MTE & !VM_MTE_ALLOWED).
-	 */
-	if (vm_flags & VM_MTE)
-		prot |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
-
-	return __pgprot(prot);
-}
-#define arch_vm_get_page_prot(vm_flags) arch_vm_get_page_prot(vm_flags)
-
 static inline bool arch_validate_prot(unsigned long prot,
 	unsigned long addr __always_unused)
 {
--- a/arch/arm64/Kconfig~arm64-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm64/Kconfig
@@ -45,6 +45,7 @@ config ARM64
 	select ARCH_HAS_SYSCALL_WRAPPER
 	select ARCH_HAS_TEARDOWN_DMA_OPS if IOMMU_SUPPORT
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_VM_GET_PAGE_PROT
 	select ARCH_HAS_ZONE_DMA_SET if EXPERT
 	select ARCH_HAVE_ELF_PROT
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
--- a/arch/arm64/mm/mmap.c~arm64-mm-enable-arch_has_vm_get_page_prot
+++ a/arch/arm64/mm/mmap.c
@@ -55,3 +55,28 @@ static int __init adjust_protection_map(
 	return 0;
 }
 arch_initcall(adjust_protection_map);
+
+pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	pteval_t prot = pgprot_val(protection_map[vm_flags &
+				   (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]);
+
+	if (vm_flags & VM_ARM64_BTI)
+		prot |= PTE_GP;
+
+	/*
+	 * There are two conditions required for returning a Normal Tagged
+	 * memory type: (1) the user requested it via PROT_MTE passed to
+	 * mmap() or mprotect() and (2) the corresponding vma supports MTE. We
+	 * register (1) as VM_MTE in the vma->vm_flags and (2) as
+	 * VM_MTE_ALLOWED. Note that the latter can only be set during the
+	 * mmap() call since mprotect() does not accept MAP_* flags.
+	 * Checking for VM_MTE only is sufficient since arch_validate_flags()
+	 * does not permit (VM_MTE & !VM_MTE_ALLOWED).
+	 */
+	if (vm_flags & VM_MTE)
+		prot |= PTE_ATTRINDX(MT_NORMAL_TAGGED);
+
+	return __pgprot(prot);
+}
+EXPORT_SYMBOL(vm_get_page_prot);
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug_vm_pgtable-drop-protection_map-usage.patch
mm-mmap-clarify-protection_map-indices.patch
mm-mmap-add-new-config-arch_has_vm_get_page_prot.patch
powerpc-mm-enable-arch_has_vm_get_page_prot.patch
arm64-mm-enable-arch_has_vm_get_page_prot.patch
sparc-mm-enable-arch_has_vm_get_page_prot.patch
mm-mmap-drop-arch_filter_pgprot.patch
mm-mmap-drop-arch_vm_get_page_pgprot.patch

