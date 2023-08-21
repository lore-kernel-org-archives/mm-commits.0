Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C5CEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjHUUlE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjHUUk2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACFBE69
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E688164B29
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49677C433C9;
        Mon, 21 Aug 2023 20:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650401;
        bh=bisYRgfqoOgYhG3/LBoyTGWk63Bki6DkbGxucgkJJHk=;
        h=Date:To:From:Subject:From;
        b=WAgUO7FbA8O8r4r5SdrLgFVdyNa2glzVW/DlGRzD9NTqp7rrR0eGD4H6mUT4XKBIm
         zA3ZhbKsLXyO+ldsuUup8k9fgjqLOP5o9fpRUcq46+FKOd+KvLN6d45h7qXRRag60K
         zHcAaz7jmTwwH6rq4FB3J/jtRtbHxLWImi/DUXys=
Date:   Mon, 21 Aug 2023 13:40:00 -0700
To:     mm-commits@vger.kernel.org, shikemeng@huaweicloud.com,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch removed from -mm tree
Message-Id: <20230821204001.49677C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: merge end_pfn boundary check in isolate_freepages_range
has been removed from the -mm tree.  Its filename was
     mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huawei.com>
Subject: mm/compaction: merge end_pfn boundary check in isolate_freepages_range
Date: Thu, 3 Aug 2023 17:48:59 +0800

Merge the end_pfn boundary check for single page block forward and
multiple page blocks forward to avoid do twice boundary check for multiple
page blocks forward.

Link: https://lkml.kernel.org/r/20230803094901.2915942-3-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-merge-end_pfn-boundary-check-in-isolate_freepages_range
+++ a/mm/compaction.c
@@ -740,8 +740,6 @@ isolate_freepages_range(struct compact_c
 		/* Protect pfn from changing by isolate_freepages_block */
 		unsigned long isolate_start_pfn = pfn;
 
-		block_end_pfn = min(block_end_pfn, end_pfn);
-
 		/*
 		 * pfn could pass the block_end_pfn if isolated freepage
 		 * is more than pageblock order. In this case, we adjust
@@ -750,9 +748,10 @@ isolate_freepages_range(struct compact_c
 		if (pfn >= block_end_pfn) {
 			block_start_pfn = pageblock_start_pfn(pfn);
 			block_end_pfn = pageblock_end_pfn(pfn);
-			block_end_pfn = min(block_end_pfn, end_pfn);
 		}
 
+		block_end_pfn = min(block_end_pfn, end_pfn);
+
 		if (!pageblock_pfn_to_page(block_start_pfn,
 					block_end_pfn, cc->zone))
 			break;
_

Patches currently in -mm which might be from shikemeng@huawei.com are


