Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8050C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81ADC22203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633013;
	bh=Cik86WubM/JUWJrgJyxxI7wRYMGWi+1ojXHyN++sdu4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=YdlpcODYmMLWwgzND8SwSMLDyCbBpeeLhqLospTs/bNraM6FQp9HMTtk9dXVb921R
	 6pwOPSRSUnTYKxmQ/pyeR16hPPoXMgD1T+cXKNVe8sbm1BJLs2igmXN1bLMY+6pbyg
	 jqusn9dtSzk229ager947CMfA+HabH589i9P8+OE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgJMXuM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730277AbgJMXuH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:50:07 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C873322200;
        Tue, 13 Oct 2020 23:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633005;
        bh=Cik86WubM/JUWJrgJyxxI7wRYMGWi+1ojXHyN++sdu4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hvHPOX0ntRE82Aiy26UORIIx96VXSgLLkxJMi+R8GKbaS8o0GHfcl5AeiwgnNJeCY
         8y9d2ACIrYF7z2RBdr4VmkPQb8LlD+zpQMFxn+B9KmSLrk39cevE4HgzzDmnETgRMQ
         +vnoP/KQm1xZtWMZk6Z7NFC0CJiKqmXkzeM3dCD0=
Date:   Tue, 13 Oct 2020 16:50:03 -0700
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
Subject:  [patch 039/181] device-dax: add an allocation interface
 for device-dax instances
Message-ID: <20201013235003.FfoxMdiM5%akpm@linux-foundation.org>
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
Subject: device-dax: add an allocation interface for device-dax instances

In preparation for a facility that enables dax regions to be sub-divided,
introduce infrastructure to track and allocate region capacity.

The new dax_region/available_size attribute is only enabled for volatile
hmem devices, not pmem devices that are defined by nvdimm namespace
boundaries.  This is per Jeff's feedback the last time dynamic device-dax
capacity allocation support was discussed.

Link: https://lore.kernel.org/linux-nvdimm/x49shpp3zn8.fsf@segfault.boston.=
devel.redhat.com
Link: https://lkml.kernel.org/r/159643101035.4062302.6785857915652647857.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106112801.30709.14601438735305335071.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
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

 drivers/dax/bus.c         |  120 +++++++++++++++++++++++++++++++++---
 drivers/dax/bus.h         |    7 +-
 drivers/dax/dax-private.h |    2=20
 drivers/dax/hmem/hmem.c   |    7 --
 drivers/dax/pmem/core.c   |    8 --
 5 files changed, 121 insertions(+), 23 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-an-allocation-interface-for-device-d=
ax-instances
+++ a/drivers/dax/bus.c
@@ -130,6 +130,11 @@ ATTRIBUTE_GROUPS(dax_drv);
=20
 static int dax_bus_match(struct device *dev, struct device_driver *drv);
