From: akpm@linux-foundation.org
Subject: [merged] mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:51 -0800
Message-ID: <201003091907.o29J7pX6031387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab0CITWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc: bfin_sdh: fix unused sg warning on BF51x/BF52x systems
has been removed from the -mm tree.  Its filename was
     mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: bfin_sdh: fix unused sg warning on BF51x/BF52x systems
From: Mike Frysinger <vapier@gentoo.org>

The local sg variable is only used with BF54x code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/bfin_sdh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/bfin_sdh.c~mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems drivers/mmc/host/bfin_sdh.c
--- a/drivers/mmc/host/bfin_sdh.c~mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems
+++ a/drivers/mmc/host/bfin_sdh.c
@@ -115,7 +115,6 @@ static int sdh_setup_data(struct sdh_hos
 	unsigned int length;
 	unsigned int data_ctl;
 	unsigned int dma_cfg;
-	struct scatterlist *sg;
 
 	dev_dbg(mmc_dev(host->mmc), "%s enter flags: 0x%x\n", __func__, data->flags);
 	host->data = data;
@@ -151,6 +150,7 @@ static int sdh_setup_data(struct sdh_hos
 #if defined(CONFIG_BF54x)
 	dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;
 	{
+		struct scatterlist *sg;
 		int i;
 		for_each_sg(data->sg, sg, host->dma_len, i) {
 			host->sg_cpu[i].start_addr = sg_dma_address(sg);
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch

