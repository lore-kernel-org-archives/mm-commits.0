Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B39C41604
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 05:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F52208C3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 05:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601961356;
	bh=zTM5VSuKUGr7+FSQKbQw+VwpMY2ZUBKhqQ6euha1RCI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ys8WpQZHBwsHGO8OtJOScyhkMnCtf4QX73Q0RMU6JRCSiT+RZfpVKoHqypnDnv/u2
	 DkamZ4d5TlW4RENBG95bj7KM3t8gRZpYMEQSfqbVNVVCe+g0ycQuHefjdZw7ulxN2Q
	 5JhP+TSj5su8GiCz1cpV/J7fhOQaGgKbz75aullE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJFFP4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 01:15:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJFFP4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 01:15:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F07320870;
        Tue,  6 Oct 2020 05:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601961355;
        bh=zTM5VSuKUGr7+FSQKbQw+VwpMY2ZUBKhqQ6euha1RCI=;
        h=Date:From:To:Subject:From;
        b=jeKBt74NSeTqM3ItYWG33x7dNyMCZ4jrNSEQ7ku0g089L1nO3c5e0a+8HgCXOTb3U
         G/AeZvsiUrFcM7+xrcnqRTiL5l5v/r3Twqw4qNCzkWA0NkpkCGSZo8Mu7XBxpPsI1u
         bNqs2h8Ze206CrYA8q4DsrfsBK/PmEYKfs8A06kc=
Date:   Mon, 05 Oct 2020 22:15:53 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, cheloha@linux.ibm.com,
        dave.hansen@intel.com, david@redhat.com, haiyangz@microsoft.com,
        kys@microsoft.com, mgorman@techsingularity.net, mhocko@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        osalvador@suse.de, pankaj.gupta.linux@gmail.com,
        richard.weiyang@linux.alibaba.com, rppt@kernel.org,
        sthemmin@microsoft.com, vbabka@suse.cz, wei.liu@kernel.org,
        willy@infradead.org
Subject:  +
 mm-page_alloc-convert-report-flag-of-__free_one_page-to-a-proper-flag.patch
 added to -mm tree
Message-ID: <20201006051553.9kRAwOg9S%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: convert "report" flag of __free_one_page() to a proper flag
has been added to the -mm tree.  Its filename is
     mm-page_alloc-convert-report-flag-of-__free_one_page-to-a-proper-flag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-convert-report-flag-of-__free_one_page-to-a-proper-flag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-convert-report-flag-of-__free_one_page-to-a-proper-flag.patch

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
Subject: mm/page_alloc: convert "report" flag of __free_one_page() to a proper flag

Patch series "mm: place pages to the freelist tail when onlining and undoing isolation", v2.

When adding separate memory blocks via add_memory*() and onlining them
immediately, the metadata (especially the memmap) of the next block will
be placed onto one of the just added+onlined block.  This creates a chain
of unmovable allocations: If the last memory block cannot get
offlined+removed() so will all dependent ones.  We directly have unmovable
allocations all over the place.

This can be observed quite easily using virtio-mem, however, it can also
be observed when using DIMMs.  The freshly onlined pages will usually be
placed to the head of the freelists, meaning they will be allocated next,
turning the just-added memory usually immediately un-removable.  The fresh
pages are cold, prefering to allocate others (that might be hot) also
feels to be the natural thing to do.

It also applies to the hyper-v balloon xen-balloon, and ppc64 dlpar: when
adding separate, successive memory blocks, each memory block will have
unmovable allocations on them - for example gigantic pages will fail to
allocate.

While the ZONE_NORMAL doesn't provide any guarantees that memory can get
offlined+removed again (any kind of fragmentation with unmovable
allocations is possible), there are many scenarios (hotplugging a lot of
memory, running workload, hotunplug some memory/as much as possible) where
we can offline+remove quite a lot with this patchset.

a) To visualize the problem, a very simple example:

Start a VM with 4GB and 8GB of virtio-mem memory:

 [root@localhost ~]# lsmem
 RANGE                                 SIZE  STATE REMOVABLE  BLOCK
 0x0000000000000000-0x00000000bfffffff   3G online       yes   0-23
 0x0000000100000000-0x000000033fffffff   9G online       yes 32-103

 Memory block size:       128M
 Total online memory:      12G
 Total offline memory:      0B

