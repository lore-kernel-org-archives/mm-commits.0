Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34FBC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99710206E5
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709346;
	bh=WeoaFU2YYjd8TCvLRiTZG0b/IlMVTBB+oAVkngwQ0i0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rywcicKkI5GZsGrWsmDvJwJhCSn47qQet1Ka1dmofurfJPYS0w5bJUm1yEpmIJJZN
	 Wsf5eIPOie+mpnZIJXf+8GMhHFU3KZ5Q8wCbLVVlkxjBu0VHeIAgdiUQa+b3sflY4L
	 88jLhywBj6ezgMvqVy1jsVpVHg+SxRe9KtdFVoa0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388099AbgJNVC0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbgJNVC0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:26 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EC1F206D4;
        Wed, 14 Oct 2020 21:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709345;
        bh=WeoaFU2YYjd8TCvLRiTZG0b/IlMVTBB+oAVkngwQ0i0=;
        h=Date:From:To:Subject:From;
        b=NmHy5zpc4D4Z8DEX4bekM4N2yWEppBw4h2sEv2bg4juxX8HR/wt/6DEBLyflTWfBn
         mz0/9ED686JrNtLQhhrdoUMSIR7aHt/rbPj4dMVry4htGY/RIvlk5IcGw4kVX+FlR6
         OESDFIno8L2orkdd0tnZJCfmN6vhiagS5m/5Gj0k=
Date:   Wed, 14 Oct 2020 14:02:24 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Fisolation-exit-early-when-pageblock-is-isolated-?=
 =?US-ASCII?Q?in-set=5Fmigratetype=5Fisolate.patch?= removed from -mm tree
Message-ID: <20201014210224.9JEcBZQa8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: exit early when pageblock is isolated in set_migratetype_isolate()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: exit early when pageblock is isolated in set_migratetype_isolate()

Right now, if we have two isolations racing on a pageblock that's in the
MOVABLE zone, we would trigger the WARN_ON_ONCE().  Let's just return
directly, simplifying error handling.

The change was introduced in commit 3d680bdf60a5 ("mm/page_isolation: fix
potential warning from user").  As far as I can see, we currently don't
have alloc_contig_range() users that use the ZONE_MOVABLE (anymore), so
it's currently more a cleanup and a preparation for the future than a fix.

Link: http://lkml.kernel.org/r/20200816125333.7434-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-exit-early-when-pageblock-is-isolated-in-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -29,10 +29,12 @@ static int set_migratetype_isolate(struc
 	/*
 	 * We assume the caller intended to SET migrate type to isolate.
 	 * If it is already set, then someone else must have raced and
-	 * set it before us.  Return -EBUSY
+	 * set it before us.
 	 */
-	if (is_migrate_isolate_page(page))
-		goto out;
+	if (is_migrate_isolate_page(page)) {
+		spin_unlock_irqrestore(&zone->lock, flags);
+		return -EBUSY;
+	}
 
 	/*
 	 * FIXME: Now, memory hotplug doesn't call shrink_slab() by itself.
@@ -52,7 +54,6 @@ static int set_migratetype_isolate(struc
 		ret = 0;
 	}
 
-out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret) {
 		drain_all_pages(zone);
_

Patches currently in -mm which might be from david@redhat.com are

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