=20
+static bool is_static(struct dax_region *dax_region)
+{
+	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) !=3D 0;
+}
+
 static struct bus_type dax_bus_type =3D {
 	.name =3D "dax",
 	.uevent =3D dax_bus_uevent,
@@ -185,7 +190,48 @@ static ssize_t align_show(struct device
 }
 static DEVICE_ATTR_RO(align);
=20
+#define for_each_dax_region_resource(dax_region, res) \
+	for (res =3D (dax_region)->res.child; res; res =3D res->sibling)
+
+static unsigned long long dax_region_avail_size(struct dax_region *dax_reg=
ion)
+{
+	resource_size_t size =3D resource_size(&dax_region->res);
+	struct resource *res;
+
+	device_lock_assert(dax_region->dev);
+
+	for_each_dax_region_resource(dax_region, res)
+		size -=3D resource_size(res);
+	return size;
+}
+
+static ssize_t available_size_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dax_region *dax_region =3D dev_get_drvdata(dev);
+	unsigned long long size;
+
+	device_lock(dev);
+	size =3D dax_region_avail_size(dax_region);
+	device_unlock(dev);
+
+	return sprintf(buf, "%llu\n", size);
+}
+static DEVICE_ATTR_RO(available_size);
+
+static umode_t dax_region_visible(struct kobject *kobj, struct attribute *=
a,
+		int n)
+{
+	struct device *dev =3D container_of(kobj, struct device, kobj);
+	struct dax_region *dax_region =3D dev_get_drvdata(dev);
+
+	if (is_static(dax_region) && a =3D=3D &dev_attr_available_size.attr)
+		return 0;
+	return a->mode;
+}
+
 static struct attribute *dax_region_attributes[] =3D {
+	&dev_attr_available_size.attr,
 	&dev_attr_region_size.attr,
 	&dev_attr_align.attr,
 	&dev_attr_id.attr,
@@ -195,6 +241,7 @@ static struct attribute *dax_region_attr
 static const struct attribute_group dax_region_attribute_group =3D {
 	.name =3D "dax_region",
 	.attrs =3D dax_region_attributes,
+	.is_visible =3D dax_region_visible,
 };
=20
 static const struct attribute_group *dax_region_attribute_groups[] =3D {
@@ -226,7 +273,8 @@ static void dax_region_unregister(void *
 }
=20
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
-		struct resource *res, int target_node, unsigned int align)
+		struct resource *res, int target_node, unsigned int align,
+		unsigned long flags)
 {
 	struct dax_region *dax_region;
=20
@@ -249,12 +297,17 @@ struct dax_region *alloc_dax_region(stru
 		return NULL;
=20
 	dev_set_drvdata(parent, dax_region);
-	memcpy(&dax_region->res, res, sizeof(*res));
 	kref_init(&dax_region->kref);
 	dax_region->id =3D region_id;
 	dax_region->align =3D align;
 	dax_region->dev =3D parent;
 	dax_region->target_node =3D target_node;
+	dax_region->res =3D (struct resource) {
+		.start =3D res->start,
+		.end =3D res->end,
+		.flags =3D IORESOURCE_MEM | flags,
+	};
+
 	if (sysfs_create_groups(&parent->kobj, dax_region_attribute_groups)) {
 		kfree(dax_region);
 		return NULL;
@@ -267,6 +320,32 @@ struct dax_region *alloc_dax_region(stru
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
=20
+static int alloc_dev_dax_range(struct dev_dax *dev_dax, resource_size_t si=
ze)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct resource *res =3D &dax_region->res;
+	struct device *dev =3D &dev_dax->dev;
+	struct resource *alloc;
+
+	device_lock_assert(dax_region->dev);
+
+	/* TODO: handle multiple allocations per region */
+	if (res->child)
+		return -ENOMEM;
+
+	alloc =3D __request_region(res, res->start, size, dev_name(dev), 0);
+
+	if (!alloc)
+		return -ENOMEM;
+
+	dev_dax->range =3D (struct range) {
+		.start =3D alloc->start,
+		.end =3D alloc->end,
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
=20
+static void free_dev_dax_range(struct dev_dax *dev_dax)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct range *range =3D &dev_dax->range;
+
+	device_lock_assert(dax_region->dev);
+	__release_region(&dax_region->res, range->start, range_len(range));
+}
+
 static void dev_dax_release(struct device *dev)
 {
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
@@ -385,6 +473,7 @@ static void unregister_dev_dax(void *dev
 	dev_dbg(dev, "%s\n", __func__);
=20
 	kill_dev_dax(dev_dax);
+	free_dev_dax_range(dev_dax);
 	device_del(dev);
 	put_device(dev);
 }
@@ -397,7 +486,7 @@ struct dev_dax *devm_create_dev_dax(stru
 	struct dev_dax *dev_dax;
 	struct inode *inode;
 	struct device *dev;
-	int rc =3D -ENOMEM;
+	int rc;
=20
 	if (data->id < 0)
 		return ERR_PTR(-EINVAL);
@@ -406,11 +495,25 @@ struct dev_dax *devm_create_dev_dax(stru
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
=20
+	dev_dax->region =3D dax_region;
+	dev =3D &dev_dax->dev;
+	device_initialize(dev);
+	dev_set_name(dev, "dax%d.%d", dax_region->id, data->id);
+
+	rc =3D alloc_dev_dax_range(dev_dax, data->size);
+	if (rc)
+		goto err_range;
+
 	if (data->pgmap) {
+		dev_WARN_ONCE(parent, !is_static(dax_region),
+			"custom dev_pagemap requires a static dax_region\n");
+
 		dev_dax->pgmap =3D kmemdup(data->pgmap,
 				sizeof(struct dev_pagemap), GFP_KERNEL);
-		if (!dev_dax->pgmap)
+		if (!dev_dax->pgmap) {
+			rc =3D -ENOMEM;
 			goto err_pgmap;
+		}
 	}
=20
 	/*
@@ -427,12 +530,7 @@ struct dev_dax *devm_create_dev_dax(stru
 	kill_dax(dax_dev);
=20
 	/* from here on we're committed to teardown via dev_dax_release() */
-	dev =3D &dev_dax->dev;
-	device_initialize(dev);
-
 	dev_dax->dax_dev =3D dax_dev;
-	dev_dax->region =3D dax_region;
-	dev_dax->range =3D data->range;
 	dev_dax->target_node =3D dax_region->target_node;
 	kref_get(&dax_region->kref);
=20
@@ -444,7 +542,6 @@ struct dev_dax *devm_create_dev_dax(stru
 		dev->class =3D dax_class;
 	dev->parent =3D parent;
 	dev->type =3D &dev_dax_type;
-	dev_set_name(dev, "dax%d.%d", dax_region->id, data->id);
=20
 	rc =3D device_add(dev);
 	if (rc) {
@@ -458,9 +555,12 @@ struct dev_dax *devm_create_dev_dax(stru
 		return ERR_PTR(rc);
=20
 	return dev_dax;
+
 err_alloc_dax:
 	kfree(dev_dax->pgmap);
 err_pgmap:
+	free_dev_dax_range(dev_dax);
+err_range:
 	kfree(dev_dax);
=20
 	return ERR_PTR(rc);
--- a/drivers/dax/bus.h~device-dax-add-an-allocation-interface-for-device-d=
ax-instances
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
=20
 enum dev_dax_subsys {
 	DEV_DAX_BUS =3D 0, /* zeroed dev_dax_data picks this by default */
@@ -22,7 +25,7 @@ struct dev_dax_data {
 	struct dax_region *dax_region;
 	struct dev_pagemap *pgmap;
 	enum dev_dax_subsys subsys;
-	struct range range;
+	resource_size_t size;
 	int id;
 };
=20
--- a/drivers/dax/dax-private.h~device-dax-add-an-allocation-interface-for-=
device-dax-instances
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
--- a/drivers/dax/hmem/hmem.c~device-dax-add-an-allocation-interface-for-de=
vice-dax-instances
+++ a/drivers/dax/hmem/hmem.c
@@ -20,17 +20,14 @@ static int dax_hmem_probe(struct platfor
=20
 	mri =3D dev->platform_data;
 	dax_region =3D alloc_dax_region(dev, pdev->id, res, mri->target_node,
-			PMD_SIZE);
+			PMD_SIZE, 0);
 	if (!dax_region)
 		return -ENOMEM;
=20
 	data =3D (struct dev_dax_data) {
 		.dax_region =3D dax_region,
 		.id =3D 0,
-		.range =3D {
-			.start =3D res->start,
-			.end =3D res->end,
-		},
+		.size =3D resource_size(res),
 	};
 	dev_dax =3D devm_create_dev_dax(&data);
 	if (IS_ERR(dev_dax))
--- a/drivers/dax/pmem/core.c~device-dax-add-an-allocation-interface-for-de=
vice-dax-instances
+++ a/drivers/dax/pmem/core.c
@@ -54,7 +54,8 @@ struct dev_dax *__dax_pmem_probe(struct
 	memcpy(&res, &pgmap.res, sizeof(res));
 	res.start +=3D offset;
 	dax_region =3D alloc_dax_region(dev, region_id, &res,
-			nd_region->target_node, le32_to_cpu(pfn_sb->align));
+			nd_region->target_node, le32_to_cpu(pfn_sb->align),
+			IORESOURCE_DAX_STATIC);
 	if (!dax_region)
 		return ERR_PTR(-ENOMEM);
=20
@@ -63,10 +64,7 @@ struct dev_dax *__dax_pmem_probe(struct
 		.id =3D id,
 		.pgmap =3D &pgmap,
 		.subsys =3D subsys,
-		.range =3D {
-			.start =3D res.start,
-			.end =3D res.end,
-		},
+		.size =3D resource_size(&res),
 	};
 	dev_dax =3D devm_create_dev_dax(&data);
=20
_
