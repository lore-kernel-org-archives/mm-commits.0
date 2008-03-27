From: akpm@linux-foundation.org
Subject: - mmc-omap-power-functions-modified-to-mmc-multislot-support.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:17:47 -0700
Message-ID: <200803270317.m2R3HlsA015177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755739AbYC0DSE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:18:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juha.yrjola@solidboot.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: power functions modified to MMC multislot support
has been removed from the -mm tree.  Its filename was
     mmc-omap-power-functions-modified-to-mmc-multislot-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: power functions modified to MMC multislot support
From: Juha Yrjola <juha.yrjola@solidboot.com>

Modifications at power functions to MMC multislot support.  This patch also
move board-specific code out of MMC OMAP driver.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   88 +++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 51 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-power-functions-modified-to-mmc-multislot-support drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-power-functions-modified-to-mmc-multislot-support
+++ a/drivers/mmc/host/omap.c
@@ -983,52 +983,27 @@ static void mmc_omap_request(struct mmc_
 	mmc_omap_start_request(host, req);
 }
 
-static void innovator_fpga_socket_power(int on)
+static void mmc_omap_set_power(struct mmc_omap_slot *slot, int power_on,
+				int vdd)
 {
-#if defined(CONFIG_MACH_OMAP_INNOVATOR) && defined(CONFIG_ARCH_OMAP15XX)
-	if (on) {
-		fpga_write(fpga_read(OMAP1510_FPGA_POWER) | (1 << 3),
-		     OMAP1510_FPGA_POWER);
-	} else {
-		fpga_write(fpga_read(OMAP1510_FPGA_POWER) & ~(1 << 3),
-		     OMAP1510_FPGA_POWER);
-	}
-#endif
-}
+	struct mmc_omap_host *host;
+
+	host = slot->host;
+
+	if (slot->pdata->set_power != NULL)
+		slot->pdata->set_power(mmc_dev(slot->mmc), slot->id, power_on,
+					vdd);
+
+	if (cpu_is_omap24xx()) {
+		u16 w;
 
-/*
- * Turn the socket power on/off. Innovator uses FPGA, most boards
- * probably use GPIO.
- */
-static void mmc_omap_power(struct mmc_omap_host *host, int on)
-{
-	if (on) {
-		if (machine_is_omap_innovator())
-			innovator_fpga_socket_power(1);
-		else if (machine_is_omap_h2())
-			tps65010_set_gpio_out_value(GPIO3, HIGH);
-		else if (machine_is_omap_h3())
-			/* GPIO 4 of TPS65010 sends SD_EN signal */
-			tps65010_set_gpio_out_value(GPIO4, HIGH);
-		else if (cpu_is_omap24xx()) {
-			u16 reg = OMAP_MMC_READ(host, CON);
-			OMAP_MMC_WRITE(host, CON, reg | (1 << 11));
-		} else
-			if (host->power_pin >= 0)
-				omap_set_gpio_dataout(host->power_pin, 1);
-	} else {
-		if (machine_is_omap_innovator())
-			innovator_fpga_socket_power(0);
-		else if (machine_is_omap_h2())
-			tps65010_set_gpio_out_value(GPIO3, LOW);
-		else if (machine_is_omap_h3())
-			tps65010_set_gpio_out_value(GPIO4, LOW);
-		else if (cpu_is_omap24xx()) {
-			u16 reg = OMAP_MMC_READ(host, CON);
-			OMAP_MMC_WRITE(host, CON, reg & ~(1 << 11));
-		} else
-			if (host->power_pin >= 0)
-				omap_set_gpio_dataout(host->power_pin, 0);
+		if (power_on) {
+			w = OMAP_MMC_READ(host, CON);
+			OMAP_MMC_WRITE(host, CON, w | (1 << 11));
+		} else {
+			w = OMAP_MMC_READ(host, CON);
+			OMAP_MMC_WRITE(host, CON, w & ~(1 << 11));
+		}
 	}
 }
 
@@ -1067,23 +1042,31 @@ static void mmc_omap_set_ios(struct mmc_
 	int i, dsor;
 
 	dsor = mmc_omap_calc_divisor(mmc, ios);
-	host->bus_mode = ios->bus_mode;
-	host->hw_bus_mode = host->bus_mode;
+
+	mmc_omap_select_slot(slot, 0);
+
+	if (ios->vdd != slot->vdd)
+		slot->vdd = ios->vdd;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
-		mmc_omap_power(host, 0);
+		mmc_omap_set_power(slot, 0, ios->vdd);
 		break;
 	case MMC_POWER_UP:
 		/* Cannot touch dsor yet, just power up MMC */
-		mmc_omap_power(host, 1);
-		return;
+		mmc_omap_set_power(slot, 1, ios->vdd);
+		goto exit;
 	case MMC_POWER_ON:
 		dsor |= 1 << 11;
 		break;
 	}
 
-	clk_enable(host->fclk);
+	if (slot->bus_mode != ios->bus_mode) {
+		if (slot->pdata->set_bus_mode != NULL)
+			slot->pdata->set_bus_mode(mmc_dev(mmc), slot->id,
+						  ios->bus_mode);
+		slot->bus_mode = ios->bus_mode;
+	}
 
 	/* On insanely high arm_per frequencies something sometimes
 	 * goes somehow out of sync, and the POW bit is not being set,
@@ -1091,6 +1074,7 @@ static void mmc_omap_set_ios(struct mmc_
 	 * Writing to the CON register twice seems to do the trick. */
 	for (i = 0; i < 2; i++)
 		OMAP_MMC_WRITE(host, CON, dsor);
+	slot->saved_con = dsor;
 	if (ios->power_mode == MMC_POWER_ON) {
 		/* Send clock cycles, poll completion */
 		OMAP_MMC_WRITE(host, IE, 0);
@@ -1099,7 +1083,9 @@ static void mmc_omap_set_ios(struct mmc_
 		while ((OMAP_MMC_READ(host, STAT) & 1) == 0);
 		OMAP_MMC_WRITE(host, STAT, 1);
 	}
-	clk_disable(host->fclk);
+
+exit:
+	mmc_omap_release_slot(slot);
 }
 
 static int mmc_omap_get_ro(struct mmc_host *mmc)
_

Patches currently in -mm which might be from juha.yrjola@solidboot.com are

mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch

