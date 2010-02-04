From: akpm@linux-foundation.org
Subject: [merged] radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh.patch removed from -mm tree
Date: Thu, 04 Feb 2010 09:49:13 -0800
Message-ID: <201002041749.o14HnDKF012011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755680Ab0BDRuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2010 12:50:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors@pelagicore.com, dougsland@gmail.com, hverkuil@xs4all.nl, mchehab@infradead.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     radio: add support for SAA7706H Car Radio DSP
has been removed from the -mm tree.  Its filename was
     radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: radio: add support for SAA7706H Car Radio DSP
=46rom: Richard R=F6jfors <richard.rojfors@pelagicore.com>

Initial support for the SAA7706H Car Radio DSP.

It is a I2C device and currently the mute control is supported.

When the device is unmuted it is brought out of reset and initiated usi=
ng
the proposed intialisation sequence.

When muted the DSP is brought into reset state.

[akpm@linux-foundation.org: include delay.h]
Signed-off-by: Richard R=F6jfors <richard.rojfors@pelagicore.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/radio/Kconfig     |   12=20
 drivers/media/radio/Makefile    |    1=20
 drivers/media/radio/saa7706h.c  |  451 ++++++++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h |    3=20
 4 files changed, 467 insertions(+)

diff -puN drivers/media/radio/Kconfig~radio-add-the-saa7706h-car-radio-=
dsp-to-v4l2-chip-identh drivers/media/radio/Kconfig
--- a/drivers/media/radio/Kconfig~radio-add-the-saa7706h-car-radio-dsp-=
to-v4l2-chip-identh
+++ a/drivers/media/radio/Kconfig
@@ -417,6 +417,18 @@ config RADIO_TEA5764_XTAL
 	  Say Y here if TEA5764 have a 32768 Hz crystal in circuit, say N
 	  here if TEA5764 reference frequency is connected in FREQIN.
=20
+config RADIO_SAA7706H
+	tristate "SAA7706H Car Radio DSP"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  Say Y here if you want to use the SAA7706H Car radio Digital
+	  Signal Processor, found for instance on the Russellville developmen=
t
+	  board. On the russellville the device is connected to internal
+	  timberdale I2C bus.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called SAA7706H.
+
 config RADIO_TEF6862
 	tristate "TEF6862 Car Radio Enhanced Selectivity Tuner"
 	depends on I2C && VIDEO_V4L2
diff -puN drivers/media/radio/Makefile~radio-add-the-saa7706h-car-radio=
-dsp-to-v4l2-chip-identh drivers/media/radio/Makefile
--- a/drivers/media/radio/Makefile~radio-add-the-saa7706h-car-radio-dsp=
-to-v4l2-chip-identh
+++ a/drivers/media/radio/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_USB_DSBR) +=3D dsbr100.o
 obj-$(CONFIG_RADIO_SI470X) +=3D si470x/
 obj-$(CONFIG_USB_MR800) +=3D radio-mr800.o
 obj-$(CONFIG_RADIO_TEA5764) +=3D radio-tea5764.o
+obj-$(CONFIG_RADIO_SAA7706H) +=3D saa7706h.o
 obj-$(CONFIG_RADIO_TEF6862) +=3D tef6862.o
=20
 EXTRA_CFLAGS +=3D -Isound
