From: akpm@linux-foundation.org
Subject: - i2c-superh-mobile-i2c-bus-controller-v3.patch removed from -mm tree
Date: Thu, 27 Mar 2008 15:49:10 -0700
Message-ID: <200803272259.m2RMx7VD026180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbYC0W7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 18:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, damm@igel.co.jp, mm-commits@vger.kernel.org


The patch titled
     i2c: SuperH Mobile I2C Bus Controller V3
has been removed from the -mm tree.  Its filename was
     i2c-superh-mobile-i2c-bus-controller-v3.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: i2c: SuperH Mobile I2C Bus Controller V3
=46rom: Paul Mundt <lethal@linux-sh.org>

This is V3 of the SuperH Mobile I2C Controller Driver.  A simple Master=
 only
driver for the I2C block included in processors such as sh7343, sh7722 =
and
sh7723.  Tested on a sh7722 MigoR using a rs5c372b rtc.

Verified with the rtc-rs5c372 SMBus conversion patches currently in -mm=
=2E

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/Kconfig         |    9=20
 drivers/i2c/busses/Makefile        |    1=20
 drivers/i2c/busses/i2c-sh_mobile.c |  497 +++++++++++++++++++++++++++
 3 files changed, 507 insertions(+)

diff -puN drivers/i2c/busses/Kconfig~i2c-superh-mobile-i2c-bus-controll=
er-v3 drivers/i2c/busses/Kconfig
--- a/drivers/i2c/busses/Kconfig~i2c-superh-mobile-i2c-bus-controller-v=
3
+++ a/drivers/i2c/busses/Kconfig
@@ -707,4 +707,13 @@ config I2C_SH7760
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-sh7760.
=20
+config I2C_SH_MOBILE
+	tristate "SuperH Mobile I2C Controller"
+	help
+	  If you say yes to this option, support will be included for the
+	  built-in I2C interface on the Renesas SH-Mobile processor.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called i2c-sh_mobile.
+
 endmenu
diff -puN drivers/i2c/busses/Makefile~i2c-superh-mobile-i2c-bus-control=
ler-v3 drivers/i2c/busses/Makefile
--- a/drivers/i2c/busses/Makefile~i2c-superh-mobile-i2c-bus-controller-=
v3
+++ a/drivers/i2c/busses/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_I2C_VIAPRO)	+=3D i2c-viapro.o
 obj-$(CONFIG_I2C_VOODOO3)	+=3D i2c-voodoo3.o
 obj-$(CONFIG_SCx200_ACB)	+=3D scx200_acb.o
 obj-$(CONFIG_SCx200_I2C)	+=3D scx200_i2c.o
+obj-$(CONFIG_I2C_SH_MOBILE)	+=3D i2c-sh_mobile.o
=20
 ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
 EXTRA_CFLAGS +=3D -DDEBUG
