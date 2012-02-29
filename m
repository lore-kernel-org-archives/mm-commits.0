From: akpm@linux-foundation.org
Subject: + bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch added to -mm tree
Date: Wed, 29 Feb 2012 15:29:05 -0800
Message-ID: <20120229232905.83F20A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:57092 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2B2X3H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 18:29:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nacc@linux.vnet.ibm.com, anton@au1.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, haveblue@us.ibm.com, nacc@us.ibm.com, paulus@samba.org, rcj@linux.vnet.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: bootmem/sparsemem: remove limit constraint in alloc_bootmem_section
has been added to the -mm tree.  Its filename is
     bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: bootmem/sparsemem: remove limit constraint in alloc_bootmem_section

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
sparse_early_usemaps_alloc_pgdat_section calls

	return alloc_bootmem_section(usemap_size() * count, section_nr);

This is on a system with 8TB available via the AMS pool, and as a quirk of
AMS in firmware, all of that memory shows up in node 0.  So, we end up
with an allocation that will fail the goal/limit constraints.  In theory,
we could "fall-back" to alloc_bootmem_node() in
sparse_early_usemaps_alloc_node(), but since we actually have HOTREMOVE
defined, we'll BUG_ON() instead.  A simple solution appears to be to
unconditionally remove the limit condition in alloc_bootmem_section,
meaning allocations are allowed to cross section boundaries (necessary for
systems of this size).

Johannes Weiner pointed out that if alloc_bootmem_section() no longer
guarantees section-locality, we need check_usemap_section_nr() to print
possible cross-dependencies between node descriptors and the usemaps
allocated through it.  That makes the two loops in
sparse_early_usemaps_alloc_node() identical, so re-factor the code a bit.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>	[3.3.1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    2 +-
 mm/sparse.c  |   30 +++++++++++-------------------
 2 files changed, 12 insertions(+), 20 deletions(-)

diff -puN mm/bootmem.c~bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section mm/bootmem.c
--- a/mm/bootmem.c~bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section
+++ a/mm/bootmem.c
@@ -770,7 +770,7 @@ void * __init alloc_bootmem_section(unsi
 
 	pfn = section_nr_to_pfn(section_nr);
 	goal = pfn << PAGE_SHIFT;
-	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+	limit = 0;
 	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
 	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
diff -puN mm/sparse.c~bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section mm/sparse.c
--- a/mm/sparse.c~bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section
+++ a/mm/sparse.c
@@ -353,29 +353,21 @@ static void __init sparse_early_usemaps_
 
 	usemap = sparse_early_usemaps_alloc_pgdat_section(NODE_DATA(nodeid),
 								 usemap_count);
-	if (usemap) {
-		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
-			if (!present_section_nr(pnum))
-				continue;
-			usemap_map[pnum] = usemap;
-			usemap += size;
+	if (!usemap) {
+		usemap = alloc_bootmem_node(NODE_DATA(nodeid), size * usemap_count);
+		if (!usemap) {
+			printk(KERN_WARNING "%s: allocation failed\n", __func__);
+			return;
 		}
-		return;
 	}
 
-	usemap = alloc_bootmem_node(NODE_DATA(nodeid), size * usemap_count);
-	if (usemap) {
-		for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
-			if (!present_section_nr(pnum))
-				continue;
-			usemap_map[pnum] = usemap;
-			usemap += size;
-			check_usemap_section_nr(nodeid, usemap_map[pnum]);
-		}
-		return;
+	for (pnum = pnum_begin; pnum < pnum_end; pnum++) {
+		if (!present_section_nr(pnum))
+			continue;
+		usemap_map[pnum] = usemap;
+		usemap += size;
+		check_usemap_section_nr(nodeid, usemap_map[pnum]);
 	}
