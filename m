From: akpm@linux-foundation.org
Subject: + mmc-add-mmc-card-sleep-and-awake-support.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:54:36 -0700
Message-ID: <200907242254.n6OMsaAR030985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036AbZGXWyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:54:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jarkko.lavinen@nokia.com, adrian.hunter@nokia.com, ext-denis.2.karpov@nokia.com, ian@mnementh.co.uk, matt@console-pimps.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     mmc: add mmc card sleep and awake support
has been added to the -mm tree.  Its filename is
     mmc-add-mmc-card-sleep-and-awake-support.patch

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
Subject: mmc: add mmc card sleep and awake support
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Add support for the new MMC command SLEEP_AWAKE.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c    |   40 +++++++++++++++++++++++++
 drivers/mmc/core/core.h    |    2 +
 drivers/mmc/core/mmc.c     |   54 +++++++++++++++++++++++++++++++----
 drivers/mmc/core/mmc_ops.c |   36 +++++++++++++++++++++++
 drivers/mmc/core/mmc_ops.h |    1 
 include/linux/mmc/card.h   |    2 +
 include/linux/mmc/host.h   |    5 +++
 include/linux/mmc/mmc.h    |    2 +
 8 files changed, 137 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/core/core.c~mmc-add-mmc-card-sleep-and-awake-support drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-add-mmc-card-sleep-and-awake-support
+++ a/drivers/mmc/core/core.c
@@ -1182,6 +1182,46 @@ void mmc_power_restore_host(struct mmc_h
 }
 EXPORT_SYMBOL(mmc_power_restore_host);
 
+int mmc_card_awake(struct mmc_host *host)
+{
+	int err = -ENOSYS;
+
+	mmc_bus_get(host);
+
+	if (host->bus_ops && !host->bus_dead && host->bus_ops->awake)
+		err = host->bus_ops->awake(host);
+
+	mmc_bus_put(host);
+
+	return err;
+}
+EXPORT_SYMBOL(mmc_card_awake);
+
+int mmc_card_sleep(struct mmc_host *host)
+{
+	int err = -ENOSYS;
+
+	mmc_bus_get(host);
+
+	if (host->bus_ops && !host->bus_dead && host->bus_ops->awake)
+		err = host->bus_ops->sleep(host);
+
+	mmc_bus_put(host);
+
+	return err;
+}
+EXPORT_SYMBOL(mmc_card_sleep);
+
+int mmc_card_can_sleep(struct mmc_host *host)
+{
+	struct mmc_card *card = host->card;
+
+	if (card && mmc_card_mmc(card) && card->ext_csd.rev >= 3)
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL(mmc_card_can_sleep);
+
 #ifdef CONFIG_PM
 
 /**
diff -puN drivers/mmc/core/core.h~mmc-add-mmc-card-sleep-and-awake-support drivers/mmc/core/core.h
--- a/drivers/mmc/core/core.h~mmc-add-mmc-card-sleep-and-awake-support
+++ a/drivers/mmc/core/core.h
@@ -16,6 +16,8 @@
 #define MMC_CMD_RETRIES        3
 
 struct mmc_bus_ops {
+	int (*awake)(struct mmc_host *);
+	int (*sleep)(struct mmc_host *);
 	void (*remove)(struct mmc_host *);
 	void (*detect)(struct mmc_host *);
 	void (*suspend)(struct mmc_host *);
diff -puN drivers/mmc/core/mmc.c~mmc-add-mmc-card-sleep-and-awake-support drivers/mmc/core/mmc.c
--- a/drivers/mmc/core/mmc.c~mmc-add-mmc-card-sleep-and-awake-support
+++ a/drivers/mmc/core/mmc.c
@@ -160,7 +160,6 @@ static int mmc_read_ext_csd(struct mmc_c
 {
 	int err;
 	u8 *ext_csd;
-	unsigned int ext_csd_struct;
 
 	BUG_ON(!card);
 
@@ -207,16 +206,16 @@ static int mmc_read_ext_csd(struct mmc_c
 		goto out;
 	}
 
-	ext_csd_struct = ext_csd[EXT_CSD_REV];
-	if (ext_csd_struct > 3) {
+	card->ext_csd.rev = ext_csd[EXT_CSD_REV];
+	if (card->ext_csd.rev > 3) {
 		printk(KERN_ERR "%s: unrecognised EXT_CSD structure "
 			"version %d\n", mmc_hostname(card->host),
-			ext_csd_struct);
+			card->ext_csd.rev);
 		err = -EINVAL;
 		goto out;
 	}
 
-	if (ext_csd_struct >= 2) {
+	if (card->ext_csd.rev >= 2) {
 		card->ext_csd.sectors =
 			ext_csd[EXT_CSD_SEC_CNT + 0] << 0 |
 			ext_csd[EXT_CSD_SEC_CNT + 1] << 8 |
@@ -241,6 +240,15 @@ static int mmc_read_ext_csd(struct mmc_c
 		goto out;
 	}
 
+	if (card->ext_csd.rev >= 3) {
+		u8 sa_shift = ext_csd[EXT_CSD_S_A_TIMEOUT];
+
+		/* Sleep / awake timeout in 100ns units */
+		if (sa_shift > 0 && sa_shift <= 0x17)
+			card->ext_csd.sa_timeout =
+					1 << ext_csd[EXT_CSD_S_A_TIMEOUT];
+	}
+
 out:
 	kfree(ext_csd);
 