diff -puN /dev/null drivers/media/radio/saa7706h.c
--- /dev/null
+++ a/drivers/media/radio/saa7706h.c
@@ -0,0 +1,451 @@
+/*
+ * saa7706.c Philips SAA7706H Car Radio DSP driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+
+#define DRIVER_NAME "saa7706h"
+
+/* the I2C memory map looks like this
+
+	$1C00 - $FFFF Not Used
+	$2200 - $3FFF Reserved YRAM (DSP2) space
+	$2000 - $21FF YRAM (DSP2)
+	$1FF0 - $1FFF Hardware Registers
+	$1280 - $1FEF Reserved XRAM (DSP2) space
+	$1000 - $127F XRAM (DSP2)
+	$0FFF        DSP CONTROL
+	$0A00 - $0FFE Reserved
+	$0980 - $09FF Reserved YRAM (DSP1) space
+	$0800 - $097F YRAM (DSP1)
+	$0200 - $07FF Not Used
+	$0180 - $01FF Reserved XRAM (DSP1) space
+	$0000 - $017F XRAM (DSP1)
+*/
+
+#define SAA7706H_REG_CTRL		0x0fff
+#define SAA7706H_CTRL_BYP_PLL		0x0001
+#define SAA7706H_CTRL_PLL_DIV_MASK	0x003e
+#define SAA7706H_CTRL_PLL3_62975MHZ	0x003e
+#define SAA7706H_CTRL_DSP_TURBO		0x0040
+#define SAA7706H_CTRL_PC_RESET_DSP1	0x0080
+#define SAA7706H_CTRL_PC_RESET_DSP2	0x0100
+#define SAA7706H_CTRL_DSP1_ROM_EN_MASK	0x0600
+#define SAA7706H_CTRL_DSP1_FUNC_PROM	0x0000
+#define SAA7706H_CTRL_DSP2_ROM_EN_MASK	0x1800
+#define SAA7706H_CTRL_DSP2_FUNC_PROM	0x0000
+#define SAA7706H_CTRL_DIG_SIL_INTERPOL	0x8000
+
+#define SAA7706H_REG_EVALUATION			0x1ff0
+#define SAA7706H_EVAL_DISABLE_CHARGE_PUMP	0x000001
+#define SAA7706H_EVAL_DCS_CLOCK			0x000002
+#define SAA7706H_EVAL_GNDRC1_ENABLE		0x000004
+#define SAA7706H_EVAL_GNDRC2_ENABLE		0x000008
+
+#define SAA7706H_REG_CL_GEN1			0x1ff3
+#define SAA7706H_CL_GEN1_MIN_LOOPGAIN_MASK	0x00000f
+#define SAA7706H_CL_GEN1_LOOPGAIN_MASK		0x0000f0
+#define SAA7706H_CL_GEN1_COARSE_RATION		0xffff00
+
+#define SAA7706H_REG_CL_GEN2			0x1ff4
+#define SAA7706H_CL_GEN2_WSEDGE_FALLING		0x000001
+#define SAA7706H_CL_GEN2_STOP_VCO		0x000002
+#define SAA7706H_CL_GEN2_FRERUN			0x000004
+#define SAA7706H_CL_GEN2_ADAPTIVE		0x000008
+#define SAA7706H_CL_GEN2_FINE_RATIO_MASK	0x0ffff0
+
+#define SAA7706H_REG_CL_GEN4		0x1ff6
+#define SAA7706H_CL_GEN4_BYPASS_PLL1	0x001000
+#define SAA7706H_CL_GEN4_PLL1_DIV_MASK	0x03e000
+#define SAA7706H_CL_GEN4_DSP1_TURBO	0x040000
+
+#define SAA7706H_REG_SEL	0x1ff7
+#define SAA7706H_SEL_DSP2_SRCA_MASK	0x000007
+#define SAA7706H_SEL_DSP2_FMTA_MASK	0x000031
+#define SAA7706H_SEL_DSP2_SRCB_MASK	0x0001c0
+#define SAA7706H_SEL_DSP2_FMTB_MASK	0x000e00
+#define SAA7706H_SEL_DSP1_SRC_MASK	0x003000
+#define SAA7706H_SEL_DSP1_FMT_MASK	0x01c003
+#define SAA7706H_SEL_SPDIF2		0x020000
+#define SAA7706H_SEL_HOST_IO_FMT_MASK	0x1c0000
+#define SAA7706H_SEL_EN_HOST_IO		0x200000
+
+#define SAA7706H_REG_IAC		0x1ff8
+#define SAA7706H_REG_CLK_SET		0x1ff9
+#define SAA7706H_REG_CLK_COEFF		0x1ffa
+#define SAA7706H_REG_INPUT_SENS		0x1ffb
+#define SAA7706H_INPUT_SENS_RDS_VOL_MASK	0x0003f
+#define SAA7706H_INPUT_SENS_FM_VOL_MASK		0x00fc0
+#define SAA7706H_INPUT_SENS_FM_MPX		0x01000
+#define SAA7706H_INPUT_SENS_OFF_FILTER_A_EN	0x02000
+#define SAA7706H_INPUT_SENS_OFF_FILTER_B_EN	0x04000
+#define SAA7706H_REG_PHONE_NAV_AUDIO	0x1ffc
+#define SAA7706H_REG_IO_CONF_DSP2	0x1ffd
+#define SAA7706H_REG_STATUS_DSP2	0x1ffe
+#define SAA7706H_REG_PC_DSP2		0x1fff
+
+#define SAA7706H_DSP1_MOD0	0x0800
+#define SAA7706H_DSP1_ROM_VER	0x097f
+#define SAA7706H_DSP2_MPTR0	0x1000
+
+#define SAA7706H_DSP1_MODPNTR	0x0000
+
+#define SAA7706H_DSP2_XMEM_CONTLLCW	0x113e
+#define SAA7706H_DSP2_XMEM_BUSAMP	0x114a
+#define SAA7706H_DSP2_XMEM_FDACPNTR	0x11f9
+#define SAA7706H_DSP2_XMEM_IIS1PNTR	0x11fb
+
+#define SAA7706H_DSP2_YMEM_PVGA		0x212a
+#define SAA7706H_DSP2_YMEM_PVAT1	0x212b
+#define SAA7706H_DSP2_YMEM_PVAT		0x212c
+#define SAA7706H_DSP2_YMEM_ROM_VER	0x21ff
+
+#define SUPPORTED_DSP1_ROM_VER		0x667
+
+struct saa7706h_state {
+	struct v4l2_subdev sd;
+	unsigned muted;
+};
+
+static inline struct saa7706h_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct saa7706h_state, sd);
+}
+
+static int saa7706h_i2c_send(struct i2c_client *client, const u8 *data=
, int len)
+{
+	int err =3D i2c_master_send(client, data, len);
+	if (err =3D=3D len)
+		return 0;
+	return err > 0 ? -EIO : err;
+}
+
+static int saa7706h_i2c_transfer(struct i2c_client *client,
+	struct i2c_msg *msgs, int num)
+{
+	int err =3D i2c_transfer(client->adapter, msgs, num);
+	if (err =3D=3D num)
+		return 0;
+	return err > 0 ? -EIO : err;
+}
+
+static int saa7706h_set_reg24(struct v4l2_subdev *sd, u16 reg, u32 val=
)
+{
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+	u8 buf[5];
+	int pos =3D 0;
+
+	buf[pos++] =3D reg >> 8;
+	buf[pos++] =3D reg;
+	buf[pos++] =3D val >> 16;
+	buf[pos++] =3D val >> 8;
+	buf[pos++] =3D val;
+
+	return saa7706h_i2c_send(client, buf, pos);
+}
+
+static int saa7706h_set_reg24_err(struct v4l2_subdev *sd, u16 reg, u32=
 val,
+	int *err)
+{
+	return *err ? *err : saa7706h_set_reg24(sd, reg, val);
+}
+
+static int saa7706h_set_reg16(struct v4l2_subdev *sd, u16 reg, u16 val=
)
+{
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+	u8 buf[4];
+	int pos =3D 0;
+
+	buf[pos++] =3D reg >> 8;
+	buf[pos++] =3D reg;
+	buf[pos++] =3D val >> 8;
+	buf[pos++] =3D val;
+
+	return saa7706h_i2c_send(client, buf, pos);
+}
+
+static int saa7706h_set_reg16_err(struct v4l2_subdev *sd, u16 reg, u16=
 val,
+	int *err)
+{
+	return *err ? *err : saa7706h_set_reg16(sd, reg, val);
+}
+
+static int saa7706h_get_reg16(struct v4l2_subdev *sd, u16 reg)
+{
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+	u8 buf[2];
+	int err;
+	u8 regaddr[] =3D {reg >> 8, reg};
+	struct i2c_msg msg[] =3D { {client->addr, 0, sizeof(regaddr), regaddr=
},
+				{client->addr, I2C_M_RD, sizeof(buf), buf} };
+
+	err =3D saa7706h_i2c_transfer(client, msg, ARRAY_SIZE(msg));
+	if (err)
+		return err;
+
+	return buf[0] << 8 | buf[1];
+}
+
+static int saa7706h_unmute(struct v4l2_subdev *sd)
+{
+	struct saa7706h_state *state =3D to_state(sd);
+	int err =3D 0;
+
+	err =3D saa7706h_set_reg16_err(sd, SAA7706H_REG_CTRL,
+		SAA7706H_CTRL_PLL3_62975MHZ | SAA7706H_CTRL_PC_RESET_DSP1 |
+		SAA7706H_CTRL_PC_RESET_DSP2, &err);
+
+	/* newer versions of the chip requires a small sleep after reset */
+	msleep(1);
+
+	err =3D saa7706h_set_reg16_err(sd, SAA7706H_REG_CTRL,
+		SAA7706H_CTRL_PLL3_62975MHZ, &err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_EVALUATION, 0, &err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_CL_GEN1, 0x040022, &e=
rr);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_CL_GEN2,
+		SAA7706H_CL_GEN2_WSEDGE_FALLING, &err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_CL_GEN4, 0x024080, &e=
rr);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_SEL, 0x200080, &err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_IAC, 0xf4caed, &err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_CLK_SET, 0x124334, &e=
rr);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_CLK_COEFF, 0x004a1a,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_INPUT_SENS, 0x0071c7,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_PHONE_NAV_AUDIO,
+		0x0e22ff, &err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_IO_CONF_DSP2, 0x001ff=
8,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_STATUS_DSP2, 0x080003=
,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_REG_PC_DSP2, 0x000004, &e=
rr);
+
+	err =3D saa7706h_set_reg16_err(sd, SAA7706H_DSP1_MOD0, 0x0c6c, &err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP2_MPTR0, 0x000b4b, &er=
r);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP1_MODPNTR, 0x000600, &=
err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP1_MODPNTR, 0x0000c0, &=
err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP2_XMEM_CONTLLCW, 0x000=
819,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP2_XMEM_CONTLLCW, 0x000=
85a,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP2_XMEM_BUSAMP, 0x7ffff=
f,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP2_XMEM_FDACPNTR, 0x200=
0cb,
+		&err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP2_XMEM_IIS1PNTR, 0x200=
0cb,
+		&err);
+
+	err =3D saa7706h_set_reg16_err(sd, SAA7706H_DSP2_YMEM_PVGA, 0x0f80, &=
err);
+
+	err =3D saa7706h_set_reg16_err(sd, SAA7706H_DSP2_YMEM_PVAT1, 0x0800,
+		&err);
+
+	err =3D saa7706h_set_reg16_err(sd, SAA7706H_DSP2_YMEM_PVAT, 0x0800, &=
err);
+
+	err =3D saa7706h_set_reg24_err(sd, SAA7706H_DSP2_XMEM_CONTLLCW, 0x000=
905,
+		&err);
+	if (!err)
+		state->muted =3D 0;
+	return err;
+}
+
+static int saa7706h_mute(struct v4l2_subdev *sd)
+{
+	struct saa7706h_state *state =3D to_state(sd);
+	int err;
+
+	err =3D saa7706h_set_reg16(sd, SAA7706H_REG_CTRL,
+		SAA7706H_CTRL_PLL3_62975MHZ | SAA7706H_CTRL_PC_RESET_DSP1 |
+		SAA7706H_CTRL_PC_RESET_DSP2);
+	if (!err)
+		state->muted =3D 1;
+	return err;
+}
+
+static int saa7706h_queryctrl(struct v4l2_subdev *sd, struct v4l2_quer=
yctrl *qc)
+{
+	switch (qc->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
+	}
+	return -EINVAL;
+}
+
+static int saa7706h_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control=
 *ctrl)
