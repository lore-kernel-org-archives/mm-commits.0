From: akpm@linux-foundation.org
Subject: + intel_agp-cleanup-intel-private-data-update.patch added to -mm tree
Date: Tue, 29 May 2007 20:27:27 -0700
Message-ID: <200705300327.l4U3RQRe018363@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbXE3D1r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 23:27:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhenyu.z.wang@intel.com, davej@codemonkey.org.uk, eric@anholt.net, keithp@keithp.com


The patch titled
     intel_agp: cleanup intel private data (update)
has been added to the -mm tree.  Its filename is
     intel_agp-cleanup-intel-private-data-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel_agp: cleanup intel private data (update)
From: Wang Zhenyu <zhenyu.z.wang@intel.com>

Remove volatile type declare for IO mem variables.

A single private gart data is used by all drivers, this
makes it clean. Eric Anholt wrote the original patch.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Keith Packard <keithp@keithp.com>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel_agp-cleanup-intel-private-data-update drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel_agp-cleanup-intel-private-data-update
+++ a/drivers/char/agp/intel-agp.c
@@ -95,8 +95,8 @@ static struct gatt_mask intel_i810_masks
 
 static struct _intel_private {
 	struct pci_dev *pcidev;	/* device one */
-	volatile u8 __iomem *registers;
-	volatile u32 __iomem *gtt;		/* I915G */
+	u8 __iomem *registers;
+	u32 __iomem *gtt;		/* I915G */
 	int num_dcache_entries;
 	/* gtt_entries is the number of gtt entries that are already mapped
 	 * to stolen memory.  Stolen memory is larger than the memory mapped
_

Patches currently in -mm which might be from zhenyu.z.wang@intel.com are

intel_agp-cleanup-intel-private-data.patch
intel_agp-cleanup-intel-private-data-update.patch
intel_agp-use-table-for-device-probe.patch
