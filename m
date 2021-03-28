Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55E72C433E1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D06061949
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhC1Wat (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhC1Wao (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:30:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B70F76192F;
        Sun, 28 Mar 2021 22:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970644;
        bh=5QdZ2rt9uDMSiDaqiCy0s9XakMi8QC7MJfWs5yziIGU=;
        h=Date:From:To:Subject:From;
        b=QAZOUN3uERpIdfl28ddMorYAQjQN3bgYdbB6B4dcOPBCTSirU8WgEd3TIv5dEPLZq
         v51z8Rg+d+1MQC8b3le++1jfmL3LREeDwUEjXrsje7OljkaYvK+t+v1mT6RSE5Wv/x
         wqnExuz1f7mhA9TZpAuybm0FgCo4+ZCTK87B6WvA=
Date:   Sun, 28 Mar 2021 15:30:43 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  +
 mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk.patch added to
 -mm tree
Message-ID: <20210328223043.EIcZQfis5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: optimize code layout for __alloc_pages_bulk
has been added to the -mm tree.  Its filename is
     mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm/page_alloc: optimize code layout for __alloc_pages_bulk

Looking at perf-report and ASM-code for __alloc_pages_bulk() it is clear
that the code activated is suboptimal.  The compiler guesses wrong and
places unlikely code at the beginning.  Due to the use of WARN_ON_ONCE()
macro the UD2 asm instruction is added to the code, which confuse the
I-cache prefetcher in the CPU.

[mgorman@techsingularity.net: minor changes and rebasing]
Link: https://lkml.kernel.org/r/20210325114228.27719-5-mgorman@techsingularity.net
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk
+++ a/mm/page_alloc.c
@@ -5036,7 +5036,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	unsigned int alloc_flags;
 	int nr_populated = 0;
 
-	if (WARN_ON_ONCE(nr_pages <= 0))
+	if (unlikely(nr_pages <= 0))
 		return 0;
 
 	/*
@@ -5083,7 +5083,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	 * If there are no allowed local zones that meets the watermarks then
 	 * try to allocate a single page and reclaim if necessary.
 	 */
-	if (!zone)
+	if (unlikely(!zone))
 		goto failed;
 
 	/* Attempt the batch allocation */
@@ -5101,7 +5101,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
-		if (!page) {
+		if (unlikely(!page)) {
 			/* Try and get at least one page */
 			if (!nr_populated)
 				goto failed_irq;
_

Patches currently in -mm which might be from brouer@redhat.com are

mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk.patch
mm-page_alloc-inline-__rmqueue_pcplist.patch
net-page_pool-refactor-dma_map-into-own-function-page_pool_dma_map.patch
net-page_pool-use-alloc_pages_bulk-in-refill-code-path.patch

