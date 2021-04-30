Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04960C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC51061458
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhD3GCl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:55834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhD3GCl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42842613F8;
        Fri, 30 Apr 2021 06:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762512;
        bh=E4/5ag3DtW0a5RrYZ9+9ibPzTXU7qrU0ThLvl1sHWkw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JLowfukxMGcARR2Z+YFcbSJbdm5HolT1TChBZER6A5IltatJD65cBZt7l70Kaxy4u
         PDXJWe+3jwhkqR4+DMg/IowsPkuX4Utv6Jz9Dy1cib+okWZ1eqSl3V+V32Tz+ZYqw+
         VO0iwHKkOdUKIU6YRt7wYoj/vguV5PRPiUMAgTkA=
Date:   Thu, 29 Apr 2021 23:01:51 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 169/178] mm/page_alloc: optimize code layout for
 __alloc_pages_bulk
Message-ID: <20210430060151.fpwn8MC_r%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
Acked-By: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk
+++ a/mm/page_alloc.c
@@ -5042,7 +5042,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
 	int nr_populated = 0;
 
-	if (WARN_ON_ONCE(nr_pages <= 0))
+	if (unlikely(nr_pages <= 0))
 		return 0;
 
 	/*
@@ -5089,7 +5089,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	 * If there are no allowed local zones that meets the watermarks then
 	 * try to allocate a single page and reclaim if necessary.
 	 */
-	if (!zone)
+	if (unlikely(!zone))
 		goto failed;
 
 	/* Attempt the batch allocation */
@@ -5107,7 +5107,7 @@ unsigned long __alloc_pages_bulk(gfp_t g
 
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
-		if (!page) {
+		if (unlikely(!page)) {
 			/* Try and get at least one page */
 			if (!nr_populated)
 				goto failed_irq;
_
