From: akpm@linux-foundation.org
Subject: - sfc-remove-casts-to-void.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:05 -0700
Message-ID: <200805231859.m4NIx5mr004203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753356AbYEWS7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: remove casts to void
has been removed from the -mm tree.  Its filename was
     sfc-remove-casts-to-void.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: remove casts to void
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c         |    4 ++--
 drivers/net/sfc/falcon.c      |    2 +-
 drivers/net/sfc/falcon_xmac.c |    4 ++--
 drivers/net/sfc/sfe4001.c     |   14 +++++++-------
 drivers/net/sfc/tenxpress.c   |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-remove-casts-to-void drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-remove-casts-to-void
+++ a/drivers/net/sfc/efx.c
@@ -265,7 +265,7 @@ void efx_process_channel_now(struct efx_
 	napi_disable(&channel->napi_str);
 
 	/* Poll the channel */
-	(void) efx_process_channel(channel, efx->type->evq_size);
+	efx_process_channel(channel, efx->type->evq_size);
 
 	/* Ack the eventq. This may cause an interrupt to be generated
 	 * when they are reenabled */
@@ -1688,7 +1688,7 @@ static int efx_reset(struct efx_nic *efx
 	if (method == RESET_TYPE_DISABLE) {
 		/* Reinitialise the device anyway so the driver unload sequence
 		 * can talk to the external SRAM */
-		(void) falcon_init_nic(efx);
+		falcon_init_nic(efx);
 		rc = -EIO;
 		goto fail4;
 	}
diff -puN drivers/net/sfc/falcon.c~sfc-remove-casts-to-void drivers/net/sfc/falcon.c
--- a/drivers/net/sfc/falcon.c~sfc-remove-casts-to-void
+++ a/drivers/net/sfc/falcon.c
@@ -2647,7 +2647,7 @@ void falcon_remove_nic(struct efx_nic *e
 
 	falcon_free_buffer(efx, &efx->irq_status);
 
-	(void) falcon_reset_hw(efx, RESET_TYPE_ALL);
+	falcon_reset_hw(efx, RESET_TYPE_ALL);
 
 	/* Release the second function after the reset */
 	if (nic_data->pci_dev2) {
diff -puN drivers/net/sfc/falcon_xmac.c~sfc-remove-casts-to-void drivers/net/sfc/falcon_xmac.c
--- a/drivers/net/sfc/falcon_xmac.c~sfc-remove-casts-to-void
+++ a/drivers/net/sfc/falcon_xmac.c
@@ -454,7 +454,7 @@ static int falcon_check_xaui_link_up(str
 
 		EFX_LOG(efx, "%s Clobbering XAUI (%d tries left).\n",
 			__func__, tries);
-		(void) falcon_reset_xaui(efx);
+		falcon_reset_xaui(efx);
 		udelay(200);
 		tries--;
 	}
@@ -572,7 +572,7 @@ int falcon_check_xmac(struct efx_nic *ef
 	xaui_link_ok = falcon_xaui_link_ok(efx);
 
 	if (EFX_WORKAROUND_5147(efx) && !xaui_link_ok)
-		(void) falcon_reset_xaui(efx);
+		falcon_reset_xaui(efx);
 
 	/* Call the PHY check_hw routine */
 	rc = efx->phy_op->check_hw(efx);
diff -puN drivers/net/sfc/sfe4001.c~sfc-remove-casts-to-void drivers/net/sfc/sfe4001.c
--- a/drivers/net/sfc/sfe4001.c~sfc-remove-casts-to-void
+++ a/drivers/net/sfc/sfe4001.c
@@ -116,18 +116,18 @@ void sfe4001_poweroff(struct efx_nic *ef
 
 	/* Turn off all power rails */
 	out = 0xff;
-	(void) efx_i2c_write(i2c, PCA9539, P0_OUT, &out, 1);
+	efx_i2c_write(i2c, PCA9539, P0_OUT, &out, 1);
 
 	/* Disable port 1 outputs on IO expander */
 	cfg = 0xff;
-	(void) efx_i2c_write(i2c, PCA9539, P1_CONFIG, &cfg, 1);
+	efx_i2c_write(i2c, PCA9539, P1_CONFIG, &cfg, 1);
 
 	/* Disable port 0 outputs on IO expander */
 	cfg = 0xff;
-	(void) efx_i2c_write(i2c, PCA9539, P0_CONFIG, &cfg, 1);
+	efx_i2c_write(i2c, PCA9539, P0_CONFIG, &cfg, 1);
 
 	/* Clear any over-temperature alert */
-	(void) efx_i2c_read(i2c, MAX6647, RSL, &in, 1);
+	efx_i2c_read(i2c, MAX6647, RSL, &in, 1);
 }
 
 /* The P0_EN_3V3X line on SFE4001 boards (from A2 onward) is connected
@@ -253,14 +253,14 @@ done:
 fail3:
 	/* Turn off all power rails */
 	out = 0xff;
-	(void) efx_i2c_write(i2c, PCA9539, P0_OUT, &out, 1);
+	efx_i2c_write(i2c, PCA9539, P0_OUT, &out, 1);
 	/* Disable port 1 outputs on IO expander */
 	out = 0xff;
-	(void) efx_i2c_write(i2c, PCA9539, P1_CONFIG, &out, 1);
+	efx_i2c_write(i2c, PCA9539, P1_CONFIG, &out, 1);
 fail2:
 	/* Disable port 0 outputs on IO expander */
 	out = 0xff;
-	(void) efx_i2c_write(i2c, PCA9539, P0_CONFIG, &out, 1);
+	efx_i2c_write(i2c, PCA9539, P0_CONFIG, &out, 1);
 fail1:
 	return rc;
 }
diff -puN drivers/net/sfc/tenxpress.c~sfc-remove-casts-to-void drivers/net/sfc/tenxpress.c
--- a/drivers/net/sfc/tenxpress.c~sfc-remove-casts-to-void
+++ a/drivers/net/sfc/tenxpress.c
@@ -376,7 +376,7 @@ static void tenxpress_phy_reconfigure(st
 	 * perform a special software reset */
 	if ((phy_data->tx_disabled && !efx->tx_disabled) ||
 	    loop_change) {
-		(void) tenxpress_special_reset(efx);
+		tenxpress_special_reset(efx);
 		falcon_reset_xaui(efx);
 	}
 
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

