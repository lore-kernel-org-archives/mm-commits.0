From: akpm@linux-foundation.org
Subject: + tmio-add-a-platform-flag-to-disable-card-write-protection-detection.patch added to -mm tree
Date: Fri, 21 May 2010 12:39:11 -0700
Message-ID: <201005211939.o4LJdCIe030293__36916.2332769067$1274470771$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758489Ab0EUTjS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 15:39:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, ian@mnementh.co.uk, lethal@linux-sh.org, linux-mmc@vger.kernel.org, magnus.damm@gmail.com, sameo@linux.intel.com


The patch titled
     tmio: add a platform flag to disable card write-protection detection
has been added to the -mm tree.  Its filename is
     tmio-add-a-platform-flag-to-disable-card-write-protection-detection.patch

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
Subject: tmio: add a platform flag to disable card write-protection detection
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Write-protection status is not always available, e.g., micro-SD cards do
not have a write-protection switch at all.  This patch adds a flag to let
platforms force tmio_mmc to consider the card writable.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Ian Molton <ian@mnementh.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |    5 ++++-
 include/linux/mfd/tmio.h    |    4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/tmio_mmc.c~tmio-add-a-platform-flag-to-disable-card-write-protection-detection drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~tmio-add-a-platform-flag-to-disable-card-write-protection-detection
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -746,8 +746,11 @@ static void tmio_mmc_set_ios(struct mmc_
 static int tmio_mmc_get_ro(struct mmc_host *mmc)
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
+	struct mfd_cell	*cell = host->pdev->dev.platform_data;
+	struct tmio_mmc_data *pdata = cell->driver_data;
 
-	return (sd_ctrl_read32(host, CTL_STATUS) & TMIO_STAT_WRPROTECT) ? 0 : 1;
+	return ((pdata->flags & TMIO_MMC_WRPROTECT_DISABLE) ||
+		(sd_ctrl_read32(host, CTL_STATUS) & TMIO_STAT_WRPROTECT)) ? 0 : 1;
 }
 
 static const struct mmc_host_ops tmio_mmc_ops = {
diff -puN include/linux/mfd/tmio.h~tmio-add-a-platform-flag-to-disable-card-write-protection-detection include/linux/mfd/tmio.h
--- a/include/linux/mfd/tmio.h~tmio-add-a-platform-flag-to-disable-card-write-protection-detection
+++ a/include/linux/mfd/tmio.h
@@ -50,6 +50,9 @@
 		tmio_iowrite16((val) >> 16, (base) + ((reg + 2) << (shift))); \
 	} while (0)
 
+/* tmio MMC platform flags */
+#define TMIO_MMC_WRPROTECT_DISABLE	(1 << 0)
+
 int tmio_core_mmc_enable(void __iomem *cnf, int shift, unsigned long base);
 int tmio_core_mmc_resume(void __iomem *cnf, int shift, unsigned long base);
 void tmio_core_mmc_pwr(void __iomem *cnf, int shift, int state);
@@ -66,6 +69,7 @@ struct tmio_mmc_dma {
 struct tmio_mmc_data {
 	unsigned int			hclk;
 	unsigned long			capabilities;
+	unsigned long			flags;
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

