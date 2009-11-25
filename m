From: akpm@linux-foundation.org
Subject: + blackfin-sd-host-controller-driver-fix.patch added to -mm tree
Date: Wed, 25 Nov 2009 14:04:53 -0800
Message-ID: <200911252204.nAPM4r7W016603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932854AbZKYWF0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Nov 2009 17:05:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, cliffcai.sh@gmail.com, cooloney@kernel.org, linux-mmc@vger.kernel.org, vapier@gentoo.org


The patch titled
     blackfin-sd-host-controller-driver-fix
has been added to the -mm tree.  Its filename is
     blackfin-sd-host-controller-driver-fix.patch

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

drivers-media-dvb-dvb-core-dvb_frontendc-needs-semaphoreh.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
recordmcount-stfu.patch
include-linux-compiler-gcc4h-gcc-402-doesnt-understand-__builtin_object_size.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
kbuild-generate-modulesbuiltin-fix-2-checkpatch-fixes.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
mtd-nand-fix-multi-chip-suspend-problem-fix.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
st-fix-test-of-value-range-in-st_set_options.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages-checkpatch-fixes.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
wusb-use-sizeof-struct-rather-than-pointer.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
char-cyclades-fix-compiler-warning.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
reiser4-disable.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

