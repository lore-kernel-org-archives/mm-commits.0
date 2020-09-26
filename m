Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2C3C4727D
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F263221741
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087113;
	bh=7KxMbXNapWKJyf7nRof8ivSo0P0epUDqVwqMoyyOkoM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=0QassoZARHQzIf/WBDA0KOFsZSiy1RSxCyriVrlQqFctU3rXScT6n2fYmbTniMLcF
	 E504kgGXPW6DZH9aeH+EFoHer+0JGrNzZgRNBNU47wo+3f7SRJuZCBOPCpv3f8L44D
	 V48LwK9a/PBQXpxS4wANCTWgCCwL8FNwO/S8Yv9U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgIZCZM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgIZCZM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:12 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 299B520936;
        Sat, 26 Sep 2020 02:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087111;
        bh=7KxMbXNapWKJyf7nRof8ivSo0P0epUDqVwqMoyyOkoM=;
        h=Date:From:To:Subject:From;
        b=ouAUdhTtix824Y7mF0LxeeePqIpHVpZSn2IsXHRjELAVRdjQo1VeMr2Q6REvWTEZF
         wOV/urN0n3wavjhxYIduCllDnGgw4Hn1IpB4KTJZfuTwij1XQTC/7H07OgcNE4QBvY
         Kp/V8yRdMBjiOagNDiQJZwe/SiafaA0BLDz8Ay+w=
Date:   Fri, 25 Sep 2020 19:25:08 -0700
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
Subject:  + device-dax-add-resize-support.patch added to -mm tree
Message-ID: <20200926022508.StSrw%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: add resize support
has been added to the -mm tree.  Its filename is
     device-dax-add-resize-support.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-resize-support=
.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-resize-support=
.patch

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
Subject: device-dax: add resize support

Make the device-dax 'size' attribute writable to allow capacity to be
split between multiple instances in a region.  The intended consumers of
this capability are users that want to split a scarce memory resource
between device-dax and System-RAM access, or users that want to have
multiple security domains for a large region.

By default the hmem instance provider allocates an entire region to the
first instance.  The process of creating a new instance (assuming a
region-id of 0) is find the region and trigger the 'create' attribute
which yields an empty instance to configure.  For example:

    cd /sys/bus/dax/devices
    echo dax0.0 > dax0.0/driver/unbind
    echo $new_size > dax0.0/size
    echo 1 > $(readlink -f dax0.0)../dax_region/create
    seed=3D$(cat $(readlink -f dax0.0)../dax_region/seed)
    echo $new_size > $seed/size
    echo dax0.0 > ../drivers/{device_dax,kmem}/bind
    echo dax0.1 > ../drivers/{device_dax,kmem}/bind

Instances can be destroyed by:

    echo $device > $(readlink -f $device)../dax_region/delete

Link: https://lkml.kernel.org/r/159643102625.4062302.7431838945566033852.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lkml.kernel.org/r/160106115239.30709.9850106928133493138.stgi=
t@dwillia2-desk3.amr.corp.intel.com
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

 drivers/dax/bus.c |  161 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 152 insertions(+), 9 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-resize-support
+++ a/drivers/dax/bus.c
@@ -6,6 +6,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/dax.h>
+#include <linux/io.h>
 #include "dax-private.h"
 #include "bus.h"
=20
@@ -562,7 +563,8 @@ struct dax_region *alloc_dax_region(stru
 }
 EXPORT_SYMBOL_GPL(alloc_dax_region);
=20
-static int alloc_dev_dax_range(struct dev_dax *dev_dax, resource_size_t si=
ze)
+static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
+		resource_size_t size)
 {
 	struct dax_region *dax_region =3D dev_dax->region;
 	struct resource *res =3D &dax_region->res;
@@ -580,12 +582,7 @@ static int alloc_dev_dax_range(struct de
 		return 0;
 	}
=20
-	/* TODO: handle multiple allocations per region */
-	if (res->child)
-		return -ENOMEM;
-
-	alloc =3D __request_region(res, res->start, size, dev_name(dev), 0);
-
+	alloc =3D __request_region(res, start, size, dev_name(dev), 0);
 	if (!alloc)
 		return -ENOMEM;
=20
@@ -597,6 +594,29 @@ static int alloc_dev_dax_range(struct de
 	return 0;
 }
=20
+static int adjust_dev_dax_range(struct dev_dax *dev_dax, struct resource *=
res, resource_size_t size)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct range *range =3D &dev_dax->range;
+	int rc =3D 0;
+
+	device_lock_assert(dax_region->dev);
+
+	if (size)
+		rc =3D adjust_resource(res, range->start, size);
+	else
+		__release_region(&dax_region->res, range->start, range_len(range));
+	if (rc)
+		return rc;
+
+	dev_dax->range =3D (struct range) {
+		.start =3D range->start,
+		.end =3D range->start + size - 1,
+	};
+
+	return 0;
+}
+
 static ssize_t size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -605,7 +625,127 @@ static ssize_t size_show(struct device *
=20
 	return sprintf(buf, "%llu\n", size);
 }
