From: akpm@linux-foundation.org
Subject: + spi-prefix-modalias-with-spi.patch added to -mm tree
Date: Thu, 30 Jul 2009 16:09:20 -0700
Message-ID: <200907302309.n6UN9Kae031430@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbZG3XLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 19:11:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, ben-linux@fluff.org, benh@kernel.crashing.org, dbrownell@users.sourceforge.net, dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca, khali@linux-fr.org, linville@tuxdriver.com, sameo@openedhand.com


The patch titled
     spi: prefix modalias with "spi:"
has been added to the -mm tree.  Its filename is
     spi-prefix-modalias-with-spi.patch

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
Subject: spi: prefix modalias with "spi:"
From: Anton Vorontsov <avorontsov@ru.mvista.com>

This makes it consistent with other buses (platform, i2c, vio, ...).  I'm
not sure why we use the prefixes, but there must be a reason.

This was easy enough to do it, and I did it.

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

 drivers/gpio/max7301.c                    |    1 +
 drivers/gpio/mcp23s08.c                   |    1 +
 drivers/hwmon/adcxx.c                     |    8 ++++----
 drivers/hwmon/lis3lv02d_spi.c             |    2 +-
 drivers/hwmon/lm70.c                      |    2 ++
 drivers/hwmon/max1111.c                   |    1 +
 drivers/input/touchscreen/ad7877.c        |    1 +
 drivers/input/touchscreen/ad7879.c        |    1 +
 drivers/input/touchscreen/ads7846.c       |    1 +
 drivers/leds/leds-dac124s085.c            |    1 +
 drivers/mfd/ezx-pcap.c                    |    1 +
 drivers/misc/eeprom/at25.c                |    2 +-
 drivers/mmc/host/mmc_spi.c                |    1 +
 drivers/mtd/devices/mtd_dataflash.c       |    1 +
 drivers/net/enc28j60.c                    |    1 +
 drivers/net/ks8851.c                      |    1 +
 drivers/net/wireless/libertas/if_spi.c    |    1 +
 drivers/net/wireless/p54/p54spi.c         |    1 +
 drivers/net/wireless/wl12xx/wl1251_main.c |    1 +
 drivers/rtc/rtc-ds1305.c                  |    1 +
 drivers/rtc/rtc-ds1390.c                  |    1 +
 drivers/rtc/rtc-ds3234.c                  |    1 +
 drivers/rtc/rtc-m41t94.c                  |    1 +
 drivers/rtc/rtc-max6902.c                 |    1 +
 drivers/rtc/rtc-r9701.c                   |    1 +
 drivers/rtc/rtc-rs5c348.c                 |    1 +
 drivers/serial/max3100.c                  |    1 +
 drivers/spi/spi.c                         |    3 ++-
 drivers/spi/spidev.c                      |    1 +
 drivers/spi/tle62x0.c                     |    1 +
 drivers/staging/stlc45xx/stlc45xx.c       |    1 +
 drivers/video/backlight/corgi_lcd.c       |    1 +
 drivers/video/backlight/ltv350qv.c        |    1 +
 drivers/video/backlight/tdo24m.c          |    1 +
 drivers/video/backlight/tosa_lcd.c        |    2 +-
 drivers/video/backlight/vgg2432a4.c       |    3 +--
 include/linux/mod_devicetable.h           |    1 +
 scripts/mod/file2alias.c                  |    4 ++--
 38 files changed, 44 insertions(+), 12 deletions(-)

diff -puN drivers/gpio/max7301.c~spi-prefix-modalias-with-spi drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~spi-prefix-modalias-with-spi
+++ a/drivers/gpio/max7301.c
@@ -339,3 +339,4 @@ module_exit(max7301_exit);
 MODULE_AUTHOR("Juergen Beisert");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("MAX7301 SPI based GPIO-Expander");
+MODULE_ALIAS("spi:" DRIVER_NAME);
diff -puN drivers/gpio/mcp23s08.c~spi-prefix-modalias-with-spi drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~spi-prefix-modalias-with-spi
+++ a/drivers/gpio/mcp23s08.c
@@ -433,3 +433,4 @@ static void __exit mcp23s08_exit(void)
 module_exit(mcp23s08_exit);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:mcp23s08");
diff -puN drivers/hwmon/adcxx.c~spi-prefix-modalias-with-spi drivers/hwmon/adcxx.c
--- a/drivers/hwmon/adcxx.c~spi-prefix-modalias-with-spi
+++ a/drivers/hwmon/adcxx.c
@@ -323,7 +323,7 @@ MODULE_AUTHOR("Marc Pignat");
 MODULE_DESCRIPTION("National Semiconductor adcxx8sxxx Linux driver");
 MODULE_LICENSE("GPL");
 
