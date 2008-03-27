From: akpm@linux-foundation.org
Subject: - input-touchscreen-driver-for-the-superh-migor-board.patch removed from -mm tree
Date: Thu, 27 Mar 2008 01:08:15 -0700
Message-ID: <200803270808.m2R88F1l024988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755716AbYC0IIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 04:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus.damm@gmail.com, damm@igel.co.jp, dtor@mail.ru, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     input: touchscreen driver for the SuperH MigoR board
has been removed from the -mm tree.  Its filename was
     input-touchscreen-driver-for-the-superh-migor-board.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: touchscreen driver for the SuperH MigoR board
From: Magnus Damm <magnus.damm@gmail.com>

Add a touch screen driver for the MigoR board.  The chip we interface to is
unfortunately a custom designed microcontroller speaking some undocumented
protocol over i2c.

The board specific code is expected to register this device as an i2c chip
using struct i2c_board_info [] and i2c_register_board_info().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/Kconfig    |   12 +
 drivers/input/touchscreen/Makefile   |    1 
 drivers/input/touchscreen/migor_ts.c |  196 +++++++++++++++++++++++++
 3 files changed, 209 insertions(+)

diff -puN drivers/input/touchscreen/Kconfig~input-touchscreen-driver-for-the-superh-migor-board drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~input-touchscreen-driver-for-the-superh-migor-board
+++ a/drivers/input/touchscreen/Kconfig
@@ -147,6 +147,18 @@ config TOUCHSCREEN_HP7XX
 	  To compile this driver as a module, choose M here: the
 	  module will be called jornada720_ts.
 
+config TOUCHSCREEN_MIGOR
+	tristate "Renesas MIGO-R touchscreen"
+	depends on SH_MIGOR
+	default n
+	help
+	  Say Y here to enable MIGO-R touchscreen support.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called migor_ts.
+
 config TOUCHSCREEN_PENMOUNT
 	tristate "Penmount serial touchscreen"
 	select SERIO
diff -puN drivers/input/touchscreen/Makefile~input-touchscreen-driver-for-the-superh-migor-board drivers/input/touchscreen/Makefile
--- a/drivers/input/touchscreen/Makefile~input-touchscreen-driver-for-the-superh-migor-board
+++ a/drivers/input/touchscreen/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunz
 obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
 obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
+obj-$(CONFIG_TOUCHSCREEN_MIGOR)		+= migor_ts.o
 obj-$(CONFIG_TOUCHSCREEN_MK712)		+= mk712.o
 obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
 obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
