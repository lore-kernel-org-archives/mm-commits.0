Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1C7C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4805206D9
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709349;
	bh=13shAcqwnUSqlzIW71jg2ylwmxqb1V9K58teFpXthsU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=r7e0XJLSjng9vgH8e9I3eB4vfzU7qH3NWg3OHLZH17qxGiValtutZhwuohyk+Wziq
	 m1uxQNxXsplixlZwRXc8AyZV0Hm/ae/nA8R6XjlbUyzv/19PGpIYr6omo2M6Kbp//w
	 YAVpddM4MICOsmfY0DYp/WSRE7YJ6RDywKeqgAoE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgJNVC3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbgJNVC3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC641206CB;
        Wed, 14 Oct 2020 21:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709348;
        bh=13shAcqwnUSqlzIW71jg2ylwmxqb1V9K58teFpXthsU=;
        h=Date:From:To:Subject:From;
        b=X3g1lrYhalEc11gvmG6vpsGMlIlh2JVNTHtwDE8H9wcJC9hmqRoKkvSw+NQVLeB+w
         YEEbZgucn618U+tVfsWb1H3j6naiP4riLL2/2z4MN/lVN3F7Rbwm7zYjR5x+khG58o
         j4MMqBGaTR4XTMpggGYEw9LJQ9L7SYcFDrb/IaD4=
Date:   Wed, 14 Oct 2020 14:02:27 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org
Subject:  [merged]
 mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch
 removed from -mm tree
Message-ID: <20201014210227.KAQaU7lF5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: drop WARN_ON_ONCE() in set_migratetype_isolate()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: drop WARN_ON_ONCE() in set_migratetype_isolate()

Inside has_unmovable_pages(), we have a comment describing how unmovable
data could end up in ZONE_MOVABLE - via "movablecore".  Also, besides
checking if the first page in the pageblock is reserved, we don't perform
any further checks in case of ZONE_MOVABLE.

In case of memory offlining, we set REPORT_FAILURE, properly dump_page()
the page and handle the error gracefully.  alloc_contig_pages() users
currently never allocate from ZONE_MOVABLE.  E.g., hugetlb uses
alloc_contig_pages() for the allocation of gigantic pages only, which will
never end up on the MOVABLE zone (see htlb_alloc_mask()).

Link: http://lkml.kernel.org/r/20200816125333.7434-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-drop-warn_on_once-in-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -57,15 +57,12 @@ static int set_migratetype_isolate(struc
 	spin_unlock_irqrestore(&zone->lock, flags);
 	if (!ret) {
 		drain_all_pages(zone);
-	} else {
-		WARN_ON_ONCE(zone_idx(zone) == ZONE_MOVABLE);
-
-		if ((isol_flags & REPORT_FAILURE) && unmovable)
-			/*
-			 * printk() with zone->lock held will likely trigger a
-			 * lockdep splat, so defer it here.
-			 */
-			dump_page(unmovable, "unmovable page");
+	} else if ((isol_flags & REPORT_FAILURE) && unmovable) {
+		/*
+		 * printk() with zone->lock held will likely trigger a
+		 * lockdep splat, so defer it here.
+		 */
+		dump_page(unmovable, "unmovable page");
 	}
 
 	return ret;
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

