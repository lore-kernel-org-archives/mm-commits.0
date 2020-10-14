Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20925C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E9F32068E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709092;
	bh=CUGLcyzzDcGVOfEiZ51Lce5mqz6nJ9a9n8D6ynXWkKk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=2Byp4xTYmw13kJxfQ7YPKYHoluseT4CZP7Frka5CazYUF6KDVmd87bkPXSbCC9sAQ
	 h7pXqMmOqaexSAnZKOaFArPvW17gAVWc0bjwmuXIEHuz9mwocsyn38oi1IRsKRbGB9
	 sajTHJJpb8GUNxz11Bp+LKTdJ1B0lgM0ahJKaT/k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgJNU6M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNU6M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC1FC22248;
        Wed, 14 Oct 2020 20:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709089;
        bh=CUGLcyzzDcGVOfEiZ51Lce5mqz6nJ9a9n8D6ynXWkKk=;
        h=Date:From:To:Subject:From;
        b=QTXpIVcbj3QzVKga53+hw7HZC6S3OsRmI6NV1toZIKHtZ6sSoqIVPiFjY9PY5RFEi
         FgBjdD3IAgRwN+B0vxGC+8PjuAFUFWjf6BhacyT43F4K8ms58syCeDuBU0ElRwWCbx
         FudPMCYILQUjM9lWE+floRi+gzmw3axwsI50AZgE=
Date:   Wed, 14 Oct 2020 13:58:06 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.carpenter@oracle.com, dan.j.williams@intel.com,
        daniel@ffwll.ch, dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, lkp@intel.com, luto@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        pasha.tatashin@soleen.com, paulus@ozlabs.org, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rdunlap@infradead.org,
        richard.weiyang@linux.alibaba.com, rppt@linux.ibm.com,
        sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, vgoyal@redhat.com,
        vishal.l.verma@intel.com, will@kernel.org, yanaijie@huawei.com
Subject:  [merged] mm-memremap_pages-convert-to-struct-range.patch
 removed from -mm tree
Message-ID: <20201014205806.bw9OZHhk1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap_pages: convert to 'struct range'
has been removed from the -mm tree.  Its filename was
     mm-memremap_pages-convert-to-struct-range.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memremap_pages: convert to 'struct range'

The 'struct resource' in 'struct dev_pagemap' is only used for holding
resource span information.  The other fields, 'name', 'flags', 'desc',
'parent', 'sibling', and 'child' are all unused wasted space.

This is in preparation for introducing a multi-range extension of
devm_memremap_pages().

The bulk of this change is unwinding all the places internal to libnvdimm
that used 'struct resource' unnecessarily, and replacing instances of
'struct dev_pagemap'.res with 'struct dev_pagemap'.range.

P2PDMA had a minor usage of the resource flags field, but only to report
failures with "%pR".  That is replaced with an open coded print of the
range.

[dan.carpenter@oracle.com: mm/hmm/test: use after free in dmirror_allocate_=
chunk()]
  Link: https://lkml.kernel.org/r/20200926121402.GA7467@kadam
Link: https://lkml.kernel.org/r/159643103173.4062302.768998885691711532.stg=
it@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106115761.30709.13539840236873663620.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>	[xen]
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
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
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_uvmem.c     |   13 ++-
 drivers/dax/bus.c                      |   10 +-
 drivers/dax/bus.h                      |    2=20
 drivers/dax/dax-private.h              |    5 -
 drivers/dax/device.c                   |    3=20
 drivers/dax/hmem/hmem.c                |    5 +
 drivers/dax/pmem/core.c                |   12 +--
 drivers/gpu/drm/nouveau/nouveau_dmem.c |   14 ++--
 drivers/nvdimm/badrange.c              |   26 +++----
 drivers/nvdimm/claim.c                 |   13 ++-
 drivers/nvdimm/nd.h                    |    3=20
 drivers/nvdimm/pfn_devs.c              |   12 +--
 drivers/nvdimm/pmem.c                  |   26 ++++---
 drivers/nvdimm/region.c                |   21 +++---
 drivers/pci/p2pdma.c                   |   11 +--
 drivers/xen/unpopulated-alloc.c        |   44 ++++++++-----
 include/linux/memremap.h               |    5 -
 include/linux/range.h                  |    6 +
 lib/test_hmm.c                         |   50 +++++++-------
 mm/memremap.c                          |   77 +++++++++++------------
 tools/testing/nvdimm/test/iomap.c      |    2=20
 21 files changed, 195 insertions(+), 165 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-memremap_pages-convert-to-struc=
t-range
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -687,9 +687,9 @@ static struct page *kvmppc_uvmem_get_pag
 	struct kvmppc_uvmem_page_pvt *pvt;
 	unsigned long pfn_last, pfn_first;
=20
-	pfn_first =3D kvmppc_uvmem_pgmap.res.start >> PAGE_SHIFT;
+	pfn_first =3D kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT;
 	pfn_last =3D pfn_first +
