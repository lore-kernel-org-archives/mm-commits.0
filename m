Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D1FC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiGDBM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbiGDBLu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A529640E
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7A20B80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7333EC341C6;
        Mon,  4 Jul 2022 01:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897053;
        bh=QttJQzXp7Z789aeOrWhqb1Icec3QXeSkfJwqmh7DCRc=;
        h=Date:To:From:Subject:From;
        b=mEsxMK+XIbFCp1FU82Ex9JGnKc16CdpqdJRQpoqjNaFeeJb4vwuuYDTg5CetPz4Q0
         xkWumvvpMwyS52MlqG4xblJI1d0UzJZ5bQLUXh4N9F+khT7Zup1FPKh/b6kiru7x2P
         kV61hD1spBhVTReBotnMzX6l7n7iYIojWfEUERik=
Date:   Sun, 03 Jul 2022 18:10:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        cgel.zte@gmail.com, yang.yang29@zte.com.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-the-annotations-of-available-memory-more-accurate.patch removed from -mm tree
Message-Id: <20220704011053.7333EC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: make the annotations of available memory more accurate
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-the-annotations-of-available-memory-more-accurate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Yang <yang.yang29@zte.com.cn>
Subject: mm/page_alloc: make the annotations of available memory more accurate
Date: Thu, 23 Jun 2022 02:08:34 +0000

Not all systems use swap, so estimating available memory would help to
prevent swapping or OOM of system that not use swap.

And we need to reserve some page cache to prevent swapping or thrashing. 
If somebody is accessing the pages in pagecache, and if too much would be
freed, most accesses might mean reading data from disk, i.e.  thrashing.

Link: https://lkml.kernel.org/r/20220623020833.972979-1-yang.yang29@zte.com.cn
Signed-off-by: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-make-the-annotations-of-available-memory-more-accurate
+++ a/mm/page_alloc.c
@@ -5800,14 +5800,14 @@ long si_mem_available(void)
 
 	/*
 	 * Estimate the amount of memory available for userspace allocations,
-	 * without causing swapping.
+	 * without causing swapping or OOM.
 	 */
 	available = global_zone_page_state(NR_FREE_PAGES) - totalreserve_pages;
 
 	/*
 	 * Not all the page cache can be freed, otherwise the system will
-	 * start swapping. Assume at least half of the page cache, or the
-	 * low watermark worth of cache, needs to stay.
+	 * start swapping or thrashing. Assume at least half of the page
+	 * cache, or the low watermark worth of cache, needs to stay.
 	 */
 	pagecache = pages[LRU_ACTIVE_FILE] + pages[LRU_INACTIVE_FILE];
 	pagecache -= min(pagecache / 2, wmark_low);
_

Patches currently in -mm which might be from yang.yang29@zte.com.cn are


