Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654ADC4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10CB320936
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087072;
	bh=EhqfwyGySSFmI8XWPFGo/CYk44hhfqGlQu55LOvROgw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=IebZF2wEe7Zr7rBnZTFDbjZ9ZWrdjJ/tmINwQJ4+gRJ9Z7SodJ2o/JflIGT/vJ3Sc
	 uicXqWwMJm5vzWRlqeKM3ORmSNAv6Iql6V3FBoUMngslC3fNWJeeY7V0LucM2/O/Ii
	 uNzgeonzAidfI1BJ4fJ3NwupqpFIs9P5oB2n0z1E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgIZCYb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728406AbgIZCYb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:24:31 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27CD820866;
        Sat, 26 Sep 2020 02:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087070;
        bh=EhqfwyGySSFmI8XWPFGo/CYk44hhfqGlQu55LOvROgw=;
        h=Date:From:To:Subject:From;
        b=oOdLlbmpq1IUqFxjOgaQIDoRVM6FoNj6NxR3Lq1McMD/tOuq2rYaZ10fsmwdVfb3N
         VPnNYlNuK+hcEVWBcc1s71nrmrJpsBznXcY2bsrukFGTbGMMCIDEyYL84yajpSCEEk
         77n6tlkuUqQz21DLhAC+zIkFqXRQthRgDELNqP/Y=
Date:   Fri, 25 Sep 2020 19:24:27 -0700
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
        jglisse@redhat.com, jgg@mellanox.com, ira.weiny@intel.com,
        hulkci@huawei.com, hpa@zytor.com, gregkh@linuxfoundation.org,
        david@redhat.com, dave.jiang@intel.com,
        dave.hansen@linux.intel.com, daniel@ffwll.ch,
        catalin.marinas@arm.com, bskeggs@redhat.com, Brice.Goglin@inria.fr,
        bp@alien8.de, boris.ostrovsky@oracle.com, bhelgaas@google.com,
        benh@kernel.crashing.org, ardb@kernel.org,
        ard.biesheuvel@linaro.org, airlied@linux.ie,
        dan.j.williams@intel.com
Subject:  +
 device-dax-make-pgmap-optional-for-instance-creation.patch added to -mm tree
Message-ID: <20200926022427.yxuIj%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: make pgmap optional for instance creation
has been added to the -mm tree.  Its filename is
     device-dax-make-pgmap-optional-for-instance-creation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-make-pgmap-optiona=
l-for-instance-creation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-make-pgmap-optiona=
l-for-instance-creation.patch

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

