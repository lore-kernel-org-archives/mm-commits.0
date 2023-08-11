Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C44C04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbjHKXDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbjHKXCk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CCD4218
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76A6E6492D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE62FC433C7;
        Fri, 11 Aug 2023 23:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794861;
        bh=mD5nOjWxEOb/LjYulcpDFA/1n8uVOzF98S9kKobQREg=;
        h=Date:To:From:Subject:From;
        b=IlrmWooi/BfkhaLlJCEp3D8wlzDmqcWURdQZ7Z2tfcei5wHJr9yT9AzsasVGilI+T
         w4sn3Ztni61DtkRnz2VBD1ZhxV47g46D9BBGMGXxN8MBmXgS6Nug9lHzWndh4Y4gtx
         3Q8OK2I4ZilhFvFznOKs+o/2mVxdxk7O6eQbfTwk=
Date:   Fri, 11 Aug 2023 16:01:01 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch removed from -mm tree
Message-Id: <20230811230101.CE62FC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pmd_set
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pmd_set
Date: Fri, 14 Jul 2023 01:26:35 +0800

Remove unused addr in __page_table_check_pmd_set and
page_table_check_pmd_set.

Link: https://lkml.kernel.org/r/20230713172636.1705415-8-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    4 ++--
 arch/riscv/include/asm/pgtable.h |    4 ++--
 arch/x86/include/asm/pgtable.h   |    4 ++--
 include/linux/page_table_check.h |   11 ++++-------
 mm/page_table_check.c            |    3 +--
 5 files changed, 11 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -524,7 +524,7 @@ static inline pmd_t pmd_mkdevmap(pmd_t p
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	page_table_check_pmd_set(mm, pmdp, pmd);
 	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
@@ -976,7 +976,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -687,7 +687,7 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	page_table_check_pmd_set(mm, pmdp, pmd);
 	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
@@ -758,7 +758,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
 	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1030,7 +1030,7 @@ static inline void set_pte_at(struct mm_
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	page_table_check_pmd_set(mm, pmdp, pmd);
 	set_pmd(pmdp, pmd);
 }
 
@@ -1167,7 +1167,7 @@ static inline int pud_write(pud_t pud)
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pmdp, pmd);
 	} else {
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/include/linux/page_table_check.h
@@ -18,8 +18,7 @@ void __page_table_check_pte_clear(struct
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
 void __page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep, pte_t pte);
-void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
-				pmd_t *pmdp, pmd_t pmd);
+void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd);
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -75,14 +74,13 @@ static inline void page_table_check_pte_
 	__page_table_check_pte_set(mm, ptep, pte);
 }
 
-static inline void page_table_check_pmd_set(struct mm_struct *mm,
-					    unsigned long addr, pmd_t *pmdp,
+static inline void page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp,
 					    pmd_t pmd)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	__page_table_check_pmd_set(mm, pmdp, pmd);
 }
 
 static inline void page_table_check_pud_set(struct mm_struct *mm,
@@ -132,8 +130,7 @@ static inline void page_table_check_pte_
 {
 }
 
-static inline void page_table_check_pmd_set(struct mm_struct *mm,
-					    unsigned long addr, pmd_t *pmdp,
+static inline void page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp,
 					    pmd_t pmd)
 {
 }
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/mm/page_table_check.c
@@ -195,8 +195,7 @@ void __page_table_check_pte_set(struct m
 }
 EXPORT_SYMBOL(__page_table_check_pte_set);
 
-void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
-				pmd_t *pmdp, pmd_t pmd)
+void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
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