-		   (resource_size(&kvmppc_uvmem_pgmap.res) >> PAGE_SHIFT);
+		   (range_len(&kvmppc_uvmem_pgmap.range) >> PAGE_SHIFT);
=20
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
 	bit =3D find_first_zero_bit(kvmppc_uvmem_bitmap,
@@ -1007,7 +1007,7 @@ static vm_fault_t kvmppc_uvmem_migrate_t
 static void kvmppc_uvmem_page_free(struct page *page)
 {
 	unsigned long pfn =3D page_to_pfn(page) -
-			(kvmppc_uvmem_pgmap.res.start >> PAGE_SHIFT);
+			(kvmppc_uvmem_pgmap.range.start >> PAGE_SHIFT);
 	struct kvmppc_uvmem_page_pvt *pvt;
=20
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
@@ -1170,7 +1170,8 @@ int kvmppc_uvmem_init(void)
 	}
=20
 	kvmppc_uvmem_pgmap.type =3D MEMORY_DEVICE_PRIVATE;
-	kvmppc_uvmem_pgmap.res =3D *res;
+	kvmppc_uvmem_pgmap.range.start =3D res->start;
+	kvmppc_uvmem_pgmap.range.end =3D res->end;
 	kvmppc_uvmem_pgmap.ops =3D &kvmppc_uvmem_ops;
 	/* just one global instance: */
 	kvmppc_uvmem_pgmap.owner =3D &kvmppc_uvmem_pgmap;
@@ -1205,7 +1206,7 @@ void kvmppc_uvmem_free(void)
 		return;
=20
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
=20
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align,
+		struct range *range, int target_node, unsigned int align,
 		unsigned long flags)
 {
 	struct dax_region *dax_region;
@@ -530,8 +530,8 @@ struct dax_region *alloc_dax_region(stru
 		return NULL;
 	}
=20
-	if (!IS_ALIGNED(res->start, align)
-			|| !IS_ALIGNED(resource_size(res), align))
+	if (!IS_ALIGNED(range->start, align)
+			|| !IS_ALIGNED(range_len(range), align))
 		return NULL;
=20
 	dax_region =3D kzalloc(sizeof(*dax_region), GFP_KERNEL);
@@ -546,8 +546,8 @@ struct dax_region *alloc_dax_region(stru
 	dax_region->target_node =3D target_node;
 	ida_init(&dax_region->ida);
 	dax_region->res =3D (struct resource) {
-		.start =3D res->start,
-		.end =3D res->end,
+		.start =3D range->start,
+		.end =3D range->end,
 		.flags =3D IORESOURCE_MEM | flags,
 	};
=20
--- a/drivers/dax/bus.h~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/bus.h
@@ -13,7 +13,7 @@ void dax_region_put(struct dax_region *d
=20
 #define IORESOURCE_DAX_STATIC (1UL << 0)
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align,
+		struct range *range, int target_node, unsigned int align,
 		unsigned long flags);
=20
 enum dev_dax_subsys {
--- a/drivers/dax/dax-private.h~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/dax-private.h
@@ -61,11 +61,6 @@ struct dev_dax {
 	struct range range;
 };
=20
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
 		pgmap =3D devm_kzalloc(dev, sizeof(*pgmap), GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
-		pgmap->res.start =3D range->start;
-		pgmap->res.end =3D range->end;
+		pgmap->range =3D *range;
 	}
 	pgmap->type =3D MEMORY_DEVICE_GENERIC;
 	addr =3D devm_memremap_pages(dev, pgmap);
--- a/drivers/dax/hmem/hmem.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/hmem/hmem.c
@@ -13,13 +13,16 @@ static int dax_hmem_probe(struct platfor
 	struct dev_dax_data data;
 	struct dev_dax *dev_dax;
 	struct resource *res;
+	struct range range;
=20
 	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENOMEM;
=20
 	mri =3D dev->platform_data;
-	dax_region =3D alloc_dax_region(dev, pdev->id, res, mri->target_node,
+	range.start =3D res->start;
+	range.end =3D res->end;
+	dax_region =3D alloc_dax_region(dev, pdev->id, &range, mri->target_node,
 			PMD_SIZE, 0);
 	if (!dax_region)
 		return -ENOMEM;
--- a/drivers/dax/pmem/core.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/dax/pmem/core.c
@@ -9,7 +9,7 @@
=20
 struct dev_dax *__dax_pmem_probe(struct device *dev, enum dev_dax_subsys s=
ubsys)
 {
-	struct resource res;
+	struct range range;
 	int rc, id, region_id;
 	resource_size_t offset;
 	struct nd_pfn_sb *pfn_sb;
@@ -50,10 +50,10 @@ struct dev_dax *__dax_pmem_probe(struct
 	if (rc !=3D 2)
 		return ERR_PTR(-EINVAL);
=20
-	/* adjust the dax_region resource to the start of data */
-	memcpy(&res, &pgmap.res, sizeof(res));
-	res.start +=3D offset;
-	dax_region =3D alloc_dax_region(dev, region_id, &res,
+	/* adjust the dax_region range to the start of data */
+	range =3D pgmap.range;
+	range.start +=3D offset,
+	dax_region =3D alloc_dax_region(dev, region_id, &range,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
 			IORESOURCE_DAX_STATIC);
 	if (!dax_region)
@@ -64,7 +64,7 @@ struct dev_dax *__dax_pmem_probe(struct
 		.id =3D id,
 		.pgmap =3D &pgmap,
 		.subsys =3D subsys,
-		.size =3D resource_size(&res),
+		.size =3D range_len(&range),
 	};
 	dev_dax =3D devm_create_dev_dax(&data);
=20
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-memremap_pages-convert-to-s=
truct-range
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -101,7 +101,7 @@ unsigned long nouveau_dmem_page_addr(str
 {
 	struct nouveau_dmem_chunk *chunk =3D nouveau_page_to_chunk(page);
 	unsigned long off =3D (page_to_pfn(page) << PAGE_SHIFT) -
-				chunk->pagemap.res.start;
+				chunk->pagemap.range.start;
=20
 	return chunk->bo->offset + off;
 }
@@ -249,7 +249,8 @@ nouveau_dmem_chunk_alloc(struct nouveau_
=20
 	chunk->drm =3D drm;
 	chunk->pagemap.type =3D MEMORY_DEVICE_PRIVATE;
-	chunk->pagemap.res =3D *res;
+	chunk->pagemap.range.start =3D res->start;
+	chunk->pagemap.range.end =3D res->end;
 	chunk->pagemap.ops =3D &nouveau_dmem_pagemap_ops;
 	chunk->pagemap.owner =3D drm->dev;
=20
@@ -273,7 +274,7 @@ nouveau_dmem_chunk_alloc(struct nouveau_
 	list_add(&chunk->list, &drm->dmem->chunks);
 	mutex_unlock(&drm->dmem->mutex);
=20
-	pfn_first =3D chunk->pagemap.res.start >> PAGE_SHIFT;
+	pfn_first =3D chunk->pagemap.range.start >> PAGE_SHIFT;
 	page =3D pfn_to_page(pfn_first);
 	spin_lock(&drm->dmem->lock);
 	for (i =3D 0; i < DMEM_CHUNK_NPAGES - 1; ++i, ++page) {
@@ -294,8 +295,7 @@ out_bo_unpin:
 out_bo_free:
 	nouveau_bo_ref(NULL, &chunk->bo);
 out_release:
-	release_mem_region(chunk->pagemap.res.start,
-			   resource_size(&chunk->pagemap.res));
+	release_mem_region(chunk->pagemap.range.start, range_len(&chunk->pagemap.=
range));
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
=20
--- a/drivers/nvdimm/badrange.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/badrange.c
@@ -211,7 +211,7 @@ static void __add_badblock_range(struct
 }
=20
 static void badblocks_populate(struct badrange *badrange,
-		struct badblocks *bb, const struct resource *res)
+		struct badblocks *bb, const struct range *range)
 {
 	struct badrange_entry *bre;
=20
@@ -222,34 +222,34 @@ static void badblocks_populate(struct ba
 		u64 bre_end =3D bre->start + bre->length - 1;
=20
 		/* Discard intervals with no intersection */
-		if (bre_end < res->start)
+		if (bre_end < range->start)
 			continue;
-		if (bre->start >  res->end)
+		if (bre->start > range->end)
 			continue;
 		/* Deal with any overlap after start of the namespace */
-		if (bre->start >=3D res->start) {
+		if (bre->start >=3D range->start) {
 			u64 start =3D bre->start;
 			u64 len;
=20
-			if (bre_end <=3D res->end)
+			if (bre_end <=3D range->end)
 				len =3D bre->length;
 			else
-				len =3D res->start + resource_size(res)
+				len =3D range->start + range_len(range)
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
=20
-			if (bre_end < res->end)
-				len =3D bre->start + bre->length - res->start;
+			if (bre_end < range->end)
+				len =3D bre->start + bre->length - range->start;
 			else
-				len =3D resource_size(res);
+				len =3D range_len(range);
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
=20
@@ -279,7 +279,7 @@ void nvdimm_badblocks_populate(struct nd
 	nvdimm_bus =3D walk_to_nvdimm_bus(&nd_region->dev);
=20
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
-	struct resource *res =3D &nsio->res;
 	struct nd_namespace_common *ndns =3D &nsio->common;
+	struct range range =3D {
+		.start =3D nsio->res.start,
+		.end =3D nsio->res.end,
+	};
=20
 	nsio->size =3D size;
-	if (!devm_request_mem_region(dev, res->start, size,
+	if (!devm_request_mem_region(dev, range.start, size,
 				dev_name(&ndns->dev))) {
-		dev_warn(dev, "could not reserve region %pR\n", res);
+		dev_warn(dev, "could not reserve region %pR\n", &nsio->res);
 		return -EBUSY;
 	}
=20
@@ -317,9 +320,9 @@ int devm_nsio_enable(struct device *dev,
 	if (devm_init_badblocks(dev, &nsio->bb))
 		return -ENOMEM;
 	nvdimm_badblocks_populate(to_nd_region(ndns->dev.parent), &nsio->bb,
-			&nsio->res);
+			&range);
=20
-	nsio->addr =3D devm_memremap(dev, res->start, size, ARCH_MEMREMAP_PMEM);
+	nsio->addr =3D devm_memremap(dev, range.start, size, ARCH_MEMREMAP_PMEM);
=20
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
 int devm_namespace_enable(struct device *dev, struct nd_namespace_common *=
ndns,
 		resource_size_t size);
 void devm_namespace_disable(struct device *dev,
--- a/drivers/nvdimm/pfn_devs.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/pfn_devs.c
@@ -672,7 +672,7 @@ static unsigned long init_altmap_reserve
=20
 static int __nvdimm_setup_pfn(struct nd_pfn *nd_pfn, struct dev_pagemap *p=
gmap)
 {
-	struct resource *res =3D &pgmap->res;
+	struct range *range =3D &pgmap->range;
 	struct vmem_altmap *altmap =3D &pgmap->altmap;
 	struct nd_pfn_sb *pfn_sb =3D nd_pfn->pfn_sb;
 	u64 offset =3D le64_to_cpu(pfn_sb->dataoff);
@@ -689,16 +689,16 @@ static int __nvdimm_setup_pfn(struct nd_
 		.end_pfn =3D PHYS_PFN(end),
 	};
=20
-	memcpy(res, &nsio->res, sizeof(*res));
-	res->start +=3D start_pad;
-	res->end -=3D end_trunc;
-
+	*range =3D (struct range) {
+		.start =3D nsio->res.start + start_pad,
+		.end =3D nsio->res.end - end_trunc,
+	};
 	if (nd_pfn->mode =3D=3D PFN_MODE_RAM) {
 		if (offset < reserve)
 			return -EINVAL;
 		nd_pfn->npfns =3D le64_to_cpu(pfn_sb->npfns);
 	} else if (nd_pfn->mode =3D=3D PFN_MODE_PMEM) {
-		nd_pfn->npfns =3D PHYS_PFN((resource_size(res) - offset));
+		nd_pfn->npfns =3D PHYS_PFN((range_len(range) - offset));
 		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
 			dev_info(&nd_pfn->dev,
 					"number of pfns truncated from %lld to %ld\n",
--- a/drivers/nvdimm/pmem.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/pmem.c
@@ -375,7 +375,7 @@ static int pmem_attach_disk(struct devic
 	struct nd_region *nd_region =3D to_nd_region(dev->parent);
 	int nid =3D dev_to_node(dev), fua;
 	struct resource *res =3D &nsio->res;
-	struct resource bb_res;
+	struct range bb_range;
 	struct nd_pfn *nd_pfn =3D NULL;
 	struct dax_device *dax_dev;
 	struct nd_pfn_sb *pfn_sb;
@@ -434,24 +434,26 @@ static int pmem_attach_disk(struct devic
 		pfn_sb =3D nd_pfn->pfn_sb;
 		pmem->data_offset =3D le64_to_cpu(pfn_sb->dataoff);
 		pmem->pfn_pad =3D resource_size(res) -
-			resource_size(&pmem->pgmap.res);
+			range_len(&pmem->pgmap.range);
 		pmem->pfn_flags |=3D PFN_MAP;
-		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
-		bb_res.start +=3D pmem->data_offset;
+		bb_range =3D pmem->pgmap.range;
+		bb_range.start +=3D pmem->data_offset;
 	} else if (pmem_should_map_pages(dev)) {
-		memcpy(&pmem->pgmap.res, &nsio->res, sizeof(pmem->pgmap.res));
+		pmem->pgmap.range.start =3D res->start;
+		pmem->pgmap.range.end =3D res->end;
 		pmem->pgmap.type =3D MEMORY_DEVICE_FS_DAX;
 		pmem->pgmap.ops =3D &fsdax_pagemap_ops;
 		addr =3D devm_memremap_pages(dev, &pmem->pgmap);
 		pmem->pfn_flags |=3D PFN_MAP;
-		memcpy(&bb_res, &pmem->pgmap.res, sizeof(bb_res));
+		bb_range =3D pmem->pgmap.range;
 	} else {
 		if (devm_add_action_or_reset(dev, pmem_release_queue,
 					&pmem->pgmap))
 			return -ENOMEM;
 		addr =3D devm_memremap(dev, pmem->phys_addr,
 				pmem->size, ARCH_MEMREMAP_PMEM);
-		memcpy(&bb_res, &nsio->res, sizeof(bb_res));
+		bb_range.start =3D  res->start;
+		bb_range.end =3D res->end;
 	}
=20
 	if (IS_ERR(addr))
@@ -480,7 +482,7 @@ static int pmem_attach_disk(struct devic
 			/ 512);
 	if (devm_init_badblocks(dev, &pmem->bb))
 		return -ENOMEM;
-	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_res);
+	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
 	disk->bb =3D &pmem->bb;
=20
 	if (is_nvdimm_sync(nd_region))
@@ -591,8 +593,8 @@ static void nd_pmem_notify(struct device
 	resource_size_t offset =3D 0, end_trunc =3D 0;
 	struct nd_namespace_common *ndns;
 	struct nd_namespace_io *nsio;
-	struct resource res;
 	struct badblocks *bb;
+	struct range range;
 	struct kernfs_node *bb_state;
=20
 	if (event !=3D NVDIMM_REVALIDATE_POISON)
@@ -628,9 +630,9 @@ static void nd_pmem_notify(struct device
 		nsio =3D to_nd_namespace_io(&ndns->dev);
 	}
=20
-	res.start =3D nsio->res.start + offset;
-	res.end =3D nsio->res.end - end_trunc;
-	nvdimm_badblocks_populate(nd_region, bb, &res);
+	range.start =3D nsio->res.start + offset;
+	range.end =3D nsio->res.end - end_trunc;
+	nvdimm_badblocks_populate(nd_region, bb, &range);
 	if (bb_state)
 		sysfs_notify_dirent(bb_state);
 }
--- a/drivers/nvdimm/region.c~mm-memremap_pages-convert-to-struct-range
+++ a/drivers/nvdimm/region.c
@@ -35,7 +35,10 @@ static int nd_region_probe(struct device
 		return rc;
=20
 	if (is_memory(&nd_region->dev)) {
-		struct resource ndr_res;
+		struct range range =3D {
+			.start =3D nd_region->ndr_start,
+			.end =3D nd_region->ndr_start + nd_region->ndr_size - 1,
+		};
=20
 		if (devm_init_badblocks(dev, &nd_region->bb))
 			return -ENODEV;
@@ -44,9 +47,7 @@ static int nd_region_probe(struct device
 		if (!nd_region->bb_state)
 			dev_warn(&nd_region->dev,
 					"'badblocks' notification disabled\n");
-		ndr_res.start =3D nd_region->ndr_start;
-		ndr_res.end =3D nd_region->ndr_start + nd_region->ndr_size - 1;
-		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &ndr_res);
+		nvdimm_badblocks_populate(nd_region, &nd_region->bb, &range);
 	}
=20
 	rc =3D nd_region_register_namespaces(nd_region, &err);
@@ -121,14 +122,16 @@ static void nd_region_notify(struct devi
 {
 	if (event =3D=3D NVDIMM_REVALIDATE_POISON) {
 		struct nd_region *nd_region =3D to_nd_region(dev);
-		struct resource res;
=20
 		if (is_memory(&nd_region->dev)) {
-			res.start =3D nd_region->ndr_start;
-			res.end =3D nd_region->ndr_start +
-				nd_region->ndr_size - 1;
+			struct range range =3D {
+				.start =3D nd_region->ndr_start,
+				.end =3D nd_region->ndr_start +
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
=20
 	pgmap =3D &p2p_pgmap->pgmap;
-	pgmap->res.start =3D pci_resource_start(pdev, bar) + offset;
-	pgmap->res.end =3D pgmap->res.start + size - 1;
-	pgmap->res.flags =3D pci_resource_flags(pdev, bar);
+	pgmap->range.start =3D pci_resource_start(pdev, bar) + offset;
+	pgmap->range.end =3D pgmap->range.start + size - 1;
 	pgmap->type =3D MEMORY_DEVICE_PCI_P2PDMA;
=20
 	p2p_pgmap->provider =3D pdev;
@@ -202,13 +201,13 @@ int pci_p2pdma_add_resource(struct pci_d
=20
 	error =3D gen_pool_add_owner(pdev->p2pdma->pool, (unsigned long)addr,
 			pci_bus_address(pdev, bar) + offset,
-			resource_size(&pgmap->res), dev_to_node(&pdev->dev),
+			range_len(&pgmap->range), dev_to_node(&pdev->dev),
 			pgmap->ref);
 	if (error)
 		goto pages_free;
=20
-	pci_info(pdev, "added peer-to-peer DMA memory %pR\n",
-		 &pgmap->res);
+	pci_info(pdev, "added peer-to-peer DMA memory %#llx-%#llx\n",
+		 pgmap->range.start, pgmap->range.end);
=20
 	return 0;
=20
--- a/drivers/xen/unpopulated-alloc.c~mm-memremap_pages-convert-to-struct-r=
ange
+++ a/drivers/xen/unpopulated-alloc.c
@@ -18,27 +18,37 @@ static unsigned int list_count;
 static int fill_list(unsigned int nr_pages)
 {
 	struct dev_pagemap *pgmap;
+	struct resource *res;
 	void *vaddr;
 	unsigned int i, alloc_pages =3D round_up(nr_pages, PAGES_PER_SECTION);
-	int ret;
+	int ret =3D -ENOMEM;
+
+	res =3D kzalloc(sizeof(*res), GFP_KERNEL);
+	if (!res)
+		return -ENOMEM;
=20
 	pgmap =3D kzalloc(sizeof(*pgmap), GFP_KERNEL);
 	if (!pgmap)
-		return -ENOMEM;
+		goto err_pgmap;
=20
 	pgmap->type =3D MEMORY_DEVICE_GENERIC;
-	pgmap->res.name =3D "Xen scratch";
-	pgmap->res.flags =3D IORESOURCE_MEM | IORESOURCE_BUSY;
+	res->name =3D "Xen scratch";
+	res->flags =3D IORESOURCE_MEM | IORESOURCE_BUSY;
=20
-	ret =3D allocate_resource(&iomem_resource, &pgmap->res,
+	ret =3D allocate_resource(&iomem_resource, res,
 				alloc_pages * PAGE_SIZE, 0, -1,
 				PAGES_PER_SECTION * PAGE_SIZE, NULL, NULL);
 	if (ret < 0) {
 		pr_err("Cannot allocate new IOMEM resource\n");
-		kfree(pgmap);
-		return ret;
+		goto err_resource;
 	}
=20
+	pgmap->range =3D (struct range) {
+		.start =3D res->start,
+		.end =3D res->end,
+	};
+	pgmap->owner =3D res;
+
 #ifdef CONFIG_XEN_HAVE_PVMMU
         /*
          * memremap will build page tables for the new memory so
@@ -50,14 +60,13 @@ static int fill_list(unsigned int nr_pag
          * conflict with any devices.
          */
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-		xen_pfn_t pfn =3D PFN_DOWN(pgmap->res.start);
+		xen_pfn_t pfn =3D PFN_DOWN(res->start);
=20
 		for (i =3D 0; i < alloc_pages; i++) {
 			if (!set_phys_to_machine(pfn + i, INVALID_P2M_ENTRY)) {
 				pr_warn("set_phys_to_machine() failed, no memory added\n");
-				release_resource(&pgmap->res);
-				kfree(pgmap);
-				return -ENOMEM;
+				ret =3D -ENOMEM;
+				goto err_memremap;
 			}
                 }
 	}
@@ -66,9 +75,8 @@ static int fill_list(unsigned int nr_pag
 	vaddr =3D memremap_pages(pgmap, NUMA_NO_NODE);
 	if (IS_ERR(vaddr)) {
 		pr_err("Cannot remap memory range\n");
-		release_resource(&pgmap->res);
-		kfree(pgmap);
-		return PTR_ERR(vaddr);
+		ret =3D PTR_ERR(vaddr);
+		goto err_memremap;
 	}
=20
 	for (i =3D 0; i < alloc_pages; i++) {
@@ -80,6 +88,14 @@ static int fill_list(unsigned int nr_pag
 	}
=20
 	return 0;
+
+err_memremap:
+	release_resource(res);
+err_resource:
+	kfree(pgmap);
+err_pgmap:
+	kfree(res);
+	return ret;
 }
=20
 /**
--- a/include/linux/memremap.h~mm-memremap_pages-convert-to-struct-range
+++ a/include/linux/memremap.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _LINUX_MEMREMAP_H_
 #define _LINUX_MEMREMAP_H_
+#include <linux/range.h>
 #include <linux/ioport.h>
 #include <linux/percpu-refcount.h>
=20
@@ -93,7 +94,7 @@ struct dev_pagemap_ops {
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
- * @res: physical address range covered by @ref
+ * @range: physical address range covered by @ref
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @internal_ref: internal reference if @ref is not provided by the caller
  * @done: completion for @internal_ref
@@ -106,7 +107,7 @@ struct dev_pagemap_ops {
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
=20
 struct range {
 	u64   start;
 	u64   end;
 };
=20
+static inline u64 range_len(const struct range *range)
+{
+	return range->end - range->start + 1;
+}
+
 int add_range(struct range *range, int az, int nr_range,
 		u64 start, u64 end);
=20
--- a/lib/test_hmm.c~mm-memremap_pages-convert-to-struct-range
+++ a/lib/test_hmm.c
@@ -460,6 +460,21 @@ static bool dmirror_allocate_chunk(struc
 	unsigned long pfn_last;
 	void *ptr;
=20
+	devmem =3D kzalloc(sizeof(*devmem), GFP_KERNEL);
+	if (!devmem)
+		return -ENOMEM;
+
+	res =3D request_free_mem_region(&iomem_resource, DEVMEM_CHUNK_SIZE,
+				      "hmm_dmirror");
+	if (IS_ERR(res))
+		goto err_devmem;
+
+	devmem->pagemap.type =3D MEMORY_DEVICE_PRIVATE;
+	devmem->pagemap.range.start =3D res->start;
+	devmem->pagemap.range.end =3D res->end;
+	devmem->pagemap.ops =3D &dmirror_devmem_ops;
+	devmem->pagemap.owner =3D mdevice;
+
 	mutex_lock(&mdevice->devmem_lock);
=20
 	if (mdevice->devmem_count =3D=3D mdevice->devmem_capacity) {
@@ -472,33 +487,18 @@ static bool dmirror_allocate_chunk(struc
 				sizeof(new_chunks[0]) * new_capacity,
 				GFP_KERNEL);
 		if (!new_chunks)
-			goto err;
+			goto err_release;
 		mdevice->devmem_capacity =3D new_capacity;
 		mdevice->devmem_chunks =3D new_chunks;
 	}
=20
-	res =3D request_free_mem_region(&iomem_resource, DEVMEM_CHUNK_SIZE,
-					"hmm_dmirror");
-	if (IS_ERR(res))
-		goto err;
-
-	devmem =3D kzalloc(sizeof(*devmem), GFP_KERNEL);
-	if (!devmem)
-		goto err_release;
-
-	devmem->pagemap.type =3D MEMORY_DEVICE_PRIVATE;
-	devmem->pagemap.res =3D *res;
-	devmem->pagemap.ops =3D &dmirror_devmem_ops;
-	devmem->pagemap.owner =3D mdevice;
-
 	ptr =3D memremap_pages(&devmem->pagemap, numa_node_id());
 	if (IS_ERR(ptr))
-		goto err_free;
+		goto err_release;
=20
 	devmem->mdevice =3D mdevice;
-	pfn_first =3D devmem->pagemap.res.start >> PAGE_SHIFT;
-	pfn_last =3D pfn_first +
-		(resource_size(&devmem->pagemap.res) >> PAGE_SHIFT);
+	pfn_first =3D devmem->pagemap.range.start >> PAGE_SHIFT;
+	pfn_last =3D pfn_first + (range_len(&devmem->pagemap.range) >> PAGE_SHIFT=
);
 	mdevice->devmem_chunks[mdevice->devmem_count++] =3D devmem;
=20
 	mutex_unlock(&mdevice->devmem_lock);
@@ -525,12 +525,12 @@ static bool dmirror_allocate_chunk(struc
=20
 	return true;
=20
-err_free:
-	kfree(devmem);
 err_release:
-	release_mem_region(res->start, resource_size(res));
-err:
 	mutex_unlock(&mdevice->devmem_lock);
+	release_mem_region(devmem->pagemap.range.start, range_len(&devmem->pagema=
p.range));
+err_devmem:
+	kfree(devmem);
+
 	return false;
 }
=20
@@ -1100,8 +1100,8 @@ static void dmirror_device_remove(struct
 				mdevice->devmem_chunks[i];
=20
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
=20
-static void pgmap_array_delete(struct resource *res)
+static void pgmap_array_delete(struct range *range)
 {
-	xa_store_range(&pgmap_array, PHYS_PFN(res->start), PHYS_PFN(res->end),
+	xa_store_range(&pgmap_array, PHYS_PFN(range->start), PHYS_PFN(range->end),
 			NULL, GFP_KERNEL);
 	synchronize_rcu();
 }
=20
 static unsigned long pfn_first(struct dev_pagemap *pgmap)
 {
-	return PHYS_PFN(pgmap->res.start) +
+	return PHYS_PFN(pgmap->range.start) +
 		vmem_altmap_offset(pgmap_altmap(pgmap));
 }
=20
 static unsigned long pfn_end(struct dev_pagemap *pgmap)
 {
-	const struct resource *res =3D &pgmap->res;
+	const struct range *range =3D &pgmap->range;
=20
-	return (res->start + resource_size(res)) >> PAGE_SHIFT;
+	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
=20
 static unsigned long pfn_next(unsigned long pfn)
@@ -126,7 +126,7 @@ static void dev_pagemap_cleanup(struct d
=20
 void memunmap_pages(struct dev_pagemap *pgmap)
 {
-	struct resource *res =3D &pgmap->res;
+	struct range *range =3D &pgmap->range;
 	struct page *first_page;
 	unsigned long pfn;
 	int nid;
@@ -143,20 +143,20 @@ void memunmap_pages(struct dev_pagemap *
 	nid =3D page_to_nid(first_page);
=20
 	mem_hotplug_begin();
-	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(res->start),
-				   PHYS_PFN(resource_size(res)));
+	remove_pfn_range_from_zone(page_zone(first_page), PHYS_PFN(range->start),
+				   PHYS_PFN(range_len(range)));
 	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE) {
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
=20
-	untrack_pfn(NULL, PHYS_PFN(res->start), resource_size(res));
-	pgmap_array_delete(res);
+	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range));
+	pgmap_array_delete(range);
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
 	devmap_managed_enable_put();
 }
@@ -182,7 +182,7 @@ static void dev_pagemap_percpu_release(s
  */
 void *memremap_pages(struct dev_pagemap *pgmap, int nid)
 {
-	struct resource *res =3D &pgmap->res;
+	struct range *range =3D &pgmap->range;
 	struct dev_pagemap *conflict_pgmap;
 	struct mhp_params params =3D {
 		/*
@@ -251,7 +251,7 @@ void *memremap_pages(struct dev_pagemap
 			return ERR_PTR(error);
 	}
=20
-	conflict_pgmap =3D get_dev_pagemap(PHYS_PFN(res->start), NULL);
+	conflict_pgmap =3D get_dev_pagemap(PHYS_PFN(range->start), NULL);
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
@@ -259,7 +259,7 @@ void *memremap_pages(struct dev_pagemap
 		goto err_array;
 	}
=20
-	conflict_pgmap =3D get_dev_pagemap(PHYS_PFN(res->end), NULL);
+	conflict_pgmap =3D get_dev_pagemap(PHYS_PFN(range->end), NULL);
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
@@ -267,26 +267,27 @@ void *memremap_pages(struct dev_pagemap
 		goto err_array;
 	}
=20
-	is_ram =3D region_intersects(res->start, resource_size(res),
+	is_ram =3D region_intersects(range->start, range_len(range),
 		IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
=20
 	if (is_ram !=3D REGION_DISJOINT) {
-		WARN_ONCE(1, "%s attempted on %s region %pr\n", __func__,
-				is_ram =3D=3D REGION_MIXED ? "mixed" : "ram", res);
+		WARN_ONCE(1, "attempted on %s region %#llx-%#llx\n",
+				is_ram =3D=3D REGION_MIXED ? "mixed" : "ram",
+				range->start, range->end);
 		error =3D -ENXIO;
 		goto err_array;
 	}
=20
-	error =3D xa_err(xa_store_range(&pgmap_array, PHYS_PFN(res->start),
-				PHYS_PFN(res->end), pgmap, GFP_KERNEL));
+	error =3D xa_err(xa_store_range(&pgmap_array, PHYS_PFN(range->start),
+				PHYS_PFN(range->end), pgmap, GFP_KERNEL));
 	if (error)
 		goto err_array;
=20
 	if (nid < 0)
 		nid =3D numa_mem_id();
=20
-	error =3D track_pfn_remap(NULL, &params.pgprot, PHYS_PFN(res->start),
-				0, resource_size(res));
+	error =3D track_pfn_remap(NULL, &params.pgprot, PHYS_PFN(range->start), 0,
+			range_len(range));
 	if (error)
 		goto err_pfn_remap;
=20
@@ -304,16 +305,16 @@ void *memremap_pages(struct dev_pagemap
 	 * arch_add_memory().
 	 */
 	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE) {
-		error =3D add_pages(nid, PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), &params);
+		error =3D add_pages(nid, PHYS_PFN(range->start),
+				PHYS_PFN(range_len(range)), &params);
 	} else {
-		error =3D kasan_add_zero_shadow(__va(res->start), resource_size(res));
+		error =3D kasan_add_zero_shadow(__va(range->start), range_len(range));
 		if (error) {
 			mem_hotplug_done();
 			goto err_kasan;
 		}
=20
-		error =3D arch_add_memory(nid, res->start, resource_size(res),
+		error =3D arch_add_memory(nid, range->start, range_len(range),
 					&params);
 	}
=20
@@ -321,8 +322,8 @@ void *memremap_pages(struct dev_pagemap
 		struct zone *zone;
=20
 		zone =3D &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
-		move_pfn_range_to_zone(zone, PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), params.altmap);
+		move_pfn_range_to_zone(zone, PHYS_PFN(range->start),
+				PHYS_PFN(range_len(range)), params.altmap);
 	}
=20
 	mem_hotplug_done();
@@ -334,17 +335,17 @@ void *memremap_pages(struct dev_pagemap
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
=20
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
@@ -369,7 +370,7 @@ EXPORT_SYMBOL_GPL(memremap_pages);
  *    'live' on entry and will be killed and reaped at
  *    devm_memremap_pages_release() time, or if this routine fails.
  *
- * 4/ res is expected to be a host memory range that could feasibly be
+ * 4/ range is expected to be a host memory range that could feasibly be
  *    treated as a "System RAM" range, i.e. not a device mmio range, but
  *    this is not enforced.
  */
@@ -426,7 +427,7 @@ struct dev_pagemap *get_dev_pagemap(unsi
 	 * In the cached case we're already holding a live reference.
 	 */
 	if (pgmap) {
-		if (phys >=3D pgmap->res.start && phys <=3D pgmap->res.end)
+		if (phys >=3D pgmap->range.start && phys <=3D pgmap->range.end)
 			return pgmap;
 		put_dev_pagemap(pgmap);
 	}
--- a/tools/testing/nvdimm/test/iomap.c~mm-memremap_pages-convert-to-struct=
-range
+++ a/tools/testing/nvdimm/test/iomap.c
@@ -126,7 +126,7 @@ static void dev_pagemap_percpu_release(s
 void *__wrap_devm_memremap_pages(struct device *dev, struct dev_pagemap *p=
gmap)
 {
 	int error;
-	resource_size_t offset =3D pgmap->res.start;
+	resource_size_t offset =3D pgmap->range.start;
 	struct nfit_test_resource *nfit_res =3D get_nfit_res(offset);
=20
 	if (!nfit_res)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


