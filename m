Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C602EE3F05
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 17:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbjILRZ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234306AbjILRZ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 13:25:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F7010E9
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 10:25:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC4CC433C7;
        Tue, 12 Sep 2023 17:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694539523;
        bh=9z7EGdhqjmcYtOIxzbc1r/EeClt1QGu13W79DrzveAE=;
        h=Date:To:From:Subject:From;
        b=CS0Zd3Hz4inS1kCmctolAgqUEChEgIGwT+5my1L3kj6nR5UqNCnmijZb2oS963vM2
         86KEH+Z3i8k6276cqyoF6SUcSmeuORmAwG5+l82XdZ5bZhsUrbXnFmXyLkJmdmCgHM
         HnAk+1lovBkEt+1zhPiHRSyjam4Aa57b9lwkFttQ=
Date:   Tue, 12 Sep 2023 10:25:23 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com,
        shy828301@gmail.com, rafael.j.wysocki@intel.com, mhocko@kernel.org,
        Jonathan.Cameron@huawei.com, hannes@cmpxchg.org, dave@stgolabs.net,
        dave.jiang@intel.com, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + dax-kmem-calculate-abstract-distance-with-general-interface.patch added to mm-unstable branch
Message-Id: <20230912172523.BDC4CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dax, kmem: calculate abstract distance with general interface
has been added to the -mm mm-unstable branch.  Its filename is
     dax-kmem-calculate-abstract-distance-with-general-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dax-kmem-calculate-abstract-distance-with-general-interface.patch

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
From: Huang Ying <ying.huang@intel.com>
Subject: dax, kmem: calculate abstract distance with general interface
Date: Tue, 12 Sep 2023 16:21:01 +0800

Previously, a fixed abstract distance MEMTIER_DEFAULT_DAX_ADISTANCE is
used for slow memory type in kmem driver.  This limits the usage of kmem
driver, for example, it cannot be used for HBM (high bandwidth memory).

So, we use the general abstract distance calculation mechanism in kmem
drivers to get more accurate abstract distance on systems with proper
support.  The original MEMTIER_DEFAULT_DAX_ADISTANCE is used as fallback
only.

Now, multiple memory types may be managed by kmem.  These memory types are
put into the "kmem_memory_types" list and protected by
kmem_memory_type_lock.

Link: https://lkml.kernel.org/r/20230912082101.342002-5-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Tested-by: Bharata B Rao <bharata@amd.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Rafael J Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c           |   62 ++++++++++++++++++++++++++-------
 include/linux/memory-tiers.h |    2 +
 mm/memory-tiers.c            |    2 -
 3 files changed, 52 insertions(+), 14 deletions(-)

--- a/drivers/dax/kmem.c~dax-kmem-calculate-abstract-distance-with-general-interface
+++ a/drivers/dax/kmem.c
@@ -49,14 +49,52 @@ struct dax_kmem_data {
 	struct resource *res[];
 };
 
