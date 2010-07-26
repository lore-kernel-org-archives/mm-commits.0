From: akpm@linux-foundation.org
Subject: + tmio_mmc-allow-2-byte-requests-in-4-bit-mode.patch added to -mm tree
Date: Mon, 26 Jul 2010 16:03:49 -0700
Message-ID: <201007262303.o6QN3n5n015124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60548 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab0GZXEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 19:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yusuke.goda.sx@renesas.com, damm@opensource.se, linux-mmc@vger.kernel.org


The patch titled
     tmio_mmc: allow 2 byte requests in 4-bit mode
has been added to the -mm tree.  Its filename is
     tmio_mmc-allow-2-byte-requests-in-4-bit-mode.patch

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
Subject: tmio_mmc: allow 2 byte requests in 4-bit mode
From: Yusuke Goda <yusuke.goda.sx@renesas.com>

Adjust the tmio_mmc block size check to accept 2-byte requests in 4-bit
mode.  Tested with the SDHI hardware block included in sh7724.

Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Tested-by: Magnus Damm <damm@opensource.se>
Acked-by: Magnus Damm <damm@opensource.se>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.c~tmio_mmc-allow-2-byte-requests-in-4-bit-mode drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~tmio_mmc-allow-2-byte-requests-in-4-bit-mode
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -660,8 +660,8 @@ static int tmio_mmc_start_data(struct tm
 	pr_debug("setup data transfer: blocksize %08x  nr_blocks %d\n",
 		 data->blksz, data->blocks);
 
-	/* Hardware cannot perform 1 and 2 byte requests in 4 bit mode */
-	if (data->blksz < 4 && host->mmc->ios.bus_width == MMC_BUS_WIDTH_4) {
+	/* Hardware cannot perform 1 byte requests in 4 bit mode */
+	if (data->blksz < 2 && host->mmc->ios.bus_width == MMC_BUS_WIDTH_4) {
 		pr_err("%s: %d byte block unsupported in 4 bit mode\n",
 		       mmc_hostname(host->mmc), data->blksz);
 		return -EINVAL;
_

Patches currently in -mm which might be from yusuke.goda.sx@renesas.com are

tmio_mmc-prevent-unexpected-status-clear.patch
tmio_mmc-allow-2-byte-requests-in-4-bit-mode.patch

