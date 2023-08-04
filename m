Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE024C001DF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Aug 2023 17:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjHDR5r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Aug 2023 13:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjHDR5h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2023 13:57:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18EB4C06
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 10:57:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F3FB620DC
        for <mm-commits@vger.kernel.org>; Fri,  4 Aug 2023 17:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DB6C433C8;
        Fri,  4 Aug 2023 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691171854;
        bh=LrsNXaLmbr8BQJyVvda4wiPpGs3VGRrO5IICANRH63s=;
        h=Date:To:From:Subject:From;
        b=HRsdluJuCCom89fW9ebMWEJ67bsDHrzQdBgoCPLX4wEsycU5PkC2Da7xIga3Gl54G
         Y04h3iIrlZTgj/wnwQjVlCGflzqZlwVA2M+DoRkieuaDOqpel87mPG4DOsCsNlzz/3
         AM5S4MGHIZyKKY7D8YGU8KG5yhLb2UNdX7+T9sEU=
Date:   Fri, 04 Aug 2023 10:57:33 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch added to mm-unstable branch
Message-Id: <20230804175733.E4DB6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: skip page block marked skip in isolate_migratepages_block
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch

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
Subject: mm/compaction: skip page block marked skip in isolate_migratepages_block
Date: Fri, 4 Aug 2023 19:04:49 +0800

Move migrate_pfn to page block end when block is marked skip to avoid
   unnecessary scan retry of that block from upper caller.  For example,
   compact_zone may wrongly rescan skip page block with finish_pageblock
   set as following:

1. cc->migrate point to the start of page block

2. compact_zone record last_migrated_pfn to cc->migrate

3. compact_zone->isolate_migratepages->isolate_migratepages_block
   tries to scan the block.  The low_pfn maybe moved forward to middle of
   block because of free pages at beginning of block.

4. we find first lru page could be isolated but block was exclusive
   marked skip.

5. abort isolate_migratepages_block and make cc->migrate_pfn point to
   found lru page at middle of block.

6. compact_zone find cc->migrate_pfn and last_migrated_pfn are in the
   same block and wrongly rescan the block with finish_pageblock set.

Link: https://lkml.kernel.org/r/20230804110454.2935878-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/compaction.c~mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block
+++ a/mm/compaction.c
@@ -1141,6 +1141,7 @@ isolate_migratepages_block(struct compac
 				skip_updated = true;
 				if (test_and_set_skip(cc, valid_page) &&
 				    !cc->finish_pageblock) {
+					low_pfn = end_pfn;
 					goto isolate_abort;
 				}
 			}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
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
mm-compaction-avoid-missing-last-page-block-in-section-after-skip-offline-sections.patch
mm-compaction-correct-last_migrated_pfn-update-in-compact_zone.patch
mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch
mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages.patch
mm-compaction-correct-comment-of-cached-migrate-pfn-update.patch
mm-compaction-correct-comment-to-complete-migration-failure.patch
mm-compaction-remove-unnecessary-return-for-void-function.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch

