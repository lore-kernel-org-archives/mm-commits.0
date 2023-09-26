Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7CFBE7F144
	for <mm-commits@archiver.kernel.org>; Tue, 26 Sep 2023 23:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbjIZXWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 26 Sep 2023 19:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjIZXUK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 26 Sep 2023 19:20:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5791B391
        for <mm-commits@vger.kernel.org>; Tue, 26 Sep 2023 15:22:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7FEC4339A;
        Tue, 26 Sep 2023 21:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695762424;
        bh=V92bYaeChUdLzBubpugzMVGUoi2FK1qrzWJq964vIss=;
        h=Date:To:From:Subject:From;
        b=Zf/uiX5LNsZhjXaLto75WGpKOBffb26NeKuCQgmBkPJtm/jSY1jfCJEXH6AtdbgxM
         5kodcoj0xSw+ZU3c/Q0Gmkw5dTZpK0rmmEkvRCgkdQybfnrkIppi1yx7dA0+1Ue2sG
         3A5xckBP8cuSrIT0ksgJOkumnxvZzP2WimuNask8=
Date:   Tue, 26 Sep 2023 14:07:02 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com,
        shy828301@gmail.com, rafael.j.wysocki@intel.com, mhocko@kernel.org,
        Jonathan.Cameron@huawei.com, hannes@cmpxchg.org, dave@stgolabs.net,
        dave.jiang@intel.com, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acpi-hmat-calculate-abstract-distance-with-hmat.patch added to mm-unstable branch
Message-Id: <20230926210703.DE7FEC4339A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, hmat: calculate abstract distance with HMAT
has been added to the -mm mm-unstable branch.  Its filename is
     acpi-hmat-calculate-abstract-distance-with-hmat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpi-hmat-calculate-abstract-distance-with-hmat.patch

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
Subject: acpi, hmat: calculate abstract distance with HMAT
Date: Tue, 26 Sep 2023 14:06:27 +0800

A memory tiering abstract distance calculation algorithm based on ACPI
HMAT is implemented.  The basic idea is as follows.

The performance attributes of system default DRAM nodes are recorded as
the base line.  Whose abstract distance is MEMTIER_ADISTANCE_DRAM.  Then,
the ratio of the abstract distance of a memory node (target) to
MEMTIER_ADISTANCE_DRAM is scaled based on the ratio of the performance
attributes of the node to that of the default DRAM nodes.

The functions to record the read/write latency/bandwidth of the default
DRAM nodes and calculate abstract distance according to read/write
latency/bandwidth ratio will be used by CXL CDAT (Coherent Device
Attribute Table) and other memory device drivers.  So, they are put in
memory-tiers.c.

Link: https://lkml.kernel.org/r/20230926060628.265989-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Tested-by: Bharata B Rao <bharata@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Rafael J Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c     |   65 ++++++++++++++++++++
 include/linux/memory-tiers.h |   18 +++++
 mm/memory-tiers.c            |  103 ++++++++++++++++++++++++++++++++-
 3 files changed, 183 insertions(+), 3 deletions(-)

--- a/drivers/acpi/numa/hmat.c~acpi-hmat-calculate-abstract-distance-with-hmat
+++ a/drivers/acpi/numa/hmat.c
@@ -24,6 +24,7 @@
 #include <linux/node.h>
 #include <linux/sysfs.h>
 #include <linux/dax.h>
+#include <linux/memory-tiers.h>
 
 static u8 hmat_revision;
 static int hmat_disable __initdata;
@@ -759,6 +760,61 @@ static int hmat_callback(struct notifier
 	return NOTIFY_OK;
 }
 
