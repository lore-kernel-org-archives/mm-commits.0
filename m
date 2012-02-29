From: akpm@linux-foundation.org
Subject: [to-be-updated] sparsemem-bootmem-catch-greater-than-section-size-allocations.patch removed from -mm tree
Date: Wed, 29 Feb 2012 15:22:19 -0800
Message-ID: <20120229232221.C0DDFA02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:41487 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2B2XWZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 18:22:25 -0500
Received: by qcsp5 with SMTP id p5so256327qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 15:22:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nacc@us.ibm.com, anton@au1.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, haveblue@us.ibm.com, paulus@samba.org, rcj@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sparsemem/bootmem: catch greater than section size allocations
has been removed from the -mm tree.  Its filename was
     sparsemem-bootmem-catch-greater-than-section-size-allocations.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: sparsemem/bootmem: catch greater than section size allocations

While testing AMS (Active Memory Sharing) / CMO (Cooperative Memory
Overcommit) on powerpc, we tripped the following:

kernel BUG at mm/bootmem.c:483!
cpu 0x0: Vector: 700 (Program Check) at [c000000000c03940]
    pc: c000000000a62bd8: .alloc_bootmem_core+0x90/0x39c
    lr: c000000000a64bcc: .sparse_early_usemaps_alloc_node+0x84/0x29c
    sp: c000000000c03bc0
   msr: 8000000000021032
  current = 0xc000000000b0cce0
  paca    = 0xc000000001d80000
    pid   = 0, comm = swapper
kernel BUG at mm/bootmem.c:483!
enter ? for help
[c000000000c03c80] c000000000a64bcc
.sparse_early_usemaps_alloc_node+0x84/0x29c
[c000000000c03d50] c000000000a64f10 .sparse_init+0x12c/0x28c
[c000000000c03e20] c000000000a474f4 .setup_arch+0x20c/0x294
[c000000000c03ee0] c000000000a4079c .start_kernel+0xb4/0x460
[c000000000c03f90] c000000000009670 .start_here_common+0x1c/0x2c

This is

        BUG_ON(limit && goal + size > limit);

and after some debugging, it seems that

	goal = 0x7ffff000000
	limit = 0x80000000000

and sparse_early_usemaps_alloc_node ->
sparse_early_usemaps_alloc_pgdat_section -> alloc_bootmem_section calls

	return alloc_bootmem_section(usemap_size() * count, section_nr);

This is on a system with 8TB available via the AMS pool, and as a quirk of
AMS in firmware, all of that memory shows up in node 0.  So, we end up
with an allocation that will fail the goal/limit constraints.  In theory,
we could "fall-back" to alloc_bootmem_node() in
sparse_early_usemaps_alloc_node(), but since we actually have HOTREMOVE
defined, we'll BUG_ON() instead.  A simple solution appears to be to
disable the limit check if the size of the allocation in
alloc_bootmem_secition exceeds the section size.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 mm/bootmem.c           |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~sparsemem-bootmem-catch-greater-than-section-size-allocations include/linux/mmzone.h
--- a/include/linux/mmzone.h~sparsemem-bootmem-catch-greater-than-section-size-allocations
+++ a/include/linux/mmzone.h
@@ -967,6 +967,8 @@ static inline unsigned long early_pfn_to
  * PA_SECTION_SHIFT		physical address to/from section number
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
+#define BYTES_PER_SECTION	(1UL << SECTION_SIZE_BITS)
+
 #define SECTIONS_SHIFT		(MAX_PHYSMEM_BITS - SECTION_SIZE_BITS)
 
 #define PA_SECTION_SHIFT	(SECTION_SIZE_BITS)
diff -puN mm/bootmem.c~sparsemem-bootmem-catch-greater-than-section-size-allocations mm/bootmem.c
--- a/mm/bootmem.c~sparsemem-bootmem-catch-greater-than-section-size-allocations
+++ a/mm/bootmem.c
@@ -770,7 +770,10 @@ void * __init alloc_bootmem_section(unsi
 
 	pfn = section_nr_to_pfn(section_nr);
 	goal = pfn << PAGE_SHIFT;
-	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+	if (size > BYTES_PER_SECTION)
+		limit = 0;
+	else
+		limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
 	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
_

Patches currently in -mm which might be from nacc@us.ibm.com are


