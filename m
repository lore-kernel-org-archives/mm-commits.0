Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4813C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 983FE206F7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709352;
	bh=L4KKzbzXVTr32i5k1eZiiNfdLLJl1LBSSaxyTr4ljC0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QD04cscfI+9J5frZYPQ/Yc0LgvlZPxs8ScR4hk+gEU6qdI0zNmBdgGXoV1CIArr8Z
	 bUMVFfECpLdI6pXzeYOg5HafvsmIBMT9KnqcZFTAqz/f+pfqRL6ku8e8csqBxzO6QD
	 rXWEfL/fRkkOEYAK6hsV6ZV70Yu610928D/VpPGI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbgJNVCc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbgJNVCc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:32 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96B09206B2;
        Wed, 14 Oct 2020 21:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709351;
        bh=L4KKzbzXVTr32i5k1eZiiNfdLLJl1LBSSaxyTr4ljC0=;
        h=Date:From:To:Subject:From;
        b=WR/TwyeHCn7A8Dtsq4jZ1LlY0oXLVEkGgi47YBmJeMNvI9h/w1C7SfcednhWZCtIF
         Qg1xlrw8g/tGhRt6h75URJYk0IoclFXJp36RNQHKRniRpMKZRSxZlMqhwCDb7O3pHS
         qN274X2hHboN+Qj53alk9RUucCIgnkGekzJJMV+Y=
Date:   Wed, 14 Oct 2020 14:02:30 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, cai@lca.pw, david@redhat.com, jasowang@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        pankaj.gupta.linux@gmail.com, rppt@kernel.org
Subject:  [merged]
 mm-page_isolation-cleanup-set_migratetype_isolate.patch removed from -mm
 tree
Message-ID: <20201014210230.CRI6HgYok%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: cleanup set_migratetype_isolate()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-cleanup-set_migratetype_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: cleanup set_migratetype_isolate()

Let's clean it up a bit, simplifying the exit paths.

Link: http://lkml.kernel.org/r/20200816125333.7434-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-cleanup-set_migratetype_isolate
+++ a/mm/page_isolation.c
@@ -17,12 +17,9 @@
 
 static int set_migratetype_isolate(struct page *page, int migratetype, int isol_flags)
 {
-	struct page *unmovable = NULL;
-	struct zone *zone;
+	struct zone *zone = page_zone(page);
+	struct page *unmovable;
 	unsigned long flags;
-	int ret = -EBUSY;
-
-	zone = page_zone(page);
 
 	spin_lock_irqsave(&zone->lock, flags);
 
@@ -51,13 +48,13 @@ static int set_migratetype_isolate(struc
 									NULL);
 
 		__mod_zone_freepage_state(zone, -nr_pages, mt);
-		ret = 0;
+		spin_unlock_irqrestore(&zone->lock, flags);
+		drain_all_pages(zone);
+		return 0;
 	}
 
 	spin_unlock_irqrestore(&zone->lock, flags);
-	if (!ret) {
-		drain_all_pages(zone);
-	} else if ((isol_flags & REPORT_FAILURE) && unmovable) {
+	if (isol_flags & REPORT_FAILURE) {
 		/*
 		 * printk() with zone->lock held will likely trigger a
 		 * lockdep splat, so defer it here.
@@ -65,7 +62,7 @@ static int set_migratetype_isolate(struc
 		dump_page(unmovable, "unmovable page");
 	}
 
-	return ret;
+	return -EBUSY;
 }
 
 static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
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

