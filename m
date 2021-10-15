Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5201C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F40611CE
	for <mm-commits@archiver.kernel.org>; Fri, 15 Oct 2021 21:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243019AbhJOVOX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 15 Oct 2021 17:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234257AbhJOVOU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 Oct 2021 17:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9B5761151;
        Fri, 15 Oct 2021 21:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634332334;
        bh=G+MXG6zFsgS81JrNIJC6gxZk1V1zaIFRxoYiY1zg8QM=;
        h=Date:From:To:Subject:From;
        b=z0+FZF58ZOomiMID2x3DBpVtqJPm7+COjdvDvnUNvZd+2cIDe/mOM8lM7ruTl5oeD
         yr3g3nlLe6Uy1BajMzAvpkW3lH7BNmUKJFJShU0pIMHLk/qo3sLpEdPEHeLQao5diy
         q64zqXLYowpH6c3aZ30wcup8tXhiq9opBV7lTNRU=
Date:   Fri, 15 Oct 2021 14:12:13 -0700
From:   akpm@linux-foundation.org
To:     chenwandun@huawei.com, edumazet@google.com, guohanjun@huawei.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shakeelb@google.com,
        urezki@gmail.com, wangkefeng.wang@huawei.com
Subject:  +
 =?US-ASCII?Q?mm-vmalloc-introduce-alloc=5Fpages=5Fbulk=5Farray=5Fmempoli?=
 =?US-ASCII?Q?cy-to-accelerate-memory-allocation.patch?= added to -mm tree
Message-ID: <20211015211213.0HGunDuS2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: introduce alloc_pages_bulk_array_mempolicy to accelerate memory allocation
has been added to the -mm tree.  Its filename is
     mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Wandun <chenwandun@huawei.com>
Subject: mm/vmalloc: introduce alloc_pages_bulk_array_mempolicy to accelerate memory allocation

It will cause significant performance regressions in some situations as
Andrew mentioned in [1].  The main situation is vmalloc, vmalloc will
allocate pages with NUMA_NO_NODE by default, that will result in alloc
page one by one;

In order to solve this, __alloc_pages_bulk and mempolicy should be
considered at the same time.

1) If node is specified in memory allocation request, it will alloc all
   pages by __alloc_pages_bulk.

2) If interleaving allocate memory, it will cauculate how many pages
   should be allocated in each node, and use __alloc_pages_bulk to alloc
   pages in each node.

Based on "[PATCH] mm/vmalloc: fix numa spreading for large hash
   tables".

[1]: https://lore.kernel.org/lkml/CALvZod4G3SzP3kWxQYn0fj+VgG-G3yWXz=gz17+3N57ru1iajw@mail.gmail.com/t/#m750c8e3231206134293b089feaa090590afa0f60

Link: https://lkml.kernel.org/r/20211014092952.1500982-1-chenwandun@huawei.com
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++
 mm/mempolicy.c      |   76 ++++++++++++++++++++++++++++++++++++++++++
 mm/vmalloc.c        |   19 ++--------
 3 files changed, 85 insertions(+), 14 deletions(-)

--- a/include/linux/gfp.h~mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation
+++ a/include/linux/gfp.h
@@ -535,6 +535,10 @@ unsigned long __alloc_pages_bulk(gfp_t g
 				struct list_head *page_list,
 				struct page **page_array);
 
+unsigned long alloc_pages_bulk_array_mempolicy(gfp_t gfp,
+				unsigned long nr_pages,
+				struct page **page_array);
+
 /* Bulk allocate order-0 pages */
 static inline unsigned long
 alloc_pages_bulk_list(gfp_t gfp, unsigned long nr_pages, struct list_head *list)
--- a/mm/mempolicy.c~mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation
+++ a/mm/mempolicy.c
@@ -2196,6 +2196,82 @@ struct page *alloc_pages(gfp_t gfp, unsi
 }
 EXPORT_SYMBOL(alloc_pages);
 
