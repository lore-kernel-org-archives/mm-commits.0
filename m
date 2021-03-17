Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A2EC4332E
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F129164F62
	for <mm-commits@archiver.kernel.org>; Wed, 17 Mar 2021 23:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbhCQXEI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 19:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhCQXDw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 19:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1595864F3B;
        Wed, 17 Mar 2021 23:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616022232;
        bh=f1kq8ME08H1ChmAIKcyEl6F+m8ucGC4fyaIWYUxo/c8=;
        h=Date:From:To:Subject:From;
        b=FdY7V4lucwdHJZMsyVGvtTTsbWSVR14+2+5RgTEgGitz6AbBPNpznYd6AxtE59ssS
         /NWyd/EFHxh8R0biMt0M/6MB+g7B+YkdgdsLAeljRb/Lcg7uR1JyjhP51Mx3WQPby2
         tJROEW2qITw4qhEA83K+4KiHm42Y6RCWLYNQrR0Q=
Date:   Wed, 17 Mar 2021 16:03:51 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, catalin.marinas@arm.com, dingtianhong@huawei.com,
        hch@lst.de, hpa@zytor.com, linmiaohe@huawei.com,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        tglx@linutronix.de, urezki@gmail.com, will@kernel.org
Subject:  + x86-inline-huge-vmap-supported-functions.patch added to
 -mm tree
Message-ID: <20210317230351.IyEQx3R2U%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: x86: inline huge vmap supported functions
has been added to the -mm tree.  Its filename is
     x86-inline-huge-vmap-supported-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/x86-inline-huge-vmap-supported-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/x86-inline-huge-vmap-supported-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: x86: inline huge vmap supported functions

This allows unsupported levels to be constant folded away, and so
p4d_free_pud_page can be removed because it's no longer linked to.

Link: https://lkml.kernel.org/r/20210317062402.533919-10-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/vmalloc.h |   22 +++++++++++++++++++---
 arch/x86/mm/ioremap.c          |   21 ---------------------
 arch/x86/mm/pgtable.c          |   13 -------------
 3 files changed, 19 insertions(+), 37 deletions(-)

--- a/arch/x86/include/asm/vmalloc.h~x86-inline-huge-vmap-supported-functions
+++ a/arch/x86/include/asm/vmalloc.h
@@ -1,13 +1,29 @@
 #ifndef _ASM_X86_VMALLOC_H
 #define _ASM_X86_VMALLOC_H
 
+#include <asm/cpufeature.h>
 #include <asm/page.h>
 #include <asm/pgtable_areas.h>
 
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
+#ifdef CONFIG_X86_64
+	return boot_cpu_has(X86_FEATURE_GBPAGES);
+#else
+	return false;
+#endif
+}
+
+static inline bool arch_vmap_pmd_supported(pgprot_t prot)
+{
+	return boot_cpu_has(X86_FEATURE_PSE);
+}
 #endif
 
 #endif /* _ASM_X86_VMALLOC_H */
--- a/arch/x86/mm/ioremap.c~x86-inline-huge-vmap-supported-functions
+++ a/arch/x86/mm/ioremap.c
@@ -481,27 +481,6 @@ void iounmap(volatile void __iomem *addr
 }
 EXPORT_SYMBOL(iounmap);
 
-#ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
-bool arch_vmap_p4d_supported(pgprot_t prot)
-{
-	return false;
-}
-
-bool arch_vmap_pud_supported(pgprot_t prot)
-{
-#ifdef CONFIG_X86_64
-	return boot_cpu_has(X86_FEATURE_GBPAGES);
-#else
-	return false;
-#endif
-}
-
-bool arch_vmap_pmd_supported(pgprot_t prot)
-{
-	return boot_cpu_has(X86_FEATURE_PSE);
-}
-#endif
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
--- a/arch/x86/mm/pgtable.c~x86-inline-huge-vmap-supported-functions
+++ a/arch/x86/mm/pgtable.c
@@ -780,14 +780,6 @@ int pmd_clear_huge(pmd_t *pmd)
 	return 0;
 }
 
-/*
- * Until we support 512GB pages, skip them in the vmap area.
- */
-int p4d_free_pud_page(p4d_t *p4d, unsigned long addr)
-{
-	return 0;
-}
-
 #ifdef CONFIG_X86_64
 /**
  * pud_free_pmd_page - Clear pud entry and free pmd page.
@@ -861,11 +853,6 @@ int pmd_free_pte_page(pmd_t *pmd, unsign
 
 #else /* !CONFIG_X86_64 */
 
-int pud_free_pmd_page(pud_t *pud, unsigned long addr)
-{
-	return pud_none(*pud);
-}
-
 /*
  * Disable free page handling on x86-PAE. This assures that ioremap()
  * does not update sync'd pmd entries. See vmalloc_sync_one().
_

Patches currently in -mm which might be from npiggin@gmail.com are

arm-mm-add-missing-pud_page-define-to-2-level-page-tables.patch
mm-vmalloc-fix-huge_vmap-regression-by-enabling-huge-pages-in-vmalloc_to_page.patch
mm-apply_to_pte_range-warn-and-fail-if-a-large-pte-is-encountered.patch
mm-vmalloc-rename-vmap__range-vmap_pages__range.patch
mm-ioremap-rename-ioremap__range-to-vmap__range.patch
mm-huge_vmap-arch-support-cleanup.patch
powerpc-inline-huge-vmap-supported-functions.patch
arm64-inline-huge-vmap-supported-functions.patch
x86-inline-huge-vmap-supported-functions.patch
mm-vmalloc-provide-fallback-arch-huge-vmap-support-functions.patch
mm-move-vmap_range-from-mm-ioremapc-to-mm-vmallocc.patch
mm-vmalloc-add-vmap_range_noflush-variant.patch
mm-vmalloc-hugepage-vmalloc-mappings.patch
powerpc-64s-radix-enable-huge-vmalloc-mappings.patch

