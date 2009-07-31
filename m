From: akpm@linux-foundation.org
Subject: [withdrawn] spi-merge-probe-and-probe_id-callbacks.patch removed from -mm tree
Date: Fri, 31 Jul 2009 13:52:47 -0700
Message-ID: <200907312052.n6VKqlRu005307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbZGaUyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Jul 2009 16:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.


The patch titled
     spi: merge probe and probe_id callbacks
has been removed from the -mm tree.  Its filename was
     spi-merge-probe-and-probe_id-callbacks.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: merge probe and probe_id callbacks
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The probe_id callback was introduced for the transition period as a
"new-style" probe hook.  This patch makes probe() look exactly as
probe_id(), converts drivers and removes probe_id().

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c                    |    3 ++-
 drivers/gpio/mcp23s08.c                   |    3 ++-
 drivers/hwmon/adcxx.c                     |   12 ++++++++----
 drivers/hwmon/lis3lv02d_spi.c             |    3 ++-
 drivers/hwmon/lm70.c                      |    6 ++++--
 drivers/hwmon/max1111.c                   |    3 ++-
 drivers/input/touchscreen/ad7877.c        |    3 ++-
 drivers/input/touchscreen/ad7879.c        |    3 ++-
 drivers/input/touchscreen/ads7846.c       |    3 ++-
 drivers/leds/leds-dac124s085.c            |    3 ++-
 drivers/mfd/ezx-pcap.c                    |    3 ++-
 drivers/misc/eeprom/at25.c                |    2 +-
 drivers/mmc/host/mmc_spi.c                |    3 ++-
 drivers/mtd/devices/m25p80.c              |    2 +-
 drivers/mtd/devices/mtd_dataflash.c       |    3 ++-
 drivers/net/enc28j60.c                    |    3 ++-
 drivers/net/ks8851.c                      |    3 ++-
 drivers/net/wireless/libertas/if_spi.c    |    3 ++-
 drivers/net/wireless/p54/p54spi.c         |    3 ++-
 drivers/net/wireless/wl12xx/wl1251_main.c |    3 ++-
 drivers/rtc/rtc-ds1305.c                  |    3 ++-
 drivers/rtc/rtc-ds1390.c                  |    3 ++-
 drivers/rtc/rtc-ds3234.c                  |    3 ++-
 drivers/rtc/rtc-m41t94.c                  |    3 ++-
 drivers/rtc/rtc-max6902.c                 |    3 ++-
 drivers/rtc/rtc-r9701.c                   |    3 ++-
 drivers/rtc/rtc-rs5c348.c                 |    3 ++-
 drivers/serial/max3100.c                  |    3 ++-
 drivers/spi/spi.c                         |   15 +++------------
 drivers/spi/spidev.c                      |    2 +-
 drivers/spi/tle62x0.c                     |    3 ++-
 drivers/staging/stlc45xx/stlc45xx.c       |    3 ++-
 drivers/video/backlight/corgi_lcd.c       |    3 ++-
 drivers/video/backlight/ltv350qv.c        |    3 ++-
 drivers/video/backlight/tdo24m.c          |    3 ++-
 drivers/video/backlight/tosa_lcd.c        |    3 ++-
 drivers/video/backlight/vgg2432a4.c       |    3 ++-
 include/linux/spi/spi.h                   |    6 ++----
 38 files changed, 82 insertions(+), 56 deletions(-)

diff -puN drivers/gpio/max7301.c~spi-merge-probe-and-probe_id-callbacks drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/gpio/max7301.c
@@ -210,7 +210,8 @@ static void max7301_set(struct gpio_chip
 	mutex_unlock(&ts->lock);
 }
 
-static int __devinit max7301_probe(struct spi_device *spi)
+static int __devinit max7301_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct max7301 *ts;
 	struct max7301_platform_data *pdata;
diff -puN drivers/gpio/mcp23s08.c~spi-merge-probe-and-probe_id-callbacks drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/gpio/mcp23s08.c
@@ -300,7 +300,8 @@ fail:
 	return status;
 }
 
-static int mcp23s08_probe(struct spi_device *spi)
+static int mcp23s08_probe(struct spi_device *spi,
+			  const struct spi_device_id *id)
 {
 	struct mcp23s08_platform_data	*pdata;
 	unsigned			addr;
diff -puN drivers/hwmon/adcxx.c~spi-merge-probe-and-probe_id-callbacks drivers/hwmon/adcxx.c
--- a/drivers/hwmon/adcxx.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/hwmon/adcxx.c
@@ -204,22 +204,26 @@ out_err:
 	return status;
 }
 
