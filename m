Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A43C433E1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D5506191D
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhC1TbZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230184AbhC1TbW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:31:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38F8A6191D;
        Sun, 28 Mar 2021 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616959882;
        bh=tMo32rDS88Q6sRlmfPHLPPxw5taxDBPttkFGWpMm+F4=;
        h=Date:From:To:Subject:From;
        b=j4JxfnuuukuAGBJmsrKiL/oxQgODo3LKG/XOWD4jI+fkiYPg0IypMbZF4M1L19co5
         CYFcD/ACnOVVv5mk20GkVtL/C+eSGLif3Lh4XAGrpSBoE4hOVbnMgqCDtHzTUN5G5J
         X6SRiml3EDg9+JOIejbw/dTZixvoqCs8enrQPeGE=
Date:   Sun, 28 Mar 2021 12:31:21 -0700
From:   akpm@linux-foundation.org
To:     alexander.duyck@gmail.com, alobakin@pm.me, brouer@redhat.com,
        chuck.lever@oracle.com, davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  + mm-page_alloc-rename-alloced-to-allocated.patch added
 to -mm tree
Message-ID: <20210328193121.MyU0ObM0y%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: rename alloced to allocated
has been added to the -mm tree.  Its filename is
     mm-page_alloc-rename-alloced-to-allocated.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-rename-alloced-to-allocated.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-rename-alloced-to-allocated.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-rename-alloced-to-allocated
+++ a/mm/page_alloc.c
@@ -2943,7 +2943,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, unsigned int alloc_flags)
 {
-	int i, alloced = 0;
+	int i, allocated = 0;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -2966,7 +2966,7 @@ static int rmqueue_bulk(struct zone *zon
 		 * pages are ordered properly.
 		 */
 		list_add_tail(&page->lru, list);
-		alloced++;
+		allocated++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
@@ -2975,12 +2975,12 @@ static int rmqueue_bulk(struct zone *zon
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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-rename-alloced-to-allocated.patch
mm-page_alloc-add-a-bulk-page-allocator.patch
mm-page_alloc-add-a-bulk-page-allocator-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator.patch

