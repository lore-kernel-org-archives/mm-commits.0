From: akpm@linux-foundation.org
Subject: + x86nobootmem-make-alloc_bootmem_node-fall-back-to-other-node-when-32bit-numa-is-used.patch added to -mm tree
Date: Mon, 12 Jul 2010 00:34:18 -0700
Message-ID: <201007120734.o6C7YOsS026463@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754171Ab0GLHhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jul 2010 03:37:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, borislav.petkov@amd.com, conny.seidel@amd.com, hannes@cmpxchg.org, hpa@zytor.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, mingo@elte.hu, stable@kernel.org, tglx@linutronix.de


The patch titled
     x86,nobootmem: make alloc_bootmem_node fall back to other node when 32bit numa is used
has been added to the -mm tree.  Its filename is
     x86nobootmem-make-alloc_bootmem_node-fall-back-to-other-node-when-32bit-numa-is-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86,nobootmem: make alloc_bootmem_node fall back to other node when 32bit numa is used
From: Yinghai Lu <yinghai@kernel.org>

Borislav Petkov reported his 32bit numa system has problem:

[    0.000000] Reserving total of 4c00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 32800 max_low_pfn ~ 375fe
[    0.000000] max_pfn = 238000
[    0.000000] 8202MB HIGHMEM available.
[    0.000000] 885MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 375fe000
[    0.000000]   low ram: 0 - 375fe000
[    0.000000] alloc (nid=8 100000 - 7ee00000) (1000000 - ffffffff) 1000 1000 => 34e7000
[    0.000000] alloc (nid=8 100000 - 7ee00000) (1000000 - ffffffff) 200 40 => 34c9d80
[    0.000000] alloc (nid=0 100000 - 7ee00000) (1000000 - ffffffffffffffff) 180 40 => 34e6140
[    0.000000] alloc (nid=1 80000000 - c7e60000) (1000000 - ffffffffffffffff) 240 40 => 80000000
[    0.000000] BUG: unable to handle kernel paging request at 40000000
[    0.000000] IP: [<c2c8cff1>] __alloc_memory_core_early+0x147/0x1d6
[    0.000000] *pdpt = 0000000000000000 *pde = f000ff53f000ff00
...
[    0.000000] Call Trace:
[    0.000000]  [<c2c8b4f8>] ? __alloc_bootmem_node+0x216/0x22f
[    0.000000]  [<c2c90c9b>] ? sparse_early_usemaps_alloc_node+0x5a/0x10b
[    0.000000]  [<c2c9149e>] ? sparse_init+0x1dc/0x499
[    0.000000]  [<c2c79118>] ? paging_init+0x168/0x1df
[    0.000000]  [<c2c780ff>] ? native_pagetable_setup_start+0xef/0x1bb

looks like it allocate much high address for bootmem.

Try to cut limit with get_max_mapped()

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Tested-by: Conny Seidel <conny.seidel@amd.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@kernel.org>		[2.6.34.x]
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c    |   24 ++++++++++++++++++++----
 mm/page_alloc.c |    3 +++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff -puN mm/bootmem.c~x86nobootmem-make-alloc_bootmem_node-fall-back-to-other-node-when-32bit-numa-is-used mm/bootmem.c
--- a/mm/bootmem.c~x86nobootmem-make-alloc_bootmem_node-fall-back-to-other-node-when-32bit-numa-is-used
+++ a/mm/bootmem.c
@@ -833,15 +833,24 @@ static void * __init ___alloc_bootmem_no
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
+	void *ptr;
+
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
 #ifdef CONFIG_NO_BOOTMEM
-	return __alloc_memory_core_early(pgdat->node_id, size, align,
+	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+					 goal, -1ULL);
+	if (ptr)
+		return ptr;
+
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
 					 goal, -1ULL);
 #else
-	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
+	ptr = ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
 #endif
+
+	return ptr;
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
@@ -977,14 +986,21 @@ void * __init __alloc_bootmem_low(unsign
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
+	void *ptr;
+
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
 #ifdef CONFIG_NO_BOOTMEM
-	return __alloc_memory_core_early(pgdat->node_id, size, align,
+	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
+	if (ptr)
+		return ptr;
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
 #else
-	return ___alloc_bootmem_node(pgdat->bdata, size, align,
+	ptr = ___alloc_bootmem_node(pgdat->bdata, size, align,
 				goal, ARCH_LOW_ADDRESS_LIMIT);
 #endif
+	return ptr;
 }
diff -puN mm/page_alloc.c~x86nobootmem-make-alloc_bootmem_node-fall-back-to-other-node-when-32bit-numa-is-used mm/page_alloc.c
--- a/mm/page_alloc.c~x86nobootmem-make-alloc_bootmem_node-fall-back-to-other-node-when-32bit-numa-is-used
+++ a/mm/page_alloc.c
@@ -3634,6 +3634,9 @@ void * __init __alloc_memory_core_early(
 	int i;
 	void *ptr;
 
+	if (limit > get_max_mapped())
+		limit = get_max_mapped();
+
 	/* need to go over early_node_map to find out good range for node */
 	for_each_active_range_index_in_nid(i, nid) {
 		u64 addr;
_

Patches currently in -mm which might be from yinghai@kernel.org are

x86-numa-fix-boot-without-ram-on-node0-again.patch
x86-numa-fix-boot-without-ram-on-node0-again-fix.patch
linux-next.patch
x86nobootmem-make-alloc_bootmem_node-fall-back-to-other-node-when-32bit-numa-is-used.patch
kernel-range-remove-unused-definition-of-array_size.patch