-static DEVICE_ATTR_RO(size);
+
+static bool alloc_is_aligned(struct dax_region *dax_region,
+		resource_size_t size)
+{
+	/*
+	 * The minimum mapping granularity for a device instance is a
+	 * single subsection, unless the arch says otherwise.
+	 */
+	return IS_ALIGNED(size, max_t(unsigned long, dax_region->align,
+				memremap_compat_align()));
+}
+
+static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
+{
+	struct dax_region *dax_region =3D dev_dax->region;
+	struct range *range =3D &dev_dax->range;
+	struct resource *res, *adjust =3D NULL;
+	struct device *dev =3D &dev_dax->dev;
+
+	for_each_dax_region_resource(dax_region, res)
+		if (strcmp(res->name, dev_name(dev)) =3D=3D 0
+				&& res->start =3D=3D range->start) {
+			adjust =3D res;
+			break;
+		}
+
+	if (dev_WARN_ONCE(dev, !adjust, "failed to find matching resource\n"))
+		return -ENXIO;
+	return adjust_dev_dax_range(dev_dax, adjust, size);
+}
+
+static ssize_t dev_dax_resize(struct dax_region *dax_region,
+		struct dev_dax *dev_dax, resource_size_t size)
+{
+	resource_size_t avail =3D dax_region_avail_size(dax_region), to_alloc;
+	resource_size_t dev_size =3D range_len(&dev_dax->range);
+	struct resource *region_res =3D &dax_region->res;
+	struct device *dev =3D &dev_dax->dev;
+	const char *name =3D dev_name(dev);
+	struct resource *res, *first;
+
+	if (dev->driver)
+		return -EBUSY;
+	if (size =3D=3D dev_size)
+		return 0;
+	if (size > dev_size && size - dev_size > avail)
+		return -ENOSPC;
+	if (size < dev_size)
+		return dev_dax_shrink(dev_dax, size);
+
+	to_alloc =3D size - dev_size;
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dax_region, to_alloc),
+			"resize of %pa misaligned\n", &to_alloc))
+		return -ENXIO;
+
+	/*
+	 * Expand the device into the unused portion of the region. This
+	 * may involve adjusting the end of an existing resource, or
+	 * allocating a new resource.
+	 */
+	first =3D region_res->child;
+	if (!first)
+		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+	for (res =3D first; to_alloc && res; res =3D res->sibling) {
+		struct resource *next =3D res->sibling;
+		resource_size_t free;
+
+		/* space at the beginning of the region */
+		free =3D 0;
+		if (res =3D=3D first && res->start > dax_region->res.start)
+			free =3D res->start - dax_region->res.start;
+		if (free >=3D to_alloc && dev_size =3D=3D 0)
+			return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc);
+
+		free =3D 0;
+		/* space between allocations */
+		if (next && next->start > res->end + 1)
+			free =3D next->start - res->end + 1;
+
+		/* space at the end of the region */
+		if (free < to_alloc && !next && res->end < region_res->end)
+			free =3D region_res->end - res->end;
+
+		if (free >=3D to_alloc && strcmp(name, res->name) =3D=3D 0)
+			return adjust_dev_dax_range(dev_dax, res, resource_size(res) + to_alloc=
);
+		else if (free >=3D to_alloc && dev_size =3D=3D 0)
+			return alloc_dev_dax_range(dev_dax, res->end + 1, to_alloc);
+	}
+	return -ENOSPC;
+}
+
+static ssize_t size_store(struct device *dev, struct device_attribute *att=
r,
+		const char *buf, size_t len)
+{
+	ssize_t rc;
+	unsigned long long val;
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
+
+	rc =3D kstrtoull(buf, 0, &val);
+	if (rc)
+		return rc;
+
+	if (!alloc_is_aligned(dax_region, val)) {
+		dev_dbg(dev, "%s: size: %lld misaligned\n", __func__, val);
+		return -EINVAL;
+	}
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+	device_lock(dev);
+	rc =3D dev_dax_resize(dax_region, dev_dax, val);
+	device_unlock(dev);
+	device_unlock(dax_region->dev);
+
+	return rc =3D=3D 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(size);
=20
 static int dev_dax_target_node(struct dev_dax *dev_dax)
 {
@@ -654,11 +794,14 @@ static umode_t dev_dax_visible(struct ko
 {
 	struct device *dev =3D container_of(kobj, struct device, kobj);
 	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
=20
 	if (a =3D=3D &dev_attr_target_node.attr && dev_dax_target_node(dev_dax) <=
 0)
 		return 0;
 	if (a =3D=3D &dev_attr_numa_node.attr && !IS_ENABLED(CONFIG_NUMA))
 		return 0;
+	if (a =3D=3D &dev_attr_size.attr && is_static(dax_region))
+		return 0444;
 	return a->mode;
 }
=20
@@ -739,7 +882,7 @@ struct dev_dax *devm_create_dev_dax(stru
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
=20
-	rc =3D alloc_dev_dax_range(dev_dax, data->size);
+	rc =3D alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
 	if (rc)
 		goto err_range;
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

