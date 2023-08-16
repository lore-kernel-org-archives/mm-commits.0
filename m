Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B426C27C6D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Aug 2023 22:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347024AbjHPWuQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Aug 2023 18:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347014AbjHPWtq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Aug 2023 18:49:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB1FFD
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 15:49:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4ACCE63E0F
        for <mm-commits@vger.kernel.org>; Wed, 16 Aug 2023 22:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB22C433C7;
        Wed, 16 Aug 2023 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692226183;
        bh=QN1T2c/z+VSlj9S2Geoy7/uPMQ5cKIKCauDoZ7zAmS0=;
        h=Date:To:From:Subject:From;
        b=f4cPhO/xSQQBfO/2s6XbmHRwbU1OZdsnP6bfN4HKeaSL+TqymSiMMfiuKNSeyw+eI
         rD7+EnkGJcNyG7oslJjwKXGdoKHgbk6jG0QG+WqeYUjKklbr8ezYRT3XWYByBMPgm+
         Ez4ucwybfVEsXTbwQSn49+Mp68Rpjld+ADRf5huQ=
Date:   Wed, 16 Aug 2023 15:49:43 -0700
To:     mm-commits@vger.kernel.org, weixugc@google.com,
        shy828301@gmail.com, rafael.j.wysocki@intel.com, mhocko@kernel.org,
        Jonathan.Cameron@huawei.com, hannes@cmpxchg.org, dave@stgolabs.net,
        dave.hansen@intel.com, dan.j.williams@intel.com, bharata@amd.com,
        apopple@nvidia.com, aneesh.kumar@linux.ibm.com,
        ying.huang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + acpi-hmat-refactor-hmat_register_target_initiators.patch added to mm-unstable branch
Message-Id: <20230816224943.9FB22C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: acpi, hmat: refactor hmat_register_target_initiators()
has been added to the -mm mm-unstable branch.  Its filename is
     acpi-hmat-refactor-hmat_register_target_initiators.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/acpi-hmat-refactor-hmat_register_target_initiators.patch

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
Subject: acpi, hmat: refactor hmat_register_target_initiators()
Date: Wed, 16 Aug 2023 16:00:22 +0800

Previously, in hmat_register_target_initiators(), the performance
attributes are calculated and the corresponding sysfs links and files
are created too.  Which is called during memory onlining.

But now, to calculate the abstract distance of a memory target before
memory onlining, we need to calculate the performance attributes for
a memory target without creating sysfs links and files.

To do that, hmat_register_target_initiators() is refactored to make it
possible to calculate performance attributes separately.

Link: https://lkml.kernel.org/r/20230816080024.105554-3-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Alistair Popple <apopple@nvidia.com>
Tested-by: Bharata B Rao <bharata@amd.com>
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

memory-tiering-add-abstract-distance-calculation-algorithms-management.patch
acpi-hmat-refactor-hmat_register_target_initiators.patch
acpi-hmat-calculate-abstract-distance-with-hmat.patch
dax-kmem-calculate-abstract-distance-with-general-interface.patch

