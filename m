From: akpm@linux-foundation.org
Subject: [merged] mmc-bfin_sdh-set-timeout-based-on-actual-card-data.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:56 -0800
Message-ID: <201003091907.o29J7uTW031396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab0CITWK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cliff.cai@analog.com, linux-mmc@vger.kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     mmc: bfin_sdh: set timeout based on actual card data
has been removed from the -mm tree.  Its filename was
     mmc-bfin_sdh-set-timeout-based-on-actual-card-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: bfin_sdh: set timeout based on actual card data
From: Cliff Cai <cliff.cai@analog.com>

The hardcoded value doesn't really work for all cards.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/bfin_sdh.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/bfin_sdh.c~mmc-bfin_sdh-set-timeout-based-on-actual-card-data drivers/mmc/host/bfin_sdh.c
--- a/drivers/mmc/host/bfin_sdh.c~mmc-bfin_sdh-set-timeout-based-on-actual-card-data
+++ a/drivers/mmc/host/bfin_sdh.c
@@ -115,6 +115,7 @@ static int sdh_setup_data(struct sdh_hos
 	unsigned int length;
 	unsigned int data_ctl;
 	unsigned int dma_cfg;
+	unsigned int cycle_ns, timeout;
 
 	dev_dbg(mmc_dev(host->mmc), "%s enter flags: 0x%x\n", __func__, data->flags);
 	host->data = data;
@@ -135,8 +136,11 @@ static int sdh_setup_data(struct sdh_hos
 	data_ctl |= ((ffs(data->blksz) - 1) << 4);
 
 	bfin_write_SDH_DATA_CTL(data_ctl);
