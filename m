From: akpm@linux-foundation.org
Subject: + mm-memblock-fix-overlapping-allocation-when-doubling-reserved-array.patch added to -mm tree
Date: Tue, 19 Jun 2012 15:14:41 -0700
Message-ID: <20120619221441.C2633A021F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:59824 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2FSWOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 18:14:43 -0400
Received: by qcsp5 with SMTP id p5so603630qcs.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 15:14:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: greg.pearson@hp.com, benh@kernel.crashing.org, tj@kernel.org, yinghai@kernel.org


The patch titled
     Subject: mm/memblock: fix overlapping allocation when doubling reserved array
has been added to the -mm tree.  Its filename is
     mm-memblock-fix-overlapping-allocation-when-doubling-reserved-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Greg Pearson <greg.pearson@hp.com>
Subject: mm/memblock: fix overlapping allocation when doubling reserved array

__alloc_memory_core_early() asks memblock for a range of memory then try
to reserve it.  If the reserved region array lacks space for the new
range, memblock_double_array() is called to allocate more space for the
array.  If memblock is used to allocate memory for the new array it can
end up using a range that overlaps with the range originally allocated in
__alloc_memory_core_early(), leading to possible data corruption.

With this patch memblock_double_array() now calls memblock_find_in_range()
with a narrowed candidate range (in cases where the reserved.regions array
is being doubled) so any memory allocated will not overlap with the
original range that was being reserved.  The range is narrowed by passing
in the starting address and size of the previously allocated range.  Then
the range above the ending address is searched and if a candidate is not
found, the range below the starting address is searched.

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff -puN mm/memblock.c~mm-memblock-fix-overlapping-allocation-when-doubling-reserved-array mm/memblock.c
--- a/mm/memblock.c~mm-memblock-fix-overlapping-allocation-when-doubling-reserved-array
+++ a/mm/memblock.c
@@ -184,7 +184,24 @@ static void __init_memblock memblock_rem
 	}
 }
 
-static int __init_memblock memblock_double_array(struct memblock_type *type)
+/**
+ * memblock_double_array - double the size of the memblock regions array
+ * @type: memblock type of the regions array being doubled
+ * @new_area_start: starting address of memory range to avoid overlap with
+ * @new_area_size: size of memory range to avoid overlap with
+ *
+ * Double the size of the @type regions array. If memblock is being used to
+ * allocate memory for a new reserved regions array and there is a previously
+ * allocated memory range [@new_area_start,@new_area_start+@new_area_size]
+ * waiting to be reserved, ensure the memory used by the new array does
+ * not overlap.
+ *
+ * RETURNS:
+ * 0 on success, -1 on failure.
+ */
+static int __init_memblock memblock_double_array(struct memblock_type *type,
+						phys_addr_t new_area_start,
+						phys_addr_t new_area_size)
 {
 	struct memblock_region *new_array, *old_array;
 	phys_addr_t old_size, new_size, addr;
@@ -222,7 +239,18 @@ static int __init_memblock memblock_doub
 		new_array = kmalloc(new_size, GFP_KERNEL);
 		addr = new_array ? __pa(new_array) : 0;
 	} else {
-		addr = memblock_find_in_range(0, MEMBLOCK_ALLOC_ACCESSIBLE, new_size, sizeof(phys_addr_t));
+		/* only exclude range when trying to double reserved.regions */
+		if (type != &memblock.reserved)
+			new_area_start = new_area_size = 0;
+
+		addr = memblock_find_in_range(new_area_start + new_area_size,
+						memblock.current_limit,
+						new_size, sizeof(phys_addr_t));
+		if (!addr && new_area_size)
+			addr = memblock_find_in_range(0,
+					min(new_area_start, memblock.current_limit),
+					new_size, sizeof(phys_addr_t));
+
 		new_array = addr ? __va(addr) : 0;
 	}
 	if (!addr) {
@@ -399,7 +427,7 @@ repeat:
 	 */
 	if (!insert) {
 		while (type->cnt + nr_new > type->max)
-			if (memblock_double_array(type) < 0)
+			if (memblock_double_array(type, obase, size) < 0)
 				return -ENOMEM;
 		insert = true;
 		goto repeat;
@@ -450,7 +478,7 @@ static int __init_memblock memblock_isol
 
 	/* we'll create at most two more regions */
 	while (type->cnt + 2 > type->max)
-		if (memblock_double_array(type) < 0)
+		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
 	for (i = 0; i < type->cnt; i++) {
_
Subject: Subject: mm/memblock: fix overlapping allocation when doubling reserved array

Patches currently in -mm which might be from greg.pearson@hp.com are

mm-memblock-fix-overlapping-allocation-when-doubling-reserved-array.patch

