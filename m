Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0609CC74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 16 Mar 2023 22:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCPW4h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Mar 2023 18:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCPW4h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2023 18:56:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD11C86DDB
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 15:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 785AEB823A0
        for <mm-commits@vger.kernel.org>; Thu, 16 Mar 2023 22:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1DBC4339B;
        Thu, 16 Mar 2023 22:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679007391;
        bh=9GhJ46/4q1nBMPLPiqvdpW5GTlrt6xmkRY1Cl8g+ybE=;
        h=Date:To:From:Subject:From;
        b=ShOR5V5fbBlFQoEpnJZkCXIs6kEznYKFuOLRF+kWAVPuDTqmBkQwa7U0Ac7BMXBZU
         XncEgjLe4d4UGDVRJqfHdGLvwgj7lb55FBv6eC17xrWHNg/Y54y2MIiMHL/PuVMITk
         EB7W7PXJqH+FIIoWsFslA4hZOzsnKd5005s4TNJM=
Date:   Thu, 16 Mar 2023 15:56:30 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        vbabka@suse.cz, osalvador@suse.de, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch added to mm-unstable branch
Message-Id: <20230316225631.0D1DBC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: consider the number of scanning compound pages in isolate fail path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch

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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: William Lam <william.lam@bytedance.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch
mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch

