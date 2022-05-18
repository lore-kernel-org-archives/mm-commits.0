Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC56C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 17:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbiERROE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 13:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240785AbiERROD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 13:14:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26C16F922
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 10:14:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6988CCE205F
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 17:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92B7C34100;
        Wed, 18 May 2022 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652894038;
        bh=bMmniUNoVOYEuSx2JrV/6jpYU/ipUNL5+QfUgmQ4M90=;
        h=Date:To:From:Subject:From;
        b=HVHKmuizc3MiBh2y841W8kU6bOgPmX9yLu3Tq2l5JDIx2b+li+JYorMVRLr8HWZNT
         URrN6ZVXDUedJ3k/ROVlH+2LWKs/kOH/vFPNM5Fwgx+5HklDI60L3qdV3S9kPEisoU
         HJ1jJY5h8BJFlNrk6H7z8JiX//+Mia3bMhNK9Y2M=
Date:   Wed, 18 May 2022 10:13:58 -0700
To:     mm-commits@vger.kernel.org, xiexiuqi@huawei.com, will@kernel.org,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, lkp@intel.com, guohanjun@huawei.com,
        catalin.marinas@arm.com, arnd@arndb.de, aou@eecs.berkeley.edu,
        anshuman.khandual@arm.com, tongtiangen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2.patch added to mm-unstable branch
Message-Id: <20220518171358.C92B7C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64/mm: fix page table check compile error for CONFIG_PGTABLE_LEVELS=2
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2.patch

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
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: arm64/mm: fix page table check compile error for CONFIG_PGTABLE_LEVELS=2
Date: Tue, 17 May 2022 07:45:48 +0000

If CONFIG_PGTABLE_LEVELS=2 and CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y,
then we trigger a compile error:

  error: implicit declaration of function 'pte_user_accessible_page'

Move the definition of page table check helper out of branch
CONFIG_PGTABLE_LEVELS > 2

Link: https://lkml.kernel.org/r/20220517074548.2227779-3-tongtiangen@huawei.com
Fixes: daf214c14dbe ("arm64/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   33 ++++++++++++++---------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2
+++ a/arch/arm64/include/asm/pgtable.h
@@ -667,22 +667,6 @@ static inline unsigned long pmd_page_vad
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
 #define pud_user(pud)		pte_user(pud_pte(pud))
 
-#ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
-{
-	return pte_present(pte) && (pte_user(pte) || pte_user_exec(pte));
-}
-
-static inline bool pmd_user_accessible_page(pmd_t pmd)
-{
-	return pmd_present(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
-}
-
-static inline bool pud_user_accessible_page(pud_t pud)
-{
-	return pud_present(pud) && pud_user(pud);
-}
-#endif
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
@@ -855,6 +839,23 @@ static inline int pgd_devmap(pgd_t pgd)
 }
 #endif
 
+#ifdef CONFIG_PAGE_TABLE_CHECK
+static inline bool pte_user_accessible_page(pte_t pte)
+{
+	return pte_present(pte) && (pte_user(pte) || pte_user_exec(pte));
+}
+
+static inline bool pmd_user_accessible_page(pmd_t pmd)
+{
+	return pmd_present(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
+}
+
+static inline bool pud_user_accessible_page(pud_t pud)
+{
+	return pud_present(pud) && pud_user(pud);
+}
+#endif
+
 /*
  * Atomic pte/pmd modifications.
  */
_

Patches currently in -mm which might be from tongtiangen@huawei.com are

riscv-mm-fix-two-page-table-check-related-issues.patch
arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2.patch

