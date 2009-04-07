From: akpm@linux-foundation.org
Subject: [merged] tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:28 -0700
Message-ID: <200904071907.n37J7S49011340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376AbZDGTJk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: move I2C functionality into the tdfxfb
has been removed from the -mm tree.  Its filename was
     tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: move I2C functionality into the tdfxfb
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The I2C functionality provided by the i2c-voodoo3 driver is moved into the
tdfxfb (frame buffer driver for Voodoo3 cards).  This way there is no
conflict between the i2c driver and the fb driver.

The tdfxfb does not make use from the DDC functionality yet but provides
all the functionality of the i2c-voodoo3 driver.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig  |    9 +
 drivers/video/tdfxfb.c |  200 ++++++++++++++++++++++++++++++++++++++-
 include/video/tdfx.h   |   26 +++++
 3 files changed, 234 insertions(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~tdfxfb-move-i2c-functionality-into-the-tdfxfb drivers/video/Kconfig
--- a/drivers/video/Kconfig~tdfxfb-move-i2c-functionality-into-the-tdfxfb
+++ a/drivers/video/Kconfig
@@ -1550,6 +1550,7 @@ config FB_3DFX
 	select FB_CFB_IMAGEBLIT
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
+	select FB_MODE_HELPERS
 	help
 	  This driver supports graphics boards with the 3Dfx Banshee,
 	  Voodoo3 or VSA-100 (aka Voodoo4/5) chips. Say Y if you have
@@ -1565,6 +1566,14 @@ config FB_3DFX_ACCEL
 	This will compile the 3Dfx Banshee/Voodoo3/VSA-100 frame buffer
 	device driver with acceleration functions.
 
+config FB_3DFX_I2C
+	bool "Enable DDC/I2C support"
+	depends on FB_3DFX && EXPERIMENTAL
+	select FB_DDC
+	default y
+	help
+	  Say Y here if you want DDC/I2C support for your 3dfx Voodoo3.
+
 config FB_VOODOO1
 	tristate "3Dfx Voodoo Graphics (sst1) support"
 	depends on FB && PCI
diff -puN drivers/video/tdfxfb.c~tdfxfb-move-i2c-functionality-into-the-tdfxfb drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-move-i2c-functionality-into-the-tdfxfb
+++ a/drivers/video/tdfxfb.c
@@ -10,6 +10,12 @@
  * Created      : Thu Sep 23 18:17:43 1999, hmallat
  * Last modified: Tue Nov  2 21:19:47 1999, hmallat
  *
+ * I2C part copied from the i2c-voodoo3.c driver by:
+ * Frodo Looijaard <frodol@dds.nl>,
+ * Philip Edelbrock <phil@netroedge.com>,
+ * Ralph Metzler <rjkm@thp.uni-koeln.de>, and
+ * Mark D. Studebaker <mdsxyz123@yahoo.com>
+ *
  * Lots of the information here comes from the Daryll Strauss' Banshee
  * patches to the XF86 server, and the rest comes from the 3dfx
  * Banshee specification. I'm very much indebted to Daryll for his
@@ -1167,6 +1173,190 @@ static struct fb_ops tdfxfb_ops = {
 #endif
 };
 
+#ifdef CONFIG_FB_3DFX_I2C
+/* The voo GPIO registers don't have individual masks for each bit
+   so we always have to read before writing. */
+
+static void tdfxfb_i2c_setscl(void *data, int val)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+	unsigned int r;
+
+	r = tdfx_inl(par, VIDSERPARPORT);
+	if (val)
+		r |= I2C_SCL_OUT;
+	else
+		r &= ~I2C_SCL_OUT;
+	tdfx_outl(par, VIDSERPARPORT, r);
+	tdfx_inl(par, VIDSERPARPORT);	/* flush posted write */
+}
+
+static void tdfxfb_i2c_setsda(void *data, int val)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+	unsigned int r;
+
+	r = tdfx_inl(par, VIDSERPARPORT);
+	if (val)
+		r |= I2C_SDA_OUT;
+	else
+		r &= ~I2C_SDA_OUT;
+	tdfx_outl(par, VIDSERPARPORT, r);
+	tdfx_inl(par, VIDSERPARPORT);	/* flush posted write */
+}
+
+/* The GPIO pins are open drain, so the pins always remain outputs.
+   We rely on the i2c-algo-bit routines to set the pins high before
+   reading the input from other chips. */
+
+static int tdfxfb_i2c_getscl(void *data)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+
+	return (0 != (tdfx_inl(par, VIDSERPARPORT) & I2C_SCL_IN));
+}
+
+static int tdfxfb_i2c_getsda(void *data)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+
+	return (0 != (tdfx_inl(par, VIDSERPARPORT) & I2C_SDA_IN));
+}
+
+static void tdfxfb_ddc_setscl(void *data, int val)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+	unsigned int r;
+
+	r = tdfx_inl(par, VIDSERPARPORT);
+	if (val)
+		r |= DDC_SCL_OUT;
+	else
+		r &= ~DDC_SCL_OUT;
+	tdfx_outl(par, VIDSERPARPORT, r);
+	tdfx_inl(par, VIDSERPARPORT);	/* flush posted write */
+}
+
+static void tdfxfb_ddc_setsda(void *data, int val)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+	unsigned int r;
+
+	r = tdfx_inl(par, VIDSERPARPORT);
+	if (val)
+		r |= DDC_SDA_OUT;
+	else
+		r &= ~DDC_SDA_OUT;
+	tdfx_outl(par, VIDSERPARPORT, r);
+	tdfx_inl(par, VIDSERPARPORT);	/* flush posted write */
+}
+
+static int tdfxfb_ddc_getscl(void *data)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+
+	return (0 != (tdfx_inl(par, VIDSERPARPORT) & DDC_SCL_IN));
+}
+
+static int tdfxfb_ddc_getsda(void *data)
+{
+	struct tdfxfb_i2c_chan 	*chan = data;
+	struct tdfx_par 	*par = chan->par;
+
+	return (0 != (tdfx_inl(par, VIDSERPARPORT) & DDC_SDA_IN));
+}
+
+static int __devinit tdfxfb_setup_ddc_bus(struct tdfxfb_i2c_chan *chan,
+					  const char *name, struct device *dev)
+{
+	int rc;
+
+	strlcpy(chan->adapter.name, name, sizeof(chan->adapter.name));
+	chan->adapter.owner		= THIS_MODULE;
+	chan->adapter.class		= I2C_CLASS_DDC;
+	chan->adapter.algo_data		= &chan->algo;
+	chan->adapter.dev.parent	= dev;
+	chan->algo.setsda		= tdfxfb_ddc_setsda;
+	chan->algo.setscl		= tdfxfb_ddc_setscl;
+	chan->algo.getsda		= tdfxfb_ddc_getsda;
+	chan->algo.getscl		= tdfxfb_ddc_getscl;
+	chan->algo.udelay		= 10;
+	chan->algo.timeout		= msecs_to_jiffies(500);
+	chan->algo.data 		= chan;
+
+	i2c_set_adapdata(&chan->adapter, chan);
+
+	rc = i2c_bit_add_bus(&chan->adapter);
+	if (rc == 0)
+		DPRINTK("I2C bus %s registered.\n", name);
+	else
+		chan->par = NULL;
+
+	return rc;
+}
+
+static int __devinit tdfxfb_setup_i2c_bus(struct tdfxfb_i2c_chan *chan,
+					  const char *name, struct device *dev)
+{
+	int rc;
+
+	strlcpy(chan->adapter.name, name, sizeof(chan->adapter.name));
+	chan->adapter.owner		= THIS_MODULE;
+	chan->adapter.class		= I2C_CLASS_TV_ANALOG;
+	chan->adapter.algo_data		= &chan->algo;
+	chan->adapter.dev.parent	= dev;
+	chan->algo.setsda		= tdfxfb_i2c_setsda;
+	chan->algo.setscl		= tdfxfb_i2c_setscl;
+	chan->algo.getsda		= tdfxfb_i2c_getsda;
+	chan->algo.getscl		= tdfxfb_i2c_getscl;
+	chan->algo.udelay		= 10;
+	chan->algo.timeout		= msecs_to_jiffies(500);
+	chan->algo.data 		= chan;
+
+	i2c_set_adapdata(&chan->adapter, chan);
+
+	rc = i2c_bit_add_bus(&chan->adapter);
+	if (rc == 0)
+		DPRINTK("I2C bus %s registered.\n", name);
+	else
+		chan->par = NULL;
+
+	return rc;
+}
+
+static void __devinit tdfxfb_create_i2c_busses(struct fb_info *info)
+{
+	struct tdfx_par *par = info->par;
+
+	tdfx_outl(par, VIDINFORMAT, 0x8160);
+	tdfx_outl(par, VIDSERPARPORT, 0xcffc0020);
+
+	par->chan[0].par = par;
+	par->chan[1].par = par;
+
+	tdfxfb_setup_ddc_bus(&par->chan[0], "Voodoo3-DDC", info->dev);
+	tdfxfb_setup_i2c_bus(&par->chan[1], "Voodoo3-I2C", info->dev);
+}
+
+static void tdfxfb_delete_i2c_busses(struct tdfx_par *par)
+{
+	if (par->chan[0].par)
+		i2c_del_adapter(&par->chan[0].adapter);
+	par->chan[0].par = NULL;
+
+	if (par->chan[1].par)
+		i2c_del_adapter(&par->chan[1].adapter);
+	par->chan[1].par = NULL;
+}
+#endif /* CONFIG_FB_3DFX_I2C */
+
 /**
  *      tdfxfb_probe - Device Initializiation
  *
@@ -1284,7 +1474,9 @@ static int __devinit tdfxfb_probe(struct
 	if (hwcursor)
 		info->fix.smem_len = (info->fix.smem_len - 1024) &
 					(PAGE_MASK << 1);
-
+#ifdef CONFIG_FB_3DFX_I2C
+	tdfxfb_create_i2c_busses(info);
+#endif
 	if (!mode_option)
 		mode_option = "640x480@60";
 
@@ -1315,6 +1507,9 @@ static int __devinit tdfxfb_probe(struct
 	return 0;
 
 out_err_iobase:
+#ifdef CONFIG_FB_3DFX_I2C
+	tdfxfb_delete_i2c_busses(default_par);
+#endif
 	if (default_par->mtrr_handle >= 0)
 		mtrr_del(default_par->mtrr_handle, info->fix.smem_start,
 			 info->fix.smem_len);
@@ -1379,6 +1574,9 @@ static void __devexit tdfxfb_remove(stru
 	struct tdfx_par *par = info->par;
 
 	unregister_framebuffer(info);
+#ifdef CONFIG_FB_3DFX_I2C
+	tdfxfb_delete_i2c_busses(par);
+#endif
 	if (par->mtrr_handle >= 0)
 		mtrr_del(par->mtrr_handle, info->fix.smem_start,
 			 info->fix.smem_len);
diff -puN include/video/tdfx.h~tdfxfb-move-i2c-functionality-into-the-tdfxfb include/video/tdfx.h
--- a/include/video/tdfx.h~tdfxfb-move-i2c-functionality-into-the-tdfxfb
+++ a/include/video/tdfx.h
@@ -1,6 +1,9 @@
 #ifndef _TDFX_H
 #define _TDFX_H
 
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+
 /* membase0 register offsets */
 #define STATUS		0x00
 #define PCIINIT0	0x04
