Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0503AC4727C
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C46EA21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 02:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601087145;
	bh=D2nDJ5CqlWZdyJmjITOVcN4D7NJ6V7ZHTCnmJigKELU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ZFPprEBG7BQCQny40rkGkLh7BZarggCXgfycQu3VMA++C8b2WKKEtlD2LqfGxz0Vi
	 iuL0F2tpPFHD8AYckWX2pAnWgi70ZNU3evpsYtOLakR/pSZStcdTB0Y4p6/7fLwJEd
	 XFWYm11ctG44mhKwHnQ/oLnDrQwlNflDt5zCjoJE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgIZCZp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 22:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729960AbgIZCZp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 22:25:45 -0400
Received: from X1 (unknown [104.245.68.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2730D20936;
        Sat, 26 Sep 2020 02:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601087144;
        bh=D2nDJ5CqlWZdyJmjITOVcN4D7NJ6V7ZHTCnmJigKELU=;
        h=Date:From:To:Subject:From;
        b=dvLuEJxw1AJ3pHY9Ius7dJyhNSjCvB2GewYbMjFTKrAsyLMJERxRzcFm4MZhGr5U+
         WQBe9T28LpCjXlPSYc50V/XZggxutnIu2DhIdT+mABBJpVdCEkCZdYb5S5f2ZyITgQ
         hXNwUN27oOscMtNOCz+ebrRSjvh7iRmj34Sib8xw=
Date:   Fri, 25 Sep 2020 19:25:41 -0700
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
Subject:  + device-dax-add-an-align-attribute.patch added to -mm tree
Message-ID: <20200926022541.tJzu-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: add an 'align' attribute
has been added to the -mm tree.  Its filename is
     device-dax-add-an-align-attribute.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-an-align-attri=
bute.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-an-align-attri=
bute.patch

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
Subject: device-dax: add an 'align' attribute

Introduce a device align attribute.  While doing so, rename the region
align attribute to be more explicitly named as so, but keep it named as
@align to retain the API for tools like daxctl.

Changes on align may not always be valid, when say certain mappings were
created with 2M and then we switch to 1G.  So, we validate all ranges
against the new value being attempted, post resizing.

Link: https://lkml.kernel.org/r/159643105944.4062302.3131761052969132784.st=
git@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-3-joao.m.martins@oracl=
e.com
Link: https://lkml.kernel.org/r/160106118486.30709.13012322227204800596.stg=
it@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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

 drivers/dax/bus.c         |   93 ++++++++++++++++++++++++++++++++----
 drivers/dax/dax-private.h |   18 ++++++
 2 files changed, 101 insertions(+), 10 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-an-align-attribute
+++ a/drivers/dax/bus.c
@@ -230,14 +230,15 @@ static ssize_t region_size_show(struct d
 static struct device_attribute dev_attr_region_size =3D __ATTR(size, 0444,
 		region_size_show, NULL);
=20
-static ssize_t align_show(struct device *dev,
+static ssize_t region_align_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct dax_region *dax_region =3D dev_get_drvdata(dev);
=20
 	return sprintf(buf, "%u\n", dax_region->align);
 }
-static DEVICE_ATTR_RO(align);
+static struct device_attribute dev_attr_region_align =3D
+		__ATTR(align, 0400, region_align_show, NULL);
=20
 #define for_each_dax_region_resource(dax_region, res) \
 	for (res =3D (dax_region)->res.child; res; res =3D res->sibling)
@@ -488,7 +489,7 @@ static umode_t dax_region_visible(struct
 static struct attribute *dax_region_attributes[] =3D {
 	&dev_attr_available_size.attr,
 	&dev_attr_region_size.attr,
-	&dev_attr_align.attr,
+	&dev_attr_region_align.attr,
 	&dev_attr_create.attr,
 	&dev_attr_seed.attr,
 	&dev_attr_delete.attr,
@@ -858,15 +859,13 @@ static ssize_t size_show(struct device *
 	return sprintf(buf, "%llu\n", size);
 }
=20
-static bool alloc_is_aligned(struct dax_region *dax_region,
-		resource_size_t size)
+static bool alloc_is_aligned(struct dev_dax *dev_dax, resource_size_t size)
 {
 	/*
 	 * The minimum mapping granularity for a device instance is a
 	 * single subsection, unless the arch says otherwise.
 	 */
-	return IS_ALIGNED(size, max_t(unsigned long, dax_region->align,
-				memremap_compat_align()));
+	return IS_ALIGNED(size, max_t(unsigned long, dev_dax->align, memremap_com=
pat_align()));
 }
=20
 static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
@@ -961,7 +960,7 @@ static ssize_t dev_dax_resize(struct dax
 		return dev_dax_shrink(dev_dax, size);
=20
 	to_alloc =3D size - dev_size;
-	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dax_region, to_alloc),
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
 			"resize of %pa misaligned\n", &to_alloc))
 		return -ENXIO;
=20
@@ -1025,7 +1024,7 @@ static ssize_t size_store(struct device
 	if (rc)
 		return rc;
=20
-	if (!alloc_is_aligned(dax_region, val)) {
+	if (!alloc_is_aligned(dev_dax, val)) {
 		dev_dbg(dev, "%s: size: %lld misaligned\n", __func__, val);
 		return -EINVAL;
 	}
@@ -1044,6 +1043,78 @@ static ssize_t size_store(struct device
 }
 static DEVICE_ATTR_RW(size);
=20
+static ssize_t align_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax->align);
+}
+
+static ssize_t dev_dax_validate_align(struct dev_dax *dev_dax)
+{
+	resource_size_t dev_size =3D dev_dax_size(dev_dax);
+	struct device *dev =3D &dev_dax->dev;
+	int i;
+
+	if (dev_size > 0 && !alloc_is_aligned(dev_dax, dev_size)) {
+		dev_dbg(dev, "%s: align %u invalid for size %pa\n",
+			__func__, dev_dax->align, &dev_size);
+		return -EINVAL;
+	}
+
+	for (i =3D 0; i < dev_dax->nr_range; i++) {
+		size_t len =3D range_len(&dev_dax->ranges[i].range);
+
+		if (!alloc_is_aligned(dev_dax, len)) {
+			dev_dbg(dev, "%s: align %u invalid for range %d\n",
+				__func__, dev_dax->align, i);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static ssize_t align_store(struct device *dev, struct device_attribute *at=
tr,
+		const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax =3D to_dev_dax(dev);
+	struct dax_region *dax_region =3D dev_dax->region;
+	unsigned long val, align_save;
+	ssize_t rc;
+
+	rc =3D kstrtoul(buf, 0, &val);
+	if (rc)
+		return -ENXIO;
+
+	if (!dax_align_valid(val))
+		return -EINVAL;
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+
+	device_lock(dev);
+	if (dev->driver) {
+		rc =3D -EBUSY;
+		goto out_unlock;
+	}
+
+	align_save =3D dev_dax->align;
+	dev_dax->align =3D val;
+	rc =3D dev_dax_validate_align(dev_dax);
+	if (rc)
+		dev_dax->align =3D align_save;
+out_unlock:
+	device_unlock(dev);
+	device_unlock(dax_region->dev);
+	return rc =3D=3D 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(align);
+
 static int dev_dax_target_node(struct dev_dax *dev_dax)
 {
 	struct dax_region *dax_region =3D dev_dax->region;
@@ -1104,7 +1175,8 @@ static umode_t dev_dax_visible(struct ko
 		return 0;
 	if (a =3D=3D &dev_attr_numa_node.attr && !IS_ENABLED(CONFIG_NUMA))
 		return 0;
-	if (a =3D=3D &dev_attr_size.attr && is_static(dax_region))
+	if ((a =3D=3D &dev_attr_align.attr ||
+	     a =3D=3D &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
 	return a->mode;
 }
@@ -1113,6 +1185,7 @@ static struct attribute *dev_dax_attribu
 	&dev_attr_modalias.attr,
 	&dev_attr_size.attr,
 	&dev_attr_target_node.attr,
+	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
 	NULL,
--- a/drivers/dax/dax-private.h~device-dax-add-an-align-attribute
+++ a/drivers/dax/dax-private.h
@@ -87,4 +87,22 @@ static inline struct dax_mapping *to_dax
 }
=20
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsi=
gned long size);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool dax_align_valid(unsigned long align)
+{
+	if (align =3D=3D PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGE=
PAGE_PUD))
+		return true;
+	if (align =3D=3D PMD_SIZE && has_transparent_hugepage())
+		return true;
+	if (align =3D=3D PAGE_SIZE)
+		return true;
+	return false;
+}
+#else
+static inline bool dax_align_valid(unsigned long align)
+{
+	return align =3D=3D PAGE_SIZE;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
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

