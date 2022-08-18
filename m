Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DB7C28B2B
	for <mm-commits@archiver.kernel.org>; Thu, 18 Aug 2022 23:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239690AbiHRXvR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Aug 2022 19:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239843AbiHRXvP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Aug 2022 19:51:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438A6CE48A
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 16:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC69CB824CD
        for <mm-commits@vger.kernel.org>; Thu, 18 Aug 2022 23:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900B5C433D6;
        Thu, 18 Aug 2022 23:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660866671;
        bh=KDbykRxqFQKgVv9Pxy6cqsdS2Hfw2SHWqE9ooc3/oMo=;
        h=Date:To:From:Subject:From;
        b=dY6v27pDHY1VJETimiBcRbqbzzoT0FyscGRNPGdHl2hOHfdh9vAgKCmexKewIh7W2
         q80GW8uzvXiNSCysorAKQuuZbeksUk2vK4LEzI142dt+5mcy7ysRYpemrXQJVs23Mo
         EXUHzkv6p35jU8G0F8uFWeLHZcqyfoD6V05IZhe8=
Date:   Thu, 18 Aug 2022 16:51:10 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        weixugc@google.com, tim.c.chen@intel.com, shy828301@gmail.com,
        mhocko@kernel.org, jvgediya.oss@gmail.com,
        Jonathan.Cameron@huawei.com, hesham.almatary@huawei.com,
        hannes@cmpxchg.org, dave@stgolabs.net, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch added to mm-unstable branch
Message-Id: <20220818235111.900B5C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/demotion/dax/kmem: set node's abstract distance to MEMTIER_DEFAULT_DAX_ADISTANCE
has been added to the -mm mm-unstable branch.  Its filename is
     mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch

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
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: mm/demotion/dax/kmem: set node's abstract distance to MEMTIER_DEFAULT_DAX_ADISTANCE
Date: Thu, 18 Aug 2022 18:40:36 +0530

By default, all nodes are assigned to the default memory tier which is the
memory tier designated for nodes with DRAM

Set dax kmem device node's tier to slower memory tier by assigning
abstract distance to MEMTIER_DEFAULT_DAX_ADISTANCE.  Low-level drivers
like papr_scm or ACPI NFIT can initialize memory device type to a more
accurate value based on device tree details or HMAT.  If the kernel
doesn't find the memory type initialized, a default slower memory type is
assigned by the kmem driver.

Link: https://lkml.kernel.org/r/20220818131042.113280-5-aneesh.kumar@linux.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hesham Almatary <hesham.almatary@huawei.com>
Cc: Jagdish Gediya <jvgediya.oss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c           |   42 ++++++++++++++-
 include/linux/memory-tiers.h |   42 ++++++++++++++-
 mm/memory-tiers.c            |   91 +++++++++++++++++++++++++--------
 3 files changed, 149 insertions(+), 26 deletions(-)

--- a/drivers/dax/kmem.c~mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance
+++ a/drivers/dax/kmem.c
@@ -11,9 +11,17 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/memory-tiers.h>
 #include "dax-private.h"
 #include "bus.h"
 
+/*
+ * Default abstract distance assigned to the NUMA node onlined
+ * by DAX/kmem if the low level platform driver didn't initialize
+ * one for this NUMA node.
+ */
+#define MEMTIER_DEFAULT_DAX_ADISTANCE	(MEMTIER_ADISTANCE_DRAM * 5)
+
 /* Memory resource name used for add_memory_driver_managed(). */
 static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
@@ -41,6 +49,7 @@ struct dax_kmem_data {
 	struct resource *res[];
 };
 
+static struct memory_dev_type *dax_slowmem_type;
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -79,11 +88,13 @@ static int dev_dax_kmem_probe(struct dev
 		return -EINVAL;
 	}
 
+	init_node_memory_type(numa_node, dax_slowmem_type);
+
+	rc = -ENOMEM;
 	data = kzalloc(struct_size(data, res, dev_dax->nr_range), GFP_KERNEL);
 	if (!data)
-		return -ENOMEM;
+		goto err_dax_kmem_data;
 
-	rc = -ENOMEM;
 	data->res_name = kstrdup(dev_name(dev), GFP_KERNEL);
 	if (!data->res_name)
 		goto err_res_name;
@@ -155,6 +166,8 @@ err_reg_mgid:
 	kfree(data->res_name);
 err_res_name:
 	kfree(data);
+err_dax_kmem_data:
+	clear_node_memory_type(numa_node, dax_slowmem_type);
 	return rc;
 }
 
@@ -162,6 +175,7 @@ err_res_name:
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
 	int i, success = 0;
