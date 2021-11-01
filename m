Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24372C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D1A561078
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhKAS0u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231931AbhKAS0u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Nov 2021 14:26:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8658F60FC4;
        Mon,  1 Nov 2021 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635791056;
        bh=5ZzlOPMweyQ0Rk1tqKG8uVOgxrQ4CWmpJRNBPGUWrRc=;
        h=Date:From:To:Subject:From;
        b=qpjoQDY7nqhMpt0YFMDU1wtwvW8ocqsyveJ9f5vyyj6aHssj0SF6iX8N4cMSxTrPJ
         d7VA2waMZbdWYHeqmTmzWx5ECcW9oG3RzXMB1VAk6NsnnUE/4TuS1F+WA8mHBd0Exp
         yJoFJ4ZbLNtJt0EqttB+eGIT60sgL5ifE35+r6ao=
Date:   Mon, 01 Nov 2021 11:24:16 -0700
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, edumazet@google.com, guohanjun@huawei.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shakeelb@google.com,
        urezki@gmail.com, wangkefeng.wang@huawei.com
Subject:  [merged]
 mm-vmalloc-fix-numa-spreading-for-large-hash-tables.patch removed from -mm
 tree
Message-ID: <20211101182416.oH7pNvmg_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix numa spreading for large hash tables
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-numa-spreading-for-large-hash-tables.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

So after commit 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings"), it
will allocate memory in current node instead of interleaving allocate
memory.

[1]
https://lore.kernel.org/linux-mm/CANn89iL6AAyWhfxdHO+jaT075iOa3XcYn9k6JJc7JR2XYn6k_Q@mail.gmail.com/

[2]
https://lore.kernel.org/linux-mm/CANn89iLofTR=AK-QOZY87RdUZENCZUT4O6a0hvhu3_EwRMerOg@mail.gmail.com/

Link: https://lkml.kernel.org/r/20211021080744.874701-2-chenwandun@huawei.com
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

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
@@ -2823,7 +2825,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * to fails, fallback to a single page allocator that is
 	 * more permissive.
 	 */
-	if (!order) {
+	if (!order && nid != NUMA_NO_NODE) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
 
@@ -2848,7 +2850,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			if (nr != nr_pages_request)
 				break;
 		}
-	} else
+	} else if (order)
 		/*
 		 * Compound pages required for remap_vmalloc_page if
 		 * high-order pages.
@@ -2856,11 +2858,12 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		gfp |= __GFP_COMP;
 
 	/* High-order pages or fallback path if "bulk" fails. */
-	while (nr_allocated < nr_pages) {
-		struct page *page;
-		int i;
 
-		page = alloc_pages_node(nid, gfp, order);
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