+{
+	struct saa7706h_state *state =3D to_state(sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		ctrl->value =3D state->muted;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int saa7706h_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control=
 *ctrl)
+{
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		if (ctrl->value)
+			return saa7706h_mute(sd);
+		return saa7706h_unmute(sd);
+	}
+	return -EINVAL;
+}
+
+static int saa7706h_g_chip_ident(struct v4l2_subdev *sd,
+	struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client =3D v4l2_get_subdevdata(sd);
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA7706H, =
0);
+}
+
+static const struct v4l2_subdev_core_ops saa7706h_core_ops =3D {
+	.g_chip_ident =3D saa7706h_g_chip_ident,
+	.queryctrl =3D saa7706h_queryctrl,
+	.g_ctrl =3D saa7706h_g_ctrl,
+	.s_ctrl =3D saa7706h_s_ctrl,
+};
+
+static const struct v4l2_subdev_ops saa7706h_ops =3D {
+	.core =3D &saa7706h_core_ops,
+};
+
+/*
+ * Generic i2c probe
+ * concerning the addresses: i2c wants 7 bit (without the r/w bit), so=
 '>>1'
+ */
+
+static int __devinit saa7706h_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct saa7706h_state *state;
+	struct v4l2_subdev *sd;
+	int err;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DAT=
A))
+		return -EIO;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	state =3D kmalloc(sizeof(struct saa7706h_state), GFP_KERNEL);
+	if (state =3D=3D NULL)
+		return -ENOMEM;
+	sd =3D &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &saa7706h_ops);
+
+	/* check the rom versions */
+	err =3D saa7706h_get_reg16(sd, SAA7706H_DSP1_ROM_VER);
+	if (err < 0)
+		goto err;
+	if (err !=3D SUPPORTED_DSP1_ROM_VER)
+		v4l2_warn(sd, "Unknown DSP1 ROM code version: 0x%x\n", err);
+
+	state->muted =3D 1;
+
+	/* startup in a muted state */
+	err =3D saa7706h_mute(sd);
+	if (err)
+		goto err;
+
+	return 0;
+
+err:
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+
+	printk(KERN_ERR DRIVER_NAME ": Failed to probe: %d\n", err);
+
+	return err;
+}
+
+static int __devexit saa7706h_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
+
+	saa7706h_mute(sd);
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+	return 0;
+}
+
+static const struct i2c_device_id saa7706h_id[] =3D {
+	{DRIVER_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, saa7706h_id);
+
+static struct i2c_driver saa7706h_driver =3D {
+	.driver =3D {
+		.owner	=3D THIS_MODULE,
+		.name	=3D DRIVER_NAME,
+	},
+	.probe		=3D saa7706h_probe,
+	.remove		=3D saa7706h_remove,
+	.id_table	=3D saa7706h_id,
+};
+
+static __init int saa7706h_init(void)
+{
+	return i2c_add_driver(&saa7706h_driver);
+}
+
+static __exit void saa7706h_exit(void)
+{
+	i2c_del_driver(&saa7706h_driver);
+}
+
+module_init(saa7706h_init);
+module_exit(saa7706h_exit);
+
+MODULE_DESCRIPTION("SAA7706H Car Radio DSP driver");
+MODULE_AUTHOR("Mocean Laboratories");
+MODULE_LICENSE("GPL v2");
diff -puN include/media/v4l2-chip-ident.h~radio-add-the-saa7706h-car-ra=
dio-dsp-to-v4l2-chip-identh include/media/v4l2-chip-ident.h
--- a/include/media/v4l2-chip-ident.h~radio-add-the-saa7706h-car-radio-=
dsp-to-v4l2-chip-identh
+++ a/include/media/v4l2-chip-ident.h
@@ -155,6 +155,9 @@ enum {
 	/* module adv7343: just ident 7343 */
 	V4L2_IDENT_ADV7343 =3D 7343,
=20
+	/* module saa7706h: just ident 7706 */
+	V4L2_IDENT_SAA7706H =3D 7706,
+
 	/* module wm8739: just ident 8739 */
 	V4L2_IDENT_WM8739 =3D 8739,
=20
_

Patches currently in -mm which might be from richard.rojfors@pelagicore=
=2Ecom are

origin.patch
linux-next.patch
timbgpio-add-support-for-interrupt-triggering-on-both-flanks.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
