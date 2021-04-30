Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDCAC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EAFC61463
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhD3F7W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:52546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhD3F7V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F59B61480;
        Fri, 30 Apr 2021 05:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762314;
        bh=Ph63gHyCYtBxBygHRgaEupWsWMrVvgT4fDSpv3Q4+gw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=dA4ALOvQQ87nRDnkhZ/xj787UL0UxlYQ66si3gWuvPPzAnU9FhHPtyBiJFwkVSCZy
         w7zow1UTEtXDYYM0KIu5nKmPMxxy3yjrCYWUMmEio78GGwEecFnZTs466xvGKeTmX2
         ufHFOWjJOURZKTH7J/YIY2mTQN38LZtqJYAD1B+c=
Date:   Thu, 29 Apr 2021 22:58:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bp@alien8.de, catalin.marinas@arm.com,
        dingtianhong@huawei.com, hch@lst.de, hpa@zytor.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, linux@armlinux.org.uk,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        npiggin@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, urezki@gmail.com, will@kernel.org
Subject:  [patch 104/178] arm64: inline huge vmap supported
 functions
Message-ID: <20210430055833.FzOouQl2s%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>
Subject: arm64: inline huge vmap supported functions

This allows unsupported levels to be constant folded away, and so
p4d_free_pud_page can be removed because it's no longer linked to.

Link: https://lkml.kernel.org/r/20210317062402.533919-9-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/vmalloc.h |   23 ++++++++++++++++++++---
 arch/arm64/mm/mmu.c              |   26 --------------------------
 2 files changed, 20 insertions(+), 29 deletions(-)

--- a/arch/arm64/include/asm/vmalloc.h~arm64-inline-huge-vmap-supported-functions
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -4,9 +4,26 @@
 #include <asm/page.h>
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-bool arch_vmap_p4d_supported(pgprot_t prot);
-bool arch_vmap_pud_supported(pgprot_t prot);
-bool arch_vmap_pmd_supported(pgprot_t prot);
+static inline bool arch_vmap_p4d_supported(pgprot_t prot)
+{
+	return false;
+}
+
+static inline bool arch_vmap_pud_supported(pgprot_t prot)
+{
+	/*
+	 * Only 4k granule supports level 1 block mappings.
+	 * SW table walks can't handle removal of intermediate entries.
+	 */
+	return IS_ENABLED(CONFIG_ARM64_4K_PAGES) &&
+	       !IS_ENABLED(CONFIG_PTDUMP_DEBUGFS);
+}
+
+static inline bool arch_vmap_pmd_supported(pgprot_t prot)
+{
+	/* See arch_vmap_pud_supported() */
+	return !IS_ENABLED(CONFIG_PTDUMP_DEBUGFS);
+}
 #endif
 
 #endif /* _ASM_ARM64_VMALLOC_H */
--- a/arch/arm64/mm/mmu.c~arm64-inline-huge-vmap-supported-functions
+++ a/arch/arm64/mm/mmu.c
@@ -1339,27 +1339,6 @@ void *__init fixmap_remap_fdt(phys_addr_
 	return dt_virt;
 }
 
-bool arch_vmap_p4d_supported(pgprot_t prot)
-{
-	return false;
-}
-
-bool arch_vmap_pud_supported(pgprot_t prot)
-{
-	/*
-	 * Only 4k granule supports level 1 block mappings.
-	 * SW table walks can't handle removal of intermediate entries.
-	 */
-	return IS_ENABLED(CONFIG_ARM64_4K_PAGES) &&
-	       !IS_ENABLED(CONFIG_PTDUMP_DEBUGFS);
-}
-
-bool arch_vmap_pmd_supported(pgprot_t prot)
-{
-	/* See arch_vmap_pud_supported() */
-	return !IS_ENABLED(CONFIG_PTDUMP_DEBUGFS);
-}
-
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 {
 	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
@@ -1451,11 +1430,6 @@ int pud_free_pmd_page(pud_t *pudp, unsig
 	return 1;
 }
 
-int p4d_free_pud_page(p4d_t *p4d, unsigned long addr)
-{
-	return 0;	/* Don't attempt a block mapping */
-}
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 static void __remove_pgd_mapping(pgd_t *pgdir, unsigned long start, u64 size)
 {
_
