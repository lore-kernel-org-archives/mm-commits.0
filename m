Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B51DC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242227AbiESWZ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbiESWZ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0873B6622A
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94CC961698
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5886C34113;
        Thu, 19 May 2022 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999124;
        bh=DE0DfLxQicqdxaIF2qKEVOrL6o0G7VSZE3F/5PwyWX0=;
        h=Date:To:From:Subject:From;
        b=GOF5wx3UZI3eTuS+KEa43l/PNneCfdQAHcqisiBm0tqIXc0P1wZCl8jj1pexdImyt
         TGC7XeQtD1a4ZUpNuTO2nxbyhCFkUYmPhJrNeJ4KmcvQXKP8HbXe7wZpbTqXWTisdf
         QDU8ybpnHHI467DfdMJC8bLwJWlwXxwykQHuGprU=
Date:   Thu, 19 May 2022 15:25:23 -0700
To:     mm-commits@vger.kernel.org, xiexiuqi@huawei.com, will@kernel.org,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, lkp@intel.com, guohanjun@huawei.com,
        catalin.marinas@arm.com, arnd@arndb.de, aou@eecs.berkeley.edu,
        anshuman.khandual@arm.com, tongtiangen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2.patch removed from -mm tree
Message-Id: <20220519222523.D5886C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64/mm: fix page table check compile error for CONFIG_PGTABLE_LEVELS=2
has been removed from the -mm tree.  Its filename was
     arm64-mm-fix-page-table-check-compile-error-for-config_pgtable_levels=2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


