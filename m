Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81A6C433B4
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AB7361155
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 21:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240034AbhELVNq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 17:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1387032AbhELUbx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 16:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B0C61425;
        Wed, 12 May 2021 20:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620851390;
        bh=S3MpxxIW1kCCYbRqUxzsv7lZ6uWOFQ2D4sgSS8qYmR4=;
        h=Date:From:To:Subject:From;
        b=k0Ab2N7SMHIbb4OOLcds2Dgcvt7RRlh0K1SrKyzNUu5ErYQgnpig8B+i/EmFCp5AK
         mxvnqef2w60Aru74F8A8eoZZzGC/7Ew01BZo9y7g2FdSk9o2CflEgQwYlCSOdFSzTT
         JbCP5tvnpFLGPaPJPjzE7ZeAa71rBxQiIc4XvI2M=
Date:   Wed, 12 May 2021 13:29:49 -0700
From:   akpm@linux-foundation.org
To:     hdanton@sina.com, mgorman@suse.de, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        sfr@canb.auug.org.au, urezki@gmail.com, willy@infradead.org
Subject:  [failures]
 mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch removed
 from -mm tree
Message-ID: <20210512202949.eUYaWpNcg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-switch-to-bulk-allocator-in-__vmalloc_area_node.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: switch to bulk allocator in __vmalloc_area_node()

Recently there has been introduced a page bulk allocator for users which
need to get number of pages per one call request.

For order-0 pages switch to __alloc_pages_bulk() instead of
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

Link: https://lkml.kernel.org/r/20210509193844.2562-1-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   74 ++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

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
@@ -2790,43 +2788,51 @@ static void *__vmalloc_area_node(struct
 		return NULL;
 	}
 
-	area->pages = pages;
-	area->nr_pages = nr_small_pages;
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
+		area->nr_pages = __alloc_pages_bulk(gfp_mask, node,
+			NULL, nr_small_pages, NULL, area->pages);
+	} else {
+		/*
+		 * Careful, we allocate and map page_order pages, but tracking is done
+		 * per PAGE_SIZE page so as to keep the vm_struct APIs independent of
+		 * the physical/mapped size.
+		 */
+		for (area->nr_pages = 0; area->nr_pages < nr_small_pages;
+				area->nr_pages += 1U << page_order) {
+			struct page *page;
+			int i;
+
+			/* Compound pages required for remap_vmalloc_page */
+			page = alloc_pages_node(node, gfp_mask | __GFP_COMP, page_order);
+			if (unlikely(!page))
+				break;
 
-		for (p = 0; p < (1U << page_order); p++)
-			area->pages[i + p] = page + p;
+			for (i = 0; i < (1U << page_order); i++)
+				area->pages[area->nr_pages + i] = page + i;
 
-		if (gfpflags_allow_blocking(gfp_mask))
-			cond_resched();
+			if (gfpflags_allow_blocking(gfp_mask))
+				cond_resched();
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

mm-vmalloc-print-a-warning-message-first-on-failure.patch

