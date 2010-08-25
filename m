From: akpm@linux-foundation.org
Subject: + tmio_mmc-revise-a-limit-of-the-data-size.patch added to -mm tree
Date: Wed, 25 Aug 2010 15:05:17 -0700
Message-ID: <201008252205.o7PM5HDw018415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400Ab0HYWFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Aug 2010 18:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yusuke.goda.sx@renesas.com, damm@opensource.se, ian@mnementh.co.uk, lethal@linux-sh.org, matt@console-pimps.org, sameo@linux.intel.com


The patch titled
     tmio_mmc: revise a limit of the data size
has been added to the -mm tree.  Its filename is
     tmio_mmc-revise-a-limit-of-the-data-size.patch

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
Subject: tmio_mmc: revise a limit of the data size
From: Yusuke Goda <yusuke.goda.sx@renesas.com>

When running in 4-bit bus width mode, it is entirely possible to transfer
data in block sizes of 2 bytes and larger.  Relax the conditional check to
allow 2-byte data block transfers which were previously disallowed.

[matt@console-pimps.org: wrote changelog]
Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <damm@opensource.se>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~tmio_mmc-revise-a-limit-of-the-data-size drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~tmio_mmc-revise-a-limit-of-the-data-size
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

tmio_mmc-revise-a-limit-of-the-data-size.patch
tmio_mmc-revise-a-limit-of-the-data-size-fix.patch

