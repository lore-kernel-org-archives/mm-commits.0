Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7003FC433E0
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 380C464F3F
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhB0C3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:29:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhB0C3o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:29:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE6664F2F;
        Sat, 27 Feb 2021 02:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392939;
        bh=k2xas50+hY/ytxSWhSBSATFT7se6H1eD31X+MHQj8O0=;
        h=Date:From:To:Subject:From;
        b=qyxeXwzRdeYbn9nBT3xiPrK0RY6GM1I3hV/Vrp3F1Bs5dCuyk5w9FDZyrXqU5eG7o
         yjTPWZcXcWrFbV21as+4LkM3sbZzNYGHtFLQVooR6zTZy9Km2qC7dDOawELiCncPjE
         VHIG+KZ3FTaIK6IL0jQjGX/IPblOhjyOSoJeEik0=
Date:   Fri, 26 Feb 2021 18:28:58 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        osalvador@suse.de, peterz@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@kernel.org,
        tglx@linutronix.de, ziy@nvidia.com
Subject:  [merged]
 mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails.patch
 removed from -mm tree
Message-ID: <20210227022858.btvixAgr2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma: expose all pages to the buddy if activation of an area fails
has been removed from the -mm tree.  Its filename was
     mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/cma: expose all pages to the buddy if activation of an area fails

Right now, if activation fails, we might already have exposed some pages
to the buddy for CMA use (although they will never get actually used by
CMA), and some pages won't be exposed to the buddy at all.

Let's check for "single zone" early and on error, don't expose any pages
for CMA use - instead, expose them to the buddy available for any use. 
Simply call free_reserved_page() on every single page - easier than going
via free_reserved_area(), converting back and forth between pfns and virt
addresses.

In addition, make sure to fixup totalcma_pages properly.

Example: 6 GiB QEMU VM with "... hugetlb_cma=2G movablecore=20% ...":
  [    0.006891] hugetlb_cma: reserve 2048 MiB, up to 2048 MiB per node
  [    0.006893] cma: Reserved 2048 MiB at 0x0000000100000000
  [    0.006893] hugetlb_cma: reserved 2048 MiB on node 0
  ...
  [    0.175433] cma: CMA area hugetlb0 could not be activated

Before this patch:
  # cat /proc/meminfo
  MemTotal:        5867348 kB
  MemFree:         5692808 kB
  MemAvailable:    5542516 kB
  ...
  CmaTotal:        2097152 kB
  CmaFree:         1884160 kB

After this patch:
  # cat /proc/meminfo
  MemTotal:        6077308 kB
  MemFree:         5904208 kB
  MemAvailable:    5747968 kB
  ...
  CmaTotal:              0 kB
  CmaFree:               0 kB

Note: cma_init_reserved_mem() makes sure that we always cover full
pageblocks / MAX_ORDER - 1 pages.

Link: https://lkml.kernel.org/r/20210127101813.6370-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   43 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

--- a/mm/cma.c~mm-cma-expose-all-pages-to-the-buddy-if-activation-of-an-area-fails
+++ a/mm/cma.c
@@ -94,34 +94,29 @@ static void cma_clear_bitmap(struct cma
 
 static void __init cma_activate_area(struct cma *cma)
 {
-	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
-	unsigned i = cma->count >> pageblock_order;
+	unsigned long base_pfn = cma->base_pfn, pfn;
 	struct zone *zone;
 
 	cma->bitmap = bitmap_zalloc(cma_bitmap_maxno(cma), GFP_KERNEL);
 	if (!cma->bitmap)
 		goto out_error;
 
-	WARN_ON_ONCE(!pfn_valid(pfn));
-	zone = page_zone(pfn_to_page(pfn));
-
-	do {
-		unsigned j;
-
-		base_pfn = pfn;
-		for (j = pageblock_nr_pages; j; --j, pfn++) {
-			WARN_ON_ONCE(!pfn_valid(pfn));
-			/*
-			 * alloc_contig_range requires the pfn range
-			 * specified to be in the same zone. Make this
-			 * simple by forcing the entire CMA resv range
-			 * to be in the same zone.
-			 */
-			if (page_zone(pfn_to_page(pfn)) != zone)
-				goto not_in_zone;
-		}
-		init_cma_reserved_pageblock(pfn_to_page(base_pfn));
-	} while (--i);
+	/*
+	 * alloc_contig_range() requires the pfn range specified to be in the
+	 * same zone. Simplify by forcing the entire CMA resv range to be in the
+	 * same zone.
+	 */
+	WARN_ON_ONCE(!pfn_valid(base_pfn));
+	zone = page_zone(pfn_to_page(base_pfn));
+	for (pfn = base_pfn + 1; pfn < base_pfn + cma->count; pfn++) {
+		WARN_ON_ONCE(!pfn_valid(pfn));
+		if (page_zone(pfn_to_page(pfn)) != zone)
+			goto not_in_zone;
+	}
+
+	for (pfn = base_pfn; pfn < base_pfn + cma->count;
+	     pfn += pageblock_nr_pages)
+		init_cma_reserved_pageblock(pfn_to_page(pfn));
 
 	mutex_init(&cma->lock);
 
@@ -135,6 +130,10 @@ static void __init cma_activate_area(str
 not_in_zone:
 	bitmap_free(cma->bitmap);
 out_error:
+	/* Expose all pages to the buddy, they are useless for CMA. */
+	for (pfn = base_pfn; pfn < base_pfn + cma->count; pfn++)
+		free_reserved_page(pfn_to_page(pfn));
+	totalcma_pages -= cma->count;
 	cma->count = 0;
 	pr_err("CMA area %s could not be activated\n", cma->name);
 	return;
_

Patches currently in -mm which might be from david@redhat.com are


