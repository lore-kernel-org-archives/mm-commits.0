Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98580C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CE561884
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 03:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhJVDPK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 23:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232570AbhJVDPJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 23:15:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE386613A9;
        Fri, 22 Oct 2021 03:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634872373;
        bh=ZQokfrMdl5T/aamRANHND0C5JEK++c2bv6wil2FodsM=;
        h=Date:From:To:Subject:From;
        b=EmYKPz1CZARb8m9TFaIYJqx1HyxUsQ08D/klX+bJsoDn0Vthms5tOBVZEON/ciCpU
         IU3mfL21ONAvUEwX7/U1f3yjlsgQSN0pmc7vvAx6IUu5bU/1kidPiYGpUhX5CS2Mj+
         kJwyQAX/T9/wciqA4vWgNjj64KPzyiJsPFosqJiM=
Date:   Thu, 21 Oct 2021 20:12:52 -0700
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, edumazet@google.com, guohanjun@huawei.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shakeelb@google.com,
        wangkefeng.wang@huawei.com
Subject:  [to-be-updated]
 mm-vmalloc-fix-numa-spreading-for-large-hash-tables.patch removed from -mm
 tree
Message-ID: <20211022031252.bG5ru2N_F%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix numa spreading for large hash tables
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-numa-spreading-for-large-hash-tables.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/vmalloc: fix numa spreading for large hash tables

Eric Dumazet reported a strange numa spreading info in [1], and found
commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings") introduced
this issue [2].

Dig into the difference before and after this patch, page allocation has
some difference:

before:
alloc_large_system_hash
    __vmalloc
        __vmalloc_node(..., NUMA_NO_NODE, ...)
            __vmalloc_node_range
                __vmalloc_area_node
                    alloc_page /* because NUMA_NO_NODE, so choose alloc_page branch */
                        alloc_pages_current
                            alloc_page_interleave /* can be proved by print policy mode */

after:
alloc_large_system_hash
    __vmalloc
        __vmalloc_node(..., NUMA_NO_NODE, ...)
            __vmalloc_node_range
                __vmalloc_area_node
                    alloc_pages_node /* choose nid by nuam_mem_id() */
                        __alloc_pages_node(nid, ....)

So after commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings"),
it will allocate memory in current node instead of interleaving allocate
memory.

[1]
https://lore.kernel.org/linux-mm/CANn89iL6AAyWhfxdHO+jaT075iOa3XcYn9k6JJc7JR2XYn6k_Q@mail.gmail.com/

[2]
https://lore.kernel.org/linux-mm/CANn89iLofTR=AK-QOZY87RdUZENCZUT4O6a0hvhu3_EwRMerOg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20210928121040.2547407-1-chenwandun@huawei.com
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-numa-spreading-for-large-hash-tables
+++ a/mm/vmalloc.c
@@ -2816,6 +2816,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
 {
 	unsigned int nr_allocated = 0;
+	struct page *page;
+	int i;
 
 	/*
 	 * For order-0 pages we make use of bulk allocator, if
@@ -2826,6 +2828,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	if (!order) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
+			page = NULL;
 
 			/*
 			 * A maximum allowed request is hard-coded and is 100
@@ -2835,9 +2838,23 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 */
 			nr_pages_request = min(100U, nr_pages - nr_allocated);
 
-			nr = alloc_pages_bulk_array_node(gfp, nid,
-				nr_pages_request, pages + nr_allocated);
-
+			if (nid == NUMA_NO_NODE) {
+				for (i = 0; i < nr_pages_request; i++) {
+					page = alloc_page(gfp);
+					if (page)
+						pages[nr_allocated + i] = page;
+					else {
+						nr = i;
+						break;
+					}
+				}
+				if (i >= nr_pages_request)
+					nr = nr_pages_request;
+			} else {
+				nr = alloc_pages_bulk_array_node(gfp, nid,
+							nr_pages_request,
+							pages + nr_allocated);
+			}
 			nr_allocated += nr;
 			cond_resched();
 
@@ -2856,11 +2873,13 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		gfp |= __GFP_COMP;
 
 	/* High-order pages or fallback path if "bulk" fails. */
-	while (nr_allocated < nr_pages) {
-		struct page *page;
-		int i;
 
-		page = alloc_pages_node(nid, gfp, order);
+	page = NULL;
+	while (nr_allocated < nr_pages) {
+		if (nid == NUMA_NO_NODE)
+			page = alloc_pages(gfp, order);
+		else
+			page = alloc_pages_node(nid, gfp, order);
 		if (unlikely(!page))
 			break;
 
_

Patches currently in -mm which might be from chenwandun@huawei.com are

mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch

