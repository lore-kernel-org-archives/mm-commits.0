Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C4CC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A3661466
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238370AbhGABue (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhGABud (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:50:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E298E61090;
        Thu,  1 Jul 2021 01:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104084;
        bh=W04BZQyHI8Y3cnY8wTCOhMWigds5hckFeLoTe4oVIRQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BK1wRMW7+OMItAfYulA4yPOaEw/LjA9PjA/jNEYhfJolzoN8Kbihvuo6Wq0wvjSOD
         Jl1+nsFvYYshMML9f/05LnEuCUDCoKzoxxY489fb/qzqYjGPEu8t6zjYXQXxYJHN5+
         zPt1vBwuYYaf3/PMD7bXToiCmy2FR0x3rRKYJCIM=
Date:   Wed, 30 Jun 2021 18:48:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        christophe.leroy@csgroup.eu, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, naresh.kamboju@linaro.org, npiggin@gmail.com,
        paulus@samba.org, rppt@kernel.org, torvalds@linux-foundation.org,
        uladzislau.rezki@sony.com
Subject:  [patch 018/192] mm/pgtable: add stubs for
 {pmd/pub}_{set/clear}_huge
Message-ID: <20210701014803.NuCUAlJTH%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/pgtable: add stubs for {pmd/pub}_{set/clear}_huge

For architectures with no PMD and/or no PUD, add stubs similar to what we
have for architectures without P4D.

[christophe.leroy@csgroup.eu: arm64: define only {pud/pmd}_{set/clear}_huge when useful]
  Link: https://lkml.kernel.org/r/73ec95f40cafbbb69bdfb43a7f53876fd845b0ce.1620990479.git.christophe.leroy@csgroup.eu
[christophe.leroy@csgroup.eu: x86: define only {pud/pmd}_{set/clear}_huge when useful]
  Link: https://lkml.kernel.org/r/7fbf1b6bc3e15c07c24fa45278d57064f14c896b.1620930415.git.christophe.leroy@csgroup.eu
Link: https://lkml.kernel.org/r/5ac5976419350e8e048d463a64cae449eb3ba4b0.1620795204.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Uladzislau Rezki <uladzislau.rezki@sony.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c     |   20 ++++++++++++--------
 arch/x86/mm/pgtable.c   |   34 +++++++++++++++++++---------------
 include/linux/pgtable.h |   26 +++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 24 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge
+++ a/arch/arm64/mm/mmu.c
@@ -1338,6 +1338,7 @@ void *__init fixmap_remap_fdt(phys_addr_
 	return dt_virt;
 }
 
+#if CONFIG_PGTABLE_LEVELS > 3
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 {
 	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
@@ -1352,6 +1353,16 @@ int pud_set_huge(pud_t *pudp, phys_addr_
 	return 1;
 }
 
+int pud_clear_huge(pud_t *pudp)
+{
+	if (!pud_sect(READ_ONCE(*pudp)))
+		return 0;
+	pud_clear(pudp);
+	return 1;
+}
+#endif
+
+#if CONFIG_PGTABLE_LEVELS > 2
 int pmd_set_huge(pmd_t *pmdp, phys_addr_t phys, pgprot_t prot)
 {
 	pmd_t new_pmd = pfn_pmd(__phys_to_pfn(phys), mk_pmd_sect_prot(prot));
@@ -1366,14 +1377,6 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_
 	return 1;
 }
 
-int pud_clear_huge(pud_t *pudp)
-{
-	if (!pud_sect(READ_ONCE(*pudp)))
-		return 0;
-	pud_clear(pudp);
-	return 1;
-}
-
 int pmd_clear_huge(pmd_t *pmdp)
 {
 	if (!pmd_sect(READ_ONCE(*pmdp)))
@@ -1381,6 +1384,7 @@ int pmd_clear_huge(pmd_t *pmdp)
 	pmd_clear(pmdp);
 	return 1;
 }
+#endif
 
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
--- a/arch/x86/mm/pgtable.c~mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge
+++ a/arch/x86/mm/pgtable.c
@@ -682,6 +682,7 @@ int p4d_clear_huge(p4d_t *p4d)
 }
 #endif
 
+#if CONFIG_PGTABLE_LEVELS > 3
 /**
  * pud_set_huge - setup kernel PUD mapping
  *
@@ -721,6 +722,23 @@ int pud_set_huge(pud_t *pud, phys_addr_t
 }
 
 /**
+ * pud_clear_huge - clear kernel PUD mapping when it is set
+ *
+ * Returns 1 on success and 0 on failure (no PUD map is found).
+ */
+int pud_clear_huge(pud_t *pud)
+{
+	if (pud_large(*pud)) {
+		pud_clear(pud);
+		return 1;
+	}
+
+	return 0;
+}
+#endif
+
+#if CONFIG_PGTABLE_LEVELS > 2
+/**
  * pmd_set_huge - setup kernel PMD mapping
  *
  * See text over pud_set_huge() above.
@@ -751,21 +769,6 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t
 }
 
 /**
- * pud_clear_huge - clear kernel PUD mapping when it is set
- *
- * Returns 1 on success and 0 on failure (no PUD map is found).
- */
-int pud_clear_huge(pud_t *pud)
-{
-	if (pud_large(*pud)) {
-		pud_clear(pud);
-		return 1;
-	}
-
-	return 0;
-}
-
-/**
  * pmd_clear_huge - clear kernel PMD mapping when it is set
  *
  * Returns 1 on success and 0 on failure (no PMD map is found).
@@ -779,6 +782,7 @@ int pmd_clear_huge(pmd_t *pmd)
 
 	return 0;
 }
+#endif
 
 #ifdef CONFIG_X86_64
 /**
--- a/include/linux/pgtable.h~mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge
+++ a/include/linux/pgtable.h
@@ -1379,10 +1379,34 @@ static inline int p4d_clear_huge(p4d_t *
 }
 #endif /* !__PAGETABLE_P4D_FOLDED */
 
+#ifndef __PAGETABLE_PUD_FOLDED
 int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot);
-int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
 int pud_clear_huge(pud_t *pud);
+#else
+static inline int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int pud_clear_huge(pud_t *pud)
+{
+	return 0;
+}
+#endif /* !__PAGETABLE_PUD_FOLDED */
+
+#ifndef __PAGETABLE_PMD_FOLDED
+int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot);
 int pmd_clear_huge(pmd_t *pmd);
+#else
+static inline int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
+{
+	return 0;
+}
+static inline int pmd_clear_huge(pmd_t *pmd)
+{
+	return 0;
+}
+#endif /* !__PAGETABLE_PMD_FOLDED */
+
 int p4d_free_pud_page(p4d_t *p4d, unsigned long addr);
 int pud_free_pmd_page(pud_t *pud, unsigned long addr);
 int pmd_free_pte_page(pmd_t *pmd, unsigned long addr);
_
