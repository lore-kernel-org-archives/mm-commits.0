Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5A2C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABA0820855
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052262;
	bh=Rj57AfngWYF8X6CIeHxLzTnbTlG8BPzMEOZl098Wsts=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=a3mSRZkI7jMusNEdKUKormEf/NCP+oo6EMT4b/t0E4ddKUN9P/s+UUbNjTZLMgChH
	 bLZ7aQUdG4lTcYtEudc9N7WxCBAs1BGkorylA5qXO7d9KE5iZEzVbzVFxvZHkOMOHK
	 PLNqBCUZveMb1tHxWvRN8/p0y9Jd2GslO9XL2Wsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHUXYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgHUXYR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:24:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA82207C3;
        Fri, 21 Aug 2020 23:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052255;
        bh=Rj57AfngWYF8X6CIeHxLzTnbTlG8BPzMEOZl098Wsts=;
        h=Date:From:To:Subject:From;
        b=MxS4sLY+YpQIDfkSg0NBpYOlfJMxJzDJMIK7P766ZaBZsGIFMoE52+6/uiFHSJUKj
         K2+snO3P/kq4rGhZw79LrkVU9N7CANXZN21PkaLLxtfA762RvL8Hr5iKzsbZ3aGL++
         4SwkilbCrDC7m3qwrP/PQ3AYDCshltMtjCy8rE24=
Date:   Fri, 21 Aug 2020 16:24:13 -0700
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
Subject:  + device-dax-introduce-mapping-devices.patch added to -mm
 tree
Message-ID: <20200821232413.7gamPzg6x%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: introduce 'mapping' devices
has been added to the -mm tree.  Its filename is
     device-dax-introduce-mapping-devices.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-introduce-mapping-devices.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-introduce-mapping-devices.patch

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
Subject: device-dax: introduce 'mapping' devices

In support of interrogating the physical address layout of a device with
dis-contiguous ranges, introduce a sysfs directory with 'start', 'end',
and 'page_offset' attributes.  The alternative is trying to parse
/proc/iomem, and that file will not reflect the extent layout until the
device is enabled.

Link: https://lkml.kernel.org/r/159643104819.4062302.13691281391423291589.stgit@dwillia2-desk3.amr.corp.intel.com
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

 drivers/dax/bus.c         |  191 +++++++++++++++++++++++++++++++++++-
 drivers/dax/dax-private.h |   14 ++
 2 files changed, 203 insertions(+), 2 deletions(-)