@@ -557,9 +565,41 @@ static void mmc_power_restore(struct mmc
 	mmc_release_host(host);
 }
 
+static int mmc_sleep(struct mmc_host *host)
+{
+	struct mmc_card *card = host->card;
+	int err = -ENOSYS;
+
+	if (card && card->ext_csd.rev >= 3) {
+		err = mmc_card_sleepawake(host, 1);
+		if (err < 0)
+			pr_debug("%s: Error %d while putting card into sleep",
+				 mmc_hostname(host), err);
+	}
+
+	return err;
+}
+
+static int mmc_awake(struct mmc_host *host)
+{
+	struct mmc_card *card = host->card;
+	int err = -ENOSYS;
+
+	if (card && card->ext_csd.rev >= 3) {
+		err = mmc_card_sleepawake(host, 0);
+		if (err < 0)
+			pr_debug("%s: Error %d while awaking sleeping card",
+				 mmc_hostname(host), err);
+	}
+
+	return err;
+}
+
 #ifdef CONFIG_MMC_UNSAFE_RESUME
 
 static const struct mmc_bus_ops mmc_ops = {
+	.awake = mmc_awake,
+	.sleep = mmc_sleep,
 	.remove = mmc_remove,
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
@@ -575,6 +615,8 @@ static void mmc_attach_bus_ops(struct mm
 #else
 
 static const struct mmc_bus_ops mmc_ops = {
+	.awake = mmc_awake,
+	.sleep = mmc_sleep,
 	.remove = mmc_remove,
 	.detect = mmc_detect,
 	.suspend = NULL,
@@ -583,6 +625,8 @@ static const struct mmc_bus_ops mmc_ops 
 };
 
 static const struct mmc_bus_ops mmc_ops_unsafe = {
+	.awake = mmc_awake,
+	.sleep = mmc_sleep,
 	.remove = mmc_remove,
 	.detect = mmc_detect,
 	.suspend = mmc_suspend,
diff -puN drivers/mmc/core/mmc_ops.c~mmc-add-mmc-card-sleep-and-awake-support drivers/mmc/core/mmc_ops.c
--- a/drivers/mmc/core/mmc_ops.c~mmc-add-mmc-card-sleep-and-awake-support
+++ a/drivers/mmc/core/mmc_ops.c
@@ -57,6 +57,42 @@ int mmc_deselect_cards(struct mmc_host *
 	return _mmc_select_card(host, NULL);
 }
 
+int mmc_card_sleepawake(struct mmc_host *host, int sleep)
+{
+	struct mmc_command cmd;
+	struct mmc_card *card = host->card;
+	int err;
+
+	if (sleep)
+		mmc_deselect_cards(host);
+
+	memset(&cmd, 0, sizeof(struct mmc_command));
+
+	cmd.opcode = MMC_SLEEP_AWAKE;
+	cmd.arg = card->rca << 16;
+	if (sleep)
+		cmd.arg |= 1 << 15;
+
+	cmd.flags = MMC_RSP_R1B | MMC_CMD_AC;
+	err = mmc_wait_for_cmd(host, &cmd, 0);
+	if (err)
+		return err;
+
+	/*
+	 * If the host does not wait while the card signals busy, then we will
+	 * will have to wait the sleep/awake timeout.  Note, we cannot use the
+	 * SEND_STATUS command to poll the status because that command (and most
+	 * others) is invalid while the card sleeps.
+	 */
+	if (!(host->caps & MMC_CAP_WAIT_WHILE_BUSY))
+		mmc_delay(DIV_ROUND_UP(card->ext_csd.sa_timeout, 10000));
+
+	if (!sleep)
+		err = mmc_select_card(card);
+
+	return err;
+}
+
 int mmc_go_idle(struct mmc_host *host)
 {
 	int err;
diff -puN drivers/mmc/core/mmc_ops.h~mmc-add-mmc-card-sleep-and-awake-support drivers/mmc/core/mmc_ops.h
--- a/drivers/mmc/core/mmc_ops.h~mmc-add-mmc-card-sleep-and-awake-support
+++ a/drivers/mmc/core/mmc_ops.h
@@ -25,6 +25,7 @@ int mmc_send_status(struct mmc_card *car
 int mmc_send_cid(struct mmc_host *host, u32 *cid);
 int mmc_spi_read_ocr(struct mmc_host *host, int highcap, u32 *ocrp);
 int mmc_spi_set_crc(struct mmc_host *host, int use_crc);
+int mmc_card_sleepawake(struct mmc_host *host, int sleep);
 
 #endif
 
diff -puN include/linux/mmc/card.h~mmc-add-mmc-card-sleep-and-awake-support include/linux/mmc/card.h
--- a/include/linux/mmc/card.h~mmc-add-mmc-card-sleep-and-awake-support
+++ a/include/linux/mmc/card.h
@@ -40,6 +40,8 @@ struct mmc_csd {
 };
 
 struct mmc_ext_csd {
+	u8			rev;
+	unsigned int		sa_timeout;		/* Units: 100ns */
 	unsigned int		hs_max_dtr;
 	unsigned int		sectors;
 };
diff -puN include/linux/mmc/host.h~mmc-add-mmc-card-sleep-and-awake-support include/linux/mmc/host.h
--- a/include/linux/mmc/host.h~mmc-add-mmc-card-sleep-and-awake-support
+++ a/include/linux/mmc/host.h
@@ -149,6 +149,7 @@ struct mmc_host {
 #define MMC_CAP_8_BIT_DATA	(1 << 6)	/* Can the host do 8 bit transfers */
 #define MMC_CAP_DISABLE		(1 << 7)	/* Can the host be disabled */
 #define MMC_CAP_NONREMOVABLE	(1 << 8)	/* Nonremovable e.g. eMMC */
+#define MMC_CAP_WAIT_WHILE_BUSY	(1 << 9)	/* Waits while card is busy */
 
 	/* host specific block data */
 	unsigned int		max_seg_size;	/* see blk_queue_max_segment_size */
@@ -240,6 +241,10 @@ struct regulator;
 int mmc_regulator_get_ocrmask(struct regulator *supply);
 int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
 
+int mmc_card_awake(struct mmc_host *host);
+int mmc_card_sleep(struct mmc_host *host);
+int mmc_card_can_sleep(struct mmc_host *host);
+
 int mmc_host_enable(struct mmc_host *host);
 int mmc_host_disable(struct mmc_host *host);
 int mmc_host_lazy_disable(struct mmc_host *host);
diff -puN include/linux/mmc/mmc.h~mmc-add-mmc-card-sleep-and-awake-support include/linux/mmc/mmc.h
--- a/include/linux/mmc/mmc.h~mmc-add-mmc-card-sleep-and-awake-support
+++ a/include/linux/mmc/mmc.h
@@ -31,6 +31,7 @@
 #define MMC_ALL_SEND_CID          2   /* bcr                     R2  */
 #define MMC_SET_RELATIVE_ADDR     3   /* ac   [31:16] RCA        R1  */
 #define MMC_SET_DSR               4   /* bc   [31:16] RCA            */
+#define MMC_SLEEP_AWAKE		  5   /* ac   [31:16] RCA 15:flg R1b */
 #define MMC_SWITCH                6   /* ac   [31:0] See below   R1b */
 #define MMC_SELECT_CARD           7   /* ac   [31:16] RCA        R1  */
 #define MMC_SEND_EXT_CSD          8   /* adtc                    R1  */
@@ -254,6 +255,7 @@ struct _mmc_csd {
 #define EXT_CSD_CARD_TYPE	196	/* RO */
 #define EXT_CSD_REV		192	/* RO */
 #define EXT_CSD_SEC_CNT		212	/* RO, 4 bytes */
+#define EXT_CSD_S_A_TIMEOUT	217
 
 /*
  * EXT_CSD field definitions
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch
mmc-check-status-after-mmc-switch-command.patch
omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

