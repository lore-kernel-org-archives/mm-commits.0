Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBFA7C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ABC922258
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709096;
	bh=VEk9rSAE1RlTuOs+uXt6VWgiwx58cp80pMEK8JuN00o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ooLukOgkEZwIE/iCOCnQAL19Yc4ZsXyxaOtCf0UVb8uyYH4/1kFaExWX/vKM+tE90
	 qstQO0HBPxItdOJtekrWgLAPjL0xKTQy5riUAFAiwPiTlsZRTcZISQ6F6rOcnggvyF
	 48VvQpsA1x+TZEskX+zXdZVm0D/LP2LZtaqn+Dgk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgJNU6Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNU6P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE7720725;
        Wed, 14 Oct 2020 20:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709092;
        bh=VEk9rSAE1RlTuOs+uXt6VWgiwx58cp80pMEK8JuN00o=;
        h=Date:From:To:Subject:From;
        b=jta5eozGlDSTbGrjXpq8TLm/fRegCXDRUUfXUELEttF9VOXbSjqWcqks9g8svNLV/
         t6dnQRPjzzrq1A0+yHlMsJVLmKQ0zW5/sVuAz5bQU6jwpO2wI8bVx5/6wcxQifS7nY
         o0chrm2oWlSs5A1vUVqu121TtIWhzSX3hC+lQe0M=
Date:   Wed, 14 Oct 2020 13:58:10 -0700
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.co, jglisse@redhat.com, jgross@suse.com,
        jmoyer@redhat.com, joao.m.martins@oracle.com,
        Jonathan.Cameron@huawei.com, justin.he@arm.com, lkp@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, pasha.tatashin@soleen.com, paulus@ozlabs.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rdunlap@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@linux.ibm.com, sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, vgoyal@redhat.com,
        vishal.l.verma@intel.com, will@kernel.org, yanaijie@huawei.com
Subject:  [merged]
 mm-memremap_pages-support-multiple-ranges-per-invocation.patch removed from
 -mm tree
Message-ID: <20201014205810.VW49bm-iT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap_pages: support multiple ranges per invocation
has been removed from the -mm tree.  Its filename was
     mm-memremap_pages-support-multiple-ranges-per-invocation.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: mm/memremap_pages: support multiple ranges per invocation

In support of device-dax growing the ability to front physically
dis-contiguous ranges of memory, update devm_memremap_pages() to track
multiple ranges with a single reference counter and devm instance.

Convert all [devm_]memremap_pages() users to specify the number of ranges
they are mapping in their 'struct dev_pagemap' instance.

Link: https://lkml.kernel.org/r/159643103789.4062302.18426128170217903785.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106116293.30709.13350662794915396198.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.co
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
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
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

 arch/powerpc/kvm/book3s_hv_uvmem.c     |    1=20
 drivers/dax/device.c                   |    1=20
 drivers/gpu/drm/nouveau/nouveau_dmem.c |    1=20
 drivers/nvdimm/pfn_devs.c              |    1=20
 drivers/nvdimm/pmem.c                  |    1=20
 drivers/pci/p2pdma.c                   |    1=20
 drivers/xen/unpopulated-alloc.c        |    1=20
 include/linux/memremap.h               |   10=20
 lib/test_hmm.c                         |    1=20
 mm/memremap.c                          |  258 +++++++++++++----------
 10 files changed, 166 insertions(+), 110 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-memremap_pages-support-multiple=
-ranges-per-invocation
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -1172,6 +1172,7 @@ int kvmppc_uvmem_init(void)
 	kvmppc_uvmem_pgmap.type =3D MEMORY_DEVICE_PRIVATE;
 	kvmppc_uvmem_pgmap.range.start =3D res->start;
 	kvmppc_uvmem_pgmap.range.end =3D res->end;
+	kvmppc_uvmem_pgmap.nr_range =3D 1;
 	kvmppc_uvmem_pgmap.ops =3D &kvmppc_uvmem_ops;
 	/* just one global instance: */
 	kvmppc_uvmem_pgmap.owner =3D &kvmppc_uvmem_pgmap;
