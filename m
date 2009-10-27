From: akpm@linux-foundation.org
Subject: [to-be-updated] ia64-use-bitmap_find_next_zero_area.patch removed from -mm tree
Date: Tue, 27 Oct 2009 01:19:59 -0700
Message-ID: <200910270820.n9R8JxId014926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932142AbZJ0IUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Oct 2009 04:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: use bitmap_find_next_zero_area()
has been removed from the -mm tree.  Its filename was
     ia64-use-bitmap_find_next_zero_area.patch

This patch was dropped because an updated version will be merged

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
