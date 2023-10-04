Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA91E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjJDURc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232977AbjJDURb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:17:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55279AD
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:17:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1963C433C8;
        Wed,  4 Oct 2023 20:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450648;
        bh=bVaHL4bw8qr9zUIqnG2nYO3jQjHhhCVkg8wHhmo95es=;
        h=Date:To:From:Subject:From;
        b=lL3gSx2r0XYKEnq5wVI0rVvcfgGK0a7ItgR7cew4k+Az1wd0wsrJRGYTLsyhve6s7
         lWqPnKgikruqcJvNR2bAu9opL6unsm+M+P7bErzJZO7+nlpx3QkPK4bwKxZpbYNoFE
         ynj07X1eACeugh1VzWamNb9ZkmeWVsjRh8pylWBA=
Date:   Wed, 04 Oct 2023 13:17:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        mgorman@techsingularity.net, david@redhat.com,
        baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch removed from -mm tree
Message-Id: <20231004201727.B1963C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/compaction: remove repeat compact_blockskip_flush check in reset_isolation_suitable
has been removed from the -mm tree.  Its filename was
     mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/compaction: remove repeat compact_blockskip_flush check in reset_isolation_suitable
Date: Fri, 1 Sep 2023 23:51:39 +0800

We have compact_blockskip_flush check in __reset_isolation_suitable, just
remove repeat check before __reset_isolation_suitable in
compact_blockskip_flush.

Link: https://lkml.kernel.org/r/20230901155141.249860-5-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-remove-repeat-compact_blockskip_flush-check-in-reset_isolation_suitable
+++ a/mm/compaction.c
@@ -382,6 +382,7 @@ static void __reset_isolation_suitable(s
 	bool source_set = false;
 	bool free_set = false;
 
+	/* Only flush if a full compaction finished recently */
 	if (!zone->compact_blockskip_flush)
 		return;
 
@@ -434,9 +435,7 @@ void reset_isolation_suitable(pg_data_t
 		if (!populated_zone(zone))
 			continue;
 
-		/* Only flush if a full compaction finished recently */
-		if (zone->compact_blockskip_flush)
-			__reset_isolation_suitable(zone);
+		__reset_isolation_suitable(zone);
 	}
 }
 
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-page_alloc-correct-start-page-when-guard-page-debug-is-enabled.patch
mm-page_alloc-remove-unnecessary-check-in-break_down_buddy_pages.patch
mm-page_alloc-remove-unnecessary-next_page-in-break_down_buddy_pages.patch

