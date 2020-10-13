Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B472DC41604
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 711452223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633014;
	bh=FdhLn1uXTqHBw0hZS1GMY8BiCqSZZgJ8sTyQtYfpJms=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wv8u2LGJLmasFmeeesyxP1oA578eDi7zW/pS9r2dSB1opx3QpvYaSWw9WxXU6zh/S
	 H14K7309cfr2lF7JxSlmJ6CpNVGh460zZ0NoYI+9LB7lOZVYMUPYdLNN3MwZoupQME
	 +uQ8zUifaZNLoJw+skCSJ7+PUTYmZPmpehBad5IQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730274AbgJMXuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgJMXts (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:49:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C789421D81;
        Tue, 13 Oct 2020 23:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632985;
        bh=FdhLn1uXTqHBw0hZS1GMY8BiCqSZZgJ8sTyQtYfpJms=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t8bXF+XY8lpI6WbG05f+LjoOhqQaeqmwCH7aDP2jRHap4tXAxXrQFyUCiGBOdRU2L
         OOsGIWDEoRYm47jWejZPmb2zUXiWlUk+UG7WPqhnQ7LsDEJ+700bOm2e8jhHftc1Ov
         DGrelKlNOAaqklaOGStE/2fDMqd3fkIpyk5QC5yU=
Date:   Tue, 13 Oct 2020 16:49:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org,
        ard.biesheuvel@linaro.org, ardb@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com,
        boris.ostrovsky@oracle.com, bp@alien8.de, Brice.Goglin@inria.fr,
        bskeggs@redhat.com, catalin.marinas@arm.com,
        dan.j.williams@intel.com, daniel@ffwll.ch,
        dave.hansen@linux.intel.com, dave.jiang@intel.com,
        david@redhat.com, gregkh@linuxfoundation.org, hpa@zytor.com,
        hulkci@huawei.com, ira.weiny@intel.com, jgg@mellanox.com,
        jglisse@redhat.com, jgross@suse.com, jmoyer@redhat.com,
        joao.m.martins@oracle.com, Jonathan.Cameron@huawei.com,
        justin.he@arm.com, linux-mm@kvack.org, lkp@intel.com,
        luto@kernel.org, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, pasha.tatashin@soleen.com, paulus@ozlabs.org,
        peterz@infradead.org, rafael.j.wysocki@intel.com,
        rdunlap@infradead.org, richard.weiyang@linux.alibaba.com,
        rppt@linux.ibm.com, sstabellini@kernel.org, tglx@linutronix.de,
        thomas.lendacky@amd.com, torvalds@linux-foundation.org,
        vgoyal@redhat.com, vishal.l.verma@intel.com, will@kernel.org,
        yanaijie@huawei.com
Subject:  [patch 035/181] device-dax: make pgmap optional for
 instance creation
Message-ID: <20201013234943.ze0jGQtJn%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

=46rom: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: make pgmap optional for instance creation

The passed in dev_pagemap is only required in the pmem case as the
libnvdimm core may have reserved a vmem_altmap for dev_memremap_pages() to
place the memmap in pmem directly.  In the hmem case there is no agent
reserving an altmap so it can all be handled by a core internal default.

Pass the resource range via a new @range property of 'struct
dev_dax_data'.

Link: https://lkml.kernel.org/r/159643099958.4062302.10379230791041872886.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106110513.30709.4303239334850606031.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c              |   29 +++++++++++++++--------------
 drivers/dax/bus.h              |    2 ++
 drivers/dax/dax-private.h      |    9 ++++++++-
 drivers/dax/device.c           |   28 +++++++++++++++++++---------
 drivers/dax/hmem/hmem.c        |    8 ++++----
 drivers/dax/kmem.c             |   12 ++++++------
 drivers/dax/pmem/core.c        |    4 ++++
 tools/testing/nvdimm/dax-dev.c |    8 ++++----
 8 files changed, 62 insertions(+), 38 deletions(-)

--- a/drivers/dax/bus.c~device-dax-make-pgmap-optional-for-instance-creation
+++ a/drivers/dax/bus.c
@@ -271,7 +271,7 @@ static ssize_t size_show(struct device *
 		struct device_attribute *attr, char *buf)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
-	unsigned long long size =3D resource_size(&dev_dax->region->res);
+	unsigned long long size =3D range_len(&dev_dax->range);
=20
 	return sprintf(buf, "%llu\n", size);
 }
