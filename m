From: akpm@linux-foundation.org
Subject: + atl1-fix-typo-in-dma-engine-setup.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:45:15 -0700
Message-ID: <200707202145.l6KLjFVV018076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33544 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbXGTVpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jacliburn@bellsouth.net


The patch titled
     atl1: fix typo in DMA engine setup
has been added to the -mm tree.  Its filename is
     atl1-fix-typo-in-dma-engine-setup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: atl1: fix typo in DMA engine setup
From: Jay Cliburn <jacliburn@bellsouth.net>

The DMA engine setup contains a typo that can result in an incorrect
dmaw_block setting.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-fix-typo-in-dma-engine-setup drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-fix-typo-in-dma-engine-setup
+++ a/drivers/net/atl1/atl1_main.c
@@ -908,8 +908,8 @@ static u32 atl1_configure(struct atl1_ad
 	/* config DMA Engine */
 	value = ((((u32) hw->dmar_block) & DMA_CTRL_DMAR_BURST_LEN_MASK)
 		<< DMA_CTRL_DMAR_BURST_LEN_SHIFT) |
-		((((u32) hw->dmaw_block) & DMA_CTRL_DMAR_BURST_LEN_MASK)
-		<< DMA_CTRL_DMAR_BURST_LEN_SHIFT) | DMA_CTRL_DMAR_EN |
+		((((u32) hw->dmaw_block) & DMA_CTRL_DMAW_BURST_LEN_MASK)
+		<< DMA_CTRL_DMAW_BURST_LEN_SHIFT) | DMA_CTRL_DMAR_EN |
 		DMA_CTRL_DMAW_EN;
 	value |= (u32) hw->dma_ord;
 	if (atl1_rcb_128 == hw->rcb_value)
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

origin.patch
atl1-change-tpd_avail-function-name.patch
atl1-fix-typo-in-dma-engine-setup.patch
atl1-change-cmb-write-threshold.patch
atl1-fix-typo-in-dma_req_block.patch
atl1-use-kernel-provided-ethernet-length-constants.patch
