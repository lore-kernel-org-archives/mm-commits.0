From: akpm@linux-foundation.org
Subject: +
 tree-wide-use-reinit_completion-instead-of-init_completion.patch added to
 -mm tree
Date: Tue, 15 Oct 2013 15:25:39 -0700
Message-ID: <525dc0e3.W/X3mUWcesrasQWV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab3JOWZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Oct 2013 18:25:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, linus.walleij@linaro.org, wsa@the-dreams.de

Subject: + tree-wide-use-reinit_completion-instead-of-init_completion.patch added to -mm tree
To: wsa@the-dreams.de,linus.walleij@linaro.org,mingo@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 15 Oct 2013 15:25:39 -0700


The patch titled
     Subject: tree-wide: use reinit_completion instead of INIT_COMPLETION
has been added to the -mm tree.  Its filename is
     tree-wide-use-reinit_completion-instead-of-init_completion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tree-wide-use-reinit_completion-instead-of-init_completion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tree-wide-use-reinit_completion-instead-of-init_completion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wolfram Sang <wsa@the-dreams.de>
Subject: tree-wide: use reinit_completion instead of INIT_COMPLETION

Use this new function to make code more comprehensible, since we are
reinitialzing the completion, not initializing.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-tegra/apbio.c                          |    2 -
 arch/powerpc/platforms/powermac/low_i2c.c            |    6 +--
 arch/powerpc/platforms/pseries/suspend.c             |    2 -
 crypto/af_alg.c                                      |    2 -
 crypto/tcrypt.c                                      |    4 +-
 crypto/testmgr.c                                     |   12 +++---
 drivers/ata/libata-eh.c                              |    4 +-
 drivers/base/power/main.c                            |    4 +-
 drivers/block/amiflop.c                              |    2 -
 drivers/block/cciss.c                                |    4 +-
 drivers/char/hw_random/timeriomem-rng.c              |    2 -
 drivers/crypto/tegra-aes.c                           |    2 -
 drivers/firewire/core-transaction.c                  |    2 -
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c           |    2 -
 drivers/hid/hid-wiimote.h                            |    2 -
 drivers/hwmon/jz4740-hwmon.c                         |    2 -
 drivers/i2c/busses/i2c-at91.c                        |    2 -
 drivers/i2c/busses/i2c-bcm2835.c                     |    2 -
 drivers/i2c/busses/i2c-davinci.c                     |    2 -
 drivers/i2c/busses/i2c-designware-core.c             |    2 -
 drivers/i2c/busses/i2c-ismt.c                        |    2 -
 drivers/i2c/busses/i2c-mxs.c                         |    2 -
 drivers/i2c/busses/i2c-omap.c                        |    2 -
 drivers/i2c/busses/i2c-tegra.c                       |    2 -
 drivers/i2c/busses/i2c-wmt.c                         |    4 +-
 drivers/iio/adc/ad_sigma_delta.c                     |    6 +--
 drivers/iio/adc/nau7802.c                            |    2 -
 drivers/input/touchscreen/cyttsp_core.c              |    2 -
 drivers/md/dm-crypt.c                                |    2 -
 drivers/media/platform/blackfin/bfin_capture.c       |    2 -
 drivers/media/radio/radio-wl1273.c                   |   10 ++---
 drivers/media/radio/si470x/radio-si470x-common.c     |    4 +-
 drivers/media/rc/iguanair.c                          |    2 -
 drivers/memstick/core/memstick.c                     |    2 -
 drivers/memstick/host/r592.c                         |    2 -
 drivers/misc/ti-st/st_kim.c                          |   12 +++---
 drivers/mtd/nand/mxc_nand.c                          |    2 -
 drivers/mtd/nand/r852.c                              |    2 -
 drivers/mtd/onenand/omap2.c                          |   10 ++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c  |    2 -
 drivers/net/ieee802154/at86rf230.c                   |    2 -
 drivers/net/ieee802154/mrf24j40.c                    |    2 -
 drivers/net/wireless/ath/ath10k/htc.c                |    4 +-
 drivers/net/wireless/ath/ath10k/mac.c                |   18 +++++-----
 drivers/net/wireless/ath/carl9170/usb.c              |    2 -
 drivers/net/wireless/ath/wil6210/main.c              |    2 -
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c        |    4 +-
 drivers/net/wireless/zd1211rw/zd_usb.c               |    2 -
 drivers/parport/parport_ip32.c                       |    4 +-
 drivers/platform/x86/apple-gmux.c                    |    2 -
 drivers/power/ab8500_fg.c                            |    4 +-
 drivers/power/jz4740-battery.c                       |    2 -
 drivers/rtc/rtc-hid-sensor-time.c                    |    2 -
 drivers/spi/spi-bcm2835.c                            |    2 -
 drivers/spi/spi-clps711x.c                           |    2 -
 drivers/spi/spi-davinci.c                            |    2 -
 drivers/spi/spi-fsl-espi.c                           |    2 -
 drivers/spi/spi-fsl-spi.c                            |    2 -
 drivers/spi/spi-mpc512x-psc.c                        |    2 -
 drivers/spi/spi-mxs.c                                |    2 -
 drivers/spi/spi-s3c64xx.c                            |    2 -
 drivers/spi/spi-sh-msiof.c                           |    2 -
 drivers/spi/spi-sirf.c                               |    4 +-
 drivers/spi/spi-tegra114.c                           |    6 +--
 drivers/spi/spi-tegra20-sflash.c                     |    2 -
 drivers/spi/spi-tegra20-slink.c                      |    6 +--
 drivers/spi/spi-xilinx.c                             |    2 -
 drivers/staging/iio/adc/mxs-lradc.c                  |    2 -
 drivers/staging/media/solo6x10/solo6x10-p2m.c        |    2 -
 drivers/staging/tidspbridge/core/sync.c              |    4 +-
 drivers/staging/tidspbridge/include/dspbridge/sync.h |    2 -
 drivers/staging/tidspbridge/rmgr/drv_interface.c     |    6 +--
 drivers/tty/metag_da.c                               |    2 -
 drivers/usb/c67x00/c67x00-sched.c                    |    2 -
 drivers/usb/gadget/f_fs.c                            |    2 -
 drivers/usb/serial/mos7720.c                         |    2 -
 drivers/video/exynos/exynos_mipi_dsi_common.c        |    4 +-
 drivers/video/omap2/displays-new/encoder-tpd12s015.c |    2 -
 fs/ecryptfs/crypto.c                                 |    2 -
 fs/nfs/nfs4state.c                                   |    2 -
 fs/ocfs2/dlmglue.c                                   |    4 +-
 sound/soc/samsung/ac97.c                             |    6 +--
 82 files changed, 134 insertions(+), 134 deletions(-)

