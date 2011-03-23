From: akpm@linux-foundation.org
Subject: [merged] drivers-vidfeo-backlight-ld9040-amoled-driver-support.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:00 -0700
Message-ID: <201103232036.p2NKaas1028139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933426Ab1CWUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh09.lee@samsung.com, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/vidfeo/backlight: ld9040 amoled driver support
has been removed from the -mm tree.  Its filename was
     drivers-vidfeo-backlight-ld9040-amoled-driver-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/vidfeo/backlight: ld9040 amoled driver support
From: Donghwa Lee <dh09.lee@samsung.com>

Add a ld9040 amoled panel driver.

Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Kconfig        |    8 
 drivers/video/backlight/Makefile       |    1 
 drivers/video/backlight/ld9040.c       |  820 +++++++++++++++++++++++
 drivers/video/backlight/ld9040_gamma.h |  201 +++++
 4 files changed, 1030 insertions(+)

diff -puN drivers/video/backlight/Kconfig~drivers-vidfeo-backlight-ld9040-amoled-driver-support drivers/video/backlight/Kconfig
--- a/drivers/video/backlight/Kconfig~drivers-vidfeo-backlight-ld9040-amoled-driver-support
+++ a/drivers/video/backlight/Kconfig
@@ -109,6 +109,14 @@ config LCD_S6E63M0
 	  If you have an S6E63M0 LCD Panel, say Y to enable its
 	  LCD control driver.
 
+config LCD_LD9040
+	tristate "LD9040 AMOLED LCD Driver"
+	depends on SPI && BACKLIGHT_CLASS_DEVICE
+	default n
+	help
+	  If you have an LD9040 Panel, say Y to enable its
+	  control driver.
+
 endif # LCD_CLASS_DEVICE
 
 #
diff -puN drivers/video/backlight/Makefile~drivers-vidfeo-backlight-ld9040-amoled-driver-support drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~drivers-vidfeo-backlight-ld9040-amoled-driver-support
+++ a/drivers/video/backlight/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_LCD_VGG2432A4)	   += vgg243
 obj-$(CONFIG_LCD_TDO24M)	   += tdo24m.o
 obj-$(CONFIG_LCD_TOSA)		   += tosa_lcd.o
 obj-$(CONFIG_LCD_S6E63M0)	+= s6e63m0.o
+obj-$(CONFIG_LCD_LD9040)	+= ld9040.o
 
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
 obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)    += atmel-pwm-bl.o
