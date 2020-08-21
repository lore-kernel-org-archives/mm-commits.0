Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A22C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CACF6207DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052240;
	bh=pd0AjAeRaem5D2yxn2NFSLCUTp4I9lY4KqI7jHK+jtc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=K164uKYTH4G9Gm2XJLfucDJM+bj01TYsL+gdjTTZsWIcgLVRPORMnMlxQsDzZrjtm
	 hOdpr1ja60SA6/wDlPo65QKqxAjgfynf0iwzvR/XJnn0eaWzWueAmJAlNNeKvLUOcH
	 V2p6bsWG8aV+yfQ3dN4+PjdFxbdAgqMJWZQD6v2g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHUXYA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHUXX7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:23:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B2B5207CD;
        Fri, 21 Aug 2020 23:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052237;
        bh=pd0AjAeRaem5D2yxn2NFSLCUTp4I9lY4KqI7jHK+jtc=;
        h=Date:From:To:Subject:From;
        b=K1mdj9zY70MVZK1as+gDleiwWRqGqMFYWGqfNaLHa74aviLrl0TUtuq4LpYSTB3ZJ
         IADoYVowr09JpqjMsN7vwg2fS4XXZfcyMr74imPoo6nbJo8tH+9rZNybnBlHCPwE7U
         cePyo8F1pFvrsq+fgcp4uj7A02dGWL/g2HR2aS0Y=
Date:   Fri, 21 Aug 2020 16:23:55 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        ira.weiny@intel.com, jgg@mellanox.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, luto@kernel.org, mingo@redhat.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rafael@kernel.org,
        richardw.yang@linux.intel.com, rjw@rjwysocki.net,
        rppt@linux.ibm.com, tglx@linutronix.de, thomas.lendacky@amd.com,
        vishal.l.verma@intel.com, will@kernel.org
Subject:  + mm-memremap_pages-convert-to-struct-range.patch added
 to -mm tree
Message-ID: <20200821232355.Ia3AvoN-A%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap_pages: convert to 'struct range'
has been added to the -mm tree.  Its filename is
     mm-memremap_pages-convert-to-struct-range.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memremap_pages-convert-to-struct-range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memremap_pages-convert-to-struct-range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memremap_pages: convert to 'struct range'

The 'struct resource' in 'struct dev_pagemap' is only used for holding
resource span information.  The other fields, 'name', 'flags', 'desc',
'parent', 'sibling', and 'child' are all unused wasted space.

This is in preparation for introducing a multi-range extension of
devm_memremap_pages().

The bulk of this change is unwinding all the places internal to libnvdimm
that used 'struct resource' unnecessarily.

P2PDMA had a minor usage of the flags field, but only to report failures
with "%pR".  That is replaced with an open coded print of the range.

Link: https://lkml.kernel.org/r/159643103173.4062302.768998885691711532.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c     |   13 ++-
 drivers/dax/bus.c                      |   10 +-
 drivers/dax/bus.h                      |    2 
 drivers/dax/dax-private.h              |    5 -
 drivers/dax/device.c                   |    3 
 drivers/dax/hmem/hmem.c                |    5 +
 drivers/dax/pmem/core.c                |   12 +--
 drivers/gpu/drm/nouveau/nouveau_dmem.c |   14 ++--
 drivers/nvdimm/badrange.c              |   26 +++----
 drivers/nvdimm/claim.c                 |   13 ++-
 drivers/nvdimm/nd.h                    |    3 
 drivers/nvdimm/pfn_devs.c              |   12 +--
 drivers/nvdimm/pmem.c                  |   26 ++++---
 drivers/nvdimm/region.c                |   21 +++---
 drivers/pci/p2pdma.c                   |   11 +--
 include/linux/memremap.h               |    5 -
 include/linux/range.h                  |    6 +
 lib/test_hmm.c                         |   14 ++--
 mm/memremap.c                          |   77 +++++++++++------------
 tools/testing/nvdimm/test/iomap.c      |    2 
 20 files changed, 147 insertions(+), 133 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-memremap_pages-convert-to-struct-range
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -687,9 +687,9 @@ static struct page *kvmppc_uvmem_get_pag
 	struct kvmppc_uvmem_page_pvt *pvt;
 	unsigned long pfn_last, pfn_first;
 
-	pfn_first = kvmppc_uvmem_pgmap.res.start >> PAGE_SHIFT;
+	pfn_first = kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT;
 	pfn_last = pfn_first +
-		   (resource_size(&kvmppc_uvmem_pgmap.res) >> PAGE_SHIFT);
+		   (range_len(&kvmppc_uvmem_pgmap.range) >> PAGE_SHIFT);
 
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
 	bit = find_first_zero_bit(kvmppc_uvmem_bitmap,
@@ -1007,7 +1007,7 @@ static vm_fault_t kvmppc_uvmem_migrate_t
 static void kvmppc_uvmem_page_free(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page) -
-			(kvmppc_uvmem_pgmap.res.start >> PAGE_SHIFT);
+			(kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT);
 	struct kvmppc_uvmem_page_pvt *pvt;
 
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
@@ -1170,7 +1170,8 @@ int kvmppc_uvmem_init(void)
 	}
 
 	kvmppc_uvmem_pgmap.type = MEMORY_DEVICE_PRIVATE;
-	kvmppc_uvmem_pgmap.res = *res;
+	kvmppc_uvmem_pgmap.range.start = res->start;
+	kvmppc_uvmem_pgmap.range.end = res->end;
 	kvmppc_uvmem_pgmap.ops = &kvmppc_uvmem_ops;
 	/* just one global instance: */
 	kvmppc_uvmem_pgmap.owner = &kvmppc_uvmem_pgmap;
@@ -1205,7 +1206,7 @@ void kvmppc_uvmem_free(void)
 		return;
 
 	memunmap_pages(&kvmppc_uvmem_pgmap);
-	release_mem_region(kvmppc_uvmem_pgmap.res.start,
-			   resource_size(&kvmppc_uvmem_pgmap.res));
+	release_mem_region(kvmppc_uvmem_pgmap.range.start,
+			   range_len(&kvmppc_uvmem_pgmap.range));
 	kfree(kvmppc_uvmem_bitmap);
 }
--- a/drivers/dax/bus.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/bus.c
@@ -515,7 +515,7 @@ static void dax_region_unregister(void *
 }
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align,
+		struct range *range, int target_node, unsigned int align,
 		unsigned long flags)
 {
 	struct dax_region *dax_region;
@@ -530,8 +530,8 @@ struct dax_region *alloc_dax_region(stru
 		return NULL;
 	}
 
-	if (!IS_ALIGNED(res->start, align)
-			|| !IS_ALIGNED(resource_size(res), align))
+	if (!IS_ALIGNED(range->start, align)
+			|| !IS_ALIGNED(range_len(range), align))
 		return NULL;
 
 	dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
@@ -546,8 +546,8 @@ struct dax_region *alloc_dax_region(stru
 	dax_region->target_node = target_node;
 	ida_init(&dax_region->ida);
 	dax_region->res = (struct resource) {
-		.start = res->start,
-		.end = res->end,
+		.start = range->start,
+		.end = range->end,
 		.flags = IORESOURCE_MEM | flags,
 	};
 
--- a/drivers/dax/bus.h~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/bus.h
@@ -13,7 +13,7 @@ void dax_region_put(struct dax_region *d
 
 #define IORESOURCE_DAX_STATIC (1UL << 0)
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align,
+		struct range *range, int target_node, unsigned int align,
 		unsigned long flags);
 
 enum dev_dax_subsys {
--- a/drivers/dax/dax-private.h~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/dax-private.h
@@ -61,11 +61,6 @@ struct dev_dax {
 	struct range range;
 };
 
-static inline u64 range_len(struct range *range)
-{
-	return range->end - range->start + 1;
-}
-
 static inline struct dev_dax *to_dev_dax(struct device *dev)
 {
 	return container_of(dev, struct dev_dax, dev);
--- a/drivers/dax/device.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/device.c
@@ -416,8 +416,7 @@ int dev_dax_probe(struct dev_dax *dev_da
 		pgmap = devm_kzalloc(dev, sizeof(*pgmap), GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
-		pgmap->res.start = range->start;
-		pgmap->res.end = range->end;
+		pgmap->range = *range;
 	}
 	pgmap->type = MEMORY_DEVICE_DEVDAX;
 	addr = devm_memremap_pages(dev, pgmap);
--- a/drivers/dax/hmem/hmem.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/hmem/hmem.c
@@ -13,13 +13,16 @@ static int dax_hmem_probe(struct platfor
 	struct dev_dax_data data;
 	struct dev_dax *dev_dax;
 	struct resource *res;
+	struct range range;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENOMEM;
 
 	mri = dev->platform_data;
-	dax_region = alloc_dax_region(dev, pdev->id, res, mri->target_node,
+	range.start = res->start;
+	range.end = res->end;
+	dax_region = alloc_dax_region(dev, pdev->id, &range, mri->target_node,
 			PMD_SIZE, 0);
 	if (!dax_region)
 		return -ENOMEM;
--- a/drivers/dax/pmem/core.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/pmem/core.c
@@ -9,7 +9,7 @@
 
 struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys subsys)
 {
-	struct resource res;
+	struct range range;
 	int rc, id, region_id;
 	resource_size_t offset;
 	struct nd_pfn_sb *pfn_sb;
@@ -50,10 +50,10 @@ struct dev_dax *__dax_pmem_probe(struct
 	if (rc != 2)
 		return ERR_PTR(-EINVAL);
 
-	/* adjust the dax_region resource to the start of data */
-	memcpy(&res, &pgmap.res, sizeof(res));
-	res.start += offset;
-	dax_region = alloc_dax_region(dev, region_id, &res,
+	/* adjust the dax_region range to the start of data */
+	range = pgmap.range;
+	range.start += offset,
+	dax_region = alloc_dax_region(dev, region_id, &range,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
 			IORESOURCE_DAX_STATIC);
 	if (!dax_region)
@@ -64,7 +64,7 @@ struct dev_dax *__dax_pmem_probe(struct
 		.id = id,
 		.pgmap = &pgmap,
 		.subsys = subsys,
-		.size = resource_size(&res),
+		.size = range_len(&range),
 	};
 	dev_dax = devm_create_dev_dax(&data);
 
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -101,7 +101,7 @@ unsigned long nouveau_dmem_page_addr(str
 {
 	struct nouveau_dmem_chunk *chunk = nouveau_page_to_chunk(page);
 	unsigned long off = (page_to_pfn(page) << PAGE_SHIFT) -
-				chunk->pagemap.res.start;
+				chunk->pagemap.range.start;
 
 	return chunk->bo->offset + off;
 }
@@ -249,7 +249,8 @@ nouveau_dmem_chunk_alloc(struct nouveau_
 
 	chunk->drm = drm;
 	chunk->pagemap.type = MEMORY_DEVICE_PRIVATE;
-	chunk->pagemap.res = *res;
+	chunk->pagemap.range.start = res->start;
+	chunk->pagemap.range.end = res->end;
 	chunk->pagemap.ops = &nouveau_dmem_pagemap_ops;
 	chunk->pagemap.owner = drm->dev;
 
@@ -273,7 +274,7 @@ nouveau_dmem_chunk_alloc(struct nouveau_
 	list_add(&chunk->list, &drm->dmem->chunks);
 	mutex_unlock(&drm->dmem->mutex);
 
-	pfn_first = chunk->pagemap.res.start >> PAGE_SHIFT;
+	pfn_first = chunk->pagemap.range.start >> PAGE_SHIFT;
 	page = pfn_to_page(pfn_first);
 	spin_lock(&drm->dmem->lock);
 	for (i = 0; i < DMEM_CHUNK_NPAGES - 1; ++i, ++page) {
@@ -294,8 +295,7 @@ out_bo_unpin:
 out_bo_free:
 	nouveau_bo_ref(NULL, &chunk->bo);
 out_release:
-	release_mem_region(chunk->pagemap.res.start,
-			   resource_size(&chunk->pagemap.res));
+	release_mem_region(chunk->pagemap.range.start, range_len(&chunk->pagemap.range));
 out_free:
 	kfree(chunk);
 out:
@@ -382,8 +382,8 @@ nouveau_dmem_fini(struct nouveau_drm *dr
 		nouveau_bo_ref(NULL, &chunk->bo);
 		list_del(&chunk->list);
 		memunmap_pages(&chunk->pagemap);
-		release_mem_region(chunk->pagemap.res.start,
-				   resource_size(&chunk->pagemap.res));
+		release_mem_region(chunk->pagemap.range.start,
+				   range_len(&chunk->pagemap.range));
 		kfree(chunk);
 	}
 
--- a/drivers/nvdimm/badrange.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/badrange.c
@@ -211,7 +211,7 @@ static void __add_badblock_range(struct
 }
 
 static void badblocks_populate(struct badrange *badrange,
-		struct badblocks *bb, const struct resource *res)
+		struct badblocks *bb, const struct range *range)
 {
 	struct badrange_entry *bre;
 
@@ -222,34 +222,34 @@ static void badblocks_populate(struct ba
 		u64 bre_end = bre->start + bre->length - 1;
 
 		/* Discard intervals with no intersection */
-		if (bre_end < res->start)
+		if (bre_end < range->start)
 			continue;
-		if (bre->start >  res->end)
+		if (bre->start > range->end)
 			continue;
 		/* Deal with any overlap after start of the namespace */
-		if (bre->start >= res->start) {
+		if (bre->start >= range->start) {
 			u64 start = bre->start;
 			u64 len;
 
-			if (bre_end <= res->end)
+			if (bre_end <= range->end)
 				len = bre->length;
 			else
-				len = res->start + resource_size(res)
+				len = range->start + range_len(range)
 					- bre->start;
-			__add_badblock_range(bb, start - res->start, len);
+			__add_badblock_range(bb, start - range->start, len);
 			continue;
 		}
 		/*
 		 * Deal with overlap for badrange starting before
 		 * the namespace.
 		 */
-		if (bre->start < res->start) {
+		if (bre->start < range->start) {
 			u64 len;
 
-			if (bre_end < res->end)
-				len = bre->start + bre->length - res->start;
+			if (bre_end < range->end)
+				len = bre->start + bre->length - range->start;
 			else
-				len = resource_size(res);
+				len = range_len(range);
 			__add_badblock_range(bb, 0, len);
 		}
 	}
@@ -267,7 +267,7 @@ static void badblocks_populate(struct ba
  * and add badblocks entries for all matching sub-ranges
  */
 void nvdimm_badblocks_populate(struct nd_region *nd_region,
-		struct badblocks *bb, const struct resource *res)
+		struct badblocks *bb, const struct range *range)
 {
 	struct nvdimm_bus *nvdimm_bus;
 
@@ -279,7 +279,7 @@ void nvdimm_badblocks_populate(struct nd
 	nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
 
 	nvdimm_bus_lock(&nvdimm_bus->dev);
-	badblocks_populate(&nvdimm_bus->badrange, bb, res);
+	badblocks_populate(&nvdimm_bus->badrange, bb, range);
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
 EXPORT_SYMBOL_GPL(nvdimm_badblocks_populate);
--- a/drivers/nvdimm/claim.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/claim.c
@@ -303,13 +303,16 @@ static int nsio_rw_bytes(struct nd_names
 int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio,
 		resource_size_t size)
 {
-	struct resource *res = &nsio->res;
 	struct nd_namespace_common *ndns = &nsio->common;
+	struct range range = {
+		.start = nsio->res.start,
+		.end = nsio->res.end,
+	};
 
 	nsio->size = size;
-	if (!devm_request_mem_region(dev, res->start, size,
+	if (!devm_request_mem_region(dev, range.start, size,
 				dev_name(&ndns->dev))) {
-		dev_warn(dev, "could not reserve region %pR\n", res);
+		dev_warn(dev, "could not reserve region %pR\n", &nsio->res);
 		return -EBUSY;
 	}
 
@@ -317,9 +320,9 @@ int devm_nsio_enable(struct device *dev,
 	if (devm_init_badblocks(dev, &nsio->bb))
 		return -ENOMEM;
 	nvdimm_badblocks_populate(to_nd_region(ndns->dev.parent), &nsio->bb,
-			&nsio->res);
+			&range);
 
-	nsio->addr = devm_memremap(dev, res->start, size, ARCH_MEMREMAP_PMEM);
+	nsio->addr = devm_memremap(dev, range.start, size, ARCH_MEMREMAP_PMEM);
 
 	return PTR_ERR_OR_ZERO(nsio->addr);
 }
--- a/drivers/nvdimm/nd.h~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/nd.h
@@ -377,8 +377,9 @@ int nvdimm_namespace_detach_btt(struct n
 const char *nvdimm_namespace_disk_name(struct nd_namespace_common *ndns,
 		char *name);
 unsigned int pmem_sector_size(struct nd_namespace_common *ndns);
+struct range;
 void nvdimm_badblocks_populate(struct nd_region *nd_region,
-		struct badblocks *bb, const struct resource *res);
+		struct badblocks *bb, const struct range *range);
 int devm_namespace_enable(struct device *dev, struct nd_namespace_common *ndns,
 		resource_size_t size);
 void devm_namespace_disable(struct device *dev,
--- a/drivers/nvdimm/pfn_devs.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/pfn_devs.c
@@ -672,7 +672,7 @@ static unsigned long init_altmap_reserve
 
 static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *pgmap)
 {
-	struct resource *res = &pgmap->res;
+	struct range *range = &pgmap->range;
 	struct vmem_altmap *altmap = &pgmap->altmap;
 	struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
 	u64 offset = le64_to_cpu(pfn_sb->dataoff);
@@ -689,16 +689,16 @@ static int __nvdimm_setup_pfn(struct nd_
 		.end_pfn = PHYS_PFN(end),
 	};
 
-	memcpy(res, &nsio->res, sizeof(*res));
-	res->start += start_pad;
-	res->end -= end_trunc;
-
+	*range = (struct range) {
+		.start = nsio->res.start + start_pad,
+		.end = nsio->res.end - end_trunc,
+	};
 	if (nd_pfn->mode == PFN_MODE_RAM) {
 		if (offset < reserve)
 			return -EINVAL;
 		nd_pfn->npfns = le64_to_cpu(pfn_sb->npfns);
 	} else if (nd_pfn->mode == PFN_MODE_PMEM) {
-		nd_pfn->npfns = PHYS_PFN((resource_size(res) - offset));
+		nd_pfn->npfns = PHYS_PFN((range_len(range) - offset));
 		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
 			dev_info(&nd_pfn->dev,
 					"number of pfns truncated from %lld to %ld\n",
--- a/drivers/nvdimm/pmem.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/pmem.c
@@ -376,7 +376,7 @@ static int pmem_attach_disk(struct devic
 	struct nd_region *nd_region = to_nd_region(dev->parent);
 	int nid = dev_to_node(dev), fua;
 	struct resource *res = &nsio->res;
-	struct resource bb_res;
+	struct range bb_range;
 	struct nd_pfn *nd_pfn = NULL;
 	struct dax_device *dax_dev;
 	struct nd_pfn_sb *pfn_sb;
@@ -435,24 +435,26 @@ static int pmem_attach_disk(struct devic
 		pfn_sb = nd_pfn->pfn_sb;
 		pmem->data_offset = le64_to_cpu(pfn_sb->dataoff);
 		pmem->pfn_pad = resource_size(res) -
-			resource_size(&pmem->pgmap.res);
+			range_len(&pmem->pgmap.range);
 		pmem->pfn_flags |= PFN_MAP;
-		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
-		bb_res.start += pmem->data_offset;
+		bb_range = pmem->pgmap.range;
+		bb_range.start += pmem->data_offset;
 	} else if (pmem_should_map_pages(dev)) {
-		memcpy(&pmem->pgmap.res, &nsio->res, sizeof(pmem->pgmap.res));
+		pmem->pgmap.range.start = res->start;
+		pmem->pgmap.range.end = res->end;
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
 		pmem->pgmap.ops = &fsdax_pagemap_ops;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		pmem->pfn_flags |= PFN_MAP;
-		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
+		bb_range = pmem->pgmap.range;
 	} else {
 		if (devm_add_action_or_reset(dev, pmem_release_queue,
 					&pmem->pgmap))
 			return -ENOMEM;
 		addr = devm_memremap(dev, pmem->phys_addr,
 				pmem->size, ARCH_MEMREMAP_PMEM);
-		memcpy(&bb_res, &nsio->res, sizeof(bb_res));
+		bb_range.start =  res->start;
+		bb_range.end = res->end;
 	}
 
 	if (IS_ERR(addr))
@@ -482,7 +484,7 @@ static int pmem_attach_disk(struct devic
 			/ 512);
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
-	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_res);
+	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb = &pmem->bb;
 
 	if (is_nvdimm_sync(nd_region))
@@ -593,8 +595,8 @@ static void nd_pmem_notify(struct device
 	resource_size_t offset = 0, end_trunc = 0;
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
-	struct resource res;
 	struct badblocks *bb;
+	struct range range;
 	struct kernfs_node *bb_state;
 
 	if (event != NVDIMM_REVALIDATE_POISON)
@@ -630,9 +632,9 @@ static void nd_pmem_notify(struct device
 		nsio = to_nd_namespace_io(&ndns->dev);
 	}
 
-	res.start = nsio->res.start + offset;
-	res.end = nsio->res.end - end_trunc;
-	nvdimm_badblocks_populate(nd_region, bb, &res);
+	range.start = nsio->res.start + offset;
+	range.end = nsio->res.end - end_trunc;
+	nvdimm_badblocks_populate(nd_region, bb, &range);
 	if (bb_state)
 		sysfs_notify_dirent(bb_state);
 }
--- a/drivers/nvdimm/region.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/region.c
@@ -35,7 +35,10 @@ static int nd_region_probe(struct device
 		return rc;
 
 	if (is_memory(&nd_region->dev)) {
-		struct resource ndr_res;
+		struct range range = {
+			.start = nd_region->ndr_start,
+			.end = nd_region->ndr_start + nd_region->ndr_size - 1,
+		};
 
 		if (devm_init_badblocks(dev, &nd_region->bb))
 			return -ENODEV;
@@ -44,9 +47,7 @@ static int nd_region_probe(struct device
 		if (!nd_region->bb_state)
 			dev_warn(&nd_region->dev,
 					"'badblocks' notification disabled\n");
-		ndr_res.start = nd_region->ndr_start;
-		ndr_res.end = nd_region->ndr_start + nd_region->ndr_size - 1;
-		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &ndr_res);
+		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &range);
 	}
 
 	rc = nd_region_register_namespaces(nd_region, &err);
@@ -121,14 +122,16 @@ static void nd_region_notify(struct devi
 {
 	if (event == NVDIMM_REVALIDATE_POISON) {
 		struct nd_region *nd_region = to_nd_region(dev);
-		struct resource res;
 
 		if (is_memory(&nd_region->dev)) {
-			res.start = nd_region->ndr_start;
-			res.end = nd_region->ndr_start +
-				nd_region->ndr_size - 1;
+			struct range range = {
+				.start = nd_region->ndr_start,
+				.end = nd_region->ndr_start +
+					nd_region->ndr_size - 1,
+			};
+
 			nvdimm_badblocks_populate(nd_region,
-					&nd_region->bb, &res);
+					&nd_region->bb, &range);
 			if (nd_region->bb_state)
 				sysfs_notify_dirent(nd_region->bb_state);
 		}
--- a/drivers/pci/p2pdma.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/pci/p2pdma.c
@@ -185,9 +185,8 @@ int pci_p2pdma_add_resource(struct pci_d
 		return -ENOMEM;
 
 	pgmap = &p2p_pgmap->pgmap;
-	pgmap->res.start = pci_resource_start(pdev, bar) + offset;
-	pgmap->res.end = pgmap->res.start + size - 1;
-	pgmap->res.flags = pci_resource_flags(pdev, bar);
+	pgmap->range.start = pci_resource_start(pdev, bar) + offset;
+	pgmap->range.end = pgmap->range.start + size - 1;
 	pgmap->type = MEMORY_DEVICE_PCI_P2PDMA;
 
 	p2p_pgmap->provider = pdev;
@@ -202,13 +201,13 @@ int pci_p2pdma_add_resource(struct pci_d
 
 	error = gen_pool_add_owner(pdev->p2pdma->pool, (unsigned long)addr,
 			pci_bus_address(pdev, bar) + offset,
-			resource_size(&pgmap->res), dev_to_node(&pdev->dev),
+			range_len(&pgmap->range), dev_to_node(&pdev->dev),
 			pgmap->ref);
 	if (error)
 		goto pages_free;
 
-	pci_info(pdev, "added peer-to-peer DMA memory %pR\n",
-		 &pgmap->res);
+	pci_info(pdev, "added peer-to-peer DMA memory %#llx-%#llx\n",
+		 pgmap->range.start, pgmap->range.end);
 
 	return 0;
 
--- a/include/linux/memremap.h~mm-memremap_pages-convert-to-struct-range
+++ a/include/linux/memremap.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_MEMREMAP_H_
 #define _LINUX_MEMREMAP_H_
+#include <linux/range.h>
 #include <linux/ioport.h>
 #include <linux/percpu-refcount.h>
 
@@ -94,7 +95,7 @@ struct dev_pagemap_ops {
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
- * @res: physical address range covered by @ref
+ * @range: physical address range covered by @ref
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @internal_ref: internal reference if @ref is not provided by the caller
  * @done: completion for @internal_ref
@@ -107,7 +108,7 @@ struct dev_pagemap_ops {
  */
 struct dev_pagemap {
 	struct vmem_altmap altmap;
-	struct resource res;
+	struct range range;
 	struct percpu_ref *ref;
 	struct percpu_ref internal_ref;
 	struct completion done;
--- a/include/linux/range.h~mm-memremap_pages-convert-to-struct-range
+++ a/include/linux/range.h
@@ -1,12 +1,18 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_RANGE_H
 #define _LINUX_RANGE_H
+#include <linux/types.h>
 
 struct range {
 	u64   start;
 	u64   end;
 };
 
+static inline u64 range_len(const struct range *range)
+{
+	return range->end - range->start + 1;
+}
+
 int add_range(struct range *range, int az, int nr_range,
 		u64 start, u64 end);
 
--- a/lib/test_hmm.c~mm-memremap_pages-convert-to-struct-range
+++ a/lib/test_hmm.c
@@ -487,7 +487,8 @@ static bool dmirror_allocate_chunk(struc
 		goto err_release;
 
 	devmem->pagemap.type = MEMORY_DEVICE_PRIVATE;
-	devmem->pagemap.res = *res;
+	devmem->pagemap.range.start = res->start;
+	devmem->pagemap.range.end = res->end;
 	devmem->pagemap.ops = &dmirror_devmem_ops;
 	devmem->pagemap.owner = mdevice;
 
@@ -496,9 +497,8 @@ static bool dmirror_allocate_chunk(struc
 		goto err_free;
 
 	devmem->mdevice = mdevice;
-	pfn_first = devmem->pagemap.res.start >> PAGE_SHIFT;
-	pfn_last = pfn_first +
-		(resource_size(&devmem->pagemap.res) >> PAGE_SHIFT);
+	pfn_first = devmem->pagemap.range.start >> PAGE_SHIFT;
+	pfn_last = pfn_first + (range_len(&devmem->pagemap.range) >> PAGE_SHIFT);
 	mdevice->devmem_chunks[mdevice->devmem_count++] = devmem;
 
 	mutex_unlock(&mdevice->devmem_lock);
@@ -528,7 +528,7 @@ static bool dmirror_allocate_chunk(struc
 err_free:
 	kfree(devmem);
 err_release:
-	release_mem_region(res->start, resource_size(res));
+	release_mem_region(devmem->pagemap.range.start, range_len(&devmem->pagemap.range));
 err:
 	mutex_unlock(&mdevice->devmem_lock);
 	return false;
@@ -1100,8 +1100,8 @@ static void dmirror_device_remove(struct
 				mdevice->devmem_chunks[i];
 
 			memunmap_pages(&devmem->pagemap);
-			release_mem_region(devmem->pagemap.res.start,
-					   resource_size(&devmem->pagemap.res));
+			release_mem_region(devmem->pagemap.range.start,
+					   range_len(&devmem->pagemap.range));
 			kfree(devmem);
 		}
 		kfree(mdevice->devmem_chunks);
--- a/mm/memremap.c~mm-memremap_pages-convert-to-struct-range
+++ a/mm/memremap.c
@@ -70,24 +70,24 @@ static void devmap_managed_enable_put(vo
 }
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
 
-static void pgmap_array_delete(struct resource *res)
+static void pgmap_array_delete(struct range *range)
 {
-	xa_store_range(&pgmap_array, PHYS_PFN(res->start), PHYS_PFN(res->end),
+	xa_store_range(&pgmap_array, PHYS_PFN(range->start), PHYS_PFN(range->end),
 			NULL, GFP_KERNEL);
 	synchronize_rcu();
 }
 
 static unsigned long pfn_first(struct dev_pagemap *pgmap)
 {
-	return PHYS_PFN(pgmap->res.start) +
+	return PHYS_PFN(pgmap->range.start) +
 		vmem_altmap_offset(pgmap_altmap(pgmap));
 }
 
 static unsigned long pfn_end(struct dev_pagemap *pgmap)
 {
-	const struct resource *res = &pgmap->res;
+	const struct range *range = &pgmap->range;
 
-	return (res->start + resource_size(res)) >> PAGE_SHIFT;
+	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
 
 static unsigned long pfn_next(unsigned long pfn)
@@ -146,7 +146,7 @@ static void dev_pagemap_cleanup(struct d
 
 void memunmap_pages(struct dev_pagemap *pgmap)
 {
-	struct resource *res = &pgmap->res;
+	struct range *range = &pgmap->range;
 	struct page *first_page;
 	unsigned long pfn;
 	int nid;
@@ -163,20 +163,20 @@ void memunmap_pages(struct dev_pagemap *
 	nid = page_to_nid(first_page);
 
 	mem_hotplug_begin();
-	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(res->start),
-				   PHYS_PFN(resource_size(res)));
+	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(range->start),
+				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
-		__remove_pages(PHYS_PFN(res->start),
-			       PHYS_PFN(resource_size(res)), NULL);
+		__remove_pages(PHYS_PFN(range->start),
+			       PHYS_PFN(range_len(range)), NULL);
 	} else {
-		arch_remove_memory(nid, res->start, resource_size(res),
+		arch_remove_memory(nid, range->start, range_len(range),
 				pgmap_altmap(pgmap));
-		kasan_remove_zero_shadow(__va(res->start), resource_size(res));
+		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
 
-	untrack_pfn(NULL, PHYS_PFN(res->start), resource_size(res));
-	pgmap_array_delete(res);
+	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range));
+	pgmap_array_delete(range);
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
 	devmap_managed_enable_put();
 }
@@ -202,7 +202,7 @@ static void dev_pagemap_percpu_release(s
  */
 void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
-	struct resource *res = &pgmap->res;
+	struct range *range = &pgmap->range;
 	struct dev_pagemap *conflict_pgmap;
 	struct mhp_params params = {
 		/*
@@ -271,7 +271,7 @@ void *memremap_pages(struct dev_pagemap
 			return ERR_PTR(error);
 	}
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(res->start), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->start), NULL);
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
@@ -279,7 +279,7 @@ void *memremap_pages(struct dev_pagemap
 		goto err_array;
 	}
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(res->end), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->end), NULL);
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
@@ -287,26 +287,27 @@ void *memremap_pages(struct dev_pagemap
 		goto err_array;
 	}
 
-	is_ram = region_intersects(res->start, resource_size(res),
+	is_ram = region_intersects(range->start, range_len(range),
 		IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
 
 	if (is_ram != REGION_DISJOINT) {
-		WARN_ONCE(1, "%s attempted on %s region %pr\n", __func__,
-				is_ram == REGION_MIXED ? "mixed" : "ram", res);
+		WARN_ONCE(1, "attempted on %s region %#llx-%#llx\n",
+				is_ram == REGION_MIXED ? "mixed" : "ram",
+				range->start, range->end);
 		error = -ENXIO;
 		goto err_array;
 	}
 
-	error = xa_err(xa_store_range(&pgmap_array, PHYS_PFN(res->start),
-				PHYS_PFN(res->end), pgmap, GFP_KERNEL));
+	error = xa_err(xa_store_range(&pgmap_array, PHYS_PFN(range->start),
+				PHYS_PFN(range->end), pgmap, GFP_KERNEL));
 	if (error)
 		goto err_array;
 
 	if (nid < 0)
 		nid = numa_mem_id();
 
-	error = track_pfn_remap(NULL, &params.pgprot, PHYS_PFN(res->start),
-				0, resource_size(res));
+	error = track_pfn_remap(NULL, &params.pgprot, PHYS_PFN(range->start), 0,
+			range_len(range));
 	if (error)
 		goto err_pfn_remap;
 
@@ -324,16 +325,16 @@ void *memremap_pages(struct dev_pagemap
 	 * arch_add_memory().
 	 */
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
-		error = add_pages(nid, PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), &params);
+		error = add_pages(nid, PHYS_PFN(range->start),
+				PHYS_PFN(range_len(range)), &params);
 	} else {
-		error = kasan_add_zero_shadow(__va(res->start), resource_size(res));
+		error = kasan_add_zero_shadow(__va(range->start), range_len(range));
 		if (error) {
 			mem_hotplug_done();
 			goto err_kasan;
 		}
 
-		error = arch_add_memory(nid, res->start, resource_size(res),
+		error = arch_add_memory(nid, range->start, range_len(range),
 					&params);
 	}
 
@@ -341,8 +342,8 @@ void *memremap_pages(struct dev_pagemap
 		struct zone *zone;
 
 		zone = &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
-		move_pfn_range_to_zone(zone, PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), params.altmap);
+		move_pfn_range_to_zone(zone, PHYS_PFN(range->start),
+				PHYS_PFN(range_len(range)), params.altmap);
 	}
 
 	mem_hotplug_done();
@@ -354,17 +355,17 @@ void *memremap_pages(struct dev_pagemap
 	 * to allow us to do the work while not holding the hotplug lock.
 	 */
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
-				PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), pgmap);
+				PHYS_PFN(range->start),
+				PHYS_PFN(range_len(range)), pgmap);
 	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap) - pfn_first(pgmap));
-	return __va(res->start);
+	return __va(range->start);
 
  err_add_memory:
-	kasan_remove_zero_shadow(__va(res->start), resource_size(res));
+	kasan_remove_zero_shadow(__va(range->start), range_len(range));
  err_kasan:
-	untrack_pfn(NULL, PHYS_PFN(res->start), resource_size(res));
+	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range));
  err_pfn_remap:
-	pgmap_array_delete(res);
+	pgmap_array_delete(range);
  err_array:
 	dev_pagemap_kill(pgmap);
 	dev_pagemap_cleanup(pgmap);
@@ -389,7 +390,7 @@ EXPORT_SYMBOL_GPL(memremap_pages);
  *    'live' on entry and will be killed and reaped at
  *    devm_memremap_pages_release() time, or if this routine fails.
  *
- * 4/ res is expected to be a host memory range that could feasibly be
+ * 4/ range is expected to be a host memory range that could feasibly be
  *    treated as a "System RAM" range, i.e. not a device mmio range, but
  *    this is not enforced.
  */
@@ -446,7 +447,7 @@ struct dev_pagemap *get_dev_pagemap(unsi
 	 * In the cached case we're already holding a live reference.
 	 */
 	if (pgmap) {
-		if (phys >= pgmap->res.start && phys <= pgmap->res.end)
+		if (phys >= pgmap->range.start && phys <= pgmap->range.end)
 			return pgmap;
 		put_dev_pagemap(pgmap);
 	}
--- a/tools/testing/nvdimm/test/iomap.c~mm-memremap_pages-convert-to-struct-range
+++ a/tools/testing/nvdimm/test/iomap.c
@@ -126,7 +126,7 @@ static void dev_pagemap_percpu_release(s
 void *__wrap_devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap)
 {
 	int error;
-	resource_size_t offset = pgmap->res.start;
+	resource_size_t offset = pgmap->range.start;
 	struct nfit_test_resource *nfit_res = get_nfit_res(offset);
 
 	if (!nfit_res)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

x86-numa-cleanup-configuration-dependent-command-line-options.patch
x86-numa-add-nohmat-option.patch
efi-fake_mem-arrange-for-a-resource-entry-per-efi_fake_mem-instance.patch
acpi-hmat-refactor-hmat_register_target_device-to-hmem_register_device.patch
resource-report-parent-to-walk_iomem_res_desc-callback.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation.patch
acpi-hmat-attach-a-device-for-each-soft-reserved-range.patch
device-dax-drop-the-dax_regionpfn_flags-attribute.patch
device-dax-move-instance-creation-parameters-to-struct-dev_dax_data.patch
device-dax-make-pgmap-optional-for-instance-creation.patch
device-dax-kill-dax_kmem_res.patch
device-dax-add-an-allocation-interface-for-device-dax-instances.patch
device-dax-introduce-seed-devices.patch
drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inputs.patch
device-dax-add-resize-support.patch
mm-memremap_pages-convert-to-struct-range.patch
mm-memremap_pages-support-multiple-ranges-per-invocation.patch
device-dax-add-dis-contiguous-resource-support.patch
device-dax-introduce-mapping-devices.patch