diff -puN /dev/null drivers/i2c/busses/i2c-sh_mobile.c
--- /dev/null
+++ a/drivers/i2c/busses/i2c-sh_mobile.c
@@ -0,0 +1,497 @@
+/*
+ * SuperH Mobile I2C Controller
+ *
+ * Copyright (C) 2008 Magnus Damm
+ *
+ * Based on i2c-simtec.c by Ben Dooks <ben@simtec.co.uk>
+ * Copyright (C) 2005 Simtec Electronics
+ *
+ * Portions of the code based on out-of-tree driver i2c-sh7343.c
+ * Copyright (c) 2006 Carlos Munoz <carlos@kenati.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <asm/io.h>
+
+enum {
+	OP_START =3D 0,
+	OP_TX_ONLY,
+	OP_TX_STOP,
+	OP_TX_TO_RX,
+	OP_RX_ONLY,
+	OP_RX_STOP,
+};
+
+struct sh_mobile_i2c_data {
+	struct device *dev;
+	void __iomem *reg;
+	struct i2c_adapter adap;
+
+	struct clk *clk;
+	u_int8_t iccl;
+	u_int8_t icch;
+
+	int fast_mode;
+	int rx_ack_high;
+
+	spinlock_t lock;
+	wait_queue_head_t wait;
+	struct i2c_msg *msg;
+	int pos;
+	int sr;
+};
+
+#define NORMAL_SPEED		100000
+#define FAST_SPEED		400000
+
+/* Register offsets */
+#define	ICDR(pd)		(pd->reg + 0x00)
+#define	ICCR(pd)		(pd->reg + 0x04)
+#define	ICSR(pd)		(pd->reg + 0x08)
+#define	ICIC(pd)		(pd->reg + 0x0c)
+#define	ICCL(pd)		(pd->reg + 0x10)
+#define	ICCH(pd)		(pd->reg + 0x14)
+
+/* Register bits */
+#define ICCR_ICE		0x80
+#define ICCR_RACK		0x40
+#define ICCR_TRS		0x10
+#define ICCR_BBSY		0x04
+#define ICCR_SCP		0x01
+
+#define ICSR_SCLM		0x80
+#define ICSR_SDAM		0x40
+#define SW_DONE			0x20
+#define ICSR_BUSY		0x10
+#define ICSR_AL			0x08
+#define ICSR_TACK		0x04
+#define ICSR_WAIT		0x02
+#define ICSR_DTE		0x01
+
+#define ICIC_ALE		0x08
+#define ICIC_TACKE		0x04
+#define ICIC_WAITE		0x02
+#define ICIC_DTEE		0x01
+
+static void activate_ch(struct sh_mobile_i2c_data *pd)
+{
+	/* Enable channel and configure rx ack */
+	iowrite8(ioread8(ICCR(pd))  | ICCR_ICE |
+		 (pd->rx_ack_high ? ICCR_RACK : 0), ICCR(pd));
+
+	/* Mask all interrupts */
+	iowrite8(0, ICIC(pd));
+
+	/* Set the clock */
+	iowrite8(pd->iccl, ICCL(pd));
+	iowrite8(pd->icch, ICCH(pd));
+}
+
+static void deactivate_ch(struct sh_mobile_i2c_data *pd)
+{
+	/* Clear/disable interrupts */
+	iowrite8(0, ICSR(pd));
+	iowrite8(0, ICIC(pd));
+
+	/* Initialize channel */
+	iowrite8(ioread8(ICCR(pd)) & ~ICCR_ICE, ICCR(pd));
+}
+
+static unsigned char i2c_op(struct sh_mobile_i2c_data *pd,
+			    int op, unsigned char data)
+{
+	unsigned char ret =3D 0;
+
+	dev_dbg(pd->dev, "op %d, data in 0x%02x\n", op, data);
+
+	spin_lock_irq(&pd->lock);
+
+	switch (op) {
+	case OP_START:
+		iowrite8(0x94, ICCR(pd));
+		break;
+	case OP_TX_ONLY:
+		iowrite8(data, ICDR(pd));
+		break;
+	case OP_TX_STOP:
+		iowrite8(data, ICDR(pd));
+		iowrite8(0x90, ICCR(pd));
+		iowrite8(ICIC_ALE | ICIC_TACKE, ICIC(pd));
+		break;
+	case OP_TX_TO_RX:
+		iowrite8(data, ICDR(pd));
+		iowrite8(0x81, ICCR(pd));
+		break;
+	case OP_RX_ONLY:
+		ret =3D ioread8(ICDR(pd));
+		break;
+	case OP_RX_STOP:
+		ret =3D ioread8(ICDR(pd));
+		iowrite8(0xc0, ICCR(pd));
+		break;
+	}
+
+	spin_unlock_irq(&pd->lock);
+
+	dev_dbg(pd->dev, "op %d, data out 0x%02x\n", op, ret);
+	return ret;
+}
+
+static irqreturn_t sh_mobile_i2c_isr(int irq, void *dev_id)
+{
+	struct platform_device *dev =3D dev_id;
+	struct sh_mobile_i2c_data *pd =3D platform_get_drvdata(dev);
+	struct i2c_msg *msg =3D pd->msg;
+	unsigned char data, sr;
+	int wakeup =3D 0;
+
+	sr =3D ioread8(ICSR(pd));
+	pd->sr |=3D sr;
+
+	dev_dbg(pd->dev, "i2c_isr 0x%02x 0x%02x %s %d %d!\n", sr, pd->sr,
+	       (msg->flags & I2C_M_RD) ? "read" : "write",
+	       pd->pos, msg->len);
+
+	if (sr & (ICSR_AL | ICSR_TACK)) {
+		iowrite8(0, ICIC(pd)); /* disable interrupts */
+		wakeup =3D 1;
+		goto do_wakeup;
+	}
+
+	if (pd->pos =3D=3D msg->len) {
+		i2c_op(pd, OP_RX_ONLY, 0);
+		wakeup =3D 1;
+		goto do_wakeup;
+	}
+
+	if (pd->pos =3D=3D -1) {
+		data =3D (msg->addr & 0x7f) << 1;
+		data |=3D (msg->flags & I2C_M_RD) ? 1 : 0;
+	} else
+		data =3D msg->buf[pd->pos];
+
+	if ((pd->pos =3D=3D -1) || !(msg->flags & I2C_M_RD)) {
+		if (msg->flags & I2C_M_RD)
+			i2c_op(pd, OP_TX_TO_RX, data);
+		else if (pd->pos =3D=3D (msg->len - 1)) {
+			i2c_op(pd, OP_TX_STOP, data);
+			wakeup =3D 1;
+		} else
+			i2c_op(pd, OP_TX_ONLY, data);
+	} else {
+		if (pd->pos =3D=3D (msg->len - 1))
+			data =3D i2c_op(pd, OP_RX_STOP, 0);
+		else
+			data =3D i2c_op(pd, OP_RX_ONLY, 0);
+
+		msg->buf[pd->pos] =3D data;
+	}
+	pd->pos++;
+
+ do_wakeup:
+	if (wakeup) {
+		pd->sr |=3D SW_DONE;
+		wake_up(&pd->wait);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int start_ch(struct sh_mobile_i2c_data *pd, struct i2c_msg *usr=
_msg)
+{
+	/* Initialize channel registers */
+	iowrite8(ioread8(ICCR(pd)) & ~ICCR_ICE, ICCR(pd));
+
+	/* Enable channel and configure rx ack */
+	iowrite8(ioread8(ICCR(pd)) | ICCR_ICE |
+		 (pd->rx_ack_high ? ICCR_RACK : 0), ICCR(pd));
+
+	/* Set the clock */
+	iowrite8(pd->iccl, ICCL(pd));
+	iowrite8(pd->icch, ICCH(pd));
+
+	pd->msg =3D usr_msg;
+	pd->pos =3D -1;
+	pd->sr =3D 0;
+
+	/* Enable all interrupts except wait */
+	iowrite8(ioread8(ICIC(pd)) | ICIC_ALE | ICIC_TACKE | ICIC_DTEE,
+		 ICIC(pd));
+	return 0;
+}
+
+static int sh_mobile_i2c_xfer(struct i2c_adapter *adapter,
+			      struct i2c_msg *msgs,
+			      int num)
+{
+	struct sh_mobile_i2c_data *pd =3D i2c_get_adapdata(adapter);
+	struct i2c_msg	*msg;
+	int err =3D 0;
+	u_int8_t val;
+	int i, k;
+
+	activate_ch(pd);
+
+	/* Process all messages */
+	for (i =3D 0; i < num; i++) {
+		msg =3D &msgs[i];
+
+		err =3D start_ch(pd, msg);
+		if (err)
+			break;
+
+		i2c_op(pd, OP_START, 0);
+
+		/* The interrupt handler takes care of the rest... */
+		k =3D wait_event_timeout(pd->wait,
+				       pd->sr & (ICSR_TACK | SW_DONE),
+				       5 * HZ);
+		if (!k)
+			dev_err(pd->dev, "Transfer request timed out\n");
+
+		k =3D 10;
+	again:
+		val =3D ioread8(ICSR(pd));
+
+		dev_dbg(pd->dev, "val 0x%02x pd->sr 0x%02x!\n", val, pd->sr);
+
+		if ((val | pd->sr) & (ICSR_TACK | ICSR_AL)) {
+			err =3D -EIO;
+			break;
+		}
+
+		if (!(!(val & ICSR_BUSY) && (val & ICSR_SCLM) &&
+		      (val & ICSR_SDAM))) {
+			msleep(1);
+			if (k--)
+				goto again;
+
+			err =3D -EIO;
+			dev_err(pd->dev, "Polling timed out\n");
+			break;
+		}
+	}
+
+	deactivate_ch(pd);
+
+	if (!err)
+		err =3D num;
+	return err;
+}
+
+static u32 sh_mobile_i2c_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+}
+
+static struct i2c_algorithm sh_mobile_i2c_algorithm =3D {
+	.functionality	=3D sh_mobile_i2c_func,
+	.master_xfer	=3D sh_mobile_i2c_xfer,
+};
+
+static void sh_mobile_i2c_setup_channel(struct platform_device *dev)
+{
+	struct sh_mobile_i2c_data *pd =3D platform_get_drvdata(dev);
+	unsigned long peripheral_clk =3D clk_get_rate(pd->clk);
+	u_int32_t num;
+	u_int32_t denom;
+	u_int32_t tmp;
+
+	spin_lock_init(&pd->lock);
+	init_waitqueue_head(&pd->wait);
+
+	/* Calculate the value for iccl. From the data sheet:
+	 * iccl =3D (p clock =C3=B7 transfer rate) =C3=97 (L =C3=B7 (L + H))
+	 * where L and H are the SCL low/high ratio (5/4 in this case).
+	 * We also round off the result.
+	 */
+	num =3D peripheral_clk * 5;
+	denom =3D pd->fast_mode ? (FAST_SPEED * 9) : (NORMAL_SPEED * 9);
+	tmp =3D num * 10 / denom;
+	if (tmp % 10 >=3D 5)
+		pd->iccl =3D (u_int8_t)((num/denom) + 1);
+	else
+		pd->iccl =3D (u_int8_t)(num/denom);
+
+	/* Calculate the value for icch. From the data sheet:
+	   icch =3D (p clock =C3=B7 transfer rate) =C3=97 (H =C3=B7 (L + H)) =
*/
+	num =3D peripheral_clk * 4;
+	tmp =3D num * 10 / denom;
+	if (tmp % 10 >=3D 5)
+		pd->icch =3D (u_int8_t)((num/denom) + 1);
+	else
+		pd->icch =3D (u_int8_t)(num/denom);
+
+	deactivate_ch(pd);
+}
+
+static int sh_mobile_i2c_hook_irqs(struct platform_device *dev, int ho=
ok)
+{
+	struct resource *res;
+	int ret =3D -ENXIO;
+	int q, m;
+	int k =3D 0;
+	int n =3D 0;
+
+	while ((res =3D platform_get_resource(dev, IORESOURCE_IRQ, k))) {
+		for (n =3D res->start; hook && n <=3D res->end; n++) {
+			if (request_irq(n, sh_mobile_i2c_isr, 0,
+					dev->dev.bus_id, dev))
+				goto rollback;
+		}
+		k++;
+	}
+
+	if (hook)
+		return k > 0 ? 0 : -ENOENT;
+
+	k--;
+	ret =3D 0;
+
+ rollback:
+	for (q =3D k; k >=3D 0; k--) {
+		for (m =3D n; m >=3D res->start; m--)
+			free_irq(m, dev);
+
+		res =3D platform_get_resource(dev, IORESOURCE_IRQ, k - 1);
+		m =3D res->end;
+	}
+
+	return ret;
+}
+
+static int sh_mobile_i2c_probe(struct platform_device *dev)
+{
+	struct sh_mobile_i2c_data *pd;
+	struct i2c_adapter *adap;
+	struct resource *res;
+	int size;
+	int ret;
+
+	pd =3D kzalloc(sizeof(struct sh_mobile_i2c_data), GFP_KERNEL);
+	if (pd =3D=3D NULL) {
+		dev_err(&dev->dev, "cannot allocate private data\n");
+		return -ENOMEM;
+	}
+
+	pd->clk =3D clk_get(&dev->dev, "peripheral_clk");
+	if (IS_ERR(pd->clk)) {
+		dev_err(&dev->dev, "cannot get peripheral clock\n");
+		ret =3D PTR_ERR(pd->clk);
+		goto err;
+	}
+
+	ret =3D sh_mobile_i2c_hook_irqs(dev, 1);
+	if (ret) {
+		dev_err(&dev->dev, "cannot request IRQ\n");
+		goto err_clk;
+	}
+
+	pd->dev =3D &dev->dev;
+	platform_set_drvdata(dev, pd);
+
+	res =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (res =3D=3D NULL) {
+		dev_err(&dev->dev, "cannot find IO resource\n");
+		ret =3D -ENOENT;
+		goto err_irq;
+	}
+
+	size =3D (res->end - res->start) + 1;
+
+	pd->reg =3D ioremap(res->start, size);
+	if (pd->reg =3D=3D NULL) {
+		dev_err(&dev->dev, "cannot map IO\n");
+		ret =3D -ENXIO;
+		goto err_irq;
+	}
+
+	/* setup the private data */
+	adap =3D &pd->adap;
+	i2c_set_adapdata(adap, pd);
+
+	adap->owner =3D THIS_MODULE;
+	adap->algo =3D &sh_mobile_i2c_algorithm;
+	adap->dev.parent =3D &dev->dev;
+	adap->retries =3D 5;
+	adap->nr =3D dev->id;
+
+	strlcpy(adap->name, dev->name, sizeof(adap->name));
+
+	sh_mobile_i2c_setup_channel(dev);
+
+	ret =3D i2c_add_numbered_adapter(adap);
+	if (ret < 0)
+		goto err_all;
+
+	return 0;
+
+ err_all:
+	iounmap(pd->reg);
+ err_irq:
+	sh_mobile_i2c_hook_irqs(dev, 0);
+ err_clk:
+	clk_put(pd->clk);
+ err:
+	kfree(pd);
+	return ret;
+}
+
+static int sh_mobile_i2c_remove(struct platform_device *dev)
+{
+	struct sh_mobile_i2c_data *pd =3D platform_get_drvdata(dev);
+
+	i2c_del_adapter(&pd->adap);
+	iounmap(pd->reg);
+	sh_mobile_i2c_hook_irqs(dev, 0);
+	clk_put(pd->clk);
+	kfree(pd);
+	return 0;
+}
+
+static struct platform_driver sh_mobile_i2c_driver =3D {
+	.driver		=3D {
+		.name		=3D "i2c-sh_mobile",
+		.owner		=3D THIS_MODULE,
+	},
+	.probe		=3D sh_mobile_i2c_probe,
+	.remove		=3D sh_mobile_i2c_remove,
+};
+
+static int __init sh_mobile_i2c_adap_init(void)
+{
+	return platform_driver_register(&sh_mobile_i2c_driver);
+}
+
+static void __exit sh_mobile_i2c_adap_exit(void)
+{
+	platform_driver_unregister(&sh_mobile_i2c_driver);
+}
+
+module_init(sh_mobile_i2c_adap_init);
+module_exit(sh_mobile_i2c_adap_exit);
+
+MODULE_DESCRIPTION("SuperH Mobile I2C Bus Controller driver");
+MODULE_AUTHOR("Magnus Damm");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
i2c-renesas-highlander-fpga-smbus-support.patch
i2c-superh-mobile-i2c-bus-controller-v3.patch
i2c-superh-mobile-i2c-bus-controller-v3-checkpatch-fixes.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-s390.patch
git-sh.patch
taint-kernel-after-warn_oncondition.patch
sm501-add-uart-support.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
asm-futexh-should-include-linux-uaccessh.patch
remove-duplicated-unlikely-in-is_err.patch
introduce-a-generic-__fls-implementation.patch
implement-__fls-on-all-64-bit-archs.patch
use-__fls-for-fls64-on-64-bit-archs.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