Then try to unplug as much as possible using virtio-mem. Observe which
memory blocks are still around. Without this patch set:

 [root@localhost ~]# lsmem
 RANGE                                  SIZE  STATE REMOVABLE   BLOCK
 0x0000000000000000-0x00000000bfffffff    3G online       yes    0-23
 0x0000000100000000-0x000000013fffffff    1G online       yes   32-39
 0x0000000148000000-0x000000014fffffff  128M online       yes      41
 0x0000000158000000-0x000000015fffffff  128M online       yes      43
 0x0000000168000000-0x000000016fffffff  128M online       yes      45
 0x0000000178000000-0x000000017fffffff  128M online       yes      47
 0x0000000188000000-0x0000000197ffffff  256M online       yes   49-50
 0x00000001a0000000-0x00000001a7ffffff  128M online       yes      52
 0x00000001b0000000-0x00000001b7ffffff  128M online       yes      54
 0x00000001c0000000-0x00000001c7ffffff  128M online       yes      56
 0x00000001d0000000-0x00000001d7ffffff  128M online       yes      58
 0x00000001e0000000-0x00000001e7ffffff  128M online       yes      60
 0x00000001f0000000-0x00000001f7ffffff  128M online       yes      62
 0x0000000200000000-0x0000000207ffffff  128M online       yes      64
 0x0000000210000000-0x0000000217ffffff  128M online       yes      66
 0x0000000220000000-0x0000000227ffffff  128M online       yes      68
 0x0000000230000000-0x0000000237ffffff  128M online       yes      70
 0x0000000240000000-0x0000000247ffffff  128M online       yes      72
 0x0000000250000000-0x0000000257ffffff  128M online       yes      74
 0x0000000260000000-0x0000000267ffffff  128M online       yes      76
 0x0000000270000000-0x0000000277ffffff  128M online       yes      78
 0x0000000280000000-0x0000000287ffffff  128M online       yes      80
 0x0000000290000000-0x0000000297ffffff  128M online       yes      82
 0x00000002a0000000-0x00000002a7ffffff  128M online       yes      84
 0x00000002b0000000-0x00000002b7ffffff  128M online       yes      86
 0x00000002c0000000-0x00000002c7ffffff  128M online       yes      88
 0x00000002d0000000-0x00000002d7ffffff  128M online       yes      90
 0x00000002e0000000-0x00000002e7ffffff  128M online       yes      92
 0x00000002f0000000-0x00000002f7ffffff  128M online       yes      94
 0x0000000300000000-0x0000000307ffffff  128M online       yes      96
 0x0000000310000000-0x0000000317ffffff  128M online       yes      98
 0x0000000320000000-0x0000000327ffffff  128M online       yes     100
 0x0000000330000000-0x000000033fffffff  256M online       yes 102-103

 Memory block size:       128M
 Total online memory:     8.1G
 Total offline memory:      0B

With this patch set:

 [root@localhost ~]# lsmem
 RANGE                                 SIZE  STATE REMOVABLE BLOCK
 0x0000000000000000-0x00000000bfffffff   3G online       yes  0-23
 0x0000000100000000-0x000000013fffffff   1G online       yes 32-39

 Memory block size:       128M
 Total online memory:       4G
 Total offline memory:      0B

All memory can get unplugged, all memory block can get removed.  Of
course, no workload ran and the system was basically idle, but it
highlights the issue - the fairly deterministic chain of unmovable
allocations.  When a huge page for the 2MB memmap is needed, a
just-onlined 4MB page will be split.  The remaining 2MB page will be used
for the memmap of the next memory block.  So one memory block will hold
the memmap of the two following memory blocks.  Finally the pages of the
last-onlined memory block will get used for the next bigger allocations -
if any allocation is unmovable, all dependent memory blocks cannot get
unplugged and removed until that allocation is gone.

Note that with bigger memory blocks (e.g., 256MB), *all* memory
blocks are dependent and none can get unplugged again!

b) Experiment with memory intensive workload

