From: akpm@linux-foundation.org
Subject: + backlight-add-s6e63m0-amoled-lcd-panel-driver.patch added to -mm tree
Date: Tue, 30 Mar 2010 16:03:03 -0700
Message-ID: <201003302303.o2UN34I0010211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011Ab0C3XDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 19:03:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daeinki@gmail.com, inki.dae@samsung.com, pavel@ucw.cz, rpurdie@rpsys.net


The patch titled
     backlight: add S6E63M0 AMOLED LCD Panel driver
has been added to the -mm tree.  Its filename is
     backlight-add-s6e63m0-amoled-lcd-panel-driver.patch

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
Subject: backlight: add S6E63M0 AMOLED LCD Panel driver
From: InKi Dae <daeinki@gmail.com>

This is S6E63M0 AMOLED LCD Panel(480x800) driver using 3-wired SPI
interface also almost features for lcd panel driver has been implemented
in here.  and I added new structure common for all the lcd panel drivers
to include/linux/lcd.h file.

LCD Panel driver needs interfaces for controlling device power such as
power on/off and reset.  these interfaces are device specific so it should
be implemented to machine code at this time, we should create new
structure for registering these functions as callbacks and also a header
file for that structure and finally registered callback functions would be
called by lcd panel driver.  such header file(including new structure for
lcd panel) would be added for all the lcd panel drivers.

If anyone provides common structure for registering such callback
functions then we could reduce unnecessary header files for lcd panel.  I
thought that suitable anyone could be include/linux/lcd.h

I added new structure to lcd.h like following,
struct lcd_platform_data {
	/* reset lcd panel device. */
	int (*reset)(struct lcd_device *ld);
	/* on or off to lcd panel. if 'enable' is 0 then
	   lcd power off and 1, lcd power on. */
	int (*power_on)(struct lcd_device *ld, int enable);

	/* it indicates whether lcd panel was enabled
	   from bootloader or not. */
	int lcd_enabled;
	/* it means delay for stable time when it becomes low to high
	   or high to low that is dependent on whether reset gpio is
	   low active or high active. */
	unsigned int reset_delay;
	/* stable time needing to become lcd power on. */
	unsigned int power_on_delay;
	/* stable time needing to become lcd power off. */
	unsigned int power_off_delay;

	/* it could be used for any purpose. */
	void *pdata;
};

Signed-off-by: InKi Dae <inki.dae@samsung.com>
Reviewed-by: KyungMin Park <kyungmin.park.samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig         |    6 
 drivers/video/backlight/Makefile        |    1 
 drivers/video/backlight/s6e63m0.c       |  884 ++++++++++++++++++++++
 drivers/video/backlight/s6e63m0_gamma.h |  266 ++++++
 include/linux/lcd.h                     |   23 
 5 files changed, 1180 insertions(+)

diff -puN drivers/video/backlight/Kconfig~backlight-add-s6e63m0-amoled-lcd-panel-driver drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~backlight-add-s6e63m0-amoled-lcd-panel-driver
+++ a/drivers/video/backlight/Kconfig
@@ -107,6 +107,12 @@ config LCD_HP700
 	  If you have an HP Jornada 700 series handheld (710/720/728)
 	  say Y to enable LCD control driver.
 
+config LCD_S6E63M0
+	tristate "S6E63M0 AMOLED LCD Driver"
+	depends on LCD_CLASS_DEVICE && SPI
+	default n
+	help
+	  If you have an S6E63M0 LCD Panel say Y to enable LCD control driver
 #
 # Backlight
 #
diff -puN drivers/video/backlight/Makefile~backlight-add-s6e63m0-amoled-lcd-panel-driver drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~backlight-add-s6e63m0-amoled-lcd-panel-driver
+++ a/drivers/video/backlight/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_LCD_PLATFORM)	   += platfor
 obj-$(CONFIG_LCD_VGG2432A4)	   += vgg2432a4.o
 obj-$(CONFIG_LCD_TDO24M)	   += tdo24m.o
 obj-$(CONFIG_LCD_TOSA)		   += tosa_lcd.o
+obj-$(CONFIG_LCD_S6E63M0)	+= s6e63m0.o
 
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
 obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)    += atmel-pwm-bl.o
