Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC19C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 21:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377119AbhLBVgT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Dec 2021 16:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377097AbhLBVgT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Dec 2021 16:36:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB12C06174A
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 13:32:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42C01CE2474
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 21:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CB9C00446;
        Thu,  2 Dec 2021 21:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638480772;
        bh=hWZIOqVzowhjHmpAwFET6Yt3fbqIN6PrNdoUaFI3+D8=;
        h=Date:From:To:Subject:From;
        b=qKbIS/IKhvyoaJzHJmwOfJFFyIB2xG9IO0wfQKCiQXwuWAXMoY67SjBXrPYyOU1kt
         tf//A6ZL/yC5biR7Nv5HUGsWGri0qwE7w5NMUN78HOnCqPueqBu2Rdj8pXk5EfTlYM
         EoTsy1WcvzYgbc0D8A/AofMRCLhDRdTIukqzsLj0=
Date:   Thu, 02 Dec 2021 13:32:51 -0800
From:   akpm@linux-foundation.org
To:     corbet@lwn.net, dan.j.williams@intel.com, dave.jiang@intel.com,
        hch@lst.de, jane.chu@oracle.com, jgg@nvidia.com, jgg@ziepe.ca,
        jhubbard@nvidia.com, joao.m.martins@oracle.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, songmuchun@bytedance.com,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  +
 device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch added to
 -mm tree
Message-ID: <20211202213251.EaNts0ZoK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: ensure dev_dax->pgmap is valid for dynamic devices
has been added to the -mm tree.  Its filename is
     device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch

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
Subject: device-dax: ensure dev_dax->pgmap is valid for dynamic devices

Right now, only static dax regions have a valid @pgmap pointer in its
struct dev_dax.  Dynamic dax case however, do not.

In preparation for device-dax compound devmap support, make sure that
dev_dax pgmap field is set after it has been allocated and initialized.

dynamic dax device have the @pgmap is allocated at probe() and it's
managed by devm (contrast to static dax region which a pgmap is provided
and dax core kfrees it).  So in addition to ensure a valid @pgmap, clear
the pgmap when the dynamic dax device is released to avoid the same pgmap
ranges to be re-requested across multiple region device reconfigs.

Add a static_dev_dax() and use that helper in dev_dax_probe() to ensure
the initialization differences between dynamic and static regions are more
explicit.  While at it, consolidate the ranges initialization when we
allocate the @pgmap for the dynamic dax region case.  Also take the
opportunity to document the differences between static and dynamic da
regions.

Link: https://lkml.kernel.org/r/20211202204422.26777-8-joao.m.martins@oracle.com
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c    |   32 ++++++++++++++++++++++++++++++++
 drivers/dax/bus.h    |    1 +
 drivers/dax/device.c |   29 +++++++++++++++++++++--------
 3 files changed, 54 insertions(+), 8 deletions(-)

--- a/drivers/dax/bus.c~device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices
+++ a/drivers/dax/bus.c
@@ -129,11 +129,35 @@ ATTRIBUTE_GROUPS(dax_drv);
 
 static int dax_bus_match(struct device *dev, struct device_driver *drv);
 
+/*
+ * Static dax regions are regions created by an external subsystem
+ * nvdimm where a single range is assigned. Its boundaries are by the external
+ * subsystem and are usually limited to one physical memory range. For example,
+ * for PMEM it is usually defined by NVDIMM Namespace boundaries (i.e. a
+ * single contiguous range)
+ *
+ * On dynamic dax regions, the assigned region can be partitioned by dax core
+ * into multiple subdivisions. A subdivision is represented into one
+ * /dev/daxN.M device composed by one or more potentially discontiguous ranges.
+ *
+ * When allocating a dax region, drivers must set whether it's static
+ * (IORESOURCE_DAX_STATIC).  On static dax devices, the @pgmap is pre-assigned
+ * to dax core when calling devm_create_dev_dax(), whereas in dynamic dax
+ * devices it is NULL but afterwards allocated by dax core on device ->probe().
+ * Care is needed to make sure that dynamic dax devices are torn down with a
+ * cleared @pgmap field (see kill_dev_dax()).
+ */
 static bool is_static(struct dax_region *dax_region)
 {
 	return (dax_region->res.flags & IORESOURCE_DAX_STATIC) != 0;
 }
 