@@ -293,19 +293,12 @@ static ssize_t target_node_show(struct d
 }
 static DEVICE_ATTR_RO(target_node);
=20
-static unsigned long long dev_dax_resource(struct dev_dax *dev_dax)
-{
-	struct dax_region *dax_region =3D dev_dax->region;
-
-	return dax_region->res.start;
-}
-
 static ssize_t resource_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
=20
-	return sprintf(buf, "%#llx\n", dev_dax_resource(dev_dax));
+	return sprintf(buf, "%#llx\n", dev_dax->range.start);
 }
 static DEVICE_ATTR(resource, 0400, resource_show, NULL);
=20
@@ -376,6 +369,7 @@ static void dev_dax_release(struct devic
=20
 	dax_region_put(dax_region);
 	put_dax(dax_dev);
+	kfree(dev_dax->pgmap);
 	kfree(dev_dax);
 }
=20
@@ -412,7 +406,12 @@ struct dev_dax *devm_create_dev_dax(stru
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
=20
-	memcpy(&dev_dax->pgmap, data->pgmap, sizeof(struct dev_pagemap));
+	if (data->pgmap) {
+		dev_dax->pgmap =3D kmemdup(data->pgmap,
+				sizeof(struct dev_pagemap), GFP_KERNEL);
+		if (!dev_dax->pgmap)
+			goto err_pgmap;
+	}
=20
 	/*
 	 * No 'host' or dax_operations since there is no access to this
@@ -421,18 +420,19 @@ struct dev_dax *devm_create_dev_dax(stru
 	dax_dev =3D alloc_dax(dev_dax, NULL, NULL, DAXDEV_F_SYNC);
 	if (IS_ERR(dax_dev)) {
 		rc =3D PTR_ERR(dax_dev);
-		goto err;
+		goto err_alloc_dax;
 	}
=20
 	/* a device_dax instance is dead while the driver is not attached */
 	kill_dax(dax_dev);
=20
-	/* from here on we're committed to teardown via dax_dev_release() */
+	/* from here on we're committed to teardown via dev_dax_release() */
 	dev =3D &dev_dax->dev;
 	device_initialize(dev);
=20
 	dev_dax->dax_dev =3D dax_dev;
 	dev_dax->region =3D dax_region;
+	dev_dax->range =3D data->range;
 	dev_dax->target_node =3D dax_region->target_node;
 	kref_get(&dax_region->kref);
=20
@@ -458,8 +458,9 @@ struct dev_dax *devm_create_dev_dax(stru
 		return ERR_PTR(rc);
=20
 	return dev_dax;
-
- err:
+err_alloc_dax:
+	kfree(dev_dax->pgmap);
+err_pgmap:
 	kfree(dev_dax);
=20
 	return ERR_PTR(rc);
--- a/drivers/dax/bus.h~device-dax-make-pgmap-optional-for-instance-creation
+++ a/drivers/dax/bus.h
@@ -3,6 +3,7 @@
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
 #include <linux/device.h>
+#include <linux/range.h>
=20
 struct dev_dax;
 struct resource;
@@ -21,6 +22,7 @@ struct dev_dax_data {
 	struct dax_region *dax_region;
 	struct dev_pagemap *pgmap;
 	enum dev_dax_subsys subsys;
+	struct range range;
 	int id;
 };
=20
--- a/drivers/dax/dax-private.h~device-dax-make-pgmap-optional-for-instance=
-creation
+++ a/drivers/dax/dax-private.h
@@ -41,6 +41,7 @@ struct dax_region {
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
+ * @range: resource range for the instance
  * @dax_mem_res: physical address range of hotadded DAX memory
  * @dax_mem_name: name for hotadded DAX memory via add_memory_driver_manag=
ed()
  */
@@ -49,10 +50,16 @@ struct dev_dax {
 	struct dax_device *dax_dev;
 	int target_node;
 	struct device dev;
-	struct dev_pagemap pgmap;
+	struct dev_pagemap *pgmap;
+	struct range range;
 	struct resource *dax_kmem_res;
 };
=20
+static inline u64 range_len(struct range *range)
+{
+	return range->end - range->start + 1;
+}
+
 static inline struct dev_dax *to_dev_dax(struct device *dev)
 {
 	return container_of(dev, struct dev_dax, dev);
--- a/drivers/dax/device.c~device-dax-make-pgmap-optional-for-instance-crea=
tion
+++ a/drivers/dax/device.c
@@ -55,12 +55,12 @@ static int check_vma(struct dev_dax *dev
 __weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgof=
f,
 		unsigned long size)
 {
-	struct resource *res =3D &dev_dax->region->res;
+	struct range *range =3D &dev_dax->range;
 	phys_addr_t phys;
=20
-	phys =3D pgoff * PAGE_SIZE + res->start;
-	if (phys >=3D res->start && phys <=3D res->end) {
-		if (phys + size - 1 <=3D res->end)
+	phys =3D pgoff * PAGE_SIZE + range->start;
+	if (phys >=3D range->start && phys <=3D range->end) {
+		if (phys + size - 1 <=3D range->end)
 			return phys;
 	}
=20
@@ -396,21 +396,31 @@ int dev_dax_probe(struct device *dev)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
 	struct dax_device *dax_dev =3D dev_dax->dax_dev;
-	struct resource *res =3D &dev_dax->region->res;
+	struct range *range =3D &dev_dax->range;
+	struct dev_pagemap *pgmap;
 	struct inode *inode;
 	struct cdev *cdev;
 	void *addr;
 	int rc;
=20
 	/* 1:1 map region resource range to device-dax instance range */
-	if (!devm_request_mem_region(dev, res->start, resource_size(res),
+	if (!devm_request_mem_region(dev, range->start, range_len(range),
 				dev_name(dev))) {
-		dev_warn(dev, "could not reserve region %pR\n", res);
+		dev_warn(dev, "could not reserve range: %#llx - %#llx\n",
+				range->start, range->end);
 		return -EBUSY;
 	}
=20
-	dev_dax->pgmap.type =3D MEMORY_DEVICE_GENERIC;
-	addr =3D devm_memremap_pages(dev, &dev_dax->pgmap);
+	pgmap =3D dev_dax->pgmap;
+	if (!pgmap) {
+		pgmap =3D devm_kzalloc(dev, sizeof(*pgmap), GFP_KERNEL);
+		if (!pgmap)
+			return -ENOMEM;
+		pgmap->res.start =3D range->start;
+		pgmap->res.end =3D range->end;
+	}
+	pgmap->type =3D MEMORY_DEVICE_GENERIC;
+	addr =3D devm_memremap_pages(dev, pgmap);
 	if (IS_ERR(addr))
 		return PTR_ERR(addr);
=20
--- a/drivers/dax/hmem/hmem.c~device-dax-make-pgmap-optional-for-instance-c=
reation
+++ a/drivers/dax/hmem/hmem.c
@@ -8,7 +8,6 @@
 static int dax_hmem_probe(struct platform_device *pdev)
 {
 	struct device *dev =3D &pdev->dev;
-	struct dev_pagemap pgmap =3D { };
 	struct dax_region *dax_region;
 	struct memregion_info *mri;
 	struct dev_dax_data data;
@@ -20,8 +19,6 @@ static int dax_hmem_probe(struct platfor
 		return -ENOMEM;
=20
 	mri =3D dev->platform_data;
-	memcpy(&pgmap.res, res, sizeof(*res));
-
 	dax_region =3D alloc_dax_region(dev, pdev->id, res, mri->target_node,
 			PMD_SIZE);
 	if (!dax_region)
@@ -30,7 +27,10 @@ static int dax_hmem_probe(struct platfor
 	data =3D (struct dev_dax_data) {
 		.dax_region =3D dax_region,
 		.id =3D 0,
-		.pgmap =3D &pgmap,
+		.range =3D {
+			.start =3D res->start,
+			.end =3D res->end,
+		},
 	};
 	dev_dax =3D devm_create_dev_dax(&data);
 	if (IS_ERR(dev_dax))
--- a/drivers/dax/kmem.c~device-dax-make-pgmap-optional-for-instance-creati=
on
+++ a/drivers/dax/kmem.c
@@ -22,7 +22,7 @@ static bool any_hotremove_failed;
 int dev_dax_kmem_probe(struct device *dev)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
-	struct resource *res =3D &dev_dax->region->res;
+	struct range *range =3D &dev_dax->range;
 	resource_size_t kmem_start;
 	resource_size_t kmem_size;
 	resource_size_t kmem_end;
@@ -39,17 +39,17 @@ int dev_dax_kmem_probe(struct device *de
 	 */
 	numa_node =3D dev_dax->target_node;
 	if (numa_node < 0) {
-		dev_warn(dev, "rejecting DAX region %pR with invalid node: %d\n",
-			 res, numa_node);
+		dev_warn(dev, "rejecting DAX region with invalid node: %d\n",
+				numa_node);
 		return -EINVAL;
 	}
=20
 	/* Hotplug starting at the beginning of the next block: */
-	kmem_start =3D ALIGN(res->start, memory_block_size_bytes());
+	kmem_start =3D ALIGN(range->start, memory_block_size_bytes());
=20
-	kmem_size =3D resource_size(res);
+	kmem_size =3D range_len(range);
 	/* Adjust the size down to compensate for moving up kmem_start: */
-	kmem_size -=3D kmem_start - res->start;
+	kmem_size -=3D kmem_start - range->start;
 	/* Align the size down to cover only complete blocks: */
 	kmem_size &=3D ~(memory_block_size_bytes() - 1);
 	kmem_end =3D kmem_start + kmem_size;
--- a/drivers/dax/pmem/core.c~device-dax-make-pgmap-optional-for-instance-c=
reation
+++ a/drivers/dax/pmem/core.c
@@ -63,6 +63,10 @@ struct dev_dax *__dax_pmem_probe(struct
 		.id =3D id,
 		.pgmap =3D &pgmap,
 		.subsys =3D subsys,
+		.range =3D {
+			.start =3D res.start,
+			.end =3D res.end,
+		},
 	};
 	dev_dax =3D devm_create_dev_dax(&data);
=20
--- a/tools/testing/nvdimm/dax-dev.c~device-dax-make-pgmap-optional-for-ins=
tance-creation
+++ a/tools/testing/nvdimm/dax-dev.c
@@ -9,12 +9,12 @@
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
 		unsigned long size)
 {
-	struct resource *res =3D &dev_dax->region->res;
+	struct range *range =3D &dev_dax->range;
 	phys_addr_t addr;
=20
-	addr =3D pgoff * PAGE_SIZE + res->start;
-	if (addr >=3D res->start && addr <=3D res->end) {
-		if (addr + size - 1 <=3D res->end) {
+	addr =3D pgoff * PAGE_SIZE + range->start;
+	if (addr >=3D range->start && addr <=3D range->end) {
+		if (addr + size - 1 <=3D range->end) {
 			if (get_nfit_res(addr)) {
 				struct page *page;
=20
_
