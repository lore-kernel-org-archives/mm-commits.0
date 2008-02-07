From: akpm@linux-foundation.org
Subject: - spi_bfin-remove-useless-fault-path.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:25:59 -0800
Message-ID: <200802070025.m170PeTk006737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933552AbYBGAp2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bryan.wu@analog.com, dbrownell@users.sourceforge.net, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     spi_bfin: remove useless fault path
has been removed from the -mm tree.  Its filename was
     spi_bfin-remove-useless-fault-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-watchdog.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
procfs-constify-function-pointer-tables.patch
