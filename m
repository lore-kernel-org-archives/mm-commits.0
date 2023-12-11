Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9EE1FD5
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZ1rJbJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B4AC433C7;
	Mon, 11 Dec 2023 00:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256045;
	bh=hxj9hexcvJmlpDQgT7EkhDE13s541RULC5/FpmytVBI=;
	h=Date:To:From:Subject:From;
	b=aZ1rJbJpNDeR5oiOihLbkTyFhEESW29kFJAWnUpNNeCNNsKzRs+4FRtjqfjK4fj/a
	 v4WjDA7Y2wrdLPjZiPs8vnorpXAHPEbJHYT5ylZmn4+SMYgYzQc3ZZMeXkOPOjWnJd
	 QNEVtGKIM2e4GXpJ8kSTca1VAhCRjuLmtmwkJNvg=
Date: Sun, 10 Dec 2023 16:54:04 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,osalvador@suse.de,mhocko@suse.com,lizhijian@fujitsu.com,Jonathan.Cameron@huawei.com,jmoyer@redhat.com,fan.ni@samsung.com,david@redhat.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,aneesh.kumar@linux.ibm.com,vishal.l.verma@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory.patch removed from -mm tree
Message-Id: <20231211005405.05B4AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dax/kmem: allow kmem to add memory with memmap_on_memory
has been removed from the -mm tree.  Its filename was
     dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: dax/kmem: allow kmem to add memory with memmap_on_memory
Date: Tue, 07 Nov 2023 00:22:43 -0700

Large amounts of memory managed by the kmem driver may come in via CXL,
and it is often desirable to have the memmap for this memory on the new
memory itself.

Enroll kmem-managed memory for memmap_on_memory semantics if the dax
region originates via CXL.  For non-CXL dax regions, retain the existing
default behavior of hot adding without memmap_on_memory semantics.

Link: https://lkml.kernel.org/r/20231107-vv-kmem_memmap-v10-3-1253ec050ed0@intel.com
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>	[cxl.kmem and nvdimm.kmem]
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Fan Ni <fan.ni@samsung.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/bus.c         |    3 +++
 drivers/dax/bus.h         |    1 +
 drivers/dax/cxl.c         |    1 +
 drivers/dax/dax-private.h |    1 +
 drivers/dax/hmem/hmem.c   |    1 +
 drivers/dax/kmem.c        |    8 +++++++-
 drivers/dax/pmem.c        |    1 +
 7 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/dax/bus.c~dax-kmem-allow-kmem-to-add-memory-with-memmap_on_memory
+++ a/drivers/dax/bus.c
@@ -367,6 +367,7 @@ static ssize_t create_store(struct devic
 			.dax_region = dax_region,
 			.size = 0,
 			.id = -1,
+			.memmap_on_memory = false,
 		};
 		struct dev_dax *dev_dax = devm_create_dev_dax(&data);
 
@@ -1400,6 +1401,8 @@ struct dev_dax *devm_create_dev_dax(stru
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


