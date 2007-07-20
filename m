From: akpm@linux-foundation.org
Subject: + atl1-change-cmb-write-threshold.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:45:17 -0700
Message-ID: <200707202145.l6KLjHjd018080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbXGTVpZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:45:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net


The patch titled
     atl1: change cmb write threshold
has been added to the -mm tree.  Its filename is
     atl1-change-cmb-write-threshold.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atl1: change cmb write threshold
From: Jay Cliburn <jacliburn@bellsouth.net>

Change the threshold number of descriptors used to trigger CMB writes.
The vendor reports that under certain conditions this will reduce the
number of unnecessary tx interrupts and improve rx performance.

This change is lifted directly from vendor version 1.2.40.2 of the L1
driver.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-change-cmb-write-threshold drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-change-cmb-write-threshold
+++ a/drivers/net/atl1/atl1_main.c
@@ -917,7 +917,10 @@ static u32 atl1_configure(struct atl1_ad
 	iowrite32(value, hw->hw_addr + REG_DMA_CTRL);
 
 	/* config CMB / SMB */
-	value = hw->cmb_rrd | ((u32) hw->cmb_tpd << 16);
+	value = (hw->cmb_tpd > adapter->tpd_ring.count) ?
+		hw->cmb_tpd : adapter->tpd_ring.count;
+	value <<= 16;
+	value |= hw->cmb_rrd;
 	iowrite32(value, hw->hw_addr + REG_CMB_WRITE_TH);
 	value = hw->cmb_rx_timer | ((u32) hw->cmb_tx_timer << 16);
 	iowrite32(value, hw->hw_addr + REG_CMB_WRITE_TIMER);
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
atl1-change-tpd_avail-function-name.patch
atl1-fix-typo-in-dma-engine-setup.patch
atl1-change-cmb-write-threshold.patch
atl1-fix-typo-in-dma_req_block.patch
atl1-use-kernel-provided-ethernet-length-constants.patch