diff -puN /dev/null drivers/video/backlight/s6e63m0.c
--- /dev/null
+++ a/drivers/video/backlight/s6e63m0.c
@@ -0,0 +1,884 @@
+/*
+ * S6E63M0 AMOLED LCD panel driver.
+ *
+ * Author: InKi Dae  <inki.dae@samsung.com>
+ *
+ * Derived from drivers/video/omap/lcd-apollon.c
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/wait.h>
+#include <linux/fb.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/lcd.h>
+#include <linux/backlight.h>
+
+#include "s6e63m0_gamma.h"
+
+#define SLEEPMSEC		0x1000
+#define ENDDEF			0x2000
+#define	DEFMASK			0xFF00
+#define COMMAND_ONLY		0xFE
+#define DATA_ONLY		0xFF
+
+#define MIN_BRIGHTNESS		0
+#define MAX_BRIGHTNESS		10
+
+#define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
+
+struct s6e63m0 {
+	struct device			*dev;
+	struct spi_device		*spi;
+	unsigned int			power;
+	unsigned int			current_brightness;
+	unsigned int			gamma_mode;
+	unsigned int			gamma_table_count;
+	struct lcd_device		*ld;
+	struct backlight_device		*bd;
+	struct lcd_platform_data	*lcd_pd;
+};
+
+static const unsigned short SEQ_PANEL_CONDITION_SET[] = {
+	0xF8, 0x01,
+	DATA_ONLY, 0x27,
+	DATA_ONLY, 0x27,
+	DATA_ONLY, 0x07,
+	DATA_ONLY, 0x07,
+	DATA_ONLY, 0x54,
+	DATA_ONLY, 0x9f,
+	DATA_ONLY, 0x63,
+	DATA_ONLY, 0x86,
+	DATA_ONLY, 0x1a,
+	DATA_ONLY, 0x33,
+	DATA_ONLY, 0x0d,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_DISPLAY_CONDITION_SET[] = {
+	0xf2, 0x02,
+	DATA_ONLY, 0x03,
+	DATA_ONLY, 0x1c,
+	DATA_ONLY, 0x10,
+	DATA_ONLY, 0x10,
+
+	0xf7, 0x03,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_GAMMA_SETTING[] = {
+	0xfa, 0x00,
+	DATA_ONLY, 0x18,
+	DATA_ONLY, 0x08,
+	DATA_ONLY, 0x24,
+	DATA_ONLY, 0x64,
+	DATA_ONLY, 0x56,
+	DATA_ONLY, 0x33,
+	DATA_ONLY, 0xb6,
+	DATA_ONLY, 0xba,
+	DATA_ONLY, 0xa8,
+	DATA_ONLY, 0xac,
+	DATA_ONLY, 0xb1,
+	DATA_ONLY, 0x9d,
+	DATA_ONLY, 0xc1,
+	DATA_ONLY, 0xc1,
+	DATA_ONLY, 0xb7,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x9c,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x9f,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0xd6,
+
+	0xfa, 0x01,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_ETC_CONDITION_SET[] = {
+	0xf6, 0x00,
+	DATA_ONLY, 0x8c,
+	DATA_ONLY, 0x07,
+
+	0xb3, 0xc,
+
+	0xb5, 0x2c,
+	DATA_ONLY, 0x12,
+	DATA_ONLY, 0x0c,
+	DATA_ONLY, 0x0a,
+	DATA_ONLY, 0x10,
+	DATA_ONLY, 0x0e,
+	DATA_ONLY, 0x17,
+	DATA_ONLY, 0x13,
+	DATA_ONLY, 0x1f,
+	DATA_ONLY, 0x1a,
+	DATA_ONLY, 0x2a,
+	DATA_ONLY, 0x24,
+	DATA_ONLY, 0x1f,
+	DATA_ONLY, 0x1b,
+	DATA_ONLY, 0x1a,
+	DATA_ONLY, 0x17,
+
+	DATA_ONLY, 0x2b,
+	DATA_ONLY, 0x26,
+	DATA_ONLY, 0x22,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x3a,
+	DATA_ONLY, 0x34,
+	DATA_ONLY, 0x30,
+	DATA_ONLY, 0x2c,
+	DATA_ONLY, 0x29,
+	DATA_ONLY, 0x26,
+	DATA_ONLY, 0x25,
+	DATA_ONLY, 0x23,
+	DATA_ONLY, 0x21,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x1e,
+	DATA_ONLY, 0x1e,
+
+	0xb6, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x11,
+	DATA_ONLY, 0x22,
+	DATA_ONLY, 0x33,
+	DATA_ONLY, 0x44,
+	DATA_ONLY, 0x44,
+	DATA_ONLY, 0x44,
+
+	DATA_ONLY, 0x55,
+	DATA_ONLY, 0x55,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+
+	0xb7, 0x2c,
+	DATA_ONLY, 0x12,
+	DATA_ONLY, 0x0c,
+	DATA_ONLY, 0x0a,
+	DATA_ONLY, 0x10,
+	DATA_ONLY, 0x0e,
+	DATA_ONLY, 0x17,
+	DATA_ONLY, 0x13,
+	DATA_ONLY, 0x1f,
+	DATA_ONLY, 0x1a,
+	DATA_ONLY, 0x2a,
+	DATA_ONLY, 0x24,
+	DATA_ONLY, 0x1f,
+	DATA_ONLY, 0x1b,
+	DATA_ONLY, 0x1a,
+	DATA_ONLY, 0x17,
+
+	DATA_ONLY, 0x2b,
+	DATA_ONLY, 0x26,
+	DATA_ONLY, 0x22,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x3a,
+	DATA_ONLY, 0x34,
+	DATA_ONLY, 0x30,
+	DATA_ONLY, 0x2c,
+	DATA_ONLY, 0x29,
+	DATA_ONLY, 0x26,
+	DATA_ONLY, 0x25,
+	DATA_ONLY, 0x23,
+	DATA_ONLY, 0x21,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x1e,
+	DATA_ONLY, 0x1e,
+
+	0xb8, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x11,
+	DATA_ONLY, 0x22,
+	DATA_ONLY, 0x33,
+	DATA_ONLY, 0x44,
+	DATA_ONLY, 0x44,
+	DATA_ONLY, 0x44,
+
+	DATA_ONLY, 0x55,
+	DATA_ONLY, 0x55,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+
+	0xb9, 0x2c,
+	DATA_ONLY, 0x12,
+	DATA_ONLY, 0x0c,
+	DATA_ONLY, 0x0a,
+	DATA_ONLY, 0x10,
+	DATA_ONLY, 0x0e,
+	DATA_ONLY, 0x17,
+	DATA_ONLY, 0x13,
+	DATA_ONLY, 0x1f,
+	DATA_ONLY, 0x1a,
+	DATA_ONLY, 0x2a,
+	DATA_ONLY, 0x24,
+	DATA_ONLY, 0x1f,
+	DATA_ONLY, 0x1b,
+	DATA_ONLY, 0x1a,
+	DATA_ONLY, 0x17,
+
+	DATA_ONLY, 0x2b,
+	DATA_ONLY, 0x26,
+	DATA_ONLY, 0x22,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x3a,
+	DATA_ONLY, 0x34,
+	DATA_ONLY, 0x30,
+	DATA_ONLY, 0x2c,
+	DATA_ONLY, 0x29,
+	DATA_ONLY, 0x26,
+	DATA_ONLY, 0x25,
+	DATA_ONLY, 0x23,
+	DATA_ONLY, 0x21,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x1e,
+	DATA_ONLY, 0x1e,
+
+	0xba, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x11,
+	DATA_ONLY, 0x22,
+	DATA_ONLY, 0x33,
+	DATA_ONLY, 0x44,
+	DATA_ONLY, 0x44,
+	DATA_ONLY, 0x44,
+
+	DATA_ONLY, 0x55,
+	DATA_ONLY, 0x55,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+	DATA_ONLY, 0x66,
+
+	0xc1, 0x4d,
+	DATA_ONLY, 0x96,
+	DATA_ONLY, 0x1d,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x01,
+	DATA_ONLY, 0xdf,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	DATA_ONLY, 0x1f,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	DATA_ONLY, 0x06,
+	DATA_ONLY, 0x09,
+	DATA_ONLY, 0x0d,
+	DATA_ONLY, 0x0f,
+	DATA_ONLY, 0x12,
+	DATA_ONLY, 0x15,
+	DATA_ONLY, 0x18,
+
+	0xb2, 0x10,
+	DATA_ONLY, 0x10,
+	DATA_ONLY, 0x0b,
+	DATA_ONLY, 0x05,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_ACL_ON[] = {
+	/* ACL on */
+	0xc0, 0x01,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_ACL_OFF[] = {
+	/* ACL off */
+	0xc0, 0x00,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_ELVSS_ON[] = {
+	/* ELVSS on */
+	0xb1, 0x0b,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_ELVSS_OFF[] = {
+	/* ELVSS off */
+	0xb1, 0x0a,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_STAND_BY_OFF[] = {
+	0x11, COMMAND_ONLY,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_STAND_BY_ON[] = {
+	0x10, COMMAND_ONLY,
+
+	ENDDEF, 0x0000
+};
+
+static const unsigned short SEQ_DISPLAY_ON[] = {
+	0x29, COMMAND_ONLY,
+
+	ENDDEF, 0x0000
+};
+
+
+static int s6e63m0_spi_write_byte(struct s6e63m0 *lcd, int addr, int data)
+{
+	u16 buf[1];
+	struct spi_message msg;
+
+	struct spi_transfer xfer = {
+		.len		= 2,
+		.tx_buf		= buf,
+	};
+
+	buf[0] = (addr << 8) | data;
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	return spi_sync(lcd->spi, &msg);
+}
+
+static int s6e63m0_spi_write(struct s6e63m0 *lcd, unsigned char address,
+	unsigned char command)
+{
+	int ret = 0;
+
+	if (address != DATA_ONLY)
+		ret = s6e63m0_spi_write_byte(lcd, 0x0, address);
+	if (command != COMMAND_ONLY)
+		ret = s6e63m0_spi_write_byte(lcd, 0x1, command);
+
+	return ret;
+}
+
+static int s6e63m0_panel_send_sequence(struct s6e63m0 *lcd,
+	const unsigned short *wbuf)
+{
+	int ret = 0, i = 0;
+
+	while ((wbuf[i] & DEFMASK) != ENDDEF) {
+		if ((wbuf[i] & DEFMASK) != SLEEPMSEC) {
+			ret = s6e63m0_spi_write(lcd, wbuf[i], wbuf[i+1]);
+			if (ret)
+				break;
+		} else
+			udelay(wbuf[i+1]*1000);
+		i += 2;
+	}
+
+	return ret;
+}
+
+static int _s6e63m0_gamma_ctl(struct s6e63m0 *lcd, const unsigned int *gamma)
+{
+	unsigned int i = 0;
+	int ret = 0;
+
+	/* disable gamma table updating. */
+	ret = s6e63m0_spi_write(lcd, 0xfa, 0x00);
+
+	for (i = 0 ; i < GAMMA_TABLE_COUNT; i++)
+		ret |= s6e63m0_spi_write(lcd, DATA_ONLY, gamma[i]);
+
+	/* update gamma table. */
+	ret |= s6e63m0_spi_write(lcd, 0xfa, 0x01);
+
+	return ret;
+}
+
+static int s6e63m0_gamma_ctl(struct s6e63m0 *lcd, int gamma)
+{
+	int ret = 0;
+
+	ret = _s6e63m0_gamma_ctl(lcd, gamma_table.gamma_22_table[gamma]);
+
+	return ret;
+}
+
+
+static int s6e63m0_ldi_init(struct s6e63m0 *lcd)
+{
+	int ret;
+
+	ret = s6e63m0_panel_send_sequence(lcd, SEQ_PANEL_CONDITION_SET);
+	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_CONDITION_SET);
+	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_GAMMA_SETTING);
+	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ETC_CONDITION_SET);
+	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ACL_ON);
+	ret |= s6e63m0_panel_send_sequence(lcd, SEQ_ELVSS_ON);
+
+	return ret;
+}
+
+static int s6e63m0_ldi_enable(struct s6e63m0 *lcd)
+{
+	int ret = 0;
+
+	ret = s6e63m0_panel_send_sequence(lcd, SEQ_STAND_BY_OFF);
+	ret = s6e63m0_panel_send_sequence(lcd, SEQ_DISPLAY_ON);
+
+	return ret;
+}
+
+static int s6e63m0_ldi_disable(struct s6e63m0 *lcd)
+{
+	int ret;
+
+	ret = s6e63m0_panel_send_sequence(lcd, SEQ_STAND_BY_ON);
+
+	return ret;
+}
+
+static int s6e63m0_power_on(struct s6e63m0 *lcd)
+{
+	int ret = 0;
+	struct lcd_platform_data *pd = NULL;
+	struct backlight_device *bd = NULL;
+
+	pd = lcd->lcd_pd;
+	if (!pd) {
+		dev_err(lcd->dev, "platform data is NULL.\n");
+		return -EFAULT;
+	}
+
+	bd = lcd->bd;
+	if (!bd) {
+		dev_err(lcd->dev, "backlight device is NULL.\n");
+		return -EFAULT;
+	}
+
+	if (!pd->power_on) {
+		dev_err(lcd->dev, "power_on is NULL.\n");
+		return -EFAULT;
+	} else {
+		pd->power_on(lcd->ld, 1);
+		mdelay(pd->power_on_delay);
+	}
+
+	if (!pd->reset) {
+		dev_err(lcd->dev, "reset is NULL.\n");
+		return -EFAULT;
+	} else {
+		pd->reset(lcd->ld);
+		mdelay(pd->reset_delay);
+	}
+
+	ret = s6e63m0_ldi_init(lcd);
+	ret |= s6e63m0_ldi_enable(lcd);
+	/* set brightness to current value after power on or resume. */
+	ret |= s6e63m0_gamma_ctl(lcd, bd->props.brightness);
+	if (ret) {
+		dev_err(lcd->dev, "lcd gamma setting failed.\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int s6e63m0_power_off(struct s6e63m0 *lcd)
+{
+	int ret = 0;
+	struct lcd_platform_data *pd = NULL;
+
+	pd = lcd->lcd_pd;
+	if (!pd) {
+		dev_err(lcd->dev, "platform data is NULL.\n");
+		return -EFAULT;
+	}
+
+	ret = s6e63m0_ldi_disable(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "lcd setting failed.\n");
+		return -EIO;
+	}
+
+	mdelay(pd->power_off_delay);
+
+	if (!pd->power_on) {
+		dev_err(lcd->dev, "power_on is NULL.\n");
+		return -EFAULT;
+	} else
+		pd->power_on(lcd->ld, 0);
+
+	return 0;
+}
+
+static int s6e63m0_power(struct s6e63m0 *lcd, int power)
+{
+	int ret = 0;
+
+	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
+		ret = s6e63m0_power_on(lcd);
+	else if (!POWER_IS_ON(power) && POWER_IS_ON(lcd->power))
+		ret = s6e63m0_power_off(lcd);
+
+	if (!ret)
+		lcd->power = power;
+
+	return ret;
+}
+
+static int s6e63m0_set_power(struct lcd_device *ld, int power)
+{
+	struct s6e63m0 *lcd = lcd_get_data(ld);
+
+	if (power != FB_BLANK_UNBLANK && power != FB_BLANK_POWERDOWN &&
+		power != FB_BLANK_NORMAL) {
+		dev_err(lcd->dev, "power value should be 0, 1 or 4.\n");
+		return -EINVAL;
+	}
+
+	return s6e63m0_power(lcd, power);
+}
+
+static int s6e63m0_get_power(struct lcd_device *ld)
+{
+	struct s6e63m0 *lcd = lcd_get_data(ld);
+
+	return lcd->power;
+}
+
+static int s6e63m0_get_brightness(struct backlight_device *bd)
+{
+	return bd->props.brightness;
+}
+
+static int s6e63m0_set_brightness(struct backlight_device *bd)
+{
+	int ret = 0, brightness = bd->props.brightness;
+	struct s6e63m0 *lcd = bl_get_data(bd);
+
+	if (brightness < MIN_BRIGHTNESS ||
+		brightness > bd->props.max_brightness) {
+		dev_err(&bd->dev, "lcd brightness should be %d to %d.\n",
+			MIN_BRIGHTNESS, MAX_BRIGHTNESS);
+		return -EINVAL;
+	}
+
+	ret = s6e63m0_gamma_ctl(lcd, bd->props.brightness);
+	if (ret) {
+		dev_err(&bd->dev, "lcd brightness setting failed.\n");
+		return -EIO;
+	}
+
+	return ret;
+}
+
+static struct lcd_ops s6e63m0_lcd_ops = {
+	.set_power = s6e63m0_set_power,
+	.get_power = s6e63m0_get_power,
+};
+
+static struct backlight_ops s6e63m0_backlight_ops  = {
+	.get_brightness = s6e63m0_get_brightness,
+	.update_status = s6e63m0_set_brightness,
+};
+
+static int s6e63m0_sysfs_show_gamma_mode(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct s6e63m0 *lcd = dev_get_drvdata(dev);
+	char temp[10];
+
+	switch (lcd->gamma_mode) {
+	case 0:
+		sprintf(temp, "2.2 mode\n");
+		strcat(buf, temp);
+		break;
+	case 1:
+		sprintf(temp, "1.9 mode\n");
+		strcat(buf, temp);
+		break;
+	case 2:
+		sprintf(temp, "1.7 mode\n");
+		strcat(buf, temp);
+		break;
+	default:
+		dev_info(dev, "gamma mode could be 0:2.2, 1:1.9 or 2:1.7)n");
+		break;
+	}
+
+	return strlen(buf);
+}
+
+static int s6e63m0_sysfs_store_gamma_mode(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t len)
+{
+	struct s6e63m0 *lcd = dev_get_drvdata(dev);
+	struct backlight_device *bd = NULL;
+	int brightness, rc;
+
+	rc = strict_strtoul(buf, 0, (unsigned long *)&lcd->gamma_mode);
+	if (rc < 0)
+		return rc;
+
+	bd = lcd->bd;
+
+	brightness = bd->props.brightness;
+
+	switch (lcd->gamma_mode) {
+	case 0:
+		_s6e63m0_gamma_ctl(lcd, gamma_table.gamma_22_table[brightness]);
+		break;
+	case 1:
+		_s6e63m0_gamma_ctl(lcd, gamma_table.gamma_19_table[brightness]);
+		break;
+	case 2:
+		_s6e63m0_gamma_ctl(lcd, gamma_table.gamma_17_table[brightness]);
+		break;
+	default:
+		dev_info(dev, "gamma mode could be 0:2.2, 1:1.9 or 2:1.7\n");
+		_s6e63m0_gamma_ctl(lcd, gamma_table.gamma_22_table[brightness]);
+		break;
+	}
+	return len;
+}
+
+static DEVICE_ATTR(gamma_mode, 0644,
+		s6e63m0_sysfs_show_gamma_mode, s6e63m0_sysfs_store_gamma_mode);
+
+static int s6e63m0_sysfs_show_gamma_table(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct s6e63m0 *lcd = dev_get_drvdata(dev);
+	char temp[3];
+
+	sprintf(temp, "%d\n", lcd->gamma_table_count);
+	strcpy(buf, temp);
+
+	return strlen(buf);
+}
+static DEVICE_ATTR(gamma_table, 0644,
+		s6e63m0_sysfs_show_gamma_table, NULL);
+
+static int __init s6e63m0_probe(struct spi_device *spi)
+{
+	int ret = 0;
+	struct s6e63m0 *lcd = NULL;
+	struct lcd_device *ld = NULL;
+	struct backlight_device *bd = NULL;
+
+	lcd = kzalloc(sizeof(struct s6e63m0), GFP_KERNEL);
+	if (!lcd)
+		return -ENOMEM;
+
+	/* s6e63m0 lcd panel uses 3-wire 9bits SPI Mode. */
+	spi->bits_per_word = 9;
+
+	ret = spi_setup(spi);
+	if (ret < 0) {
+		dev_err(&spi->dev, "spi setup failed.\n");
+		goto out_free_lcd;
+	}
+
+	lcd->spi = spi;
+	lcd->dev = &spi->dev;
+
+	lcd->lcd_pd = (struct lcd_platform_data *)spi->dev.platform_data;
+	if (!lcd->lcd_pd) {
+		dev_err(&spi->dev, "platform data is NULL.\n");
+		goto out_free_lcd;
+	}
+
+	ld = lcd_device_register("s6e63m0", &spi->dev, lcd, &s6e63m0_lcd_ops);
+	if (IS_ERR(ld)) {
+		ret = PTR_ERR(ld);
+		goto out_free_lcd;
+	}
+
+	lcd->ld = ld;
+
+	bd = backlight_device_register("s6e63m0bl-bl", &spi->dev, lcd,
+		&s6e63m0_backlight_ops, NULL);
+	if (IS_ERR(bd)) {
+		ret =  PTR_ERR(bd);
+		goto out_lcd_unregister;
+	}
+
+	bd->props.max_brightness = MAX_BRIGHTNESS;
+	bd->props.brightness = MAX_BRIGHTNESS;
+	lcd->bd = bd;
+
+	/*
+	 * it gets gamma table count available so it gets user
+	 * know that.
+	 */
+	lcd->gamma_table_count =
+	    sizeof(gamma_table) / (MAX_GAMMA_LEVEL * sizeof(int));
+
+	ret = device_create_file(&(spi->dev), &dev_attr_gamma_mode);
+	if (ret < 0)
+		dev_err(&(spi->dev), "failed to add sysfs entries\n");
+
+	ret = device_create_file(&(spi->dev), &dev_attr_gamma_table);
+	if (ret < 0)
+		dev_err(&(spi->dev), "failed to add sysfs entries\n");
+
+	/*
+	 * if lcd panel was on from bootloader like u-boot then
+	 * do not lcd on.
+	 */
+	if (!lcd->lcd_pd->lcd_enabled) {
+		/*
+		 * if lcd panel was off from bootloader then
+		 * current lcd status is powerdown and then
+		 * it enables lcd panel.
+		 */
+		lcd->power = FB_BLANK_POWERDOWN;
+
+		s6e63m0_power(lcd, FB_BLANK_UNBLANK);
+	} else
+		lcd->power = FB_BLANK_UNBLANK;
+
+	dev_set_drvdata(&spi->dev, lcd);
+
+	dev_info(&spi->dev, "s6e63m0 panel driver has been probed.\n");
+
+	return 0;
+
+out_lcd_unregister:
+	lcd_device_unregister(ld);
+out_free_lcd:
+	kfree(lcd);
+	return ret;
+}
+
+static int __devexit s6e63m0_remove(struct spi_device *spi)
+{
+	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+
+	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
+	lcd_device_unregister(lcd->ld);
+	kfree(lcd);
+
+	return 0;
+}
+
+#if defined(CONFIG_PM)
+unsigned int before_power;
+
+static int s6e63m0_suspend(struct spi_device *spi, pm_message_t mesg)
+{
+	int ret = 0;
+	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+
+	before_power = lcd->power;
+
+	/*
+	 * when lcd panel is suspend, lcd panel becomes off
+	 * regardless of status.
+	 */
+	ret = s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
+
+	return ret;
+}
+
+static int s6e63m0_resume(struct spi_device *spi)
+{
+	int ret = 0;
+	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+
+	/*
+	 * after suspended, if lcd panel status is FB_BLANK_UNBLANK
+	 * (at that time, before_power is FB_BLANK_UNBLANK) then
+	 * it changes that status to FB_BLANK_POWERDOWN to get lcd on.
+	 */
+	if (before_power == FB_BLANK_UNBLANK)
+		lcd->power = FB_BLANK_POWERDOWN;
+
+	dev_dbg(&spi->dev, "before_power = %d\n", before_power);
+
+	ret = s6e63m0_power(lcd, before_power);
+
+	return ret;
+}
+#else
+#define s6e63m0_suspend		NULL
+#define s6e63m0_resume		NULL
+#endif
+
+/* Power down all displays on reboot, poweroff or halt. */
+static void s6e63m0_shutdown(struct spi_device *spi)
+{
+	struct s6e63m0 *lcd = dev_get_drvdata(&spi->dev);
+
+	s6e63m0_power(lcd, FB_BLANK_POWERDOWN);
+}
+
+static struct spi_driver s6e63m0_driver = {
+	.driver = {
+		.name	= "s6e63m0",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= s6e63m0_probe,
+	.remove		= __devexit_p(s6e63m0_remove),
+	.shutdown	= s6e63m0_shutdown,
+	.suspend	= s6e63m0_suspend,
+	.resume		= s6e63m0_resume,
+};
+
+static int __init s6e63m0_init(void)
+{
+	return spi_register_driver(&s6e63m0_driver);
+}
+
+static void __exit s6e63m0_exit(void)
+{
+	spi_unregister_driver(&s6e63m0_driver);
+}
+
+module_init(s6e63m0_init);
+module_exit(s6e63m0_exit);
+
+MODULE_AUTHOR("InKi Dae <inki.dae@samsung.com>");
+MODULE_DESCRIPTION("S6E63M0 LCD Driver");
+MODULE_LICENSE("GPL");
+
diff -puN /dev/null drivers/video/backlight/s6e63m0_gamma.h
--- /dev/null
+++ a/drivers/video/backlight/s6e63m0_gamma.h
@@ -0,0 +1,266 @@
+/* linux/drivers/video/samsung/s6e63m0_brightness.h
+ *
+ * Gamma level definitions.
+ *
+ * Copyright (c) 2009 Samsung Electronics
+ * InKi Dae <inki.dae@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef _S6E63M0_BRIGHTNESS_H
+#define _S6E63M0_BRIGHTNESS_H
+
+#define MAX_GAMMA_LEVEL		11
+#define GAMMA_TABLE_COUNT	21
+
+/* gamma value: 2.2 */
+static const unsigned int s6e63m0_22_300[] = {
+	0x18, 0x08, 0x24, 0x5f, 0x50, 0x2d, 0xB6,
+	0xB9, 0xA7, 0xAd, 0xB1, 0x9f, 0xbe, 0xC0,
+	0xB5, 0x00, 0xa0, 0x00, 0xa4, 0x00, 0xdb
+};
+
+static const unsigned int s6e63m0_22_280[] = {
+	0x18, 0x08, 0x24, 0x64, 0x56, 0x33, 0xB6,
+	0xBA, 0xA8, 0xAC, 0xB1, 0x9D, 0xC1, 0xC1,
+	0xB7, 0x00, 0x9C, 0x00, 0x9F, 0x00, 0xD6
+};
+
+static const unsigned int s6e63m0_22_260[] = {
+	0x18, 0x08, 0x24, 0x66, 0x58, 0x34, 0xB6,
+	0xBA, 0xA7, 0xAF, 0xB3, 0xA0, 0xC1, 0xC2,
+	0xB7, 0x00, 0x97, 0x00, 0x9A, 0x00, 0xD1
+
+};
+
+static const unsigned int s6e63m0_22_240[] = {
+	0x18, 0x08, 0x24, 0x62, 0x54, 0x30, 0xB9,
+	0xBB, 0xA9, 0xB0, 0xB3, 0xA1, 0xC1, 0xC3,
+	0xB7, 0x00, 0x91, 0x00, 0x95, 0x00, 0xDA
+
+};
+static const unsigned int s6e63m0_22_220[] = {
+	0x18, 0x08, 0x24, 0x63, 0x53, 0x31, 0xB8,
+	0xBC, 0xA9, 0xB0, 0xB5, 0xA2, 0xC4, 0xC4,
+	0xB8, 0x00, 0x8B, 0x00, 0x8E, 0x00, 0xC2
+};
+
+static const unsigned int s6e63m0_22_200[] = {
+	0x18, 0x08, 0x24, 0x66, 0x55, 0x34, 0xBA,
+	0xBD, 0xAB, 0xB1, 0xB5, 0xA3, 0xC5, 0xC6,
+	0xB9, 0x00, 0x85, 0x00, 0x88, 0x00, 0xBA
+};
+
+static const unsigned int s6e63m0_22_170[] = {
+	0x18, 0x08, 0x24, 0x69, 0x54, 0x37, 0xBB,
+	0xBE, 0xAC, 0xB4, 0xB7, 0xA6, 0xC7, 0xC8,
+	0xBC, 0x00, 0x7B, 0x00, 0x7E, 0x00, 0xAB
+};
+
+static const unsigned int s6e63m0_22_140[] = {
+	0x18, 0x08, 0x24, 0x6C, 0x54, 0x3A, 0xBC,
+	0xBF, 0xAC, 0xB7, 0xBB, 0xA9, 0xC9, 0xC9,
+	0xBE, 0x00, 0x71, 0x00, 0x73, 0x00, 0x9E
+};
+
+static const unsigned int s6e63m0_22_110[] = {
+	0x18, 0x08, 0x24, 0x70, 0x51, 0x3E, 0xBF,
+	0xC1, 0xAF, 0xB9, 0xBC, 0xAB, 0xCC, 0xCC,
+	0xC2, 0x00, 0x65, 0x00, 0x67, 0x00, 0x8D
+};
+
+static const unsigned int s6e63m0_22_90[] = {
+	0x18, 0x08, 0x24, 0x73, 0x4A, 0x3D, 0xC0,
+	0xC2, 0xB1, 0xBB, 0xBE, 0xAC, 0xCE, 0xCF,
+	0xC5, 0x00, 0x5D, 0x00, 0x5E, 0x00, 0x82
+};
+
+static const unsigned int s6e63m0_22_30[] = {
+	0x18, 0x08, 0x24, 0x78, 0xEC, 0x3D, 0xC8,
+	0xC2, 0xB6, 0xC4, 0xC7, 0xB6, 0xD5, 0xD7,
+	0xCC, 0x00, 0x39, 0x00, 0x36, 0x00, 0x51
+};
+
+/* gamma value: 1.9 */
+static const unsigned int s6e63m0_19_300[] = {
+	0x18, 0x08, 0x24, 0x61, 0x5F, 0x39, 0xBA,
+	0xBD, 0xAD, 0xB1, 0xB6, 0xA5, 0xC4, 0xC5,
+	0xBC, 0x00, 0xA0, 0x00, 0xA4, 0x00, 0xDB
+};
+
+static const unsigned int s6e63m0_19_280[] = {
+	0x18, 0x08, 0x24, 0x61, 0x60, 0x39, 0xBB,
+	0xBE, 0xAD, 0xB2, 0xB6, 0xA6, 0xC5, 0xC7,
+	0xBD, 0x00, 0x9B, 0x00, 0x9E, 0x00, 0xD5
+};
+
+static const unsigned int s6e63m0_19_260[] = {
+	0x18, 0x08, 0x24, 0x63, 0x61, 0x3B, 0xBA,
+	0xBE, 0xAC, 0xB3, 0xB8, 0xA7, 0xC6, 0xC8,
+	0xBD, 0x00, 0x96, 0x00, 0x98, 0x00, 0xCF
+};
+
+static const unsigned int s6e63m0_19_240[] = {
+	0x18, 0x08, 0x24, 0x67, 0x64, 0x3F, 0xBB,
+	0xBE, 0xAD, 0xB3, 0xB9, 0xA7, 0xC8, 0xC9,
+	0xBE, 0x00, 0x90, 0x00, 0x92, 0x00, 0xC8
+};
+
+static const unsigned int s6e63m0_19_220[] = {
+	0x18, 0x08, 0x24, 0x68, 0x64, 0x40, 0xBC,
+	0xBF, 0xAF, 0xB4, 0xBA, 0xA9, 0xC8, 0xCA,
+	0xBE, 0x00, 0x8B, 0x00, 0x8C, 0x00, 0xC0
+};
+
+static const unsigned int s6e63m0_19_200[] = {
+	0x18, 0x08, 0x24, 0x68, 0x64, 0x3F, 0xBE,
+	0xC0, 0xB0, 0xB6, 0xBB, 0xAB, 0xC8, 0xCB,
+	0xBF, 0x00, 0x85, 0x00, 0x86, 0x00, 0xB8
+};
+
+static const unsigned int s6e63m0_19_170[] = {
+	0x18, 0x08, 0x24, 0x69, 0x64, 0x40, 0xBF,
+	0xC1, 0xB0, 0xB9, 0xBE, 0xAD, 0xCB, 0xCD,
+	0xC2, 0x00, 0x7A, 0x00, 0x7B, 0x00, 0xAA
+};
+
+static const unsigned int s6e63m0_19_140[] = {
+	0x18, 0x08, 0x24, 0x6E, 0x65, 0x45, 0xC0,
+	0xC3, 0xB2, 0xBA, 0xBE, 0xAE, 0xCD, 0xD0,
+	0xC4, 0x00, 0x70, 0x00, 0x70, 0x00, 0x9C
+};
+
+static const unsigned int s6e63m0_19_110[] = {
+	0x18, 0x08, 0x24, 0x6F, 0x65, 0x46, 0xC2,
+	0xC4, 0xB3, 0xBF, 0xC2, 0xB2, 0xCF, 0xD1,
+	0xC6, 0x00, 0x64, 0x00, 0x64, 0x00, 0x8D
+};
+
+static const unsigned int s6e63m0_19_90[] = {
+	0x18, 0x08, 0x24, 0x74, 0x60, 0x4A, 0xC3,
+	0xC6, 0xB5, 0xBF, 0xC3, 0xB2, 0xD2, 0xD3,
+	0xC8, 0x00, 0x5B, 0x00, 0x5B, 0x00, 0x81
+};
+
+static const unsigned int s6e63m0_19_30[] = {
+	0x18, 0x08, 0x24, 0x84, 0x45, 0x4F, 0xCA,
+	0xCB, 0xBC, 0xC9, 0xCB, 0xBC, 0xDA, 0xDA,
+	0xD0, 0x00, 0x35, 0x00, 0x34, 0x00, 0x4E
+};
+
+/* gamma value: 1.7 */
+static const unsigned int s6e63m0_17_300[] = {
+	0x18, 0x08, 0x24, 0x70, 0x70, 0x4F, 0xBF,
+	0xC2, 0xB2, 0xB8, 0xBC, 0xAC, 0xCB, 0xCD,
+	0xC3, 0x00, 0xA0, 0x00, 0xA4, 0x00, 0xDB
+};
+
+static const unsigned int s6e63m0_17_280[] = {
+	0x18, 0x08, 0x24, 0x71, 0x71, 0x50, 0xBF,
+	0xC2, 0xB2, 0xBA, 0xBE, 0xAE, 0xCB, 0xCD,
+	0xC3, 0x00, 0x9C, 0x00, 0x9F, 0x00, 0xD6
+};
+
+static const unsigned int s6e63m0_17_260[] = {
+	0x18, 0x08, 0x24, 0x72, 0x72, 0x50, 0xC0,
+	0xC3, 0xB4, 0xB9, 0xBE, 0xAE, 0xCC, 0xCF,
+	0xC4, 0x00, 0x97, 0x00, 0x9A, 0x00, 0xD1
+};
+
+static const unsigned int s6e63m0_17_240[] = {
+	0x18, 0x08, 0x24, 0x71, 0x72, 0x4F, 0xC2,
+	0xC4, 0xB5, 0xBB, 0xBF, 0xB0, 0xCC, 0xCF,
+	0xC3, 0x00, 0x91, 0x00, 0x95, 0x00, 0xCA
+};
+
+static const unsigned int s6e63m0_17_220[] = {
+	0x18, 0x08, 0x24, 0x71, 0x73, 0x4F, 0xC2,
+	0xC5, 0xB5, 0xBD, 0xC0, 0xB2, 0xCD, 0xD1,
+	0xC5, 0x00, 0x8B, 0x00, 0x8E, 0x00, 0xC2
+};
+
+static const unsigned int s6e63m0_17_200[] = {
+	0x18, 0x08, 0x24, 0x72, 0x75, 0x51, 0xC2,
+	0xC6, 0xB5, 0xBF, 0xC1, 0xB3, 0xCE, 0xD1,
+	0xC6, 0x00, 0x85, 0x00, 0x88, 0x00, 0xBA
+};
+
+static const unsigned int s6e63m0_17_170[] = {
+	0x18, 0x08, 0x24, 0x75, 0x77, 0x54, 0xC3,
+	0xC7, 0xB7, 0xC0, 0xC3, 0xB4, 0xD1, 0xD3,
+	0xC9, 0x00, 0x7B, 0x00, 0x7E, 0x00, 0xAB
+};
+
+static const unsigned int s6e63m0_17_140[] = {
+	0x18, 0x08, 0x24, 0x7B, 0x77, 0x58, 0xC3,
+	0xC8, 0xB8, 0xC2, 0xC6, 0xB6, 0xD3, 0xD4,
+	0xCA, 0x00, 0x71, 0x00, 0x73, 0x00, 0x9E
+};
+
+static const unsigned int s6e63m0_17_110[] = {
+	0x18, 0x08, 0x24, 0x81, 0x7B, 0x5D, 0xC6,
+	0xCA, 0xBB, 0xC3, 0xC7, 0xB8, 0xD6, 0xD8,
+	0xCD, 0x00, 0x65, 0x00, 0x67, 0x00, 0x8D
+};
+
+static const unsigned int s6e63m0_17_90[] = {
+	0x18, 0x08, 0x24, 0x82, 0x7A, 0x5B, 0xC8,
+	0xCB, 0xBD, 0xC5, 0xCA, 0xBA, 0xD6, 0xD8,
+	0xCE, 0x00, 0x5D, 0x00, 0x5E, 0x00, 0x82
+};
+
+static const unsigned int s6e63m0_17_30[] = {
+	0x18, 0x08, 0x24, 0x8F, 0x73, 0x63, 0xD1,
+	0xD0, 0xC5, 0xCC, 0xD1, 0xC2, 0xDE, 0xE0,
+	0xD6, 0x00, 0x39, 0x00, 0x36, 0x00, 0x51
+};
+
+struct s6e63m0_gamma {
+	unsigned int *gamma_22_table[MAX_GAMMA_LEVEL];
+	unsigned int *gamma_19_table[MAX_GAMMA_LEVEL];
+	unsigned int *gamma_17_table[MAX_GAMMA_LEVEL];
+};
+
+static struct s6e63m0_gamma gamma_table = {
+	.gamma_22_table[0] = (unsigned int *)&s6e63m0_22_30,
+	.gamma_22_table[1] = (unsigned int *)&s6e63m0_22_90,
+	.gamma_22_table[2] = (unsigned int *)&s6e63m0_22_110,
+	.gamma_22_table[3] = (unsigned int *)&s6e63m0_22_140,
+	.gamma_22_table[4] = (unsigned int *)&s6e63m0_22_170,
+	.gamma_22_table[5] = (unsigned int *)&s6e63m0_22_200,
+	.gamma_22_table[6] = (unsigned int *)&s6e63m0_22_220,
+	.gamma_22_table[7] = (unsigned int *)&s6e63m0_22_240,
+	.gamma_22_table[8] = (unsigned int *)&s6e63m0_22_260,
+	.gamma_22_table[9] = (unsigned int *)&s6e63m0_22_280,
+	.gamma_22_table[10] = (unsigned int *)&s6e63m0_22_300,
+
+	.gamma_19_table[0] = (unsigned int *)&s6e63m0_19_30,
+	.gamma_19_table[1] = (unsigned int *)&s6e63m0_19_90,
+	.gamma_19_table[2] = (unsigned int *)&s6e63m0_19_110,
+	.gamma_19_table[3] = (unsigned int *)&s6e63m0_19_140,
+	.gamma_19_table[4] = (unsigned int *)&s6e63m0_19_170,
+	.gamma_19_table[5] = (unsigned int *)&s6e63m0_19_200,
+	.gamma_19_table[6] = (unsigned int *)&s6e63m0_19_220,
+	.gamma_19_table[7] = (unsigned int *)&s6e63m0_19_240,
+	.gamma_19_table[8] = (unsigned int *)&s6e63m0_19_260,
+	.gamma_19_table[9] = (unsigned int *)&s6e63m0_19_280,
+	.gamma_19_table[10] = (unsigned int *)&s6e63m0_19_300,
+
+	.gamma_17_table[0] = (unsigned int *)&s6e63m0_17_30,
+	.gamma_17_table[1] = (unsigned int *)&s6e63m0_17_90,
+	.gamma_17_table[2] = (unsigned int *)&s6e63m0_17_110,
+	.gamma_17_table[3] = (unsigned int *)&s6e63m0_17_140,
+	.gamma_17_table[4] = (unsigned int *)&s6e63m0_17_170,
+	.gamma_17_table[5] = (unsigned int *)&s6e63m0_17_200,
+	.gamma_17_table[6] = (unsigned int *)&s6e63m0_17_220,
+	.gamma_17_table[7] = (unsigned int *)&s6e63m0_17_240,
+	.gamma_17_table[8] = (unsigned int *)&s6e63m0_17_260,
+	.gamma_17_table[9] = (unsigned int *)&s6e63m0_17_280,
+	.gamma_17_table[10] = (unsigned int *)&s6e63m0_17_300,
+};
+
+#endif
+
diff -puN include/linux/lcd.h~backlight-add-s6e63m0-amoled-lcd-panel-driver include/linux/lcd.h
--- a/include/linux/lcd.h~backlight-add-s6e63m0-amoled-lcd-panel-driver
+++ a/include/linux/lcd.h
@@ -69,6 +69,29 @@ struct lcd_device {
 	struct device dev;
 };
 
+struct lcd_platform_data {
+	/* reset lcd panel device. */
+	int (*reset)(struct lcd_device *ld);
+	/* on or off to lcd panel. if 'enable' is 0 then
+	   lcd power off and 1, lcd power on. */
+	int (*power_on)(struct lcd_device *ld, int enable);
+
+	/* it indicates whether lcd panel was enabled
+	   from bootloader or not. */
+	int lcd_enabled;
+	/* it means delay for stable time when it becomes low to high
+	   or high to low that is dependent on whether reset gpio is
+	   low active or high active. */
+	unsigned int reset_delay;
+	/* stable time needing to become lcd power on. */
+	unsigned int power_on_delay;
+	/* stable time needing to become lcd power off. */
+	unsigned int power_off_delay;
+
+	/* it could be used for any purpose. */
+	void *pdata;
+};
+
 static inline void lcd_set_power(struct lcd_device *ld, int power)
 {
 	mutex_lock(&ld->update_lock);
_

Patches currently in -mm which might be from daeinki@gmail.com are

backlight-add-s6e63m0-amoled-lcd-panel-driver.patch

