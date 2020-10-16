Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22A3C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96CC72087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816391;
	bh=9duJ/HbZPcKuwxPGheMqvgdki2o4OpqAQWX2FYauE14=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gbvvWQqOnXcOwSIVYWnxUEydF1kwxRsH86eQxh0Uft9AW9uZqxzv+jY/8KSCSs8th
	 TXtCWueZce0Nh/uDyqMRBxicOIk15yFSqHeNV+R5rOZYDKZl+g8PHXxRUb5uzgUyxK
	 Zc3esI0n1gckvqD8MD7dRafNxntWuFaZROGq8W6U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404333AbgJPCqb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731896AbgJPCqb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECAB020E65;
        Fri, 16 Oct 2020 02:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816390;
        bh=9duJ/HbZPcKuwxPGheMqvgdki2o4OpqAQWX2FYauE14=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2cugplFVontX/dcA8qPCRCbzXZCAjFy/76DsI2cNqqAQmF6O0ZFCgauoMG02BJH0k
         cjDMHFQOb4ng2g3oweXQAHt9/IU4Zn+P+zJZrh/Ood1JbPsgf7cbP37Zx/bQcD8q/B
         ROGMKCln3NiAXcMAcRE+10iXbOW6z69fmenqD95Q=
Date:   Thu, 15 Oct 2020 19:46:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alexander.h.duyck@linux.intel.com,
        cheloha@linux.ibm.com, dave.hansen@intel.com, david@redhat.com,
        haiyangz@microsoft.com, kys@microsoft.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, sthemmin@microsoft.com,
        torvalds@linux-foundation.org, vbabka@suse.cz, wei.liu@kernel.org,
        willy@infradead.org
Subject:  [patch 082/156] mm/page_alloc: place pages to tail in
 __free_pages_core()
Message-ID: <20201016024628.CwIUohTl6%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: place pages to tail in __free_pages_core()

__free_pages_core() is used when exposing fresh memory to the buddy during
system boot and when onlining memory in generic_online_page().

generic_online_page() is used in two cases:

1. Direct memory onlining in online_pages().
2. Deferred memory onlining in memory-ballooning-like mechanisms (HyperV
   balloon and virtio-mem), when parts of a section are kept
   fake-offline to be fake-onlined later on.

In 1, we already place pages to the tail of the freelist.  Pages will be
freed to MIGRATE_ISOLATE lists first and moved to the tail of the
freelists via undo_isolate_page_range().

In 2, we currently don't implement a proper rule.  In case of virtio-mem,
where we currently always online MAX_ORDER - 1 pages, the pages will be
placed to the HEAD of the freelist - undesireable.  While the hyper-v
balloon calls generic_online_page() with single pages, usually it will
call it on successive single pages in a larger block.

The pages are fresh, so place them to the tail of the freelist and avoid
the PCP.  In __free_pages_core(), remove the now superflouos call to
set_page_refcounted() and add a comment regarding page initialization and
the refcount.

Note: In 2.  we currently don't shuffle.  If ever relevant (page shuffling
is usually of limited use in virtualized environments), we might want to
shuffle after a sequence of generic_online_page() calls in the relevant
callers.

Link: https://lkml.kernel.org/r/20201005121534.15649-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-place-pages-to-tail-in-__free_pages_core
+++ a/mm/page_alloc.c
@@ -275,7 +275,8 @@ bool pm_suspended_storage(void)
 unsigned int pageblock_order __read_mostly;
 #endif
 
-static void __free_pages_ok(struct page *page, unsigned int order);
+static void __free_pages_ok(struct page *page, unsigned int order,
+			    fpi_t fpi_flags);
 
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
@@ -687,7 +688,7 @@ out:
 void free_compound_page(struct page *page)
 {
 	mem_cgroup_uncharge(page);
-	__free_pages_ok(page, compound_order(page));
+	__free_pages_ok(page, compound_order(page), FPI_NONE);
 }
 
 void prep_compound_page(struct page *page, unsigned int order)
@@ -1423,14 +1424,14 @@ static void free_pcppages_bulk(struct zo
 static void free_one_page(struct zone *zone,
 				struct page *page, unsigned long pfn,
 				unsigned int order,
-				int migratetype)
+				int migratetype, fpi_t fpi_flags)
 {
 	spin_lock(&zone->lock);
 	if (unlikely(has_isolate_pageblock(zone) ||
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype, FPI_NONE);
+	__free_one_page(page, pfn, zone, order, migratetype, fpi_flags);
 	spin_unlock(&zone->lock);
 }
 
@@ -1508,7 +1509,8 @@ void __meminit reserve_bootmem_region(ph
 	}
 }
 
-static void __free_pages_ok(struct page *page, unsigned int order)
+static void __free_pages_ok(struct page *page, unsigned int order,
+			    fpi_t fpi_flags)
 {
 	unsigned long flags;
 	int migratetype;
@@ -1520,7 +1522,8 @@ static void __free_pages_ok(struct page
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, pfn, order, migratetype);
+	free_one_page(page_zone(page), page, pfn, order, migratetype,
+		      fpi_flags);
 	local_irq_restore(flags);
 }
 
@@ -1530,6 +1533,11 @@ void __free_pages_core(struct page *page
 	struct page *p = page;
 	unsigned int loop;
 
+	/*
+	 * When initializing the memmap, __init_single_page() sets the refcount
+	 * of all pages to 1 ("allocated"/"not free"). We have to set the
+	 * refcount of all involved pages to 0.
+	 */
 	prefetchw(p);
 	for (loop = 0; loop < (nr_pages - 1); loop++, p++) {
 		prefetchw(p + 1);
@@ -1540,8 +1548,12 @@ void __free_pages_core(struct page *page
 	set_page_count(p, 0);
 
 	atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
-	set_page_refcounted(page);
-	__free_pages(page, order);
+
+	/*
+	 * Bypass PCP and place fresh pages right to the tail, primarily
+	 * relevant for memory onlining.
+	 */
+	__free_pages_ok(page, order, FPI_TO_TAIL);
 }
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
@@ -3168,7 +3180,8 @@ static void free_unref_page_commit(struc
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
 		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(zone, page, pfn, 0, migratetype);
+			free_one_page(zone, page, pfn, 0, migratetype,
+				      FPI_NONE);
 			return;
 		}
 		migratetype = MIGRATE_MOVABLE;
@@ -4991,7 +5004,7 @@ static inline void free_the_page(struct
 	if (order == 0)		/* Via pcp? */
 		free_unref_page(page);
 	else
-		__free_pages_ok(page, order);
+		__free_pages_ok(page, order, FPI_NONE);
 }
 
 void __free_pages(struct page *page, unsigned int order)
_