diff -puN arch/arm/mach-tegra/apbio.c~tree-wide-use-reinit_completion-instead-of-init_completion arch/arm/mach-tegra/apbio.c
--- a/arch/arm/mach-tegra/apbio.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/arch/arm/mach-tegra/apbio.c
@@ -114,7 +114,7 @@ static int do_dma_transfer(unsigned long
 	dma_desc->callback = apb_dma_complete;
 	dma_desc->callback_param = NULL;
 
-	INIT_COMPLETION(tegra_apb_wait);
+	reinit_completion(&tegra_apb_wait);
 
 	dmaengine_submit(dma_desc);
 	dma_async_issue_pending(tegra_apb_dma_chan);
diff -puN arch/powerpc/platforms/powermac/low_i2c.c~tree-wide-use-reinit_completion-instead-of-init_completion arch/powerpc/platforms/powermac/low_i2c.c
--- a/arch/powerpc/platforms/powermac/low_i2c.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/arch/powerpc/platforms/powermac/low_i2c.c
@@ -452,7 +452,7 @@ static int kw_i2c_xfer(struct pmac_i2c_b
 	 */
 	if (use_irq) {
 		/* Clear completion */
-		INIT_COMPLETION(host->complete);
+		reinit_completion(&host->complete);
 		/* Ack stale interrupts */
 		kw_write_reg(reg_isr, kw_read_reg(reg_isr));
 		/* Arm timeout */
@@ -717,7 +717,7 @@ static int pmu_i2c_xfer(struct pmac_i2c_
 			return -EINVAL;
 		}
 
-		INIT_COMPLETION(comp);
+		reinit_completion(&comp);
 		req->data[0] = PMU_I2C_CMD;
 		req->reply[0] = 0xff;
 		req->nbytes = sizeof(struct pmu_i2c_hdr) + 1;
@@ -748,7 +748,7 @@ static int pmu_i2c_xfer(struct pmac_i2c_
 
 		hdr->bus = PMU_I2C_BUS_STATUS;
 
-		INIT_COMPLETION(comp);
+		reinit_completion(&comp);
 		req->data[0] = PMU_I2C_CMD;
 		req->reply[0] = 0xff;
 		req->nbytes = 2;
diff -puN arch/powerpc/platforms/pseries/suspend.c~tree-wide-use-reinit_completion-instead-of-init_completion arch/powerpc/platforms/pseries/suspend.c
--- a/arch/powerpc/platforms/pseries/suspend.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/arch/powerpc/platforms/pseries/suspend.c
@@ -106,7 +106,7 @@ static int pseries_prepare_late(void)
 	atomic_set(&suspend_data.done, 0);
 	atomic_set(&suspend_data.error, 0);
 	suspend_data.complete = &suspend_work;
-	INIT_COMPLETION(suspend_work);
+	reinit_completion(&suspend_work);
 	return 0;
 }
 
diff -puN crypto/af_alg.c~tree-wide-use-reinit_completion-instead-of-init_completion crypto/af_alg.c
--- a/crypto/af_alg.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/crypto/af_alg.c
@@ -434,7 +434,7 @@ int af_alg_wait_for_completion(int err,
 	case -EINPROGRESS:
 	case -EBUSY:
 		wait_for_completion(&completion->completion);
-		INIT_COMPLETION(completion->completion);
+		reinit_completion(&completion->completion);
 		err = completion->err;
 		break;
 	};
diff -puN crypto/tcrypt.c~tree-wide-use-reinit_completion-instead-of-init_completion crypto/tcrypt.c
--- a/crypto/tcrypt.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/crypto/tcrypt.c
@@ -493,7 +493,7 @@ static inline int do_one_ahash_op(struct
 		ret = wait_for_completion_interruptible(&tr->completion);
 		if (!ret)
 			ret = tr->err;
-		INIT_COMPLETION(tr->completion);
+		reinit_completion(&tr->completion);
 	}
 	return ret;
 }
@@ -721,7 +721,7 @@ static inline int do_one_acipher_op(stru
 		ret = wait_for_completion_interruptible(&tr->completion);
 		if (!ret)
 			ret = tr->err;
-		INIT_COMPLETION(tr->completion);
+		reinit_completion(&tr->completion);
 	}
 
 	return ret;
diff -puN crypto/testmgr.c~tree-wide-use-reinit_completion-instead-of-init_completion crypto/testmgr.c
--- a/crypto/testmgr.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/crypto/testmgr.c
@@ -179,7 +179,7 @@ static int do_one_async_hash_op(struct a
 		ret = wait_for_completion_interruptible(&tr->completion);
 		if (!ret)
 			ret = tr->err;
-		INIT_COMPLETION(tr->completion);
+		reinit_completion(&tr->completion);
 	}
 	return ret;
 }
@@ -336,7 +336,7 @@ static int __test_hash(struct crypto_aha
 				ret = wait_for_completion_interruptible(
 					&tresult.completion);
 				if (!ret && !(ret = tresult.err)) {
-					INIT_COMPLETION(tresult.completion);
+					reinit_completion(&tresult.completion);
 					break;
 				}
 				/* fall through */
@@ -543,7 +543,7 @@ static int __test_aead(struct crypto_aea
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !(ret = result.err)) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 			case -EBADMSG:
@@ -697,7 +697,7 @@ static int __test_aead(struct crypto_aea
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !(ret = result.err)) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 			case -EBADMSG:
@@ -983,7 +983,7 @@ static int __test_skcipher(struct crypto
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !((ret = result.err))) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 				/* fall through */
@@ -1086,7 +1086,7 @@ static int __test_skcipher(struct crypto
 				ret = wait_for_completion_interruptible(
 					&result.completion);
 				if (!ret && !((ret = result.err))) {
-					INIT_COMPLETION(result.completion);
+					reinit_completion(&result.completion);
 					break;
 				}
 				/* fall through */
diff -puN drivers/ata/libata-eh.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/ata/libata-eh.c
--- a/drivers/ata/libata-eh.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/ata/libata-eh.c
@@ -3009,7 +3009,7 @@ static inline void ata_eh_pull_park_acti
 	 * ourselves at the beginning of each pass over the loop.
 	 *
 	 * Additionally, all write accesses to &ap->park_req_pending
-	 * through INIT_COMPLETION() (see below) or complete_all()
+	 * through reinit_completion() (see below) or complete_all()
 	 * (see ata_scsi_park_store()) are protected by the host lock.
 	 * As a result we have that park_req_pending.done is zero on
 	 * exit from this function, i.e. when ATA_EH_PARK actions for
@@ -3023,7 +3023,7 @@ static inline void ata_eh_pull_park_acti
 	 */
 
 	spin_lock_irqsave(ap->lock, flags);
-	INIT_COMPLETION(ap->park_req_pending);
+	reinit_completion(&ap->park_req_pending);
 	ata_for_each_link(link, ap, EDGE) {
 		ata_for_each_dev(dev, link, ALL) {
 			struct ata_eh_info *ehi = &link->eh_info;
diff -puN drivers/base/power/main.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/base/power/main.c
--- a/drivers/base/power/main.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/base/power/main.c
@@ -687,7 +687,7 @@ void dpm_resume(pm_message_t state)
 	async_error = 0;
 
 	list_for_each_entry(dev, &dpm_suspended_list, power.entry) {
-		INIT_COMPLETION(dev->power.completion);
+		reinit_completion(&dev->power.completion);
 		if (is_async(dev)) {
 			get_device(dev);
 			async_schedule(async_resume, dev);
@@ -1164,7 +1164,7 @@ static void async_suspend(void *data, as
 
 static int device_suspend(struct device *dev)
 {
-	INIT_COMPLETION(dev->power.completion);
+	reinit_completion(&dev->power.completion);
 
 	if (pm_async_enabled && dev->power.async_suspend) {
 		get_device(dev);
diff -puN drivers/block/amiflop.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/block/amiflop.c
--- a/drivers/block/amiflop.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/block/amiflop.c
@@ -343,7 +343,7 @@ static int fd_motor_on(int nr)
 		unit[nr].motor = 1;
 		fd_select(nr);
 
-		INIT_COMPLETION(motor_on_completion);
+		reinit_completion(&motor_on_completion);
 		motor_on_timer.data = nr;
 		mod_timer(&motor_on_timer, jiffies + HZ/2);
 
diff -puN drivers/block/cciss.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/block/cciss.c
--- a/drivers/block/cciss.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/block/cciss.c
@@ -2808,7 +2808,7 @@ resend_cmd2:
 		/* erase the old error information */
 		memset(c->err_info, 0, sizeof(ErrorInfo_struct));
 		return_status = IO_OK;
-		INIT_COMPLETION(wait);
+		reinit_completion(&wait);
 		goto resend_cmd2;
 	}
 
@@ -3669,7 +3669,7 @@ static int add_to_scan_list(struct ctlr_
 		}
 	}
 	if (!found && !h->busy_scanning) {
-		INIT_COMPLETION(h->scan_wait);
+		reinit_completion(&h->scan_wait);
 		list_add_tail(&h->scan_list, &scan_q);
 		ret = 1;
 	}
diff -puN drivers/char/hw_random/timeriomem-rng.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/char/hw_random/timeriomem-rng.c
--- a/drivers/char/hw_random/timeriomem-rng.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/char/hw_random/timeriomem-rng.c
@@ -79,7 +79,7 @@ static int timeriomem_rng_data_read(stru
 	priv->expires = cur + delay;
 	priv->present = 0;
 
-	INIT_COMPLETION(priv->completion);
+	reinit_completion(&priv->completion);
 	mod_timer(&priv->timer, priv->expires);
 
 	return 4;
diff -puN drivers/crypto/tegra-aes.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/crypto/tegra-aes.c
--- a/drivers/crypto/tegra-aes.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/crypto/tegra-aes.c
@@ -268,7 +268,7 @@ static int aes_start_crypt(struct tegra_
 	aes_writel(dd, value, TEGRA_AES_SECURE_INPUT_SELECT);
 
 	aes_writel(dd, out_addr, TEGRA_AES_SECURE_DEST_ADDR);
-	INIT_COMPLETION(dd->op_complete);
+	reinit_completion(&dd->op_complete);
 
 	for (i = 0; i < AES_HW_MAX_ICQ_LENGTH - 1; i++) {
 		do {
diff -puN drivers/firewire/core-transaction.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/firewire/core-transaction.c
--- a/drivers/firewire/core-transaction.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/firewire/core-transaction.c
@@ -477,7 +477,7 @@ void fw_send_phy_config(struct fw_card *
 	phy_config_packet.header[1] = data;
 	phy_config_packet.header[2] = ~data;
 	phy_config_packet.generation = generation;
-	INIT_COMPLETION(phy_config_done);
+	reinit_completion(&phy_config_done);
 
 	card->driver->send_request(card, &phy_config_packet);
 	wait_for_completion_timeout(&phy_config_done, timeout);
diff -puN drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c
@@ -99,7 +99,7 @@ static int xfer_read(struct i2c_adapter
 	i2c_dev->status = I2C_STAT_INIT;
 	i2c_dev->msg = pmsg;
 	i2c_dev->buf_offset = 0;
-	INIT_COMPLETION(i2c_dev->complete);
+	reinit_completion(&i2c_dev->complete);
 
 	/* Enable I2C transaction */
 	temp = ((pmsg->len) << 20) | HI2C_EDID_READ | HI2C_ENABLE_TRANSACTION;
diff -puN drivers/hid/hid-wiimote.h~tree-wide-use-reinit_completion-instead-of-init_completion drivers/hid/hid-wiimote.h
--- a/drivers/hid/hid-wiimote.h~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/hid/hid-wiimote.h
@@ -327,7 +327,7 @@ static inline void wiimote_cmd_acquire_n
 static inline void wiimote_cmd_set(struct wiimote_data *wdata, int cmd,
 								__u32 opt)
 {
-	INIT_COMPLETION(wdata->state.ready);
+	reinit_completion(&wdata->state.ready);
 	wdata->state.cmd = cmd;
 	wdata->state.opt = opt;
 }
diff -puN drivers/hwmon/jz4740-hwmon.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/hwmon/jz4740-hwmon.c
--- a/drivers/hwmon/jz4740-hwmon.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/hwmon/jz4740-hwmon.c
@@ -66,7 +66,7 @@ static ssize_t jz4740_hwmon_read_adcin(s
 
 	mutex_lock(&hwmon->lock);
 
-	INIT_COMPLETION(*completion);
+	reinit_completion(completion);
 
 	enable_irq(hwmon->irq);
 	hwmon->cell->enable(to_platform_device(dev));
diff -puN drivers/i2c/busses/i2c-at91.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-at91.c
--- a/drivers/i2c/busses/i2c-at91.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-at91.c
@@ -371,7 +371,7 @@ static int at91_do_twi_transfer(struct a
 	dev_dbg(dev->dev, "transfer: %s %d bytes.\n",
 		(dev->msg->flags & I2C_M_RD) ? "read" : "write", dev->buf_len);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->transfer_status = 0;
 
 	if (!dev->buf_len) {
diff -puN drivers/i2c/busses/i2c-bcm2835.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-bcm2835.c
--- a/drivers/i2c/busses/i2c-bcm2835.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-bcm2835.c
@@ -151,7 +151,7 @@ static int bcm2835_i2c_xfer_msg(struct b
 
 	i2c_dev->msg_buf = msg->buf;
 	i2c_dev->msg_buf_remaining = msg->len;
-	INIT_COMPLETION(i2c_dev->completion);
+	reinit_completion(&i2c_dev->completion);
 
 	bcm2835_i2c_writel(i2c_dev, BCM2835_I2C_C, BCM2835_I2C_C_CLEAR);
 
diff -puN drivers/i2c/busses/i2c-davinci.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-davinci.c
--- a/drivers/i2c/busses/i2c-davinci.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-davinci.c
@@ -323,7 +323,7 @@ i2c_davinci_xfer_msg(struct i2c_adapter
 
 	davinci_i2c_write_reg(dev, DAVINCI_I2C_CNT_REG, dev->buf_len);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->cmd_err = 0;
 
 	/* Take I2C out of reset and configure it as master */
diff -puN drivers/i2c/busses/i2c-designware-core.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-designware-core.c
--- a/drivers/i2c/busses/i2c-designware-core.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-designware-core.c
@@ -613,7 +613,7 @@ i2c_dw_xfer(struct i2c_adapter *adap, st
 	mutex_lock(&dev->lock);
 	pm_runtime_get_sync(dev->dev);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->msgs = msgs;
 	dev->msgs_num = num;
 	dev->cmd_err = 0;
diff -puN drivers/i2c/busses/i2c-ismt.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-ismt.c
--- a/drivers/i2c/busses/i2c-ismt.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-ismt.c
@@ -541,7 +541,7 @@ static int ismt_access(struct i2c_adapte
 		desc->dptr_high = upper_32_bits(dma_addr);
 	}
 
-	INIT_COMPLETION(priv->cmp);
+	reinit_completion(&priv->cmp);
 
 	/* Add the descriptor */
 	ismt_submit_desc(priv);
diff -puN drivers/i2c/busses/i2c-mxs.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-mxs.c
--- a/drivers/i2c/busses/i2c-mxs.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-mxs.c
@@ -505,7 +505,7 @@ static int mxs_i2c_xfer_msg(struct i2c_a
 				return err;
 		}
 	} else {
-		INIT_COMPLETION(i2c->cmd_complete);
+		reinit_completion(&i2c->cmd_complete);
 		ret = mxs_i2c_dma_setup_xfer(adap, msg, flags);
 		if (ret)
 			return ret;
diff -puN drivers/i2c/busses/i2c-omap.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-omap.c
--- a/drivers/i2c/busses/i2c-omap.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-omap.c
@@ -543,7 +543,7 @@ static int omap_i2c_xfer_msg(struct i2c_
 	w |= OMAP_I2C_BUF_RXFIF_CLR | OMAP_I2C_BUF_TXFIF_CLR;
 	omap_i2c_write_reg(dev, OMAP_I2C_BUF_REG, w);
 
-	INIT_COMPLETION(dev->cmd_complete);
+	reinit_completion(&dev->cmd_complete);
 	dev->cmd_err = 0;
 
 	w = OMAP_I2C_CON_EN | OMAP_I2C_CON_MST | OMAP_I2C_CON_STT;
diff -puN drivers/i2c/busses/i2c-tegra.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-tegra.c
--- a/drivers/i2c/busses/i2c-tegra.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-tegra.c
@@ -544,7 +544,7 @@ static int tegra_i2c_xfer_msg(struct teg
 	i2c_dev->msg_buf_remaining = msg->len;
 	i2c_dev->msg_err = I2C_ERR_NONE;
 	i2c_dev->msg_read = (msg->flags & I2C_M_RD);
-	INIT_COMPLETION(i2c_dev->msg_complete);
+	reinit_completion(&i2c_dev->msg_complete);
 
 	packet_header = (0 << PACKET_HEADER0_HEADER_SIZE_SHIFT) |
 			PACKET_HEADER0_PROTOCOL_I2C |
diff -puN drivers/i2c/busses/i2c-wmt.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/i2c/busses/i2c-wmt.c
--- a/drivers/i2c/busses/i2c-wmt.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/i2c/busses/i2c-wmt.c
@@ -158,7 +158,7 @@ static int wmt_i2c_write(struct i2c_adap
 		writew(val, i2c_dev->base + REG_CR);
 	}
 
-	INIT_COMPLETION(i2c_dev->complete);
+	reinit_completion(&i2c_dev->complete);
 
 	if (i2c_dev->mode == I2C_MODE_STANDARD)
 		tcr_val = TCR_STANDARD_MODE;
@@ -247,7 +247,7 @@ static int wmt_i2c_read(struct i2c_adapt
 		writew(val, i2c_dev->base + REG_CR);
 	}
 
-	INIT_COMPLETION(i2c_dev->complete);
+	reinit_completion(&i2c_dev->complete);
 
 	if (i2c_dev->mode == I2C_MODE_STANDARD)
 		tcr_val = TCR_STANDARD_MODE;
diff -puN drivers/iio/adc/ad_sigma_delta.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/iio/adc/ad_sigma_delta.c
--- a/drivers/iio/adc/ad_sigma_delta.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/iio/adc/ad_sigma_delta.c
@@ -188,7 +188,7 @@ static int ad_sd_calibrate(struct ad_sig
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
-	INIT_COMPLETION(sigma_delta->completion);
+	reinit_completion(&sigma_delta->completion);
 
 	ret = ad_sigma_delta_set_mode(sigma_delta, mode);
 	if (ret < 0)
@@ -259,7 +259,7 @@ int ad_sigma_delta_single_conversion(str
 
 	spi_bus_lock(sigma_delta->spi->master);
 	sigma_delta->bus_locked = true;
-	INIT_COMPLETION(sigma_delta->completion);
+	reinit_completion(&sigma_delta->completion);
 
 	ad_sigma_delta_set_mode(sigma_delta, AD_SD_MODE_SINGLE);
 
@@ -343,7 +343,7 @@ static int ad_sd_buffer_postdisable(stru
 {
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
 
-	INIT_COMPLETION(sigma_delta->completion);
+	reinit_completion(&sigma_delta->completion);
 	wait_for_completion_timeout(&sigma_delta->completion, HZ);
 
 	if (!sigma_delta->irq_dis) {
diff -puN drivers/iio/adc/nau7802.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/iio/adc/nau7802.c
--- a/drivers/iio/adc/nau7802.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/iio/adc/nau7802.c
@@ -189,7 +189,7 @@ static int nau7802_read_irq(struct iio_d
 	struct nau7802_state *st = iio_priv(indio_dev);
 	int ret;
 
-	INIT_COMPLETION(st->value_ok);
+	reinit_completion(&st->value_ok);
 	enable_irq(st->client->irq);
 
 	nau7802_sync(st);
diff -puN drivers/input/touchscreen/cyttsp_core.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/input/touchscreen/cyttsp_core.c
--- a/drivers/input/touchscreen/cyttsp_core.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/input/touchscreen/cyttsp_core.c
@@ -242,7 +242,7 @@ static int cyttsp_soft_reset(struct cytt
 	int retval;
 
 	/* wait for interrupt to set ready completion */
-	INIT_COMPLETION(ts->bl_ready);
+	reinit_completion(&ts->bl_ready);
 	ts->state = CY_BL_STATE;
 
 	enable_irq(ts->irq);
diff -puN drivers/md/dm-crypt.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/md/dm-crypt.c
@@ -774,7 +774,7 @@ static int crypt_convert(struct crypt_co
 		/* async */
 		case -EBUSY:
 			wait_for_completion(&ctx->restart);
-			INIT_COMPLETION(ctx->restart);
+			reinit_completion(&ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
 			this_cc->req = NULL;
diff -puN drivers/media/platform/blackfin/bfin_capture.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/media/platform/blackfin/bfin_capture.c
--- a/drivers/media/platform/blackfin/bfin_capture.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/media/platform/blackfin/bfin_capture.c
@@ -422,7 +422,7 @@ static int bcap_start_streaming(struct v
 		return ret;
 	}
 
-	INIT_COMPLETION(bcap_dev->comp);
+	reinit_completion(&bcap_dev->comp);
 	bcap_dev->stop = false;
 	return 0;
 }
diff -puN drivers/media/radio/radio-wl1273.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/media/radio/radio-wl1273.c
--- a/drivers/media/radio/radio-wl1273.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/media/radio/radio-wl1273.c
@@ -375,7 +375,7 @@ static int wl1273_fm_set_tx_freq(struct
 	if (r)
 		return r;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 
 	/* wait for the FR IRQ */
 	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
@@ -389,7 +389,7 @@ static int wl1273_fm_set_tx_freq(struct
 	if (r)
 		return r;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 
 	/* wait for the POWER_ENB IRQ */
 	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000));
@@ -444,7 +444,7 @@ static int wl1273_fm_set_rx_freq(struct
 		goto err;
 	}
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 
 	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
 	if (!r) {
@@ -805,7 +805,7 @@ static int wl1273_fm_set_seek(struct wl1
 	if (level < SCHAR_MIN || level > SCHAR_MAX)
 		return -EINVAL;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 	dev_dbg(radio->dev, "%s: BUSY\n", __func__);
 
 	r = core->write(core, WL1273_INT_MASK_SET, radio->irq_flags);
@@ -847,7 +847,7 @@ static int wl1273_fm_set_seek(struct wl1
 	if (r)
 		goto out;
 
-	INIT_COMPLETION(radio->busy);
+	reinit_completion(&radio->busy);
 	dev_dbg(radio->dev, "%s: BUSY\n", __func__);
 
 	r = core->write(core, WL1273_TUNER_MODE_SET, TUNER_MODE_AUTO_SEEK);
diff -puN drivers/media/radio/si470x/radio-si470x-common.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/media/radio/si470x/radio-si470x-common.c
--- a/drivers/media/radio/si470x/radio-si470x-common.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/media/radio/si470x/radio-si470x-common.c
@@ -218,7 +218,7 @@ static int si470x_set_chan(struct si470x
 		goto done;
 
 	/* wait till tune operation has completed */
-	INIT_COMPLETION(radio->completion);
+	reinit_completion(&radio->completion);
 	retval = wait_for_completion_timeout(&radio->completion,
 			msecs_to_jiffies(tune_timeout));
 	if (!retval)
@@ -341,7 +341,7 @@ static int si470x_set_seek(struct si470x
 		return retval;
 
 	/* wait till tune operation has completed */
-	INIT_COMPLETION(radio->completion);
+	reinit_completion(&radio->completion);
 	retval = wait_for_completion_timeout(&radio->completion,
 			msecs_to_jiffies(seek_timeout));
 	if (!retval)
diff -puN drivers/media/rc/iguanair.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/media/rc/iguanair.c
--- a/drivers/media/rc/iguanair.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/media/rc/iguanair.c
@@ -207,7 +207,7 @@ static int iguanair_send(struct iguanair
 {
 	int rc;
 
-	INIT_COMPLETION(ir->completion);
+	reinit_completion(&ir->completion);
 
 	ir->urb_out->transfer_buffer_length = size;
 	rc = usb_submit_urb(ir->urb_out, GFP_KERNEL);
diff -puN drivers/memstick/core/memstick.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/memstick/core/memstick.c
@@ -253,7 +253,7 @@ void memstick_new_req(struct memstick_ho
 {
 	if (host->card) {
 		host->retries = cmd_retries;
-		INIT_COMPLETION(host->card->mrq_complete);
+		reinit_completion(&host->card->mrq_complete);
 		host->request(host);
 	}
 }
diff -puN drivers/memstick/host/r592.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/memstick/host/r592.c
--- a/drivers/memstick/host/r592.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/memstick/host/r592.c
@@ -290,7 +290,7 @@ static int r592_transfer_fifo_dma(struct
 	dbg_verbose("doing dma transfer");
 
 	dev->dma_error = 0;
-	INIT_COMPLETION(dev->dma_done);
+	reinit_completion(&dev->dma_done);
 
 	/* TODO: hidden assumption about nenth beeing always 1 */
 	sg_count = dma_map_sg(&dev->pci_dev->dev, &dev->req->sg, 1, is_write ?
diff -puN drivers/misc/ti-st/st_kim.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/misc/ti-st/st_kim.c
--- a/drivers/misc/ti-st/st_kim.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/misc/ti-st/st_kim.c
@@ -218,7 +218,7 @@ static long read_local_version(struct ki
 
 	pr_debug("%s", __func__);
 
-	INIT_COMPLETION(kim_gdata->kim_rcvd);
+	reinit_completion(&kim_gdata->kim_rcvd);
 	if (4 != st_int_write(kim_gdata->core_data, read_ver_cmd, 4)) {
 		pr_err("kim: couldn't write 4 bytes");
 		return -EIO;
@@ -229,7 +229,7 @@ static long read_local_version(struct ki
 		pr_err(" waiting for ver info- timed out ");
 		return -ETIMEDOUT;
 	}
-	INIT_COMPLETION(kim_gdata->kim_rcvd);
+	reinit_completion(&kim_gdata->kim_rcvd);
 	/* the positions 12 & 13 in the response buffer provide with the
 	 * chip, major & minor numbers
 	 */
@@ -362,7 +362,7 @@ static long download_firmware(struct kim
 			/* reinit completion before sending for the
 			 * relevant wait
 			 */
-			INIT_COMPLETION(kim_gdata->kim_rcvd);
+			reinit_completion(&kim_gdata->kim_rcvd);
 
 			/*
 			 * Free space found in uart buffer, call st_int_write
@@ -398,7 +398,7 @@ static long download_firmware(struct kim
 				release_firmware(kim_gdata->fw_entry);
 				return -ETIMEDOUT;
 			}
-			INIT_COMPLETION(kim_gdata->kim_rcvd);
+			reinit_completion(&kim_gdata->kim_rcvd);
 			break;
 		case ACTION_DELAY:	/* sleep */
 			pr_info("sleep command in scr");
@@ -474,7 +474,7 @@ long st_kim_start(void *kim_data)
 		gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
 		mdelay(100);
 		/* re-initialize the completion */
-		INIT_COMPLETION(kim_gdata->ldisc_installed);
+		reinit_completion(&kim_gdata->ldisc_installed);
 		/* send notification to UIM */
 		kim_gdata->ldisc_install = 1;
 		pr_info("ldisc_install = 1");
@@ -525,7 +525,7 @@ long st_kim_stop(void *kim_data)
 		kim_gdata->kim_pdev->dev.platform_data;
 	struct tty_struct	*tty = kim_gdata->core_data->tty;
 
-	INIT_COMPLETION(kim_gdata->ldisc_installed);
+	reinit_completion(&kim_gdata->ldisc_installed);
 
 	if (tty) {	/* can be called before ldisc is installed */
 		/* Flush any pending characters in the driver and discipline. */
diff -puN drivers/mtd/nand/mxc_nand.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/mtd/nand/mxc_nand.c
--- a/drivers/mtd/nand/mxc_nand.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/mtd/nand/mxc_nand.c
@@ -395,7 +395,7 @@ static void wait_op_done(struct mxc_nand
 
 	if (useirq) {
 		if (!host->devtype_data->check_int(host)) {
-			INIT_COMPLETION(host->op_completion);
+			reinit_completion(&host->op_completion);
 			irq_control(host, 1);
 			wait_for_completion(&host->op_completion);
 		}
diff -puN drivers/mtd/nand/r852.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/mtd/nand/r852.c
--- a/drivers/mtd/nand/r852.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/mtd/nand/r852.c
@@ -181,7 +181,7 @@ static void r852_do_dma(struct r852_devi
 	/* Set dma direction */
 	dev->dma_dir = do_read;
 	dev->dma_stage = 1;
-	INIT_COMPLETION(dev->dma_done);
+	reinit_completion(&dev->dma_done);
 
 	dbg_verbose("doing dma %s ", do_read ? "read" : "write");
 
diff -puN drivers/mtd/onenand/omap2.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/mtd/onenand/omap2.c
--- a/drivers/mtd/onenand/omap2.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/mtd/onenand/omap2.c
@@ -159,7 +159,7 @@ static int omap2_onenand_wait(struct mtd
 				syscfg = read_reg(c, ONENAND_REG_SYS_CFG1);
 		}
 
-		INIT_COMPLETION(c->irq_done);
+		reinit_completion(&c->irq_done);
 		if (c->gpio_irq) {
 			result = gpio_get_value(c->gpio_irq);
 			if (result == -1) {
@@ -349,7 +349,7 @@ static int omap3_onenand_read_bufferram(
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 
 	timeout = jiffies + msecs_to_jiffies(20);
@@ -420,7 +420,7 @@ static int omap3_onenand_write_bufferram
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 
 	timeout = jiffies + msecs_to_jiffies(20);
@@ -499,7 +499,7 @@ static int omap2_onenand_read_bufferram(
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 	wait_for_completion(&c->dma_done);
 
@@ -544,7 +544,7 @@ static int omap2_onenand_write_bufferram
 	omap_set_dma_dest_params(c->dma_channel, 0, OMAP_DMA_AMODE_POST_INC,
 				 dma_dst, 0, 0);
 
-	INIT_COMPLETION(c->dma_done);
+	reinit_completion(&c->dma_done);
 	omap_start_dma(c->dma_channel);
 	wait_for_completion(&c->dma_done);
 
diff -puN drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3524,7 +3524,7 @@ int qlcnic_83xx_resume(struct qlcnic_ada
 
 void qlcnic_83xx_reinit_mbx_work(struct qlcnic_mailbox *mbx)
 {
-	INIT_COMPLETION(mbx->completion);
+	reinit_completion(&mbx->completion);
 	set_bit(QLC_83XX_MBX_READY, &mbx->status);
 }
 
diff -puN drivers/net/ieee802154/at86rf230.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/ieee802154/at86rf230.c
--- a/drivers/net/ieee802154/at86rf230.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/ieee802154/at86rf230.c
@@ -561,7 +561,7 @@ at86rf230_xmit(struct ieee802154_dev *de
 
 	spin_lock_irqsave(&lp->lock, flags);
 	lp->is_tx = 1;
-	INIT_COMPLETION(lp->tx_complete);
+	reinit_completion(&lp->tx_complete);
 	spin_unlock_irqrestore(&lp->lock, flags);
 
 	rc = at86rf230_write_fbuf(lp, skb->data, skb->len);
diff -puN drivers/net/ieee802154/mrf24j40.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/ieee802154/mrf24j40.c
--- a/drivers/net/ieee802154/mrf24j40.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/ieee802154/mrf24j40.c
@@ -354,7 +354,7 @@ static int mrf24j40_tx(struct ieee802154
 		val |= 0x4;
 	write_short_reg(devrec, REG_TXNCON, val);
 
-	INIT_COMPLETION(devrec->tx_complete);
+	reinit_completion(&devrec->tx_complete);
 
 	/* Wait for the device to send the TX complete interrupt. */
 	ret = wait_for_completion_interruptible_timeout(
diff -puN drivers/net/wireless/ath/ath10k/htc.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/wireless/ath/ath10k/htc.c
--- a/drivers/net/wireless/ath/ath10k/htc.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/wireless/ath/ath10k/htc.c
@@ -647,7 +647,7 @@ int ath10k_htc_wait_target(struct ath10k
 	u16 credit_count;
 	u16 credit_size;
 
-	INIT_COMPLETION(htc->ctl_resp);
+	reinit_completion(&htc->ctl_resp);
 
 	status = ath10k_hif_start(htc->ar);
 	if (status) {
@@ -782,7 +782,7 @@ int ath10k_htc_connect_service(struct at
 		disable_credit_flow_ctrl = true;
 	}
 
-	INIT_COMPLETION(htc->ctl_resp);
+	reinit_completion(&htc->ctl_resp);
 
 	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
 	if (status) {
diff -puN drivers/net/wireless/ath/ath10k/mac.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/wireless/ath/ath10k/mac.c
--- a/drivers/net/wireless/ath/ath10k/mac.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/wireless/ath/ath10k/mac.c
@@ -92,7 +92,7 @@ static int ath10k_install_key(struct ath
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	INIT_COMPLETION(ar->install_key_done);
+	reinit_completion(&ar->install_key_done);
 
 	ret = ath10k_send_key(arvif, key, cmd, macaddr);
 	if (ret)
@@ -434,7 +434,7 @@ static int ath10k_vdev_start(struct ath1
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	INIT_COMPLETION(ar->vdev_setup_done);
+	reinit_completion(&ar->vdev_setup_done);
 
 	arg.vdev_id = arvif->vdev_id;
 	arg.dtim_period = arvif->dtim_period;
@@ -482,7 +482,7 @@ static int ath10k_vdev_stop(struct ath10
 
 	lockdep_assert_held(&ar->conf_mutex);
 
-	INIT_COMPLETION(ar->vdev_setup_done);
+	reinit_completion(&ar->vdev_setup_done);
 
 	ret = ath10k_wmi_vdev_stop(ar, arvif->vdev_id);
 	if (ret) {
@@ -1557,7 +1557,7 @@ void ath10k_offchan_tx_work(struct work_
 		}
 
 		spin_lock_bh(&ar->data_lock);
-		INIT_COMPLETION(ar->offchan_tx_completed);
+		reinit_completion(&ar->offchan_tx_completed);
 		ar->offchan_tx_skb = skb;
 		spin_unlock_bh(&ar->data_lock);
 
@@ -2313,8 +2313,8 @@ static int ath10k_hw_scan(struct ieee802
 		goto exit;
 	}
 
-	INIT_COMPLETION(ar->scan.started);
-	INIT_COMPLETION(ar->scan.completed);
+	reinit_completion(&ar->scan.started);
+	reinit_completion(&ar->scan.completed);
 	ar->scan.in_progress = true;
 	ar->scan.aborting = false;
 	ar->scan.is_roc = false;
@@ -2672,9 +2672,9 @@ static int ath10k_remain_on_channel(stru
 		goto exit;
 	}
 
-	INIT_COMPLETION(ar->scan.started);
-	INIT_COMPLETION(ar->scan.completed);
-	INIT_COMPLETION(ar->scan.on_channel);
+	reinit_completion(&ar->scan.started);
+	reinit_completion(&ar->scan.completed);
+	reinit_completion(&ar->scan.on_channel);
 	ar->scan.in_progress = true;
 	ar->scan.aborting = false;
 	ar->scan.is_roc = true;
diff -puN drivers/net/wireless/ath/carl9170/usb.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/wireless/ath/carl9170/usb.c
--- a/drivers/net/wireless/ath/carl9170/usb.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/wireless/ath/carl9170/usb.c
@@ -773,7 +773,7 @@ void carl9170_usb_stop(struct ar9170 *ar
 	complete_all(&ar->cmd_wait);
 
 	/* This is required to prevent an early completion on _start */
-	INIT_COMPLETION(ar->cmd_wait);
+	reinit_completion(&ar->cmd_wait);
 
 	/*
 	 * Note:
diff -puN drivers/net/wireless/ath/wil6210/main.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/wireless/ath/wil6210/main.c
--- a/drivers/net/wireless/ath/wil6210/main.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/wireless/ath/wil6210/main.c
@@ -250,7 +250,7 @@ int wil_reset(struct wil6210_priv *wil)
 
 	/* init after reset */
 	wil->pending_connect_cid = -1;
-	INIT_COMPLETION(wil->wmi_ready);
+	reinit_completion(&wil->wmi_ready);
 
 	/* TODO: release MAC reset */
 	wil6210_enable_irq(wil);
diff -puN drivers/net/wireless/brcm80211/brcmfmac/p2p.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/wireless/brcm80211/brcmfmac/p2p.c
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1148,7 +1148,7 @@ static s32 brcmf_p2p_af_searching_channe
 
 	pri_vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 
-	INIT_COMPLETION(afx_hdl->act_frm_scan);
+	reinit_completion(&afx_hdl->act_frm_scan);
 	set_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL, &p2p->status);
 	afx_hdl->is_active = true;
 	afx_hdl->peer_chan = P2P_INVALID_CHANNEL;
@@ -1501,7 +1501,7 @@ static s32 brcmf_p2p_tx_action_frame(str
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	INIT_COMPLETION(p2p->send_af_done);
+	reinit_completion(&p2p->send_af_done);
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status);
 	clear_bit(BRCMF_P2P_STATUS_ACTION_TX_NOACK, &p2p->status);
 
diff -puN drivers/net/wireless/zd1211rw/zd_usb.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/net/wireless/zd1211rw/zd_usb.c
--- a/drivers/net/wireless/zd1211rw/zd_usb.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1619,7 +1619,7 @@ static void prepare_read_regs_int(struct
 	atomic_set(&intr->read_regs_enabled, 1);
 	intr->read_regs.req = req;
 	intr->read_regs.req_count = count;
-	INIT_COMPLETION(intr->read_regs.completion);
+	reinit_completion(&intr->read_regs.completion);
 	spin_unlock_irq(&intr->lock);
 }
 
diff -puN drivers/parport/parport_ip32.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/parport/parport_ip32.c
--- a/drivers/parport/parport_ip32.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/parport/parport_ip32.c
@@ -1331,7 +1331,7 @@ static unsigned int parport_ip32_fwp_wai
 			break;
 
 		/* Initialize mutex used to take interrupts into account */
-		INIT_COMPLETION(priv->irq_complete);
+		reinit_completion(&priv->irq_complete);
 
 		/* Enable serviceIntr */
 		parport_ip32_frob_econtrol(p, ECR_SERVINTR, 0);
@@ -1446,7 +1446,7 @@ static size_t parport_ip32_fifo_write_bl
 	priv->irq_mode = PARPORT_IP32_IRQ_HERE;
 
 	parport_ip32_dma_start(DMA_TO_DEVICE, (void *)buf, len);
-	INIT_COMPLETION(priv->irq_complete);
+	reinit_completion(&priv->irq_complete);
 	parport_ip32_frob_econtrol(p, ECR_DMAEN | ECR_SERVINTR, ECR_DMAEN);
 
 	nfault_timeout = min((unsigned long)physport->cad->timeout,
diff -puN drivers/platform/x86/apple-gmux.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/platform/x86/apple-gmux.c
--- a/drivers/platform/x86/apple-gmux.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/platform/x86/apple-gmux.c
@@ -289,7 +289,7 @@ static int gmux_switchto(enum vga_switch
 static int gmux_set_discrete_state(struct apple_gmux_data *gmux_data,
 				   enum vga_switcheroo_state state)
 {
-	INIT_COMPLETION(gmux_data->powerchange_done);
+	reinit_completion(&gmux_data->powerchange_done);
 
 	if (state == VGA_SWITCHEROO_ON) {
 		gmux_write8(gmux_data, GMUX_PORT_DISCRETE_POWER, 1);
diff -puN drivers/power/ab8500_fg.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/power/ab8500_fg.c
--- a/drivers/power/ab8500_fg.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/power/ab8500_fg.c
@@ -574,8 +574,8 @@ int ab8500_fg_inst_curr_start(struct ab8
 	}
 
 	/* Return and WFI */
-	INIT_COMPLETION(di->ab8500_fg_started);
-	INIT_COMPLETION(di->ab8500_fg_complete);
+	reinit_completion(&di->ab8500_fg_started);
+	reinit_completion(&di->ab8500_fg_complete);
 	enable_irq(di->irq);
 
 	/* Note: cc_lock is still locked */
diff -puN drivers/power/jz4740-battery.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/power/jz4740-battery.c
--- a/drivers/power/jz4740-battery.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/power/jz4740-battery.c
@@ -73,7 +73,7 @@ static long jz_battery_read_voltage(stru
 
 	mutex_lock(&battery->lock);
 
-	INIT_COMPLETION(battery->read_completion);
+	reinit_completion(&battery->read_completion);
 
 	enable_irq(battery->irq);
 	battery->cell->enable(battery->pdev);
diff -puN drivers/rtc/rtc-hid-sensor-time.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/rtc/rtc-hid-sensor-time.c
--- a/drivers/rtc/rtc-hid-sensor-time.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/rtc/rtc-hid-sensor-time.c
@@ -209,7 +209,7 @@ static int hid_rtc_read_time(struct devi
 		platform_get_drvdata(to_platform_device(dev));
 	int ret;
 
-	INIT_COMPLETION(time_state->comp_last_time);
+	reinit_completion(&time_state->comp_last_time);
 	/* get a report with all values through requesting one value */
 	sensor_hub_input_attr_get_raw_value(time_state->common_attributes.hsdev,
 			HID_USAGE_SENSOR_TIME, hid_time_addresses[0],
diff -puN drivers/spi/spi-bcm2835.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-bcm2835.c
--- a/drivers/spi/spi-bcm2835.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-bcm2835.c
@@ -217,7 +217,7 @@ static int bcm2835_spi_start_transfer(st
 		cs |= spi->chip_select;
 	}
 
-	INIT_COMPLETION(bs->done);
+	reinit_completion(&bs->done);
 	bs->tx_buf = tfr->tx_buf;
 	bs->rx_buf = tfr->rx_buf;
 	bs->len = tfr->len;
diff -puN drivers/spi/spi-clps711x.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-clps711x.c
--- a/drivers/spi/spi-clps711x.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-clps711x.c
@@ -105,7 +105,7 @@ static int spi_clps711x_transfer_one_mes
 
 		gpio_set_value(cs, !!(msg->spi->mode & SPI_CS_HIGH));
 
-		INIT_COMPLETION(hw->done);
+		reinit_completion(&hw->done);
 
 		hw->count = 0;
 		hw->len = xfer->len;
diff -puN drivers/spi/spi-davinci.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-davinci.c
--- a/drivers/spi/spi-davinci.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-davinci.c
@@ -553,7 +553,7 @@ static int davinci_spi_bufs(struct spi_d
 	clear_io_bits(dspi->base + SPIGCR1, SPIGCR1_POWERDOWN_MASK);
 	set_io_bits(dspi->base + SPIGCR1, SPIGCR1_SPIENA_MASK);
 
-	INIT_COMPLETION(dspi->done);
+	reinit_completion(&dspi->done);
 
 	if (spicfg->io_type == SPI_IO_TYPE_INTR)
 		set_io_bits(dspi->base + SPIINT, SPIINT_MASKINT);
diff -puN drivers/spi/spi-fsl-espi.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-fsl-espi.c
--- a/drivers/spi/spi-fsl-espi.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-fsl-espi.c
@@ -230,7 +230,7 @@ static int fsl_espi_bufs(struct spi_devi
 	mpc8xxx_spi->tx = t->tx_buf;
 	mpc8xxx_spi->rx = t->rx_buf;
 
-	INIT_COMPLETION(mpc8xxx_spi->done);
+	reinit_completion(&mpc8xxx_spi->done);
 
 	/* Set SPCOM[CS] and SPCOM[TRANLEN] field */
 	if ((t->len - 1) > SPCOM_TRANLEN_MAX) {
diff -puN drivers/spi/spi-fsl-spi.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-fsl-spi.c
--- a/drivers/spi/spi-fsl-spi.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-fsl-spi.c
@@ -339,7 +339,7 @@ static int fsl_spi_bufs(struct spi_devic
 	mpc8xxx_spi->tx = t->tx_buf;
 	mpc8xxx_spi->rx = t->rx_buf;
 
-	INIT_COMPLETION(mpc8xxx_spi->done);
+	reinit_completion(&mpc8xxx_spi->done);
 
 	if (mpc8xxx_spi->flags & SPI_CPM_MODE)
 		ret = fsl_spi_cpm_bufs(mpc8xxx_spi, t, is_dma_mapped);
diff -puN drivers/spi/spi-mpc512x-psc.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-mpc512x-psc.c
--- a/drivers/spi/spi-mpc512x-psc.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-mpc512x-psc.c
@@ -166,7 +166,7 @@ static int mpc512x_psc_spi_transfer_rxtx
 			}
 
 			/* have the ISR trigger when the TX FIFO is empty */
-			INIT_COMPLETION(mps->txisrdone);
+			reinit_completion(&mps->txisrdone);
 			out_be32(&fifo->txisr, MPC512x_PSC_FIFO_EMPTY);
 			out_be32(&fifo->tximr, MPC512x_PSC_FIFO_EMPTY);
 			wait_for_completion(&mps->txisrdone);
diff -puN drivers/spi/spi-mxs.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-mxs.c
--- a/drivers/spi/spi-mxs.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-mxs.c
@@ -226,7 +226,7 @@ static int mxs_spi_txrx_dma(struct mxs_s
 	if (!dma_xfer)
 		return -ENOMEM;
 
-	INIT_COMPLETION(spi->c);
+	reinit_completion(&spi->c);
 
 	ctrl0 = readl(ssp->base + HW_SSP_CTRL0);
 	ctrl0 &= ~BM_SSP_CTRL0_XFER_COUNT;
diff -puN drivers/spi/spi-s3c64xx.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-s3c64xx.c
--- a/drivers/spi/spi-s3c64xx.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-s3c64xx.c
@@ -899,7 +899,7 @@ static int s3c64xx_spi_transfer_one_mess
 		unsigned long flags;
 		int use_dma;
 
-		INIT_COMPLETION(sdd->xfer_completion);
+		reinit_completion(&sdd->xfer_completion);
 
 		/* Only BPW and Speed may change across transfers */
 		bpw = xfer->bits_per_word;
diff -puN drivers/spi/spi-sh-msiof.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-sh-msiof.c
--- a/drivers/spi/spi-sh-msiof.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-sh-msiof.c
@@ -465,7 +465,7 @@ static int sh_msiof_spi_txrx_once(struct
 	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TXE);
 
 	/* start by setting frame bit */
-	INIT_COMPLETION(p->done);
+	reinit_completion(&p->done);
 	ret = ret ? ret : sh_msiof_modify_ctr_wait(p, 0, CTR_TFSE);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to start hardware\n");
diff -puN drivers/spi/spi-sirf.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-sirf.c
--- a/drivers/spi/spi-sirf.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-sirf.c
@@ -305,8 +305,8 @@ static int spi_sirfsoc_transfer(struct s
 	sspi->tx = t->tx_buf ? t->tx_buf : sspi->dummypage;
 	sspi->rx = t->rx_buf ? t->rx_buf : sspi->dummypage;
 	sspi->left_tx_word = sspi->left_rx_word = t->len / sspi->word_width;
-	INIT_COMPLETION(sspi->rx_done);
-	INIT_COMPLETION(sspi->tx_done);
+	reinit_completion(&sspi->rx_done);
+	reinit_completion(&sspi->tx_done);
 
 	writel(SIRFSOC_SPI_INT_MASK_ALL, sspi->base + SIRFSOC_SPI_INT_STATUS);
 
diff -puN drivers/spi/spi-tegra114.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-tegra114.c
--- a/drivers/spi/spi-tegra114.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-tegra114.c
@@ -450,7 +450,7 @@ static void tegra_spi_dma_complete(void
 
 static int tegra_spi_start_tx_dma(struct tegra_spi_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->tx_dma_complete);
+	reinit_completion(&tspi->tx_dma_complete);
 	tspi->tx_dma_desc = dmaengine_prep_slave_single(tspi->tx_dma_chan,
 				tspi->tx_dma_phys, len, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -469,7 +469,7 @@ static int tegra_spi_start_tx_dma(struct
 
 static int tegra_spi_start_rx_dma(struct tegra_spi_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->rx_dma_complete);
+	reinit_completion(&tspi->rx_dma_complete);
 	tspi->rx_dma_desc = dmaengine_prep_slave_single(tspi->rx_dma_chan,
 				tspi->rx_dma_phys, len, DMA_DEV_TO_MEM,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -818,7 +818,7 @@ static int tegra_spi_transfer_one_messag
 
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		INIT_COMPLETION(tspi->xfer_completion);
+		reinit_completion(&tspi->xfer_completion);
 		ret = tegra_spi_start_transfer_one(spi, xfer,
 					is_first_msg, single_xfer);
 		if (ret < 0) {
diff -puN drivers/spi/spi-tegra20-sflash.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-tegra20-sflash.c
--- a/drivers/spi/spi-tegra20-sflash.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-tegra20-sflash.c
@@ -339,7 +339,7 @@ static int tegra_sflash_transfer_one_mes
 	msg->actual_length = 0;
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		INIT_COMPLETION(tsd->xfer_completion);
+		reinit_completion(&tsd->xfer_completion);
 		ret = tegra_sflash_start_transfer_one(spi, xfer,
 					is_first_msg, single_xfer);
 		if (ret < 0) {
diff -puN drivers/spi/spi-tegra20-slink.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-tegra20-slink.c
--- a/drivers/spi/spi-tegra20-slink.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-tegra20-slink.c
@@ -462,7 +462,7 @@ static void tegra_slink_dma_complete(voi
 
 static int tegra_slink_start_tx_dma(struct tegra_slink_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->tx_dma_complete);
+	reinit_completion(&tspi->tx_dma_complete);
 	tspi->tx_dma_desc = dmaengine_prep_slave_single(tspi->tx_dma_chan,
 				tspi->tx_dma_phys, len, DMA_MEM_TO_DEV,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -481,7 +481,7 @@ static int tegra_slink_start_tx_dma(stru
 
 static int tegra_slink_start_rx_dma(struct tegra_slink_data *tspi, int len)
 {
-	INIT_COMPLETION(tspi->rx_dma_complete);
+	reinit_completion(&tspi->rx_dma_complete);
 	tspi->rx_dma_desc = dmaengine_prep_slave_single(tspi->rx_dma_chan,
 				tspi->rx_dma_phys, len, DMA_DEV_TO_MEM,
 				DMA_PREP_INTERRUPT |  DMA_CTRL_ACK);
@@ -839,7 +839,7 @@ static int tegra_slink_transfer_one_mess
 
 	single_xfer = list_is_singular(&msg->transfers);
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		INIT_COMPLETION(tspi->xfer_completion);
+		reinit_completion(&tspi->xfer_completion);
 		ret = tegra_slink_start_transfer_one(spi, xfer,
 					is_first_msg, single_xfer);
 		if (ret < 0) {
diff -puN drivers/spi/spi-xilinx.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/spi/spi-xilinx.c
--- a/drivers/spi/spi-xilinx.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/spi/spi-xilinx.c
@@ -258,7 +258,7 @@ static int xilinx_spi_txrx_bufs(struct s
 	xspi->tx_ptr = t->tx_buf;
 	xspi->rx_ptr = t->rx_buf;
 	xspi->remaining_bytes = t->len;
-	INIT_COMPLETION(xspi->done);
+	reinit_completion(&xspi->done);
 
 
 	/* Enable the transmit empty interrupt, which we use to determine
diff -puN drivers/staging/iio/adc/mxs-lradc.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/staging/iio/adc/mxs-lradc.c
--- a/drivers/staging/iio/adc/mxs-lradc.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/staging/iio/adc/mxs-lradc.c
@@ -255,7 +255,7 @@ static int mxs_lradc_read_raw(struct iio
 	if (!ret)
 		return -EBUSY;
 
-	INIT_COMPLETION(lradc->completion);
+	reinit_completion(&lradc->completion);
 
 	/*
 	 * No buffered operation in progress, map the channel and trigger it.
diff -puN drivers/staging/media/solo6x10/solo6x10-p2m.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/staging/media/solo6x10/solo6x10-p2m.c
--- a/drivers/staging/media/solo6x10/solo6x10-p2m.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/staging/media/solo6x10/solo6x10-p2m.c
@@ -87,7 +87,7 @@ int solo_p2m_dma_desc(struct solo_dev *s
 	if (mutex_lock_interruptible(&p2m_dev->mutex))
 		return -EINTR;
 
-	INIT_COMPLETION(p2m_dev->completion);
+	reinit_completion(&p2m_dev->completion);
 	p2m_dev->error = 0;
 
 	if (desc_cnt > 1 && solo_dev->type != SOLO_DEV_6110 && desc_mode) {
diff -puN drivers/staging/tidspbridge/core/sync.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/staging/tidspbridge/core/sync.c
--- a/drivers/staging/tidspbridge/core/sync.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/staging/tidspbridge/core/sync.c
@@ -72,7 +72,7 @@ int sync_wait_on_multiple_events(struct
 	spin_lock_bh(&sync_lock);
 	for (i = 0; i < count; i++) {
 		if (completion_done(&events[i]->comp)) {
-			INIT_COMPLETION(events[i]->comp);
+			reinit_completion(&events[i]->comp);
 			*index = i;
 			spin_unlock_bh(&sync_lock);
 			status = 0;
@@ -92,7 +92,7 @@ int sync_wait_on_multiple_events(struct
 	spin_lock_bh(&sync_lock);
 	for (i = 0; i < count; i++) {
 		if (completion_done(&events[i]->comp)) {
-			INIT_COMPLETION(events[i]->comp);
+			reinit_completion(&events[i]->comp);
 			*index = i;
 			status = 0;
 		}
diff -puN drivers/staging/tidspbridge/include/dspbridge/sync.h~tree-wide-use-reinit_completion-instead-of-init_completion drivers/staging/tidspbridge/include/dspbridge/sync.h
--- a/drivers/staging/tidspbridge/include/dspbridge/sync.h~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/staging/tidspbridge/include/dspbridge/sync.h
@@ -59,7 +59,7 @@ static inline void sync_init_event(struc
 
 static inline void sync_reset_event(struct sync_object *event)
 {
-	INIT_COMPLETION(event->comp);
+	reinit_completion(&event->comp);
 	event->multi_comp = NULL;
 }
 
diff -puN drivers/staging/tidspbridge/rmgr/drv_interface.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/staging/tidspbridge/rmgr/drv_interface.c
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -332,7 +332,7 @@ static void bridge_recover(struct work_s
 	struct dev_object *dev;
 	struct cfg_devnode *dev_node;
 	if (atomic_read(&bridge_cref)) {
-		INIT_COMPLETION(bridge_comp);
+		reinit_completion(&bridge_comp);
 		while (!wait_for_completion_timeout(&bridge_comp,
 						msecs_to_jiffies(REC_TIMEOUT)))
 			pr_info("%s:%d handle(s) still opened\n",
@@ -348,7 +348,7 @@ static void bridge_recover(struct work_s
 
 void bridge_recover_schedule(void)
 {
-	INIT_COMPLETION(bridge_open_comp);
+	reinit_completion(&bridge_open_comp);
 	recover = true;
 	queue_work(bridge_rec_queue, &bridge_recovery_work);
 }
@@ -389,7 +389,7 @@ static int omap3_bridge_startup(struct p
 #ifdef CONFIG_TIDSPBRIDGE_RECOVERY
 	bridge_rec_queue = create_workqueue("bridge_rec_queue");
 	INIT_WORK(&bridge_recovery_work, bridge_recover);
-	INIT_COMPLETION(bridge_comp);
+	reinit_completion(&bridge_comp);
 #endif
 
 #ifdef CONFIG_PM
diff -puN drivers/tty/metag_da.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/tty/metag_da.c
--- a/drivers/tty/metag_da.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/tty/metag_da.c
@@ -495,7 +495,7 @@ static int dashtty_write(struct tty_stru
 	count = dport->xmit_cnt;
 	/* xmit buffer no longer empty? */
 	if (count)
-		INIT_COMPLETION(dport->xmit_empty);
+		reinit_completion(&dport->xmit_empty);
 	mutex_unlock(&dport->xmit_lock);
 
 	if (total) {
diff -puN drivers/usb/c67x00/c67x00-sched.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/usb/c67x00/c67x00-sched.c
--- a/drivers/usb/c67x00/c67x00-sched.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/usb/c67x00/c67x00-sched.c
@@ -344,7 +344,7 @@ void c67x00_endpoint_disable(struct usb_
 		/* it could happen that we reinitialize this completion, while
 		 * somebody was waiting for that completion.  The timeout and
 		 * while loop handle such cases, but this might be improved */
-		INIT_COMPLETION(c67x00->endpoint_disable);
+		reinit_completion(&c67x00->endpoint_disable);
 		c67x00_sched_kick(c67x00);
 		wait_for_completion_timeout(&c67x00->endpoint_disable, 1 * HZ);
 
diff -puN drivers/usb/gadget/f_fs.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/usb/gadget/f_fs.c
--- a/drivers/usb/gadget/f_fs.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/usb/gadget/f_fs.c
@@ -373,7 +373,7 @@ static int __ffs_ep0_queue_wait(struct f
 	if (req->buf == NULL)
 		req->buf = (void *)0xDEADBABE;
 
-	INIT_COMPLETION(ffs->ep0req_completion);
+	reinit_completion(&ffs->ep0req_completion);
 
 	ret = usb_ep_queue(ffs->gadget->ep0, req, GFP_ATOMIC);
 	if (unlikely(ret < 0))
diff -puN drivers/usb/serial/mos7720.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/usb/serial/mos7720.c
--- a/drivers/usb/serial/mos7720.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/usb/serial/mos7720.c
@@ -455,7 +455,7 @@ static int parport_prologue(struct parpo
 		return -1;
 	}
 	mos_parport->msg_pending = true;   /* synch usb call pending */
-	INIT_COMPLETION(mos_parport->syncmsg_compl);
+	reinit_completion(&mos_parport->syncmsg_compl);
 	spin_unlock(&release_lock);
 
 	mutex_lock(&mos_parport->serial->disc_mutex);
diff -puN drivers/video/exynos/exynos_mipi_dsi_common.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/video/exynos/exynos_mipi_dsi_common.c
--- a/drivers/video/exynos/exynos_mipi_dsi_common.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/video/exynos/exynos_mipi_dsi_common.c
@@ -220,7 +220,7 @@ int exynos_mipi_dsi_wr_data(struct mipi_
 	case MIPI_DSI_DCS_LONG_WRITE:
 	{
 		unsigned int size, payload = 0;
-		INIT_COMPLETION(dsim_wr_comp);
+		reinit_completion(&dsim_wr_comp);
 
 		size = data_size * 4;
 
@@ -356,7 +356,7 @@ int exynos_mipi_dsi_rd_data(struct mipi_
 	msleep(20);
 
 	mutex_lock(&dsim->lock);
-	INIT_COMPLETION(dsim_rd_comp);
+	reinit_completion(&dsim_rd_comp);
 	exynos_mipi_dsi_rd_tx_header(dsim,
 		MIPI_DSI_SET_MAXIMUM_RETURN_PACKET_SIZE, req_size);
 
diff -puN drivers/video/omap2/displays-new/encoder-tpd12s015.c~tree-wide-use-reinit_completion-instead-of-init_completion drivers/video/omap2/displays-new/encoder-tpd12s015.c
--- a/drivers/video/omap2/displays-new/encoder-tpd12s015.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/drivers/video/omap2/displays-new/encoder-tpd12s015.c
@@ -69,7 +69,7 @@ static int tpd_connect(struct omap_dss_d
 	dst->src = dssdev;
 	dssdev->dst = dst;
 
-	INIT_COMPLETION(ddata->hpd_completion);
+	reinit_completion(&ddata->hpd_completion);
 
 	gpio_set_value_cansleep(ddata->ct_cp_hpd_gpio, 1);
 	/* DC-DC converter needs at max 300us to get to 90% of 5V */
diff -puN fs/ecryptfs/crypto.c~tree-wide-use-reinit_completion-instead-of-init_completion fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/fs/ecryptfs/crypto.c
@@ -392,7 +392,7 @@ static int crypt_scatterlist(struct ecry
 
 		wait_for_completion(&ecr->completion);
 		rc = ecr->rc;
-		INIT_COMPLETION(ecr->completion);
+		reinit_completion(&ecr->completion);
 	}
 out:
 	ablkcipher_request_free(req);
diff -puN fs/nfs/nfs4state.c~tree-wide-use-reinit_completion-instead-of-init_completion fs/nfs/nfs4state.c
--- a/fs/nfs/nfs4state.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/fs/nfs/nfs4state.c
@@ -246,7 +246,7 @@ static int nfs4_drain_slot_tbl(struct nf
 	set_bit(NFS4_SLOT_TBL_DRAINING, &tbl->slot_tbl_state);
 	spin_lock(&tbl->slot_tbl_lock);
 	if (tbl->highest_used_slotid != NFS4_NO_SLOT) {
-		INIT_COMPLETION(tbl->complete);
+		reinit_completion(&tbl->complete);
 		spin_unlock(&tbl->slot_tbl_lock);
 		return wait_for_completion_interruptible(&tbl->complete);
 	}
diff -puN fs/ocfs2/dlmglue.c~tree-wide-use-reinit_completion-instead-of-init_completion fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/fs/ocfs2/dlmglue.c
@@ -1304,7 +1304,7 @@ static int ocfs2_wait_for_mask(struct oc
 {
 	wait_for_completion(&mw->mw_complete);
 	/* Re-arm the completion in case we want to wait on it again */
-	INIT_COMPLETION(mw->mw_complete);
+	reinit_completion(&mw->mw_complete);
 	return mw->mw_status;
 }
 
@@ -1355,7 +1355,7 @@ static int ocfs2_wait_for_mask_interrupt
 	else
 		ret = mw->mw_status;
 	/* Re-arm the completion in case we want to wait on it again */
-	INIT_COMPLETION(mw->mw_complete);
+	reinit_completion(&mw->mw_complete);
 	return ret;
 }
 
diff -puN sound/soc/samsung/ac97.c~tree-wide-use-reinit_completion-instead-of-init_completion sound/soc/samsung/ac97.c
--- a/sound/soc/samsung/ac97.c~tree-wide-use-reinit_completion-instead-of-init_completion
+++ a/sound/soc/samsung/ac97.c
@@ -74,7 +74,7 @@ static void s3c_ac97_activate(struct snd
 	if (stat == S3C_AC97_GLBSTAT_MAINSTATE_ACTIVE)
 		return; /* Return if already active */
 
-	INIT_COMPLETION(s3c_ac97.done);
+	reinit_completion(&s3c_ac97.done);
 
 	ac_glbctrl = readl(s3c_ac97.regs + S3C_AC97_GLBCTRL);
 	ac_glbctrl = S3C_AC97_GLBCTRL_ACLINKON;
@@ -103,7 +103,7 @@ static unsigned short s3c_ac97_read(stru
 
 	s3c_ac97_activate(ac97);
 
-	INIT_COMPLETION(s3c_ac97.done);
+	reinit_completion(&s3c_ac97.done);
 
 	ac_codec_cmd = readl(s3c_ac97.regs + S3C_AC97_CODEC_CMD);
 	ac_codec_cmd = S3C_AC97_CODEC_CMD_READ | AC_CMD_ADDR(reg);
@@ -140,7 +140,7 @@ static void s3c_ac97_write(struct snd_ac
 
 	s3c_ac97_activate(ac97);
 
-	INIT_COMPLETION(s3c_ac97.done);
+	reinit_completion(&s3c_ac97.done);
 
 	ac_codec_cmd = readl(s3c_ac97.regs + S3C_AC97_CODEC_CMD);
 	ac_codec_cmd = AC_CMD_ADDR(reg) | AC_CMD_DATA(val);
_

Patches currently in -mm which might be from wsa@the-dreams.de are

sched-replace-init_completion-with-reinit_completion.patch
tree-wide-use-reinit_completion-instead-of-init_completion.patch
sched-remove-init_completion.patch