+	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
@@ -198,6 +212,14 @@ static void dev_dax_kmem_remove(struct d
 		kfree(data->res_name);
 		kfree(data);
 		dev_set_drvdata(dev, NULL);
+		/*
+		 * Clear the memtype association on successful unplug.
+		 * If not, we have memory blocks left which can be
+		 * offlined/onlined later. We need to keep memory_dev_type
+		 * for that. This implies this reference will be around
+		 * till next reboot.
+		 */
+		clear_node_memory_type(node, dax_slowmem_type);
 	}
 }
 #else
@@ -228,9 +250,22 @@ static int __init dax_kmem_init(void)
 	if (!kmem_name)
 		return -ENOMEM;
 
+	dax_slowmem_type = alloc_memory_type(MEMTIER_DEFAULT_DAX_ADISTANCE);
+	if (IS_ERR(dax_slowmem_type)) {
+		rc = PTR_ERR(dax_slowmem_type);
+		goto err_dax_slowmem_type;
+	}
+
 	rc = dax_driver_register(&device_dax_kmem_driver);
 	if (rc)
-		kfree_const(kmem_name);
+		goto error_dax_driver;
+
+	return rc;
+
+error_dax_driver:
+	destroy_memory_type(dax_slowmem_type);
+err_dax_slowmem_type:
+	kfree_const(kmem_name);
 	return rc;
 }
 
@@ -239,6 +274,7 @@ static void __exit dax_kmem_exit(void)
 	dax_driver_unregister(&device_dax_kmem_driver);
 	if (!any_hotremove_failed)
 		kfree_const(kmem_name);
+	destroy_memory_type(dax_slowmem_type);
 }
 
 MODULE_AUTHOR("Intel Corporation");
--- a/include/linux/memory-tiers.h~mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance
+++ a/include/linux/memory-tiers.h
@@ -2,6 +2,9 @@
 #ifndef _LINUX_MEMORY_TIERS_H
 #define _LINUX_MEMORY_TIERS_H
 
+#include <linux/types.h>
+#include <linux/nodemask.h>
+#include <linux/kref.h>
 /*
  * Each tier cover a abstrace distance chunk size of 128
  */
@@ -16,12 +19,49 @@
 #define MEMTIER_ADISTANCE_DRAM	((4 * MEMTIER_CHUNK_SIZE) + (MEMTIER_CHUNK_SIZE >> 1))
 #define MEMTIER_HOTPLUG_PRIO	100
 
+struct memory_tier;
+struct memory_dev_type {
+	/* list of memory types that are part of same tier as this type */
+	struct list_head tier_sibiling;
+	/* abstract distance for this specific memory type */
+	int adistance;
+	/* Nodes of same abstract distance */
+	nodemask_t nodes;
+	struct kref kref;
+	struct memory_tier *memtier;
+};
+
 #ifdef CONFIG_NUMA
-#include <linux/types.h>
 extern bool numa_demotion_enabled;
+struct memory_dev_type *alloc_memory_type(int adistance);
+void destroy_memory_type(struct memory_dev_type *memtype);
+void init_node_memory_type(int node, struct memory_dev_type *default_type);
+void clear_node_memory_type(int node, struct memory_dev_type *memtype);
 
 #else
 
 #define numa_demotion_enabled	false
