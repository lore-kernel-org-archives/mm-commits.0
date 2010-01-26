From: akpm@linux-foundation.org
Subject: + mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:05:58 -0800
Message-ID: <201001260005.o0Q05wrX019150__35668.7078405686$1264464383$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323Ab0AZAGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:06:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: bfin_sdh: fix unused sg warning on BF51x/BF52x systems
has been added to the -mm tree.  Its filename is
     mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems.patch

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
mmc-bfin_sdh-fix-unused-sg-warning-on-bf51x-bf52x-systems.patch
mmc-bfin_sdh-drop-redundant-mmc-depend-string.patch
mmc-bfin_sdh-set-timeout-based-on-actual-card-data.patch
fbdev-bf54x-lq043fb-bfin-t350mcqb-fb-drop-custom-mmap-handler.patch

