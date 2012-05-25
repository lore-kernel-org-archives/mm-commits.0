From: akpm@linux-foundation.org
Subject: + mm-memblock-fix-memory-leak-on-extending-regions.patch added to -mm tree
Date: Fri, 25 May 2012 16:20:06 -0700
Message-ID: <20120525232006.3286FA022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:63194 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740Ab2EYXUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 May 2012 19:20:07 -0400
Received: by ghbz15 with SMTP id z15so101313ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 16:20:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: mm/memblock: fix memory leak on extending regions
has been added to the -mm tree.  Its filename is
     mm-memblock-fix-memory-leak-on-extending-regions.patch

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
Subject: mm/memblock: fix memory leak on extending regions

The overall memblock has been organized into the memory regions and
reserved regions.  Initially, the memory regions and reserved regions are
stored in the predetermined arrays of "struct memblock _region".  It's
possible for the arrays to be enlarged when we have newly added regions,
but no free space left there.  The policy here is to create double-sized
array either by slab allocator or memblock allocator.  Unfortunately, we
didn't free the old array, which might be allocated through slab allocator
before.  That would cause memory leak.

The patch introduces 2 variables to trace where (slab or memblock) the
memory and reserved regions come from.  The memory for the memory or
reserved regions will be deallocated by kfree() if that was allocated by
slab allocator.  Thus to fix the memory leak issue.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff -puN mm/memblock.c~mm-memblock-fix-memory-leak-on-extending-regions mm/memblock.c
--- a/mm/memblock.c~mm-memblock-fix-memory-leak-on-extending-regions
+++ a/mm/memblock.c
@@ -37,6 +37,8 @@ struct memblock memblock __initdata_memb
 
 int memblock_debug __initdata_memblock;
 static int memblock_can_resize __initdata_memblock;
+static int memblock_memory_in_slab __initdata_memblock = 0;
+static int memblock_reserved_in_slab __initdata_memblock = 0;
 
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *memblock_type_name(struct memblock_type *type)
@@ -187,6 +189,7 @@ static int __init_memblock memblock_doub
 	struct memblock_region *new_array, *old_array;
 	phys_addr_t old_size, new_size, addr;
 	int use_slab = slab_is_available();
+	int *in_slab;
 
 	/* We don't allow resizing until we know about the reserved regions
 	 * of memory that aren't suitable for allocation
@@ -198,6 +201,12 @@ static int __init_memblock memblock_doub
 	old_size = type->max * sizeof(struct memblock_region);
 	new_size = old_size << 1;
 
+	/* Retrieve the slab flag */
+	if (type == &memblock.memory)
+		in_slab = &memblock_memory_in_slab;
+	else
+		in_slab = &memblock_reserved_in_slab;
+
 	/* Try to find some space for it.
 	 *
 	 * WARNING: We assume that either slab_is_available() and we use it or
@@ -235,22 +244,24 @@ static int __init_memblock memblock_doub
 	type->regions = new_array;
 	type->max <<= 1;
 
-	/* If we use SLAB that's it, we are done */
-	if (use_slab)
-		return 0;
-
-	/* Add the new reserved region now. Should not fail ! */
-	BUG_ON(memblock_reserve(addr, new_size));
-
-	/* If the array wasn't our static init one, then free it. We only do
-	 * that before SLAB is available as later on, we don't know whether
-	 * to use kfree or free_bootmem_pages(). Shouldn't be a big deal
-	 * anyways
+	/* Free old array. We needn't free it if the array is the
+	 * static one
 	 */
-	if (old_array != memblock_memory_init_regions &&
-	    old_array != memblock_reserved_init_regions)
+	if (*in_slab)
+		kfree(old_array);
+	else if (old_array != memblock_memory_init_regions &&
+		 old_array != memblock_reserved_init_regions)
 		memblock_free(__pa(old_array), old_size);
 
+	/* Reserve the new array if that comes from the memblock.
+	 * Otherwise, we needn't do it
+	 */
+	if (!use_slab)
+		BUG_ON(memblock_reserve(addr, new_size));
+
+	/* Update slab flag */
+	*in_slab = use_slab;
+
 	return 0;
 }
 
_
Subject: Subject: mm/memblock: fix memory leak on extending regions

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