diff -puN /dev/null drivers/video/backlight/ld9040.c
--- /dev/null
+++ a/drivers/video/backlight/ld9040.c
@@ -0,0 +1,820 @@
+/*
+ * ld9040 AMOLED LCD panel driver.
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ * Author: Donghwa Lee  <dh09.lee@samsung.com>
+ * Derived from drivers/video/backlight/s6e63m0.c
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
+#include "ld9040_gamma.h"
+
+#define SLEEPMSEC		0x1000
+#define ENDDEF			0x2000
+#define	DEFMASK			0xFF00
+#define COMMAND_ONLY		0xFE
+#define DATA_ONLY		0xFF
+
+#define MIN_BRIGHTNESS		0
+#define MAX_BRIGHTNESS		24
+#define power_is_on(pwr)	((pwr) <= FB_BLANK_NORMAL)
+
+struct ld9040 {
+	struct device			*dev;
+	struct spi_device		*spi;
+	unsigned int			power;
+	unsigned int			current_brightness;
+
+	struct lcd_device		*ld;
+	struct backlight_device		*bd;
+	struct lcd_platform_data	*lcd_pd;
+};
+
+static const unsigned short seq_swreset[] = {
+	0x01, COMMAND_ONLY,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_user_setting[] = {
+	0xF0, 0x5A,
+
+	DATA_ONLY, 0x5A,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_elvss_on[] = {
+	0xB1, 0x0D,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x16,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_gtcon[] = {
+	0xF7, 0x09,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_panel_condition[] = {
+	0xF8, 0x05,
+
+	DATA_ONLY, 0x65,
+	DATA_ONLY, 0x96,
+	DATA_ONLY, 0x71,
+	DATA_ONLY, 0x7D,
+	DATA_ONLY, 0x19,
+	DATA_ONLY, 0x3B,
+	DATA_ONLY, 0x0D,
+	DATA_ONLY, 0x19,
+	DATA_ONLY, 0x7E,
+	DATA_ONLY, 0x0D,
+	DATA_ONLY, 0xE2,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x7E,
+	DATA_ONLY, 0x7D,
+	DATA_ONLY, 0x07,
+	DATA_ONLY, 0x07,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x20,
+	DATA_ONLY, 0x02,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_gamma_set1[] = {
+	0xF9, 0x00,
+
+	DATA_ONLY, 0xA7,
+	DATA_ONLY, 0xB4,
+	DATA_ONLY, 0xAE,
+	DATA_ONLY, 0xBF,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x91,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0xB2,
+	DATA_ONLY, 0xB4,
+	DATA_ONLY, 0xAA,
+	DATA_ONLY, 0xBB,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0xAC,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0xB3,
+	DATA_ONLY, 0xB1,
+	DATA_ONLY, 0xAA,
+	DATA_ONLY, 0xBC,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0xB3,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_gamma_ctrl[] = {
+	0xFB, 0x02,
+
+	DATA_ONLY, 0x5A,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_gamma_start[] = {
+	0xF9, COMMAND_ONLY,
+
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_apon[] = {
+	0xF3, 0x00,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x0A,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_display_ctrl[] = {
+	0xF2, 0x02,
+
+	DATA_ONLY, 0x08,
+	DATA_ONLY, 0x08,
+	DATA_ONLY, 0x10,
+	DATA_ONLY, 0x10,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_manual_pwr[] = {
+	0xB0, 0x04,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_pwr_ctrl[] = {
+	0xF4, 0x0A,
+
+	DATA_ONLY, 0x87,
+	DATA_ONLY, 0x25,
+	DATA_ONLY, 0x6A,
+	DATA_ONLY, 0x44,
+	DATA_ONLY, 0x02,
+	DATA_ONLY, 0x88,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_sleep_out[] = {
+	0x11, COMMAND_ONLY,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_sleep_in[] = {
+	0x10, COMMAND_ONLY,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_display_on[] = {
+	0x29, COMMAND_ONLY,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_display_off[] = {
+	0x28, COMMAND_ONLY,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vci1_1st_en[] = {
+	0xF3, 0x10,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vl1_en[] = {
+	0xF3, 0x11,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vl2_en[] = {
+	0xF3, 0x13,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vci1_2nd_en[] = {
+	0xF3, 0x33,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vl3_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vreg1_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0x01,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vgh_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0x11,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vgl_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0x31,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x02,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vmos_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xB1,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vint_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xF1,
+	/* DATA_ONLY, 0x71,	VMOS/VBL/VBH not used */
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	/* DATA_ONLY, 0x02,	VMOS/VBL/VBH not used */
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vbh_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xF9,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_vbl_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xFD,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_gam_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xFF,
+	/* DATA_ONLY, 0x73,	VMOS/VBL/VBH not used */
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	/* DATA_ONLY, 0x02,	VMOS/VBL/VBH not used */
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_sd_amp_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xFF,
+	/* DATA_ONLY, 0x73,	VMOS/VBL/VBH not used */
+	DATA_ONLY, 0x80,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	/* DATA_ONLY, 0x02,	VMOS/VBL/VBH not used */
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_gls_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xFF,
+	/* DATA_ONLY, 0x73,	VMOS/VBL/VBH not used */
+	DATA_ONLY, 0x81,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	/* DATA_ONLY, 0x02,	VMOS/VBL/VBH not used */
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_els_en[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xFF,
+	/* DATA_ONLY, 0x73,	VMOS/VBL/VBH not used */
+	DATA_ONLY, 0x83,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	/* DATA_ONLY, 0x02,	VMOS/VBL/VBH not used */
+	ENDDEF, 0x00
+};
+
+static const unsigned short seq_el_on[] = {
+	0xF3, 0x37,
+
+	DATA_ONLY, 0xFF,
+	/* DATA_ONLY, 0x73,	VMOS/VBL/VBH not used */
+	DATA_ONLY, 0x87,
+	DATA_ONLY, 0x00,
+	DATA_ONLY, 0x03,
+	/* DATA_ONLY, 0x02,	VMOS/VBL/VBH not used */
+	ENDDEF, 0x00
+};
+
+static int ld9040_spi_write_byte(struct ld9040 *lcd, int addr, int data)
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
+static int ld9040_spi_write(struct ld9040 *lcd, unsigned char address,
+	unsigned char command)
+{
+	int ret = 0;
+
+	if (address != DATA_ONLY)
+		ret = ld9040_spi_write_byte(lcd, 0x0, address);
+	if (command != COMMAND_ONLY)
+		ret = ld9040_spi_write_byte(lcd, 0x1, command);
+
+	return ret;
+}
+
+static int ld9040_panel_send_sequence(struct ld9040 *lcd,
+	const unsigned short *wbuf)
+{
+	int ret = 0, i = 0;
+
+	while ((wbuf[i] & DEFMASK) != ENDDEF) {
+		if ((wbuf[i] & DEFMASK) != SLEEPMSEC) {
+			ret = ld9040_spi_write(lcd, wbuf[i], wbuf[i+1]);
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
+static int _ld9040_gamma_ctl(struct ld9040 *lcd, const unsigned int *gamma)
+{
+	unsigned int i = 0;
+	int ret = 0;
+
+	/* start gamma table updating. */
+	ret = ld9040_panel_send_sequence(lcd, seq_gamma_start);
+	if (ret) {
+		dev_err(lcd->dev, "failed to disable gamma table updating.\n");
+		goto gamma_err;
+	}
+
+	for (i = 0 ; i < GAMMA_TABLE_COUNT; i++) {
+		ret = ld9040_spi_write(lcd, DATA_ONLY, gamma[i]);
+		if (ret) {
+			dev_err(lcd->dev, "failed to set gamma table.\n");
+			goto gamma_err;
+		}
+	}
+
+	/* update gamma table. */
+	ret = ld9040_panel_send_sequence(lcd, seq_gamma_ctrl);
+	if (ret)
+		dev_err(lcd->dev, "failed to update gamma table.\n");
+
+gamma_err:
+	return ret;
+}
+
+static int ld9040_gamma_ctl(struct ld9040 *lcd, int gamma)
+{
+	int ret = 0;
+
+	ret = _ld9040_gamma_ctl(lcd, gamma_table.gamma_22_table[gamma]);
+
+	return ret;
+}
+
+
+static int ld9040_ldi_init(struct ld9040 *lcd)
+{
+	int ret, i;
+	static const unsigned short *init_seq[] = {
+		seq_user_setting,
+		seq_panel_condition,
+		seq_display_ctrl,
+		seq_manual_pwr,
+		seq_elvss_on,
+		seq_gtcon,
+		seq_gamma_set1,
+		seq_gamma_ctrl,
+		seq_sleep_out,
+	};
+
+	for (i = 0; i < ARRAY_SIZE(init_seq); i++) {
+		ret = ld9040_panel_send_sequence(lcd, init_seq[i]);
+		/* workaround: minimum delay time for transferring CMD */
+		udelay(300);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int ld9040_ldi_enable(struct ld9040 *lcd)
+{
+	int ret = 0;
+
+	ret = ld9040_panel_send_sequence(lcd, seq_display_on);
+
+	return ret;
+}
+
+static int ld9040_ldi_disable(struct ld9040 *lcd)
+{
+	int ret;
+
+	ret = ld9040_panel_send_sequence(lcd, seq_display_off);
+	ret = ld9040_panel_send_sequence(lcd, seq_sleep_in);
+
+	return ret;
+}
+
+static int ld9040_power_on(struct ld9040 *lcd)
+{
+	int ret = 0;
+	struct lcd_platform_data *pd = NULL;
+	pd = lcd->lcd_pd;
+	if (!pd) {
+		dev_err(lcd->dev, "platform data is NULL.\n");
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
+	ret = ld9040_ldi_init(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "failed to initialize ldi.\n");
+		return ret;
+	}
+
+	ret = ld9040_ldi_enable(lcd);
+	if (ret) {
+		dev_err(lcd->dev, "failed to enable ldi.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ld9040_power_off(struct ld9040 *lcd)
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
+	ret = ld9040_ldi_disable(lcd);
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
+static int ld9040_power(struct ld9040 *lcd, int power)
+{
+	int ret = 0;
+
+	if (power_is_on(power) && !power_is_on(lcd->power))
+		ret = ld9040_power_on(lcd);
+	else if (!power_is_on(power) && power_is_on(lcd->power))
+		ret = ld9040_power_off(lcd);
+
+	if (!ret)
+		lcd->power = power;
+
+	return ret;
+}
+
+static int ld9040_set_power(struct lcd_device *ld, int power)
+{
+	struct ld9040 *lcd = lcd_get_data(ld);
+
+	if (power != FB_BLANK_UNBLANK && power != FB_BLANK_POWERDOWN &&
+		power != FB_BLANK_NORMAL) {
+		dev_err(lcd->dev, "power value should be 0, 1 or 4.\n");
+		return -EINVAL;
+	}
+
+	return ld9040_power(lcd, power);
+}
+
+static int ld9040_get_power(struct lcd_device *ld)
+{
+	struct ld9040 *lcd = lcd_get_data(ld);
+
+	return lcd->power;
+}
+
+static int ld9040_get_brightness(struct backlight_device *bd)
+{
+	return bd->props.brightness;
+}
+
+static int ld9040_set_brightness(struct backlight_device *bd)
+{
+	int ret = 0, brightness = bd->props.brightness;
+	struct ld9040 *lcd = bl_get_data(bd);
+
+	if (brightness < MIN_BRIGHTNESS ||
+		brightness > bd->props.max_brightness) {
+		dev_err(&bd->dev, "lcd brightness should be %d to %d.\n",
+			MIN_BRIGHTNESS, MAX_BRIGHTNESS);
+		return -EINVAL;
+	}
+
+	ret = ld9040_gamma_ctl(lcd, bd->props.brightness);
+	if (ret) {
+		dev_err(&bd->dev, "lcd brightness setting failed.\n");
+		return -EIO;
+	}
+
+	return ret;
+}
+
+static struct lcd_ops ld9040_lcd_ops = {
+	.set_power = ld9040_set_power,
+	.get_power = ld9040_get_power,
+};
+
+static const struct backlight_ops ld9040_backlight_ops  = {
+	.get_brightness = ld9040_get_brightness,
+	.update_status = ld9040_set_brightness,
+};
+
+
+static int ld9040_probe(struct spi_device *spi)
+{
+	int ret = 0;
+	struct ld9040 *lcd = NULL;
+	struct lcd_device *ld = NULL;
+	struct backlight_device *bd = NULL;
+
+	lcd = kzalloc(sizeof(struct ld9040), GFP_KERNEL);
+	if (!lcd)
+		return -ENOMEM;
+
+	/* ld9040 lcd panel uses 3-wire 9bits SPI Mode. */
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
+	lcd->lcd_pd = spi->dev.platform_data;
+	if (!lcd->lcd_pd) {
+		dev_err(&spi->dev, "platform data is NULL.\n");
+		goto out_free_lcd;
+	}
+
+	ld = lcd_device_register("ld9040", &spi->dev, lcd, &ld9040_lcd_ops);
+	if (IS_ERR(ld)) {
+		ret = PTR_ERR(ld);
+		goto out_free_lcd;
+	}
+
+	lcd->ld = ld;
+
+	bd = backlight_device_register("ld9040-bl", &spi->dev,
+		lcd, &ld9040_backlight_ops, NULL);
+	if (IS_ERR(ld)) {
+		ret = PTR_ERR(ld);
+		goto out_free_lcd;
+	}
+
+	bd->props.max_brightness = MAX_BRIGHTNESS;
+	bd->props.brightness = MAX_BRIGHTNESS;
+	lcd->bd = bd;
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
+		ld9040_power(lcd, FB_BLANK_UNBLANK);
+	} else
+		lcd->power = FB_BLANK_UNBLANK;
+
+	dev_set_drvdata(&spi->dev, lcd);
+
+	dev_info(&spi->dev, "ld9040 panel driver has been probed.\n");
+	return 0;
+
+out_free_lcd:
+	kfree(lcd);
+	return ret;
+}
+
+static int __devexit ld9040_remove(struct spi_device *spi)
+{
+	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+
+	ld9040_power(lcd, FB_BLANK_POWERDOWN);
+	lcd_device_unregister(lcd->ld);
+	kfree(lcd);
+
+	return 0;
+}
+
+#if defined(CONFIG_PM)
+static int ld9040_suspend(struct spi_device *spi, pm_message_t mesg)
+{
+	int ret = 0;
+	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "lcd->power = %d\n", lcd->power);
+
+	/*
+	 * when lcd panel is suspend, lcd panel becomes off
+	 * regardless of status.
+	 */
+	ret = ld9040_power(lcd, FB_BLANK_POWERDOWN);
+
+	return ret;
+}
+
+static int ld9040_resume(struct spi_device *spi)
+{
+	int ret = 0;
+	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+
+	lcd->power = FB_BLANK_POWERDOWN;
+
+	ret = ld9040_power(lcd, FB_BLANK_UNBLANK);
+
+	return ret;
+}
+#else
+#define ld9040_suspend		NULL
+#define ld9040_resume		NULL
+#endif
+
+/* Power down all displays on reboot, poweroff or halt. */
+static void ld9040_shutdown(struct spi_device *spi)
+{
+	struct ld9040 *lcd = dev_get_drvdata(&spi->dev);
+
+	ld9040_power(lcd, FB_BLANK_POWERDOWN);
+}
+
+static struct spi_driver ld9040_driver = {
+	.driver = {
+		.name	= "ld9040",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= ld9040_probe,
+	.remove		= __devexit_p(ld9040_remove),
+	.shutdown	= ld9040_shutdown,
+	.suspend	= ld9040_suspend,
+	.resume		= ld9040_resume,
+};
+
+static int __init ld9040_init(void)
+{
+	return spi_register_driver(&ld9040_driver);
+}
+
+static void __exit ld9040_exit(void)
+{
+	spi_unregister_driver(&ld9040_driver);
+}
+
+module_init(ld9040_init);
+module_exit(ld9040_exit);
+
+MODULE_AUTHOR("Donghwa Lee <dh09.lee@samsung.com>");
+MODULE_DESCRIPTION("ld9040 LCD Driver");
+MODULE_LICENSE("GPL");
+
diff -puN /dev/null drivers/video/backlight/ld9040_gamma.h
--- /dev/null
+++ a/drivers/video/backlight/ld9040_gamma.h
@@ -0,0 +1,201 @@
+/*
+ * Gamma level definitions.
+ *
+ * Copyright (c) 2011 Samsung Electronics
+ * InKi Dae <inki.dae@samsung.com>
+ * Donghwa Lee <dh09.lee@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef _LD9040_BRIGHTNESS_H
+#define _LD9040_BRIGHTNESS_H
+
+#define MAX_GAMMA_LEVEL		25
+#define GAMMA_TABLE_COUNT	21
+
+/* gamma value: 2.2 */
+static const unsigned int ld9040_22_300[] = {
+	0x00, 0xa7, 0xb4, 0xae, 0xbf, 0x00, 0x91,
+	0x00, 0xb2, 0xb4, 0xaa, 0xbb, 0x00, 0xac,
+	0x00, 0xb3, 0xb1, 0xaa, 0xbc, 0x00, 0xb3
+};
+
+static const unsigned int ld9040_22_290[] = {
+	0x00, 0xa9, 0xb7, 0xae, 0xbd, 0x00, 0x89,
+	0x00, 0xb7, 0xb6, 0xa8, 0xba, 0x00, 0xa4,
+	0x00, 0xb1, 0xb4, 0xaa, 0xbb, 0x00, 0xaa
+};
+
+static const unsigned int ld9040_22_280[] = {
+	0x00, 0xa9, 0xb6, 0xad, 0xbf, 0x00, 0x86,
+	0x00, 0xb8, 0xb5, 0xa8, 0xbc, 0x00, 0xa0,
+	0x00, 0xb3, 0xb3, 0xa9, 0xbc, 0x00, 0xa7
+};
+
+static const unsigned int ld9040_22_270[] = {
+	0x00, 0xa8, 0xb8, 0xae, 0xbe, 0x00, 0x84,
+	0x00, 0xb9, 0xb7, 0xa8, 0xbc, 0x00, 0x9d,
+	0x00, 0xb2, 0xb5, 0xaa, 0xbc, 0x00, 0xa4
+
+};
+static const unsigned int ld9040_22_260[] = {
+	0x00, 0xa4, 0xb8, 0xb0, 0xbf, 0x00, 0x80,
+	0x00, 0xb8, 0xb6, 0xaa, 0xbc, 0x00, 0x9a,
+	0x00, 0xb0, 0xb5, 0xab, 0xbd, 0x00, 0xa0
+};
+
+static const unsigned int ld9040_22_250[] = {
+	0x00, 0xa4, 0xb9, 0xaf, 0xc1, 0x00, 0x7d,
+	0x00, 0xb9, 0xb6, 0xaa, 0xbb, 0x00, 0x97,
+	0x00, 0xb1, 0xb5, 0xaa, 0xbf, 0x00, 0x9d
+};
+
+static const unsigned int ld9040_22_240[] = {
+	0x00, 0xa2, 0xb9, 0xaf, 0xc2, 0x00, 0x7a,
+	0x00, 0xb9, 0xb7, 0xaa, 0xbd, 0x00, 0x94,
+	0x00, 0xb0, 0xb5, 0xab, 0xbf, 0x00, 0x9a
+};
+
+static const unsigned int ld9040_22_230[] = {
+	0x00, 0xa0, 0xb9, 0xaf, 0xc3, 0x00, 0x77,
+	0x00, 0xb9, 0xb7, 0xab, 0xbe, 0x00, 0x90,
+	0x00, 0xb0, 0xb6, 0xab, 0xbf, 0x00, 0x97
+};
+
+static const unsigned int ld9040_22_220[] = {
+	0x00, 0x9e, 0xba, 0xb0, 0xc2, 0x00, 0x75,
+	0x00, 0xb9, 0xb8, 0xab, 0xbe, 0x00, 0x8e,
+	0x00, 0xb0, 0xb6, 0xac, 0xbf, 0x00, 0x94
+};
+
+static const unsigned int ld9040_22_210[] = {
+	0x00, 0x9c, 0xb9, 0xb0, 0xc4, 0x00, 0x72,
+	0x00, 0xb8, 0xb8, 0xac, 0xbf, 0x00, 0x8a,
+	0x00, 0xb0, 0xb6, 0xac, 0xc0, 0x00, 0x91
+};
+
+static const unsigned int ld9040_22_200[] = {
+	0x00, 0x9a, 0xba, 0xb1, 0xc4, 0x00, 0x6f,
+	0x00, 0xb8, 0xb8, 0xad, 0xc0, 0x00, 0x86,
+	0x00, 0xb0, 0xb7, 0xad, 0xc0, 0x00, 0x8d
+};
+
+static const unsigned int ld9040_22_190[] = {
+	0x00, 0x97, 0xba, 0xb2, 0xc5, 0x00, 0x6c,
+	0x00, 0xb8, 0xb8, 0xae, 0xc1, 0x00, 0x82,
+	0x00, 0xb0, 0xb6, 0xae, 0xc2, 0x00, 0x89
+};
+
+static const unsigned int ld9040_22_180[] = {
+	0x00, 0x93, 0xba, 0xb3, 0xc5, 0x00, 0x69,
+	0x00, 0xb8, 0xb9, 0xae, 0xc1, 0x00, 0x7f,
+	0x00, 0xb0, 0xb6, 0xae, 0xc3, 0x00, 0x85
+};
+
+static const unsigned int ld9040_22_170[] = {
+	0x00, 0x8b, 0xb9, 0xb3, 0xc7, 0x00, 0x65,
+	0x00, 0xb7, 0xb8, 0xaf, 0xc3, 0x00, 0x7a,
+	0x00, 0x80, 0xb6, 0xae, 0xc4, 0x00, 0x81
+};
+
+static const unsigned int ld9040_22_160[] = {
+	0x00, 0x89, 0xba, 0xb3, 0xc8, 0x00, 0x62,
+	0x00, 0xb6, 0xba, 0xaf, 0xc3, 0x00, 0x76,
+	0x00, 0xaf, 0xb7, 0xae, 0xc4, 0x00, 0x7e
+};
+
+static const unsigned int ld9040_22_150[] = {
+	0x00, 0x82, 0xba, 0xb4, 0xc7, 0x00, 0x5f,
+	0x00, 0xb5, 0xba, 0xb0, 0xc3, 0x00, 0x72,
+	0x00, 0xae, 0xb8, 0xb0, 0xc3, 0x00, 0x7a
+};
+
+static const unsigned int ld9040_22_140[] = {
+	0x00, 0x7b, 0xbb, 0xb4, 0xc8, 0x00, 0x5b,
+	0x00, 0xb5, 0xba, 0xb1, 0xc4, 0x00, 0x6e,
+	0x00, 0xae, 0xb9, 0xb0, 0xc5, 0x00, 0x75
+};
+
+static const unsigned int ld9040_22_130[] = {
+	0x00, 0x71, 0xbb, 0xb5, 0xc8, 0x00, 0x57,
+	0x00, 0xb5, 0xbb, 0xb0, 0xc5, 0x00, 0x6a,
+	0x00, 0xae, 0xb9, 0xb1, 0xc6, 0x00, 0x70
+};
+
+static const unsigned int ld9040_22_120[] = {
+	0x00, 0x47, 0xba, 0xb6, 0xca, 0x00, 0x53,
+	0x00, 0xb5, 0xbb, 0xb3, 0xc6, 0x00, 0x65,
+	0x00, 0xae, 0xb8, 0xb3, 0xc7, 0x00, 0x6c
+};
+
+static const unsigned int ld9040_22_110[] = {
+	0x00, 0x13, 0xbb, 0xb7, 0xca, 0x00, 0x4f,
+	0x00, 0xb4, 0xbb, 0xb3, 0xc7, 0x00, 0x60,
+	0x00, 0xad, 0xb8, 0xb4, 0xc7, 0x00, 0x67
+};
+
+static const unsigned int ld9040_22_100[] = {
+	0x00, 0x13, 0xba, 0xb8, 0xcb, 0x00, 0x4b,
+	0x00, 0xb3, 0xbc, 0xb4, 0xc7, 0x00, 0x5c,
+	0x00, 0xac, 0xb8, 0xb4, 0xc8, 0x00, 0x62
+};
+
+static const unsigned int ld9040_22_90[] = {
+	0x00, 0x13, 0xb9, 0xb8, 0xcd, 0x00, 0x46,
+	0x00, 0xb1, 0xbc, 0xb5, 0xc8, 0x00, 0x56,
+	0x00, 0xaa, 0xb8, 0xb4, 0xc9, 0x00, 0x5d
+};
+
+static const unsigned int ld9040_22_80[] = {
+	0x00, 0x13, 0xba, 0xb9, 0xcd, 0x00, 0x41,
+	0x00, 0xb0, 0xbe, 0xb5, 0xc9, 0x00, 0x51,
+	0x00, 0xa9, 0xb9, 0xb5, 0xca, 0x00, 0x57
+};
+
+static const unsigned int ld9040_22_70[] = {
+	0x00, 0x13, 0xb9, 0xb9, 0xd0, 0x00, 0x3c,
+	0x00, 0xaf, 0xbf, 0xb6, 0xcb, 0x00, 0x4b,
+	0x00, 0xa8, 0xb9, 0xb5, 0xcc, 0x00, 0x52
+};
+
+static const unsigned int ld9040_22_50[] = {
+	0x00, 0x13, 0xb2, 0xba, 0xd2, 0x00, 0x30,
+	0x00, 0xaf, 0xc0, 0xb8, 0xcd, 0x00, 0x3d,
+	0x00, 0xa8, 0xb8, 0xb7, 0xcd, 0x00, 0x44
+};
+
+struct ld9040_gamma {
+	unsigned int *gamma_22_table[MAX_GAMMA_LEVEL];
+} gamma_table = {
+	.gamma_22_table[0] = (unsigned int *)&ld9040_22_50,
+	.gamma_22_table[1] = (unsigned int *)&ld9040_22_70,
+	.gamma_22_table[2] = (unsigned int *)&ld9040_22_80,
+	.gamma_22_table[3] = (unsigned int *)&ld9040_22_90,
+	.gamma_22_table[4] = (unsigned int *)&ld9040_22_100,
+	.gamma_22_table[5] = (unsigned int *)&ld9040_22_110,
+	.gamma_22_table[6] = (unsigned int *)&ld9040_22_120,
+	.gamma_22_table[7] = (unsigned int *)&ld9040_22_130,
+	.gamma_22_table[8] = (unsigned int *)&ld9040_22_140,
+	.gamma_22_table[9] = (unsigned int *)&ld9040_22_150,
+	.gamma_22_table[10] = (unsigned int *)&ld9040_22_160,
+	.gamma_22_table[11] = (unsigned int *)&ld9040_22_170,
+	.gamma_22_table[12] = (unsigned int *)&ld9040_22_180,
+	.gamma_22_table[13] = (unsigned int *)&ld9040_22_190,
+	.gamma_22_table[14] = (unsigned int *)&ld9040_22_200,
+	.gamma_22_table[15] = (unsigned int *)&ld9040_22_210,
+	.gamma_22_table[16] = (unsigned int *)&ld9040_22_220,
+	.gamma_22_table[17] = (unsigned int *)&ld9040_22_230,
+	.gamma_22_table[18] = (unsigned int *)&ld9040_22_240,
+	.gamma_22_table[19] = (unsigned int *)&ld9040_22_250,
+	.gamma_22_table[20] = (unsigned int *)&ld9040_22_260,
+	.gamma_22_table[21] = (unsigned int *)&ld9040_22_270,
+	.gamma_22_table[22] = (unsigned int *)&ld9040_22_280,
+	.gamma_22_table[23] = (unsigned int *)&ld9040_22_290,
+	.gamma_22_table[24] = (unsigned int *)&ld9040_22_300,
+};
+
+#endif
+
_

Patches currently in -mm which might be from dh09.lee@samsung.com are

origin.patch

