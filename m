From: akpm@linux-foundation.org
Subject: - input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:19:13 -0800
Message-ID: <200812012219.mB1MJD1Z011988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbYLAWUR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:20:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.hennerich@analog.com, cooloney@kernel.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Input/AD7879: Fix/workaroud build error reported by Andrew Morton:
has been removed from the -mm tree.  Its filename was
     input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch

This patch was dropped because it was folded into input-ad7879-touchscreen-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Input/AD7879: Fix/workaroud build error reported by Andrew Morton:
From: Michael Hennerich <michael.hennerich@analog.com>

On Thu, 30 Oct 2008 02:24:25 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-10-30-02-23 has been uploaded to
>
>    http://userweb.kernel.org/~akpm/mmotm/
>
> It contains the following patches against 2.6.28-rc2:

CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_I2C=m <<<<<<<<<<
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m
CONFIG_I2C_GPIO=m

causes
drivers/built-in.o: In function `ad7879_write':
ad7879.c:(.text+0x749ce): undefined reference to
`i2c_smbus_write_word_data'
drivers/built-in.o: In function `ad7879_read':
ad7879.c:(.text+0x749ee): undefined reference to
`i2c_smbus_read_word_data'
drivers/built-in.o: In function `ad7879_init':
ad7879.c:(.init.text+0x3a6e): undefined reference to
`i2c_register_driver'
drivers/built-in.o: In function `ad7879_exit':
ad7879.c:(.exit.text+0x6c1): undefined reference to `i2c_del_driver'

rand-config attached.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/Kconfig  |   35 +++++++++++++++------------
 drivers/input/touchscreen/ad7879.c |   10 +++----
 2 files changed, 25 insertions(+), 20 deletions(-)

diff -puN drivers/input/touchscreen/Kconfig~input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton
+++ a/drivers/input/touchscreen/Kconfig
@@ -42,32 +42,37 @@ config TOUCHSCREEN_AD7877
 	  To compile this driver as a module, choose M here: the
 	  module will be called ad7877.
 
-config TOUCHSCREEN_AD7879
-	tristate "AD7879 based touchscreens"
-	depends on SPI_MASTER || I2C
+config TOUCHSCREEN_AD7879_I2C
+	tristate "AD7879 based touchscreens: AD7879-1 I2C Interface"
+	depends on I2C
+	select TOUCHSCREEN_AD7879
 	help
 	  Say Y here if you have a touchscreen interface using the
-	  AD7879(-1) controller, and your board-specific initialization
-	  code includes that in its table of SPI/I2C devices.
+	  AD7879-1 controller, and your board-specific initialization
+	  code includes that in its table of I2C devices.
 
 	  If unsure, say N (but it's safe to say "Y").
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called ad7879.
 
-choice
-	prompt "Interface Selection"
-	depends on TOUCHSCREEN_AD7879
+config TOUCHSCREEN_AD7879_SPI
+	tristate "AD7879 based touchscreens: AD7879 SPI Interface"
+	depends on SPI_MASTER && TOUCHSCREEN_AD7879_I2C = n
+	select TOUCHSCREEN_AD7879
+	help
+	  Say Y here if you have a touchscreen interface using the
+	  AD7879 controller, and your board-specific initialization
+	  code includes that in its table of SPI devices.
 
-config TOUCHSCREEN_AD7879_I2C
-	bool "AD7879-1 I2C"
-	depends on I2C
+	  If unsure, say N (but it's safe to say "Y").
 
-config TOUCHSCREEN_AD7879_SPI
-	bool "AD7879 SPI"
-	depends on SPI_MASTER
-endchoice
+	  To compile this driver as a module, choose M here: the
+	  module will be called ad7879.
 
+config TOUCHSCREEN_AD7879
+	tristate
+	default n
 
 config TOUCHSCREEN_BITSY
 	tristate "Compaq iPAQ H3600 (Bitsy) touchscreen"
diff -puN drivers/input/touchscreen/ad7879.c~input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton drivers/input/touchscreen/ad7879.c
--- a/drivers/input/touchscreen/ad7879.c~input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton
+++ a/drivers/input/touchscreen/ad7879.c
@@ -120,10 +120,10 @@ enum {
 #define	MAX_12BIT			((1<<12)-1)
 #define	TS_PEN_UP_TIMEOUT		msecs_to_jiffies(50)
 
-#if defined(CONFIG_TOUCHSCREEN_AD7879_SPI)
+#if defined(CONFIG_TOUCHSCREEN_AD7879_SPI) || defined(CONFIG_TOUCHSCREEN_AD7879_SPI_MODULE)
 #define AD7879_DEVID		0x7A
 typedef struct spi_device	bus_device;
-#elif defined(CONFIG_TOUCHSCREEN_AD7879_I2C)
+#elif defined(CONFIG_TOUCHSCREEN_AD7879_I2C) || defined(CONFIG_TOUCHSCREEN_AD7879_I2C_MODULE)
 #define AD7879_DEVID		0x79
 typedef struct i2c_client	bus_device;
 #endif
@@ -135,7 +135,7 @@ struct ad7879 {
 	struct timer_list	timer;
 	spinlock_t		lock;
 
-#ifdef CONFIG_TOUCHSCREEN_AD7879_SPI
+#if defined(CONFIG_TOUCHSCREEN_AD7879_SPI) || defined(CONFIG_TOUCHSCREEN_AD7879_SPI_MODULE)
 	struct spi_message	msg;
 	struct spi_transfer	xfer[AD7879_NR_SENSE + 1];
 	u16			cmd;
@@ -527,7 +527,7 @@ static int ad7879_resume(bus_device *bus
 #define ad7879_resume  NULL
 #endif
 
-#if defined(CONFIG_TOUCHSCREEN_AD7879_SPI)
+#if defined(CONFIG_TOUCHSCREEN_AD7879_SPI) || defined(CONFIG_TOUCHSCREEN_AD7879_SPI_MODULE)
 #define MAX_SPI_FREQ_HZ		5000000
 #define AD7879_CMD_MAGIC	0xE000
 #define AD7879_CMD_READ		(1 << 10)
@@ -700,7 +700,7 @@ static void __exit ad7879_exit(void)
 }
 module_exit(ad7879_exit);
 
-#elif defined(CONFIG_TOUCHSCREEN_AD7879_I2C)
+#elif defined(CONFIG_TOUCHSCREEN_AD7879_I2C) || defined(CONFIG_TOUCHSCREEN_AD7879_I2C_MODULE)
 
 /* All registers are word-sized.
  * AD7879 uses a high-byte first convention.
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-ad7879-touchscreen-driver.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
pcmcia-blackfin-fix-bug-add-missing-to-module-macro.patch

