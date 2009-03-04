From: akpm@linux-foundation.org
Subject: [folded] via-sdmmc-via-msp-card-reader-driver-support-update.patch removed from -mm tree
Date: Wed, 04 Mar 2009 11:47:21 -0800
Message-ID: <200903041947.n24JlLMM027149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755022AbZCDTrw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 14:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josephchan@via.com.tw, arnd@arndb.de, ben-linux@fluff.org, drzeus-mmc@drzeus.cx, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     via-sdmmc-via-msp-card-reader-driver-support-update
has been removed from the -mm tree.  Its filename was
     via-sdmmc-via-msp-card-reader-driver-support-update.patch

This patch was dropped because it was folded into via-sdmmc-via-msp-card-reader-driver-support.patch

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
viafb-returns-0-two-too-early.patch