-static int __devinit adcxx1s_probe(struct spi_device *spi)
+static int __devinit adcxx1s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 1);
 }
 
-static int __devinit adcxx2s_probe(struct spi_device *spi)
+static int __devinit adcxx2s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 2);
 }
 
-static int __devinit adcxx4s_probe(struct spi_device *spi)
+static int __devinit adcxx4s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 4);
 }
 
-static int __devinit adcxx8s_probe(struct spi_device *spi)
+static int __devinit adcxx8s_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	return adcxx_probe(spi, 8);
 }
diff -puN drivers/hwmon/lis3lv02d_spi.c~spi-merge-probe-and-probe_id-callbacks drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -56,7 +56,8 @@ static int lis3_spi_init(struct lis3lv02
 
 static struct axis_conversion lis3lv02d_axis_normal = { 1, 2, 3 };
 
-static int __devinit lis302dl_spi_probe(struct spi_device *spi)
+static int __devinit lis302dl_spi_probe(struct spi_device *spi,
+					const struct spi_device_id *id)
 {
 	int ret;
 
diff -puN drivers/hwmon/lm70.c~spi-merge-probe-and-probe_id-callbacks drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/hwmon/lm70.c
@@ -170,7 +170,8 @@ out_dev_reg_failed:
 	return status;
 }
 
-static int __devinit lm70_probe(struct spi_device *spi)
+static int __devinit lm70_probe(struct spi_device *spi,
+				const struct spi_device_id *id)
 {
 	/* signaling is SPI_MODE_0 on a 3-wire link (shared SI/SO) */
 	if ((spi->mode & (SPI_CPOL | SPI_CPHA)) || !(spi->mode & SPI_3WIRE))
@@ -179,7 +180,8 @@ static int __devinit lm70_probe(struct s
 	return common_probe(spi, LM70_CHIP_LM70);
 }
 
-static int __devinit tmp121_probe(struct spi_device *spi)
+static int __devinit tmp121_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	/* signaling is SPI_MODE_0 with only MISO connected */
 	if (spi->mode & (SPI_CPOL | SPI_CPHA))
diff -puN drivers/hwmon/max1111.c~spi-merge-probe-and-probe_id-callbacks drivers/hwmon/max1111.c
--- a/drivers/hwmon/max1111.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/hwmon/max1111.c
@@ -154,7 +154,8 @@ static int setup_transfer(struct max1111
 	return 0;
 }
 
-static int __devinit max1111_probe(struct spi_device *spi)
+static int __devinit max1111_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct max1111_data *data;
 	int err;
diff -puN drivers/input/touchscreen/ad7877.c~spi-merge-probe-and-probe_id-callbacks drivers/input/touchscreen/ad7877.c
--- a/drivers/input/touchscreen/ad7877.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/input/touchscreen/ad7877.c
@@ -646,7 +646,8 @@ static void ad7877_setup_ts_def_msg(stru
 	}
 }
 
-static int __devinit ad7877_probe(struct spi_device *spi)
+static int __devinit ad7877_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct ad7877			*ts;
 	struct input_dev		*input_dev;
diff -puN drivers/input/touchscreen/ad7879.c~spi-merge-probe-and-probe_id-callbacks drivers/input/touchscreen/ad7879.c
--- a/drivers/input/touchscreen/ad7879.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/input/touchscreen/ad7879.c
@@ -618,7 +618,8 @@ static void ad7879_setup_ts_def_msg(stru
 	}
 }
 
-static int __devinit ad7879_probe(struct spi_device *spi)
+static int __devinit ad7879_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct ad7879 *ts;
 	int error;
diff -puN drivers/input/touchscreen/ads7846.c~spi-merge-probe-and-probe_id-callbacks drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/input/touchscreen/ads7846.c
@@ -872,7 +872,8 @@ static int __devinit setup_pendown(struc
 	return 0;
 }
 
-static int __devinit ads7846_probe(struct spi_device *spi)
+static int __devinit ads7846_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct ads7846			*ts;
 	struct ads7846_packet		*packet;
