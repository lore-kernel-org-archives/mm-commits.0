Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E17C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbjHKXDs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbjHKXCk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5EA4215
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DFC866B5A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF09C433C8;
        Fri, 11 Aug 2023 23:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794860;
        bh=I6xcS43fO2Fxj0woOFs/AES3pfXFnIyLC5RXC45fPG4=;
        h=Date:To:From:Subject:From;
        b=df72sAM8Cth7X2L1rGKV6r6a743VIRRlPzgNRIhmYl/1TJ4uIskRVpft8AFIXcNEM
         dOOwKGJirvJxrCarM19WL7ngzBaZqpRiaA/8O9atMHXZ0HaPvt4qLgk3REwK3eaLxg
         D6dZoUGez8xCHNsG8SAqaeWADfi7468Vww6TK6ic=
Date:   Fri, 11 Aug 2023 16:01:00 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch removed from -mm tree
Message-Id: <20230811230100.BFF09C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pte_set
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pte_set
Date: Fri, 14 Jul 2023 01:26:34 +0800

Remove unused addr in __page_table_check_pte_set and
page_table_check_pte_set.

Link: https://lkml.kernel.org/r/20230713172636.1705415-7-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 ++++-------
 mm/page_table_check.c            |    3 +--
 5 files changed, 8 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -348,7 +348,7 @@ static inline void __set_pte_at(struct m
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
-	page_table_check_pte_set(mm, addr, ptep, pte);
+	page_table_check_pte_set(mm, ptep, pte);
 	return __set_pte_at(mm, addr, ptep, pte);
 }
 
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -499,7 +499,7 @@ static inline void __set_pte_at(struct m
 static inline void set_pte_at(struct mm_struct *mm,
 	unsigned long addr, pte_t *ptep, pte_t pteval)
 {
-	page_table_check_pte_set(mm, addr, ptep, pteval);
+	page_table_check_pte_set(mm, ptep, pteval);
 	__set_pte_at(mm, addr, ptep, pteval);
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1023,7 +1023,7 @@ static inline pud_t native_local_pudp_ge
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
-	page_table_check_pte_set(mm, addr, ptep, pte);
+	page_table_check_pte_set(mm, ptep, pte);
 	set_pte(ptep, pte);
 }
 
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set
+++ a/include/linux/page_table_check.h
@@ -17,8 +17,7 @@ void __page_table_check_zero(struct page
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
-void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte);
+void __page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep, pte_t pte);
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd);
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
@@ -67,14 +66,13 @@ static inline void page_table_check_pud_
 	__page_table_check_pud_clear(mm, pud);
 }
 
-static inline void page_table_check_pte_set(struct mm_struct *mm,
-					    unsigned long addr, pte_t *ptep,
+static inline void page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep,
 					    pte_t pte)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_set(mm, addr, ptep, pte);
+	__page_table_check_pte_set(mm, ptep, pte);
 }
 
 static inline void page_table_check_pmd_set(struct mm_struct *mm,
@@ -129,8 +127,7 @@ static inline void page_table_check_pud_
 {
 }
 
-static inline void page_table_check_pte_set(struct mm_struct *mm,
-					    unsigned long addr, pte_t *ptep,
+static inline void page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep,
 					    pte_t pte)
 {
 }
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set
+++ a/mm/page_table_check.c
@@ -182,8 +182,7 @@ void __page_table_check_pud_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
 
-void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte)
+void __page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep, pte_t pte)
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

