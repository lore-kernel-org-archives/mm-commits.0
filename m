Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041C6EE49A6
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjHUUl3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjHUUki (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DB21B7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F5FE64AFB
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D410BC433C9;
        Mon, 21 Aug 2023 20:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650416;
        bh=cTInGF4zp13s5jeltIlNRG8GXisw04CgLop0chlgQMk=;
        h=Date:To:From:Subject:From;
        b=DW149qfjG0G/TwzfqDpYOG0HjWcZXtS6/rHLIirBPEevM+ZQAICR43zb2d/uZ+qJ4
         UaIWfZ2oX6Z5FtLBeTb2kBAL/GyaQ8TX7cTRZfCa0stUAQGYN1naGvxJdCliWT9Xf3
         ExCpUtRvnxdqjjFwk9xmOB/hPpuWv7vDa6qwO3QY=
Date:   Mon, 21 Aug 2023 13:40:16 -0700
To:     mm-commits@vger.kernel.org, mgorman@techsingularity.net,
        david@redhat.com, baolin.wang@linux.alibaba.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch removed from -mm tree
Message-Id: <20230821204016.D410BC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: skip page block marked skip in isolate_migratepages_block
has been removed from the -mm tree.  Its filename was
     mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1140,6 +1140,7 @@ isolate_migratepages_block(struct compac
 				skip_updated = true;
 				if (test_and_set_skip(cc, valid_page) &&
 				    !cc->finish_pageblock) {
+					low_pfn = end_pfn;
 					goto isolate_abort;
 				}
 			}
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are


