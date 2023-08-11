Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E60C41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbjHKXDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbjHKXBv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0AB3584
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C5D62BDB
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFE6C433C8;
        Fri, 11 Aug 2023 23:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794856;
        bh=lP7g9Oksdc24DbPFtEfpfAdn4FdF44m6sYkKns2QQdM=;
        h=Date:To:From:Subject:From;
        b=SQDz2niws4XHNtEAu1p9JZjkTSfDtbP5g1O6T644Qzp5ql8CSkqUX5CsG6xELUPjz
         9Q5nbXqtP8oo4hJHoLtpmHGyJGMJ3/oQEZbU3mYQDVlbPDxsRbbPmXsCW7bq163tpy
         yUArSE/a848cVJAN1NVPQGQgkwa/Vi0Xjhfuqq4g=
Date:   Fri, 11 Aug 2023 16:00:56 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch removed from -mm tree
Message-Id: <20230811230056.9FFE6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: remove unused parameters in page_table_check_set()
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameters in page_table_check_set()
Date: Fri, 14 Jul 2023 01:26:30 +0800

Remove unused mm and addr in page_table_check_set().

Link: https://lkml.kernel.org/r/20230713172636.1705415-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameters-in-page_table_check_set
+++ a/mm/page_table_check.c
@@ -94,8 +94,7 @@ static void page_table_check_clear(unsig
  * verify that it is of correct type and is not being mapped with a different
  * type to a different process.
  */
-static void page_table_check_set(struct mm_struct *mm, unsigned long addr,
-				 unsigned long pfn, unsigned long pgcnt,
+static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
 				 bool rw)
 {
 	struct page_ext *page_ext;
@@ -194,8 +193,7 @@ void __page_table_check_pte_set(struct m
 
 	__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
 	if (pte_user_accessible_page(pte)) {
-		page_table_check_set(mm, addr, pte_pfn(pte),
-				     PAGE_SIZE >> PAGE_SHIFT,
+		page_table_check_set(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT,
 				     pte_write(pte));
 	}
 }
@@ -209,8 +207,7 @@ void __page_table_check_pmd_set(struct m
 
 	__page_table_check_pmd_clear(mm, addr, *pmdp);
 	if (pmd_user_accessible_page(pmd)) {
-		page_table_check_set(mm, addr, pmd_pfn(pmd),
-				     PMD_SIZE >> PAGE_SHIFT,
+		page_table_check_set(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT,
 				     pmd_write(pmd));
 	}
 }
@@ -224,8 +221,7 @@ void __page_table_check_pud_set(struct m
 
 	__page_table_check_pud_clear(mm, addr, *pudp);
 	if (pud_user_accessible_page(pud)) {
-		page_table_check_set(mm, addr, pud_pfn(pud),
-				     PUD_SIZE >> PAGE_SHIFT,
+		page_table_check_set(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT,
 				     pud_write(pud));
 	}
 }
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

