Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F76FC433E9
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB6864F2D
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 00:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhBZAla (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 19:41:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232591AbhBZAl3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 19:41:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC39F64F1B;
        Fri, 26 Feb 2021 00:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614300048;
        bh=DOaDsw/P2QtumnllAkJVHjPgjOK4PviHzi9Ycx0zvDo=;
        h=Date:From:To:Subject:From;
        b=wNzyGxgv5HHFuT97xeStb0cMxlz6LIaXSzEeQWKGJ+zr1QytY1LQGM17rl6YW2Gh7
         MUhMApjfWSAAXKW+EbSyxFYH/fqCOpUSCaPzLfe3rZ/dXblPgi7fz+573eeyCFG7Rs
         OsBJcSMQV1LPgyE9pmzHbwVo5ELjNoVA8JuLg4zQ=
Date:   Thu, 25 Feb 2021 16:40:47 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, peterz@infradead.org,
        richard.weiyang@linux.alibaba.com, rientjes@google.com,
        rppt@kernel.org, tglx@linutronix.de, ziy@nvidia.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Falloc-count-cma-pages-per-zone-and-print-them-i?=
 =?US-ASCII?Q?n-proc-zoneinfo-v3.patch?= removed from -mm tree
Message-ID: <20210226004047.EqyNDiZDN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v3
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v3.patch

This patch was dropped because it was folded into mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v3

- Print even without CONFIG_CMA. Use zone_cma_pages().
- Adjust patch description
- Dropped Oscar's RB due to the changes

Link: https://lkml.kernel.org/r/20210129113451.22085-1-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 +++++++++
 mm/vmstat.c            |   11 ++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v3
+++ a/include/linux/mmzone.h
@@ -630,6 +630,15 @@ static inline unsigned long zone_managed
 	return (unsigned long)atomic_long_read(&zone->managed_pages);
 }
 
+static inline unsigned long zone_cma_pages(struct zone *zone)
+{
+#ifdef CONFIG_CMA
+	return zone->cma_pages;
+#else
+	return 0;
+#endif
+}
+
 static inline unsigned long zone_end_pfn(const struct zone *zone)
 {
 	return zone->zone_start_pfn + zone->spanned_pages;
--- a/mm/vmstat.c~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo-v3
+++ a/mm/vmstat.c
@@ -1637,19 +1637,16 @@ static void zoneinfo_show_print(struct s
 		   "\n        high     %lu"
 		   "\n        spanned  %lu"
 		   "\n        present  %lu"
-		   "\n        managed  %lu",
+		   "\n        managed  %lu"
+		   "\n        cma      %lu",
 		   zone_page_state(zone, NR_FREE_PAGES),
 		   min_wmark_pages(zone),
 		   low_wmark_pages(zone),
 		   high_wmark_pages(zone),
 		   zone->spanned_pages,
 		   zone->present_pages,
-		   zone_managed_pages(zone));
-#ifdef CONFIG_CMA
-	seq_printf(m,
-		   "\n        cma      %lu",
-		   zone->cma_pages);
-#endif
+		   zone_managed_pages(zone),
+		   zone_cma_pages(zone));
 
 	seq_printf(m,
 		   "\n        protection: (%ld",
_

Patches currently in -mm which might be from david@redhat.com are

mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails.patch
mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch
mm-memory_hotplug-memhp_merge_resource-mhp_merge_resource.patch
drivers-base-memory-dont-store-phys_device-in-memory-blocks.patch
documentation-sysfs-memory-clarify-some-memory-block-device-properties.patch
virtio-mem-check-against-mhp_get_pluggable_range-which-memory-we-can-hotplug.patch

