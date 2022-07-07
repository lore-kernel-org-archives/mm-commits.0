Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361FEC43334
	for <mm-commits@archiver.kernel.org>; Thu,  7 Jul 2022 19:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236035AbiGGTyJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiGGTyI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jul 2022 15:54:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE81F326F8
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 12:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2DEB823F8
        for <mm-commits@vger.kernel.org>; Thu,  7 Jul 2022 19:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A95C3411E;
        Thu,  7 Jul 2022 19:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657223644;
        bh=P7Tz5Y4j2ohbLekPQa3EgnVHDQKRyYiisuR6wmQ/pkk=;
        h=Date:To:From:Subject:From;
        b=qA5Fr2YeGYdYjRYLDFt76l/D5p/Wd9DzjZ8ebX1Gx8Knj7tw67+/6pJ0JyCtsFiWe
         mIKfZOnkngVHYLgxIFIEfVRjcBED+WqkoeWuOcKbkTvhEY76bcEv+svvG6B2Sycd5A
         Gb6BPE53wRoko3TQ9kPS5n3UyN5EO3p06Y6BNfbw=
Date:   Thu, 07 Jul 2022 12:54:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rcampbell@nvidia.com, jglisse@redhat.com, jgg@nvidia.com,
        hch@lst.de, Felix.Kuehling@amd.com, david@redhat.com,
        apopple@nvidia.com, alex.sierra@amd.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-page-zone-helpers-into-new-header-specific-file.patch added to mm-unstable branch
Message-Id: <20220707195404.40A95C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move page zone helpers into new header-specific file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-page-zone-helpers-into-new-header-specific-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-page-zone-helpers-into-new-header-specific-file.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alex Sierra <alex.sierra@amd.com>
Subject: mm: move page zone helpers into new header-specific file
Date: Thu, 7 Jul 2022 14:03:36 -0500

To have a cleaner way to expose all page zone helpers in one header file,
rather than split them between mm.h and memremap.h files.

Link: https://lkml.kernel.org/r/20220707190349.9778-3-alex.sierra@amd.com
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

 drivers/infiniband/core/rw.c      |    1 
 drivers/nvme/target/io-cmd-bdev.c |    1 
 include/linux/memremap.h          |  113 ----------------
 include/linux/mm.h                |   79 -----------
 include/linux/page_zone.h         |  194 ++++++++++++++++++++++++++++
 mm/memcontrol.c                   |    1 
 6 files changed, 196 insertions(+), 193 deletions(-)

--- a/drivers/infiniband/core/rw.c~mm-move-page-zone-helpers-into-new-header-specific-file
+++ a/drivers/infiniband/core/rw.c
@@ -2,7 +2,6 @@
 /*
  * Copyright (c) 2016 HGST, a Western Digital Company.
  */
-#include <linux/memremap.h>
 #include <linux/moduleparam.h>
 #include <linux/slab.h>
 #include <linux/pci-p2pdma.h>
--- a/drivers/nvme/target/io-cmd-bdev.c~mm-move-page-zone-helpers-into-new-header-specific-file
+++ a/drivers/nvme/target/io-cmd-bdev.c
@@ -6,7 +6,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/blkdev.h>
 #include <linux/blk-integrity.h>
-#include <linux/memremap.h>
 #include <linux/module.h>
 #include "nvmet.h"
 
--- a/include/linux/memremap.h~mm-move-page-zone-helpers-into-new-header-specific-file
+++ a/include/linux/memremap.h
@@ -2,70 +2,14 @@
 #ifndef _LINUX_MEMREMAP_H_
 #define _LINUX_MEMREMAP_H_
 
-#include <linux/mm.h>
 #include <linux/range.h>
 #include <linux/ioport.h>
 #include <linux/percpu-refcount.h>
+#include <linux/page_zone.h>
 
 struct resource;
 struct device;
 
