Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E02C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F7261426
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbhEHWnx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWnx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE4F26141E;
        Sat,  8 May 2021 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513771;
        bh=f1/W8OtWfw7UD6zmRPSp6kbc6mD73dKenWJtCzitWbw=;
        h=Date:From:To:Subject:From;
        b=uIH8rTMsVxyq8myvfawh7jeyYmpZZPVXtRLLYYqi5+jXFz3YYmU1Hd5zXAgqYtcfF
         09v7dQlrv7/JAtqJ2ZNJ+HMHSA/WackOGWfwoKMQQczC9a1PMRAjkmYe7N1VwDv9/N
         hDA6Lf6sYgu34NIPCkQhvrPRiYKLM1epf1ugI/Ok=
Date:   Sat, 08 May 2021 15:42:50 -0700
From:   akpm@linux-foundation.org
To:     bp@alien8.de, catalin.marinas@arm.com, dingtianhong@huawei.com,
        hch@lst.de, hpa@zytor.com, linmiaohe@huawei.com,
        linux@armlinux.org.uk, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
        tglx@linutronix.de, urezki@gmail.com, will@kernel.org
Subject:  [merged]
 powerpc-inline-huge-vmap-supported-functions.patch removed from -mm tree
Message-ID: <20210508224250.6loF9WTu5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: inline huge vmap supported functions
has been removed from the -mm tree.  Its filename was
     powerpc-inline-huge-vmap-supported-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Piggin <npiggin@gmail.com>
Subject: powerpc: inline huge vmap supported functions

This allows unsupported levels to be constant folded away, and so
p4d_free_pud_page can be removed because it's no longer linked to.

Link: https://lkml.kernel.org/r/20210317062402.533919-8-npiggin@gmail.com
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ding Tianhong <dingtianhong@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/vmalloc.h       |   19 ++++++++++++++++---
 arch/powerpc/mm/book3s64/radix_pgtable.c |   21 ---------------------
 2 files changed, 16 insertions(+), 24 deletions(-)

--- a/arch/powerpc/include/asm/vmalloc.h~powerpc-inline-huge-vmap-supported-functions
+++ a/arch/powerpc/include/asm/vmalloc.h
@@ -1,12 +1,25 @@
 #ifndef _ASM_POWERPC_VMALLOC_H
 #define _ASM_POWERPC_VMALLOC_H
 
+#include <asm/mmu.h>
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
+	/* HPT does not cope with large pages in the vmalloc area */
+	return radix_enabled();
+}
+
+static inline bool arch_vmap_pmd_supported(pgprot_t prot)
+{
+	return radix_enabled();
+}
 #endif
 
 #endif /* _ASM_POWERPC_VMALLOC_H */
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-inline-huge-vmap-supported-functions
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1082,22 +1082,6 @@ void radix__ptep_modify_prot_commit(stru
 	set_pte_at(mm, addr, ptep, pte);
 }
 
-bool arch_vmap_pud_supported(pgprot_t prot)
-{
-	/* HPT does not cope with large pages in the vmalloc area */
-	return radix_enabled();
-}
-
-bool arch_vmap_pmd_supported(pgprot_t prot)
-{
-	return radix_enabled();
-}
-
-int p4d_free_pud_page(p4d_t *p4d, unsigned long addr)
-{
-	return 0;
-}
-
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 {
 	pte_t *ptep = (pte_t *)pud;
@@ -1181,8 +1165,3 @@ int pmd_free_pte_page(pmd_t *pmd, unsign
 
 	return 1;
 }
-
-bool arch_vmap_p4d_supported(pgprot_t prot)
-{
-	return false;
-}
_

Patches currently in -mm which might be from npiggin@gmail.com are


