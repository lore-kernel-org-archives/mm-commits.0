Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF0DC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:50:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ABAE6124B
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbhGAAw6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:52:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232066AbhGAAw5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:52:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECEC961424;
        Thu,  1 Jul 2021 00:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100627;
        bh=BMEi7p8xJs26l0Sj9EWab6A6fl2beCw2pdkSowRfQLQ=;
        h=Date:From:To:Subject:From;
        b=u7pmfq+Gewmro8FAvSY3Iybg7k71dl3ksodWg7aT0u60PTMW9mucY8IQ9Y5kc5C3a
         IVfzbM119871f+NLXjKq6LyypHZ8f5mF1n4rEZLP6IvdfPpRFEkMep1wapSWxc+vBM
         knE3fOJKdFcSi0RSLN+B/IF5VGqaICkEWlqcrtrY=
Date:   Wed, 30 Jun 2021 17:50:26 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        npiggin@gmail.com, rppt@kernel.org
Subject:  [folded-merged]
 arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch removed from
 -mm tree
Message-ID: <20210701005026.9k94Pkqh5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: define only {pud/pmd}_{set/clear}_huge when useful
has been removed from the -mm tree.  Its filename was
     arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch

This patch was dropped because it was folded into mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: arm64: define only {pud/pmd}_{set/clear}_huge when useful

When PUD and/or PMD are folded, those functions are useless
and we now have a stub in linux/pgtable.h

Link: https://lkml.kernel.org/r/73ec95f40cafbbb69bdfb43a7f53876fd845b0ce.1620990479.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/mmu.c~arm64-define-only-pud-pmd_set-clear_huge-when-usefull
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
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-pagewalk-fix-walk-for-hugepage-tables.patch
mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch

