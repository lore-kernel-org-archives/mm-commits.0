Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81602C7EE45
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbjFIX2i (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjFIX1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748933AB5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:27:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0BAB6169F
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:27:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58186C433D2;
        Fri,  9 Jun 2023 23:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353258;
        bh=aFfE66c3DO/351JwHbNjUWcxDq15+UFWio+C3HjbGOM=;
        h=Date:To:From:Subject:From;
        b=jhIg4SiOQwXZQfzHRrxWpdjnAVyXbx+maQkdrGZdIapAqtyW8tylmmdyEAlyeELkx
         HgMudYksLj7OPI8wD28Iea/DHIKtU8UvDg/jGuYELV01yk3I7AAxEKWx9hfk9WhYV5
         yLle/h/imO9gwgpN5LNEM2qMLQaQUjMk1FqP0G0w=
Date:   Fri, 09 Jun 2023 16:27:37 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        ying.huang@intel.com, rppt@kernel.org, rafael@kernel.org,
        pavel@ucw.cz, osalvador@suse.de, mcgrof@kernel.org,
        len.brown@intel.com, keescook@chromium.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch removed from -mm tree
Message-Id: <20230609232738.58186C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_alloc: move set_zone_contiguous() into mm_init.c
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-set_zone_contiguous-into-mm_initc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: page_alloc: move set_zone_contiguous() into mm_init.c
Date: Tue, 16 May 2023 14:38:11 +0800

set_zone_contiguous() is only used in mm init/hotplug, and
clear_zone_contiguous() only used in hotplug, move them from page_alloc.c
to the more appropriate file.

Link: https://lkml.kernel.org/r/20230516063821.121844-4-wangkefeng.wang@huawei.com
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

 include/linux/memory_hotplug.h |    3 ---
 mm/internal.h                  |    7 +++++++
 mm/mm_init.c                   |   22 ++++++++++++++++++++++
 mm/page_alloc.c                |   27 ---------------------------
 4 files changed, 29 insertions(+), 30 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/include/linux/memory_hotplug.h
@@ -326,9 +326,6 @@ static inline int remove_memory(u64 star
 static inline void __remove_memory(u64 start, u64 size) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
-extern void set_zone_contiguous(struct zone *zone);
-extern void clear_zone_contiguous(struct zone *zone);
-
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern void __ref free_area_init_core_hotplug(struct pglist_data *pgdat);
 extern int __add_memory(int nid, u64 start, u64 size, mhp_t mhp_flags);
--- a/mm/internal.h~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/mm/internal.h
@@ -371,6 +371,13 @@ static inline struct page *pageblock_pfn
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
 }
 
+void set_zone_contiguous(struct zone *zone);
+
+static inline void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
--- a/mm/mm_init.c~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/mm/mm_init.c
@@ -2330,6 +2330,28 @@ void __init init_cma_reserved_pageblock(
 }
 #endif
 
+void set_zone_contiguous(struct zone *zone)
+{
+	unsigned long block_start_pfn = zone->zone_start_pfn;
+	unsigned long block_end_pfn;
+
+	block_end_pfn = pageblock_end_pfn(block_start_pfn);
+	for (; block_start_pfn < zone_end_pfn(zone);
+			block_start_pfn = block_end_pfn,
+			 block_end_pfn += pageblock_nr_pages) {
+
+		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
+
+		if (!__pageblock_pfn_to_page(block_start_pfn,
+					     block_end_pfn, zone))
+			return;
+		cond_resched();
+	}
+
+	/* We confirm that there is no hole */
+	zone->contiguous = true;
+}
+
 void __init page_alloc_init_late(void)
 {
 	struct zone *zone;
--- a/mm/page_alloc.c~mm-page_alloc-move-set_zone_contiguous-into-mm_initc
+++ a/mm/page_alloc.c
@@ -1532,33 +1532,6 @@ struct page *__pageblock_pfn_to_page(uns
 	return start_page;
 }
 
-void set_zone_contiguous(struct zone *zone)
-{
-	unsigned long block_start_pfn = zone->zone_start_pfn;
-	unsigned long block_end_pfn;
-
-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
-	for (; block_start_pfn < zone_end_pfn(zone);
-			block_start_pfn = block_end_pfn,
-			 block_end_pfn += pageblock_nr_pages) {
-
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
-
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					     block_end_pfn, zone))
-			return;
-		cond_resched();
-	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
-}
-
-void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 /*
  * The order of subdivision here is critical for the IO subsystem.
  * Please do not alter this order without good reasons and regression
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


