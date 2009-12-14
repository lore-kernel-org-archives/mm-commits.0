From: akpm@linux-foundation.org
Subject: [merged] msm_sdccc-add-missing-include-fix-compilation.patch removed from -mm tree
Date: Mon, 14 Dec 2009 13:23:36 -0800
Message-ID: <200912142123.nBELNa6G017118__3073.5885528431$1260825853$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815AbZLNVXr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 16:23:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, linux-mmc@vger.kernel.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     msm_sdcc.c: add missing include, fix compilation
has been removed from the -mm tree.  Its filename was
     msm_sdccc-add-missing-include-fix-compilation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: msm_sdcc.c: add missing include, fix compilation
From: Pavel Machek <pavel@ucw.cz>

Add missing include for msm_sdcc compilation, and remove pwrsink
support that is not mainline, yet.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Cc <linux-mmc@vger.kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN /dev/null arch/arm/mach-msm/include/mach/mmc.h
--- /dev/null
+++ a/arch/arm/mach-msm/include/mach/mmc.h
@@ -0,0 +1,26 @@
+/*
+ *  arch/arm/include/asm/mach/mmc.h
+ */
+#ifndef ASMARM_MACH_MMC_H
+#define ASMARM_MACH_MMC_H
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+
+struct embedded_sdio_data {
+        struct sdio_cis cis;
+        struct sdio_cccr cccr;
+        struct sdio_embedded_func *funcs;
+        int num_funcs;
+};
+
+struct mmc_platform_data {
+	unsigned int ocr_mask;			/* available voltages */
+	u32 (*translate_vdd)(struct device *, unsigned int);
+	unsigned int (*status)(struct device *);
+	struct embedded_sdio_data *embedded_sdio;
+	int (*register_status_notify)(void (*callback)(int card_present, void *dev_id), void *dev_id);
+};
+
+#endif
diff -puN drivers/mmc/host/msm_sdcc.c~msm_sdccc-add-missing-include-fix-compilation drivers/mmc/host/msm_sdcc.c
--- a/drivers/mmc/host/msm_sdcc.c~msm_sdccc-add-missing-include-fix-compilation
+++ a/drivers/mmc/host/msm_sdcc.c
@@ -38,10 +38,9 @@
 #include <asm/div64.h>
 #include <asm/sizes.h>
 
-#include <asm/mach/mmc.h>
+#include <mach/mmc.h>
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
serial_cs-oxsemi-quirk-breaks-resume.patch
scripts-get_maintainerpl-add-roles-and-rolestats.patch
scripts-get_maintainerpl-fix-non-with-git-blame-and-cleanups.patch
lis3lv02d-axis-remap-and-resource-setup-release.patch
lis3lv02d-i2c-support.patch
lis3lv02d-send-sync-event.patch
lis3lv02d-correct-memory-leak-in-module-unload.patch
lis3-update-documentation-and-comments.patch
lis3-fix-show-rate-for-8-bits-chips.patch
lis3lv02d-proper-power-on-sequence.patch
lis3-selftest-support.patch
lis3lv02d-remove-calibaration-functionality.patch
lis3-sysfs-entry-for-setting-chip-measurement-rate.patch
lis3-scale-output-values-to-mg.patch
lis3-update-documentation-to-match-latest-changes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
vt-make-the-default-cursor-shape-configurable.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch

