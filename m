From: akpm@linux-foundation.org
Subject: + ia64-use-bitmap_find_next_zero_area.patch added to -mm tree
Date: Fri, 09 Oct 2009 16:44:02 -0700
Message-ID: <200910092344.n99Ni29E030984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933741AbZJIXpL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Oct 2009 19:45:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, fenghua.yu@intel.com, tony.luck@intel.com


The patch titled
     ia64: use bitmap_find_next_zero_area()
has been added to the -mm tree.  Its filename is
     ia64-use-bitmap_find_next_zero_area.patch

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
Subject: ia64: use bitmap_find_next_zero_area()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/ia64/sn/pci/tioca_provider.c~ia64-use-bitmap_find_next_zero_area arch/ia64/sn/pci/tioca_provider.c
--- a/arch/ia64/sn/pci/tioca_provider.c~ia64-use-bitmap_find_next_zero_area
+++ a/arch/ia64/sn/pci/tioca_provider.c
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
+#include <linux/bitmap.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/io.h>
@@ -369,7 +370,7 @@ tioca_dma_d48(struct pci_dev *pdev, u64 
 static dma_addr_t
 tioca_dma_mapped(struct pci_dev *pdev, unsigned long paddr, size_t req_size)
 {
-	int i, ps, ps_shift, entry, entries, mapsize, last_entry;
+	int ps, ps_shift, entry, entries, mapsize;
 	u64 xio_addr, end_xio_addr;
 	struct tioca_common *tioca_common;
 	struct tioca_kernel *tioca_kern;
@@ -410,23 +411,13 @@ tioca_dma_mapped(struct pci_dev *pdev, u
 	map = tioca_kern->ca_pcigart_pagemap;
 	mapsize = tioca_kern->ca_pcigart_entries;
 
-	entry = find_first_zero_bit(map, mapsize);
-	while (entry < mapsize) {
-		last_entry = find_next_bit(map, mapsize, entry);
-
-		if (last_entry - entry >= entries)
-			break;
-
-		entry = find_next_zero_bit(map, mapsize, last_entry);
-	}
-
-	if (entry > mapsize) {
+	entry = bitmap_find_next_zero_area(map, mapsize, 0, entries, 0);
+	if (entry >= mapsize) {
 		kfree(ca_dmamap);
 		goto map_return;
 	}
 
-	for (i = 0; i < entries; i++)
-		set_bit(entry + i, map);
+	bitmap_set(map, entry, entries);
 
 	bus_addr = tioca_kern->ca_pciap_base + (entry * ps);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

iommu-helper-simplify-find_next_zero_area.patch
bitmap-introduce-bitmap_set-bitmap_clear-bitmap_find_next_zero_area.patch
iommu-helper-use-bitmap-library.patch
isp1362-hcd-use-bitmap_find_next_zero_area.patch
mlx4-use-bitmap_find_next_zero_area.patch
sparc-use-bitmap_find_next_zero_area.patch
ia64-use-bitmap_find_next_zero_area.patch
genalloc-use-bitmap_find_next_zero_area.patch