+/*
+ * CONFIG_NUMA implementation returns non NULL error.
+ */
+static inline struct memory_dev_type *alloc_memory_type(int adistance)
+{
+	return NULL;
+}
+
+static inline void destroy_memory_type(struct memory_dev_type *memtype)
+{
+
+}
+
+static inline void init_node_memory_type(int node, struct memory_dev_type *default_type)
+{
+
+}
+
+static inline void clear_node_memory_type(int node, struct memory_dev_type *memtype)
+{
+
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
--- a/mm/memory-tiers.c~mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance
+++ a/mm/memory-tiers.c
@@ -1,6 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/types.h>
-#include <linux/nodemask.h>
 #include <linux/slab.h>
 #include <linux/lockdep.h>
 #include <linux/sysfs.h>
@@ -21,27 +19,10 @@ struct memory_tier {
 	int adistance_start;
 };
 
-struct memory_dev_type {
-	/* list of memory types that are part of same tier as this type */
-	struct list_head tier_sibiling;
-	/* abstract distance for this specific memory type */
-	int adistance;
-	/* Nodes of same abstract distance */
-	nodemask_t nodes;
-	struct memory_tier *memtier;
-};
-
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
 static struct memory_dev_type *node_memory_types[MAX_NUMNODES];
-/*
- * For now we can have 4 faster memory tiers with smaller adistance
- * than default DRAM tier.
- */
-static struct memory_dev_type default_dram_type  = {
-	.adistance = MEMTIER_ADISTANCE_DRAM,
-	.tier_sibiling = LIST_HEAD_INIT(default_dram_type.tier_sibiling),
-};
+static struct memory_dev_type *default_dram_type;
 
 static struct memory_tier *find_create_memory_tier(struct memory_dev_type *memtype)
 {
@@ -87,6 +68,14 @@ static struct memory_tier *find_create_m
 	return new_memtier;
 }
 
+static inline void __init_node_memory_type(int node, struct memory_dev_type *memtype)
+{
+	if (!node_memory_types[node]) {
+		node_memory_types[node] = memtype;
+		kref_get(&memtype->kref);
+	}
+}
+
 static struct memory_tier *set_node_memory_tier(int node)
 {
 	struct memory_tier *memtier;
@@ -97,8 +86,7 @@ static struct memory_tier *set_node_memo
 	if (!node_state(node, N_MEMORY))
 		return ERR_PTR(-EINVAL);
 
-	if (!node_memory_types[node])
-		node_memory_types[node] = &default_dram_type;
+	__init_node_memory_type(node, default_dram_type);
 
 	memtype = node_memory_types[node];
 	node_set(node, memtype->nodes);
@@ -144,6 +132,57 @@ static bool clear_node_memory_tier(int n
 	return cleared;
 }
 
+static void release_memtype(struct kref *kref)
+{
+	struct memory_dev_type *memtype;
+
+	memtype = container_of(kref, struct memory_dev_type, kref);
+	kfree(memtype);
+}
+
+struct memory_dev_type *alloc_memory_type(int adistance)
+{
+	struct memory_dev_type *memtype;
+
+	memtype = kmalloc(sizeof(*memtype), GFP_KERNEL);
+	if (!memtype)
+		return ERR_PTR(-ENOMEM);
+
+	memtype->adistance = adistance;
+	INIT_LIST_HEAD(&memtype->tier_sibiling);
+	memtype->nodes  = NODE_MASK_NONE;
+	memtype->memtier = NULL;
+	kref_init(&memtype->kref);
+	return memtype;
+}
+EXPORT_SYMBOL_GPL(alloc_memory_type);
+
+void destroy_memory_type(struct memory_dev_type *memtype)
+{
+	kref_put(&memtype->kref, release_memtype);
+}
+EXPORT_SYMBOL_GPL(destroy_memory_type);
+
+void init_node_memory_type(int node, struct memory_dev_type *memtype)
+{
+
+	mutex_lock(&memory_tier_lock);
+	__init_node_memory_type(node, memtype);
+	mutex_unlock(&memory_tier_lock);
+}
+EXPORT_SYMBOL_GPL(init_node_memory_type);
+
+void clear_node_memory_type(int node, struct memory_dev_type *memtype)
+{
+	mutex_lock(&memory_tier_lock);
+	if (node_memory_types[node] == memtype) {
+		node_memory_types[node] = NULL;
+		kref_put(&memtype->kref, release_memtype);
+	}
+	mutex_unlock(&memory_tier_lock);
+}
+EXPORT_SYMBOL_GPL(clear_node_memory_type);
+
 static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 					      unsigned long action, void *_arg)
 {
@@ -179,6 +218,14 @@ static int __init memory_tier_init(void)
 
 	mutex_lock(&memory_tier_lock);
 	/*
+	 * For now we can have 4 faster memory tiers with smaller adistance
+	 * than default DRAM tier.
+	 */
+	default_dram_type = alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
+	if (!default_dram_type)
+		panic("%s() failed to allocate default DRAM tier\n", __func__);
+
+	/*
 	 * Look at all the existing N_MEMORY nodes and add them to
 	 * default memory tier or to a tier if we already have memory
 	 * types assigned.
_

Patches currently in -mm which might be from aneesh.kumar@linux.ibm.com are

mm-demotion-add-support-for-explicit-memory-tiers.patch
mm-demotion-move-memory-demotion-related-code.patch
mm-demotion-add-hotplug-callbacks-to-handle-new-numa-node-onlined.patch
mm-demotion-dax-kmem-set-nodes-abstract-distance-to-memtier_default_dax_adistance.patch
mm-demotion-build-demotion-targets-based-on-explicit-memory-tiers.patch
mm-demotion-add-pg_data_t-member-to-track-node-memory-tier-details.patch
mm-demotion-drop-memtier-from-memtype.patch
mm-demotion-update-node_is_toptier-to-work-with-memory-tiers.patch
lib-nodemask-optimize-node_random-for-nodemask-with-single-numa-node.patch

