Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF4C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34FE321741
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087126;
	bh=dhr6UKZ48O9Q+lf0mIgp5eNfxFVNn4LMPK0cx14XBio=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Gb1iRK/J5Bz9/TZWkM1aDmCZ8BiOAqutq8DAjvGBK1z7gDiUm1v/O6f2mziV5kTre
	 h0c4HLAfd+wNX4nMcb3lKn70X3beE9tPKgbuccqHqHeGzqvxrwok1VI2aNj3MmaRIf
	 qLSsmx0qZhELR0hTE0PuaKbg46jRefm11qb80wgs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgIZCZZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgIZCZZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:25 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C53D2087D;
        Sat, 26 Sep 2020 02:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087123;
        bh=dhr6UKZ48O9Q+lf0mIgp5eNfxFVNn4LMPK0cx14XBio=;
        h=Date:From:To:Subject:From;
        b=vDmj65hzkfIkR1qnJF16t68+tj/69ys0Koxv5z1+YMHraYtlPkk1hJHtH9dfIOy/Z
         pWC3c57tQckhswZPRISIGJOFXEKGEvcghHiuaBg1KmTVKHFJJe02/gbco2BAIFvQeE
         Xn3jgCeaU16s50yghoELqypsQ53zr77h283AlkBs=
Date:   Fri, 25 Sep 2020 19:25:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, yanaijie@huawei.com, will@kernel.org,
        vishal.l.verma@intel.com, vgoyal@redhat.com,
        thomas.lendacky@amd.com, tglx@linutronix.de,
        sstabellini@kernel.org, rppt@linux.ibm.com,
        richard.weiyang@linux.alibaba.com, rdunlap@infradead.org,
        rafael.j.wysocki@intel.com, peterz@infradead.org,
        paulus@ozlabs.org, pasha.tatashin@soleen.com, mpe@ellerman.id.au,
        mingo@redhat.com, luto@kernel.org, lkp@intel.com,
        justin.he@arm.com, Jonathan.Cameron@huawei.com,
        joao.m.martins@oracle.com, jmoyer@redhat.com, jgross@suse.com,
        jglisse@redhat.com, jglisse@redhat.co, jgg@mellanox.com,
        ira.weiny@intel.com, hulkci@huawei.com, hpa@zytor.com,
        gregkh@linuxfoundation.org, david@redhat.com, dave.jiang@intel.com,
        dave.hansen@linux.intel.com, daniel@ffwll.ch,
        catalin.marinas@arm.com, bskeggs@redhat.com, Brice.Goglin@inria.fr,
        bp@alien8.de, boris.ostrovsky@oracle.com, bhelgaas@google.com,
        benh@kernel.crashing.org, ardb@kernel.org,
        ard.biesheuvel@linaro.org, airlied@linux.ie,
        dan.j.williams@intel.com
Subject:  +
 mm-memremap_pages-support-multiple-ranges-per-invocation.patch added to -mm
 tree
Message-ID: <20200926022520.9EF06%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memremap_pages: support multiple ranges per invocation
has been added to the -mm tree.  Its filename is
     mm-memremap_pages-support-multiple-ranges-per-invocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memremap_pages-support-mul=
tiple-ranges-per-invocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memremap_pages-support-mul=
tiple-ranges-per-invocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
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
@@ -442,6 +442,7 @@ static int pmem_attach_disk(struct devic
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
@@ -489,6 +489,7 @@ static bool dmirror_allocate_chunk(struc
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
@@ -117,8 +121,8 @@ bool pfn_zone_device_reserved(unsigned l
 	return ret;
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
@@ -144,20 +148,14 @@ static void dev_pagemap_cleanup(struct d
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
@@ -177,6 +175,22 @@ void memunmap_pages(struct dev_pagemap *
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
@@ -195,96 +209,29 @@ static void dev_pagemap_percpu_release(s
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
@@ -294,19 +241,18 @@ void *memremap_pages(struct dev_pagemap
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
@@ -326,7 +272,7 @@ void *memremap_pages(struct dev_pagemap
 	 */
 	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE) {
 		error =3D add_pages(nid, PHYS_PFN(range->start),
-				PHYS_PFN(range_len(range)), &params);
+				PHYS_PFN(range_len(range)), params);
 	} else {
 		error =3D kasan_add_zero_shadow(__va(range->start), range_len(range));
 		if (error) {
@@ -335,7 +281,7 @@ void *memremap_pages(struct dev_pagemap
 		}
=20
 		error =3D arch_add_memory(nid, range->start, range_len(range),
-					&params);
+					params);
 	}
=20
 	if (!error) {
@@ -343,7 +289,7 @@ void *memremap_pages(struct dev_pagemap
=20
 		zone =3D &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 		move_pfn_range_to_zone(zone, PHYS_PFN(range->start),
-				PHYS_PFN(range_len(range)), params.altmap);
+				PHYS_PFN(range_len(range)), params->altmap);
 	}
=20
 	mem_hotplug_done();
@@ -357,20 +303,116 @@ void *memremap_pages(struct dev_pagemap
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
device-dax-kmem-introduce-dax_kmem_range.patch
device-dax-kmem-move-resource-name-tracking-to-drvdata.patch
device-dax-kmem-replace-release_resource-with-release_mem_region.patch
device-dax-add-an-allocation-interface-for-device-dax-instances.patch
device-dax-introduce-struct-dev_dax-typed-driver-operations.patch
device-dax-introduce-seed-devices.patch
drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inputs.pa=
tch
device-dax-add-resize-support.patch
mm-memremap_pages-convert-to-struct-range.patch
mm-memremap_pages-support-multiple-ranges-per-invocation.patch
device-dax-add-dis-contiguous-resource-support.patch
device-dax-introduce-mapping-devices.patch
device-dax-add-an-align-attribute.patch

