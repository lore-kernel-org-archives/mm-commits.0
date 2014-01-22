From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:14:32 -0800
Message-ID: <52e026a8.mtOyXykdttkGYSjl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaAVUOd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tj@kernel.org, santosh.shilimkar@ti.com, grygorii.strashko@ti.com

Subject: [merged] mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch removed from -mm tree
To: grygorii.strashko@ti.com,santosh.shilimkar@ti.com,tj@kernel.org,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:32 -0800


The patch titled
     Subject: mm/memblock: use WARN_ONCE when MAX_NUMNODES passed as input parameter
has been removed from the -mm tree.  Its filename was
     mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Grygorii Strashko <grygorii.strashko@ti.com>
Subject: mm/memblock: use WARN_ONCE when MAX_NUMNODES passed as input parameter

Check nid parameter and produce warning if it has deprecated MAX_NUMNODES
value.  Also re-assign NUMA_NO_NODE value to the nid parameter in this
case.

These will help to identify the wrong API usage (the caller) and make code
simpler.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN mm/memblock.c~mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter mm/memblock.c
--- a/mm/memblock.c~mm-memblock-use-warn_once-when-max_numnodes-passed-as-input-parameter
+++ a/mm/memblock.c
@@ -785,11 +785,9 @@ void __init_memblock __next_free_mem_ran
 	struct memblock_type *rsv = &memblock.reserved;
 	int mi = *idx & 0xffffffff;
 	int ri = *idx >> 32;
-	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
-	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
-			     __func__);
+	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
+		nid = NUMA_NO_NODE;
 
 	for ( ; mi < mem->cnt; mi++) {
 		struct memblock_region *m = &mem->regions[mi];
@@ -797,7 +795,7 @@ void __init_memblock __next_free_mem_ran
 		phys_addr_t m_end = m->base + m->size;
 
 		/* only memory regions are associated with nodes, check it */
-		if (check_node && nid != memblock_get_region_node(m))
+		if (nid != NUMA_NO_NODE && nid != memblock_get_region_node(m))
 			continue;
 
 		/* scan areas before each reservation for intersection */
@@ -858,11 +856,9 @@ void __init_memblock __next_free_mem_ran
 	struct memblock_type *rsv = &memblock.reserved;
 	int mi = *idx & 0xffffffff;
 	int ri = *idx >> 32;
-	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
 
-	if (nid == MAX_NUMNODES)
-		pr_warn_once("%s: Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n",
-			     __func__);
+	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
+		nid = NUMA_NO_NODE;
 
 	if (*idx == (u64)ULLONG_MAX) {
 		mi = mem->cnt - 1;
@@ -875,7 +871,7 @@ void __init_memblock __next_free_mem_ran
 		phys_addr_t m_end = m->base + m->size;
 
 		/* only memory regions are associated with nodes, check it */
-		if (check_node && nid != memblock_get_region_node(m))
+		if (nid != NUMA_NO_NODE && nid != memblock_get_region_node(m))
 			continue;
 
 		/* skip hotpluggable memory regions if needed */
@@ -1067,9 +1063,8 @@ static void * __init memblock_virt_alloc
 	phys_addr_t alloc;
 	void *ptr;
 
-	if (nid == MAX_NUMNODES)
-		pr_warn("%s: usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE\n",
-			__func__);
+	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
+		nid = NUMA_NO_NODE;
 
 	/*
 	 * Detect any accidental use of these APIs after slab is ready, as at
_

Patches currently in -mm which might be from grygorii.strashko@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
rtc-rtc-twl-use-devm_-functions.patch
rtc-rtc-vr41xx-use-devm_-functions.patch
linux-next.patch

