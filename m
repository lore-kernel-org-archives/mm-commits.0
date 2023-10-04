Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C80E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244670AbjJDUXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245030AbjJDUWc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E2FE9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE94C433CC;
        Wed,  4 Oct 2023 20:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450947;
        bh=/nLEhLxxgl3mP4cEjFeT2DvjmFWcv4wgcG6gKAEaU8o=;
        h=Date:To:From:Subject:From;
        b=ouo06Qo+zVGSNl6psi9ls73CfwLPLT46OEqO//NeDUtRFwe1ifBuSV2FfhOkbmGDJ
         +v5xlqEx3dYG0k0HQS8M/4HC3rcABfBhMLYzGSe5Xxs9/gCLwk74ZCc3HwQAYjpcOP
         2ZEP6rLrcgSJawnX1dnvF7keSd6jVYvyRamX0JLk=
Date:   Wed, 04 Oct 2023 13:22:25 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        rppt@kernel.org, punit.agrawal@bytedance.com,
        mike.kravetz@oracle.com, fam.zheng@bytedance.com,
        usama.arif@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memblock-introduce-memblock_rsrv_noinit-flag.patch removed from -mm tree
Message-Id: <20231004202227.0FE94C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memblock: introduce MEMBLOCK_RSRV_NOINIT flag
has been removed from the -mm tree.  Its filename was
     memblock-introduce-memblock_rsrv_noinit-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@bytedance.com>
Subject: memblock: introduce MEMBLOCK_RSRV_NOINIT flag
Date: Wed, 13 Sep 2023 11:54:00 +0100

For reserved memory regions marked with this flag, reserve_bootmem_region
is not called during memmap_init_reserved_pages.  This can be used to
avoid struct page initialization for regions which won't need them, for
e.g.  hugepages with Hugepage Vmemmap Optimization enabled.

Link: https://lkml.kernel.org/r/20230913105401.519709-4-usama.arif@bytedance.com
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    9 +++++++++
 mm/memblock.c            |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

--- a/include/linux/memblock.h~memblock-introduce-memblock_rsrv_noinit-flag
+++ a/include/linux/memblock.h
@@ -40,6 +40,8 @@ extern unsigned long long max_possible_p
  * via a driver, and never indicated in the firmware-provided memory map as
  * system RAM. This corresponds to IORESOURCE_SYSRAM_DRIVER_MANAGED in the
  * kernel resource tree.
+ * @MEMBLOCK_RSRV_NOINIT: memory region for which struct pages are
+ * not initialized (only for reserved regions).
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -47,6 +49,7 @@ enum memblock_flags {
 	MEMBLOCK_MIRROR		= 0x2,	/* mirrored region */
 	MEMBLOCK_NOMAP		= 0x4,	/* don't add to kernel direct mapping */
 	MEMBLOCK_DRIVER_MANAGED = 0x8,	/* always detected via a driver */
+	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 };
 
 /**
@@ -125,6 +128,7 @@ int memblock_clear_hotplug(phys_addr_t b
 int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
 int memblock_mark_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
+int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 
 void memblock_free_all(void);
 void memblock_free(void *ptr, size_t size);
@@ -259,6 +263,11 @@ static inline bool memblock_is_nomap(str
 	return m->flags & MEMBLOCK_NOMAP;
 }
 
+static inline bool memblock_is_reserved_noinit(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_RSRV_NOINIT;
+}
+
 static inline bool memblock_is_driver_managed(struct memblock_region *m)
 {
 	return m->flags & MEMBLOCK_DRIVER_MANAGED;
--- a/mm/memblock.c~memblock-introduce-memblock_rsrv_noinit-flag
+++ a/mm/memblock.c
@@ -997,6 +997,24 @@ int __init_memblock memblock_clear_nomap
 	return memblock_setclr_flag(&memblock.memory, base, size, 0, MEMBLOCK_NOMAP);
 }
 
+/**
+ * memblock_reserved_mark_noinit - Mark a reserved memory region with flag
+ * MEMBLOCK_RSRV_NOINIT which results in the struct pages not being initialized
+ * for this region.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * struct pages will not be initialized for reserved memory regions marked with
+ * %MEMBLOCK_RSRV_NOINIT.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.reserved, base, size, 1,
+				    MEMBLOCK_RSRV_NOINIT);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2113,13 +2131,18 @@ static void __init memmap_init_reserved_
 		memblock_set_node(start, end, &memblock.reserved, nid);
 	}
 
-	/* initialize struct pages for the reserved regions */
+	/*
+	 * initialize struct pages for reserved regions that don't have
+	 * the MEMBLOCK_RSRV_NOINIT flag set
+	 */
 	for_each_reserved_mem_region(region) {
-		nid = memblock_get_region_node(region);
-		start = region->base;
-		end = start + region->size;
+		if (!memblock_is_reserved_noinit(region)) {
+			nid = memblock_get_region_node(region);
+			start = region->base;
+			end = start + region->size;
 
-		reserve_bootmem_region(start, end, nid);
+			reserve_bootmem_region(start, end, nid);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from usama.arif@bytedance.com are


