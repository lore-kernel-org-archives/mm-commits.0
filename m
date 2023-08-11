Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B794C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbjHKXD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbjHKXDG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28511422C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B41FA62BDB
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18829C433C7;
        Fri, 11 Aug 2023 23:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794872;
        bh=S7YqWL11RoDUUc7pyT7G8ZN1ttZme1Gynza/U3HJy0I=;
        h=Date:To:From:Subject:From;
        b=TsJAqIGwplg8m37lEjOdINNv0CJQgxgm27ksJ2n/8GYIPIrdVLA8zE5FZIdsRjCae
         jKPltx5rkBRZzhtqdaVV1BcupZLBRP3zVZbB3J06GIfhPOGKRVQh9TCovDryEnUfTJ
         PnNhxUf2S17TKtfDguUXElJMXFCGpz6wCrBYfvvU=
Date:   Fri, 11 Aug 2023 16:01:11 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch removed from -mm tree
Message-Id: <20230811230112.18829C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: remove unused return value of offline_page_ext
has been removed from the -mm tree.  Its filename was
     mm-page_ext-remove-unused-return-value-of-offline_page_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: remove unused return value of offline_page_ext
Date: Fri, 14 Jul 2023 19:47:47 +0800

Patch series "minor cleanups for page_ext".

This series contains some random minor cleanups for page_ext.  More
details can be found in respective patches.  


This patch (of 3):

offline_page_ext always returns 0 and no caller checks the return value. 
Just remove unused return value of offline_page_ext.

Link: https://lkml.kernel.org/r/20230714114749.1743032-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230714114749.1743032-2-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_ext.c~mm-page_ext-remove-unused-return-value-of-offline_page_ext
+++ a/mm/page_ext.c
@@ -430,7 +430,7 @@ static int __meminit online_page_ext(uns
 	return -ENOMEM;
 }
 
-static int __meminit offline_page_ext(unsigned long start_pfn,
+static void __meminit offline_page_ext(unsigned long start_pfn,
 				unsigned long nr_pages)
 {
 	unsigned long start, end, pfn;
@@ -454,8 +454,6 @@ static int __meminit offline_page_ext(un
 
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
 		__free_page_ext(pfn);
-	return 0;
-
 }
 
 static int __meminit page_ext_callback(struct notifier_block *self,
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

