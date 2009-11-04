From: akpm@linux-foundation.org
Subject: [to-be-updated] mmc-msm_sdccc-remove-references-to-htc_pwrsink.patch removed from -mm tree
Date: Tue, 03 Nov 2009 16:12:15 -0800
Message-ID: <200911040012.nA40CFWW008924__2252.14822353355$1257293551$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbZKDAMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Nov 2009 19:12:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmc:: msm_sdcc.c: remove references to htc_pwrsink
has been removed from the -mm tree.  Its filename was
     mmc-msm_sdccc-remove-references-to-htc_pwrsink.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc:: msm_sdcc.c: remove references to htc_pwrsink
From: Pavel Machek <pavel@ucw.cz>

htc_pwrsing code never went to mainline, remove references to it.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/mmc/host/msm_sdcc.c~mmc-msm_sdccc-remove-references-to-htc_pwrsink drivers/mmc/host/msm_sdcc.c
--- a/drivers/mmc/host/msm_sdcc.c~mmc-msm_sdccc-remove-references-to-htc_pwrsink
+++ a/drivers/mmc/host/msm_sdcc.c
@@ -41,7 +41,6 @@
 #include <asm/mach/mmc.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
-#include <mach/htc_pwrsink.h>
 
 #include "msm_sdcc.h"
 
@@ -775,13 +774,11 @@ msmsdcc_set_ios(struct mmc_host *mmc, st
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
-		htc_pwrsink_set(PWRSINK_SDCARD, 0);
 		break;
 	case MMC_POWER_UP:
 		pwr |= MCI_PWR_UP;
 		break;
 	case MMC_POWER_ON:
-		htc_pwrsink_set(PWRSINK_SDCARD, 100);
 		pwr |= MCI_PWR_ON;
 		break;
 	}
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
linux-next.patch
spitz-backlight-fix-brightness-limiting.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
mmc-msm_sdccc-remove-references-to-htc_pwrsink.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

