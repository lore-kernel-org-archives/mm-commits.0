Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C03C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2456364EC4
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhBXUHt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:07:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235285AbhBXUHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0330A64F14;
        Wed, 24 Feb 2021 20:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197182;
        bh=1EFjS2w3Hgd8OC0s/XzvhRFBsK9utEtfBSJV2hJHbcw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mja8ATPF0iXrqFKUOVBcMCd2BIbVwxS86zBQtDgi4u3hw7+xvML9tlGGGUtcE2i4Z
         BOmosPTZxygtIH26RFvXO2rCX8X4q5GkwrBNh8rh53B841CFDaDoUOnhTBvQyKbLPm
         axScWdF6YlV13sgzXTseeEQ1EXcAWUciBwbRgtD8=
Date:   Wed, 24 Feb 2021 12:06:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bhe@redhat.com, david@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 105/173] mm: simplify parameter of setup_usemap()
Message-ID: <20210224200620.gvrD3A1BS%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baoquan He <bhe@redhat.com>
Subject: mm: simplify parameter of setup_usemap()

Parameter 'zone' has got needed information, let's remove other
unnecessary parameters.

Link: https://lkml.kernel.org/r/20210122135956.5946-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/page_alloc.c~mm-simplify-parameter-of-setup_usemap
+++ a/mm/page_alloc.c
@@ -6765,25 +6765,22 @@ static unsigned long __init usemap_size(
 	return usemapsize / 8;
 }
 
-static void __ref setup_usemap(struct pglist_data *pgdat,
-				struct zone *zone,
-				unsigned long zone_start_pfn,
-				unsigned long zonesize)
+static void __ref setup_usemap(struct zone *zone)
 {
-	unsigned long usemapsize = usemap_size(zone_start_pfn, zonesize);
+	unsigned long usemapsize = usemap_size(zone->zone_start_pfn,
+					       zone->spanned_pages);
 	zone->pageblock_flags = NULL;
 	if (usemapsize) {
 		zone->pageblock_flags =
 			memblock_alloc_node(usemapsize, SMP_CACHE_BYTES,
-					    pgdat->node_id);
+					    zone_to_nid(zone));
 		if (!zone->pageblock_flags)
 			panic("Failed to allocate %ld bytes for zone %s pageblock flags on node %d\n",
-			      usemapsize, zone->name, pgdat->node_id);
+			      usemapsize, zone->name, zone_to_nid(zone));
 	}
 }
 #else
-static inline void setup_usemap(struct pglist_data *pgdat, struct zone *zone,
-				unsigned long zone_start_pfn, unsigned long zonesize) {}
+static inline void setup_usemap(struct zone *zone) {}
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
@@ -6978,7 +6975,7 @@ static void __init free_area_init_core(s
 			continue;
 
 		set_pageblock_order();
-		setup_usemap(pgdat, zone, zone_start_pfn, size);
+		setup_usemap(zone);
 		init_currently_empty_zone(zone, zone_start_pfn, size);
 		memmap_init_zone(zone);
 	}
_