-/**
- * struct vmem_altmap - pre-allocated storage for vmemmap_populate
- * @base_pfn: base of the entire dev_pagemap mapping
- * @reserve: pages mapped, but reserved for driver use (relative to @base)
- * @free: free pages set aside in the mapping for memmap storage
- * @align: pages reserved to meet allocation alignments
- * @alloc: track pages consumed, private to vmemmap_populate()
- */
-struct vmem_altmap {
-	unsigned long base_pfn;
-	const unsigned long end_pfn;
-	const unsigned long reserve;
-	unsigned long free;
-	unsigned long align;
-	unsigned long alloc;
-};
-
-/*
- * Specialize ZONE_DEVICE memory into multiple types each has a different
- * usage.
- *
- * MEMORY_DEVICE_PRIVATE:
- * Device memory that is not directly addressable by the CPU: CPU can neither
- * read nor write private memory. In this case, we do still have struct pages
- * backing the device memory. Doing so simplifies the implementation, but it is
- * important to remember that there are certain points at which the struct page
- * must be treated as an opaque object, rather than a "normal" struct page.
- *
- * A more complete discussion of unaddressable memory may be found in
- * include/linux/hmm.h and Documentation/mm/hmm.rst.
- *
- * MEMORY_DEVICE_FS_DAX:
- * Host memory that has similar access semantics as System RAM i.e. DMA
- * coherent and supports page pinning. In support of coordinating page
- * pinning vs other operations MEMORY_DEVICE_FS_DAX arranges for a
- * wakeup event whenever a page is unpinned and becomes idle. This
- * wakeup is used to coordinate physical address space management (ex:
- * fs truncate/hole punch) vs pinned pages (ex: device dma).
- *
- * MEMORY_DEVICE_GENERIC:
- * Host memory that has similar access semantics as System RAM i.e. DMA
- * coherent and supports page pinning. This is for example used by DAX devices
- * that expose memory using a character device.
- *
- * MEMORY_DEVICE_PCI_P2PDMA:
- * Device memory residing in a PCI BAR intended for use with Peer-to-Peer
- * transactions.
- */
-enum memory_type {
-	/* 0 is reserved to catch uninitialized type fields */
-	MEMORY_DEVICE_PRIVATE = 1,
-	MEMORY_DEVICE_FS_DAX,
-	MEMORY_DEVICE_GENERIC,
-	MEMORY_DEVICE_PCI_P2PDMA,
-};
-
 struct dev_pagemap_ops {
 	/*
 	 * Called once the page refcount reaches 0.  The reference count will be
@@ -83,42 +27,6 @@ struct dev_pagemap_ops {
 
 #define PGMAP_ALTMAP_VALID	(1 << 0)
 
-/**
- * struct dev_pagemap - metadata for ZONE_DEVICE mappings
- * @altmap: pre-allocated/reserved memory for vmemmap allocations
- * @ref: reference count that pins the devm_memremap_pages() mapping
- * @done: completion for @ref
- * @type: memory type: see MEMORY_* in memory_hotplug.h
- * @flags: PGMAP_* flags to specify defailed behavior
- * @vmemmap_shift: structural definition of how the vmemmap page metadata
- *      is populated, specifically the metadata page order.
- *	A zero value (default) uses base pages as the vmemmap metadata
- *	representation. A bigger value will set up compound struct pages
- *	of the requested order value.
- * @ops: method table
- * @owner: an opaque pointer identifying the entity that manages this
- *	instance.  Used by various helpers to make sure that no
- *	foreign ZONE_DEVICE memory is accessed.
- * @nr_range: number of ranges to be mapped
- * @range: range to be mapped when nr_range == 1
- * @ranges: array of ranges to be mapped when nr_range > 1
- */
-struct dev_pagemap {
-	struct vmem_altmap altmap;
-	struct percpu_ref ref;
-	struct completion done;
-	enum memory_type type;
-	unsigned int flags;
-	unsigned long vmemmap_shift;
-	const struct dev_pagemap_ops *ops;
-	void *owner;
-	int nr_range;
-	union {
-		struct range range;
-		struct range ranges[0];
-	};
-};
-
 static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
 {
 	if (pgmap->flags & PGMAP_ALTMAP_VALID)
@@ -131,25 +39,6 @@ static inline unsigned long pgmap_vmemma
 	return 1 << pgmap->vmemmap_shift;
 }
 
-static inline bool is_device_private_page(const struct page *page)
-{
-	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
-		is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
-}
-
-static inline bool folio_is_device_private(const struct folio *folio)
-{
-	return is_device_private_page(&folio->page);
-}
-
-static inline bool is_pci_p2pdma_page(const struct page *page)
-{
-	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
-		is_zone_device_page(page) &&
-		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
-}
-
 #ifdef CONFIG_ZONE_DEVICE
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
--- a/include/linux/mm.h~mm-move-page-zone-helpers-into-new-header-specific-file
+++ a/include/linux/mm.h
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/pgtable.h>
 #include <linux/kasan.h>
+#include <linux/page_zone.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1076,84 +1077,6 @@ vm_fault_t finish_mkwrite_fault(struct v
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
 
--- /dev/null
+++ a/include/linux/page_zone.h
@@ -0,0 +1,194 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _PAGE_ZONE_H_
+#define _PAGE_ZONE_H_
+
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
+/*
+ * Specialize ZONE_DEVICE memory into multiple types each has a different
+ * usage.
+ *
+ * MEMORY_DEVICE_PRIVATE:
+ * Device memory that is not directly addressable by the CPU: CPU can neither
+ * read nor write private memory. In this case, we do still have struct pages
+ * backing the device memory. Doing so simplifies the implementation, but it is
+ * important to remember that there are certain points at which the struct page
+ * must be treated as an opaque object, rather than a "normal" struct page.
+ *
+ * A more complete discussion of unaddressable memory may be found in
+ * include/linux/hmm.h and Documentation/mm/hmm.rst.
+ *
+ * MEMORY_DEVICE_FS_DAX:
+ * Host memory that has similar access semantics as System RAM i.e. DMA
+ * coherent and supports page pinning. In support of coordinating page
+ * pinning vs other operations MEMORY_DEVICE_FS_DAX arranges for a
+ * wakeup event whenever a page is unpinned and becomes idle. This
+ * wakeup is used to coordinate physical address space management (ex:
+ * fs truncate/hole punch) vs pinned pages (ex: device dma).
+ *
+ * MEMORY_DEVICE_GENERIC:
+ * Host memory that has similar access semantics as System RAM i.e. DMA
+ * coherent and supports page pinning. This is for example used by DAX devices
+ * that expose memory using a character device.
+ *
+ * MEMORY_DEVICE_PCI_P2PDMA:
+ * Device memory residing in a PCI BAR intended for use with Peer-to-Peer
+ * transactions.
+ */
+enum memory_type {
+	/* 0 is reserved to catch uninitialized type fields */
+	MEMORY_DEVICE_PRIVATE = 1,
+	MEMORY_DEVICE_FS_DAX,
+	MEMORY_DEVICE_GENERIC,
+	MEMORY_DEVICE_PCI_P2PDMA,
+};
+
+/**
+ * struct vmem_altmap - pre-allocated storage for vmemmap_populate
+ * @base_pfn: base of the entire dev_pagemap mapping
+ * @reserve: pages mapped, but reserved for driver use (relative to @base)
+ * @free: free pages set aside in the mapping for memmap storage
+ * @align: pages reserved to meet allocation alignments
+ * @alloc: track pages consumed, private to vmemmap_populate()
+ */
+struct vmem_altmap {
+	unsigned long base_pfn;
+	const unsigned long end_pfn;
+	const unsigned long reserve;
+	unsigned long free;
+	unsigned long align;
+	unsigned long alloc;
+};
+
+/**
+ * struct dev_pagemap - metadata for ZONE_DEVICE mappings
+ * @altmap: pre-allocated/reserved memory for vmemmap allocations
+ * @ref: reference count that pins the devm_memremap_pages() mapping
+ * @done: completion for @ref
+ * @type: memory type: see MEMORY_* in memory_hotplug.h
+ * @flags: PGMAP_* flags to specify defailed behavior
+ * @vmemmap_shift: structural definition of how the vmemmap page metadata
+ *      is populated, specifically the metadata page order.
+ *	A zero value (default) uses base pages as the vmemmap metadata
+ *	representation. A bigger value will set up compound struct pages
+ *	of the requested order value.
+ * @ops: method table
+ * @owner: an opaque pointer identifying the entity that manages this
+ *	instance.  Used by various helpers to make sure that no
+ *	foreign ZONE_DEVICE memory is accessed.
+ * @nr_range: number of ranges to be mapped
+ * @range: range to be mapped when nr_range == 1
+ * @ranges: array of ranges to be mapped when nr_range > 1
+ */
+struct dev_pagemap {
+	struct vmem_altmap altmap;
+	struct percpu_ref ref;
+	struct completion done;
+	enum memory_type type;
+	unsigned int flags;
+	unsigned long vmemmap_shift;
+	const struct dev_pagemap_ops *ops;
+	void *owner;
+	int nr_range;
+	union {
+		struct range range;
+		struct range ranges[0];
+	};
+};
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
+static inline bool is_zone_movable_page(const struct page *page)
+{
+	return page_zonenum(page) == ZONE_MOVABLE;
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
+static inline bool is_device_private_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_DEVICE_PRIVATE) &&
+		is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
+}
+
+static inline bool folio_is_device_private(const struct folio *folio)
+{
+	return is_device_private_page(&folio->page);
+}
+
+static inline bool is_pci_p2pdma_page(const struct page *page)
+{
+	return IS_ENABLED(CONFIG_PCI_P2PDMA) &&
+		is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PCI_P2PDMA;
+}
+
+#endif /* _PAGE_ZONE_H_ */
--- a/mm/memcontrol.c~mm-move-page-zone-helpers-into-new-header-specific-file
+++ a/mm/memcontrol.c
@@ -53,7 +53,6 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/vmpressure.h>
-#include <linux/memremap.h>
 #include <linux/mm_inline.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
_

Patches currently in -mm which might be from alex.sierra@amd.com are

mm-rename-is_pinnable_pages-to-is_longterm_pinnable_pages.patch
mm-move-page-zone-helpers-into-new-header-specific-file.patch
mm-add-zone-device-coherent-type-memory-support.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages.patch
mm-add-device-coherent-vma-selection-for-memory-migration.patch
drm-amdkfd-add-spm-support-for-svm.patch
lib-test_hmm-add-ioctl-to-get-zone-device-type.patch
lib-test_hmm-add-module-param-for-zone-device-type.patch
lib-add-support-for-device-coherent-type-in-test_hmm.patch
tools-update-hmm-test-to-support-device-coherent-type.patch
tools-update-test_hmm-script-to-support-sp-config.patch
tools-add-hmm-gup-tests-for-device-coherent-type.patch
tools-add-selftests-to-hmm-for-cow-in-device-memory.patch

