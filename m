Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A5FC04FDF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbjHKXEA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236244AbjHKXDH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54C8422E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A682A63F1F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0ECC433C8;
        Fri, 11 Aug 2023 23:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794873;
        bh=VyII27NqVGLUQ3hS+4LYe34A2qvK1I0JlrjXXtD11pY=;
        h=Date:To:From:Subject:From;
        b=a7ni3TdMeITWU7Bf4ehvlfGUqoN6MbHfXmKQUSyl7Ig7l6Jr4n8+QLmgk09PvxS4m
         9MPUl9mFPZMj4fIsypZjHti3Ji2ok40ROZzoyvKCp8SkK1wKTD0U2YMEwfMu2WSA9t
         aRszlIPvYs6Gx9WBCo/ZOBb5BXZ3y9AQDb0FslrA=
Date:   Fri, 11 Aug 2023 16:01:12 -0700
To:     mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch removed from -mm tree
Message-Id: <20230811230113.0D0ECC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: remove rollback for untouched mem_section in online_page_ext
has been removed from the -mm tree.  Its filename was
     mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_ext: remove rollback for untouched mem_section in online_page_ext
Date: Fri, 14 Jul 2023 19:47:48 +0800

If init_section_page_ext failed, we only need rollback for mem_section
before failed mem_section.  Make rollback end point to failed mem_section
to remove unnecessary rollback.

As pfn += PAGES_PER_SECTION will be executed even if init_section_page_ext
failed.  So pfn points to mem_section after failed mem_section.  Subtract
one mem_section from pfn to get failed mem_section.

Link: https://lkml.kernel.org/r/20230714114749.1743032-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/page_ext.c~mm-page_ext-remove-rollback-for-untouched-mem_section-in-online_page_ext
+++ a/mm/page_ext.c
@@ -424,6 +424,7 @@ static int __meminit online_page_ext(uns
 		return 0;
 
 	/* rollback */
+	end = pfn - PAGES_PER_SECTION;
 	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION)
 		__free_page_ext(pfn);
 
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

