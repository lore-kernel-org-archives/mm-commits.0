From: akpm@linux-foundation.org
Subject: - bootmem-revert-mm-fix-boundary-checking-in-free_bootmem_core.patch removed from -mm tree
Date: Tue, 15 Apr 2008 00:16:10 -0700
Message-ID: <200804150716.m3F7GATI016387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33280 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753098AbYDOHRD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 03:17:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     bootmem: revert "mm: fix boundary checking in free_bootmem_core"
has been removed from the -mm tree.  Its filename was
     bootmem-revert-mm-fix-boundary-checking-in-free_bootmem_core.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: revert "mm: fix boundary checking in free_bootmem_core"
From: Johannes Weiner <hannes@saeurebad.de>

As I was doing some clean-ups in the bootmem allocator, I noticed the patch

    5a982cbc7b3fe6cf72266f319286f29963c71b9e
    mm: fix boundary checking in free_bootmem_core

Which seems to implement the opposite of what the subject promises.

It makes input arguments acceptable if they are `a bit wrong' and
silently aborts if they are completely off the whack.

Please have a look at the two patches I propose: one to revert the
original and the other one to reimplement what the whole thing was
really about: having free_bootmem() itself look up the node holding
the specified address range.

Note also that the reverted patch changed a helper function and
therefore also affected free_bootmem_node(), making the latter paper
over bugs as well.


This patch:

This reverts commit 5a982cbc7b3fe6cf72266f319286f29963c71b9e.

The intention behind this patch was to make the free_bootmem() interface more
robust with regards to the specified range and to let it operate on multiple
node setups as well.

However, it made free_bootmem_core()

  1. handle bogus node/memory-range combination input by just
     returning early without informing the callsite or screaming BUG()
     as it did before
  2. round slightly out of node-range values to the node boundaries
     instead of treating them as the invalid parameters they are

This was partially done to abuse free_bootmem_core() for node iteration in
free_bootmem (just feeding it every node on the box and let it figure out what
it wants to do with it) instead of looking up the proper node before the call
to free_bootmem_core().

It also affects free_bootmem_node() which relies on
free_bootmem_core() and on its sanity checks now removed.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff -puN mm/bootmem.c~bootmem-revert-mm-fix-boundary-checking-in-free_bootmem_core mm/bootmem.c
--- a/mm/bootmem.c~bootmem-revert-mm-fix-boundary-checking-in-free_bootmem_core
+++ a/mm/bootmem.c
@@ -125,7 +125,6 @@ static int __init reserve_bootmem_core(b
 	BUG_ON(!size);
 	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
 	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
-	BUG_ON(addr < bdata->node_boot_start);
 
 	sidx = PFN_DOWN(addr - bdata->node_boot_start);
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
@@ -157,31 +156,21 @@ static void __init free_bootmem_core(boo
 	unsigned long sidx, eidx;
 	unsigned long i;
 
-	BUG_ON(!size);
-
-	/* out range */
-	if (addr + size < bdata->node_boot_start ||
-		PFN_DOWN(addr) > bdata->node_low_pfn)
-		return;
 	/*
 	 * round down end of usable mem, partially free pages are
 	 * considered reserved.
 	 */
+	BUG_ON(!size);
+	BUG_ON(PFN_DOWN(addr + size) > bdata->node_low_pfn);
 
-	if (addr >= bdata->node_boot_start && addr < bdata->last_success)
+	if (addr < bdata->last_success)
 		bdata->last_success = addr;
 
 	/*
-	 * Round up to index to the range.
+	 * Round up the beginning of the address.
 	 */
-	if (PFN_UP(addr) > PFN_DOWN(bdata->node_boot_start))
-		sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
-	else
-		sidx = 0;
-
+	sidx = PFN_UP(addr) - PFN_DOWN(bdata->node_boot_start);
 	eidx = PFN_DOWN(addr + size - bdata->node_boot_start);
-	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
-		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
@@ -432,9 +421,7 @@ int __init reserve_bootmem(unsigned long
 
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
-	bootmem_data_t *bdata;
-	list_for_each_entry(bdata, &bdata_list, list)
-		free_bootmem_core(bdata, addr, size);
+	free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
 }
 
 unsigned long __init free_all_bootmem(void)
_

Patches currently in -mm which might be from hannes@saeurebad.de are

bootmem-revert-mm-fix-boundary-checking-in-free_bootmem_core.patch
bootmem-node-setup-agnostic-free_bootmem.patch
bootmem-node-setup-agnostic-free_bootmem-checkpatch-fixes.patch
git-x86.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-powerpc.patch
git-ia64.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-s390.patch
git-xtensa.patch
mm-remove-unused-max_nodes_shift.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

