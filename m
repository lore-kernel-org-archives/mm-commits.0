Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6930FC433E0
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3446193F
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhC1Was (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhC1Wab (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:30:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B81AF6192F;
        Sun, 28 Mar 2021 22:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970631;
        bh=GgU+Z+8oqJehGNaEtnqISzeiO2rONxL3ZRCKiBwAE60=;
        h=Date:From:To:Subject:From;
        b=Dz/BKI+UcGyKuLfqGFdESsjG/MirHhlekEfrOctzqeQwwVJu1U/sgD8jrqjLZKmpY
         9sYoa5SlUqG26u4dnyEKOelco+rW0PYb+OqAoevIYbHlr1sHh2+Rky/MvJXhcwn0Yg
         gLeJEVb4rPHbpgkcr3cW45QvKOGJVEfvc9KyCwJ4=
Date:   Sun, 28 Mar 2021 15:30:30 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  + mm-page_alloc-inline-__rmqueue_pcplist.patch added to
 -mm tree
Message-ID: <20210328223030.9nZ6JAOXe%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: inline __rmqueue_pcplist
has been added to the -mm tree.  Its filename is
     mm-page_alloc-inline-__rmqueue_pcplist.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-inline-__rmqueue_pcplist.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-inline-__rmqueue_pcplist.patch

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
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-inline-__rmqueue_pcplist
+++ a/mm/page_alloc.c
@@ -3450,7 +3450,8 @@ static inline void zone_statistics(struc
 }
 
 /* Remove page from the per-cpu list, caller must protect the list */
-static struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
+static inline
+struct page *__rmqueue_pcplist(struct zone *zone, int migratetype,
 			unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
 			struct list_head *list)
_

Patches currently in -mm which might be from brouer@redhat.com are

mm-page_alloc-optimize-code-layout-for-__alloc_pages_bulk.patch
mm-page_alloc-inline-__rmqueue_pcplist.patch
net-page_pool-refactor-dma_map-into-own-function-page_pool_dma_map.patch
net-page_pool-use-alloc_pages_bulk-in-refill-code-path.patch

