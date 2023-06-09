Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC0CC7EE25
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbjFIX3C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjFIX2G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:28:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038023C07
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8D3065CF3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3900EC4339C;
        Fri,  9 Jun 2023 23:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353266;
        bh=56UbDW3QjObxM8BChXvbAHsssmBWHVzhsyd9GxfM59k=;
        h=Date:To:From:Subject:From;
        b=1qSJzDrNCGRcGA6nGVErGnKMEIgrqfMYFIM1WSNA78JE62JONY7mMdc/3p+XnRiE0
         zuoSsOgQmxZcefP8alEvdK4DrnydGwaXikRlbrzeAJlR+zSWUQExqfo+FgAYJRwM57
         PWeHCDZYcgsUtuQr32SuAWrIjRSx1vT0bzRLOkNE=
Date:   Fri, 09 Jun 2023 16:27:45 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-mark_free_page-into-snapshotc.patch removed from -mm tree
Message-Id: <20230609232746.3900EC4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: move mark_free_page() into snapshot.c
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-mark_free_page-into-snapshotc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: move mark_free_page() into snapshot.c
Date: Tue, 16 May 2023 14:38:17 +0800

The mark_free_page() is only used in kernel/power/snapshot.c, move it out
to reduce a bit of page_alloc.c

Link: https://lkml.kernel.org/r/20230516063821.121844-10-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/suspend.h |    3 --
 kernel/power/snapshot.c |   52 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         |   55 --------------------------------------
 3 files changed, 52 insertions(+), 58 deletions(-)

--- a/include/linux/suspend.h~mm-page_alloc-move-mark_free_page-into-snapshotc
+++ a/include/linux/suspend.h
@@ -364,9 +364,6 @@ struct pbe {
 	struct pbe *next;
 };
 
-/* mm/page_alloc.c */
-extern void mark_free_pages(struct zone *zone);
-
 /**
  * struct platform_hibernation_ops - hibernation platform support
  *
--- a/kernel/power/snapshot.c~mm-page_alloc-move-mark_free_page-into-snapshotc
+++ a/kernel/power/snapshot.c
@@ -1228,6 +1228,58 @@ unsigned int snapshot_additional_pages(s
 	return 2 * rtree;
 }
 
+/*
+ * Touch the watchdog for every WD_PAGE_COUNT pages.
+ */
+#define WD_PAGE_COUNT	(128*1024)
+
+static void mark_free_pages(struct zone *zone)
+{
+	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
+	unsigned long flags;
+	unsigned int order, t;
+	struct page *page;
+
+	if (zone_is_empty(zone))
+		return;
+
+	spin_lock_irqsave(&zone->lock, flags);
+
+	max_zone_pfn = zone_end_pfn(zone);
+	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
+		if (pfn_valid(pfn)) {
+			page = pfn_to_page(pfn);
+
+			if (!--page_count) {
+				touch_nmi_watchdog();
+				page_count = WD_PAGE_COUNT;
+			}
+
+			if (page_zone(page) != zone)
+				continue;
+
+			if (!swsusp_page_is_forbidden(page))
+				swsusp_unset_page_free(page);
+		}
+
+	for_each_migratetype_order(order, t) {
+		list_for_each_entry(page,
+				&zone->free_area[order].free_list[t], buddy_list) {
+			unsigned long i;
+
+			pfn = page_to_pfn(page);
+			for (i = 0; i < (1UL << order); i++) {
+				if (!--page_count) {
+					touch_nmi_watchdog();
+					page_count = WD_PAGE_COUNT;
+				}
+				swsusp_set_page_free(pfn_to_page(pfn + i));
+			}
+		}
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
 #ifdef CONFIG_HIGHMEM
 /**
  * count_free_highmem_pages - Compute the total number of free highmem pages.
--- a/mm/page_alloc.c~mm-page_alloc-move-mark_free_page-into-snapshotc
+++ a/mm/page_alloc.c
@@ -2365,61 +2365,6 @@ void drain_all_pages(struct zone *zone)
 	__drain_all_pages(zone, false);
 }
 
-#ifdef CONFIG_HIBERNATION
-
-/*
- * Touch the watchdog for every WD_PAGE_COUNT pages.
- */
-#define WD_PAGE_COUNT	(128*1024)
-
-void mark_free_pages(struct zone *zone)
-{
-	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
-	unsigned long flags;
-	unsigned int order, t;
-	struct page *page;
-
-	if (zone_is_empty(zone))
-		return;
-
-	spin_lock_irqsave(&zone->lock, flags);
-
-	max_zone_pfn = zone_end_pfn(zone);
-	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
-		if (pfn_valid(pfn)) {
-			page = pfn_to_page(pfn);
-
-			if (!--page_count) {
-				touch_nmi_watchdog();
-				page_count = WD_PAGE_COUNT;
-			}
-
-			if (page_zone(page) != zone)
-				continue;
-
-			if (!swsusp_page_is_forbidden(page))
-				swsusp_unset_page_free(page);
-		}
-
-	for_each_migratetype_order(order, t) {
-		list_for_each_entry(page,
-				&zone->free_area[order].free_list[t], buddy_list) {
-			unsigned long i;
-
-			pfn = page_to_pfn(page);
-			for (i = 0; i < (1UL << order); i++) {
-				if (!--page_count) {
-					touch_nmi_watchdog();
-					page_count = WD_PAGE_COUNT;
-				}
-				swsusp_set_page_free(pfn_to_page(pfn + i));
-			}
-		}
-	}
-	spin_unlock_irqrestore(&zone->lock, flags);
-}
-#endif /* CONFIG_PM */
-
 static bool free_unref_page_prepare(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


