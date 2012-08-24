From: akpm@linux-foundation.org
Subject: + mm-memblock-truncate-memblock-if-necessary.patch added to -mm tree
Date: Fri, 24 Aug 2012 14:48:11 -0700
Message-ID: <20120824214812.954EA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:53801 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2HXVsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 17:48:15 -0400
Received: by lbbge1 with SMTP id ge1so111812lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 14:48:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, benh@kernel.crashing.org, kamezawa.hiroyu@jp.fujitsu.com, liwanp@linux.vnet.ibm.com, mhocko@suse.cz, minchan@kernel.org, yinghai@kernel.org


The patch titled
     Subject: mm/memblock: truncate memblock if necessary
has been added to the -mm tree.  Its filename is
     mm-memblock-truncate-memblock-if-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-memblock-truncate-memblock-if-necessary.patch
mm-memblock-rename-get_allocated_memblock_reserved_regions_info.patch
mm-memblock-reduce-overhead-in-binary-search.patch
mm-memblock-use-existing-interface-to-set-nid.patch
mm-memblock-cleanup-early_node_map-related-comments.patch