-MODULE_ALIAS("adcxx1s");
-MODULE_ALIAS("adcxx2s");
-MODULE_ALIAS("adcxx4s");
-MODULE_ALIAS("adcxx8s");
+MODULE_ALIAS("spi:adcxx1s");
+MODULE_ALIAS("spi:adcxx2s");
+MODULE_ALIAS("spi:adcxx4s");
+MODULE_ALIAS("spi:adcxx8s");
diff -puN drivers/hwmon/lis3lv02d_spi.c~spi-prefix-modalias-with-spi drivers/hwmon/lis3lv02d_spi.c
--- a/drivers/hwmon/lis3lv02d_spi.c~spi-prefix-modalias-with-spi
+++ a/drivers/hwmon/lis3lv02d_spi.c
@@ -139,4 +139,4 @@ module_exit(lis302dl_exit);
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_DESCRIPTION("lis3lv02d SPI glue layer");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("spi:" DRV_NAME);
diff -puN drivers/hwmon/lm70.c~spi-prefix-modalias-with-spi drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~spi-prefix-modalias-with-spi
+++ a/drivers/hwmon/lm70.c
@@ -244,3 +244,5 @@ module_exit(cleanup_lm70);
 MODULE_AUTHOR("Kaiwan N Billimoria");
 MODULE_DESCRIPTION("NS LM70 / TI TMP121/TMP123 Linux driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:tmp121");
+MODULE_ALIAS("spi:lm70");
diff -puN drivers/hwmon/max1111.c~spi-prefix-modalias-with-spi drivers/hwmon/max1111.c
--- a/drivers/hwmon/max1111.c~spi-prefix-modalias-with-spi
+++ a/drivers/hwmon/max1111.c
@@ -242,3 +242,4 @@ module_exit(max1111_exit);
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
 MODULE_DESCRIPTION("MAX1111 ADC Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:max1111");
diff -puN drivers/input/touchscreen/ad7877.c~spi-prefix-modalias-with-spi drivers/input/touchscreen/ad7877.c
--- a/drivers/input/touchscreen/ad7877.c~spi-prefix-modalias-with-spi
+++ a/drivers/input/touchscreen/ad7877.c
@@ -842,3 +842,4 @@ module_exit(ad7877_exit);
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7877 touchscreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ad7877");
diff -puN drivers/input/touchscreen/ad7879.c~spi-prefix-modalias-with-spi drivers/input/touchscreen/ad7879.c
--- a/drivers/input/touchscreen/ad7879.c~spi-prefix-modalias-with-spi
+++ a/drivers/input/touchscreen/ad7879.c
@@ -779,3 +779,4 @@ module_exit(ad7879_exit);
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7879(-1) touchscreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ad7879");
diff -puN drivers/input/touchscreen/ads7846.c~spi-prefix-modalias-with-spi drivers/input/touchscreen/ads7846.c
--- a/drivers/input/touchscreen/ads7846.c~spi-prefix-modalias-with-spi
+++ a/drivers/input/touchscreen/ads7846.c
@@ -1256,3 +1256,4 @@ module_exit(ads7846_exit);
 
 MODULE_DESCRIPTION("ADS7846 TouchScreen Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ads7846");
