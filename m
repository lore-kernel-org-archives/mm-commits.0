Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B2BC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbjDFCp1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbjDFCpD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:45:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F427ED3
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848D56421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2B6C433D2;
        Thu,  6 Apr 2023 02:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749101;
        bh=SLah1pE1n60/mBMtQlUZwKbXookGuYZBoMpykbXEqkw=;
        h=Date:To:From:Subject:From;
        b=eCw/ER0wH6EedvgYzNBMex+XiMRbkDnoSoQf9IYbjEjrn09so8+siL4jWtvDm2Yxo
         3pOrI7X+ZVev4u70VFBMxD92eTvBYgpbVMLXbj3PaTHmp77ABBPziqErUTF6+8GGhH
         k7Cs1jgft2mE5aAVtE4x+X9rB0vQCXlGGffP/1Ys=
Date:   Wed, 05 Apr 2023 19:45:00 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        vbabka@suse.cz, osalvador@suse.de, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch removed from -mm tree
Message-Id: <20230406024500.DC2B6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: consider the number of scanning compound pages in isolate fail path
has been removed from the -mm tree.  Its filename was
     mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: consider the number of scanning compound pages in isolate fail path
Date: Thu, 16 Mar 2023 19:06:46 +0800

commit b717d6b93b54 ("mm: compaction: include compound page count for
scanning in pageblock isolation") added compound page statistics for
scanning in pageblock isolation, to make sure the number of scanned pages
is always larger than the number of isolated pages when isolating
mirgratable or free pageblock.

However, when failing to isolate the pages when scanning the migratable or
free pageblocks, the isolation failure path did not consider the scanning
statistics of the compound pages, which result in showing the incorrect
number of scanned pages in tracepoints or in vmstats which will confuse
people about the page scanning pressure in memory compaction.

Thus we should take into account the number of scanning pages when failing
to isolate the compound pages to make the statistics accurate.

Link: https://lkml.kernel.org/r/73d6250a90707649cc010731aedc27f946d722ed.1678962352.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: William Lam <william.lam@bytedance.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/compaction.c~mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path
+++ a/mm/compaction.c
@@ -586,6 +586,7 @@ static unsigned long isolate_freepages_b
 			if (likely(order <= MAX_ORDER)) {
 				blockpfn += (1UL << order) - 1;
 				cursor += (1UL << order) - 1;
+				nr_scanned += (1UL << order) - 1;
 			}
 			goto isolate_fail;
 		}
@@ -904,6 +905,7 @@ isolate_migratepages_block(struct compac
 				if (ret == -EBUSY)
 					ret = 0;
 				low_pfn += compound_nr(page) - 1;
+				nr_scanned += compound_nr(page) - 1;
 				goto isolate_fail;
 			}
 
@@ -938,8 +940,10 @@ isolate_migratepages_block(struct compac
 			 * a valid page order. Consider only values in the
 			 * valid order range to prevent low_pfn overflow.
 			 */
-			if (freepage_order > 0 && freepage_order <= MAX_ORDER)
+			if (freepage_order > 0 && freepage_order <= MAX_ORDER) {
 				low_pfn += (1UL << freepage_order) - 1;
+				nr_scanned += (1UL << freepage_order) - 1;
+			}
 			continue;
 		}
 
@@ -954,8 +958,10 @@ isolate_migratepages_block(struct compac
 		if (PageCompound(page) && !cc->alloc_contig) {
 			const unsigned int order = compound_order(page);
 
-			if (likely(order <= MAX_ORDER))
+			if (likely(order <= MAX_ORDER)) {
 				low_pfn += (1UL << order) - 1;
+				nr_scanned += (1UL << order) - 1;
+			}
 			goto isolate_fail;
 		}
 
@@ -1077,6 +1083,7 @@ isolate_migratepages_block(struct compac
 			 */
 			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
 				low_pfn += compound_nr(page) - 1;
+				nr_scanned += compound_nr(page) - 1;
 				SetPageLRU(page);
 				goto isolate_fail_put;
 			}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


