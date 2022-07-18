Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1DBCCA480
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiGRAQd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiGRAQ3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:16:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3129795A4
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF280B80DAF
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C4AC3411E;
        Mon, 18 Jul 2022 00:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103385;
        bh=icdVBtrcfwOJOtGFAILJIdLF4BrfAB94AJIiAqY2qJE=;
        h=Date:To:From:Subject:From;
        b=SY2Jxs9XsMw801n42XXi5dOH3BQXkoHHR/u2uh0zWbnryq9fBJYNEwdoLvUAXtdYx
         ltGD33TDLCyfF48r/crIJ7isz36w7tonKsss/X8FaNnDO+cVGYXVjni4vGVCBplz+y
         s3o0t7X8sOt2nq+XqCkAJL7fpy8NRZRDFG/fvMfo=
Date:   Sun, 17 Jul 2022 17:16:24 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-page-zone-helpers-from-mmh-to-mmzoneh.patch removed from -mm tree
Message-Id: <20220718001625.60C4AC3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move page zone helpers from mm.h to mmzone.h
has been removed from the -mm tree.  Its filename was
     mm-move-page-zone-helpers-from-mmh-to-mmzoneh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: mm: move page zone helpers from mm.h to mmzone.h
Date: Fri, 15 Jul 2022 10:05:09 -0500

It makes more sense to have these helpers in zone specific header
file, rather than the generic mm.h

Link: https://lkml.kernel.org/r/20220715150521.18165-3-alex.sierra@amd.com
Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 
 include/linux/mm.h       |   78 ------------------------------------
 include/linux/mmzone.h   |   80 +++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 79 deletions(-)

--- a/include/linux/memremap.h~mm-move-page-zone-helpers-from-mmh-to-mmzoneh
+++ a/include/linux/memremap.h
@@ -2,7 +2,7 @@
 #ifndef _LINUX_MEMREMAP_H_
 #define _LINUX_MEMREMAP_H_
 
-#include <linux/mm.h>
+#include <linux/mmzone.h>
 #include <linux/range.h>
 #include <linux/ioport.h>
 #include <linux/percpu-refcount.h>