I performed an experiment with an older version of this patch set (before
we used undo_isolate_page_range() in online_pages(): Hotplug 56GB to a VM
with an initial 4GB, onlining all memory to ZONE_NORMAL right from the
kernel when adding it.  I then run various memory intensive workloads that
consume most system memory for a total of 45 minutes.  Once finished, I
try to unplug as much memory as possible.

With this change, I am able to remove via virtio-mem (adding individual
128MB memory blocks) 413 out of 448 added memory blocks.  Via individual
(256MB) DIMMs 380 out of 448 added memory blocks.  (I don't have any
numbers without this patchset, but looking at the above example, it's at
most half of the 448 memory blocks for virtio-mem, and most probably none
for DIMMs).

Again, there are workloads that might behave very differently due to the
nature of ZONE_NORMAL.

This change also affects (besides memory onlining):
- Other users of undo_isolate_page_range(): Pages are always placed to the
  tail.
-- When memory offlining fails
-- When memory isolation fails after having isolated some pageblocks
-- When alloc_contig_range() either succeeds or fails
- Other users of __putback_isolated_page(): Pages are always placed to the
  tail.
-- Free page reporting
- Other users of __free_pages_core()
-- AFAIKs, any memory that is getting exposed to the buddy during boot.
   IIUC we will now usually allocate memory from lower addresses within
   a zone first (especially during boot).
- Other users of generic_online_page()
-- Hyper-V balloon


This patch (of 5):

Let's prepare for additional flags and avoid long parameter lists of
bools.  Follow-up patches will also make use of the flags in
__free_pages_ok().

Link: https://lkml.kernel.org/r/20201005121534.15649-1-david@redhat.com
Link: https://lkml.kernel.org/r/20201005121534.15649-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-convert-report-flag-of-__free_one_page-to-a-proper-flag
+++ a/mm/page_alloc.c
@@ -78,6 +78,22 @@
 #include "shuffle.h"
 #include "page_reporting.h"
 
+/* Free Page Internal flags: for internal, non-pcp variants of free_pages(). */
+typedef int __bitwise fpi_t;
+
+/* No special request */
+#define FPI_NONE		((__force fpi_t)0)
+
+/*
+ * Skip free page reporting notification for the (possibly merged) page.
+ * This does not hinder free page reporting from grabbing the page,
+ * reporting it and marking it "reported" -  it only skips notifying
+ * the free page reporting infrastructure about a newly freed page. For
+ * example, used when temporarily pulling a page from a freelist and
+ * putting it back unmodified.
+ */
+#define FPI_SKIP_REPORT_NOTIFY	((__force fpi_t)BIT(0))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_FRACTION	(8)
@@ -952,7 +968,7 @@ buddy_merge_likely(unsigned long pfn, un
 static inline void __free_one_page(struct page *page,
 		unsigned long pfn,
 		struct zone *zone, unsigned int order,
-		int migratetype, bool report)
+		int migratetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
 	unsigned long buddy_pfn;
@@ -1039,7 +1055,7 @@ done_merging:
 		add_to_free_list(page, zone, order, migratetype);
 
 	/* Notify page reporting subsystem of freed page */
-	if (report)
+	if (!(fpi_flags & FPI_SKIP_REPORT_NOTIFY))
 		page_reporting_notify_free(order);
 }
 
@@ -1380,7 +1396,7 @@ static void free_pcppages_bulk(struct zo
 		if (unlikely(isolated_pageblocks))
 			mt = get_pageblock_migratetype(page);
 
-		__free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
+		__free_one_page(page, page_to_pfn(page), zone, 0, mt, FPI_NONE);
 		trace_mm_page_pcpu_drain(page, 0, mt);
 	}
 	spin_unlock(&zone->lock);
@@ -1396,7 +1412,7 @@ static void free_one_page(struct zone *z
 		is_migrate_isolate(migratetype))) {
 		migratetype = get_pfnblock_migratetype(page, pfn);
 	}
-	__free_one_page(page, pfn, zone, order, migratetype, true);
+	__free_one_page(page, pfn, zone, order, migratetype, FPI_NONE);
 	spin_unlock(&zone->lock);
 }
 
@@ -3289,7 +3305,8 @@ void __putback_isolated_page(struct page
 	lockdep_assert_held(&zone->lock);
 
 	/* Return isolated page to tail of freelist. */
-	__free_one_page(page, page_to_pfn(page), zone, order, mt, false);
+	__free_one_page(page, page_to_pfn(page), zone, order, mt,
+			FPI_SKIP_REPORT_NOTIFY);
 }
 
 /*
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
kernel-resource-make-release_mem_region_adjustable-never-fail.patch
kernel-resource-move-and-rename-ioresource_mem_driver_managed.patch
mm-memory_hotplug-guard-more-declarations-by-config_memory_hotplug.patch
mm-memory_hotplug-prepare-passing-flags-to-add_memory-and-friends.patch
mm-memory_hotplug-memhp_merge_resource-to-specify-merging-of-system-ram-resources.patch
virtio-mem-try-to-merge-system-ram-resources.patch
xen-balloon-try-to-merge-system-ram-resources.patch
hv_balloon-try-to-merge-system-ram-resources.patch
kernel-resource-make-iomem_resource-implicit-in-release_mem_region_adjustable.patch
mm-page_alloc-convert-report-flag-of-__free_one_page-to-a-proper-flag.patch
mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page.patch
mm-page_alloc-move-pages-to-tail-in-move_to_free_list.patch
mm-page_alloc-place-pages-to-tail-in-__free_pages_core.patch
mm-memory_hotplug-update-comment-regarding-zone-shuffling.patch