--- a/drivers/dax/bus.c~device-dax-introduce-mapping-devices
+++ a/drivers/dax/bus.c
@@ -579,6 +579,167 @@ struct dax_region *alloc_dax_region(stru
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
 
+static void dax_mapping_release(struct device *dev)
+{
+	struct dax_mapping *mapping = to_dax_mapping(dev);
+	struct dev_dax *dev_dax = to_dev_dax(dev->parent);
+
+	ida_free(&dev_dax->ida, mapping->id);
+	kfree(mapping);
+}
+
+static void unregister_dax_mapping(void *data)
+{
+	struct device *dev = data;
+	struct dax_mapping *mapping = to_dax_mapping(dev);
+	struct dev_dax *dev_dax = to_dev_dax(dev->parent);
+	struct dax_region *dax_region = dev_dax->region;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	device_lock_assert(dax_region->dev);
+
+	dev_dax->ranges[mapping->range_id].mapping = NULL;
+	mapping->range_id = -1;
+
+	device_del(dev);
+	put_device(dev);
+}
+
+static struct dev_dax_range *get_dax_range(struct device *dev)
+{
+	struct dax_mapping *mapping = to_dax_mapping(dev);
+	struct dev_dax *dev_dax = to_dev_dax(dev->parent);
+	struct dax_region *dax_region = dev_dax->region;
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
+	struct dax_mapping *mapping = dax_range->mapping;
+	struct dev_dax *dev_dax = to_dev_dax(mapping->dev.parent);
+	struct dax_region *dax_region = dev_dax->region;
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
+	dax_range = get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc = sprintf(buf, "%#llx\n", dax_range->range.start);
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
+	dax_range = get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc = sprintf(buf, "%#llx\n", dax_range->range.end);
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
+	dax_range = get_dax_range(dev);
+	if (!dax_range)
+		return -ENXIO;
+	rc = sprintf(buf, "%#lx\n", dax_range->pgoff);
+	put_dax_range(dax_range);
+
+	return rc;
+}
+static DEVICE_ATTR(page_offset, 0400, pgoff_show, NULL);
+
+static struct attribute *dax_mapping_attributes[] = {
+	&dev_attr_start.attr,
+	&dev_attr_end.attr,
+	&dev_attr_page_offset.attr,
+	NULL,
+};
+
+static const struct attribute_group dax_mapping_attribute_group = {
+	.attrs = dax_mapping_attributes,
+};
+
+static const struct attribute_group *dax_mapping_attribute_groups[] = {
+	&dax_mapping_attribute_group,
+	NULL,
+};
+
+static struct device_type dax_mapping_type = {
+	.release = dax_mapping_release,
+	.groups = dax_mapping_attribute_groups,
+};
+
+static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
+{
+	struct dax_region *dax_region = dev_dax->region;
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
+	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
+	if (!mapping)
+		return -ENOMEM;
+	mapping->range_id = range_id;
+	mapping->id = ida_alloc(&dev_dax->ida, GFP_KERNEL);
+	if (mapping->id < 0) {
+		kfree(mapping);
+		return -ENOMEM;
+	}
+	dev_dax->ranges[range_id].mapping = mapping;
+	dev = &mapping->dev;
+	device_initialize(dev);
+	dev->parent = &dev_dax->dev;
+	dev->type = &dax_mapping_type;
+	dev_set_name(dev, "mapping%d", mapping->id);
+	rc = device_add(dev);
+	if (rc) {
+		put_device(dev);
+		return rc;
+	}
+
+	rc = devm_add_action_or_reset(dax_region->dev, unregister_dax_mapping,
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
 	unsigned long pgoff = 0;
 	struct resource *alloc;
-	int i;
+	int i, rc;
 
 	device_lock_assert(dax_region->dev);
 
@@ -630,6 +791,22 @@ static int alloc_dev_dax_range(struct de
 
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
+	rc = devm_register_dax_mapping(dev_dax, dev_dax->nr_range - 1);
+	if (rc) {
+		dev_dbg(dev, "delete range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
+				&alloc->start, &alloc->end);
+		dev_dax->nr_range--;
+		__release_region(res, alloc->start, resource_size(alloc));
+		return rc;
+	}
 
 	return 0;
 }
@@ -698,11 +875,14 @@ static int dev_dax_shrink(struct dev_dax
 
 	for (i = dev_dax->nr_range - 1; i >= 0; i--) {
 		struct range *range = &dev_dax->ranges[i].range;
+		struct dax_mapping *mapping = dev_dax->ranges[i].mapping;
 		struct resource *adjust = NULL, *res;
 		resource_size_t shrink;
 
 		shrink = min_t(u64, to_shrink, range_len(range));
 		if (shrink >= range_len(range)) {
+			devm_release_action(dax_region->dev,
+					unregister_dax_mapping, &mapping->dev);
 			__release_region(&dax_region->res, range->start,
 					range_len(range));
 			dev_dax->nr_range--;
@@ -1033,9 +1213,9 @@ struct dev_dax *devm_create_dev_dax(stru
 	/* a device_dax instance is dead while the driver is not attached */
 	kill_dax(dax_dev);
 
-	/* from here on we're committed to teardown via dev_dax_release() */
 	dev_dax->dax_dev = dax_dev;
 	dev_dax->target_node = dax_region->target_node;
+	ida_init(&dev_dax->ida);
 	kref_get(&dax_region->kref);
 
 	inode = dax_inode(dax_dev);
@@ -1058,6 +1238,13 @@ struct dev_dax *devm_create_dev_dax(stru
 	if (rc)
 		return ERR_PTR(rc);
 
+	/* register mapping device for the initial allocation range */
+	if (dev_dax->nr_range && range_len(&dev_dax->ranges[0].range)) {
+		rc = devm_register_dax_mapping(dev_dax, 0);
+		if (rc)
+			return ERR_PTR(rc);
+	}
+
 	return dev_dax;
 
 err_alloc_dax:
--- a/drivers/dax/dax-private.h~device-dax-introduce-mapping-devices
+++ a/drivers/dax/dax-private.h
@@ -40,6 +40,12 @@ struct dax_region {
 	struct device *youngest;
 };
 
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
device-dax-kill-dax_kmem_res.patch
device-dax-add-an-allocation-interface-for-device-dax-instances.patch
device-dax-introduce-seed-devices.patch
drivers-base-make-device_find_child_by_name-compatible-with-sysfs-inputs.patch
device-dax-add-resize-support.patch
mm-memremap_pages-convert-to-struct-range.patch
mm-memremap_pages-support-multiple-ranges-per-invocation.patch
device-dax-add-dis-contiguous-resource-support.patch
device-dax-introduce-mapping-devices.patch

