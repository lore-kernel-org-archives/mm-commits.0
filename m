From: akpm@linux-foundation.org
Subject: + mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:23 -0700
Message-ID: <200803172227.m2HMRNxM001537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbYCQW1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: juha.yrjola@solidboot.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, jarkko.lavinen@nokia.com, tony@atomide.com


The patch titled
     mmc: omap: fix timeout calculation for MMC multislot support
has been added to the -mm tree.  Its filename is
     mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: fix timeout calculation for MMC multislot support
From: Juha Yrjola <juha.yrjola@solidboot.com>

Fix the data timeout calculation for MMC multislot support.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-fix-timeout-calculation-for-mmc-multislot-support drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-fix-timeout-calculation-for-mmc-multislot-support
+++ a/drivers/mmc/host/omap.c
@@ -861,13 +861,12 @@ static inline void set_cmd_timeout(struc
 
 static inline void set_data_timeout(struct mmc_omap_host *host, struct mmc_request *req)
 {
-	int timeout;
+	unsigned int timeout, cycle_ns;
 	u16 reg;
 
-	/* Convert ns to clock cycles by assuming 20MHz frequency
-	 * 1 cycle at 20MHz = 500 ns
-	 */
-	timeout = req->data->timeout_clks + req->data->timeout_ns / 500;
+	cycle_ns = 1000000000 / host->current_slot->fclk_freq;
+	timeout = req->data->timeout_ns / cycle_ns;
+	timeout += req->data->timeout_clks;
 
 	/* Check if we need to use timeout multiplier register */
 	reg = OMAP_MMC_READ(host, SDIO);
_

Patches currently in -mm which might be from juha.yrjola@solidboot.com are

mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch

