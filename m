Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F738C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09EF26112F
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhICVAf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349960AbhICVAe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D3161107;
        Fri,  3 Sep 2021 20:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702773;
        bh=9c0A6n1ohqJrIGrrxllJPsdpBlViq1OzzJwoRu4WqEk=;
        h=Date:From:To:Subject:From;
        b=2YoZN9svw6X+c1Ka3F0QjJTaSEMJxm82LgsT+5Ht+do9hw0gDdHfHvd+NKtzWQmtu
         fZ2cP/JMQ7/ZnjfXQRPYbOrqUMnybJpjh6VUxQjA0gFxagaaWskc8gz/PJSoJ1K7gz
         Vr/mpOwG7kfDP61JQBqez58q0Ryou3uI70E/LICM=
Date:   Fri, 03 Sep 2021 13:59:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, monstr@monstr.eu, rppt@linux.ibm.com
Subject:  [merged]
 mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch removed from
 -mm tree
Message-ID: <20210903205933.q0EqGagby%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce memmap_alloc() to unify memory map allocation
has been removed from the -mm tree.  Its filename was
     mm-introduce-memmap_alloc-to-unify-memory-map-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: introduce memmap_alloc() to unify memory map allocation

There are several places that allocate memory for the memory map:
alloc_node_mem_map() for FLATMEM, sparse_buffer_init() and
__populate_section_memmap() for SPARSEMEM.

The memory allocated in the FLATMEM case is zeroed and it is never
poisoned, regardless of CONFIG_PAGE_POISON setting.

The memory allocated in the SPARSEMEM cases is not zeroed and it is
implicitly poisoned inside memblock if CONFIG_PAGE_POISON is set.

Introduce memmap_alloc() wrapper for memblock allocators that will be used
for both FLATMEM and SPARSEMEM cases and will makei memory map zeroing and
poisoning consistent for different memory models.

Link: https://lkml.kernel.org/r/20210714123739.16493-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++++
 mm/page_alloc.c |   24 ++++++++++++++++++++++--
 mm/sparse.c     |    6 ++----
 3 files changed, 28 insertions(+), 6 deletions(-)

--- a/mm/internal.h~mm-introduce-memmap_alloc-to-unify-memory-map-allocation
+++ a/mm/internal.h
@@ -211,6 +211,10 @@ extern void zone_pcp_reset(struct zone *
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
 
+extern void *memmap_alloc(phys_addr_t size, phys_addr_t align,
+			  phys_addr_t min_addr,
+			  int nid, bool exact_nid);
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
--- a/mm/page_alloc.c~mm-introduce-memmap_alloc-to-unify-memory-map-allocation
+++ a/mm/page_alloc.c
@@ -6748,6 +6748,26 @@ static void __init memmap_init(void)
 		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
 }
 
+void __init *memmap_alloc(phys_addr_t size, phys_addr_t align,
+			  phys_addr_t min_addr, int nid, bool exact_nid)
+{
+	void *ptr;
+
+	if (exact_nid)
+		ptr = memblock_alloc_exact_nid_raw(size, align, min_addr,
+						   MEMBLOCK_ALLOC_ACCESSIBLE,
+						   nid);
+	else
+		ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
+						 MEMBLOCK_ALLOC_ACCESSIBLE,
+						 nid);
+
+	if (ptr && size > 0)
+		page_init_poison(ptr, size);
+
+	return ptr;
+}
+
 static int zone_batchsize(struct zone *zone)
 {
 #ifdef CONFIG_MMU
@@ -7519,8 +7539,8 @@ static void __ref alloc_node_mem_map(str
 		end = pgdat_end_pfn(pgdat);
 		end = ALIGN(end, MAX_ORDER_NR_PAGES);
 		size =  (end - start) * sizeof(struct page);
-		map = memblock_alloc_node(size, SMP_CACHE_BYTES,
-					  pgdat->node_id);
+		map = memmap_alloc(size, SMP_CACHE_BYTES, MEMBLOCK_LOW_LIMIT,
+				   pgdat->node_id, false);
 		if (!map)
 			panic("Failed to allocate %ld bytes for node %d memory map\n",
 			      size, pgdat->node_id);
--- a/mm/sparse.c~mm-introduce-memmap_alloc-to-unify-memory-map-allocation
+++ a/mm/sparse.c
@@ -436,8 +436,7 @@ struct page __init *__populate_section_m
 	if (map)
 		return map;
 
-	map = memblock_alloc_try_nid_raw(size, size, addr,
-					  MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+	map = memmap_alloc(size, size, addr, nid, false);
 	if (!map)
 		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
 		      __func__, size, PAGE_SIZE, nid, &addr);
@@ -464,8 +463,7 @@ static void __init sparse_buffer_init(un
 	 * and we want it to be properly aligned to the section size - this is
 	 * especially the case for VMEMMAP which maps memmap to PMDs
 	 */
-	sparsemap_buf = memblock_alloc_exact_nid_raw(size, section_map_size(),
-					addr, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+	sparsemap_buf = memmap_alloc(size, section_map_size(), addr, nid, true);
 	sparsemap_buf_end = sparsemap_buf + size;
 }
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

