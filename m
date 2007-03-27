From: akpm@linux-foundation.org
Subject: - x86_64-configurable-fake-numa-node-sizes-fix.patch removed from -mm tree
Date: Mon, 26 Mar 2007 22:00:54 -0800
Message-ID: <200703270600.l2R60sWH008825@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013AbXC0GBE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Mar 2007 02:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, clameter@engr.sgi.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: remove SRAT active ranges for fake numa
has been removed from the -mm tree.  Its filename was
     x86_64-configurable-fake-numa-node-sizes-fix.patch

This patch was dropped because it was folded into x86_64-configurable-fake-numa-node-sizes.patch

------------------------------------------------------
Subject: x86_64: remove SRAT active ranges for fake numa
From: David Rientjes <rientjes@google.com>

Make sure we do not have any current active ranges (most notably from SRAT)
registered when we are setting up NUMA emulation.  Otherwise, we'll lose
the new fake node ID's if the smaller emulated nodes map onto existing
registered active ranges with physical node ID's.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/k8topology.c |    7 ++++---
 arch/x86_64/mm/numa.c       |    6 ++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/mm/k8topology.c~x86_64-configurable-fake-numa-node-sizes-fix arch/x86_64/mm/k8topology.c
--- a/arch/x86_64/mm/k8topology.c~x86_64-configurable-fake-numa-node-sizes-fix
+++ a/arch/x86_64/mm/k8topology.c
@@ -149,9 +149,10 @@ int __init k8_scan_nodes(unsigned long s
 		
 		nodes[nodeid].start = base; 
 		nodes[nodeid].end = limit;
-		e820_register_active_regions(nodeid,
-				nodes[nodeid].start >> PAGE_SHIFT,
-				nodes[nodeid].end >> PAGE_SHIFT);
+		if (!fake)
+			e820_register_active_regions(nodeid,
+					nodes[nodeid].start >> PAGE_SHIFT,
+					nodes[nodeid].end >> PAGE_SHIFT);
 
 		prevbase = base;
 
diff -puN arch/x86_64/mm/numa.c~x86_64-configurable-fake-numa-node-sizes-fix arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-configurable-fake-numa-node-sizes-fix
+++ a/arch/x86_64/mm/numa.c
@@ -432,6 +432,12 @@ out:
 		       "disabled.\n");
 		return -1;
 	}
+
+	/*
+	 * We need to vacate all active ranges that may have been registered by
+	 * SRAT.
+	 */
+	remove_all_active_ranges();
 	for_each_online_node(i) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
_

Patches currently in -mm which might be from rientjes@google.com are

x86_64-configurable-fake-numa-node-sizes.patch
x86_64-configurable-fake-numa-node-sizes-fix.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
i386-add-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix-2.patch
smaps-add-clear_refs-file-to-clear-reference-cleanup.patch
smaps-use-ptep_test_and_clear_young.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
