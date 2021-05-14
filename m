Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34F61C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 129CD61446
	for <mm-commits@archiver.kernel.org>; Fri, 14 May 2021 21:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhENVnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 17:43:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhENVnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 17:43:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B454E613C1;
        Fri, 14 May 2021 21:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621028557;
        bh=AnDMkrnb9un7rv9kHsfhw48qXXuNUnafqyazWmUZJzM=;
        h=Date:From:To:Subject:From;
        b=iRHofILk+5VIGhasHWw3Wj/wuEkAtHeuhrn5fff6+V9YWH6v9FEqqriSBweMO2kNO
         f/xAObciV+JZri/MEozYuOJ8LuwI30+OCfNdUPH+zdfPPw2hU1dKnnkHLF+N2+pWOe
         6oY15nAtCNLMnKFDoUM0Ltx6jGQO++/yqe8xQbH0=
Date:   Fri, 14 May 2021 14:42:37 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naresh.kamboju@linaro.org,
        npiggin@gmail.com, rppt@kernel.org
Subject:  +
 arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch added to -mm
 tree
Message-ID: <20210514214237.bJN9YxTr5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: define only {pud/pmd}_{set/clear}_huge when usefull
has been added to the -mm tree.  Its filename is
     arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: arm64: define only {pud/pmd}_{set/clear}_huge when usefull

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
@@ -1337,6 +1337,7 @@ void *__init fixmap_remap_fdt(phys_addr_
 	return dt_virt;
 }
 
+#if CONFIG_PGTABLE_LEVELS > 3
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
 {
 	pud_t new_pud = pfn_pud(__phys_to_pfn(phys), mk_pud_sect_prot(prot));
@@ -1351,6 +1352,16 @@ int pud_set_huge(pud_t *pudp, phys_addr_
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
@@ -1365,14 +1376,6 @@ int pmd_set_huge(pmd_t *pmdp, phys_addr_
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
@@ -1380,6 +1383,7 @@ int pmd_clear_huge(pmd_t *pmdp)
 	pmd_clear(pmdp);
 	return 1;
 }
+#endif
 
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-ioremap-fix-iomap_max_page_shift.patch
mm-hugetlb-change-parameters-of-arch_make_huge_pte.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge.patch
mm-pgtable-add-stubs-for-pmd-pub_set-clear_huge-fix-2.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmap.patch
mm-vmalloc-enable-mapping-of-huge-pages-at-pte-level-in-vmalloc.patch
powerpc-8xx-add-support-for-huge-pages-on-vmap-and-vmalloc.patch
arm64-define-only-pud-pmd_set-clear_huge-when-usefull.patch