diff -puN drivers/leds/leds-dac124s085.c~spi-merge-probe-and-probe_id-callbacks drivers/leds/leds-dac124s085.c
--- a/drivers/leds/leds-dac124s085.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/leds/leds-dac124s085.c
@@ -64,7 +64,8 @@ static void dac124s085_set_brightness(st
 	spin_unlock(&led->lock);
 }
 
-static int dac124s085_probe(struct spi_device *spi)
+static int dac124s085_probe(struct spi_device *spi,
+			    const struct spi_device_id *id)
 {
 	struct dac124s085	*dac;
 	struct dac124s085_led	*led;
diff -puN drivers/mfd/ezx-pcap.c~spi-merge-probe-and-probe_id-callbacks drivers/mfd/ezx-pcap.c
--- a/drivers/mfd/ezx-pcap.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/mfd/ezx-pcap.c
@@ -421,7 +421,8 @@ static int __devexit ezx_pcap_remove(str
 	return 0;
 }
 
-static int __devinit ezx_pcap_probe(struct spi_device *spi)
+static int __devinit ezx_pcap_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct pcap_platform_data *pdata = spi->dev.platform_data;
 	struct pcap_chip *pcap;
diff -puN drivers/misc/eeprom/at25.c~spi-merge-probe-and-probe_id-callbacks drivers/misc/eeprom/at25.c
--- a/drivers/misc/eeprom/at25.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/misc/eeprom/at25.c
@@ -287,7 +287,7 @@ static ssize_t at25_mem_write(struct mem
 
 /*-------------------------------------------------------------------------*/
 
-static int at25_probe(struct spi_device *spi)
+static int at25_probe(struct spi_device *spi, const struct spi_device_id *id)
 {
 	struct at25_data	*at25 = NULL;
 	const struct spi_eeprom *chip;
diff -puN drivers/mmc/host/mmc_spi.c~spi-merge-probe-and-probe_id-callbacks drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/mmc/host/mmc_spi.c
@@ -1306,7 +1306,8 @@ static int maybe_count_child(struct devi
 	return 0;
 }
 
-static int mmc_spi_probe(struct spi_device *spi)
+static int mmc_spi_probe(struct spi_device *spi,
+			 const struct spi_device_id *id)
 {
 	void			*ones;
 	struct mmc_host		*mmc;
diff -puN drivers/mtd/devices/m25p80.c~spi-merge-probe-and-probe_id-callbacks drivers/mtd/devices/m25p80.c
--- a/drivers/mtd/devices/m25p80.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/mtd/devices/m25p80.c
@@ -782,7 +782,7 @@ static struct spi_driver m25p80_driver =
 		.owner	= THIS_MODULE,
 	},
 	.id_table	= m25p_ids,
-	.probe_id	= m25p_probe,
+	.probe		= m25p_probe,
 	.remove	= __devexit_p(m25p_remove),
 
 	/* REVISIT: many of these chips have deep power-down modes, which
diff -puN drivers/mtd/devices/mtd_dataflash.c~spi-merge-probe-and-probe_id-callbacks drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -847,7 +847,8 @@ static struct flash_info *__devinit jede
  *   AT45DB0642  64Mbit  (8M)    xx111xxx (0x3c)   8192   1056     11
  *   AT45DB1282  128Mbit (16M)   xx0100xx (0x10)  16384   1056     11
  */
-static int __devinit dataflash_probe(struct spi_device *spi)
+static int __devinit dataflash_probe(struct spi_device *spi,
+				     const struct spi_device_id *id)
 {
 	int status;
 	struct flash_info	*info;
diff -puN drivers/net/enc28j60.c~spi-merge-probe-and-probe_id-callbacks drivers/net/enc28j60.c
--- a/drivers/net/enc28j60.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/net/enc28j60.c
@@ -1542,7 +1542,8 @@ static const struct net_device_ops enc28
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
-static int __devinit enc28j60_probe(struct spi_device *spi)
+static int __devinit enc28j60_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct net_device *dev;
 	struct enc28j60_net *priv;
diff -puN drivers/net/ks8851.c~spi-merge-probe-and-probe_id-callbacks drivers/net/ks8851.c
--- a/drivers/net/ks8851.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/net/ks8851.c
@@ -1176,7 +1176,8 @@ static int ks8851_read_selftest(struct k
 
 /* driver bus management functions */
 
-static int __devinit ks8851_probe(struct spi_device *spi)
+static int __devinit ks8851_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct net_device *ndev;
 	struct ks8851_net *ks;
diff -puN drivers/net/wireless/libertas/if_spi.c~spi-merge-probe-and-probe_id-callbacks drivers/net/wireless/libertas/if_spi.c
--- a/drivers/net/wireless/libertas/if_spi.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/net/wireless/libertas/if_spi.c
@@ -1027,7 +1027,8 @@ static int if_spi_calculate_fw_names(u16
 	return 0;
 }
 
-static int __devinit if_spi_probe(struct spi_device *spi)
+static int __devinit if_spi_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct if_spi_card *card;
 	struct lbs_private *priv = NULL;
diff -puN drivers/net/wireless/p54/p54spi.c~spi-merge-probe-and-probe_id-callbacks drivers/net/wireless/p54/p54spi.c
--- a/drivers/net/wireless/p54/p54spi.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/net/wireless/p54/p54spi.c
@@ -592,7 +592,8 @@ static void p54spi_op_stop(struct ieee80
 	mutex_unlock(&priv->mutex);
 }
 
-static int __devinit p54spi_probe(struct spi_device *spi)
+static int __devinit p54spi_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct p54s_priv *priv = NULL;
 	struct ieee80211_hw *hw;
diff -puN drivers/net/wireless/wl12xx/wl1251_main.c~spi-merge-probe-and-probe_id-callbacks drivers/net/wireless/wl12xx/wl1251_main.c
--- a/drivers/net/wireless/wl12xx/wl1251_main.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1190,7 +1190,8 @@ static int wl1251_init_ieee80211(struct 
 }
 
 #define WL1251_DEFAULT_CHANNEL 1
-static int __devinit wl1251_probe(struct spi_device *spi)
+static int __devinit wl1251_probe(struct spi_device *spi,
+				const struct spi_device_id *id)
 {
 	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
diff -puN drivers/rtc/rtc-ds1305.c~spi-merge-probe-and-probe_id-callbacks drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/rtc/rtc-ds1305.c
@@ -614,7 +614,8 @@ static struct bin_attribute nvram = {
  * Interface to SPI stack
  */
 
-static int __devinit ds1305_probe(struct spi_device *spi)
+static int __devinit ds1305_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct ds1305			*ds1305;
 	struct rtc_device		*rtc;
diff -puN drivers/rtc/rtc-ds1390.c~spi-merge-probe-and-probe_id-callbacks drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/rtc/rtc-ds1390.c
@@ -120,7 +120,8 @@ static const struct rtc_class_ops ds1390
 	.set_time	= ds1390_set_time,
 };
 
-static int __devinit ds1390_probe(struct spi_device *spi)
+static int __devinit ds1390_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	unsigned char tmp;
 	struct ds1390 *chip;
diff -puN drivers/rtc/rtc-ds3234.c~spi-merge-probe-and-probe_id-callbacks drivers/rtc/rtc-ds3234.c
--- a/drivers/rtc/rtc-ds3234.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/rtc/rtc-ds3234.c
@@ -105,7 +105,8 @@ static const struct rtc_class_ops ds3234
 	.set_time	= ds3234_set_time,
 };
 
-static int __devinit ds3234_probe(struct spi_device *spi)
+static int __devinit ds3234_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
diff -puN drivers/rtc/rtc-m41t94.c~spi-merge-probe-and-probe_id-callbacks drivers/rtc/rtc-m41t94.c
--- a/drivers/rtc/rtc-m41t94.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/rtc/rtc-m41t94.c
@@ -110,7 +110,8 @@ static const struct rtc_class_ops m41t94
 
 static struct spi_driver m41t94_driver;
 
-static int __devinit m41t94_probe(struct spi_device *spi)
+static int __devinit m41t94_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	int res;
diff -puN drivers/rtc/rtc-max6902.c~spi-merge-probe-and-probe_id-callbacks drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/rtc/rtc-max6902.c
@@ -120,7 +120,8 @@ static const struct rtc_class_ops max690
 	.set_time	= max6902_set_time,
 };
 
-static int __devinit max6902_probe(struct spi_device *spi)
+static int __devinit max6902_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
diff -puN drivers/rtc/rtc-r9701.c~spi-merge-probe-and-probe_id-callbacks drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/rtc/rtc-r9701.c
@@ -119,7 +119,8 @@ static const struct rtc_class_ops r9701_
 	.set_time	= r9701_set_datetime,
 };
 
-static int __devinit r9701_probe(struct spi_device *spi)
+static int __devinit r9701_probe(struct spi_device *spi,
+				 const struct spi_device_id *id)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
diff -puN drivers/rtc/rtc-rs5c348.c~spi-merge-probe-and-probe_id-callbacks drivers/rtc/rtc-rs5c348.c
--- a/drivers/rtc/rtc-rs5c348.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/rtc/rtc-rs5c348.c
@@ -147,7 +147,8 @@ static const struct rtc_class_ops rs5c34
 
 static struct spi_driver rs5c348_driver;
 
-static int __devinit rs5c348_probe(struct spi_device *spi)
+static int __devinit rs5c348_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	int ret;
 	struct rtc_device *rtc;
diff -puN drivers/serial/max3100.c~spi-merge-probe-and-probe_id-callbacks drivers/serial/max3100.c
--- a/drivers/serial/max3100.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/serial/max3100.c
@@ -741,7 +741,8 @@ static struct uart_driver max3100_uart_d
 };
 static int uart_driver_registered;
 
-static int __devinit max3100_probe(struct spi_device *spi)
+static int __devinit max3100_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	int i, retval;
 	struct plat_max3100 *pdata;
diff -puN drivers/spi/spi.c~spi-merge-probe-and-probe_id-callbacks drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/spi/spi.c
@@ -137,19 +137,12 @@ struct bus_type spi_bus_type = {
 };
 EXPORT_SYMBOL_GPL(spi_bus_type);
 
-static int spi_drv_probe_id(struct device *dev)
-{
-	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
-	struct spi_device		*sdev = to_spi_device(dev);
-
-	return sdrv->probe_id(sdev, spi_match_id(sdrv->id_table, sdev));
-}
-
 static int spi_drv_probe(struct device *dev)
 {
 	const struct spi_driver		*sdrv = to_spi_driver(dev->driver);
+	struct spi_device		*sdev = to_spi_device(dev);
 
-	return sdrv->probe(to_spi_device(dev));
+	return sdrv->probe(sdev, spi_match_id(sdrv->id_table, sdev));
 }
 
 static int spi_drv_remove(struct device *dev)
@@ -174,9 +167,7 @@ static void spi_drv_shutdown(struct devi
 int spi_register_driver(struct spi_driver *sdrv)
 {
 	sdrv->driver.bus = &spi_bus_type;
-	if (sdrv->probe_id)
-		sdrv->driver.probe = spi_drv_probe_id;
-	else if (sdrv->probe)
+	if (sdrv->probe)
 		sdrv->driver.probe = spi_drv_probe;
 	if (sdrv->remove)
 		sdrv->driver.remove = spi_drv_remove;
diff -puN drivers/spi/spidev.c~spi-merge-probe-and-probe_id-callbacks drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/spi/spidev.c
@@ -561,7 +561,7 @@ static struct class *spidev_class;
 
 /*-------------------------------------------------------------------------*/
 
-static int spidev_probe(struct spi_device *spi)
+static int spidev_probe(struct spi_device *spi, const struct spi_device_id *id)
 {
 	struct spidev_data	*spidev;
 	int			status;
diff -puN drivers/spi/tle62x0.c~spi-merge-probe-and-probe_id-callbacks drivers/spi/tle62x0.c
--- a/drivers/spi/tle62x0.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/spi/tle62x0.c
@@ -238,7 +238,8 @@ static int to_gpio_num(struct device_att
 	return -1;
 }
 
-static int __devinit tle62x0_probe(struct spi_device *spi)
+static int __devinit tle62x0_probe(struct spi_device *spi,
+				   const struct spi_device_id *id)
 {
 	struct tle62x0_state *st;
 	struct tle62x0_pdata *pdata;
diff -puN drivers/staging/stlc45xx/stlc45xx.c~spi-merge-probe-and-probe_id-callbacks drivers/staging/stlc45xx/stlc45xx.c
--- a/drivers/staging/stlc45xx/stlc45xx.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/staging/stlc45xx/stlc45xx.c
@@ -2388,7 +2388,8 @@ static struct platform_device stlc45xx_d
 	},
 };
 
-static int __devinit stlc45xx_probe(struct spi_device *spi)
+static int __devinit stlc45xx_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct stlc45xx *stlc;
 	struct ieee80211_hw *hw;
diff -puN drivers/video/backlight/corgi_lcd.c~spi-merge-probe-and-probe_id-callbacks drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -530,7 +530,8 @@ err_free_backlight_on:
 	return err;
 }
 
-static int __devinit corgi_lcd_probe(struct spi_device *spi)
+static int __devinit corgi_lcd_probe(struct spi_device *spi,
+				     const struct spi_device_id *id)
 {
 	struct corgi_lcd_platform_data *pdata = spi->dev.platform_data;
 	struct corgi_lcd *lcd;
diff -puN drivers/video/backlight/ltv350qv.c~spi-merge-probe-and-probe_id-callbacks drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/video/backlight/ltv350qv.c
@@ -225,7 +225,8 @@ static struct lcd_ops ltv_ops = {
 	.set_power	= ltv350qv_set_power,
 };
 
-static int __devinit ltv350qv_probe(struct spi_device *spi)
+static int __devinit ltv350qv_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	struct ltv350qv *lcd;
 	struct lcd_device *ld;
diff -puN drivers/video/backlight/tdo24m.c~spi-merge-probe-and-probe_id-callbacks drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/video/backlight/tdo24m.c
@@ -327,7 +327,8 @@ static struct lcd_ops tdo24m_ops = {
 	.set_mode	= tdo24m_set_mode,
 };
 
-static int __devinit tdo24m_probe(struct spi_device *spi)
+static int __devinit tdo24m_probe(struct spi_device *spi,
+				  const struct spi_device_id *id)
 {
 	struct tdo24m *lcd;
 	struct spi_message *m;
diff -puN drivers/video/backlight/tosa_lcd.c~spi-merge-probe-and-probe_id-callbacks drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -168,7 +168,8 @@ static struct lcd_ops tosa_lcd_ops = {
 	.set_mode = tosa_lcd_set_mode,
 };
 
-static int __devinit tosa_lcd_probe(struct spi_device *spi)
+static int __devinit tosa_lcd_probe(struct spi_device *spi,
+				    const struct spi_device_id *id)
 {
 	int ret;
 	struct tosa_lcd_data *data;
diff -puN drivers/video/backlight/vgg2432a4.c~spi-merge-probe-and-probe_id-callbacks drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~spi-merge-probe-and-probe_id-callbacks
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -227,7 +227,8 @@ static struct ili9320_client vgg2432a4_c
 
 /* Device probe */
 
-static int __devinit vgg2432a4_probe(struct spi_device *spi)
+static int __devinit vgg2432a4_probe(struct spi_device *spi,
+				     const struct spi_device_id *id)
 {
 	int ret;
 
diff -puN include/linux/spi/spi.h~spi-merge-probe-and-probe_id-callbacks include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-merge-probe-and-probe_id-callbacks
+++ a/include/linux/spi/spi.h
@@ -147,7 +147,6 @@ struct spi_message;
 /**
  * struct spi_driver - Host side "protocol" driver
  * @id_table: List of SPI devices supported by this driver
- * @probe_id: Binds this driver to the spi device via id_table matching.
  * @probe: Binds this driver to the spi device.  Drivers can verify
  *	that the device is actually present, and may need to configure
  *	characteristics (such as bits_per_word) which weren't needed for
@@ -174,9 +173,8 @@ struct spi_message;
  */
 struct spi_driver {
 	const struct spi_device_id *id_table;
-	int			(*probe_id)(struct spi_device *spi,
-					    const struct spi_device_id *id);
-	int			(*probe)(struct spi_device *spi);
+	int			(*probe)(struct spi_device *spi,
+					 const struct spi_device_id *id);
 	int			(*remove)(struct spi_device *spi);
 	void			(*shutdown)(struct spi_device *spi);
 	int			(*suspend)(struct spi_device *spi, pm_message_t mesg);
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
mtd-sst25l-non-jedec-spi-flash-driver-update.patch
mtd-sst25l-non-jedec-spi-flash-driver-fix.patch
mtd-m25p80-fix-null-pointer-dereference-bug.patch
spi-add-support-for-device-table-matching.patch
mtd-m25p80-convert-to-device-table-matching.patch
of-remove-stmm25p40-alias.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch
spi-prefix-modalias-with-spi.patch
spi-merge-probe-and-probe_id-callbacks.patch

