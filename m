Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF5DEE49AA
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjHUUlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbjHUUk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD29129
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BB4464B2B
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A1C433C7;
        Mon, 21 Aug 2023 20:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650402;
        bh=DgVwl3tlT22x0znfyp+iMO9ly6dVE+SidYGg0aaJoQk=;
        h=Date:To:From:Subject:From;
        b=XWl5azAZNDxoGav19OS7ICDL3cqxE4fXLz3pG6gNkcHIfJWQOFBtCFxpp9HDtfyDQ
         d+907cqR7LMkpVTaPr2jY+jxb+G52+rKadTvu/FFsq4oyeN2h/6EK6mqlzrS85J+MG
         om6lBA1onPuiivEF0QVVRAf8ZIXLdnFdjSt9f1sw=
Date:   Mon, 21 Aug 2023 13:40:01 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huawei.com,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch removed from -mm tree
Message-Id: <20230821204002.6E2A1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: remove unnecessary cursor page in isolate_freepages_block
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: remove unnecessary cursor page in isolate_freepages_block
Date: Thu, 3 Aug 2023 17:49:00 +0800

The cursor is only used for page forward currently.  We can simply move
page forward directly to remove unnecessary cursor.

Link: https://lkml.kernel.org/r/20230803094901.2915942-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kemeng Shi <shikemeng@huawei.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block
+++ a/mm/compaction.c
@@ -589,7 +589,7 @@ static unsigned long isolate_freepages_b
 				bool strict)
 {
 	int nr_scanned = 0, total_isolated = 0;
-	struct page *cursor;
+	struct page *page;
 	unsigned long flags = 0;
 	bool locked = false;
 	unsigned long blockpfn = *start_pfn;
@@ -599,12 +599,11 @@ static unsigned long isolate_freepages_b
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
@@ -629,7 +628,7 @@ static unsigned long isolate_freepages_b
 
 			if (likely(order <= MAX_ORDER)) {
 				blockpfn += (1UL << order) - 1;
-				cursor += (1UL << order) - 1;
+				page += (1UL << order) - 1;
 				nr_scanned += (1UL << order) - 1;
 			}
 			goto isolate_fail;
@@ -666,7 +665,7 @@ static unsigned long isolate_freepages_b
 		}
 		/* Advance to the end of split page */
 		blockpfn += isolated - 1;
-		cursor += isolated - 1;
+		page += isolated - 1;
 		continue;
 
 isolate_fail:
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


