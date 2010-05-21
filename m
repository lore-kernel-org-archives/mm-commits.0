From: akpm@linux-foundation.org
Subject: + mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc.patch added to -mm tree
Date: Fri, 21 May 2010 12:39:17 -0700
Message-ID: <201005211939.o4LJdH8V030314__34355.480844579$1274470771$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934042Ab0EUTjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:39:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, ian@mnementh.co.uk, lethal@linux-sh.org, linux-mmc@vger.kernel.org, magnus.damm@gmail.com, sameo@linux.intel.com


The patch titled
     mmc: let MFD's provide supported Vdd card voltages to tmio_mmc
has been added to the -mm tree.  Its filename is
     mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc.patch

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
Subject: mmc: let MFD's provide supported Vdd card voltages to tmio_mmc
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Ian Molton <ian@mnementh.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    5 ++++-
 include/linux/mfd/tmio.h    |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -845,7 +845,10 @@ static int __devinit tmio_mmc_probe(stru
 	mmc->caps |= pdata->capabilities;
 	mmc->f_max = pdata->hclk;
 	mmc->f_min = mmc->f_max / 512;
-	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+	if (pdata->ocr_mask)
+		mmc->ocr_avail = pdata->ocr_mask;
+	else
+		mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
 	/* Tell the MFD core we are ready to be enabled */
 	if (cell->enable) {
diff -puN include/linux/mfd/tmio.h~mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc include/linux/mfd/tmio.h
--- a/include/linux/mfd/tmio.h~mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc
+++ a/include/linux/mfd/tmio.h
@@ -70,6 +70,7 @@ struct tmio_mmc_data {
 	unsigned int			hclk;
 	unsigned long			capabilities;
 	unsigned long			flags;
+	u32				ocr_mask;	/* available voltages */
 	struct tmio_mmc_dma		*dma;
 	void (*set_pwr)(struct platform_device *host, int state);
 	void (*set_clk_div)(struct platform_device *host, int state);
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

origin.patch
linux-next.patch
media-ak881x-needs-slabh.patch
sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch
sh-add-dma-slaves-for-two-sdhi-controllers-to-sh7722.patch
sh-add-dma-slave-definitions-to-sh7724.patch
mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell.patch
sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch
mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch
sh-add-sdhi-dma-support-to-ecovec.patch
sh-add-sdhi-dma-support-to-ms7724se.patch
sh-add-sdhi-dma-support-to-kfr2r09.patch
sh-add-sdhi-dma-support-to-migor.patch
arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch
tmio-add-a-platform-flag-to-disable-card-write-protection-detection.patch
mfd-pass-platform-flags-down-to-the-tmio_mmc-driver.patch
sh-disable-sd-card-write-protection-detection-on-kfr2r09.patch
mmc-let-mfds-provide-supported-vdd-card-voltages-to-tmio_mmc.patch
sh-allow-platforms-to-specify-sd-card-supported-voltages.patch

