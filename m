Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20113C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjHKXDi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237121AbjHKXBr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36032684
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A2296492D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F31C433C8;
        Fri, 11 Aug 2023 23:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794855;
        bh=bAvBIpQ/hFn/9TEqtMWiVrCC5pOLjt3k7aQnbAsj5cw=;
        h=Date:To:From:Subject:From;
        b=ntq/nngtXy2yQJnvfze3xb18lBjRF77PokqVO4q/HMLBC9uWpFoILbHTo/pREPrew
         FseBVYPYvRRqIBxCM67xnOFWoQTeCvHAn73IjQ7GUXFddObHUt365hkDjyedQp1KG3
         OrzhHOKCTurL45rtcxhW02R8phRqR7JlgEQyXTJE=
Date:   Fri, 11 Aug 2023 16:00:55 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch removed from -mm tree
Message-Id: <20230811230055.B1F31C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: remove unused parameters in page_table_check_clear()
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameters in page_table_check_clear()
Date: Fri, 14 Jul 2023 01:26:29 +0800

Patch series "Remove unused parameters in page_table_check".

This series remove unused parameters in functions from page_table_check. 
The first 2 patches remove unused mm and addr parameters in static common
functions page_table_check_clear and page_table_check_set.  The last 6
patches remove unused addr parameter in some externed functions which only
need addr for cleaned page_table_check_clear or page_table_check_set. 
There is no intended functional change.  


This patch (of 8):

Remove unused mm and addr in function page_table_check_clear().

Link: https://lkml.kernel.org/r/20230713172636.1705415-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230713172636.1705415-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameters-in-page_table_check_clear
+++ a/mm/page_table_check.c
@@ -58,8 +58,7 @@ static struct page_table_check *get_page
  * An entry is removed from the page table, decrement the counters for that page
  * verify that it is of correct type and counters do not become negative.
  */
-static void page_table_check_clear(struct mm_struct *mm, unsigned long addr,
-				   unsigned long pfn, unsigned long pgcnt)
+static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
 {
 	struct page_ext *page_ext;
 	struct page *page;
@@ -158,8 +157,7 @@ void __page_table_check_pte_clear(struct
 		return;
 
 	if (pte_user_accessible_page(pte)) {
-		page_table_check_clear(mm, addr, pte_pfn(pte),
-				       PAGE_SIZE >> PAGE_SHIFT);
+		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
@@ -171,8 +169,7 @@ void __page_table_check_pmd_clear(struct
 		return;
 
 	if (pmd_user_accessible_page(pmd)) {
-		page_table_check_clear(mm, addr, pmd_pfn(pmd),
-				       PMD_SIZE >> PAGE_SHIFT);
+		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
@@ -184,8 +181,7 @@ void __page_table_check_pud_clear(struct
 		return;
 
 	if (pud_user_accessible_page(pud)) {
-		page_table_check_clear(mm, addr, pud_pfn(pud),
-				       PUD_SIZE >> PAGE_SHIFT);
+		page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
 	}
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
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

