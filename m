From: akpm@linux-foundation.org
Subject: + via-sdmmc-via-msp-card-reader-driver-support-update.patch added to -mm tree
Date: Tue, 24 Feb 2009 13:55:13 -0800
Message-ID: <200902242155.n1OLtD36014269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448AbZBXV4B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 16:56:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josephchan@via.com.tw, arnd@arndb.de, ben-linux@fluff.org, drzeus-mmc@drzeus.cx, randy.dunlap@oracle.com


The patch titled
     via-sdmmc-via-msp-card-reader-driver-support-update
has been added to the -mm tree.  Its filename is
     via-sdmmc-via-msp-card-reader-driver-support-update.patch

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
Subject: via-sdmmc-via-msp-card-reader-driver-support-update
From: Joseph Chan <josephchan@via.com.tw>

Thanks for Randy's check.
We fixed the compiling issue is this v4 patch when CONFIG_PM=n.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/via-sdmmc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/mmc/host/via-sdmmc.c~via-sdmmc-via-msp-card-reader-driver-support-update drivers/mmc/host/via-sdmmc.c
--- a/drivers/mmc/host/via-sdmmc.c~via-sdmmc-via-msp-card-reader-driver-support-update
+++ a/drivers/mmc/host/via-sdmmc.c
@@ -260,11 +260,9 @@ struct via_crdr_chip {
 	struct workqueue_struct *card_detect_queue;
 	u32 cur_device;
 
-#ifdef CONFIG_PM
 	u8 pci_cfg_bak[0x42];
 	struct pcictrlreg pm_pcictrl_reg;
 	struct sdhcreg pm_sdhc_reg;
-#endif
 };
 
 struct via_crdr_mmc_host {
_

Patches currently in -mm which might be from josephchan@via.com.tw are

via-sdmmc-via-msp-card-reader-driver-support.patch
via-sdmmc-via-msp-card-reader-driver-support-update.patch

