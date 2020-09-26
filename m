Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF3CC4727E
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8088B2087D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087136;
	bh=Btvk4kyIO/Rt46wrgUnCqK8EKyTRBRm186zFzqYAAvU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=D408RPKjm1bfBpu0X3cUmKFCKx/1F89IAFN9l31EOYIcgWFXO4bc/3SvJ08sfrYY6
	 LWCQtpe0aMz3S61vypkVspG1LJo42uoohHo8AW03oyeNDHcHAdNiGHHUFV3UEX0XmC
	 WHo4yXYJN5I9pS5n/cMtLyMLM+RZxel9dPsG2+Nw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgIZCZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIZCZg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:36 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1781D206B8;
        Sat, 26 Sep 2020 02:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087134;
        bh=Btvk4kyIO/Rt46wrgUnCqK8EKyTRBRm186zFzqYAAvU=;
        h=Date:From:To:Subject:From;
        b=xsjrfl646D2eA4GmOBcZ+aejxc/apOsgiyiuIT94mPmJZ5a1peDe7XaRa2XUeVAYN
         DeZ2A+t3huoLF1YU7CCc/bUCvU2JJXR73cSM0TmswdvDSmNjrawqkguci4tmglis+2
         gSIeVoWqidq446T2JXV1SRdWwaKzOFRD6xJB1unA=
Date:   Fri, 25 Sep 2020 19:25:31 -0700
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
Subject:  + device-dax-introduce-mapping-devices.patch added to -mm
 tree
Message-ID: <20200926022531.OTEIe%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: introduce 'mapping' devices
has been added to the -mm tree.  Its filename is
     device-dax-introduce-mapping-devices.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-introduce-mapping-=
devices.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-introduce-mapping-=
devices.patch

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
Subject: device-dax: introduce 'mapping' devices

In support of interrogating the physical address layout of a device with
dis-contiguous ranges, introduce a sysfs directory with 'start', 'end',
and 'page_offset' attributes.  The alternative is trying to parse
/proc/iomem, and that file will not reflect the extent layout until the
device is enabled.

Link: https://lkml.kernel.org/r/159643104819.4062302.13691281391423291589.s=
tgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106117446.30709.2751020815463722537.stgi=
t@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Jia He <justin.he@arm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
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
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |  191 +++++++++++++++++++++++++++++++++++-
 drivers/dax/dax-private.h |   14 ++
 2 files changed, 203 insertions(+), 2 deletions(-)