--- a/include/linux/mm.h~mm-move-page-zone-helpers-from-mmh-to-mmzoneh
+++ a/include/linux/mm.h
@@ -1045,84 +1045,6 @@ vm_fault_t finish_mkwrite_fault(struct v
  *   back into memory.
  */
 
-/*
- * The zone field is never updated after free_area_init_core()
- * sets it, so none of the operations on it need to be atomic.
- */
-
-/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_CPUPID] | ... | FLAGS | */
-#define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
-#define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
-#define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
-#define LAST_CPUPID_PGOFF	(ZONES_PGOFF - LAST_CPUPID_WIDTH)
-#define KASAN_TAG_PGOFF		(LAST_CPUPID_PGOFF - KASAN_TAG_WIDTH)
-
-/*
- * Define the bit shifts to access each section.  For non-existent
- * sections we define the shift as 0; that plus a 0 mask ensures
- * the compiler will optimise away reference to them.
- */
-#define SECTIONS_PGSHIFT	(SECTIONS_PGOFF * (SECTIONS_WIDTH != 0))
-#define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
-#define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
-#define LAST_CPUPID_PGSHIFT	(LAST_CPUPID_PGOFF * (LAST_CPUPID_WIDTH != 0))
-#define KASAN_TAG_PGSHIFT	(KASAN_TAG_PGOFF * (KASAN_TAG_WIDTH != 0))
-
-/* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
-#ifdef NODE_NOT_IN_PAGE_FLAGS
-#define ZONEID_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
-#define ZONEID_PGOFF		((SECTIONS_PGOFF < ZONES_PGOFF)? \
-						SECTIONS_PGOFF : ZONES_PGOFF)
-#else
-#define ZONEID_SHIFT		(NODES_SHIFT + ZONES_SHIFT)
-#define ZONEID_PGOFF		((NODES_PGOFF < ZONES_PGOFF)? \
-						NODES_PGOFF : ZONES_PGOFF)
-#endif
-
-#define ZONEID_PGSHIFT		(ZONEID_PGOFF * (ZONEID_SHIFT != 0))
-
-#define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
-#define NODES_MASK		((1UL << NODES_WIDTH) - 1)
-#define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
-#define LAST_CPUPID_MASK	((1UL << LAST_CPUPID_SHIFT) - 1)
-#define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
-#define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
-
-static inline enum zone_type page_zonenum(const struct page *page)
-{
-	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
-	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
-}
-
-static inline enum zone_type folio_zonenum(const struct folio *folio)
-{
-	return page_zonenum(&folio->page);
-}
-
-#ifdef CONFIG_ZONE_DEVICE
-static inline bool is_zone_device_page(const struct page *page)
-{
-	return page_zonenum(page) == ZONE_DEVICE;
-}
-extern void memmap_init_zone_device(struct zone *, unsigned long,
-				    unsigned long, struct dev_pagemap *);
-#else
-static inline bool is_zone_device_page(const struct page *page)
-{
-	return false;
-}
-#endif
-
-static inline bool folio_is_zone_device(const struct folio *folio)
-{
-	return is_zone_device_page(&folio->page);
-}
-
-static inline bool is_zone_movable_page(const struct page *page)
-{
-	return page_zonenum(page) == ZONE_MOVABLE;
-}
-
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
--- a/include/linux/mmzone.h~mm-move-page-zone-helpers-from-mmh-to-mmzoneh
+++ a/include/linux/mmzone.h
@@ -730,6 +730,86 @@ static inline bool zone_is_empty(struct
 	return zone->spanned_pages == 0;
 }
 
+#ifndef BUILD_VDSO32_64
+/*
+ * The zone field is never updated after free_area_init_core()
+ * sets it, so none of the operations on it need to be atomic.
+ */
+
+/* Page flags: | [SECTION] | [NODE] | ZONE | [LAST_CPUPID] | ... | FLAGS | */
+#define SECTIONS_PGOFF		((sizeof(unsigned long)*8) - SECTIONS_WIDTH)
+#define NODES_PGOFF		(SECTIONS_PGOFF - NODES_WIDTH)
+#define ZONES_PGOFF		(NODES_PGOFF - ZONES_WIDTH)
+#define LAST_CPUPID_PGOFF	(ZONES_PGOFF - LAST_CPUPID_WIDTH)
+#define KASAN_TAG_PGOFF		(LAST_CPUPID_PGOFF - KASAN_TAG_WIDTH)
+
+/*
+ * Define the bit shifts to access each section.  For non-existent
+ * sections we define the shift as 0; that plus a 0 mask ensures
+ * the compiler will optimise away reference to them.
+ */
+#define SECTIONS_PGSHIFT	(SECTIONS_PGOFF * (SECTIONS_WIDTH != 0))
+#define NODES_PGSHIFT		(NODES_PGOFF * (NODES_WIDTH != 0))
+#define ZONES_PGSHIFT		(ZONES_PGOFF * (ZONES_WIDTH != 0))
+#define LAST_CPUPID_PGSHIFT	(LAST_CPUPID_PGOFF * (LAST_CPUPID_WIDTH != 0))
+#define KASAN_TAG_PGSHIFT	(KASAN_TAG_PGOFF * (KASAN_TAG_WIDTH != 0))
+
+/* NODE:ZONE or SECTION:ZONE is used to ID a zone for the buddy allocator */
+#ifdef NODE_NOT_IN_PAGE_FLAGS
+#define ZONEID_SHIFT		(SECTIONS_SHIFT + ZONES_SHIFT)
+#define ZONEID_PGOFF		((SECTIONS_PGOFF < ZONES_PGOFF) ? \
+						SECTIONS_PGOFF : ZONES_PGOFF)
+#else
+#define ZONEID_SHIFT		(NODES_SHIFT + ZONES_SHIFT)
+#define ZONEID_PGOFF		((NODES_PGOFF < ZONES_PGOFF) ? \
+						NODES_PGOFF : ZONES_PGOFF)
+#endif
+
+#define ZONEID_PGSHIFT		(ZONEID_PGOFF * (ZONEID_SHIFT != 0))
+
+#define ZONES_MASK		((1UL << ZONES_WIDTH) - 1)
+#define NODES_MASK		((1UL << NODES_WIDTH) - 1)
+#define SECTIONS_MASK		((1UL << SECTIONS_WIDTH) - 1)
+#define LAST_CPUPID_MASK	((1UL << LAST_CPUPID_SHIFT) - 1)
+#define KASAN_TAG_MASK		((1UL << KASAN_TAG_WIDTH) - 1)
+#define ZONEID_MASK		((1UL << ZONEID_SHIFT) - 1)
+
+static inline enum zone_type page_zonenum(const struct page *page)
+{
+	ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
+	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
+}
+
+static inline enum zone_type folio_zonenum(const struct folio *folio)
+{
+	return page_zonenum(&folio->page);
+}
+
+#ifdef CONFIG_ZONE_DEVICE
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return page_zonenum(page) == ZONE_DEVICE;
+}
+extern void memmap_init_zone_device(struct zone *, unsigned long,
+				    unsigned long, struct dev_pagemap *);
+#else
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return false;
+}
+#endif
+
+static inline bool folio_is_zone_device(const struct folio *folio)
+{
+	return is_zone_device_page(&folio->page);
+}
+
+static inline bool is_zone_movable_page(const struct page *page)
+{
+	return page_zonenum(page) == ZONE_MOVABLE;
+}
+#endif
+
 /*
  * Return true if [start_pfn, start_pfn + nr_pages) range has a non-empty
  * intersection with the given zone
_

Patches currently in -mm which might be from alex.sierra@amd.com are