+static int hmat_set_default_dram_perf(void)
+{
+	int rc;
+	int nid, pxm;
+	struct memory_target *target;
+	struct node_hmem_attrs *attrs;
+
+	if (!default_dram_type)
+		return -EIO;
+
+	for_each_node_mask(nid, default_dram_type->nodes) {
+		pxm = node_to_pxm(nid);
+		target = find_mem_target(pxm);
+		if (!target)
+			continue;
+		attrs = &target->hmem_attrs[1];
+		rc = mt_set_default_dram_perf(nid, attrs, "ACPI HMAT");
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int hmat_calculate_adistance(struct notifier_block *self,
+				    unsigned long nid, void *data)
+{
+	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
+	struct memory_target *target;
+	struct node_hmem_attrs *perf;
+	int *adist = data;
+	int pxm;
+
+	pxm = node_to_pxm(nid);
+	target = find_mem_target(pxm);
+	if (!target)
+		return NOTIFY_OK;
+
+	mutex_lock(&target_lock);
+	hmat_update_target_attrs(target, p_nodes, 1);
+	mutex_unlock(&target_lock);
+
+	perf = &target->hmem_attrs[1];
+
+	if (mt_perf_to_adistance(perf, adist))
+		return NOTIFY_OK;
+
+	return NOTIFY_STOP;
+}
+
+static struct notifier_block hmat_adist_nb __meminitdata = {
+	.notifier_call = hmat_calculate_adistance,
+	.priority = 100,
+};
+
 static __init void hmat_free_structures(void)
 {
 	struct memory_target *target, *tnext;
@@ -841,8 +897,13 @@ static __init int hmat_init(void)
 	hmat_register_targets();
 
 	/* Keep the table and structures if the notifier may use them */
-	if (!hotplug_memory_notifier(hmat_callback, HMAT_CALLBACK_PRI))
-		return 0;
+	if (hotplug_memory_notifier(hmat_callback, HMAT_CALLBACK_PRI))
+		goto out_put;
+
+	if (!hmat_set_default_dram_perf())
+		register_mt_adistance_algorithm(&hmat_adist_nb);
+
+	return 0;
 out_put:
 	hmat_free_structures();
 	acpi_put_table(tbl);
--- a/include/linux/memory-tiers.h~acpi-hmat-calculate-abstract-distance-with-hmat
+++ a/include/linux/memory-tiers.h
@@ -31,8 +31,11 @@ struct memory_dev_type {
 	struct kref kref;
 };
 
+struct node_hmem_attrs;
+
 #ifdef CONFIG_NUMA
 extern bool numa_demotion_enabled;
+extern struct memory_dev_type *default_dram_type;
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
@@ -40,6 +43,9 @@ void clear_node_memory_type(int node, st
 int register_mt_adistance_algorithm(struct notifier_block *nb);
 int unregister_mt_adistance_algorithm(struct notifier_block *nb);
 int mt_calc_adistance(int node, int *adist);
+int mt_set_default_dram_perf(int nid, struct node_hmem_attrs *perf,
+			     const char *source);
+int mt_perf_to_adistance(struct node_hmem_attrs *perf, int *adist);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -64,6 +70,7 @@ static inline bool node_is_toptier(int n
 #else
 
 #define numa_demotion_enabled	false
+#define default_dram_type	NULL
 /*
  * CONFIG_NUMA implementation returns non NULL error.
  */
@@ -116,5 +123,16 @@ static inline int mt_calc_adistance(int
 {
 	return NOTIFY_DONE;
 }
+
+static inline int mt_set_default_dram_perf(int nid, struct node_hmem_attrs *perf,
+					   const char *source)
+{
+	return -EIO;
+}
+
+static inline int mt_perf_to_adistance(struct node_hmem_attrs *perf, int *adist)
+{
+	return -EIO;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
--- a/mm/memory-tiers.c~acpi-hmat-calculate-abstract-distance-with-hmat
+++ a/mm/memory-tiers.c
@@ -37,7 +37,7 @@ struct node_memory_type_map {
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
-static struct memory_dev_type *default_dram_type;
+struct memory_dev_type *default_dram_type;
 
 static struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
@@ -108,6 +108,11 @@ static struct demotion_nodes *node_demot
 
 static BLOCKING_NOTIFIER_HEAD(mt_adistance_algorithms);
 
+static bool default_dram_perf_error;
+static struct node_hmem_attrs default_dram_perf;
+static int default_dram_perf_ref_nid = NUMA_NO_NODE;
+static const char *default_dram_perf_ref_source;
+
 static inline struct memory_tier *to_memory_tier(struct device *device)
 {
 	return container_of(device, struct memory_tier, dev);
@@ -595,6 +600,102 @@ void clear_node_memory_type(int node, st
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
+static void dump_hmem_attrs(struct node_hmem_attrs *attrs, const char *prefix)
+{
+	pr_info(
+"%sread_latency: %u, write_latency: %u, read_bandwidth: %u, write_bandwidth: %u\n",
+		prefix, attrs->read_latency, attrs->write_latency,
+		attrs->read_bandwidth, attrs->write_bandwidth);
+}
+
+int mt_set_default_dram_perf(int nid, struct node_hmem_attrs *perf,
+			     const char *source)
+{
+	int rc = 0;
+
+	mutex_lock(&memory_tier_lock);
+	if (default_dram_perf_error) {
+		rc = -EIO;
+		goto out;
+	}
+
+	if (perf->read_latency + perf->write_latency == 0 ||
+	    perf->read_bandwidth + perf->write_bandwidth == 0) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	if (default_dram_perf_ref_nid == NUMA_NO_NODE) {
+		default_dram_perf = *perf;
+		default_dram_perf_ref_nid = nid;
+		default_dram_perf_ref_source = kstrdup(source, GFP_KERNEL);
+		goto out;
+	}
+
+	/*
+	 * The performance of all default DRAM nodes is expected to be
+	 * same (that is, the variation is less than 10%).  And it
+	 * will be used as base to calculate the abstract distance of
+	 * other memory nodes.
+	 */
+	if (abs(perf->read_latency - default_dram_perf.read_latency) * 10 >
+	    default_dram_perf.read_latency ||
+	    abs(perf->write_latency - default_dram_perf.write_latency) * 10 >
+	    default_dram_perf.write_latency ||
+	    abs(perf->read_bandwidth - default_dram_perf.read_bandwidth) * 10 >
+	    default_dram_perf.read_bandwidth ||
+	    abs(perf->write_bandwidth - default_dram_perf.write_bandwidth) * 10 >
+	    default_dram_perf.write_bandwidth) {
+		pr_info(
+"memory-tiers: the performance of DRAM node %d mismatches that of the reference\n"
+"DRAM node %d.\n", nid, default_dram_perf_ref_nid);
+		pr_info("  performance of reference DRAM node %d:\n",
+			default_dram_perf_ref_nid);
+		dump_hmem_attrs(&default_dram_perf, "    ");
+		pr_info("  performance of DRAM node %d:\n", nid);
+		dump_hmem_attrs(perf, "    ");
+		pr_info(
+"  disable default DRAM node performance based abstract distance algorithm.\n");
+		default_dram_perf_error = true;
+		rc = -EINVAL;
+	}
+
+out:
+	mutex_unlock(&memory_tier_lock);
+	return rc;
+}
+
+int mt_perf_to_adistance(struct node_hmem_attrs *perf, int *adist)
+{
+	if (default_dram_perf_error)
+		return -EIO;
+
+	if (default_dram_perf_ref_nid == NUMA_NO_NODE)
+		return -ENOENT;
+
+	if (perf->read_latency + perf->write_latency == 0 ||
+	    perf->read_bandwidth + perf->write_bandwidth == 0)
+		return -EINVAL;
+
+	mutex_lock(&memory_tier_lock);
+	/*
+	 * The abstract distance of a memory node is in direct proportion to
+	 * its memory latency (read + write) and inversely proportional to its
+	 * memory bandwidth (read + write).  The abstract distance, memory
+	 * latency, and memory bandwidth of the default DRAM nodes are used as
+	 * the base.
+	 */
+	*adist = MEMTIER_ADISTANCE_DRAM *
+		(perf->read_latency + perf->write_latency) /
+		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
+		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
+		(perf->read_bandwidth + perf->write_bandwidth);
+	mutex_unlock(&memory_tier_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt_perf_to_adistance);
+
 /**
  * register_mt_adistance_algorithm() - Register memory tiering abstract distance algorithm
  * @nb: The notifier block which describe the algorithm
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch
mm-pcp-avoid-to-drain-pcp-when-process-exit.patch
cacheinfo-calculate-per-cpu-data-cache-size.patch
mm-pcp-reduce-lock-contention-for-draining-high-order-pages.patch
mm-restrict-the-pcp-batch-scale-factor-to-avoid-too-long-latency.patch
mm-page_alloc-scale-the-number-of-pages-that-are-batch-allocated.patch
mm-add-framework-for-pcp-high-auto-tuning.patch
mm-tune-pcp-high-automatically.patch
mm-pcp-decrease-pcp-high-if-free-pages-high-watermark.patch
mm-pcp-avoid-to-reduce-pcp-high-unnecessarily.patch
mm-pcp-reduce-detecting-time-of-consecutive-high-order-page-freeing.patch
memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch

