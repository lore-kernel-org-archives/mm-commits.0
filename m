From: akpm@linux-foundation.org
Subject: + spi-gpio-allow-operation-without-cs-signal.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:28:32 -0800
Message-ID: <200902242028.n1OKSW45008525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50125 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758576AbZBXU2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net


The patch titled
     spi-gpio: allow operation without CS signal
has been added to the -mm tree.  Its filename is
     spi-gpio-allow-operation-without-cs-signal.patch

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
Subject: spi-gpio: allow operation without CS signal
From: Michael Buesch <mb@bu3sch.de>

Change spi-gpio so that it is possible to drive SPI communications over
GPIO without the need for a chipselect signal.

This is useful in very small setups where there's only one slave device
on the bus.

This patch does not affect existing setups.

I use this for a tiny communication channel between an embedded device and
a microcontroller.  There are not enough GPIOs available for chipselect
and it's not needed anyway in this case.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_gpio.c       |   21 +++++++++++++--------
 include/linux/spi/spi_gpio.h |    6 ++++++
 2 files changed, 19 insertions(+), 8 deletions(-)

diff -puN drivers/spi/spi_gpio.c~spi-gpio-allow-operation-without-cs-signal drivers/spi/spi_gpio.c
--- a/drivers/spi/spi_gpio.c~spi-gpio-allow-operation-without-cs-signal
+++ a/drivers/spi/spi_gpio.c
@@ -178,8 +178,10 @@ static void spi_gpio_chipselect(struct s
 	if (is_active)
 		setsck(spi, spi->mode & SPI_CPOL);
 
-	/* SPI is normally active-low */
-	gpio_set_value(cs, (spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
+	if (cs != SPI_GPIO_NO_CHIPSELECT) {
+		/* SPI is normally active-low */
+		gpio_set_value(cs, (spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
+	}
 }
 
 static int spi_gpio_setup(struct spi_device *spi)
@@ -191,15 +193,17 @@ static int spi_gpio_setup(struct spi_dev
 		return -EINVAL;
 
 	if (!spi->controller_state) {
-		status = gpio_request(cs, dev_name(&spi->dev));
-		if (status)
-			return status;
-		status = gpio_direction_output(cs, spi->mode & SPI_CS_HIGH);
+		if (cs != SPI_GPIO_NO_CHIPSELECT) {
+			status = gpio_request(cs, dev_name(&spi->dev));
+			if (status)
+				return status;
+			status = gpio_direction_output(cs, spi->mode & SPI_CS_HIGH);
+		}
 	}
 	if (!status)
 		status = spi_bitbang_setup(spi);
 	if (status) {
-		if (!spi->controller_state)
+		if (!spi->controller_state && cs != SPI_GPIO_NO_CHIPSELECT)
 			gpio_free(cs);
 	}
 	return status;
@@ -209,7 +213,8 @@ static void spi_gpio_cleanup(struct spi_
 {
 	unsigned long	cs = (unsigned long) spi->controller_data;
 
-	gpio_free(cs);
+	if (cs != SPI_GPIO_NO_CHIPSELECT)
+		gpio_free(cs);
 	spi_bitbang_cleanup(spi);
 }
 
diff -puN include/linux/spi/spi_gpio.h~spi-gpio-allow-operation-without-cs-signal include/linux/spi/spi_gpio.h
--- a/include/linux/spi/spi_gpio.h~spi-gpio-allow-operation-without-cs-signal
+++ a/include/linux/spi/spi_gpio.h
@@ -25,10 +25,16 @@
  *	...
  *	};
  *
+ * If chipselect is not used (there's only one device on the bus), assign
+ * SPI_GPIO_NO_CHIPSELECT to the controller_data:
+ *		.controller_data = (void *) SPI_GPIO_NO_CHIPSELECT;
+ *
  * If the bitbanged bus is later switched to a "native" controller,
  * that platform_device and controller_data should be removed.
  */
 
+#define SPI_GPIO_NO_CHIPSELECT		((unsigned long)-1l)
+
 /**
  * struct spi_gpio_platform_data - parameter for bitbanged SPI master
  * @sck: number of the GPIO used for clock output
_

Patches currently in -mm which might be from mb@bu3sch.de are

linux-next.patch
bcm47xx-fix-gpio-api-return-codes.patch
spi-gpio-allow-operation-without-cs-signal.patch

