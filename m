Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DD8E728DB
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 19:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjI2TXD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbjI2TW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 15:22:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC8A1B1
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 12:22:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64B1C433C8;
        Fri, 29 Sep 2023 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696015374;
        bh=FR2lmy2ePQDbTgzOzLhzg4R4ZvLKKx/eyU6b6GB2ruQ=;
        h=Date:To:From:Subject:From;
        b=tUaGh4EQbyKoOyhK/N6nnrrEsy0P+K9diiTUxHElk0LqyLv4U6HI2flK/xBFQ6z7J
         /CPIDYaqSLLVCGBZ7opavr9lkMWtuXcOAc/ldC1ES5lOELMn65G5B0Gg5+yBIhH0S9
         IMSFoktLITRPQUE0sT5P99P+4jvMdnOiMPyI9xY8=
Date:   Fri, 29 Sep 2023 12:22:54 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        osalvador@suse.de, mhocko@suse.com, Jonathan.Cameron@huawei.com,
        jmoyer@redhat.com, david@redhat.com, dave.jiang@intel.com,
        dave.hansen@linux.intel.com, dan.j.williams@intel.com,
        aneesh.kumar@linux.ibm.com, vishal.l.verma@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory.patch added to mm-unstable branch
Message-Id: <20230929192254.D64B1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax/kmem: allow kmem to add memory with memmap_on_memory
has been added to the -mm mm-unstable branch.  Its filename is
     dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/kmem: allow kmem to add memory with memmap_on_memory
Date: Thu, 28 Sep 2023 14:30:11 -0600

Large amounts of memory managed by the kmem driver may come in via CXL,
and it is often desirable to have the memmap for this memory on the new
memory itself.

Enroll kmem-managed memory for memmap_on_memory semantics if the dax
region originates via CXL.  For non-CXL dax regions, retain the existing
default behavior of hot adding without memmap_on_memory semantics.

Add a sysfs override under the dax device to control this behavior and
override either default.

Link: https://lkml.kernel.org/r/20230928-vv-kmem_memmap-v4-2-6ff73fec519a@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |   38 ++++++++++++++++++++++++++++++++++++
 drivers/dax/bus.h         |    1 
 drivers/dax/cxl.c         |    1 
 drivers/dax/dax-private.h |    1 
 drivers/dax/hmem/hmem.c   |    1 
 drivers/dax/kmem.c        |    8 ++++++-
 drivers/dax/pmem.c        |    1 
 7 files changed, 50 insertions(+), 1 deletion(-)

--- a/drivers/dax/bus.c~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/bus.c
@@ -367,6 +367,7 @@ static ssize_t create_store(struct devic
 			.dax_region = dax_region,
 			.size = 0,
 			.id = -1,
+			.memmap_on_memory = false,
 		};
 		struct dev_dax *dev_dax = devm_create_dev_dax(&data);
 
@@ -1269,6 +1270,40 @@ static ssize_t numa_node_show(struct dev
 }
 static DEVICE_ATTR_RO(numa_node);
 
+static ssize_t memmap_on_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sprintf(buf, "%d\n", dev_dax->memmap_on_memory);
+}
+
+static ssize_t memmap_on_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_region *dax_region = dev_dax->region;
+	ssize_t rc;
+	bool val;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	device_lock(dax_region->dev);
+	if (!dax_region->dev->driver) {
+		device_unlock(dax_region->dev);
+		return -ENXIO;
+	}
+
+	dev_dax->memmap_on_memory = val;
+
+	device_unlock(dax_region->dev);
+	return rc == 0 ? len : rc;
+}
+static DEVICE_ATTR_RW(memmap_on_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1295,6 +1330,7 @@ static struct attribute *dev_dax_attribu
 	&dev_attr_align.attr,
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
+	&dev_attr_memmap_on_memory.attr,
 	NULL,
 };
 
@@ -1400,6 +1436,8 @@ struct dev_dax *devm_create_dev_dax(stru
 	dev_dax->align = dax_region->align;
 	ida_init(&dev_dax->ida);
 
+	dev_dax->memmap_on_memory = data->memmap_on_memory;
+
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
 	dev->bus = &dax_bus_type;
--- a/drivers/dax/bus.h~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/bus.h
@@ -23,6 +23,7 @@ struct dev_dax_data {
 	struct dev_pagemap *pgmap;
 	resource_size_t size;
 	int id;
+	bool memmap_on_memory;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
--- a/drivers/dax/cxl.c~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/cxl.c
@@ -26,6 +26,7 @@ static int cxl_dax_region_probe(struct d
 		.dax_region = dax_region,
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
+		.memmap_on_memory = true,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
--- a/drivers/dax/dax-private.h~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/dax-private.h
@@ -70,6 +70,7 @@ struct dev_dax {
 	struct ida ida;
 	struct device dev;
 	struct dev_pagemap *pgmap;
+	bool memmap_on_memory;
 	int nr_range;
 	struct dev_dax_range {
 		unsigned long pgoff;
--- a/drivers/dax/hmem/hmem.c~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/hmem/hmem.c
@@ -36,6 +36,7 @@ static int dax_hmem_probe(struct platfor
 		.dax_region = dax_region,
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
+		.memmap_on_memory = false,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
--- a/drivers/dax/kmem.c~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/kmem.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/memory-tiers.h>
+#include <linux/memory_hotplug.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -93,6 +94,7 @@ static int dev_dax_kmem_probe(struct dev
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
+	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
 
@@ -179,12 +181,16 @@ static int dev_dax_kmem_probe(struct dev
 		 */
 		res->flags = IORESOURCE_SYSTEM_RAM;
 
+		mhp_flags = MHP_NID_IS_MGID;
+		if (dev_dax->memmap_on_memory)
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+
 		/*
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
 		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, MHP_NID_IS_MGID);
+				range_len(&range), kmem_name, mhp_flags);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
--- a/drivers/dax/pmem.c~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/pmem.c
@@ -63,6 +63,7 @@ static struct dev_dax *__dax_pmem_probe(
 		.id = id,
 		.pgmap = &pgmap,
 		.size = range_len(&range),
+		.memmap_on_memory = false,
 	};
 
 	return devm_create_dev_dax(&data);
_

Patches currently in -mm which might be from vishal.l.verma@intel.com are

mm-memory_hotplug-split-memmap_on_memory-requests-across-memblocks.patch
dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory.patch

