From: akpm@linux-foundation.org
Subject: + mm-memblock-cleanup-on-duplicate-va-pa-conversion.patch added to -mm tree
Date: Fri, 25 May 2012 16:20:02 -0700
Message-ID: <20120525232003.7D311A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38801 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740Ab2EYXUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 19:20:06 -0400
Received: by wgbdt11 with SMTP id dt11so82348wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 16:20:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: mm/memblock: cleanup on duplicate VA/PA conversion
has been added to the -mm tree.  Its filename is
     mm-memblock-cleanup-on-duplicate-va-pa-conversion.patch

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
Subject: Subject: mm/memblock: cleanup on duplicate VA/PA conversion

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2.patch
mm-buddy-dump-pg_compound_lock-page-flag.patch
mm-page_alloc-catch-out-of-date-list-of-page-flag-names.patch
mm-page_allocc-cleanups.patch
mm-bootmemc-cleanup-on-addition-to-bootmem-data-list.patch
mm-memblock-cleanup-on-duplicate-va-pa-conversion.patch
mm-memblock-fix-memory-leak-on-extending-regions.patch

