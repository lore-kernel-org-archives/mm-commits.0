Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3C4C001B0
	for <mm-commits@archiver.kernel.org>; Mon, 24 Jul 2023 17:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjGXR7a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbjGXR7G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jul 2023 13:59:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219321BDD
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 10:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9673B61363
        for <mm-commits@vger.kernel.org>; Mon, 24 Jul 2023 17:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29FDC433C9;
        Mon, 24 Jul 2023 17:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1690221518;
        bh=+bvO04qQzZON6R4W6aeMBBbumqU0c4XMj2Yr8sMpcQw=;
        h=Date:To:From:Subject:From;
        b=bsNQWIzLwOq20vqLxlJ8IikiuypSm7qKlzkET901gFSBuucQPKnYPZOvS/i8OQCkQ
         9rbUrji4EH4PYEH82k67DF9pp0uY2B0NIQ3PeDKdG10pjUS5EzG3r9UNcADedib0/I
         9hl1Pd+uyJ0vIak2RPI6WcvxtlFTES9LiAayRIdE=
Date:   Mon, 24 Jul 2023 10:58:38 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com,
        shy828301@gmail.com, rafael.j.wysocki@intel.com, mhocko@kernel.org,
        Jonathan.Cameron@huawei.com, hannes@cmpxchg.org, dave@stgolabs.net,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        apopple@nvidia.com, aneesh.kumar@linux.ibm.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acpi-hmat-calculate-abstract-distance-with-hmat.patch added to mm-unstable branch
Message-Id: <20230724175838.C29FDC433C9@smtp.kernel.org>
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
Date: Fri, 21 Jul 2023 09:29:31 +0800

A memory tiering abstract distance calculation algorithm based on ACPI
HMAT is implemented.  The basic idea is as follows.

The performance attributes of system default DRAM nodes are recorded as
the base line.  Whose abstract distance is MEMTIER_ADISTANCE_DRAM.  Then,
the ratio of the abstract distance of a memory node (target) to
MEMTIER_ADISTANCE_DRAM is scaled based on the ratio of the performance
attributes of the node to that of the default DRAM nodes.

Link: https://lkml.kernel.org/r/20230721012932.190742-4-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
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
Cc: Rafael J Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c     |  138 ++++++++++++++++++++++++++++++++-
 include/linux/memory-tiers.h |    2 
 mm/memory-tiers.c            |    2 
 3 files changed, 140 insertions(+), 2 deletions(-)

--- a/drivers/acpi/numa/hmat.c~acpi-hmat-calculate-abstract-distance-with-hmat
+++ a/drivers/acpi/numa/hmat.c
@@ -24,6 +24,7 @@
 #include <linux/node.h>
 #include <linux/sysfs.h>
 #include <linux/dax.h>
+#include <linux/memory-tiers.h>
 
 static u8 hmat_revision;
 static int hmat_disable __initdata;
@@ -759,6 +760,137 @@ static int hmat_callback(struct notifier
 	return NOTIFY_OK;
 }
 