--- a/drivers/dax/device.c~mm-memremap_pages-support-multiple-ranges-per-in=
vocation
+++ a/drivers/dax/device.c
@@ -417,6 +417,7 @@ int dev_dax_probe(struct dev_dax *dev_da
 		if (!pgmap)
 			return -ENOMEM;
 		pgmap->range =3D *range;
+		pgmap->nr_range =3D 1;
 	}
 	pgmap->type =3D MEMORY_DEVICE_GENERIC;
 	addr =3D devm_memremap_pages(dev, pgmap);
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c~mm-memremap_pages-support-mult=
iple-ranges-per-invocation
+++ a/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -251,6 +251,7 @@ nouveau_dmem_chunk_alloc(struct nouveau_
 	chunk->pagemap.type =3D MEMORY_DEVICE_PRIVATE;
 	chunk->pagemap.range.start =3D res->start;
 	chunk->pagemap.range.end =3D res->end;
+	chunk->pagemap.nr_range =3D 1;
 	chunk->pagemap.ops =3D &nouveau_dmem_pagemap_ops;
 	chunk->pagemap.owner =3D drm->dev;
=20
--- a/drivers/nvdimm/pfn_devs.c~mm-memremap_pages-support-multiple-ranges-p=
er-invocation
+++ a/drivers/nvdimm/pfn_devs.c
@@ -693,6 +693,7 @@ static int __nvdimm_setup_pfn(struct nd_
 		.start =3D nsio->res.start + start_pad,
 		.end =3D nsio->res.end - end_trunc,
 	};
+	pgmap->nr_range =3D 1;
 	if (nd_pfn->mode =3D=3D PFN_MODE_RAM) {
 		if (offset < reserve)
 			return -EINVAL;
--- a/drivers/nvdimm/pmem.c~mm-memremap_pages-support-multiple-ranges-per-i=
nvocation
+++ a/drivers/nvdimm/pmem.c
@@ -441,6 +441,7 @@ static int pmem_attach_disk(struct devic
 	} else if (pmem_should_map_pages(dev)) {
 		pmem->pgmap.range.start =3D res->start;
 		pmem->pgmap.range.end =3D res->end;
+		pmem->pgmap.nr_range =3D 1;
 		pmem->pgmap.type =3D MEMORY_DEVICE_FS_DAX;
 		pmem->pgmap.ops =3D &fsdax_pagemap_ops;
 		addr =3D devm_memremap_pages(dev, &pmem->pgmap);
--- a/drivers/pci/p2pdma.c~mm-memremap_pages-support-multiple-ranges-per-in=
vocation
+++ a/drivers/pci/p2pdma.c
@@ -187,6 +187,7 @@ int pci_p2pdma_add_resource(struct pci_d
 	pgmap =3D &p2p_pgmap->pgmap;
 	pgmap->range.start =3D pci_resource_start(pdev, bar) + offset;
 	pgmap->range.end =3D pgmap->range.start + size - 1;
+	pgmap->nr_range =3D 1;
 	pgmap->type =3D MEMORY_DEVICE_PCI_P2PDMA;
=20
 	p2p_pgmap->provider =3D pdev;
--- a/drivers/xen/unpopulated-alloc.c~mm-memremap_pages-support-multiple-ra=
nges-per-invocation
+++ a/drivers/xen/unpopulated-alloc.c
@@ -47,6 +47,7 @@ static int fill_list(unsigned int nr_pag
 		.start =3D res->start,
 		.end =3D res->end,
 	};
+	pgmap->nr_range =3D 1;
 	pgmap->owner =3D res;
=20
 #ifdef CONFIG_XEN_HAVE_PVMMU
--- a/include/linux/memremap.h~mm-memremap_pages-support-multiple-ranges-pe=
r-invocation
+++ a/include/linux/memremap.h
@@ -94,7 +94,6 @@ struct dev_pagemap_ops {
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
- * @range: physical address range covered by @ref
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @internal_ref: internal reference if @ref is not provided by the caller
  * @done: completion for @internal_ref
@@ -104,10 +103,12 @@ struct dev_pagemap_ops {
  * @owner: an opaque pointer identifying the entity that manages this
  *	instance.  Used by various helpers to make sure that no
  *	foreign ZONE_DEVICE memory is accessed.
+ * @nr_range: number of ranges to be mapped
+ * @range: range to be mapped when nr_range =3D=3D 1
+ * @ranges: array of ranges to be mapped when nr_range > 1
  */
 struct dev_pagemap {
 	struct vmem_altmap altmap;
-	struct range range;
 	struct percpu_ref *ref;
 	struct percpu_ref internal_ref;
 	struct completion done;
@@ -115,6 +116,11 @@ struct dev_pagemap {
 	unsigned int flags;
 	const struct dev_pagemap_ops *ops;
 	void *owner;
+	int nr_range;
+	union {
+		struct range range;
+		struct range ranges[0];
+	};
 };
=20
 static inline struct vmem_altmap *pgmap_altmap(struct dev_pagemap *pgmap)
--- a/lib/test_hmm.c~mm-memremap_pages-support-multiple-ranges-per-invocati=
on
+++ a/lib/test_hmm.c
@@ -472,6 +472,7 @@ static bool dmirror_allocate_chunk(struc
 	devmem->pagemap.type =3D MEMORY_DEVICE_PRIVATE;
 	devmem->pagemap.range.start =3D res->start;
 	devmem->pagemap.range.end =3D res->end;
+	devmem->pagemap.nr_range =3D 1;
 	devmem->pagemap.ops =3D &dmirror_devmem_ops;
 	devmem->pagemap.owner =3D mdevice;
=20
--- a/mm/memremap.c~mm-memremap_pages-support-multiple-ranges-per-invocation
+++ a/mm/memremap.c
@@ -77,15 +77,19 @@ static void pgmap_array_delete(struct ra
 	synchronize_rcu();
 }
=20
-static unsigned long pfn_first(struct dev_pagemap *pgmap)
+static unsigned long pfn_first(struct dev_pagemap *pgmap, int range_id)
 {
-	return PHYS_PFN(pgmap->range.start) +
-		vmem_altmap_offset(pgmap_altmap(pgmap));
+	struct range *range =3D &pgmap->ranges[range_id];
+	unsigned long pfn =3D PHYS_PFN(range->start);
+
+	if (range_id)
+		return pfn;
+	return pfn + vmem_altmap_offset(pgmap_altmap(pgmap));
 }
=20
-static unsigned long pfn_end(struct dev_pagemap *pgmap)
+static unsigned long pfn_end(struct dev_pagemap *pgmap, int range_id)
 {
-	const struct range *range =3D &pgmap->range;
+	const struct range *range =3D &pgmap->ranges[range_id];
=20
 	return (range->start + range_len(range)) >> PAGE_SHIFT;
 }
@@ -97,8 +101,8 @@ static unsigned long pfn_next(unsigned l
 	return pfn + 1;
 }
=20
-#define for_each_device_pfn(pfn, map) \
-	for (pfn =3D pfn_first(map); pfn < pfn_end(map); pfn =3D pfn_next(pfn))
+#define for_each_device_pfn(pfn, map, i) \
+	for (pfn =3D pfn_first(map, i); pfn < pfn_end(map, i); pfn =3D pfn_next(p=
fn))
=20
 static void dev_pagemap_kill(struct dev_pagemap *pgmap)
 {
@@ -124,20 +128,14 @@ static void dev_pagemap_cleanup(struct d
 		pgmap->ref =3D NULL;
 }
=20
-void memunmap_pages(struct dev_pagemap *pgmap)
+static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 {
-	struct range *range =3D &pgmap->range;
+	struct range *range =3D &pgmap->ranges[range_id];
 	struct page *first_page;
-	unsigned long pfn;
 	int nid;
=20
-	dev_pagemap_kill(pgmap);
-	for_each_device_pfn(pfn, pgmap)
-		put_page(pfn_to_page(pfn));
-	dev_pagemap_cleanup(pgmap);
-
 	/* make sure to access a memmap that was actually initialized */
-	first_page =3D pfn_to_page(pfn_first(pgmap));
+	first_page =3D pfn_to_page(pfn_first(pgmap, range_id));
=20
 	/* pages are dead and unused, undo the arch mapping */
 	nid =3D page_to_nid(first_page);
@@ -157,6 +155,22 @@ void memunmap_pages(struct dev_pagemap *
=20
 	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range));
 	pgmap_array_delete(range);
+}
+
+void memunmap_pages(struct dev_pagemap *pgmap)
+{
+	unsigned long pfn;
+	int i;
+
+	dev_pagemap_kill(pgmap);
+	for (i =3D 0; i < pgmap->nr_range; i++)
+		for_each_device_pfn(pfn, pgmap, i)
+			put_page(pfn_to_page(pfn));
+	dev_pagemap_cleanup(pgmap);
+
+	for (i =3D 0; i < pgmap->nr_range; i++)
+		pageunmap_range(pgmap, i);
+
 	WARN_ONCE(pgmap->altmap.alloc, "failed to free all reserved pages\n");
 	devmap_managed_enable_put();
 }
@@ -175,96 +189,29 @@ static void dev_pagemap_percpu_release(s
 	complete(&pgmap->done);
 }
=20
-/*
- * Not device managed version of dev_memremap_pages, undone by
- * memunmap_pages().  Please use dev_memremap_pages if you have a struct
- * device available.
- */
-void *memremap_pages(struct dev_pagemap *pgmap, int nid)
+static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *par=
ams,
+		int range_id, int nid)
 {
-	struct range *range =3D &pgmap->range;
+	struct range *range =3D &pgmap->ranges[range_id];
 	struct dev_pagemap *conflict_pgmap;
-	struct mhp_params params =3D {
-		/*
-		 * We do not want any optional features only our own memmap
-		 */
-		.altmap =3D pgmap_altmap(pgmap),
-		.pgprot =3D PAGE_KERNEL,
-	};
 	int error, is_ram;
-	bool need_devmap_managed =3D true;
-
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_PRIVATE:
-		if (!IS_ENABLED(CONFIG_DEVICE_PRIVATE)) {
-			WARN(1, "Device private memory not supported\n");
-			return ERR_PTR(-EINVAL);
-		}
-		if (!pgmap->ops || !pgmap->ops->migrate_to_ram) {
-			WARN(1, "Missing migrate_to_ram method\n");
-			return ERR_PTR(-EINVAL);
-		}
-		if (!pgmap->owner) {
-			WARN(1, "Missing owner\n");
-			return ERR_PTR(-EINVAL);
-		}
-		break;
-	case MEMORY_DEVICE_FS_DAX:
-		if (!IS_ENABLED(CONFIG_ZONE_DEVICE) ||
-		    IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
-			WARN(1, "File system DAX not supported\n");
-			return ERR_PTR(-EINVAL);
-		}
-		break;
-	case MEMORY_DEVICE_GENERIC:
-		need_devmap_managed =3D false;
-		break;
-	case MEMORY_DEVICE_PCI_P2PDMA:
-		params.pgprot =3D pgprot_noncached(params.pgprot);
-		need_devmap_managed =3D false;
-		break;
-	default:
-		WARN(1, "Invalid pgmap type %d\n", pgmap->type);
-		break;
-	}
-
-	if (!pgmap->ref) {
-		if (pgmap->ops && (pgmap->ops->kill || pgmap->ops->cleanup))
-			return ERR_PTR(-EINVAL);
=20
-		init_completion(&pgmap->done);
-		error =3D percpu_ref_init(&pgmap->internal_ref,
-				dev_pagemap_percpu_release, 0, GFP_KERNEL);
-		if (error)
-			return ERR_PTR(error);
-		pgmap->ref =3D &pgmap->internal_ref;
-	} else {
-		if (!pgmap->ops || !pgmap->ops->kill || !pgmap->ops->cleanup) {
-			WARN(1, "Missing reference count teardown definition\n");
-			return ERR_PTR(-EINVAL);
-		}
-	}
-
-	if (need_devmap_managed) {
-		error =3D devmap_managed_enable_get(pgmap);
-		if (error)
-			return ERR_PTR(error);
-	}
+	if (WARN_ONCE(pgmap_altmap(pgmap) && range_id > 0,
+				"altmap not supported for multiple ranges\n"))
+		return -EINVAL;
=20
 	conflict_pgmap =3D get_dev_pagemap(PHYS_PFN(range->start), NULL);
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
-		error =3D -ENOMEM;
-		goto err_array;
+		return -ENOMEM;
 	}
=20
 	conflict_pgmap =3D get_dev_pagemap(PHYS_PFN(range->end), NULL);
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
-		error =3D -ENOMEM;
-		goto err_array;
+		return -ENOMEM;
 	}
=20
 	is_ram =3D region_intersects(range->start, range_len(range),
@@ -274,19 +221,18 @@ void *memremap_pages(struct dev_pagemap
 		WARN_ONCE(1, "attempted on %s region %#llx-%#llx\n",
 				is_ram =3D=3D REGION_MIXED ? "mixed" : "ram",
 				range->start, range->end);
-		error =3D -ENXIO;
-		goto err_array;
+		return -ENXIO;
 	}
=20
 	error =3D xa_err(xa_store_range(&pgmap_array, PHYS_PFN(range->start),
 				PHYS_PFN(range->end), pgmap, GFP_KERNEL));
 	if (error)
-		goto err_array;
+		return error;
=20
 	if (nid < 0)
 		nid =3D numa_mem_id();
=20
-	error =3D track_pfn_remap(NULL, &params.pgprot, PHYS_PFN(range->start), 0,
+	error =3D track_pfn_remap(NULL, &params->pgprot, PHYS_PFN(range->start), =
0,
 			range_len(range));
 	if (error)
 		goto err_pfn_remap;
@@ -306,7 +252,7 @@ void *memremap_pages(struct dev_pagemap
 	 */
 	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE) {
 		error =3D add_pages(nid, PHYS_PFN(range->start),
-				PHYS_PFN(range_len(range)), &params);
+				PHYS_PFN(range_len(range)), params);
 	} else {
 		error =3D kasan_add_zero_shadow(__va(range->start), range_len(range));
 		if (error) {
@@ -315,7 +261,7 @@ void *memremap_pages(struct dev_pagemap
 		}
=20
 		error =3D arch_add_memory(nid, range->start, range_len(range),
-					&params);
+					params);
 	}
=20
 	if (!error) {
@@ -323,7 +269,7 @@ void *memremap_pages(struct dev_pagemap
=20
 		zone =3D &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 		move_pfn_range_to_zone(zone, PHYS_PFN(range->start),
-				PHYS_PFN(range_len(range)), params.altmap);
+				PHYS_PFN(range_len(range)), params->altmap);
 	}
=20
 	mem_hotplug_done();
@@ -337,20 +283,116 @@ void *memremap_pages(struct dev_pagemap
 	memmap_init_zone_device(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 				PHYS_PFN(range->start),
 				PHYS_PFN(range_len(range)), pgmap);
-	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap) - pfn_first(pgmap));
-	return __va(range->start);
+	percpu_ref_get_many(pgmap->ref, pfn_end(pgmap, range_id)
+			- pfn_first(pgmap, range_id));
+	return 0;
=20
- err_add_memory:
+err_add_memory:
 	kasan_remove_zero_shadow(__va(range->start), range_len(range));
- err_kasan:
+err_kasan:
 	untrack_pfn(NULL, PHYS_PFN(range->start), range_len(range));
- err_pfn_remap:
+err_pfn_remap:
 	pgmap_array_delete(range);
- err_array:
-	dev_pagemap_kill(pgmap);
-	dev_pagemap_cleanup(pgmap);
-	devmap_managed_enable_put();
-	return ERR_PTR(error);
+	return error;
+}
+
+
+/*
+ * Not device managed version of dev_memremap_pages, undone by
+ * memunmap_pages().  Please use dev_memremap_pages if you have a struct
+ * device available.
+ */
+void *memremap_pages(struct dev_pagemap *pgmap, int nid)
+{
+	struct mhp_params params =3D {
+		.altmap =3D pgmap_altmap(pgmap),
+		.pgprot =3D PAGE_KERNEL,
+	};
+	const int nr_range =3D pgmap->nr_range;
+	bool need_devmap_managed =3D true;
+	int error, i;
+
+	if (WARN_ONCE(!nr_range, "nr_range must be specified\n"))
+		return ERR_PTR(-EINVAL);
+
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_PRIVATE:
+		if (!IS_ENABLED(CONFIG_DEVICE_PRIVATE)) {
+			WARN(1, "Device private memory not supported\n");
+			return ERR_PTR(-EINVAL);
+		}
+		if (!pgmap->ops || !pgmap->ops->migrate_to_ram) {
+			WARN(1, "Missing migrate_to_ram method\n");
+			return ERR_PTR(-EINVAL);
+		}
+		if (!pgmap->owner) {
+			WARN(1, "Missing owner\n");
+			return ERR_PTR(-EINVAL);
+		}
+		break;
+	case MEMORY_DEVICE_FS_DAX:
+		if (!IS_ENABLED(CONFIG_ZONE_DEVICE) ||
+		    IS_ENABLED(CONFIG_FS_DAX_LIMITED)) {
+			WARN(1, "File system DAX not supported\n");
+			return ERR_PTR(-EINVAL);
+		}
+		break;
+	case MEMORY_DEVICE_GENERIC:
+		need_devmap_managed =3D false;
+		break;
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		params.pgprot =3D pgprot_noncached(params.pgprot);
+		need_devmap_managed =3D false;
+		break;
+	default:
+		WARN(1, "Invalid pgmap type %d\n", pgmap->type);
+		break;
+	}
+
+	if (!pgmap->ref) {
+		if (pgmap->ops && (pgmap->ops->kill || pgmap->ops->cleanup))
+			return ERR_PTR(-EINVAL);
+
+		init_completion(&pgmap->done);
+		error =3D percpu_ref_init(&pgmap->internal_ref,
+				dev_pagemap_percpu_release, 0, GFP_KERNEL);
+		if (error)
+			return ERR_PTR(error);
+		pgmap->ref =3D &pgmap->internal_ref;
+	} else {
+		if (!pgmap->ops || !pgmap->ops->kill || !pgmap->ops->cleanup) {
+			WARN(1, "Missing reference count teardown definition\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	if (need_devmap_managed) {
+		error =3D devmap_managed_enable_get(pgmap);
+		if (error)
+			return ERR_PTR(error);
+	}
+
+	/*
+	 * Clear the pgmap nr_range as it will be incremented for each
+	 * successfully processed range. This communicates how many
+	 * regions to unwind in the abort case.
+	 */
+	pgmap->nr_range =3D 0;
+	error =3D 0;
+	for (i =3D 0; i < nr_range; i++) {
+		error =3D pagemap_range(pgmap, &params, i, nid);
+		if (error)
+			break;
+		pgmap->nr_range++;
+	}
+
+	if (i < nr_range) {
+		memunmap_pages(pgmap);
+		pgmap->nr_range =3D nr_range;
+		return ERR_PTR(error);
+	}
+
+	return __va(pgmap->ranges[0].start);
 }
 EXPORT_SYMBOL_GPL(memremap_pages);
=20
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