+unsigned long alloc_pages_bulk_array_interleave(gfp_t gfp,
+		struct mempolicy *pol, unsigned long nr_pages,
+		struct page **page_array)
+{
+	int nodes;
+	unsigned long nr_pages_per_node;
+	int delta;
+	int i;
+	unsigned long nr_allocated;
+	unsigned long total_allocated = 0;
+
+	nodes = nodes_weight(pol->nodes);
+	nr_pages_per_node = nr_pages / nodes;
+	delta = nr_pages - nodes * nr_pages_per_node;
+
+	for (i = 0; i < nodes; i++) {
+		if (delta) {
+			nr_allocated = __alloc_pages_bulk(gfp,
+					interleave_nodes(pol), NULL,
+					nr_pages_per_node + 1, NULL,
+					page_array);
+			delta--;
+		} else {
+			nr_allocated = __alloc_pages_bulk(gfp,
+					interleave_nodes(pol), NULL,
+					nr_pages_per_node, NULL, page_array);
+		}
+
+		page_array += nr_allocated;
+		total_allocated += nr_allocated;
+	}
+
+	return total_allocated;
+}
+
+unsigned long alloc_pages_bulk_array_preferred_many(gfp_t gfp, int nid,
+		struct mempolicy *pol, unsigned long nr_pages,
+		struct page **page_array)
+{
+	gfp_t preferred_gfp;
+	unsigned long nr_allocated = 0;
+
+	preferred_gfp = gfp | __GFP_NOWARN;
+	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
+
+	nr_allocated  = __alloc_pages_bulk(preferred_gfp, nid, &pol->nodes,
+					   nr_pages, NULL, page_array);
+
+	if (nr_allocated < nr_pages)
+		nr_allocated += __alloc_pages_bulk(gfp, numa_node_id(), NULL,
+				nr_pages - nr_allocated, NULL,
+				page_array + nr_allocated);
+	return nr_allocated;
+}
+
+unsigned long alloc_pages_bulk_array_mempolicy(gfp_t gfp,
+		unsigned long nr_pages, struct page **page_array)
+{
+	struct mempolicy *pol = &default_policy;
+
+	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
+		pol = get_task_policy(current);
+
+	if (pol->mode == MPOL_INTERLEAVE)
+		return alloc_pages_bulk_array_interleave(gfp, pol,
+							 nr_pages, page_array);
+
+	if (pol->mode == MPOL_PREFERRED_MANY)
+		return alloc_pages_bulk_array_preferred_many(gfp,
+				numa_node_id(), pol, nr_pages, page_array);
+
+	return __alloc_pages_bulk(gfp, policy_node(gfp, pol, numa_node_id()),
+				  policy_nodemask(gfp, pol), nr_pages, NULL,
+				  page_array);
+}
+
 int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
 {
 	struct mempolicy *pol = mpol_dup(vma_policy(src));
--- a/mm/vmalloc.c~mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation
+++ a/mm/vmalloc.c
@@ -2856,23 +2856,14 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 */
 			nr_pages_request = min(100U, nr_pages - nr_allocated);
 
-			if (nid == NUMA_NO_NODE) {
-				for (i = 0; i < nr_pages_request; i++) {
-					page = alloc_page(gfp);
-					if (page)
-						pages[nr_allocated + i] = page;
-					else {
-						nr = i;
-						break;
-					}
-				}
-				if (i >= nr_pages_request)
-					nr = nr_pages_request;
-			} else {
+			if (nid == NUMA_NO_NODE)
+				nr = alloc_pages_bulk_array_mempolicy(gfp,
+							nr_pages_request,
+							pages + nr_allocated);
+			else
 				nr = alloc_pages_bulk_array_node(gfp, nid,
 							nr_pages_request,
 							pages + nr_allocated);
-			}
 			nr_allocated += nr;
 			cond_resched();
 
_

Patches currently in -mm which might be from chenwandun@huawei.com are

mm-vmalloc-fix-numa-spreading-for-large-hash-tables.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch

