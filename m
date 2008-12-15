From: akpm@linux-foundation.org
Subject: - arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:01:54 -0800
Message-ID: <200812152001.mBFK1sIS030562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755567AbYLOUCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arch/arm: eliminate NULL test and memset after alloc_bootmem
has been removed from the -mm tree.  Its filename was
     arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/arm: eliminate NULL test and memset after alloc_bootmem
From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/mmu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/arm/mm/mmu.c~arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem arch/arm/mm/mmu.c
--- a/arch/arm/mm/mmu.c~arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem
+++ a/arch/arm/mm/mmu.c
@@ -826,7 +826,6 @@ static void __init devicemaps_init(struc
 	 * Allocate the vector page early.
 	 */
 	vectors = alloc_bootmem_low_pages(PAGE_SIZE);
-	BUG_ON(!vectors);
 
 	for (addr = VMALLOC_END; addr; addr += PGDIR_SIZE)
 		pmd_clear(pmd_off_k(addr));
@@ -911,10 +910,10 @@ void __init paging_init(struct machine_d
 	top_pmd = pmd_off_k(0xffff0000);
 
 	/*
-	 * allocate the zero page.  Note that we count on this going ok.
+	 * allocate the zero page.  Note that this always succeeds and
+	 * returns a zeroed result.
 	 */
 	zero_page = alloc_bootmem_low_pages(PAGE_SIZE);
-	memset(zero_page, 0, PAGE_SIZE);
 	empty_zero_page = virt_to_page(zero_page);
 	flush_dcache_page(empty_zero_page);
 }
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
powerpc-chrp-add-missing-of_node_put-in-pcic.patch
powerpc-powermac-add-missing-of_node_put.patch
drivers-media-video-cx88-cx88-alsac-adjust-error-handling-code.patch
net-tipc-bcasth-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
drivers-macintosh-add-missing-of_node_put-in-therm_adt746xc.patch
drivers-rtc-correct-an-error-test.patch

