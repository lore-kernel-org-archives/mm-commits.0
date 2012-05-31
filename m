From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-cleanup-on-duplicate-va-pa-conversion.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:36 -0700
Message-ID: <20120531191636.56208A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:38090 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab2EaTQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:38 -0400
Received: by mail-wi0-f202.google.com with SMTP id hn6so76974wib.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: cleanup on duplicate VA/PA conversion
has been removed from the -mm tree.  Its filename was
     mm-memblock-cleanup-on-duplicate-va-pa-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/memblock: cleanup on duplicate VA/PA conversion

The overall memblock has been organized into the memory regions and
reserved regions.  Initially, the memory regions and reserved regions are
stored in the predetermined arrays of "struct memblock _region".  It's
possible for the arrays to be enlarged when we have newly added regions
for them, but no enough space there.  Under the situation, We will created
double-sized array to meet the requirement.  However, the original
implementation converted the VA (Virtual Address) of the newly allocated
array of regions to PA (Physical Address), then translate back when we
allocates the new array from slab.  That's actually unnecessary.

The patch removes the duplicate VA/PA conversion.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/memblock.c~mm-memblock-cleanup-on-duplicate-va-pa-conversion mm/memblock.c
--- a/mm/memblock.c~mm-memblock-cleanup-on-duplicate-va-pa-conversion
+++ a/mm/memblock.c
@@ -212,14 +212,15 @@ static int __init_memblock memblock_doub
 	if (use_slab) {
 		new_array = kmalloc(new_size, GFP_KERNEL);
 		addr = new_array ? __pa(new_array) : 0;
-	} else
+	} else {
 		addr = memblock_find_in_range(0, MEMBLOCK_ALLOC_ACCESSIBLE, new_size, sizeof(phys_addr_t));
+		new_array = addr ? __va(addr) : 0;
+	}
 	if (!addr) {
 		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
 		       memblock_type_name(type), type->max, type->max * 2);
 		return -1;
 	}
-	new_array = __va(addr);
 
 	memblock_dbg("memblock: %s array is doubled to %ld at [%#010llx-%#010llx]",
 		 memblock_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size - 1);
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch

