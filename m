From: akpm@linux-foundation.org
Subject: + spi_bfin-remove-useless-fault-path.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:26:55 -0800
Message-ID: <200801312126.m0VLQteP012141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57270 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbYAaV1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@analog.com, dbrownell@users.sourceforge.net, michael.hennerich@analog.com


The patch titled
     spi_bfin: remove useless fault path
has been added to the -mm tree.  Its filename is
     spi_bfin-remove-useless-fault-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_bfin: remove useless fault path
From: Bryan Wu <bryan.wu@analog.com>

Remove useless return status check in restore_state function.  Issue was
pointed out by Michael.

Cc: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi_bfin-remove-useless-fault-path drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi_bfin-remove-useless-fault-path
+++ a/drivers/spi/spi_bfin5xx.c
@@ -223,10 +223,9 @@ static void cs_deactive(struct driver_da
 #define MAX_SPI_SSEL	7
 
 /* stop controller and re-config current chip*/
-static int restore_state(struct driver_data *drv_data)
+static void restore_state(struct driver_data *drv_data)
 {
 	struct chip_data *chip = drv_data->cur_chip;
-	int ret = 0;
 
 	/* Clear status and disable clock */
 	write_STAT(drv_data, BIT_STAT_CLR);
@@ -239,13 +238,6 @@ static int restore_state(struct driver_d
 
 	bfin_spi_enable(drv_data);
 	cs_active(drv_data, chip);
-
-	if (ret)
-		dev_dbg(&drv_data->pdev->dev,
-			": request chip select number %d failed\n",
-			chip->chip_select_num);
-
-	return ret;
 }
 
 /* used to kick off transfer in rx mode */
@@ -978,10 +970,7 @@ static void pump_messages(struct work_st
 
 	/* Setup the SSP using the per chip configuration */
 	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
-	if (restore_state(drv_data)) {
-		spin_unlock_irqrestore(&drv_data->lock, flags);
-		return;
-	};
+	restore_state(drv_data);
 
 	list_del_init(&drv_data->cur_msg->queue);
 
_

Patches currently in -mm which might be from bryan.wu@analog.com are

origin.patch
git-mtd.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart.patch
kernel-printkc-concerns-about-the-console-handover.patch
remove-mm_ptovvtop.patch
spi_bfin-remove-useless-fault-path.patch
spi_bfin-use-more-useful-gpio-labels.patch
spi_bfin-wait-for-tx-to-complete-on-some-cs_chg-paths.patch
spi_bfin-wait-for-tx-to-complete-on-full-duplex-paths.patch
spi_bfin-wait-for-tx-to-complete-on-write-paths.patch
spi_bfin-headers-are-not-for-changelogs.patch
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
procfs-constify-function-pointer-tables.patch
