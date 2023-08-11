Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339F5C001DE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 16:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbjHKQ52 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 12:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbjHKQ50 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 12:57:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429FB30C1
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 09:57:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D457B6773B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D5DC433C8;
        Fri, 11 Aug 2023 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691773045;
        bh=gtasozctKfNjSXUTTUhr9uHY5ZmR0pv1iXsdwFrmM4s=;
        h=Date:To:From:Subject:From;
        b=aquD7k2aSiuky7t9m3qPRkiWe9KnN9WxtsvgFKjwYbZWwpGASFOSR2LYHnc4Lr9hm
         2KVfFzUN4sbZC5rDOL1BMRDsp1SbLreDjc1lxF20TfDN73HJ7PeBqbb0MqqMVOaqd1
         eQWEScnu1y1EzJ2RcJ2c2GeWi79PCxJwBDuU+WVM=
Date:   Fri, 11 Aug 2023 09:57:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch added to mm-unstable branch
Message-Id: <20230811165725.34D5DC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: use get_pfnblock_migratetype to avoid extra page_to_pfn
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_alloc: use get_pfnblock_migratetype to avoid extra page_to_pfn
Date: Fri, 11 Aug 2023 19:59:45 +0800

We have get_pageblock_migratetype and get_pfnblock_migratetype to get
migratetype of page.  get_pfnblock_migratetype accepts both page and pfn
from caller while get_pageblock_migratetype only accept page and get pfn
with page_to_pfn from page.

In case we already record pfn of page, we can simply call
get_pfnblock_migratetype to avoid a page_to_pfn.

Link: https://lkml.kernel.org/r/20230811115945.3423894-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn
+++ a/mm/page_alloc.c
@@ -813,7 +813,7 @@ static inline void __free_one_page(struc
 			 * pageblock isolation could cause incorrect freepage or CMA
 			 * accounting or HIGHATOMIC accounting.
 			 */
-			int buddy_mt = get_pageblock_migratetype(buddy);
+			int buddy_mt = get_pfnblock_migratetype(buddy, buddy_pfn);
 
 			if (migratetype != buddy_mt
 					&& (!migratetype_is_mergeable(migratetype) ||
@@ -889,7 +889,7 @@ int split_free_page(struct page *free_pa
 		goto out;
 	}
 
-	mt = get_pageblock_migratetype(free_page);
+	mt = get_pfnblock_migratetype(free_page, free_page_pfn);
 	if (likely(!is_migrate_isolate(mt)))
 		__mod_zone_freepage_state(zone, -(1UL << order), mt);
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-compaction-skip-the-memory-hole-rapidly-when-isolating-free-pages-fix.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch
mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch
mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch
mm-page_ext-move-functions-around-for-minor-cleanups-to-page_ext.patch
mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
mm-rmap-correct-stale-comment-of-rmap_walk_anon-and-rmap_walk_file.patch
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

