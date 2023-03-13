Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F084AC6FD19
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 19:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCMTbm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 15:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCMTbm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 15:31:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B428D7D0B2
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 12:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70110B81150
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 19:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C0C433D2;
        Mon, 13 Mar 2023 19:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678735898;
        bh=Or6F3nk/ZyFDGx/thacX6h6ARFZiPLNIR9EI/NkgG7E=;
        h=Date:To:From:Subject:From;
        b=nEoI/E8tv4xs6dIwuctL9KV/JfmP8DgHObo2+zNkJWEr66AZ1hPyTGKFDiCvR9CCW
         Z2QtElBegJ38FfeQd/V5nE3LQkvO4iWFGpEnOMOuMHX0EzofkRLr6ep8L79z9czZuV
         EdT0U3IQ/KT0I2lKI1YwlcShbHc/FteuZPGNyn+Q=
Date:   Mon, 13 Mar 2023 12:31:37 -0700
To:     mm-commits@vger.kernel.org, william.lam@bytedance.com,
        vbabka@suse.cz, osalvador@suse.de, mike.kravetz@oracle.com,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch added to mm-unstable branch
Message-Id: <20230313193138.2F3C0C433D2@smtp.kernel.org>
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
Date: Mon, 13 Mar 2023 18:37:16 +0800

Commit b717d6b93b54 ("mm: compaction: include compound page count for
scanning in pageblock isolation") added compound page statistics for
scanning in pageblock isolation, to make sure the number of scanned pages
is always larger than the number of isolated pages when isolating
migratable or free pageblocks.

However, when failing to isolate the pages when scanning the migratable or
free pageblocks, the isolation failure path did not consider the scanning
statistics of the compound pages, which can show the incorrect number of
scanned pages in tracepoints or vmstats to make people confused about the
page scanning pressure in memory compaction.

Thus we should take into account the number of scanned pages when failing
to isolate the compound pages to make the statistics accurate.

Link: https://lkml.kernel.org/r/1bc1c955b03603c4e14f56dfbbef9f637f18dbbd.1678703534.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Lam <william.lam@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/compaction.c~mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path
+++ a/mm/compaction.c
@@ -587,6 +587,7 @@ static unsigned long isolate_freepages_b
 				blockpfn += (1UL << order) - 1;
 				cursor += (1UL << order) - 1;
 			}
+			nr_scanned += (1UL << order) - 1;
 			goto isolate_fail;
 		}
 
@@ -873,9 +874,8 @@ isolate_migratepages_block(struct compac
 			cond_resched();
 		}
 
-		nr_scanned++;
-
 		page = pfn_to_page(low_pfn);
+		nr_scanned += compound_nr(page);
 
 		/*
 		 * Check if the pageblock has already been marked skipped.
@@ -1077,6 +1077,7 @@ isolate_migratepages_block(struct compac
 			 */
 			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
 				low_pfn += compound_nr(page) - 1;
+				nr_scanned += compound_nr(page) - 1;
 				SetPageLRU(page);
 				goto isolate_fail_put;
 			}
@@ -1097,7 +1098,6 @@ isolate_success:
 isolate_success_no_list:
 		cc->nr_migratepages += compound_nr(page);
 		nr_isolated += compound_nr(page);
-		nr_scanned += compound_nr(page) - 1;
 
 		/*
 		 * Avoid isolating too much unless this block is being
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-compaction-consider-the-number-of-scanning-compound-pages-in-isolate-fail-path.patch
mm-compaction-fix-the-possible-deadlock-when-isolating-hugetlb-pages.patch