diff -puN /dev/null drivers/input/touchscreen/migor_ts.c
--- /dev/null
+++ a/drivers/input/touchscreen/migor_ts.c
@@ -0,0 +1,196 @@
+/*
+ * Touch Screen driver for Renesas MIGO-R Platform
+ *
+ * Copyright (c) 2008 Magnus Damm
+ * Copyright (c) 2007 Ujjwal Pande <ujjwal@kenati.com>,
+ *  Kenati Technologies Pvt Ltd.
+ *
+ * This file is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU  General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This file is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this library; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <asm/io.h>
+#include <linux/i2c.h>
+#include <linux/timer.h>
+
+#define EVENT_PENDOWN 1
+#define EVENT_REPEAT  2
+#define EVENT_PENUP   3
+
+struct migor_ts_priv {
+	struct i2c_client *client;
+	struct input_dev *input;
+	struct delayed_work work;
+	int irq;
+};
+
+static const u_int8_t migor_ts_ena_seq[17] = { 0x33, 0x22, 0x11,
+					       0x01, 0x06, 0x07, };
+static const u_int8_t migor_ts_dis_seq[17] = { };
+
+static void migor_ts_poscheck(struct work_struct *work)
+{
+	struct migor_ts_priv *priv = container_of(work,
+						  struct migor_ts_priv,
+						  work.work);
+	unsigned short xpos, ypos;
+	unsigned char event;
+	u_int8_t buf[16];
+
+	memset(buf, 0, sizeof(buf));
+
+	/* Set Index 0 */
+	buf[0] = 0;
+	if (i2c_master_send(priv->client, buf, 1) != 1) {
+		dev_err(&priv->client->dev, "Unable to write i2c index\n");
+		goto out;
+	}
+
+	/* Now do Page Read */
+	if (i2c_master_recv(priv->client, buf, sizeof(buf)) != sizeof(buf)) {
+		dev_err(&priv->client->dev, "Unable to read i2c page\n");
+		goto out;
+	}
+
+	ypos = ((buf[9] & 0x03) << 8 | buf[8]);
+	xpos = ((buf[11] & 0x03) << 8 | buf[10]);
+	event = buf[12];
+
+	if ((event == EVENT_PENDOWN) || (event == EVENT_REPEAT)) {
+		input_report_key(priv->input, BTN_TOUCH, 1);
+		input_report_abs(priv->input, ABS_X, ypos); /*X-Y swap*/
+		input_report_abs(priv->input, ABS_Y, xpos);
+		input_report_abs(priv->input, ABS_PRESSURE, 120);
+		input_sync(priv->input);
+	} else if (event == EVENT_PENUP) {
+		input_report_abs(priv->input, ABS_PRESSURE, 0);
+		input_sync(priv->input);
+	}
+ out:
+	enable_irq(priv->irq);
+}
+
+static irqreturn_t migor_ts_isr(int irq, void *dev_id)
+{
+	struct migor_ts_priv *priv = dev_id;
+
+	disable_irq_nosync(irq);
+	schedule_delayed_work(&priv->work, HZ / 20);
+	return IRQ_HANDLED;
+}
+
+static int migor_ts_probe(struct i2c_client *client)
+{
+	struct migor_ts_priv *priv;
+	int res = 0;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv == NULL) {
+		dev_err(&client->dev, "failed to allocate driver data\n");
+		res = -ENOMEM;
+		goto err0;
+	}
+
+	dev_set_drvdata(&client->dev, priv);
+	priv->client = client;
+	INIT_DELAYED_WORK(&priv->work, migor_ts_poscheck);
+	priv->irq = client->irq;
+
+	priv->input = input_allocate_device();
+	if (!priv->input) {
+		dev_err(&client->dev, "Failed to allocate input device.\n");
+		res = -ENOMEM;
+		goto err1;
+	}
+
+	priv->input->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	priv->input->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+
+	input_set_abs_params(priv->input, ABS_X, 95, 955, 0, 0);
+	input_set_abs_params(priv->input, ABS_Y, 85, 935, 0, 0);
+	input_set_abs_params(priv->input, ABS_PRESSURE, 0, 0, 0, 0);
+
+	priv->input->name = client->driver_name;
+	priv->input->phys = "input/event0";
+	priv->input->id.bustype = BUS_ISA;
+
+	res = input_register_device(priv->input);
+	if (res) {
+		input_free_device(priv->input);
+		goto err1;
+	}
+
+	if (request_irq(priv->irq, migor_ts_isr, IRQF_TRIGGER_LOW,
+			client->driver_name, priv)) {
+		dev_err(&client->dev, "Unable to request touchscreen IRQ.\n");
+		res = -EBUSY;
+		goto err2;
+	}
+
+	/* enable controller */
+	if (i2c_master_send(client, migor_ts_ena_seq, sizeof(migor_ts_ena_seq))
+	    == sizeof(migor_ts_ena_seq))
+		return 0;
+
+	dev_err(&client->dev, "Unable to enable touchscreen.\n");
+
+	free_irq(priv->irq, priv);
+ err2:
+	input_unregister_device(priv->input);
+ err1:
+	kfree(priv);
+ err0:
+	return res;
+}
+
+static int migor_ts_remove(struct i2c_client *client)
+{
+	struct migor_ts_priv *priv = dev_get_drvdata(&client->dev);
+
+	/* disable controller */
+	i2c_master_send(client, migor_ts_dis_seq, sizeof(migor_ts_dis_seq));
+
+	free_irq(priv->irq, priv);
+	input_unregister_device(priv->input);
+	kfree(priv);
+	return 0;
+}
+
+static struct i2c_driver migor_ts_driver = {
+	.driver = {
+		.name = "migor_ts",
+	},
+	.probe = migor_ts_probe,
+	.remove = migor_ts_remove,
+};
+
+static int __init migor_ts_init(void)
+{
+	return i2c_add_driver(&migor_ts_driver);
+}
+
+static void __exit migor_ts_exit(void)
+{
+	i2c_del_driver(&migor_ts_driver);
+}
+
+MODULE_DESCRIPTION("MigoR Touchscreen driver");
+MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
+MODULE_LICENSE("GPL");
+
+module_init(migor_ts_init);
+module_exit(migor_ts_exit);
_

Patches currently in -mm which might be from magnus.damm@gmail.com are

input-touchscreen-driver-for-the-superh-migor-board.patch
git-net.patch
smc91x-add-insw-outsw-to-default-config-v2.patch
git-sh.patch
sm501-add-uart-support.patch

