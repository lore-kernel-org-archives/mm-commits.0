Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B57C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CB3E2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817707;
	bh=FW83TaNXsnvhG4f+e4cruk51KvbWh8Si4IPRWEZD1p8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Aa5HPsvDtmoQuV7EePG6yZLg6636UlXElV0yv//3MAwXrnI2FxCNDmYNd+iDaRkyZ
	 H+dydOnkwaQ3YhRvfO3NaGUO0iH608tkxYh3X714UGz89uGjqKWYow51dRlrZ3LeV1
	 /6Y5T/99Lgs5SeOdcDKvVO5ljFuInQck6jYMoZu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731348AbgJPDI1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDI1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:08:27 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2492D20789;
        Fri, 16 Oct 2020 03:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817705;
        bh=FW83TaNXsnvhG4f+e4cruk51KvbWh8Si4IPRWEZD1p8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=edKZDnWetpodQPuowSru8htbmYj9FmY3vFrzwHVkc/v1bsQgZO2/ZEhQ9DqcZoZ1y
         sphqyUpzlbo7tEJ4ui6RXwclQkvwUVi8W26yu3MnHRtU6WliuKoYGVoqKKfZeyJ7B0
         7K6iRpULA+lraHt1W+PsWJ+H81J6Lvdkof0nvrjg=
Date:   Thu, 15 Oct 2020 20:08:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, charante@codeaurora.org,
        dan.j.williams@intel.com, david@redhat.com, fenghua.yu@intel.com,
        logang@deltatee.com, mgorman@suse.de, mgorman@techsingularity.net,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com,
        torvalds@linux-foundation.org, walken@google.com,
        willy@infradead.org
Subject:  [patch 068/156] mm/memory_hotplug: mark pageblocks
 MIGRATE_ISOLATE while onlining memory
Message-ID: <20201016030823.6vt7A-pKV%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: mark pageblocks MIGRATE_ISOLATE while onlining memory

Currently, it can happen that pages are allocated (and freed) via the
buddy before we finished basic memory onlining.

For example, pages are exposed to the buddy and can be allocated before we
actually mark the sections online.  Allocated pages could suddenly fail
pfn_to_online_page() checks.  We had similar issues with pcp handling,
when pages are allocated+freed before we reach zone_pcp_update() in
online_pages() [1].

Instead, mark all pageblocks MIGRATE_ISOLATE, such that allocations are
impossible.  Once done with the heavy lifting, use
undo_isolate_page_range() to move the pages to the MIGRATE_MOVABLE
freelist, marking them ready for allocation.  Similar to offline_pages(),
we have to manually adjust zone->nr_isolate_pageblock.

[1] https://lkml.kernel.org/r/1597150703-19003-1-git-send-email-charante@codeaurora.org

Link: https://lkml.kernel.org/r/20200819175957.28465-11-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Charan Teja Reddy <charante@codeaurora.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michel Lespinasse <walken@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig          |    2 +-
 mm/memory_hotplug.c |   32 ++++++++++++++++++++++----------
 2 files changed, 23 insertions(+), 11 deletions(-)

--- a/mm/Kconfig~mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory
+++ a/mm/Kconfig
@@ -152,6 +152,7 @@ config HAVE_BOOTMEM_INFO_NODE
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
+	select MEMORY_ISOLATION
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on 64BIT || BROKEN
@@ -178,7 +179,6 @@ config MEMORY_HOTPLUG_DEFAULT_ONLINE
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
-	select MEMORY_ISOLATION
 	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
--- a/mm/memory_hotplug.c~mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory
+++ a/mm/memory_hotplug.c
@@ -813,7 +813,7 @@ int __ref online_pages(unsigned long pfn
 
 	/* associate pfn range with the zone */
 	zone = zone_for_pfn_range(online_type, nid, pfn, nr_pages);
-	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE);
+	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_ISOLATE);
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
@@ -825,6 +825,14 @@ int __ref online_pages(unsigned long pfn
 		goto failed_addition;
 
 	/*
+	 * Fixup the number of isolated pageblocks before marking the sections
+	 * onlining, such that undo_isolate_page_range() works correctly.
+	 */
+	spin_lock_irqsave(&zone->lock, flags);
+	zone->nr_isolate_pageblock += nr_pages / pageblock_nr_pages;
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	/*
 	 * If this zone is not populated, then it is not in zonelist.
 	 * This means the page allocator ignores this zone.
 	 * So, zonelist must be updated after online.
@@ -841,21 +849,25 @@ int __ref online_pages(unsigned long pfn
 	zone->zone_pgdat->node_present_pages += nr_pages;
 	pgdat_resize_unlock(zone->zone_pgdat, &flags);
 
+	node_states_set_node(nid, &arg);
+	if (need_zonelists_rebuild)
+		build_all_zonelists(NULL);
+	zone_pcp_update(zone);
+
+	/* Basic onlining is complete, allow allocation of onlined pages. */
+	undo_isolate_page_range(pfn, pfn + nr_pages, MIGRATE_MOVABLE);
+
 	/*
 	 * When exposing larger, physically contiguous memory areas to the
 	 * buddy, shuffling in the buddy (when freeing onlined pages, putting
 	 * them either to the head or the tail of the freelist) is only helpful
 	 * for maintaining the shuffle, but not for creating the initial
 	 * shuffle. Shuffle the whole zone to make sure the just onlined pages
-	 * are properly distributed across the whole freelist.
+	 * are properly distributed across the whole freelist. Make sure to
+	 * shuffle once pageblocks are no longer isolated.
 	 */
 	shuffle_zone(zone);
 
-	node_states_set_node(nid, &arg);
-	if (need_zonelists_rebuild)
-		build_all_zonelists(NULL);
-	zone_pcp_update(zone);
-
 	init_per_zone_wmark_min();
 
 	kswapd_run(nid);
@@ -1577,9 +1589,9 @@ int __ref offline_pages(unsigned long st
 	pr_info("Offlined Pages %ld\n", nr_pages);
 
 	/*
-	 * Onlining will reset pagetype flags and makes migrate type
-	 * MOVABLE, so just need to decrease the number of isolated
-	 * pageblocks zone counter here.
+	 * The memory sections are marked offline, and the pageblock flags
+	 * effectively stale; nobody should be touching them. Fixup the number
+	 * of isolated pageblocks, memory onlining will properly revert this.
 	 */
 	spin_lock_irqsave(&zone->lock, flags);
 	zone->nr_isolate_pageblock -= nr_pages / pageblock_nr_pages;
_