+static int hmat_adistance_disabled;
+static struct node_hmem_attrs default_dram_attrs;
+
+static void dump_hmem_attrs(struct node_hmem_attrs *attrs)
+{
+	pr_cont("read_latency: %u, write_latency: %u, read_bandwidth: %u, write_bandwidth: %u\n",
+		attrs->read_latency, attrs->write_latency,
+		attrs->read_bandwidth, attrs->write_bandwidth);
+}
+
+static void disable_hmat_adistance_algorithm(void)
+{
+	hmat_adistance_disabled = true;
+}
+
+static int hmat_init_default_dram_attrs(void)
+{
+	struct memory_target *target;
+	struct node_hmem_attrs *attrs;
+	int nid, pxm;
+	int nid_dram = NUMA_NO_NODE;
+
+	if (default_dram_attrs.read_latency +
+	    default_dram_attrs.write_latency != 0)
+		return 0;
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
+		if (nid_dram == NUMA_NO_NODE) {
+			if (attrs->read_latency + attrs->write_latency == 0 ||
+			    attrs->read_bandwidth + attrs->write_bandwidth == 0) {
+				pr_info("hmat: invalid hmem attrs for default DRAM node: %d,\n",
+					nid);
+				pr_info("  ");
+				dump_hmem_attrs(attrs);
+				pr_info("  disable hmat based abstract distance algorithm.\n");
+				disable_hmat_adistance_algorithm();
+				return -EIO;
+			}
+			nid_dram = nid;
+			default_dram_attrs = *attrs;
+			continue;
+		}
+
+		/*
+		 * The performance of all default DRAM nodes is expected
+		 * to be same (that is, the variation is less than 10%).
+		 * And it will be used as base to calculate the abstract
+		 * distance of other memory nodes.
+		 */
+		if (abs(attrs->read_latency - default_dram_attrs.read_latency) * 10 >
+		    default_dram_attrs.read_latency ||
+		    abs(attrs->write_latency - default_dram_attrs.write_latency) * 10 >
+		    default_dram_attrs.write_latency ||
+		    abs(attrs->read_bandwidth - default_dram_attrs.read_bandwidth) * 10 >
+		    default_dram_attrs.read_bandwidth) {
+			pr_info("hmat: hmem attrs for DRAM nodes mismatch.\n");
+			pr_info("  node %d:", nid_dram);
+			dump_hmem_attrs(&default_dram_attrs);
+			pr_info("  node %d:", nid);
+			dump_hmem_attrs(attrs);
+			pr_info("  disable hmat based abstract distance algorithm.\n");
+			disable_hmat_adistance_algorithm();
+			return -EIO;
+		}
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
+	struct node_hmem_attrs *attrs;
+	int *adist = data;
+	int pxm;
+
+	if (hmat_adistance_disabled)
+		return NOTIFY_OK;
+
+	pxm = node_to_pxm(nid);
+	target = find_mem_target(pxm);
+	if (!target)
+		return NOTIFY_OK;
+
+	if (hmat_init_default_dram_attrs())
+		return NOTIFY_OK;
+
+	mutex_lock(&target_lock);
+	hmat_update_target_attrs(target, p_nodes, 1);
+	mutex_unlock(&target_lock);
+
+	attrs = &target->hmem_attrs[1];
+
+	if (attrs->read_latency + attrs->write_latency == 0 ||
+	    attrs->read_bandwidth + attrs->write_bandwidth == 0)
+		return NOTIFY_OK;
+
+	/*
+	 * The abstract distance of a memory node is in direct
+	 * proportion to its memory latency (read + write) and
+	 * inversely proportional to its memory bandwidth (read +
+	 * write).  The abstract distance, memory latency, and memory
+	 * bandwidth of the default DRAM nodes are used as the base.
+	 */
+	*adist = MEMTIER_ADISTANCE_DRAM *
+		(attrs->read_latency + attrs->write_latency) /
+		(default_dram_attrs.read_latency +
+		 default_dram_attrs.write_latency) *
+		(default_dram_attrs.read_bandwidth +
+		 default_dram_attrs.write_bandwidth) /
+		(attrs->read_bandwidth + attrs->write_bandwidth);
+
+	return NOTIFY_STOP;
+}
+
+static __meminitdata struct notifier_block hmat_adist_nb =
+{
+	.notifier_call = hmat_calculate_adistance,
+	.priority = 100,
+};
+
 static __init void hmat_free_structures(void)
 {
 	struct memory_target *target, *tnext;
@@ -801,6 +933,7 @@ static __init int hmat_init(void)
 	struct acpi_table_header *tbl;
 	enum acpi_hmat_type i;
 	acpi_status status;
+	int usage;
 
 	if (srat_disabled() || hmat_disable)
 		return 0;
@@ -841,8 +974,11 @@ static __init int hmat_init(void)
 	hmat_register_targets();
 
 	/* Keep the table and structures if the notifier may use them */
-	if (!hotplug_memory_notifier(hmat_callback, HMAT_CALLBACK_PRI))
+	usage = !hotplug_memory_notifier(hmat_callback, HMAT_CALLBACK_PRI);
+	usage += !register_mt_adistance_algorithm(&hmat_adist_nb);
+	if (usage)
 		return 0;
+
 out_put:
 	hmat_free_structures();
 	acpi_put_table(tbl);
--- a/include/linux/memory-tiers.h~acpi-hmat-calculate-abstract-distance-with-hmat
+++ a/include/linux/memory-tiers.h
@@ -33,6 +33,7 @@ struct memory_dev_type {
 
 #ifdef CONFIG_NUMA
 extern bool numa_demotion_enabled;
+extern struct memory_dev_type *default_dram_type;
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
@@ -64,6 +65,7 @@ static inline bool node_is_toptier(int n
 #else
 
 #define numa_demotion_enabled	false
+#define default_dram_type	NULL
 /*
  * CONFIG_NUMA implementation returns non NULL error.
  */
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
_

Patches currently in -mm which might be from ying.huang@intel.com are

memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch

