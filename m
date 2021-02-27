Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D1BC433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C82E664F46
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhB0Caj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:30:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230102AbhB0CaJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB18F64F30;
        Sat, 27 Feb 2021 02:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392942;
        bh=CDsl49q4PlqQXKy5shw6P3S9cqqqZA4NTCYsvSNQe+U=;
        h=Date:From:To:Subject:From;
        b=Tru0zpEoi1h8wBQjMuLJvkSWNOiY/IAgQ4GzvY7kJMUXTHtMzQkw5kD/fLsLyxr3R
         xrm0x6/Z+vnkfOAEkkKoghAEEjDA6hIqzmySUCaPOEAbL2/3KJ6HBb5AV2+I5kR2rp
         lIhomBzbXC3UORuxrza23yoCjBWrg2XMDXR4c0dg=
Date:   Fri, 26 Feb 2021 18:29:01 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, peterz@infradead.org,
        richard.weiyang@linux.alibaba.com, rientjes@google.com,
        rppt@kernel.org, tglx@linutronix.de, ziy@nvidia.com
Subject:  [merged]
 =?US-ASCII?Q?mm-page=5Falloc-count-cma-pages-per-zone-and-print-them-in?=
 =?US-ASCII?Q?-proc-zoneinfo.patch?= removed from -mm tree
Message-ID: <20210227022901.gLkpGBqMB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: count CMA pages per zone and print them in /proc/zoneinfo
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: count CMA pages per zone and print them in /proc/zoneinfo

Let's count the number of CMA pages per zone and print them in
/proc/zoneinfo.

Having access to the total number of CMA pages per zone is helpful for
debugging purposes to know where exactly the CMA pages ended up, and to
figure out how many pages of a zone might behave differently, even after
some of these pages might already have been allocated.

As one example, CMA pages part of a kernel zone cannot be used for
ordinary kernel allocations but instead behave more like ZONE_MOVABLE.

For now, we are only able to get the global nr+free cma pages from
/proc/meminfo and the free cma pages per zone from /proc/zoneinfo.

Example after this patch when booting a 6 GiB QEMU VM with
"hugetlb_cma=2G":
  # cat /proc/zoneinfo | grep cma
          cma      0
        nr_free_cma  0
          cma      0
        nr_free_cma  0
          cma      524288
        nr_free_cma  493016
          cma      0
          cma      0
  # cat /proc/meminfo | grep Cma
  CmaTotal:        2097152 kB
  CmaFree:         1972064 kB

Note: We print even without CONFIG_CMA, just like "nr_free_cma"; this way,
      one can be sure when spotting "cma 0", that there are definetly no
      CMA pages located in a zone.

[david@redhat.com: v2]
  Link: https://lkml.kernel.org/r/20210128164533.18566-1-david@redhat.com
[david@redhat.com: v3]
  Link: https://lkml.kernel.org/r/20210129113451.22085-1-david@redhat.com
Link: https://lkml.kernel.org/r/20210127101813.6370-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   15 +++++++++++++++
 mm/page_alloc.c        |    1 +
 mm/vmstat.c            |    6 ++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo
+++ a/include/linux/mmzone.h
@@ -503,6 +503,9 @@ struct zone {
 	 * bootmem allocator):
 	 *	managed_pages = present_pages - reserved_pages;
 	 *
+	 * cma pages is present pages that are assigned for CMA use
+	 * (MIGRATE_CMA).
+	 *
 	 * So present_pages may be used by memory hotplug or memory power
 	 * management logic to figure out unmanaged pages by checking
 	 * (present_pages - managed_pages). And managed_pages should be used
@@ -527,6 +530,9 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+#ifdef CONFIG_CMA
+	unsigned long		cma_pages;
+#endif
 
 	const char		*name;
 
@@ -624,6 +630,15 @@ static inline unsigned long zone_managed
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
--- a/mm/page_alloc.c~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo
+++ a/mm/page_alloc.c
@@ -2168,6 +2168,7 @@ void __init init_cma_reserved_pageblock(
 	}
 
 	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
 #endif
 
--- a/mm/vmstat.c~mm-page_alloc-count-cma-pages-per-zone-and-print-them-in-proc-zoneinfo
+++ a/mm/vmstat.c
@@ -1637,14 +1637,16 @@ static void zoneinfo_show_print(struct s
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
+		   zone_managed_pages(zone),
+		   zone_cma_pages(zone));
 
 	seq_printf(m,
 		   "\n        protection: (%ld",
_

Patches currently in -mm which might be from david@redhat.com are


