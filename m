From: akpm@linux-foundation.org
Subject: + tmio_mmc-revise-limit-on-data-size.patch added to -mm tree
Date: Thu, 08 Jul 2010 14:48:10 -0700
Message-ID: <201007082148.o68LmALp030996__4975.28090277246$1278625740$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab0GHVss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2010 17:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yusuke.goda.sx@renesas.com, linux-mmc@vger.kernel.org, magnus.damm@gmail.com


The patch titled
     tmio_mmc: revise limit on data size
has been added to the -mm tree.  Its filename is
     tmio_mmc-revise-limit-on-data-size.patch

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
Subject: tmio_mmc: revise limit on data size
From: Yusuke Goda <yusuke.goda.sx@renesas.com>

Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~tmio_mmc-revise-limit-on-data-size drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~tmio_mmc-revise-limit-on-data-size
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -661,7 +661,7 @@ static int tmio_mmc_start_data(struct tm
 		 data->blksz, data->blocks);
 
 	/* Hardware cannot perform 1 and 2 byte requests in 4 bit mode */
-	if (data->blksz < 4 && host->mmc->ios.bus_width == MMC_BUS_WIDTH_4) {
+	if (data->blksz < 2 && host->mmc->ios.bus_width == MMC_BUS_WIDTH_4) {
 		pr_err("%s: %d byte block unsupported in 4 bit mode\n",
 		       mmc_hostname(host->mmc), data->blksz);
 		return -EINVAL;
_

Patches currently in -mm which might be from yusuke.goda.sx@renesas.com are

tmio_mmc-prevent-unexpected-status-clear.patch
tmio_mmc-revise-limit-on-data-size.patch

