Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4893AC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjHKXDk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjHKXCG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A815D35A2
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481C16526A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCFFC433C8;
        Fri, 11 Aug 2023 23:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794858;
        bh=1i7D3NxVuztswlm4R0L3ansJqfxf8dTk0frP1y31Rtg=;
        h=Date:To:From:Subject:From;
        b=zDGvFD1iygC/cZFnN8lOzBfU609B0IgOhQOd4Pgt9RVOOBlJG0/i1apa5Fcw2bSiL
         Y1AGglzhQ3rtq/0C46QeNLTsgybjw0SayMzq2DKF5TWv0hgjPjzvAzt6aIUWbk1Z4t
         /51Tlj1FpMlik1m4Rn5g7vTT3Uukuugs5+ooOA+w=
Date:   Fri, 11 Aug 2023 16:00:58 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch removed from -mm tree
Message-Id: <20230811230058.9CCFFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pmd_clear
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pmd_clear
Date: Fri, 14 Jul 2023 01:26:32 +0800

Remove unused addr in page_table_check_pmd_clear and
__page_table_check_pmd_clear.

Link: https://lkml.kernel.org/r/20230713172636.1705415-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 ++++-------
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    5 ++---
 6 files changed, 10 insertions(+), 14 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -940,7 +940,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = __pmd(xchg_relaxed(&pmd_val(*pmdp), 0));
 
-	page_table_check_pmd_clear(mm, address, pmd);
+	page_table_check_pmd_clear(mm, pmd);
 
 	return pmd;
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -742,7 +742,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
-	page_table_check_pmd_clear(mm, address, pmd);
+	page_table_check_pmd_clear(mm, pmd);
 
 	return pmd;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1133,7 +1133,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 {
 	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
 
-	page_table_check_pmd_clear(mm, addr, pmd);
+	page_table_check_pmd_clear(mm, pmd);
 
 	return pmd;
 }
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear
+++ a/include/linux/page_table_check.h
@@ -15,8 +15,7 @@ extern struct page_ext_operations page_t
 
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
-void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
-				  pmd_t pmd);
+void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud);
 void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
@@ -53,13 +52,12 @@ static inline void page_table_check_pte_
 	__page_table_check_pte_clear(mm, pte);
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm,
-					      unsigned long addr, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmd_clear(mm, addr, pmd);
+	__page_table_check_pmd_clear(mm, pmd);
 }
 
 static inline void page_table_check_pud_clear(struct mm_struct *mm,
@@ -125,8 +123,7 @@ static inline void page_table_check_pte_
 {
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm,
-					      unsigned long addr, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear
+++ a/include/linux/pgtable.h
@@ -425,7 +425,7 @@ static inline pmd_t pmdp_huge_get_and_cl
 	pmd_t pmd = *pmdp;
 
 	pmd_clear(pmdp);
-	page_table_check_pmd_clear(mm, address, pmd);
+	page_table_check_pmd_clear(mm, pmd);
 
 	return pmd;
 }
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear
+++ a/mm/page_table_check.c
@@ -160,8 +160,7 @@ void __page_table_check_pte_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
-void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
-				  pmd_t pmd)
+void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
@@ -204,7 +203,7 @@ void __page_table_check_pmd_set(struct m
 	if (&init_mm == mm)
 		return;
 
-	__page_table_check_pmd_clear(mm, addr, *pmdp);
+	__page_table_check_pmd_clear(mm, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
 		page_table_check_set(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT,
 				     pmd_write(pmd));
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
mm-page_poison-remove-unused-page_exth-from-page_poison.patch
mm-vmstat-remove-unused-page_exth-from-vmstat.patch
mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch
mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch
mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch
mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch
mm-compaction-correct-last_migrated_pfn-update-in-compact_zone.patch
mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch
mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages.patch
mm-compaction-correct-comment-of-cached-migrate-pfn-update.patch
mm-compaction-correct-comment-to-complete-migration-failure.patch
mm-compaction-remove-unnecessary-return-for-void-function.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-page_alloc-remove-track-of-active-pcp-lists-range-in-bulk-free.patch
mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch
mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch
mm-page_alloc-remove-unnecessary-inner-__get_pfnblock_flags_mask.patch
mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch

