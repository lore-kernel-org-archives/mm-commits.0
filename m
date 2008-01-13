From: akpm@linux-foundation.org
Subject: - add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:34:21 -0800
Message-ID: <200801131134.m0DBY1fp009893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434AbYAMLj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:39:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.zhang@freescale.com, benh@kernel.crashing.org, dan.j.williams@intel.com, ebony.zhu@freescale.com, galak@gate.crashing.org, paulus@samba.org, shannon.nelson@intel.com, mm-commits@v


The patch titled
     Fix the issue of fsldma driver's VIRT_TO_BUS dependence in Kconfig
has been removed from the -mm tree.  Its filename was
     add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix the issue of fsldma driver's VIRT_TO_BUS dependence in Kconfig
From: Zhang Wei <wei.zhang@freescale.com>

Remove virt_to_bus(), just using the saved phy address to match.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
Cc: Ebony Zhu <ebony.zhu@freescale.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/fsldma.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/dma/fsldma.c~add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix drivers/dma/fsldma.c
--- a/drivers/dma/fsldma.c~add-dma-engine-driver-for-freescale-mpc85xx-processors-fix-fix
+++ a/drivers/dma/fsldma.c
@@ -495,15 +495,20 @@ static struct dma_async_tx_descriptor *f
  */
 static void fsl_dma_update_completed_cookie(struct fsl_dma_chan *fsl_chan)
 {
-	struct fsl_desc_sw *cur_desc;
+	struct fsl_desc_sw *cur_desc, *desc;
 	dma_addr_t ld_phy;
 
 	ld_phy = get_cdar(fsl_chan) & FSL_DMA_NLDA_MASK;
 
 	if (ld_phy) {
-		cur_desc = (struct fsl_desc_sw *)bus_to_virt(ld_phy);
+		cur_desc = NULL;
+		list_for_each_entry(desc, &fsl_chan->ld_queue, node)
+			if (desc->async_tx.phys == ld_phy) {
+				cur_desc = desc;
+				break;
+			}
 
-		if (cur_desc->async_tx.cookie) {
+		if (cur_desc && cur_desc->async_tx.cookie) {
 			if (dma_is_idle(fsl_chan))
 				fsl_chan->completed_cookie =
 					cur_desc->async_tx.cookie;
_

Patches currently in -mm which might be from wei.zhang@freescale.com are

git-md-accel.patch
