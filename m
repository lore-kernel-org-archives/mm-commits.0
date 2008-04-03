From: akpm@linux-foundation.org
Subject: - mm-make-mem_map-allocation-continuous.patch removed from -mm tree
Date: Thu, 03 Apr 2008 15:16:13 -0700
Message-ID: <200804032216.m33MGDsS025302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757255AbYDCWRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 18:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, akpm@linux-foundation.org, apw@shadowen.org, bob.picco@hp.com, clameter@sgi.com, haveblue@us.ibm.com, kamalesh@linux.vnet.ibm.com, kamezawa.hiroyu@j


The patch titled
     mm: make mem_map allocation continuous
has been removed from the -mm tree.  Its filename was
     mm-make-mem_map-allocation-continuous.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make mem_map allocation continuous
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

vmemmap allocation current got
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001c00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810002000000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002400000 on node 0
...

there is 2M hole between them.

the rootcause is that usemap (24 bytes) will be allocated after every 2M
mem_map. and it will push next vmemmap (2M) to next align (2M).

solution:
try to allocate mem_map continously.

after patch, will get
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001400000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001800000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810001c00000 on node 0
...
and usemap will share in page because of they are allocated continuously too.
sparse_early_usemap_alloc: usemap = ffff810024e00000 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00080 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00100 size = 24
sparse_early_usemap_alloc: usemap = ffff810024e00180 size = 24
...

so we make the bootmem allocation more compact and use less memory for usemap.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Bob Picco <bob.picco@hp.com>
Cc: Christoph Lameter <clameter@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN mm/sparse.c~mm-make-mem_map-allocation-continuous mm/sparse.c
--- a/mm/sparse.c~mm-make-mem_map-allocation-continuous
+++ a/mm/sparse.c
@@ -244,6 +244,7 @@ static unsigned long *__init sparse_earl
 	int nid = sparse_early_nid(ms);
 
 	usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
+	printk(KERN_INFO "sparse_early_usemap_alloc: usemap = %p size = %ld\n", usemap, usemap_size());
 	if (usemap)
 		return usemap;
 
@@ -285,6 +286,8 @@ struct page __init *sparse_early_mem_map
 	return NULL;
 }
 
+/* section_map pointer array is 64k */
+static __initdata struct page *section_map[NR_MEM_SECTIONS];
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
@@ -295,14 +298,29 @@ void __init sparse_init(void)
 	struct page *map;
 	unsigned long *usemap;
 
+	/*
+	 * map is using big page (aka 2M in x86 64 bit)
+	 * usemap is less one page (aka 24 bytes)
+	 * so alloc 2M (with 2M align) and 24 bytes in turn will
+	 * make next 2M slip to one more 2M later.
+	 * then in big system, the memmory will have a lot hole...
+	 * here try to allocate 2M pages continously.
+	 */
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
+		section_map[pnum] = sparse_early_mem_map_alloc(pnum);
+	}
 
-		map = sparse_early_mem_map_alloc(pnum);
-		if (!map)
+
+	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
+		if (!present_section_nr(pnum))
 			continue;
 
+		map = section_map[pnum];
+		if (!map)
+			 continue;
+
 		usemap = sparse_early_usemap_alloc(pnum);
 		if (!usemap)
 			continue;
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

x86_64-do-not-reserve-ramdisk-two-times.patch
mm-make-mem_map-allocation-continuous.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
mm-allocate-section_map-for-sparse_init.patch
mm-allocate-section_map-for-sparse_init-update.patch
mm-allocate-section_map-for-sparse_init-powerpc-fix.patch
mm-fix-alloc_bootmem_core-to-use-fast-searching-for-all-nodes.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch

