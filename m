Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB7D2C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DEC52087D
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052218;
	bh=MPkGRzRl6qi9j1QvZSSCP+7dk+LCADphWvBwzr6wJ6o=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vnj6OiAPgVlrTi+M9HL1b4G06siXVHDW9+LtenXZVw7DlkTCPDxRAiYqg0VuVcUtw
	 o+AMXIQMmU8o7edAfe5eyDBt8l5p7738r/JXBfgO99PBZ8Q7lFow6WhXCQabvpLZYQ
	 5d4cowJaPLWjyZ2ZrxdfN7BGBKO8tyhUnnzFq0N0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgHUXXi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgHUXXi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:23:38 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81485207DF;
        Fri, 21 Aug 2020 23:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052217;
        bh=MPkGRzRl6qi9j1QvZSSCP+7dk+LCADphWvBwzr6wJ6o=;
        h=Date:From:To:Subject:From;
        b=mnBE5I3nAMd+Rmzq8ZpaA7zgMlu45+dwlNyoKogvUiEl9C3Ckph5z1cqTlA0kzROU
         U/QAyYT9R2E9FcMtgxYkHDwlkS68PI94ddC5atK8i81DiOJovD2bvbcfLBSBysdWV7
         p9I834K/ZovPwoEZ5uvkwjR5dof99BCBTPNyZnO4=
Date:   Fri, 21 Aug 2020 16:23:35 -0700
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
Subject:  +
 device-dax-add-an-allocation-interface-for-device-dax-instances.patch added
 to -mm tree
Message-ID: <20200821232335.uaF4agILK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: add an allocation interface for device-dax instances
has been added to the -mm tree.  Its filename is
     device-dax-add-an-allocation-interface-for-device-dax-instances.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-an-allocation-interface-for-device-dax-instances.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-an-allocation-interface-for-device-dax-instances.patch

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
Subject: device-dax: add an allocation interface for device-dax instances

;In preparation for a facility that enables dax regions to be sub-divided,
introduce infrastructure to track and allocate region capacity.

The new dax_region/available_size attribute is only enabled for volatile
hmem devices, not pmem devices that are defined by nvdimm namespace
boundaries.  This is per Jeff's feedback the last time dynamic device-dax
capacity allocation support was discussed.

Link: https://lore.kernel.org/linux-nvdimm/x49shpp3zn8.fsf@segfault.boston.devel.redhat.com
Link: https://lkml.kernel.org/r/159643101035.4062302.6785857915652647857.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
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

 drivers/dax/bus.c         |  120 +++++++++++++++++++++++++++++++++---
 drivers/dax/bus.h         |    7 +-
 drivers/dax/dax-private.h |    2 
 drivers/dax/hmem/hmem.c   |    7 --
 drivers/dax/pmem/core.c   |    8 --
 5 files changed, 121 insertions(+), 23 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-an-allocation-interface-for-device-dax-instances
+++ a/drivers/dax/bus.c
@@ -130,6 +130,11 @@ ATTRIBUTE_GROUPS(dax_drv);
 
 static int dax_bus_match(struct device *dev, struct device_driver *drv);
 
