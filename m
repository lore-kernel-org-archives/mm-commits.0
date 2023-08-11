Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDA6C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjHKXDk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjHKXCO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8FE35A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C867676A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B6FC433C8;
        Fri, 11 Aug 2023 23:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794859;
        bh=RCTwJ+fjhvDvu7FRKmWg13Txwf6BgYxOQnOSFXOUG9Q=;
        h=Date:To:From:Subject:From;
        b=owoxVOV6OXP+TUi2ZOaJfGcxxYkFkxT+kPdxBbI0V25/jFIF2XzE40avV61XZ0jm0
         9vslpXn0E4D/n+a4HYjYu28OfeOTHW24Zs0Tl3JtouNsnpeTq/UAh4+ZhiBnVB5FuH
         Mk6gmKq5RzqwpnceIpHW8ppTk38M15UcQdFMB73Q=
Date:   Fri, 11 Aug 2023 16:00:59 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch removed from -mm tree
Message-Id: <20230811230059.B2B6FC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pud_clear
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pud_clear
Date: Fri, 14 Jul 2023 01:26:33 +0800

Remove unused addr in __page_table_check_pud_clear and
page_table_check_pud_clear.

Link: https://lkml.kernel.org/r/20230713172636.1705415-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 ++++-------
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    5 ++---
 4 files changed, 8 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1144,7 +1144,7 @@ static inline pud_t pudp_huge_get_and_cl
 {
 	pud_t pud = native_pudp_get_and_clear(pudp);
 
-	page_table_check_pud_clear(mm, addr, pud);
+	page_table_check_pud_clear(mm, pud);
 
 	return pud;
 }
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/include/linux/page_table_check.h
@@ -16,8 +16,7 @@ extern struct page_ext_operations page_t
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
-void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
-				  pud_t pud);
+void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
 void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
@@ -60,13 +59,12 @@ static inline void page_table_check_pmd_
 	__page_table_check_pmd_clear(mm, pmd);
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm,
-					      unsigned long addr, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pud_clear(mm, addr, pud);
+	__page_table_check_pud_clear(mm, pud);
 }
 
 static inline void page_table_check_pte_set(struct mm_struct *mm,
@@ -127,8 +125,7 @@ static inline void page_table_check_pmd_
 {
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm,
-					      unsigned long addr, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/include/linux/pgtable.h
@@ -438,7 +438,7 @@ static inline pud_t pudp_huge_get_and_cl
 	pud_t pud = *pudp;
 
 	pud_clear(pudp);
-	page_table_check_pud_clear(mm, address, pud);
+	page_table_check_pud_clear(mm, pud);
 
 	return pud;
 }
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/mm/page_table_check.c
@@ -171,8 +171,7 @@ void __page_table_check_pmd_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
 
-void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
-				  pud_t pud)
+void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 {
 	if (&init_mm == mm)
 		return;
@@ -217,7 +216,7 @@ void __page_table_check_pud_set(struct m
 	if (&init_mm == mm)
 		return;
 
-	__page_table_check_pud_clear(mm, addr, *pudp);
+	__page_table_check_pud_clear(mm, *pudp);
 	if (pud_user_accessible_page(pud)) {
 		page_table_check_set(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT,
 				     pud_write(pud));
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

