From: akpm@linux-foundation.org
Subject: + alloc_bootmem_core-fix-misaligned-allocation-of-1g-page.patch added to -mm tree
Date: Tue, 12 Aug 2008 16:17:22 -0700
Message-ID: <200808122317.m7CNHMPg018807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbYHLXR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 19:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas.herrmann3@amd.com, hannes@saeurebad.de, mingo@elte.hu, npiggin@suse.de


The patch titled
     alloc_bootmem_core(): fix misaligned allocation of 1G page
has been added to the -mm tree.  Its filename is
     alloc_bootmem_core-fix-misaligned-allocation-of-1g-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alloc_bootmem_core(): fix misaligned allocation of 1G page
From: Andreas Herrmann <andreas.herrmann3@amd.com>

If memory hole remapping is enabled on an x86-NUMA system, allocation of
1G pages on node 1 will most probably trigger an BUG_ON in
alloc_bootmem_huge_page because alloc_bootmem_core fails to properly align
the huge page on a 1G boundary.

I've observed this Oops with kernel 2.6.27-rc2-00166-gaeee90d with a 2
socket system and activated memory hole remapping.  (Of course disabling
memory hole remapping works around the problem but this wastes a
significant amount of memory.)

Here some dmesg snippet with that kernel (using "bootmem_debug"  plus some
additional printk's):

  ...
  Bootmem setup node 0 0000000000000000-0000000130000000
  ...
  Bootmem setup node 1 0000000130000000-0000000230000000
  ...
  Kernel command line: root=/dev/sda4 console=ttyS0,115200
    hugepagesz=2M hugepages=0 hugepagesz=1G hugepages=3 bootmem_debug
    debug earlyprintk=ttyS0,115200
   ...

  bootmem::alloc_bootmem_core nid=1 size=40000000 [262144 pages]
    align=40000000 goal=0 limit=0
  min: 1245184, max: 2293760, step: 262144, start: 1310720
  sidx: 65536, midx: 1048576
  sidx: 65536
  sidx: 262144, eidx: 524288
  start_off: 1073741824, end_off: 2147483648, merge: 0, min_pfn: 1245184
  bootmem::__reserve nid=1 start=170000 end=1b0000 flags=1
  addr:ffff880170000000, paddr:0000000170000000, size: 1073741824
  PANIC: early exception 06 rip 10:ffffffff807ce3b0 error 0 cr2 0
  Pid: 0, comm: swapper Not tainted 2.6.27-rc2-00166-gaeee90d-dirty #6

  Call Trace:
   [<ffffffff807cccbe>] ___alloc_bootmem_nopanic+0x60/0x98
   [<ffffffff807bc195>] early_idt_handler+0x55/0x69
   [<ffffffff807ce3b0>] alloc_bootmem_huge_page+0xa6/0xd9
   [<ffffffff807ce39f>] alloc_bootmem_huge_page+0x95/0xd9
   [<ffffffff807ce3fe>] hugetlb_hstate_alloc_pages+0x1b/0x3a
   [<ffffffff807ce489>] hugetlb_nrpages_setup+0x6c/0x7a
   [<ffffffff807bc69e>] unknown_bootoption+0xdc/0x1e2
   [<ffffffff802446d6>] parse_args+0x137/0x1f5
   [<ffffffff807bc5c2>] unknown_bootoption+0x0/0x1e2
   [<ffffffff807bcb6e>] start_kernel+0x195/0x2b7
   [<ffffffff807bc369>] x86_64_start_kernel+0xe3/0xe7

  RIP 0x10

The problem in alloc_bootmem_core is that it just guarantees proper
alignment for the offset (sidx) from bdata->node_min_pfn.

A simple (ugly) fix is to add bdata->node_min_pfn to sidx and friends. 
Patch is attached.

The current code in alloc_bootmem_core is based on changes introduced with
commit 5f2809e69c7128f86316048221cf45146f69a4a0 (bootmem: clean up
alloc_bootmem_core).  But I didn't check whether this commit introduced
the problem.


With attached patch the 1G huge page gets properly aligned on node 1:

  Linux version 2.6.27-rc2-00389-g10fec20-dirty ...
  ...
  Bootmem setup node 0 0000000000000000-0000000130000000
  ...
  Bootmem setup node 1 0000000130000000-0000000230000000
  ...

  Kernel command line: root=/dev/sda4 console=ttyS0,115200
    hugepagesz=2M hugepages=0 huge pagesz=1G hugepages=3 bootmem_debug
    debug earlyprintk=ttyS0,115200
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::__reserve nid=0 start=40000 end=80000 flags=1
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::__reserve nid=0 start=80000 end=c0000 flags=1
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::alloc_bootmem_core nid=0 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::alloc_bootmem_core nid=1 size=40000000 [262144 pages] align=40000000
    goal=0 limit=0
  bootmem::__reserve nid=1 start=140000 end=180000 flags=1
  Initializing CPU#0
  ...

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff -puN mm/bootmem.c~alloc_bootmem_core-fix-misaligned-allocation-of-1g-page mm/bootmem.c
--- a/mm/bootmem.c~alloc_bootmem_core-fix-misaligned-allocation-of-1g-page
+++ a/mm/bootmem.c
@@ -441,8 +441,8 @@ static void * __init alloc_bootmem_core(
 	else
 		start = ALIGN(min, step);
 
-	sidx = start - bdata->node_min_pfn;;
-	midx = max - bdata->node_min_pfn;
+	sidx = start;
+	midx = max;
 
 	if (bdata->hint_idx > sidx) {
 		/*
@@ -458,7 +458,10 @@ static void * __init alloc_bootmem_core(
 		void *region;
 		unsigned long eidx, i, start_off, end_off;
 find_block:
-		sidx = find_next_zero_bit(bdata->node_bootmem_map, midx, sidx);
+		sidx = find_next_zero_bit(bdata->node_bootmem_map,
+					  midx - bdata->node_min_pfn,
+					  sidx - bdata->node_min_pfn);
+		sidx += bdata->node_min_pfn;
 		sidx = ALIGN(sidx, step);
 		eidx = sidx + PFN_UP(size);
 
@@ -466,7 +469,8 @@ find_block:
 			break;
 
 		for (i = sidx; i < eidx; i++)
-			if (test_bit(i, bdata->node_bootmem_map)) {
+			if (test_bit(i - bdata->node_min_pfn,
+				     bdata->node_bootmem_map)) {
 				sidx = ALIGN(i, step);
 				if (sidx == i)
 					sidx += step;
@@ -474,16 +478,17 @@ find_block:
 			}
 
 		if (bdata->last_end_off &&
-				PFN_DOWN(bdata->last_end_off) + 1 == sidx)
+		    (PFN_DOWN(bdata->last_end_off) + 1) ==
+		    (sidx - bdata->node_min_pfn))
 			start_off = ALIGN(bdata->last_end_off, align);
 		else
-			start_off = PFN_PHYS(sidx);
+			start_off = PFN_PHYS(sidx - bdata->node_min_pfn);
 
-		merge = PFN_DOWN(start_off) < sidx;
+		merge = PFN_DOWN(start_off) < (sidx - bdata->node_min_pfn);
 		end_off = start_off + size;
 
 		bdata->last_end_off = end_off;
-		bdata->hint_idx = PFN_UP(end_off);
+		bdata->hint_idx = PFN_UP(end_off + bdata->node_min_pfn);
 
 		/*
 		 * Reserve the area now:
_

Patches currently in -mm which might be from andreas.herrmann3@amd.com are

alloc_bootmem_core-fix-misaligned-allocation-of-1g-page.patch

