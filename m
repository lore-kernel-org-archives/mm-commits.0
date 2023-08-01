Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9AD9C04A94
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 19:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbjHATOG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 15:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbjHATOF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 15:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26B1BFD
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 12:14:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AB0D61684
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 19:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB26C433C7;
        Tue,  1 Aug 2023 19:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690917243;
        bh=4NFd5Kujx7fAavxKDse7jtj6ioNaBlOTGU6rqjfXwBQ=;
        h=Date:To:From:Subject:From;
        b=lBHpmZopTVo5JLtOQ8LLCZiE4qAoiLlsBQ7tUJUbuD8IKGiI+7uu8yDxMVHdqsr/l
         L611oR3iCrz0kZTrEwS0pyLnT1rfp0lzqFW7z4jfOnBwR0rvAgz5g6dFhtvo9q+Soo
         SyyXi1W3HVx83NCDA64iTLW/4fZfSD+8wqJ6H+oY=
Date:   Tue, 01 Aug 2023 12:14:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shikemeng@huawei.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch added to mm-unstable branch
Message-Id: <20230801191403.5EB26C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: remove unnecessary cursor page in isolate_freepages_block
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch

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
Subject: mm/compaction: remove unnecessary cursor page in isolate_freepages_block
Date: Sun, 30 Jul 2023 01:43:53 +0800

The cursor is only used for page forward currently.  We can simply move
page forward directly to remove unnecessary cursor.

Link: https://lkml.kernel.org/r/20230729174354.2239980-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kemeng Shi <shikemeng@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block
+++ a/mm/compaction.c
@@ -584,7 +584,7 @@ static unsigned long isolate_freepages_b
 				bool strict)
 {
 	int nr_scanned = 0, total_isolated = 0;
-	struct page *cursor;
+	struct page *page;
 	unsigned long flags = 0;
 	bool locked = false;
 	unsigned long blockpfn = *start_pfn;
@@ -594,12 +594,11 @@ static unsigned long isolate_freepages_b
 	if (strict)
 		stride = 1;
 
-	cursor = pfn_to_page(blockpfn);
+	page = pfn_to_page(blockpfn);
 
 	/* Isolate free pages. */
-	for (; blockpfn < end_pfn; blockpfn += stride, cursor += stride) {
+	for (; blockpfn < end_pfn; blockpfn += stride, page += stride) {
 		int isolated;
-		struct page *page = cursor;
 
 		/*
 		 * Periodically drop the lock (if held) regardless of its
@@ -624,7 +623,7 @@ static unsigned long isolate_freepages_b
 
 			if (likely(order <= MAX_ORDER)) {
 				blockpfn += (1UL << order) - 1;
-				cursor += (1UL << order) - 1;
+				page += (1UL << order) - 1;
 				nr_scanned += (1UL << order) - 1;
 			}
 			goto isolate_fail;
@@ -661,7 +660,7 @@ static unsigned long isolate_freepages_b
 		}
 		/* Advance to the end of split page */
 		blockpfn += isolated - 1;
-		cursor += isolated - 1;
+		page += isolated - 1;
 		continue;
 
 isolate_fail:
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
mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.patch
mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch
mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch
mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch

