From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-memblock-truncate-memblock-if-necessary.patch removed from -mm tree
Date: Fri, 24 Aug 2012 15:55:03 -0700
Message-ID: <20120824225504.9F3E15C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:35295 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab2HXWzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 18:55:07 -0400
Received: by eaac1 with SMTP id c1so112045eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 15:55:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, benh@kernel.crashing.org, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com, mhocko@suse.cz, minchan@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: truncate memblock if necessary
has been removed from the -mm tree.  Its filename was
     mm-memblock-truncate-memblock-if-necessary.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/memblock: truncate memblock if necessary

While enforcing memory limit on current memblock layout, it is possible
that we don't have to change the current memblock layout.  For example,
the enforced limited size is bigger than the maximal address of memory
regions.  Also, we don't have to change the memory layout while the
enforced limited size is more than the accumulative size of all memory
regions.

The patch checks them and won't change current memblock layout for
those cases, thus to reduce some overhead.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~mm-memblock-truncate-memblock-if-necessary mm/memblock.c
--- a/mm/memblock.c~mm-memblock-truncate-memblock-if-necessary
+++ a/mm/memblock.c
@@ -844,14 +844,14 @@ void __init memblock_enforce_memory_limi
 	unsigned long i;
 	phys_addr_t max_addr = (phys_addr_t)ULLONG_MAX;
 
-	if (!limit)
+	if (!limit || limit >= memblock_end_of_DRAM())
 		return;
 
 	/* find out max address */
 	for (i = 0; i < memblock.memory.cnt; i++) {
 		struct memblock_region *r = &memblock.memory.regions[i];
 
-		if (limit <= r->size) {
+		if (limit < r->size) {
 			max_addr = r->base + limit;
 			break;
 		}
@@ -859,8 +859,12 @@ void __init memblock_enforce_memory_limi
 	}
 
 	/* truncate both memory and reserved regions */
-	__memblock_remove(&memblock.memory, max_addr, (phys_addr_t)ULLONG_MAX);
-	__memblock_remove(&memblock.reserved, max_addr, (phys_addr_t)ULLONG_MAX);
+	if (max_addr < (phys_addr_t)ULLONG_MAX) {
+		__memblock_remove(&memblock.memory, max_addr,
+						(phys_addr_t)ULLONG_MAX);
+		__memblock_remove(&memblock.reserved, max_addr,
+						(phys_addr_t)ULLONG_MAX);
+	}
 }
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch
mm-vmscan-fix-error-number-for-failed-kthread.patch

