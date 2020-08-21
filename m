Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E50C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212D0207C3
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 23:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598052267;
	bh=PkWqFsKaBNqfUtC5GcpEFzsFNYSxOWVnTnPn6r0A6BU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=T4AOZWecf6TxLUtlxvVK5Gt1tMvIwl/nbjLav79x/KnmthdIbLYMOgFW9QPsEwOiA
	 HSfL/gHgSaF+8Cn/s7xYdYfEGd3ZJPFVbS32ibEIuUm+vm+cRKPQo+rfnOQ9RyzzfL
	 IXYkstMFNpNADRoiVzmb5nG7ak+WkqzeVVtlT2zU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgHUXY0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Aug 2020 19:24:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbgHUXYZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 21 Aug 2020 19:24:25 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75FF3207CD;
        Fri, 21 Aug 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598052264;
        bh=PkWqFsKaBNqfUtC5GcpEFzsFNYSxOWVnTnPn6r0A6BU=;
        h=Date:From:To:Subject:From;
        b=SCZI45waO7qhWzHP04tgIph0SN1CdR2cpoPSmOVqa5yY3BfokL5ZrY2/n4Fx6mAeY
         8uMT7hGWV/k4T65KUoxkxAGsZk0UjlKLiulRPpMyoI6vHcVkDNSoIXrBi1nqxLTynt
         0CisCYZ4U76rvEz+w6WUFC0lYkAqQo1NMFK//pnc=
Date:   Fri, 21 Aug 2020 16:24:22 -0700
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
Subject:  + device-dax-add-an-align-attribute.patch added to -mm
 tree
Message-ID: <20200821232422.gj6EQ_DGF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: add an 'align' attribute
has been added to the -mm tree.  Its filename is
     device-dax-add-an-align-attribute.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-add-an-align-attribute.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-add-an-align-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: device-dax: add an 'align' attribute

Introduce a device align attribute.  While doing so, rename the region
align attribute to be more explicitly named as so, but keep it named as
@align to retain the API for tools like daxctl.

Changes on align may not always be valid, when say certain mappings were
created with 2M and then we switch to 1G.  So, we validate all ranges
against the new value being attempted, post resizing.

Link: https://lkml.kernel.org/r/159643105944.4062302.3131761052969132784.stgit@dwillia2-desk3.amr.corp.intel.com
Link: https://lore.kernel.org/r/20200716172913.19658-3-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |   93 ++++++++++++++++++++++++++++++++----
 drivers/dax/dax-private.h |   18 ++++++
 2 files changed, 101 insertions(+), 10 deletions(-)

--- a/drivers/dax/bus.c~device-dax-add-an-align-attribute
+++ a/drivers/dax/bus.c
@@ -230,14 +230,15 @@ static ssize_t region_size_show(struct d
 static struct device_attribute dev_attr_region_size = __ATTR(size, 0444,
 		region_size_show, NULL);
 
-static ssize_t align_show(struct device *dev,
+static ssize_t region_align_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%u\n", dax_region->align);
 }
-static DEVICE_ATTR_RO(align);
+static struct device_attribute dev_attr_region_align =
+		__ATTR(align, 0400, region_align_show, NULL);
 
 #define for_each_dax_region_resource(dax_region, res) \
 	for (res = (dax_region)->res.child; res; res = res->sibling)
@@ -488,7 +489,7 @@ static umode_t dax_region_visible(struct
 static struct attribute *dax_region_attributes[] = {
 	&dev_attr_available_size.attr,
 	&dev_attr_region_size.attr,
-	&dev_attr_align.attr,
+	&dev_attr_region_align.attr,
 	&dev_attr_create.attr,
 	&dev_attr_seed.attr,
 	&dev_attr_delete.attr,
@@ -855,15 +856,13 @@ static ssize_t size_show(struct device *
 	return sprintf(buf, "%llu\n", size);
 }
 
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
+	return IS_ALIGNED(size, max_t(unsigned long, dev_dax->align, memremap_compat_align()));
 }
 
 static int dev_dax_shrink(struct dev_dax *dev_dax, resource_size_t size)
@@ -958,7 +957,7 @@ static ssize_t dev_dax_resize(struct dax
 		return dev_dax_shrink(dev_dax, size);
 
 	to_alloc = size - dev_size;
-	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dax_region, to_alloc),
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
 			"resize of %pa misaligned\n", &to_alloc))
 		return -ENXIO;
 
@@ -1022,7 +1021,7 @@ static ssize_t size_store(struct device
 	if (rc)
 		return rc;
 
-	if (!alloc_is_aligned(dax_region, val)) {
+	if (!alloc_is_aligned(dev_dax, val)) {
 		dev_dbg(dev, "%s: size: %lld misaligned\n", __func__, val);
 		return -EINVAL;
 	}
@@ -1041,6 +1040,78 @@ static ssize_t size_store(struct device
 }
 static DEVICE_ATTR_RW(size);
 
+static ssize_t align_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax->align);
+}
+
+static ssize_t dev_dax_validate_align(struct dev_dax *dev_dax)
+{
+	resource_size_t dev_size = dev_dax_size(dev_dax);
+	struct device *dev = &dev_dax->dev;
+	int i;
+
+	if (dev_size > 0 && !alloc_is_aligned(dev_dax, dev_size)) {
+		dev_dbg(dev, "%s: align %u invalid for size %pa\n",
+			__func__, dev_dax->align, &dev_size);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		size_t len = range_len(&dev_dax->ranges[i].range);
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
+static ssize_t align_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_region *dax_region = dev_dax->region;
+	unsigned long val, align_save;
+	ssize_t rc;
+
+	rc = kstrtoul(buf, 0, &val);
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
+		rc = -EBUSY;
+		goto out_unlock;
+	}
+
+	align_save = dev_dax->align;
+	dev_dax->align = val;
+	rc = dev_dax_validate_align(dev_dax);
+	if (rc)
+		dev_dax->align = align_save;
+out_unlock:
+	device_unlock(dev);
+	device_unlock(dax_region->dev);
+	return rc == 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(align);
+
 static int dev_dax_target_node(struct dev_dax *dev_dax)
 {
 	struct dax_region *dax_region = dev_dax->region;
@@ -1101,7 +1172,8 @@ static umode_t dev_dax_visible(struct ko
 		return 0;
 	if (a == &dev_attr_numa_node.attr && !IS_ENABLED(CONFIG_NUMA))
 		return 0;
-	if (a == &dev_attr_size.attr && is_static(dax_region))
+	if ((a == &dev_attr_align.attr ||
+	     a == &dev_attr_size.attr) && is_static(dax_region))
 		return 0444;
 	return a->mode;
 }
@@ -1110,6 +1182,7 @@ static struct attribute *dev_dax_attribu
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
 
 phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff, unsigned long size);
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline bool dax_align_valid(unsigned int align)
+{
+	if (align == PUD_SIZE && IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+		return true;
+	if (align == PMD_SIZE && has_transparent_hugepage())
+		return true;
+	if (align == PAGE_SIZE)
+		return true;
+	return false;
+}
+#else
+static inline bool dax_align_valid(unsigned int align)
+{
+	return align == PAGE_SIZE;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

device-dax-make-align-a-per-device-property.patch
device-dax-add-an-align-attribute.patch
dax-hmem-introduce-dax_hmemregion_idle-parameter.patch
device-dax-add-a-range-mapping-allocation-attribute.patch

