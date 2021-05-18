Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F367C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C866135B
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbhERXlk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 19:41:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhERXlh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 19:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA69D6112F;
        Tue, 18 May 2021 23:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621381219;
        bh=2v1hTlPSz2gkOnoRWZaVe/Ft3u18ottOYotUbEMe4tc=;
        h=Date:From:To:Subject:From;
        b=kb36pqi8RZaDB/zKKRvRB9kS2xbMllbNqV1hk+DRXgtnYoGx2Pk+EPiq4KuB07uHL
         hDkPIbDH9ykxLpWaFHHH96ekYdFTqaVP63ybvOjQQCLeWPodTUKC9e08O1KDmLyRyW
         cgnJ27w8WQH2P8mwDU0SWLud0FFyufdhBJfXQ40I=
Date:   Tue, 18 May 2021 16:40:18 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject:  +
 mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch added to
 -mm tree
Message-ID: <20210518234018.BtvV1jRlJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()

Recently there has been introduced a page bulk allocator for users which
need to get number of pages per one call request.

For order-0 pages switch to an alloc_pages_bulk_array_node() instead of
alloc_pages_node(), the reason is the former is not capable of allocating
set of pages, thus a one call is per one page.

Second, according to my tests the bulk allocator uses less cycles even for
scenarios when only one page is requested.  Running the "perf" on same
test case shows below difference:

<default>
  - 45.18% __vmalloc_node
     - __vmalloc_node_range
        - 35.60% __alloc_pages
           - get_page_from_freelist
                3.36% __list_del_entry_valid
                3.00% check_preemption_disabled
                1.42% prep_new_page
<default>

<patch>
  - 31.00% __vmalloc_node
     - __vmalloc_node_range
        - 14.48% __alloc_pages_bulk
             3.22% __list_del_entry_valid
           - 0.83% __alloc_pages
                get_page_from_freelist
<patch>

The "test_vmalloc.sh" also shows performance improvements:

fix_size_alloc_test_4MB   loops: 1000000 avg: 89105095 usec
fix_size_alloc_test       loops: 1000000 avg: 513672   usec
full_fit_alloc_test       loops: 1000000 avg: 748900   usec
long_busy_list_alloc_test loops: 1000000 avg: 8043038  usec
random_size_alloc_test    loops: 1000000 avg: 4028582  usec
fix_align_alloc_test      loops: 1000000 avg: 1457671  usec

fix_size_alloc_test_4MB   loops: 1000000 avg: 62083711 usec
fix_size_alloc_test       loops: 1000000 avg: 449207   usec
full_fit_alloc_test       loops: 1000000 avg: 735985   usec
long_busy_list_alloc_test loops: 1000000 avg: 5176052  usec
random_size_alloc_test    loops: 1000000 avg: 2589252  usec
fix_align_alloc_test      loops: 1000000 avg: 1365009  usec

For example 4MB allocations illustrates ~30% gain, all the
rest is also better.

Link: https://lkml.kernel.org/r/20210516202056.2120-3-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   76 +++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 34 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node
+++ a/mm/vmalloc.c
@@ -2765,8 +2765,6 @@ static void *__vmalloc_area_node(struct
 	unsigned long array_size;
 	unsigned int nr_small_pages = size >> PAGE_SHIFT;
 	unsigned int page_order;
-	struct page **pages;
-	unsigned int i;
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
@@ -2775,13 +2773,13 @@ static void *__vmalloc_area_node(struct
 
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, 1, nested_gfp, node,
+		area->pages = __vmalloc_node(array_size, 1, nested_gfp, node,
 					area->caller);
 	} else {
-		pages = kmalloc_node(array_size, nested_gfp, node);
+		area->pages = kmalloc_node(array_size, nested_gfp, node);
 	}
 
-	if (!pages) {
+	if (!area->pages) {
 		free_vm_area(area);
 		warn_alloc(gfp_mask, NULL,
 			   "vmalloc size %lu allocation failure: "
@@ -2790,43 +2788,53 @@ static void *__vmalloc_area_node(struct
 		return NULL;
 	}
 
-	area->pages = pages;
-	area->nr_pages = nr_small_pages;
+	area->nr_pages = 0;
 	set_vm_area_page_order(area, page_shift - PAGE_SHIFT);
-
 	page_order = vm_area_page_order(area);
 
-	/*
-	 * Careful, we allocate and map page_order pages, but tracking is done
-	 * per PAGE_SIZE page so as to keep the vm_struct APIs independent of
-	 * the physical/mapped size.
-	 */
-	for (i = 0; i < area->nr_pages; i += 1U << page_order) {
-		struct page *page;
-		int p;
-
-		/* Compound pages required for remap_vmalloc_page */
-		page = alloc_pages_node(node, gfp_mask | __GFP_COMP, page_order);
-		if (unlikely(!page)) {
-			/* Successfully allocated i pages, free them in __vfree() */
-			area->nr_pages = i;
-			atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
-			warn_alloc(gfp_mask, NULL,
-				   "vmalloc size %lu allocation failure: "
-				   "page order %u allocation failed",
-				   area->nr_pages * PAGE_SIZE, page_order);
-			goto fail;
-		}
+	if (!page_order) {
+		area->nr_pages = alloc_pages_bulk_array_node(
+			gfp_mask, node, nr_small_pages, area->pages);
+	} else {
+		/*
+		 * Careful, we allocate and map page_order pages, but tracking is done
+		 * per PAGE_SIZE page so as to keep the vm_struct APIs independent of
+		 * the physical/mapped size.
+		 */
+		while (area->nr_pages < nr_small_pages) {
+			struct page *page;
+			int i;
+
+			/* Compound pages required for remap_vmalloc_page */
+			page = alloc_pages_node(node, gfp_mask | __GFP_COMP, page_order);
+			if (unlikely(!page))
+				break;
+
+			for (i = 0; i < (1U << page_order); i++)
+				area->pages[area->nr_pages + i] = page + i;
 
-		for (p = 0; p < (1U << page_order); p++)
-			area->pages[i + p] = page + p;
+			if (gfpflags_allow_blocking(gfp_mask))
+				cond_resched();
 
-		if (gfpflags_allow_blocking(gfp_mask))
-			cond_resched();
+			area->nr_pages += 1U << page_order;
+		}
 	}
+
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 
-	if (vmap_pages_range(addr, addr + size, prot, pages, page_shift) < 0) {
+	/*
+	 * If not enough pages were obtained to accomplish an
+	 * allocation request, free them via __vfree() if any.
+	 */
+	if (area->nr_pages != nr_small_pages) {
+		warn_alloc(gfp_mask, NULL,
+			"vmalloc size %lu allocation failure: "
+			"page order %u allocation failed",
+			area->nr_pages * PAGE_SIZE, page_order);
+		goto fail;
+	}
+
+	if (vmap_pages_range(addr, addr + size, prot, area->pages, page_shift) < 0) {
 		warn_alloc(gfp_mask, NULL,
 			   "vmalloc size %lu allocation failure: "
 			   "failed to map pages",
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-page_alloc-add-an-alloc_pages_bulk_array_node-helper.patch
mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch
mm-vmalloc-print-a-warning-message-first-on-failure.patch

