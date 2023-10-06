Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D600AE94125
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233812AbjJFVtU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbjJFVtT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:49:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC3DBD
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:49:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A25C433C7;
        Fri,  6 Oct 2023 21:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628957;
        bh=YmhC+vNBowHFybhCKi9FzYhi1GkCfkrI/dF/kXfe0vE=;
        h=Date:To:From:Subject:From;
        b=o4fGtXCv+SxxSWiqP0V1tiIp6d8k07uCwJknui7gZZGu1OlFNMBlCQ8O0NKeFVKdd
         tG6gJ/0xEdMtxIvf61Z89rFtr4YPeTmVYjnnVZhqtHuLZF30xMM9OybNwwi7fz7wot
         mXY+ceYLjio+h3hGeNLnBzFZAAO6AocAe06++wOU=
Date:   Fri, 06 Oct 2023 14:49:15 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com,
        shy828301@gmail.com, rafael.j.wysocki@intel.com, mhocko@kernel.org,
        Jonathan.Cameron@huawei.com, hannes@cmpxchg.org, dave@stgolabs.net,
        dave.jiang@intel.com, dave.hansen@intel.com,
        dan.j.williams@intel.com, bharata@amd.com, apopple@nvidia.com,
        aneesh.kumar@linux.ibm.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] acpi-hmat-refactor-hmat_register_target_initiators.patch removed from -mm tree
Message-Id: <20231006214917.82A25C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: acpi, hmat: refactor hmat_register_target_initiators()
has been removed from the -mm tree.  Its filename was
     acpi-hmat-refactor-hmat_register_target_initiators.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: acpi, hmat: refactor hmat_register_target_initiators()
Date: Tue, 26 Sep 2023 14:06:26 +0800

Previously, in hmat_register_target_initiators(), the performance
attributes are calculated and the corresponding sysfs links and files are
created too.  Which is called during memory onlining.

But now, to calculate the abstract distance of a memory target before
memory onlining, we need to calculate the performance attributes for a
memory target without creating sysfs links and files.

To do that, hmat_register_target_initiators() is refactored to make it
possible to calculate performance attributes separately.

Link: https://lkml.kernel.org/r/20230926060628.265989-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Bharata B Rao <bharata@amd.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
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

 drivers/acpi/numa/hmat.c |   81 +++++++++++++------------------------
 1 file changed, 30 insertions(+), 51 deletions(-)

--- a/drivers/acpi/numa/hmat.c~acpi-hmat-refactor-hmat_register_target_initiators
+++ a/drivers/acpi/numa/hmat.c
@@ -582,28 +582,25 @@ static int initiators_to_nodemask(unsign
 	return 0;
 }
 
-static void hmat_register_target_initiators(struct memory_target *target)
+static void hmat_update_target_attrs(struct memory_target *target,
+				     unsigned long *p_nodes, int access)
 {
-	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
 	struct memory_initiator *initiator;
-	unsigned int mem_nid, cpu_nid;
+	unsigned int cpu_nid;
 	struct memory_locality *loc = NULL;
 	u32 best = 0;
-	bool access0done = false;
 	int i;
 
-	mem_nid = pxm_to_node(target->memory_pxm);
+	bitmap_zero(p_nodes, MAX_NUMNODES);
 	/*
-	 * If the Address Range Structure provides a local processor pxm, link
+	 * If the Address Range Structure provides a local processor pxm, set
 	 * only that one. Otherwise, find the best performance attributes and
-	 * register all initiators that match.
+	 * collect all initiators that match.
 	 */
 	if (target->processor_pxm != PXM_INVAL) {
 		cpu_nid = pxm_to_node(target->processor_pxm);
-		register_memory_node_under_compute_node(mem_nid, cpu_nid, 0);
-		access0done = true;
-		if (node_state(cpu_nid, N_CPU)) {
-			register_memory_node_under_compute_node(mem_nid, cpu_nid, 1);
+		if (access == 0 || node_state(cpu_nid, N_CPU)) {
+			set_bit(target->processor_pxm, p_nodes);
 			return;
 		}
 	}
@@ -617,47 +614,10 @@ static void hmat_register_target_initiat
 	 * We'll also use the sorting to prime the candidate nodes with known
 	 * initiators.
 	 */
-	bitmap_zero(p_nodes, MAX_NUMNODES);
 	list_sort(NULL, &initiators, initiator_cmp);
 	if (initiators_to_nodemask(p_nodes) < 0)
 		return;
 
-	if (!access0done) {
-		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
-			loc = localities_types[i];
-			if (!loc)
-				continue;
-
-			best = 0;
-			list_for_each_entry(initiator, &initiators, node) {
-				u32 value;
-
-				if (!test_bit(initiator->processor_pxm, p_nodes))
-					continue;
-
-				value = hmat_initiator_perf(target, initiator,
-							    loc->hmat_loc);
-				if (hmat_update_best(loc->hmat_loc->data_type, value, &best))
-					bitmap_clear(p_nodes, 0, initiator->processor_pxm);
-				if (value != best)
-					clear_bit(initiator->processor_pxm, p_nodes);
-			}
-			if (best)
-				hmat_update_target_access(target, loc->hmat_loc->data_type,
-							  best, 0);
-		}
-
-		for_each_set_bit(i, p_nodes, MAX_NUMNODES) {
-			cpu_nid = pxm_to_node(i);
-			register_memory_node_under_compute_node(mem_nid, cpu_nid, 0);
-		}
-	}
-
-	/* Access 1 ignores Generic Initiators */
-	bitmap_zero(p_nodes, MAX_NUMNODES);
-	if (initiators_to_nodemask(p_nodes) < 0)
-		return;
-
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)
@@ -667,7 +627,7 @@ static void hmat_register_target_initiat
 		list_for_each_entry(initiator, &initiators, node) {
 			u32 value;
 
-			if (!initiator->has_cpu) {
+			if (access == 1 && !initiator->has_cpu) {
 				clear_bit(initiator->processor_pxm, p_nodes);
 				continue;
 			}
@@ -681,14 +641,33 @@ static void hmat_register_target_initiat
 				clear_bit(initiator->processor_pxm, p_nodes);
 		}
 		if (best)
-			hmat_update_target_access(target, loc->hmat_loc->data_type, best, 1);
+			hmat_update_target_access(target, loc->hmat_loc->data_type, best, access);
 	}
+}
+
+static void __hmat_register_target_initiators(struct memory_target *target,
+					      unsigned long *p_nodes,
+					      int access)
+{
+	unsigned int mem_nid, cpu_nid;
+	int i;
+
+	mem_nid = pxm_to_node(target->memory_pxm);
+	hmat_update_target_attrs(target, p_nodes, access);
 	for_each_set_bit(i, p_nodes, MAX_NUMNODES) {
 		cpu_nid = pxm_to_node(i);
-		register_memory_node_under_compute_node(mem_nid, cpu_nid, 1);
+		register_memory_node_under_compute_node(mem_nid, cpu_nid, access);
 	}
 }
 
+static void hmat_register_target_initiators(struct memory_target *target)
+{
+	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
+
+	__hmat_register_target_initiators(target, p_nodes, 0);
+	__hmat_register_target_initiators(target, p_nodes, 1);
+}
+
 static void hmat_register_target_cache(struct memory_target *target)
 {
 	unsigned mem_nid = pxm_to_node(target->memory_pxm);
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-fix-draining-remote-pageset.patch

