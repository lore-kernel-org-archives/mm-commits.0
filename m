Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F4DC43219
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 20:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392444AbiDUUj1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392438AbiDUUj1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 16:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA354DF4C
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 13:36:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6378C61D7E
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 20:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA2FC385A1;
        Thu, 21 Apr 2022 20:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650573394;
        bh=+DP0+C34TUXuU0L1O7yD/ZkrynIwi/8DZK7YPy8Acwc=;
        h=Date:To:From:Subject:From;
        b=AGYDDR52HzPiGLlJRG6dYIumZbgyr8pps00DpIw/PDwT1m2DKbFBHa7XaQzNiYdQz
         jRaI5oGXqx7wJ/Yv8QkWAxzo8VLip9xMhcEMwQaO68f9wfXa5fevv1yVv9t6PEbCD9
         8AZlMFwgdP+SIyy5YBx98SWubymK3TOyxbn/VicQ=
Date:   Thu, 21 Apr 2022 13:36:34 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, tglx@linutronix.de,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, mingo@redhat.com, hpa@zytor.com,
        guohanjun@huawei.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, aou@eecs.berkeley.edu,
        anshuman.khandual@arm.com, tongtiangen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-add-hooks-to-public-helpers.patch added to -mm tree
Message-Id: <20220421203634.BDA2FC385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_table_check: add hooks to public helpers
has been added to the -mm tree.  Its filename is
     mm-page_table_check-add-hooks-to-public-helpers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_table_check-add-hooks-to-public-helpers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_table_check-add-hooks-to-public-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: mm: page_table_check: add hooks to public helpers

Move ptep_clear() to the include/linux/pgtable.h and add page table check
relate hooks to some helpers, it's prepare for support page table check
feature on new architecture.

Link: https://lkml.kernel.org/r/20220421082042.1167967-4-tongtiangen@huawei.com
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   10 ----------
 include/linux/pgtable.h        |   26 ++++++++++++++++++--------
 2 files changed, 18 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-add-hooks-to-public-helpers
+++ a/arch/x86/include/asm/pgtable.h
@@ -1077,16 +1077,6 @@ static inline pte_t ptep_get_and_clear_f
 	return pte;
 }
 
-#define __HAVE_ARCH_PTEP_CLEAR
-static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep)
-{
-	if (IS_ENABLED(CONFIG_PAGE_TABLE_CHECK))
-		ptep_get_and_clear(mm, addr, ptep);
-	else
-		pte_clear(mm, addr, ptep);
-}
-
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
--- a/include/linux/pgtable.h~mm-page_table_check-add-hooks-to-public-helpers
+++ a/include/linux/pgtable.h
@@ -12,6 +12,7 @@
 #include <linux/bug.h>
 #include <linux/errno.h>
 #include <asm-generic/pgtable_uffd.h>
+#include <linux/page_table_check.h>
 
 #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
 	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
@@ -259,14 +260,6 @@ static inline int pmdp_clear_flush_young
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-#ifndef __HAVE_ARCH_PTEP_CLEAR
-static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep)
-{
-	pte_clear(mm, addr, ptep);
-}
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
@@ -274,10 +267,22 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = *ptep;
 	pte_clear(mm, address, ptep);
+	page_table_check_pte_clear(mm, address, pte);
 	return pte;
 }
 #endif
 
+#ifndef __HAVE_ARCH_PTEP_CLEAR
+static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep)
+{
+	if (IS_ENABLED(CONFIG_PAGE_TABLE_CHECK))
+		ptep_get_and_clear(mm, addr, ptep);
+	else
+		pte_clear(mm, addr, ptep);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET
 static inline pte_t ptep_get(pte_t *ptep)
 {
@@ -347,7 +352,10 @@ static inline pmd_t pmdp_huge_get_and_cl
 					    pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
+
 	pmd_clear(pmdp);
+	page_table_check_pmd_clear(mm, address, pmd);
+
 	return pmd;
 }
 #endif /* __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR */
@@ -359,6 +367,8 @@ static inline pud_t pudp_huge_get_and_cl
 	pud_t pud = *pudp;
 
 	pud_clear(pudp);
+	page_table_check_pud_clear(mm, address, pud);
+
 	return pud;
 }
 #endif /* __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR */
_

Patches currently in -mm which might be from tongtiangen@huawei.com are

mm-page_table_check-using-pxd_size-instead-of-pxd_page_size.patch
mm-page_table_check-add-hooks-to-public-helpers.patch
riscv-mm-add-support-for-page-table-check.patch

