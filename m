From: akpm@linux-foundation.org
Subject: - fix-section-mismatch-warning-in-lib-swiotlbc.patch removed from -mm tree
Date: Tue, 08 May 2007 19:45:01 -0700
Message-ID: <200705090245.l492j1qh008670@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968887AbXEICpK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ak@suse.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix section mismatch warning in lib/swiotlb.c
has been removed from the -mm tree.  Its filename was
     fix-section-mismatch-warning-in-lib-swiotlbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix section mismatch warning in lib/swiotlb.c
From: Sam Ravnborg <sam@ravnborg.org>

kbuild spits outs following warning on a
defconfig x86_64 build:
WARNING: swiotlb.o - Section mismatch: reference to .init.text:swiotlb_init from __ksymtab between '__ksymtab_swiotlb_init' (at offset 0xa0) and '__ksymtab_swiotlb_free_coherent'

This warning happens because the function swiotlb_init is marked __init and
EXPORT_SYMBOL().  A 'git grep swiotlb_init' showed no users in drivers/ so
remove the EXPORT_SYMBOL.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/swiotlb.c~fix-section-mismatch-warning-in-lib-swiotlbc lib/swiotlb.c
--- a/lib/swiotlb.c~fix-section-mismatch-warning-in-lib-swiotlbc
+++ a/lib/swiotlb.c
@@ -778,7 +778,6 @@ swiotlb_dma_supported(struct device *hwd
 	return virt_to_bus(io_tlb_end - 1) <= mask;
 }
 
-EXPORT_SYMBOL(swiotlb_init);
 EXPORT_SYMBOL(swiotlb_map_single);
 EXPORT_SYMBOL(swiotlb_unmap_single);
 EXPORT_SYMBOL(swiotlb_map_sg);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
separate-freezer-from-pm-code-rev-2.patch
