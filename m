Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449B3C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 296E261450
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhD3GCp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhD3GCo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86BAF61456;
        Fri, 30 Apr 2021 06:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762516;
        bh=wJ2FWhHuwsDlzar8QiocjGEI4MxdA12Co28pz+6RTOo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XcfP0iliaP8Mzuz1MY//GT4ySWEOWJYs4SLMzWnGqaIbQLont3FRj943iLVtlmKBS
         TtUKWHvETZ4ph0OrKB3rNpOnf4je5I768tdk4C2nmDtLjA9L/rzgalRIDSqNBuleYi
         jCxoGISG98N9fSUUaL7oXHCsKQfehq1hpr5HyzkI=
Date:   Thu, 29 Apr 2021 23:01:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 170/178] mm/page_alloc: inline __rmqueue_pcplist
Message-ID: <20210430060155.8Nx4d1A9w%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: mm/page_alloc: inline __rmqueue_pcplist

When __alloc_pages_bulk() got introduced two callers of __rmqueue_pcplist
exist and the compiler chooses to not inline this function.

 ./scripts/bloat-o-meter vmlinux-before vmlinux-inline__rmqueue_pcplist
add/remove: 0/1 grow/shrink: 2/0 up/down: 164/-125 (39)
Function                                     old     new   delta
rmqueue                                     2197    2296     +99
__alloc_pages_bulk                          1921    1986     +65
__rmqueue_pcplist                            125       -    -125
Total: Before=19374127, After=19374166, chg +0.00%

modprobe page_bench04_bulk loops=$((10**7))

Type:time_bulk_page_alloc_free_array
 -  Per elem: 106 cycles(tsc) 29.595 ns (step:64)
 - (measurement period time:0.295955434 sec time_interval:295955434)
 - (invoke count:10000000 tsc_interval:1065447105)

Before:
 - Per elem: 110 cycles(tsc) 30.633 ns (step:64)

Link: https://lkml.kernel.org/r/20210325114228.27719-6-mgorman@techsingularity.net
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-inline-__rmqueue_pcplist
+++ a/mm/page_alloc.c
@@ -3456,7 +3456,8 @@ static inline void zone_statistics(struc
 }
 
 /* Remove page from the per-cpu list, caller must protect the list */
-static struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
+static inline
+struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
 			struct list_head *list)
_