-static struct memory_dev_type *dax_slowmem_type;
+static DEFINE_MUTEX(kmem_memory_type_lock);
+static LIST_HEAD(kmem_memory_types);
+
+static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
+{
+	bool found = false;
+	struct memory_dev_type *mtype;
+
+	mutex_lock(&kmem_memory_type_lock);
+	list_for_each_entry(mtype, &kmem_memory_types, list) {
+		if (mtype->adistance == adist) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		mtype = alloc_memory_type(adist);
+		if (!IS_ERR(mtype))
+			list_add(&mtype->list, &kmem_memory_types);
+	}
+	mutex_unlock(&kmem_memory_type_lock);
+
+	return mtype;
+}
+
+static void kmem_put_memory_types(void)
+{
+	struct memory_dev_type *mtype, *mtn;
+
+	mutex_lock(&kmem_memory_type_lock);
+	list_for_each_entry_safe(mtype, mtn, &kmem_memory_types, list) {
+		list_del(&mtype->list);
+		put_memory_type(mtype);
+	}
+	mutex_unlock(&kmem_memory_type_lock);
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
 	unsigned long total_len = 0;
 	struct dax_kmem_data *data;
+	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
 	int numa_node;
+	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -71,6 +109,11 @@ static int dev_dax_kmem_probe(struct dev
 		return -EINVAL;
 	}
 
+	mt_calc_adistance(numa_node, &adist);
+	mtype = kmem_find_alloc_memory_type(adist);
+	if (IS_ERR(mtype))
+		return PTR_ERR(mtype);
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -88,7 +131,7 @@ static int dev_dax_kmem_probe(struct dev
 		return -EINVAL;
 	}
 
-	init_node_memory_type(numa_node, dax_slowmem_type);
+	init_node_memory_type(numa_node, mtype);
 
 	rc = -ENOMEM;
 	data = kzalloc(struct_size(data, res, dev_dax->nr_range), GFP_KERNEL);
@@ -167,7 +210,7 @@ err_reg_mgid:
 err_res_name:
 	kfree(data);
 err_dax_kmem_data:
-	clear_node_memory_type(numa_node, dax_slowmem_type);
+	clear_node_memory_type(numa_node, mtype);
 	return rc;
 }
 
@@ -219,7 +262,7 @@ static void dev_dax_kmem_remove(struct d
 		 * for that. This implies this reference will be around
 		 * till next reboot.
 		 */
-		clear_node_memory_type(node, dax_slowmem_type);
+		clear_node_memory_type(node, NULL);
 	}
 }
 #else
@@ -251,12 +294,6 @@ static int __init dax_kmem_init(void)
 	if (!kmem_name)
 		return -ENOMEM;
 
-	dax_slowmem_type = alloc_memory_type(MEMTIER_DEFAULT_DAX_ADISTANCE);
-	if (IS_ERR(dax_slowmem_type)) {
-		rc = PTR_ERR(dax_slowmem_type);
-		goto err_dax_slowmem_type;
-	}
-
 	rc = dax_driver_register(&device_dax_kmem_driver);
 	if (rc)
 		goto error_dax_driver;
@@ -264,8 +301,7 @@ static int __init dax_kmem_init(void)
 	return rc;
 
 error_dax_driver:
-	put_memory_type(dax_slowmem_type);
-err_dax_slowmem_type:
+	kmem_put_memory_types();
 	kfree_const(kmem_name);
 	return rc;
 }
@@ -275,7 +311,7 @@ static void __exit dax_kmem_exit(void)
 	dax_driver_unregister(&device_dax_kmem_driver);
 	if (!any_hotremove_failed)
 		kfree_const(kmem_name);
-	put_memory_type(dax_slowmem_type);
+	kmem_put_memory_types();
 }
 
 MODULE_AUTHOR("Intel Corporation");
--- a/include/linux/memory-tiers.h~dax-kmem-calculate-abstract-distance-with-general-interface
+++ a/include/linux/memory-tiers.h
@@ -24,6 +24,8 @@ struct memory_tier;
 struct memory_dev_type {
 	/* list of memory types that are part of same tier as this type */
 	struct list_head tier_sibling;
+	/* list of memory types that are managed by one driver */
+	struct list_head list;
 	/* abstract distance for this specific memory type */
 	int adistance;
 	/* Nodes of same abstract distance */
--- a/mm/memory-tiers.c~dax-kmem-calculate-abstract-distance-with-general-interface
+++ a/mm/memory-tiers.c
@@ -586,7 +586,7 @@ EXPORT_SYMBOL_GPL(init_node_memory_type)
 void clear_node_memory_type(int node, struct memory_dev_type *memtype)
 {
 	mutex_lock(&memory_tier_lock);
-	if (node_memory_types[node].memtype == memtype)
+	if (node_memory_types[node].memtype == memtype || !memtype)
 		node_memory_types[node].map_count--;
 	/*
 	 * If we umapped all the attached devices to this node,
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch

