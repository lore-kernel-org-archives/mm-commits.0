Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33F79C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbjHKXAh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236086AbjHKW7w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279EF3AB1
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1B556492D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E59C433C8;
        Fri, 11 Aug 2023 22:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794774;
        bh=6FSbn5TL9lJTAhmXPkMCazwo/qJr/LlWnaVAKEmcXl8=;
        h=Date:To:From:Subject:From;
        b=UkvWzT3598K0Z7Cm7oYWGa/CyHH3Ag4T+SYQ2xZAPeYFq1YGXgE29OS8cTjYczQJ/
         TLocrNnpOMjVsfaR4jd3nadVwHdsQaYPpyehimCiWgqVjcaWqwtrVF1WVG6scwmNxK
         a954Gy6mTCfoX5oJAcauKNDqI6ZdtvFFhkWIV4E8=
Date:   Fri, 11 Aug 2023 15:59:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-correct-stale-comment-of-function-check_pte.patch removed from -mm tree
Message-Id: <20230811225934.17E59C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: correct stale comment of function check_pte
has been removed from the -mm tree.  Its filename was
     mm-correct-stale-comment-of-function-check_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm: correct stale comment of function check_pte
Date: Fri, 7 Jul 2023 23:39:53 +0800

Commit 2aff7a4755bed ("mm: Convert page_vma_mapped_walk to work on PFNs")
replaced page with pfns in page_vma_mapped_walk structure and updated
"@pvmw->page" to "@pvmw->pfn" in comment of function page_vma_mapped_walk.

This patch update stale "page" to "pfn" in comment of check_pte.

Link: https://lkml.kernel.org/r/20230707153953.1380615-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/page_vma_mapped.c~mm-correct-stale-comment-of-function-check_pte
+++ a/mm/page_vma_mapped.c
@@ -73,20 +73,22 @@ static bool map_pte(struct page_vma_mapp
 }
 
 /**
- * check_pte - check if @pvmw->page is mapped at the @pvmw->pte
- * @pvmw: page_vma_mapped_walk struct, includes a pair pte and page for checking
+ * check_pte - check if [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages) is
+ * mapped at the @pvmw->pte
+ * @pvmw: page_vma_mapped_walk struct, includes a pair pte and pfn range
+ * for checking
  *
- * page_vma_mapped_walk() found a place where @pvmw->page is *potentially*
+ * page_vma_mapped_walk() found a place where pfn range is *potentially*
  * mapped. check_pte() has to validate this.
  *
  * pvmw->pte may point to empty PTE, swap PTE or PTE pointing to
  * arbitrary page.
  *
  * If PVMW_MIGRATION flag is set, returns true if @pvmw->pte contains migration
- * entry that points to @pvmw->page or any subpage in case of THP.
+ * entry that points to [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages)
  *
  * If PVMW_MIGRATION flag is not set, returns true if pvmw->pte points to
- * pvmw->page or any subpage in case of THP.
+ * [pvmw->pfn, @pvmw->pfn + @pvmw->nr_pages)
  *
  * Otherwise, return false.
  *
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