+static bool is_static(struct dax_region *dax_region)
+{
+	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
+}
+
 static struct bus_type dax_bus_type = {
 	.name = "dax",
 	.uevent = dax_bus_uevent,
@@ -185,7 +190,48 @@ static ssize_t align_show(struct device
 }
 static DEVICE_ATTR_RO(align);
 
+#define for_each_dax_region_resource(dax_region, res) \
+	for (res = (dax_region)->res.child; res; res = res->sibling)
+
+static unsigned long long dax_region_avail_size(struct dax_region *dax_region)
+{
+	resource_size_t size = resource_size(&dax_region->res);
+	struct resource *res;
+
+	device_lock_assert(dax_region->dev);
+
+	for_each_dax_region_resource(dax_region, res)
+		size -= resource_size(res);
+	return size;
+}
+
+static ssize_t available_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region = dev_get_drvdata(dev);
+	unsigned long long size;
+
+	device_lock(dev);
+	size = dax_region_avail_size(dax_region);
+	device_unlock(dev);
+
+	return sprintf(buf, "%llu\n", size);
+}
+static DEVICE_ATTR_RO(available_size);
+
+static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
+		int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct dax_region *dax_region = dev_get_drvdata(dev);
+
+	if (is_static(dax_region) && a == &dev_attr_available_size.attr)
+		return 0;
+	return a->mode;
+}
+
 static struct attribute *dax_region_attributes[] = {
+	&dev_attr_available_size.attr,
 	&dev_attr_region_size.attr,
 	&dev_attr_align.attr,
 	&dev_attr_id.attr,
@@ -195,6 +241,7 @@ static struct attribute *dax_region_attr
 static const struct attribute_group dax_region_attribute_group = {
 	.name = "dax_region",
 	.attrs = dax_region_attributes,
+	.is_visible = dax_region_visible,
 };
 
 static const struct attribute_group *dax_region_attribute_groups[] = {
@@ -226,7 +273,8 @@ static void dax_region_unregister(void *
 }
 
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align)
+		struct resource *res, int target_node, unsigned int align,
+		unsigned long flags)
 {
 	struct dax_region *dax_region;
 
@@ -249,12 +297,17 @@ struct dax_region *alloc_dax_region(stru
 		return NULL;
 
 	dev_set_drvdata(parent, dax_region);
-	memcpy(&dax_region->res, res, sizeof(*res));
 	kref_init(&dax_region->kref);
 	dax_region->id = region_id;
 	dax_region->align = align;
 	dax_region->dev = parent;
 	dax_region->target_node = target_node;
+	dax_region->res = (struct resource) {
+		.start = res->start,
+		.end = res->end,
+		.flags = IORESOURCE_MEM | flags,
+	};
+
 	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
 		kfree(dax_region);
 		return NULL;
@@ -267,6 +320,32 @@ struct dax_region *alloc_dax_region(stru
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
 
+static int alloc_dev_dax_range(struct dev_dax *dev_dax, resource_size_t size)
+{
+	struct dax_region *dax_region = dev_dax->region;
+	struct resource *res = &dax_region->res;
+	struct device *dev = &dev_dax->dev;
+	struct resource *alloc;
+
+	device_lock_assert(dax_region->dev);
+
+	/* TODO: handle multiple allocations per region */
+	if (res->child)
+		return -ENOMEM;
+
+	alloc = __request_region(res, res->start, size, dev_name(dev), 0);
+
+	if (!alloc)
+		return -ENOMEM;
+
+	dev_dax->range = (struct range) {
+		.start = alloc->start,
+		.end = alloc->end,
+	};
+
+	return 0;
+}
+
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -361,6 +440,15 @@ void kill_dev_dax(struct dev_dax *dev_da
 }
 EXPORT_SYMBOL_GPL(kill_dev_dax);
 
+static void free_dev_dax_range(struct dev_dax *dev_dax)
+{
+	struct dax_region *dax_region = dev_dax->region;
+	struct range *range = &dev_dax->range;
+
+	device_lock_assert(dax_region->dev);
+	__release_region(&dax_region->res, range->start, range_len(range));
+}
+
 static void dev_dax_release(struct device *dev)
 {
 	struct dev_dax *dev_dax = to_dev_dax(dev);
@@ -385,6 +473,7 @@ static void unregister_dev_dax(void *dev
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dev_dax(dev_dax);
+	free_dev_dax_range(dev_dax);
 	device_del(dev);
 	put_device(dev);
 }
@@ -397,7 +486,7 @@ struct dev_dax *devm_create_dev_dax(stru
 	struct dev_dax *dev_dax;
 	struct inode *inode;
 	struct device *dev;
-	int rc = -ENOMEM;
+	int rc;
 
 	if (data->id < 0)
 		return ERR_PTR(-EINVAL);
@@ -406,11 +495,25 @@ struct dev_dax *devm_create_dev_dax(stru
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
 
+	dev_dax->region = dax_region;
+	dev = &dev_dax->dev;
+	device_initialize(dev);
+	dev_set_name(dev, "dax%d.%d", dax_region->id, data->id);
+
+	rc = alloc_dev_dax_range(dev_dax, data->size);
+	if (rc)
+		goto err_range;
+
 	if (data->pgmap) {
+		dev_WARN_ONCE(parent, !is_static(dax_region),
+			"custom dev_pagemap requires a static dax_region\n");
+
 		dev_dax->pgmap = kmemdup(data->pgmap,
 				sizeof(struct dev_pagemap), GFP_KERNEL);
-		if (!dev_dax->pgmap)
+		if (!dev_dax->pgmap) {
+			rc = -ENOMEM;
 			goto err_pgmap;
+		}
 	}
 
 	/*
@@ -427,12 +530,7 @@ struct dev_dax *devm_create_dev_dax(stru
 	kill_dax(dax_dev);
 
 	/* from here on we're committed to teardown via dev_dax_release() */
-	dev = &dev_dax->dev;
-	device_initialize(dev);
-
 	dev_dax->dax_dev = dax_dev;
-	dev_dax->region = dax_region;
-	dev_dax->range = data->range;
 	dev_dax->target_node = dax_region->target_node;
 	kref_get(&dax_region->kref);
 
@@ -444,7 +542,6 @@ struct dev_dax *devm_create_dev_dax(stru
 		dev->class = dax_class;
 	dev->parent = parent;
 	dev->type = &dev_dax_type;
-	dev_set_name(dev, "dax%d.%d", dax_region->id, data->id);
 
 	rc = device_add(dev);
 	if (rc) {
@@ -458,9 +555,12 @@ struct dev_dax *devm_create_dev_dax(stru
 		return ERR_PTR(rc);
 
 	return dev_dax;
+
 err_alloc_dax:
 	kfree(dev_dax->pgmap);
 err_pgmap:
+	free_dev_dax_range(dev_dax);
+err_range:
 	kfree(dev_dax);
 
 	return ERR_PTR(rc);
--- a/drivers/dax/bus.h~device-dax-add-an-allocation-interface-for-device-dax-instances
+++ a/drivers/dax/bus.h
@@ -10,8 +10,11 @@ struct resource;
 struct dax_device;
 struct dax_region;
 void dax_region_put(struct dax_region *dax_region);
+
+#define IORESOURCE_DAX_STATIC (1UL << 0)
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align);
+		struct resource *res, int target_node, unsigned int align,
+		unsigned long flags);
 
 enum dev_dax_subsys {
 	DEV_DAX_BUS = 0, /* zeroed dev_dax_data picks this by default */
@@ -22,7 +25,7 @@ struct dev_dax_data {
 	struct dax_region *dax_region;
 	struct dev_pagemap *pgmap;
 	enum dev_dax_subsys subsys;
-	struct range range;
+	resource_size_t size;
 	int id;
 };
 
--- a/drivers/dax/dax-private.h~device-dax-add-an-allocation-interface-for-device-dax-instances
+++ a/drivers/dax/dax-private.h
@@ -22,7 +22,7 @@ void dax_bus_exit(void);
  * @kref: to pin while other agents have a need to do lookups
  * @dev: parent device backing this region
  * @align: allocation and mapping alignment for child dax devices
- * @res: physical address range of the region
+ * @res: resource tree to track instance allocations
  */
 struct dax_region {
 	int id;
--- a/drivers/dax/hmem/hmem.c~device-dax-add-an-allocation-interface-for-device-dax-instances
+++ a/drivers/dax/hmem/hmem.c
@@ -20,17 +20,14 @@ static int dax_hmem_probe(struct platfor
 
 	mri = dev->platform_data;
 	dax_region = alloc_dax_region(dev, pdev->id, res, mri->target_node,
-			PMD_SIZE);
+			PMD_SIZE, 0);
 	if (!dax_region)
 		return -ENOMEM;
 
 	data = (struct dev_dax_data) {
 		.dax_region = dax_region,
 		.id = 0,
-		.range = {
-			.start = res->start,
-			.end = res->end,
-		},
+		.size = resource_size(res),
 	};
 	dev_dax = devm_create_dev_dax(&data);
 	if (IS_ERR(dev_dax))
--- a/drivers/dax/pmem/core.c~device-dax-add-an-allocation-interface-for-device-dax-instances
+++ a/drivers/dax/pmem/core.c
@@ -54,7 +54,8 @@ struct dev_dax *__dax_pmem_probe(struct
 	memcpy(&res, &pgmap.res, sizeof(res));
 	res.start += offset;
 	dax_region = alloc_dax_region(dev, region_id, &res,
-			nd_region->target_node, le32_to_cpu(pfn_sb->align));
+			nd_region->target_node, le32_to_cpu(pfn_sb->align),
+			IORESOURCE_DAX_STATIC);
 	if (!dax_region)
 		return ERR_PTR(-ENOMEM);
 
@@ -63,10 +64,7 @@ struct dev_dax *__dax_pmem_probe(struct
 		.id = id,
 		.pgmap = &pgmap,
 		.subsys = subsys,
-		.range = {
-			.start = res.start,
-			.end = res.end,
-		},
+		.size = resource_size(&res),
 	};
 	dev_dax = devm_create_dev_dax(&data);
 
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

