From: akpm@linux-foundation.org
Subject: + sh-allow-platforms-to-specify-sd-card-supported-voltages.patch added to -mm tree
Date: Fri, 21 May 2010 12:39:19 -0700
Message-ID: <201005211939.o4LJdKoW030317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934042Ab0EUTj3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:39:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, ian@mnementh.co.uk, lethal@linux-sh.org, linux-mmc@vger.kernel.org, magnus.damm@gmail.com, sameo@linux.intel.com


The patch titled
     sh: allow platforms to specify SD-card supported voltages
has been added to the -mm tree.  Its filename is
     sh-allow-platforms-to-specify-sd-card-supported-voltages.patch

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
Subject: sh: allow platforms to specify SD-card supported voltages
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Boards can have different supplied voltages on different SD card slots. This
information has to be passed down to the SD/MMC driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Ian Molton <ian@mnementh.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sh_mobile_sdhi.c       |    4 +++-
 include/linux/mfd/sh_mobile_sdhi.h |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/sh_mobile_sdhi.c~sh-allow-platforms-to-specify-sd-card-supported-voltages drivers/mfd/sh_mobile_sdhi.c
--- a/drivers/mfd/sh_mobile_sdhi.c~sh-allow-platforms-to-specify-sd-card-supported-voltages
+++ a/drivers/mfd/sh_mobile_sdhi.c
@@ -107,8 +107,10 @@ static int __init sh_mobile_sdhi_probe(s
 	mmc_data->hclk = clk_get_rate(priv->clk);
 	mmc_data->set_pwr = sh_mobile_sdhi_set_pwr;
 	mmc_data->capabilities = MMC_CAP_MMC_HIGHSPEED;
-	if (p)
+	if (p) {
 		mmc_data->flags = p->tmio_flags;
+		mmc_data->ocr_mask = p->tmio_ocr_mask;
+	}
 
 	if (p && p->dma_slave_tx >= 0 && p->dma_slave_rx >= 0) {
 		priv->param_tx.slave_id = p->dma_slave_tx;
diff -puN include/linux/mfd/sh_mobile_sdhi.h~sh-allow-platforms-to-specify-sd-card-supported-voltages include/linux/mfd/sh_mobile_sdhi.h
--- a/include/linux/mfd/sh_mobile_sdhi.h~sh-allow-platforms-to-specify-sd-card-supported-voltages
+++ a/include/linux/mfd/sh_mobile_sdhi.h
@@ -1,10 +1,13 @@
 #ifndef __SH_MOBILE_SDHI_H__
 #define __SH_MOBILE_SDHI_H__
 
+#include <linux/types.h>
+
 struct sh_mobile_sdhi_info {
 	int dma_slave_tx;
 	int dma_slave_rx;
 	unsigned long tmio_flags;
+	u32 tmio_ocr_mask;	/* available MMC voltages */
 	void (*set_pwr)(struct platform_device *pdev, int state);
 };
 
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

