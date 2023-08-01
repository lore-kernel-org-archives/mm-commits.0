Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B824C00528
	for <mm-commits@archiver.kernel.org>; Tue,  1 Aug 2023 19:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjHATOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Aug 2023 15:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbjHATOA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2023 15:14:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104E918B
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 12:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E0EA616AB
        for <mm-commits@vger.kernel.org>; Tue,  1 Aug 2023 19:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A8BC433C7;
        Tue,  1 Aug 2023 19:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690917238;
        bh=t4Ub9YzK58OCqHke+12NPj7meGSzc0n+F9/FCDaMnyU=;
        h=Date:To:From:Subject:From;
        b=a5LUaEdRG45vF3xi8uN823gDpv4FeNBcQ9XKeFCbMEzs9BowIWqiuvZT3FN79a5ur
         kWsI1Xw3sfwk8eqsMl+Sfx45FfBAlcI06nTtSTGsP2TjZj/42Khjw1/A7iWsVqUfzl
         fXlewWkj1H0aW7XDi9m5PaAltp7HejrK+LDu8AoA=
Date:   Tue, 01 Aug 2023 12:13:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shikemeng@huawei.com, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.patch added to mm-unstable branch
Message-Id: <20230801191357.F0A8BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: allow blockpfn outside of pageblock for high order buddy page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page.patch

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
Subject: mm/compaction: allow blockpfn outside of pageblock for high order buddy page
Date: Sun, 30 Jul 2023 01:43:50 +0800

Patch series "Fixes and cleanups to compaction".

This series contains random fixes and cleanups to free page isolation in
compaction.  This is based on another compact series[1].  More details can
be found in respective patches.


This patch (of 5):

Commit 9fcd6d2e052ee ("mm, compaction: skip compound pages by order in
free scanner") skiped compound pages to save iterations and limit blockpfn
to reach outside of page block in case of bogus compound_order.  While
this also limit pfnblock outside page block in case a buddy page with
order higher than page block is found.  After this,
isolate_freepages_range will fail unexpectedly as it will fail to isolate
the page block which was isolated successfully by high order buddy page in
previous page block and abort the free page isolation.

Fix this by allow blockpfn outside of pageblock in case of high order
buddy page.

Link: https://lkml.kernel.org/r/20230729174354.2239980-1-shikemeng@huaweicloud.com
Link: https://lkml.kernel.org/r/20230729174354.2239980-2-shikemeng@huaweicloud.com
Fixes: 9fcd6d2e052ee ("mm, compaction: skip compound pages by order in free scanner")
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Kemeng Shi <shikemeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-allow-blockpfn-outside-of-pageblock-for-high-order-buddy-page
+++ a/mm/compaction.c
@@ -678,8 +678,10 @@ isolate_fail:
 	/*
 	 * There is a tiny chance that we have read bogus compound_order(),
 	 * so be careful to not go outside of the pageblock.
+	 * Allow blockpfn outside pageblock in normal case that we isolate
+	 * buddy page with order more than pageblock order.
 	 */
-	if (unlikely(blockpfn > end_pfn))
+	if (unlikely(blockpfn > end_pfn) && total_isolated <= pageblock_nr_pages)
 		blockpfn = end_pfn;
 
 	trace_mm_compaction_isolate_freepages(*start_pfn, blockpfn,
@@ -1441,7 +1443,7 @@ fast_isolate_around(struct compact_contr
 	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
-	if (start_pfn == end_pfn)
+	if (start_pfn >= end_pfn)
 		set_pageblock_skip(page);
 
 	return;
@@ -1713,7 +1715,7 @@ static void isolate_freepages(struct com
 					block_end_pfn, freelist, stride, false);
 
 		/* Update the skip hint if the full pageblock was scanned */
-		if (isolate_start_pfn == block_end_pfn)
+		if (isolate_start_pfn >= block_end_pfn)
 			update_pageblock_skip(cc, page, block_start_pfn);
 
 		/* Are enough freepages isolated? */
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

