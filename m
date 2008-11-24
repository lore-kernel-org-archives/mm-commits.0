From: akpm@linux-foundation.org
Subject: + arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch added to -mm tree
Date: Mon, 24 Nov 2008 15:22:11 -0800
Message-ID: <200811242322.mAONMCi0021898@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbYKXXW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 18:22:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, rmk@arm.linux.org.uk


The patch titled
     arch/arm: eliminate NULL test and memset after alloc_bootmem
has been added to the -mm tree.  Its filename is
     arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch

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
drivers-char-agp-add-missing-pci_dev_get.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-pci-hotplug-add-missing-pci_dev_get.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
arch-arm-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-avr32-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-ia64-eliminate-null-test-and-memset-after-alloc_bootmem.patch
arch-powerpc-eliminate-null-test-and-memset-after-alloc_bootmem.patch
mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch

