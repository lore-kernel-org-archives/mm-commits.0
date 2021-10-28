Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2C0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32320610D2
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhJ1Viw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhJ1Viw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 889F1610C8;
        Thu, 28 Oct 2021 21:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456984;
        bh=WVhw8Y976ZTLMdEnvihPl2gK6wkVzy91Q+hCljqUI/4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=J0NoVrz+HT0Ws9gk0ZrTHSj+YjLqZCqq0wX8TbNznbISt4ZXQI9oC8L24FpZ4Zwhb
         IQ5ARdkV2OTwPlTJPmhKNCWKaWTYFDms2FuBo5wn3nVhhOdEdPkmVIHQrPxnxFC7Kp
         S1jAm9j/6Ea8sRAff5wbURcGJvMvU7a743hz5RYA=
Date:   Thu, 28 Oct 2021 14:36:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenwandun@huawei.com,
        edumazet@google.com, guohanjun@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shakeelb@google.com,
        torvalds@linux-foundation.org, urezki@gmail.com,
        wangkefeng.wang@huawei.com
Subject:  [patch 07/11] mm/vmalloc: fix numa spreading for large
 hash tables
Message-ID: <20211028213624.ioyXk3qpi%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