@@ -123,6 +126,18 @@
 #define VIDCFG_PIXFMT_SHIFT             18
 #define DACMODE_2X			BIT(0)
 
+/* I2C bit locations in the VIDSERPARPORT register */
+#define DDC_ENAB	0x00040000
+#define DDC_SCL_OUT	0x00080000
+#define DDC_SDA_OUT	0x00100000
+#define DDC_SCL_IN	0x00200000
+#define DDC_SDA_IN	0x00400000
+#define I2C_ENAB	0x00800000
+#define I2C_SCL_OUT	0x01000000
+#define I2C_SDA_OUT	0x02000000
+#define I2C_SCL_IN	0x04000000
+#define I2C_SDA_IN	0x08000000
+
 /* VGA rubbish, need to change this for multihead support */
 #define MISC_W		0x3c2
 #define MISC_R		0x3cc
@@ -168,12 +183,23 @@ struct banshee_reg {
 	unsigned long miscinit0;
 };
 
+struct tdfx_par;
+
+struct tdfxfb_i2c_chan {
+	struct tdfx_par *par;
+	struct i2c_adapter adapter;
+	struct i2c_algo_bit_data algo;
+};
+
 struct tdfx_par {
 	u32 max_pixclock;
 	u32 palette[16];
 	void __iomem *regbase_virt;
 	unsigned long iobase;
 	int mtrr_handle;
+#ifdef CONFIG_FB_3DFX_I2C
+	struct tdfxfb_i2c_chan chan[2];
+#endif
 };
 
 #endif	/* __KERNEL__ */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch

