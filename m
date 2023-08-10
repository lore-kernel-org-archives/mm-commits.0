Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE0AC04A6A
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbjHJRH4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbjHJRHz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:07:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2040D270F
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:07:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A374E656D7
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 17:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6801C433D9;
        Thu, 10 Aug 2023 17:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691687274;
        bh=ceAxR9onI2l/qcU+DmjeAQYHFhepYp/SlTn1LwDc0WU=;
        h=Date:To:From:Subject:From;
        b=jCWMMAUmtQqcjoeTJgUVZbt0H934lyez/UTviKdjJiLyPewqB8LQNII98gxUSIggB
         uCeh7Ey5/8vtkGokCIdkrQuQKB9xr0kNPXFxkNUPsJ/ak2moKYwd2VV8nOUcvRvrfA
         LSuJjhmXvWLBR7sXb9zCnoMPTkmy25P/n6DtRQjQ=
Date:   Thu, 10 Aug 2023 10:07:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch added to mm-unstable branch
Message-Id: <20230810170753.E6801C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove unused parameter pgdata of fragmentation_score_wmark
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch

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
Subject: mm/compaction: remove unused parameter pgdata of fragmentation_score_wmark
Date: Wed, 9 Aug 2023 17:49:10 +0800

Parameter pgdat is not used in fragmentation_score_wmark. Just remove it.

Link: https://lkml.kernel.org/r/20230809094910.3092446-1-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark
+++ a/mm/compaction.c
@@ -2142,7 +2142,7 @@ static unsigned int fragmentation_score_
 	return score;
 }
 
-static unsigned int fragmentation_score_wmark(pg_data_t *pgdat, bool low)
+static unsigned int fragmentation_score_wmark(bool low)
 {
 	unsigned int wmark_low;
 
@@ -2162,7 +2162,7 @@ static bool should_proactive_compact_nod
 	if (!sysctl_compaction_proactiveness || kswapd_is_running(pgdat))
 		return false;
 
-	wmark_high = fragmentation_score_wmark(pgdat, false);
+	wmark_high = fragmentation_score_wmark(false);
 	return fragmentation_score_node(pgdat) > wmark_high;
 }
 
@@ -2201,7 +2201,7 @@ static enum compact_result __compact_fin
 			return COMPACT_PARTIAL_SKIPPED;
 
 		score = fragmentation_score_zone(cc->zone);
-		wmark_low = fragmentation_score_wmark(pgdat, true);
+		wmark_low = fragmentation_score_wmark(true);
 
 		if (score > wmark_low)
 			ret = COMPACT_CONTINUE;
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

