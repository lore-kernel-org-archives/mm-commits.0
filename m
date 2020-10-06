Return-Path: <SRS0=SqaX=DN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62177C41604
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 04:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024E6208C3
	for <mm-commits@archiver.kernel.org>; Tue,  6 Oct 2020 04:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601960241;
	bh=2FxnkdGWqIODt5G6smKMaE6VUKSNj3C61wyA2WtWSG0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IbSPvaBT0N1on8S111cHLAGyuo6azmVvM69zkP6pqEy+L4X/VnIeiBU4wpQFGrjaK
	 Il8SrE97W2qO7I0lYC+6AuGOyZhzsmedkxeZkxIjM0eVAfwL/+NoyEhVMAI0p3L0jG
	 63OhLoxOQnM4lQTYlFdT+XGj3JyC5fbPhEimACxU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgJFE5U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Oct 2020 00:57:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgJFE5U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Oct 2020 00:57:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C5D20782;
        Tue,  6 Oct 2020 04:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601960239;
        bh=2FxnkdGWqIODt5G6smKMaE6VUKSNj3C61wyA2WtWSG0=;
        h=Date:From:To:Subject:From;
        b=mxzLCR7jR+vPvxxqmcFXGtOa1HC1DkJsvQ0sR4pKEf4BueuX/w+MDw1LzWL94qoQ9
         FHoqQTlnCM9KYDyKlbJsmtMl+eXEMol5mNWSpMtCFQNKb0mf9uFaJ3FT6VPtbbI3AM
         O3WGtUdQzvD28ilnxgMV0bjjV9j/kHCF8Fh6mV4o=
Date:   Mon, 05 Oct 2020 21:57:17 -0700
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
 mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page.patch added to
 -mm tree
Message-ID: <20201006045717.Gn_AdVM5P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: place pages to tail in __putback_isolated_page()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page.patch

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
Subject: mm/page_alloc: place pages to tail in __putback_isolated_page()

__putback_isolated_page() already documents that pages will be placed to
the tail of the freelist - this is, however, not the case for "order >=
MAX_ORDER - 2" (see buddy_merge_likely()) - which should be the case for
all existing users.

This change affects two users:
- free page reporting
- page isolation, when undoing the isolation (including memory onlining).

This behavior is desirable for pages that haven't really been touched
lately, so exactly the two users that don't actually read/write page
content, but rather move untouched pages.

The new behavior is especially desirable for memory onlining, where we
allow allocation of newly onlined pages via undo_isolate_page_range() in
online_pages().  Right now, we always place them to the head of the
freelist, resulting in undesireable behavior: Assume we add individual
memory chunks via add_memory() and online them right away to the NORMAL
zone.  We create a dependency chain of unmovable allocations e.g., via the
memmap.  The memmap of the next chunk will be placed onto previous chunks
- if the last block cannot get offlined+removed, all dependent ones cannot
get offlined+removed.  While this can already be observed with individual
DIMMs, it's more of an issue for virtio-mem (and I suspect also ppc
DLPAR).

Document that this should only be used for optimizations, and no code
should rely on this behavior for correction (if the order of the freelists
ever changes).

We won't care about page shuffling: memory onlining already properly
shuffles after onlining.  free page reporting doesn't care about
physically contiguous ranges, and there are already cases where page
isolation will simply move (physically close) free pages to (currently)
the head of the freelists via move_freepages_block() instead of shuffling.
If this becomes ever relevant, we should shuffle the whole zone when
undoing isolation of larger ranges, and after free_contig_range().

Link: https://lkml.kernel.org/r/20201005121534.15649-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Scott Cheloha <cheloha@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-place-pages-to-tail-in-__putback_isolated_page
+++ a/mm/page_alloc.c
@@ -94,6 +94,18 @@ typedef int __bitwise fpi_t;
  */
 #define FPI_SKIP_REPORT_NOTIFY	((__force fpi_t)BIT(0))
 
+/*
+ * Place the (possibly merged) page to the tail of the freelist. Will ignore
+ * page shuffling (relevant code - e.g., memory onlining - is expected to
+ * shuffle the whole zone).
+ *
+ * Note: No code should rely on this flag for correctness - it's purely
+ *       to allow for optimizations when handing back either fresh pages
+ *       (memory onlining) or untouched pages (page isolation, free page
+ *       reporting).
+ */
+#define FPI_TO_TAIL		((__force fpi_t)BIT(1))
+
 /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields */
 static DEFINE_MUTEX(pcp_batch_high_lock);
 #define MIN_PERCPU_PAGELIST_FRACTION	(8)
@@ -1044,7 +1056,9 @@ continue_merging:
 done_merging:
 	set_page_order(page, order);
 
-	if (is_shuffle_order(order))
+	if (fpi_flags & FPI_TO_TAIL)
+		to_tail = true;
+	else if (is_shuffle_order(order))
 		to_tail = shuffle_pick_tail();
 	else
 		to_tail = buddy_merge_likely(pfn, buddy_pfn, page, order);
@@ -3306,7 +3320,7 @@ void __putback_isolated_page(struct page
 
 	/* Return isolated page to tail of freelist. */
 	__free_one_page(page, page_to_pfn(page), zone, order, mt,
-			FPI_SKIP_REPORT_NOTIFY);
+			FPI_SKIP_REPORT_NOTIFY | FPI_TO_TAIL);
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