diff -puN drivers/leds/leds-dac124s085.c~spi-prefix-modalias-with-spi drivers/leds/leds-dac124s085.c
--- a/drivers/leds/leds-dac124s085.c~spi-prefix-modalias-with-spi
+++ a/drivers/leds/leds-dac124s085.c
@@ -148,3 +148,4 @@ module_exit(dac124s085_leds_exit);
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
 MODULE_DESCRIPTION("DAC124S085 LED driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("spi:dac124s085");
diff -puN drivers/mfd/ezx-pcap.c~spi-prefix-modalias-with-spi drivers/mfd/ezx-pcap.c
--- a/drivers/mfd/ezx-pcap.c~spi-prefix-modalias-with-spi
+++ a/drivers/mfd/ezx-pcap.c
@@ -548,3 +548,4 @@ module_exit(ezx_pcap_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
 MODULE_DESCRIPTION("Motorola PCAP2 ASIC Driver");
+MODULE_ALIAS("spi:ezx-pcap");
diff -puN drivers/misc/eeprom/at25.c~spi-prefix-modalias-with-spi drivers/misc/eeprom/at25.c
--- a/drivers/misc/eeprom/at25.c~spi-prefix-modalias-with-spi
+++ a/drivers/misc/eeprom/at25.c
@@ -417,4 +417,4 @@ module_exit(at25_exit);
 MODULE_DESCRIPTION("Driver for most SPI EEPROMs");
 MODULE_AUTHOR("David Brownell");
 MODULE_LICENSE("GPL");
-
+MODULE_ALIAS("spi:at25");
diff -puN drivers/mmc/host/mmc_spi.c~spi-prefix-modalias-with-spi drivers/mmc/host/mmc_spi.c
--- a/drivers/mmc/host/mmc_spi.c~spi-prefix-modalias-with-spi
+++ a/drivers/mmc/host/mmc_spi.c
@@ -1562,3 +1562,4 @@ MODULE_AUTHOR("Mike Lavender, David Brow
 		"Hans-Peter Nilsson, Jan Nikitenko");
 MODULE_DESCRIPTION("SPI SD/MMC host driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:mmc_spi");
diff -puN drivers/mtd/devices/mtd_dataflash.c~spi-prefix-modalias-with-spi drivers/mtd/devices/mtd_dataflash.c
--- a/drivers/mtd/devices/mtd_dataflash.c~spi-prefix-modalias-with-spi
+++ a/drivers/mtd/devices/mtd_dataflash.c
@@ -966,3 +966,4 @@ module_exit(dataflash_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Andrew Victor, David Brownell");
 MODULE_DESCRIPTION("MTD DataFlash driver");
+MODULE_ALIAS("spi:mtd_dataflash");
diff -puN drivers/net/enc28j60.c~spi-prefix-modalias-with-spi drivers/net/enc28j60.c
--- a/drivers/net/enc28j60.c~spi-prefix-modalias-with-spi
+++ a/drivers/net/enc28j60.c
@@ -1665,3 +1665,4 @@ MODULE_AUTHOR("Claudio Lanconelli <lanco
 MODULE_LICENSE("GPL");
 module_param_named(debug, debug.msg_enable, int, 0);
 MODULE_PARM_DESC(debug, "Debug verbosity level (0=none, ..., ffff=all)");
+MODULE_ALIAS("spi:" DRV_NAME);
diff -puN drivers/net/ks8851.c~spi-prefix-modalias-with-spi drivers/net/ks8851.c
--- a/drivers/net/ks8851.c~spi-prefix-modalias-with-spi
+++ a/drivers/net/ks8851.c
@@ -1320,3 +1320,4 @@ MODULE_LICENSE("GPL");
 
 module_param_named(message, msg_enable, int, 0);
 MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");
+MODULE_ALIAS("spi:ks8851");
diff -puN drivers/net/wireless/libertas/if_spi.c~spi-prefix-modalias-with-spi drivers/net/wireless/libertas/if_spi.c
--- a/drivers/net/wireless/libertas/if_spi.c~spi-prefix-modalias-with-spi
+++ a/drivers/net/wireless/libertas/if_spi.c
@@ -1222,3 +1222,4 @@ MODULE_DESCRIPTION("Libertas SPI WLAN Dr
 MODULE_AUTHOR("Andrey Yurovsky <andrey@cozybit.com>, "
 	      "Colin McCabe <colin@cozybit.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:libertas_spi");
diff -puN drivers/net/wireless/p54/p54spi.c~spi-prefix-modalias-with-spi drivers/net/wireless/p54/p54spi.c
--- a/drivers/net/wireless/p54/p54spi.c~spi-prefix-modalias-with-spi
+++ a/drivers/net/wireless/p54/p54spi.c
@@ -731,3 +731,4 @@ module_exit(p54spi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Christian Lamparter <chunkeey@web.de>");
+MODULE_ALIAS("spi:cx3110x");
diff -puN drivers/net/wireless/wl12xx/wl1251_main.c~spi-prefix-modalias-with-spi drivers/net/wireless/wl12xx/wl1251_main.c
--- a/drivers/net/wireless/wl12xx/wl1251_main.c~spi-prefix-modalias-with-spi
+++ a/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1391,3 +1391,4 @@ module_exit(wl1251_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
 		"Luciano Coelho <luciano.coelho@nokia.com>");
+MODULE_ALIAS("spi:wl12xx");
diff -puN drivers/rtc/rtc-ds1305.c~spi-prefix-modalias-with-spi drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~spi-prefix-modalias-with-spi
+++ a/drivers/rtc/rtc-ds1305.c
@@ -841,3 +841,4 @@ module_exit(ds1305_exit);
 
 MODULE_DESCRIPTION("RTC driver for DS1305 and DS1306 chips");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-ds1305");
diff -puN drivers/rtc/rtc-ds1390.c~spi-prefix-modalias-with-spi drivers/rtc/rtc-ds1390.c
--- a/drivers/rtc/rtc-ds1390.c~spi-prefix-modalias-with-spi
+++ a/drivers/rtc/rtc-ds1390.c
@@ -189,3 +189,4 @@ module_exit(ds1390_exit);
 MODULE_DESCRIPTION("Dallas/Maxim DS1390/93/94 SPI RTC driver");
 MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-ds1390");
diff -puN drivers/rtc/rtc-ds3234.c~spi-prefix-modalias-with-spi drivers/rtc/rtc-ds3234.c
--- a/drivers/rtc/rtc-ds3234.c~spi-prefix-modalias-with-spi
+++ a/drivers/rtc/rtc-ds3234.c
@@ -188,3 +188,4 @@ module_exit(ds3234_exit);
 MODULE_DESCRIPTION("DS3234 SPI RTC driver");
 MODULE_AUTHOR("Dennis Aberilla <denzzzhome@yahoo.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ds3234");
diff -puN drivers/rtc/rtc-m41t94.c~spi-prefix-modalias-with-spi drivers/rtc/rtc-m41t94.c
--- a/drivers/rtc/rtc-m41t94.c~spi-prefix-modalias-with-spi
+++ a/drivers/rtc/rtc-m41t94.c
@@ -171,3 +171,4 @@ module_exit(m41t94_exit);
 MODULE_AUTHOR("Kim B. Heino <Kim.Heino@bluegiga.com>");
 MODULE_DESCRIPTION("Driver for ST M41T94 SPI RTC");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-m41t94");
diff -puN drivers/rtc/rtc-max6902.c~spi-prefix-modalias-with-spi drivers/rtc/rtc-max6902.c
--- a/drivers/rtc/rtc-max6902.c~spi-prefix-modalias-with-spi
+++ a/drivers/rtc/rtc-max6902.c
@@ -175,3 +175,4 @@ module_exit(max6902_exit);
 MODULE_DESCRIPTION ("max6902 spi RTC driver");
 MODULE_AUTHOR ("Raphael Assenat");
 MODULE_LICENSE ("GPL");
+MODULE_ALIAS("spi:rtc-max6902");
diff -puN drivers/rtc/rtc-r9701.c~spi-prefix-modalias-with-spi drivers/rtc/rtc-r9701.c
--- a/drivers/rtc/rtc-r9701.c~spi-prefix-modalias-with-spi
+++ a/drivers/rtc/rtc-r9701.c
@@ -174,3 +174,4 @@ module_exit(r9701_exit);
 MODULE_DESCRIPTION("r9701 spi RTC driver");
 MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:rtc-r9701");
diff -puN drivers/rtc/rtc-rs5c348.c~spi-prefix-modalias-with-spi drivers/rtc/rtc-rs5c348.c
--- a/drivers/rtc/rtc-rs5c348.c~spi-prefix-modalias-with-spi
+++ a/drivers/rtc/rtc-rs5c348.c
@@ -251,3 +251,4 @@ MODULE_AUTHOR("Atsushi Nemoto <anemo@mba
 MODULE_DESCRIPTION("Ricoh RS5C348 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS("spi:rtc-rs5c348");
diff -puN drivers/serial/max3100.c~spi-prefix-modalias-with-spi drivers/serial/max3100.c
--- a/drivers/serial/max3100.c~spi-prefix-modalias-with-spi
+++ a/drivers/serial/max3100.c
@@ -925,3 +925,4 @@ module_exit(max3100_exit);
 MODULE_DESCRIPTION("MAX3100 driver");
 MODULE_AUTHOR("Christian Pellegrin <chripell@evolware.org>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:max3100");
diff -puN drivers/spi/spi.c~spi-prefix-modalias-with-spi drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-prefix-modalias-with-spi
+++ a/drivers/spi/spi.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/cache.h>
 #include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
 #include <linux/spi/spi.h>
 
 
@@ -85,7 +86,7 @@ static int spi_uevent(struct device *dev
 {
 	const struct spi_device		*spi = to_spi_device(dev);
 
-	add_uevent_var(env, "MODALIAS=%s", spi->modalias);
+	add_uevent_var(env, "MODALIAS=%s%s", SPI_MODULE_PREFIX, spi->modalias);
 	return 0;
 }
 
diff -puN drivers/spi/spidev.c~spi-prefix-modalias-with-spi drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-prefix-modalias-with-spi
+++ a/drivers/spi/spidev.c
@@ -688,3 +688,4 @@ module_exit(spidev_exit);
 MODULE_AUTHOR("Andrea Paterniani, <a.paterniani@swapp-eng.it>");
 MODULE_DESCRIPTION("User mode SPI device interface");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:spidev");
diff -puN drivers/spi/tle62x0.c~spi-prefix-modalias-with-spi drivers/spi/tle62x0.c
--- a/drivers/spi/tle62x0.c~spi-prefix-modalias-with-spi
+++ a/drivers/spi/tle62x0.c
@@ -329,3 +329,4 @@ module_exit(tle62x0_exit);
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("TLE62x0 SPI driver");
 MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("spi:tle62x0");
diff -puN drivers/staging/stlc45xx/stlc45xx.c~spi-prefix-modalias-with-spi drivers/staging/stlc45xx/stlc45xx.c
--- a/drivers/staging/stlc45xx/stlc45xx.c~spi-prefix-modalias-with-spi
+++ a/drivers/staging/stlc45xx/stlc45xx.c
@@ -2591,3 +2591,4 @@ module_exit(stlc45xx_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <kalle.valo@nokia.com>");
+MODULE_ALIAS("spi:cx3110x");
diff -puN drivers/video/backlight/corgi_lcd.c~spi-prefix-modalias-with-spi drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~spi-prefix-modalias-with-spi
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -639,3 +639,4 @@ module_exit(corgi_lcd_exit);
 MODULE_DESCRIPTION("LCD and backlight driver for SHARP C7x0/Cxx00");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:corgi-lcd");
diff -puN drivers/video/backlight/ltv350qv.c~spi-prefix-modalias-with-spi drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~spi-prefix-modalias-with-spi
+++ a/drivers/video/backlight/ltv350qv.c
@@ -328,3 +328,4 @@ module_exit(ltv350qv_exit);
 MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
 MODULE_DESCRIPTION("Samsung LTV350QV LCD Driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:ltv350qv");
diff -puN drivers/video/backlight/tdo24m.c~spi-prefix-modalias-with-spi drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~spi-prefix-modalias-with-spi
+++ a/drivers/video/backlight/tdo24m.c
@@ -472,3 +472,4 @@ module_exit(tdo24m_exit);
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
 MODULE_DESCRIPTION("Driver for Toppoly TDO24M LCD Panel");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("spi:tdo24m");
diff -puN drivers/video/backlight/tosa_lcd.c~spi-prefix-modalias-with-spi drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~spi-prefix-modalias-with-spi
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -300,4 +300,4 @@ module_exit(tosa_lcd_exit);
 MODULE_AUTHOR("Dmitry Baryshkov");
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("LCD/Backlight control for Sharp SL-6000 PDA");
-
+MODULE_ALIAS("spi:tosa-lcd");
diff -puN drivers/video/backlight/vgg2432a4.c~spi-prefix-modalias-with-spi drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~spi-prefix-modalias-with-spi
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -280,5 +280,4 @@ module_exit(vgg2432a4_exit);
 MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
 MODULE_DESCRIPTION("VGG2432A4 LCD Driver");
 MODULE_LICENSE("GPL v2");
-
-
+MODULE_ALIAS("spi:VGG2432A4");
diff -puN include/linux/mod_devicetable.h~spi-prefix-modalias-with-spi include/linux/mod_devicetable.h
--- a/include/linux/mod_devicetable.h~spi-prefix-modalias-with-spi
+++ a/include/linux/mod_devicetable.h
@@ -402,6 +402,7 @@ struct i2c_device_id {
 /* spi */
 
 #define SPI_NAME_SIZE	20
+#define SPI_MODULE_PREFIX "spi:"
 
 struct spi_device_id {
 	char name[SPI_NAME_SIZE];
diff -puN scripts/mod/file2alias.c~spi-prefix-modalias-with-spi scripts/mod/file2alias.c
--- a/scripts/mod/file2alias.c~spi-prefix-modalias-with-spi
+++ a/scripts/mod/file2alias.c
@@ -657,11 +657,11 @@ static int do_i2c_entry(const char *file
 	return 1;
 }
 
-/* Looks like: S */
+/* Looks like: spi:S */
 static int do_spi_entry(const char *filename, struct spi_device_id *id,
 			char *alias)
 {
-	sprintf(alias, "%s", id->name);
+	sprintf(alias, SPI_MODULE_PREFIX "%s", id->name);
 
 	return 1;
 }
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
spi-prefix-modalias-with-spi.patch
spi-merge-probe-and-probe_id-callbacks.patch
hwmon-adxx-convert-to-device-table-matching.patch
hwmon-lm70-convert-to-device-table-matching.patch

