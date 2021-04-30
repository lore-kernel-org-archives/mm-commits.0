Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03476C43462
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEC4F61456
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhD3GCa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhD3GCa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A60B6101E;
        Fri, 30 Apr 2021 06:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762503;
        bh=IO/55cCirt/VhVZ1sJfIrmfkFuWssm2JfaO9IE8P25g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Xn8sJz60lf0l5bP8HodRRqXjkh2S87MfXVRKrs+KSyUjCW1MVg1y6fu7IBmyCqq0N
         mdUzZM1dVm3ZYGZRv/pHFMPgAl93sF/+kpzsTfpj3p+4KAfkRmt6sJcKKTmlO/2EaY
         YZCz/NVVy6sufz3SBTjFk4sh4GwCS3ZQP1U2NpzA=
Date:   Thu, 29 Apr 2021 23:01:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 166/178] mm/page_alloc: rename alloced to
 allocated
Message-ID: <20210430060142.4yhLVVAVS%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: rename alloced to allocated

Patch series "Introduce a bulk order-0 page allocator with two in-tree users", v6.

This series introduces a bulk order-0 page allocator with sunrpc and the
network page pool being the first users.  The implementation is not
efficient as semantics needed to be ironed out first.  If no other
semantic changes are needed, it can be made more efficient.  Despite that,
this is a performance-related for users that require multiple pages for an
operation without multiple round-trips to the page allocator.  Quoting the
last patch for the high-speed networking use-case

            Kernel          XDP stats       CPU     pps           Delta
            Baseline        XDP-RX CPU      total   3,771,046       n/a
            List            XDP-RX CPU      total   3,940,242    +4.49%
            Array           XDP-RX CPU      total   4,249,224   +12.68%

Via the SUNRPC traces of svc_alloc_arg()

	Single page: 25.007 us per call over 532,571 calls
	Bulk list:    6.258 us per call over 517,034 calls
	Bulk array:   4.590 us per call over 517,442 calls

Both potential users in this series are corner cases (NFS and high-speed
networks) so it is unlikely that most users will see any benefit in the
short term.  Other potential other users are batch allocations for page
cache readahead, fault around and SLUB allocations when high-order pages
are unavailable.  It's unknown how much benefit would be seen by
converting multiple page allocation calls to a single batch or what
difference it may make to headline performance.

Light testing of my own running dbench over NFS passed.  Chuck and Jesper
conducted their own tests and details are included in the changelogs.

Patch 1 renames a variable name that is particularly unpopular

Patch 2 adds a bulk page allocator

Patch 3 adds an array-based version of the bulk allocator

Patches 4-5 adds micro-optimisations to the implementation

Patches 6-7 SUNRPC user

Patches 8-9 Network page_pool user


This patch (of 9):

Review feedback of the bulk allocator twice found problems with "alloced"
being a counter for pages allocated.  The naming was based on the API name
"alloc" and was based on the idea that verbal communication about malloc
tends to use the fake word "malloced" instead of the fake word mallocated.
To be consistent, this preparation patch renames alloced to allocated in
rmqueue_bulk so the bulk allocator and per-cpu allocator use similar names
when the bulk allocator is introduced.

Link: https://lkml.kernel.org/r/20210325114228.27719-1-mgorman@techsingularity.net
Link: https://lkml.kernel.org/r/20210325114228.27719-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-rename-alloced-to-allocated
+++ a/mm/page_alloc.c
@@ -2949,7 +2949,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, unsigned int alloc_flags)
 {
-	int i, alloced = 0;
+	int i, allocated = 0;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -2972,7 +2972,7 @@ static int rmqueue_bulk(struct zone *zon
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->lru, list);
-		alloced++;
+		allocated++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
@@ -2981,12 +2981,12 @@ static int rmqueue_bulk(struct zone *zon
 	/*
 	 * i pages were removed from the buddy list even if some leak due
 	 * to check_pcp_refill failing so adjust NR_FREE_PAGES based
-	 * on i. Do not confuse with 'alloced' which is the number of
+	 * on i. Do not confuse with 'allocated' which is the number of
 	 * pages added to the pcp list.
 	 */
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
-	return alloced;
+	return allocated;
 }
 
 #ifdef CONFIG_NUMA
_
