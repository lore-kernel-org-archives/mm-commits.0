From: akpm@linux-foundation.org
Subject: [folded] blackfin-sd-host-controller-driver-fix.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:11:36 -0800
Message-ID: <200912150111.nBF1Barj023126__13385.0733087913$1260839572$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758186AbZLOBMm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:12:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cliffcai.sh@gmail.com, cooloney@kernel.org, linux-mmc@vger.kernel.org, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     blackfin-sd-host-controller-driver-fix
has been removed from the -mm tree.  Its filename was
     blackfin-sd-host-controller-driver-fix.patch

This patch was dropped because it was folded into blackfin-sd-host-controller-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin-sd-host-controller-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix layout, c99 warning

Cc: <linux-mmc@vger.kernel.org>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Cliff Cai <cliffcai.sh@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/Kconfig    |   26 +++++++++++++-------------
 drivers/mmc/host/bfin_sdh.c |   28 ++++++++++++++++------------
 2 files changed, 29 insertions(+), 25 deletions(-)

diff -puN drivers/mmc/host/Kconfig~blackfin-sd-host-controller-driver-fix drivers/mmc/host/Kconfig
--- a/drivers/mmc/host/Kconfig~blackfin-sd-host-controller-driver-fix
+++ a/drivers/mmc/host/Kconfig
@@ -367,20 +367,20 @@ config MMC_VIA_SDMMC
 	  If unsure, say N.
 
 config SDH_BFIN
-    tristate "Blackfin Secure Digital Host support"
-    depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))
-    help
-      If you say yes here you will get support for the Blackfin on-chip
-      Secure Digital Host interface.  This includes support for MMC and
-      SD cards.
+	tristate "Blackfin Secure Digital Host support"
+	depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))
+	help
+	  If you say yes here you will get support for the Blackfin on-chip
+	  Secure Digital Host interface.  This includes support for MMC and
+	  SD cards.
 
-      To compile this driver as a module, choose M here: the
-      module will be called bfin_sdh.
+	  To compile this driver as a module, choose M here: the
+	  module will be called bfin_sdh.
 
-      If unsure, say N.
+	  If unsure, say N.
 
 config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
-    bool "Blackfin EZkit Missing SDH_CMD Pull Up Resistor Workaround"
-    depends on SDH_BFIN
-    help
-      If you say yes here SD-Cards may work on the EZkit.
+	bool "Blackfin EZkit Missing SDH_CMD Pull Up Resistor Workaround"
+	depends on SDH_BFIN
+	help
+	  If you say yes here SD-Cards may work on the EZkit.
diff -puN drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix drivers/mmc/host/bfin_sdh.c
--- a/drivers/mmc/host/bfin_sdh.c~blackfin-sd-host-controller-driver-fix
+++ a/drivers/mmc/host/bfin_sdh.c
@@ -53,7 +53,7 @@ struct dma_desc_array {
 	unsigned short	cfg;
 	unsigned short	x_count;
 	short		x_modify;
-} __attribute__((packed));
+} __packed;
 
 struct sdh_host {
 	struct mmc_host		*mmc;
@@ -149,15 +149,17 @@ static int sdh_setup_data(struct sdh_hos
 	sdh_enable_stat_irq(host, (DAT_CRC_FAIL | DAT_TIME_OUT | DAT_END));
 	host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len, host->dma_dir);
 #if defined(CONFIG_BF54x)
-	int i;
 	dma_cfg |= DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;
-	for_each_sg(data->sg, sg, host->dma_len, i) {
-		host->sg_cpu[i].start_addr = sg_dma_address(sg);
-		host->sg_cpu[i].cfg = dma_cfg;
-		host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;
-		host->sg_cpu[i].x_modify = 4;
-		dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, cfg:0x%x, x_count:0x%x,\
-				x_modify:0x%x\n", i, host->sg_cpu[i].start_addr,
+	{
+		int i;
+		for_each_sg(data->sg, sg, host->dma_len, i) {
+			host->sg_cpu[i].start_addr = sg_dma_address(sg);
+			host->sg_cpu[i].cfg = dma_cfg;
+			host->sg_cpu[i].x_count = sg_dma_len(sg) / 4;
+			host->sg_cpu[i].x_modify = 4;
+			dev_dbg(mmc_dev(host->mmc), "%d: start_addr:0x%lx, "
+				"cfg:0x%x, x_count:0x%x, x_modify:0x%x\n",
+				i, host->sg_cpu[i].start_addr,
 				host->sg_cpu[i].cfg, host->sg_cpu[i].x_count,
 				host->sg_cpu[i].x_modify);
 	}
@@ -205,8 +207,9 @@ static void sdh_start_cmd(struct sdh_hos
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		sdh_cmd |= CMD_RSP;
 		stat_mask |= CMD_RESP_END;
-	} else
+	} else {
 		stat_mask |= CMD_SENT;
+	}
 
 	if (cmd->flags & MMC_RSP_136)
 		sdh_cmd |= CMD_L_RSP;
@@ -304,8 +307,9 @@ static int sdh_data_done(struct sdh_host
 	if (host->mrq->stop) {
 		sdh_stop_clock(host);
 		sdh_start_cmd(host, host->mrq->stop);
-	} else
+	} else }
 		sdh_finish_request(host, host->mrq);
+	}
 
 	return 1;
 }
@@ -425,7 +429,7 @@ static irqreturn_t sdh_stat_irq(int irq,
 	status = bfin_read_SDH_STATUS();
 	if (status & (CMD_SENT | CMD_RESP_END | CMD_TIME_OUT | CMD_CRC_FAIL)) {
 		handled |= sdh_cmd_done(host, status);
-		bfin_write_SDH_STATUS_CLR( CMD_SENT_STAT | CMD_RESP_END_STAT | \
+		bfin_write_SDH_STATUS_CLR(CMD_SENT_STAT | CMD_RESP_END_STAT | \
 				CMD_TIMEOUT_STAT | CMD_CRC_FAIL_STAT);
 		SSYNC();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kernelh-add-printk_ratelimited-and-pr_level_rl.patch
errh-add-helper-function-to-simplify-pointer-error-checking.patch
cs5535-add-a-generic-mfgpt-driver.patch
cs5535-add-a-generic-clock-event-mfgpt-driver.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim.patch
blackfin-sd-host-controller-driver.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch

