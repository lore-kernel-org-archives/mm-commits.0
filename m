Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7C9C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE75464F03
	for <mm-commits@archiver.kernel.org>; Fri, 26 Feb 2021 01:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhBZBRe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 20:17:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhBZBRa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 20:17:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF4AF64F26;
        Fri, 26 Feb 2021 01:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614302198;
        bh=3TyicxzoG025fmHhxMfJ0JXDTN+gK5BHU36taG+gPIE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BlweDgawAWu7lxbUT+l6YPRsEwA/Uh+tucsEvLWz6k2BN0QQXjAhy7/ZTQ2Mc6UYM
         znQi8oMjV+2u0BA/btk+gDmRSfVmtjEoV+9rhLhM+svttRrlF2cfS3xp323D/9W8aF
         mu/M5T2myW3deON1aQPoa2qS6T/LrYOyCKPb+IDI=
Date:   Thu, 25 Feb 2021 17:16:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        peterz@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@kernel.org, tglx@linutronix.de, torvalds@linux-foundation.org,
        ziy@nvidia.com
Subject:  [patch 020/118] mm/cma: expose all pages to the buddy if
 activation of an area fails
Message-ID: <20210226011637.ifeOcWW-E%akpm@linux-foundation.org>
In-Reply-To: <20210225171452.713967e96554bb6a53e44a19@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
