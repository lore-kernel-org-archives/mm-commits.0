Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF1DC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbjFIXc2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbjFIXbg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2084687
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D57363EB7
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22EBC433EF;
        Fri,  9 Jun 2023 23:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353359;
        bh=/v1pbdx8zfRpUXWsla7hJSelhDASjyBc9l3fRE11GR0=;
        h=Date:To:From:Subject:From;
        b=05PR3BVaDfloa+rC+TdE/9Qe/CnBt3GWI//pJWLGAiXjI03q7IkPJJY42iY44vuzS
         zu9Mo6NR0ldgfEOw7hqYBkmIkPUS37ZAX91pDyRh8mAiRQEqGqsRwof7MqSE9piVWQ
         CaQFRvWucCk1AqhDltbLf//F0o0D1lWq5JRbWLrA=
Date:   Fri, 09 Jun 2023 16:29:19 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, baolin.wang@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-change-fast_isolate_freepages-to-void-type.patch removed from -mm tree
Message-Id: <20230609232919.B22EBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: change fast_isolate_freepages() to void type
has been removed from the -mm tree.  Its filename was
     mm-compaction-change-fast_isolate_freepages-to-void-type.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: change fast_isolate_freepages() to void type
Date: Thu, 25 May 2023 20:53:57 +0800

No caller cares about the return value of fast_isolate_freepages(), void
it.

Link: https://lkml.kernel.org/r/759fca20b22ebf4c81afa30496837b9e0fb2e53b.1685018752.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/compaction.c~mm-compaction-change-fast_isolate_freepages-to-void-type
+++ a/mm/compaction.c
@@ -1413,8 +1413,7 @@ static int next_search_order(struct comp
 	return order;
 }
 
-static unsigned long
-fast_isolate_freepages(struct compact_control *cc)
+static void fast_isolate_freepages(struct compact_control *cc)
 {
 	unsigned int limit = max(1U, freelist_scan_limit(cc) >> 1);
 	unsigned int nr_scanned = 0;
@@ -1427,7 +1426,7 @@ fast_isolate_freepages(struct compact_co
 
 	/* Full compaction passes in a negative order */
 	if (cc->order <= 0)
-		return cc->free_pfn;
+		return;
 
 	/*
 	 * If starting the scan, use a deeper search and use the highest
@@ -1566,11 +1565,10 @@ fast_isolate_freepages(struct compact_co
 
 	cc->total_free_scanned += nr_scanned;
 	if (!page)
-		return cc->free_pfn;
+		return;
 
 	low_pfn = page_to_pfn(page);
 	fast_isolate_around(cc, low_pfn);
-	return low_pfn;
 }
 
 /*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


