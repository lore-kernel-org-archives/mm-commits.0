From: akpm@linux-foundation.org
Subject: + mmc-omap-fix-the-byteblock-capability-removal.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:11 -0700
Message-ID: <200803172227.m2HMRBex001522@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbYCQW1Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: francisco.alecrim@indt.org.br, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, tony@atomide.com


The patch titled
     mmc: omap: fix the BYTEBLOCK capability removal
has been added to the -mm tree.  Its filename is
     mmc-omap-fix-the-byteblock-capability-removal.patch

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
Subject: mmc: omap: fix the BYTEBLOCK capability removal
From: Francisco Alecrim <francisco.alecrim@indt.org.br>

According with commit 255d01af9a990fd5166f04ed0cc0b30b7b67e81e from Linux-OMAP
tree, the BYTEBLOCK capability was removed by Pierre Ossman. 
MMC_CAP_BYTEBLOCK is not defined causing the compile error:

drivers/mmc/host/omap.c: In function `mmc_omap_probe':
drivers/mmc/host/omap.c:1077: error: `MMC_CAP_BYTEBLOCK' undeclared (first use in this function)
drivers/mmc/host/omap.c:1077: error: (Each undeclared identifier is reported only once
drivers/mmc/host/omap.c:1077: error: for each function it appears in.)

Signed-off-by: Francisco Alecrim <francisco.alecrim@indt.org.br>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-fix-the-byteblock-capability-removal drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-fix-the-byteblock-capability-removal
+++ a/drivers/mmc/host/omap.c
@@ -1070,7 +1070,7 @@ static int __init mmc_omap_probe(struct 
 	mmc->f_min = 400000;
 	mmc->f_max = 24000000;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_BYTEBLOCK;
+	mmc->caps = MMC_CAP_MULTIWRITE;
 
 	if (minfo->wire4)
 		 mmc->caps |= MMC_CAP_4_BIT_DATA;
_

Patches currently in -mm which might be from francisco.alecrim@indt.org.br are

mmc-omap-fix-the-byteblock-capability-removal.patch