+bool static_dev_dax(struct dev_dax *dev_dax)
+{
+	return is_static(dev_dax->region);
+}
+EXPORT_SYMBOL_GPL(static_dev_dax);
+
 static u64 dev_dax_size(struct dev_dax *dev_dax)
 {
 	u64 size = 0;
@@ -363,6 +387,14 @@ void kill_dev_dax(struct dev_dax *dev_da
 
 	kill_dax(dax_dev);
 	unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+	/*
+	 * Dynamic dax region have the pgmap allocated via dev_kzalloc()
+	 * and thus freed by devm. Clear the pgmap to not have stale pgmap
+	 * ranges on probe() from previous reconfigurations of region devices.
+	 */
+	if (!static_dev_dax(dev_dax))
+		dev_dax->pgmap = NULL;
 }
 EXPORT_SYMBOL_GPL(kill_dev_dax);
 
--- a/drivers/dax/bus.h~device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices
+++ a/drivers/dax/bus.h
@@ -48,6 +48,7 @@ int __dax_driver_register(struct dax_dev
 	__dax_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
 void dax_driver_unregister(struct dax_device_driver *dax_drv);
 void kill_dev_dax(struct dev_dax *dev_dax);
+bool static_dev_dax(struct dev_dax *dev_dax);
 
 #if IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
 int dev_dax_probe(struct dev_dax *dev_dax);
--- a/drivers/dax/device.c~device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices
+++ a/drivers/dax/device.c
@@ -398,18 +398,34 @@ int dev_dax_probe(struct dev_dax *dev_da
 	void *addr;
 	int rc, i;
 
-	pgmap = dev_dax->pgmap;
-	if (dev_WARN_ONCE(dev, pgmap && dev_dax->nr_range > 1,
-			"static pgmap / multi-range device conflict\n"))
-		return -EINVAL;
+	if (static_dev_dax(dev_dax))  {
+		if (dev_dax->nr_range > 1) {
+			dev_warn(dev,
+				"static pgmap / multi-range device conflict\n");
+			return -EINVAL;
+		}
+
+		pgmap = dev_dax->pgmap;
+	} else {
+		if (dev_dax->pgmap) {
+			dev_warn(dev,
+				 "dynamic-dax with pre-populated page map\n");
+			return -EINVAL;
+		}
 
-	if (!pgmap) {
 		pgmap = devm_kzalloc(dev,
                        struct_size(pgmap, ranges, dev_dax->nr_range - 1),
                        GFP_KERNEL);
 		if (!pgmap)
 			return -ENOMEM;
+
 		pgmap->nr_range = dev_dax->nr_range;
+		dev_dax->pgmap = pgmap;
+
+		for (i = 0; i < dev_dax->nr_range; i++) {
+			struct range *range = &dev_dax->ranges[i].range;
+			pgmap->ranges[i] = *range;
+		}
 	}
 
 	for (i = 0; i < dev_dax->nr_range; i++) {
@@ -421,9 +437,6 @@ int dev_dax_probe(struct dev_dax *dev_da
 					i, range->start, range->end);
 			return -EBUSY;
 		}
-		/* don't update the range for static pgmap */
-		if (!dev_dax->pgmap)
-			pgmap->ranges[i] = *range;
 	}
 
 	pgmap->type = MEMORY_DEVICE_GENERIC;
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-page_alloc-split-prep_compound_page-into-head-and-tail-subparts.patch
mm-page_alloc-refactor-memmap_init_zone_device-page-init.patch
mm-memremap-add-zone_device-support-for-compound-pages.patch
device-dax-use-align-for-determining-pgoff.patch
device-dax-use-struct_size.patch
device-dax-ensure-dev_dax-pgmap-is-valid-for-dynamic-devices.patch
device-dax-factor-out-page-mapping-initialization.patch
device-dax-set-mapping-prior-to-vmf_insert_pfn_pmdpud.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault.patch
device-dax-compound-devmap-support.patch

