From: akpm@linux-foundation.org
Subject: + mmc-bfin_sdh-set-timeout-based-on-actual-card-data.patch added to -mm tree
Date: Mon, 25 Jan 2010 16:06:02 -0800
Message-ID: <201001260006.o0Q062dQ019158__4927.86002946577$1264464385$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466Ab0AZAGH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 19:06:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cliff.cai@analog.com, linux-mmc@vger.kernel.org, vapier@gentoo.org


The patch titled
     mmc: bfin_sdh: set timeout based on actual card data
has been added to the -mm tree.  Its filename is
     mmc-bfin_sdh-set-timeout-based-on-actual-card-data.patch

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
