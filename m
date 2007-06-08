From: akpm@linux-foundation.org
Subject: - intel_agp-cleanup-intel-private-data-update.patch removed from -mm tree
Date: Fri, 08 Jun 2007 10:35:14 -0700
Message-ID: <200706081735.l58HZEFO006346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768AbXFHRoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2007 13:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhenyu.z.wang@intel.com, davej@codemonkey.org.uk, eric@anholt.net, keithp@keithp.com, mm-commits@vger.kernel.org


The patch titled
     intel_agp: cleanup intel private data (update)
has been removed from the -mm tree.  Its filename was
     intel_agp-cleanup-intel-private-data-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-agpgart.patch
