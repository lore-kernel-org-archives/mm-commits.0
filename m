From: akpm@linux-foundation.org
Subject: - mm-allocate-section_map-for-sparse_init-powerpc-fix.patch removed from -mm tree
Date: Thu, 03 Apr 2008 15:16:29 -0700
Message-ID: <200804032216.m33MGUfB025321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260AbYDCWRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2008 18:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel.send@gmail.com, ak@suse.de, clameter@sgi.com, kamalesh@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, michael@ellerman.id.au, mingo@elte.hu, pbadari@us


The patch titled
     mm: allocate usemap at first instead of mem_map in sparse_init
has been removed from the -mm tree.  Its filename was
     mm-allocate-section_map-for-sparse_init-powerpc-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: allocate usemap at first instead of mem_map in sparse_init
From: Yinghai Lu <yhlu.kernel.send@gmail.com>

on powerpc,

On Wed, Apr 2, 2008 at 12:22 PM, Badari Pulavarty <pbadari@us.ibm.com> wrote:
>
> On Wed, 2008-04-02 at 18:17 +1100, Michael Ellerman wrote:
>  > On Wed, 2008-04-02 at 12:38 +0530, Kamalesh Babulal wrote:
>  > > Andrew Morton wrote:
>  > > > On Wed, 02 Apr 2008 11:55:36 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>  > > >
>  > > >> Hi Andrew,
>  > > >>
>  > > >> The 2.6.25-rc8-mm1 kernel panic's while bootup on the power machine(s).
>  > > >>
>  > > >> [    0.000000] ------------[ cut here ]------------
>  > > >> [    0.000000] kernel BUG at arch/powerpc/mm/init_64.c:240!
>  > > >> [    0.000000] Oops: Exception in kernel mode, sig: 5 [#1]
>  > > >> [    0.000000] SMP NR_CPUS=32 NUMA PowerMac
>  > > >> [    0.000000] Modules linked in:
>  > > >> [    0.000000] NIP: c0000000003d1dcc LR: c0000000003d1dc4 CTR: c00000000002b6ac
>  > > >> [    0.000000] REGS: c00000000049b960 TRAP: 0700   Not tainted  (2.6.25-rc8-mm1-autokern1)
>  > > >> [    0.000000] MSR: 9000000000021032 <ME,IR,DR>  CR: 44000088  XER: 20000000
>  > > >> [    0.000000] TASK = c0000000003f9c90[0] 'swapper' THREAD: c000000000498000 CPU: 0
>  > > >> [    0.000000] GPR00: c0000000003d1dc4 c00000000049bbe0 c0000000004989d0 0000000000000001
>  > > >> [    0.000000] GPR04: d59aca40f0000000 000000000b000000 0000000000000010 0000000000000000
>  > > >> [    0.000000] GPR08: 0000000000000004 0000000000000001 c00000027e520800 c0000000004bf0f0
>  > > >> [    0.000000] GPR12: c0000000004bf020 c0000000003fa900 0000000000000000 0000000000000000
>  > > >> [    0.000000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  > > >> [    0.000000] GPR20: 0000000000000000 0000000000000000 0000000000000000 4000000001400000
>  > > >> [    0.000000] GPR24: 00000000017d64b0 c0000000003d6250 0000000000000000 c000000000504000
>  > > >> [    0.000000] GPR28: 0000000000000000 cf000000001f8000 0000000001000000 cf00000000000000
>  > > >> [    0.000000] NIP [c0000000003d1dcc] .vmemmap_populate+0xb8/0xf4
>  > > >> [    0.000000] LR [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4
>  > > >> [    0.000000] Call Trace:
>  > > >> [    0.000000] [c00000000049bbe0] [c0000000003d1dc4] .vmemmap_populate+0xb0/0xf4 (unreliable)
>  > > >> [    0.000000] [c00000000049bc70] [c0000000003d2ee8] .sparse_mem_map_populate+0x38/0x60
>  > > >> [    0.000000] [c00000000049bd00] [c0000000003c242c] .sparse_early_mem_map_alloc+0x54/0x94
>  > > >> [    0.000000] [c00000000049bd90] [c0000000003c250c] .sparse_init+0xa0/0x20c
>  > > >> [    0.000000] [c00000000049be50] [c0000000003ab7d0] .setup_arch+0x1ac/0x218
>  > > >> [    0.000000] [c00000000049bee0] [c0000000003a36ac] .start_kernel+0xe0/0x3fc
>  > > >> [    0.000000] [c00000000049bf90] [c000000000008594] .start_here_common+0x54/0xc0
>  > > >> [    0.000000] Instruction dump:
>  > > >> [    0.000000] 7fe3fb78 7ca02a14 4082000c 3860fff4 4800003c e92289c8 e96289c0 e9090002
>  > > >> [    0.000000] e8eb0002 4bc575cd 60000000 78630fe0 <0b030000> 7ffff214 7fbfe840 7fe3fb78
>  > > >> [    0.000000] ---[ end trace 31fd0ba7d8756001 ]---
>  > > >> [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
>
>  mm-make-mem_map-allocation-continuous.patch
>  and its friends in -mm.
>
>  You have to call sparse_init_one_section() on each pmap and usemap
>  as we allocate - since valid_section() depends on it (which is needed
>  by vmemmap_populate() to check if the section is populated or not).
>  On ppc, we need to call htab_bolted_mapping() on each section and
>  we need to skip existing sections.
>
>  These patches tried to group all allocations together and then later
>  calls sparse_init_one_section() - which is not good :(

so try to allocate usemap at first altogether.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/sparse.c~mm-allocate-section_map-for-sparse_init-powerpc-fix mm/sparse.c
--- a/mm/sparse.c~mm-allocate-section_map-for-sparse_init-powerpc-fix
+++ a/mm/sparse.c
@@ -297,7 +297,7 @@ void __init sparse_init(void)
 	unsigned long pnum;
 	struct page *map;
 	unsigned long *usemap;
-	struct page **section_map;
+	unsigned long **usemap_map;
 	int size;
 
 	/*
@@ -307,27 +307,31 @@ void __init sparse_init(void)
 	 * make next 2M slip to one more 2M later.
 	 * then in big system, the memmory will have a lot hole...
 	 * here try to allocate 2M pages continously.
+	 *
+	 * powerpc hope to sparse_init_one_section right after each
+	 * sparse_early_mem_map_alloc, so allocate usemap_map
+	 * at first.
 	 */
-	size = sizeof(struct page *) * NR_MEM_SECTIONS;
-	section_map = alloc_bootmem(size);
-	if (!section_map)
-		panic("can not allocate section_map\n");
+	size = sizeof(unsigned long *) * NR_MEM_SECTIONS;
+	usemap_map = alloc_bootmem(size);
+	if (!usemap_map)
+		panic("can not allocate usemap_map\n");
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
-		section_map[pnum] = sparse_early_mem_map_alloc(pnum);
+		usemap_map[pnum] = sparse_early_usemap_alloc(pnum);
 	}
 
 	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
 		if (!present_section_nr(pnum))
 			continue;
 
-		map = section_map[pnum];
+		map = sparse_early_mem_map_alloc(pnum);
 		if (!map)
 			 continue;
 
-		usemap = sparse_early_usemap_alloc(pnum);
+		usemap = usemap_map[pnum];
 		if (!usemap)
 			continue;
 
@@ -335,7 +339,7 @@ void __init sparse_init(void)
 								usemap);
 	}
 
-	free_bootmem(__pa(section_map), size);
+	free_bootmem(__pa(usemap_map), size);
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
_

Patches currently in -mm which might be from yhlu.kernel.send@gmail.com are

mm-allocate-section_map-for-sparse_init-powerpc-fix.patch
mm-offset-align-in-alloc_bootmem.patch
mm-make-reserve_bootmem-can-crossed-the-nodes.patch

