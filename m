Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB95C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5987020758
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597861271;
	bh=XB4pS0iDnfnfHQyZcYDCJmZzHXSrtZLq18igFxRho1U=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=sD5ptXcxQNnCRgsqFR6AIc5De7qkm/clucHq5NzFUUv3LfIEZAJmNoe2JucsmSb1Y
	 SZ2q9aTrlPa9hqtx+9aRAVaE37oXrY0s9Jlw+xZAIJ2Xe5hnXRMiInkdU/nxs+N8RN
	 Agtbv2jVMaJM0U7mNEE52vIfn6GIvVhjh60nrodc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHSSVK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 14:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbgHSSVG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 14:21:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A7CD20758;
        Wed, 19 Aug 2020 18:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597861265;
        bh=XB4pS0iDnfnfHQyZcYDCJmZzHXSrtZLq18igFxRho1U=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GNiAd5IBhPjrDwwjsR8KHHp3XCYUQmkQUXPUc/sfJdaASXjW2DJ4IEY54NYWzvWtd
         O/GOL3na6nOQ+ht9iCbxwh1o4iui2hcBllidTwh0ay22dcqyfYleQ4J2bSRl/ysBGD
         vYeMia4szenULGk+dCysJT7CSSn/O+0NeiDWQlJE=
Date:   Wed, 19 Aug 2020 11:21:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     bhe@redhat.com, charante@codeaurora.org, dan.j.williams@intel.com,
        david@redhat.com, fenghua.yu@intel.com, logang@deltatee.com,
        mgorman@suse.de, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        pankaj.gupta.linux@gmail.com, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tony.luck@intel.com, walken@google.com,
        willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-memory=5Fhotplug-mark-pageblocks-migrate=5Fisolate-whi?=
 =?US-ASCII?Q?le-onlining-memory.patch?= added to -mm tree
Message-ID: <20200819182104.52fpibeeh%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: mark pageblocks MIGRATE_ISOLATE while onlining memory
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
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
@@ -805,7 +805,7 @@ int __ref online_pages(unsigned long pfn
 
 	/* associate pfn range with the zone */
 	zone = zone_for_pfn_range(online_type, nid, pfn, nr_pages);
-	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE);
+	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_ISOLATE);
 
 	arg.start_pfn = pfn;
 	arg.nr_pages = nr_pages;
@@ -817,6 +817,14 @@ int __ref online_pages(unsigned long pfn
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
@@ -833,21 +841,25 @@ int __ref online_pages(unsigned long pfn
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
@@ -1552,9 +1564,9 @@ int __ref offline_pages(unsigned long st
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

Patches currently in -mm which might be from david@redhat.com are

mm-page_alloc-tweak-comments-in-has_unmovable_pages.patch
mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch
mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
mm-page_isolation-cleanup-set_migratetype_isolate.patch
virtio-mem-dont-special-case-zone_movable.patch
mm-document-semantics-of-zone_movable.patch
mm-memory_hotplug-inline-__offline_pages-into-offline_pages.patch
mm-memory_hotplug-enforce-section-granularity-when-onlining-offlining.patch
mm-memory_hotplug-simplify-page-offlining.patch
mm-page_alloc-simplify-__offline_isolated_pages.patch
mm-memory_hotplug-drop-nr_isolate_pageblock-in-offline_pages.patch
mm-page_isolation-simplify-return-value-of-start_isolate_page_range.patch
mm-memory_hotplug-simplify-page-onlining.patch
mm-page_alloc-drop-stale-pageblock-comment-in-memmap_init_zone.patch
mm-pass-migratetype-into-memmap_init_zone-and-move_pfn_range_to_zone.patch
mm-memory_hotplug-mark-pageblocks-migrate_isolate-while-onlining-memory.patch

