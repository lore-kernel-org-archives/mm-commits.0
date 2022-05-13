Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965C0C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383873AbiEMTZL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383717AbiEMTXP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE26D3137B
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CECDB831A4
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F84C34113;
        Fri, 13 May 2022 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469729;
        bh=4whrbAFCwquu0gAmbUDvSE07qnfeazshwXwCi7gxAK4=;
        h=Date:To:From:Subject:From;
        b=MioNV+pjYJ6t0A0oj7RbwxBfGOgIJrSP3S7KFt8YRaV0FoETgeqklKbxnXeVBixjh
         QZfJFrV1dPGxnXuvmpY4kDA9pk8RU2/ToNj8nO3G3Rga8FGoE7VnUkJ3cL2yzjwkQ6
         DSp5JrxQgbqhvtEPYilanqexzovTeMyyPAj5fCd4=
Date:   Fri, 13 May 2022 12:22:08 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tongtiangen@huawei.com, paul.walmsley@sifive.com,
        pasha.tatashin@soleen.com, palmer@dabbelt.com, mingo@redhat.com,
        hpa@zytor.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, anshuman.khandual@arm.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch removed from -mm tree
Message-Id: <20220513192208.F3F84C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_table_check: move pxx_user_accessible_page into x86
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_table_check: move pxx_user_accessible_page into x86

The pxx_user_accessible_page() checks the PTE bit, it's
architecture-specific code, move them into x86's pgtable.h.

These helpers are being moved out to make the page table check framework
platform independent.

Link: https://lkml.kernel.org/r/20220507110114.4128854-3-tongtiangen@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |   17 +++++++++++++++++
 mm/page_table_check.c          |   17 -----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-move-pxx_user_accessible_page-into-x86
+++ a/arch/x86/include/asm/pgtable.h
@@ -1447,6 +1447,23 @@ static inline bool arch_faults_on_old_pt
 	return false;
 }
 
+#ifdef CONFIG_PAGE_TABLE_CHECK
+static inline bool pte_user_accessible_page(pte_t pte)
+{
+	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
+}
+
+static inline bool pmd_user_accessible_page(pmd_t pmd)
+{
+	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) && (pmd_val(pmd) & _PAGE_USER);
+}
+
+static inline bool pud_user_accessible_page(pud_t pud)
+{
+	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) && (pud_val(pud) & _PAGE_USER);
+}
+#endif
+
 #endif	/* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_H */
--- a/mm/page_table_check.c~mm-page_table_check-move-pxx_user_accessible_page-into-x86
+++ a/mm/page_table_check.c
@@ -52,23 +52,6 @@ static struct page_table_check *get_page
 	return (void *)(page_ext) + page_table_check_ops.offset;
 }
 
-static inline bool pte_user_accessible_page(pte_t pte)
-{
-	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
-}
-
-static inline bool pmd_user_accessible_page(pmd_t pmd)
-{
-	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) &&
-		(pmd_val(pmd) & _PAGE_USER);
-}
-
-static inline bool pud_user_accessible_page(pud_t pud)
-{
-	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) &&
-		(pud_val(pud) & _PAGE_USER);
-}
-
 /*
  * An enty is removed from the page table, decrement the counters for that page
  * verify that it is of correct type and counters do not become negative.
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