--- a/drivers/dax/bus.c~device-dax-introduce-mapping-devices
+++ a/drivers/dax/bus.c
@@ -579,6 +579,167 @@ struct dax_region *alloc_dax_region(stru
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
=20
+static void dax_mapping_release(struct device *dev)
+{
+	struct dax_mapping *mapping =3D to_dax_mapping(dev);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev->parent);
+
+	ida_free(&dev_dax->ida, mapping->id);
+	kfree(mapping);
+}
+
+static void unregister_dax_mapping(void *data)
+{
+	struct device *dev =3D data;
+	struct dax_mapping *mapping =3D to_dax_mapping(dev);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev->parent);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	device_lock_assert(dax_region->dev);
+
+	dev_dax->ranges[mapping->range_id].mapping =3D NULL;
+	mapping->range_id =3D -1;
+
+	device_del(dev);
+	put_device(dev);
+}
+
+static struct dev_dax_range *get_dax_range(struct device *dev)
+{
+	struct dax_mapping *mapping =3D to_dax_mapping(dev);
+	struct dev_dax *dev_dax =3D to_dev_dax(dev->parent);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	device_lock(dax_region->dev);
+	if (mapping->range_id < 0) {
+		device_unlock(dax_region->dev);
+		return NULL;
+	}
+
+	return &dev_dax->ranges[mapping->range_id];
+}
+
+static void put_dax_range(struct dev_dax_range *dax_range)
+{
+	struct dax_mapping *mapping =3D dax_range->mapping;
+	struct dev_dax *dev_dax =3D to_dev_dax(mapping->dev.parent);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	device_unlock(dax_region->dev);
+}
+
+static ssize_t start_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax_range *dax_range;
+	ssize_t rc;
+
+	dax_range =3D get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc =3D sprintf(buf, "%#llx\n", dax_range->range.start);
+	put_dax_range(dax_range);
+
+	return rc;
+}
+static DEVICE_ATTR(start, 0400, start_show, NULL);
+
+static ssize_t end_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax_range *dax_range;
+	ssize_t rc;
+
+	dax_range =3D get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc =3D sprintf(buf, "%#llx\n", dax_range->range.end);
+	put_dax_range(dax_range);
+
+	return rc;
+}
+static DEVICE_ATTR(end, 0400, end_show, NULL);
+
+static ssize_t pgoff_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax_range *dax_range;
+	ssize_t rc;
+
+	dax_range =3D get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc =3D sprintf(buf, "%#lx\n", dax_range->pgoff);
+	put_dax_range(dax_range);
+
+	return rc;
+}
+static DEVICE_ATTR(page_offset, 0400, pgoff_show, NULL);
+
+static struct attribute *dax_mapping_attributes[] =3D {
+	&dev_attr_start.attr,
+	&dev_attr_end.attr,
+	&dev_attr_page_offset.attr,
+	NULL,
+};
+
+static const struct attribute_group dax_mapping_attribute_group =3D {
+	.attrs =3D dax_mapping_attributes,
+};
+
+static const struct attribute_group *dax_mapping_attribute_groups[] =3D {
+	&dax_mapping_attribute_group,
+	NULL,
+};
+
+static struct device_type dax_mapping_type =3D {
+	.release =3D dax_mapping_release,
+	.groups =3D dax_mapping_attribute_groups,
+};
+
+static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct dax_mapping *mapping;
+	struct device *dev;
+	int rc;
+
+	device_lock_assert(dax_region->dev);
+
+	if (dev_WARN_ONCE(&dev_dax->dev, !dax_region->dev->driver,
+				"region disabled\n"))
+		return -ENXIO;
+
+	mapping =3D kzalloc(sizeof(*mapping), GFP_KERNEL);
+	if (!mapping)
+		return -ENOMEM;
+	mapping->range_id =3D range_id;
+	mapping->id =3D ida_alloc(&dev_dax->ida, GFP_KERNEL);
+	if (mapping->id < 0) {
+		kfree(mapping);
+		return -ENOMEM;
+	}
+	dev_dax->ranges[range_id].mapping =3D mapping;
+	dev =3D &mapping->dev;
+	device_initialize(dev);
+	dev->parent =3D &dev_dax->dev;
+	dev->type =3D &dax_mapping_type;
+	dev_set_name(dev, "mapping%d", mapping->id);
+	rc =3D device_add(dev);
+	if (rc) {
+		put_device(dev);
+		return rc;
+	}
+
+	rc =3D devm_add_action_or_reset(dax_region->dev, unregister_dax_mapping,
+			dev);
+	if (rc)
+		return rc;
+	return 0;
+}
+
 static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 		resource_size_t size)
 {
@@ -588,7 +749,7 @@ static int alloc_dev_dax_range(struct de
 	struct dev_dax_range *ranges;
 	unsigned long pgoff =3D 0;
 	struct resource *alloc;
-	int i;
+	int i, rc;
=20
 	device_lock_assert(dax_region->dev);
=20
@@ -633,6 +794,22 @@ static int alloc_dev_dax_range(struct de
=20
 	dev_dbg(dev, "alloc range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
 			&alloc->start, &alloc->end);
+	/*
+	 * A dev_dax instance must be registered before mapping device
+	 * children can be added. Defer to devm_create_dev_dax() to add
+	 * the initial mapping device.
+	 */
+	if (!device_is_registered(&dev_dax->dev))
+		return 0;
+
+	rc =3D devm_register_dax_mapping(dev_dax, dev_dax->nr_range - 1);
+	if (rc) {
+		dev_dbg(dev, "delete range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
+				&alloc->start, &alloc->end);
+		dev_dax->nr_range--;
+		__release_region(res, alloc->start, resource_size(alloc));
+		return rc;
+	}
=20
 	return 0;
 }
@@ -701,11 +878,14 @@ static int dev_dax_shrink(struct dev_dax
=20
 	for (i =3D dev_dax->nr_range - 1; i >=3D 0; i--) {
 		struct range *range =3D &dev_dax->ranges[i].range;
+		struct dax_mapping *mapping =3D dev_dax->ranges[i].mapping;
 		struct resource *adjust =3D NULL, *res;
 		resource_size_t shrink;
=20
 		shrink =3D min_t(u64, to_shrink, range_len(range));
 		if (shrink >=3D range_len(range)) {
+			devm_release_action(dax_region->dev,
+					unregister_dax_mapping, &mapping->dev);
 			__release_region(&dax_region->res, range->start,
 					range_len(range));
 			dev_dax->nr_range--;
@@ -1036,9 +1216,9 @@ struct dev_dax *devm_create_dev_dax(stru
 	/* a device_dax instance is dead while the driver is not attached */
 	kill_dax(dax_dev);
=20
-	/* from here on we're committed to teardown via dev_dax_release() */
 	dev_dax->dax_dev =3D dax_dev;
 	dev_dax->target_node =3D dax_region->target_node;
+	ida_init(&dev_dax->ida);
 	kref_get(&dax_region->kref);
=20
 	inode =3D dax_inode(dax_dev);
@@ -1061,6 +1241,13 @@ struct dev_dax *devm_create_dev_dax(stru
 	if (rc)
 		return ERR_PTR(rc);
=20
+	/* register mapping device for the initial allocation range */
+	if (dev_dax->nr_range && range_len(&dev_dax->ranges[0].range)) {
+		rc =3D devm_register_dax_mapping(dev_dax, 0);
+		if (rc)
+			return ERR_PTR(rc);
+	}
+
 	return dev_dax;
=20
 err_alloc_dax:
--- a/drivers/dax/dax-private.h~device-dax-introduce-mapping-devices
+++ a/drivers/dax/dax-private.h
@@ -40,6 +40,12 @@ struct dax_region {
 	struct device *youngest;
 };
=20
+struct dax_mapping {
+	struct device dev;
+	int range_id;
+	int id;
+};
+
 /**
  * struct dev_dax - instance data for a subdivision of a dax region, and
  * data while the device is activated in the driver.
@@ -47,6 +53,7 @@ struct dax_region {
  * @dax_dev - core dax functionality
  * @target_node: effective numa node if dev_dax memory range is onlined
  * @id: ida allocated id
+ * @ida: mapping id allocator
  * @dev - device core
  * @pgmap - pgmap for memmap setup / lifetime (driver owned)
  * @nr_range: size of @ranges
@@ -57,12 +64,14 @@ struct dev_dax {
 	struct dax_device *dax_dev;
 	int target_node;
 	int id;
+	struct ida ida;
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	int nr_range;
 	struct dev_dax_range {
 		unsigned long pgoff;
 		struct range range;
+		struct dax_mapping *mapping;
 	} *ranges;
 };
=20
@@ -70,4 +79,9 @@ static inline struct dev_dax *to_dev_dax
 {
 	return container_of(dev, struct dev_dax, dev);
 }
+
+static inline struct dax_mapping *to_dax_mapping(struct device *dev)
+{
+	return container_of(dev, struct dax_mapping, dev);
+}
 #endif
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

