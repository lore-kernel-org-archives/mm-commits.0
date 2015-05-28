From: akpm@linux-foundation.org
Subject: + w1-masters-omap_hdq-add-support-for-1-wire-mode.patch added to
 -mm tree
Date: Thu, 28 May 2015 14:27:36 -0700
Message-ID: <55678848.HQOk9502Lf5NVumS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233AbbE1V1h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 17:27:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vigneshr@ti.com, corbet@lwn.net, fabf@skynet.be, galak@codeaurora.org, gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk, mark.rutland@arm.com, neilb@suse.de, pawel.moll@arm.com, robh+dt@kernel.org, tony@atomide.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: w1: masters: omap_hdq: add support for 1-wire mode
has been added to the -mm tree.  Its filename is
     w1-masters-omap_hdq-add-support-for-1-wire-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/w1-masters-omap_hdq-add-support-for-1-wire-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vignesh R <vigneshr@ti.com>
Subject: w1: masters: omap_hdq: add support for 1-wire mode

This patches makes following changes to omap_hdq driver
 - Enable 1-wire mode.
 - Implement w1_triplet callback to facilitate search rom
   procedure and auto detection of 1-wire slaves.
 - Proper enabling and disabling of interrupt.
 - Cleanups (formatting and return value checks).

HDQ mode remains unchanged.

Signed-off-by: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jonathan Corbet <corbet@lwn.net>
CC: Tony Lindgren <tony@atomide.com>
Cc: Vignesh R <vigneshr@ti.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/w1/omap-hdq.txt |    7 
 Documentation/w1/masters/omap-hdq                 |    6 
 drivers/w1/masters/omap_hdq.c                     |  224 ++++++++++--
 3 files changed, 203 insertions(+), 34 deletions(-)

diff -puN Documentation/devicetree/bindings/w1/omap-hdq.txt~w1-masters-omap_hdq-add-support-for-1-wire-mode Documentation/devicetree/bindings/w1/omap-hdq.txt
--- a/Documentation/devicetree/bindings/w1/omap-hdq.txt~w1-masters-omap_hdq-add-support-for-1-wire-mode
+++ a/Documentation/devicetree/bindings/w1/omap-hdq.txt
@@ -1,11 +1,15 @@
 * OMAP HDQ One wire bus master controller
 
 Required properties:
-- compatible : should be "ti,omap3-1w"
+- compatible : should be "ti,omap3-1w" or "ti,am4372-hdq"
 - reg : Address and length of the register set for the device
 - interrupts : interrupt line.
 - ti,hwmods : "hdq1w"
 
+Optional properties:
+- ti,mode: should be "hdq": HDQ mode  "1w": one-wire mode.
+	   If not specified HDQ mode is implied.
+
 Example:
 
 - From omap3.dtsi
@@ -14,4 +18,5 @@ Example:
 	reg = <0x480b2000 0x1000>;
 	interrupts = <58>;
 	ti,hwmods = "hdq1w";
+	ti,mode = "hdq";
   };
diff -puN Documentation/w1/masters/omap-hdq~w1-masters-omap_hdq-add-support-for-1-wire-mode Documentation/w1/masters/omap-hdq
--- a/Documentation/w1/masters/omap-hdq~w1-masters-omap_hdq-add-support-for-1-wire-mode
+++ a/Documentation/w1/masters/omap-hdq
@@ -44,3 +44,9 @@ e.g:
 insmod omap_hdq.ko W1_ID=2
 inamod w1_bq27000.ko F_ID=2
 
+The driver also supports 1-wire mode. In this mode, there is no need to
+pass slave ID as parameter. The driver will auto-detect slaves connected
+to the bus using SEARCH_ROM procedure. 1-wire mode can be selected by
+setting "ti,mode" property to "1w" in DT (see
+Documentation/devicetree/bindings/w1/omap-hdq.txt for more details).
+By default driver is in HDQ mode.
diff -puN drivers/w1/masters/omap_hdq.c~w1-masters-omap_hdq-add-support-for-1-wire-mode drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-masters-omap_hdq-add-support-for-1-wire-mode
+++ a/drivers/w1/masters/omap_hdq.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/sched.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -27,21 +28,23 @@
 #define OMAP_HDQ_TX_DATA			0x04
 #define OMAP_HDQ_RX_DATA			0x08
 #define OMAP_HDQ_CTRL_STATUS			0x0c
-#define OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK	(1<<6)
-#define OMAP_HDQ_CTRL_STATUS_CLOCKENABLE	(1<<5)
-#define OMAP_HDQ_CTRL_STATUS_GO			(1<<4)
-#define OMAP_HDQ_CTRL_STATUS_INITIALIZATION	(1<<2)
-#define OMAP_HDQ_CTRL_STATUS_DIR		(1<<1)
-#define OMAP_HDQ_CTRL_STATUS_MODE		(1<<0)
+#define OMAP_HDQ_CTRL_STATUS_SINGLE		BIT(7)
+#define OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK	BIT(6)
+#define OMAP_HDQ_CTRL_STATUS_CLOCKENABLE	BIT(5)
+#define OMAP_HDQ_CTRL_STATUS_GO                 BIT(4)
+#define OMAP_HDQ_CTRL_STATUS_PRESENCE		BIT(3)
+#define OMAP_HDQ_CTRL_STATUS_INITIALIZATION	BIT(2)
+#define OMAP_HDQ_CTRL_STATUS_DIR		BIT(1)
 #define OMAP_HDQ_INT_STATUS			0x10
-#define OMAP_HDQ_INT_STATUS_TXCOMPLETE		(1<<2)
-#define OMAP_HDQ_INT_STATUS_RXCOMPLETE		(1<<1)
-#define OMAP_HDQ_INT_STATUS_TIMEOUT		(1<<0)
+#define OMAP_HDQ_INT_STATUS_TXCOMPLETE		BIT(2)
+#define OMAP_HDQ_INT_STATUS_RXCOMPLETE		BIT(1)
+#define OMAP_HDQ_INT_STATUS_TIMEOUT		BIT(0)
 #define OMAP_HDQ_SYSCONFIG			0x14
-#define OMAP_HDQ_SYSCONFIG_SOFTRESET		(1<<1)
-#define OMAP_HDQ_SYSCONFIG_AUTOIDLE		(1<<0)
+#define OMAP_HDQ_SYSCONFIG_SOFTRESET		BIT(1)
+#define OMAP_HDQ_SYSCONFIG_AUTOIDLE		BIT(0)
+#define OMAP_HDQ_SYSCONFIG_NOIDLE		0x0
 #define OMAP_HDQ_SYSSTATUS			0x18
-#define OMAP_HDQ_SYSSTATUS_RESETDONE		(1<<0)
+#define OMAP_HDQ_SYSSTATUS_RESETDONE		BIT(0)
 
 #define OMAP_HDQ_FLAG_CLEAR			0
 #define OMAP_HDQ_FLAG_SET			1
@@ -67,6 +70,10 @@ struct hdq_data {
 	 * the data wrire or read.
 	 */
 	int			init_trans;
+	int                     rrw;
+	/* mode: 0-HDQ 1-W1 */
+	int                     mode;
+
 };
 
 static int omap_hdq_probe(struct platform_device *pdev);
@@ -74,6 +81,7 @@ static int omap_hdq_remove(struct platfo
 
 static const struct of_device_id omap_hdq_dt_ids[] = {
 	{ .compatible = "ti,omap3-1w" },
+	{ .compatible = "ti,am4372-hdq" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, omap_hdq_dt_ids);
@@ -90,15 +98,12 @@ static struct platform_driver omap_hdq_d
 static u8 omap_w1_read_byte(void *_hdq);
 static void omap_w1_write_byte(void *_hdq, u8 byte);
 static u8 omap_w1_reset_bus(void *_hdq);
-static void omap_w1_search_bus(void *_hdq, struct w1_master *master_dev,
-		u8 search_type,	w1_slave_found_callback slave_found);
 
 
 static struct w1_bus_master omap_w1_master = {
 	.read_byte	= omap_w1_read_byte,
 	.write_byte	= omap_w1_write_byte,
 	.reset_bus	= omap_w1_reset_bus,
-	.search		= omap_w1_search_bus,
 };
 
 /* HDQ register I/O routines */
@@ -122,6 +127,15 @@ static inline u8 hdq_reg_merge(struct hd
 	return new_val;
 }
 
+static void hdq_disable_interrupt(struct hdq_data *hdq_data, u32 offset,
+				  u32 mask)
+{
+	u32 ie;
+
+	ie = readl(hdq_data->hdq_base + offset);
+	writel(ie & mask, hdq_data->hdq_base + offset);
+}
+
 /*
  * Wait for one or more bits in flag change.
  * HDQ_FLAG_SET: wait until any bit in the flag is set.
@@ -229,13 +243,7 @@ static irqreturn_t hdq_isr(int irq, void
 	return IRQ_HANDLED;
 }
 
-/* HDQ Mode: always return success */
-static u8 omap_w1_reset_bus(void *_hdq)
-{
-	return 0;
-}
-
-/* W1 search callback function */
+/* W1 search callback function  in HDQ mode */
 static void omap_w1_search_bus(void *_hdq, struct w1_master *master_dev,
 		u8 search_type, w1_slave_found_callback slave_found)
 {
@@ -262,9 +270,10 @@ static int _omap_hdq_reset(struct hdq_da
 	int ret;
 	u8 tmp_status;
 
-	hdq_reg_out(hdq_data, OMAP_HDQ_SYSCONFIG, OMAP_HDQ_SYSCONFIG_SOFTRESET);
+	hdq_reg_out(hdq_data, OMAP_HDQ_SYSCONFIG,
+		    OMAP_HDQ_SYSCONFIG_SOFTRESET);
 	/*
-	 * Select HDQ mode & enable clocks.
+	 * Select HDQ/1W mode & enable clocks.
 	 * It is observed that INT flags can't be cleared via a read and GO/INIT
 	 * won't return to zero if interrupt is disabled. So we always enable
 	 * interrupt.
@@ -282,7 +291,8 @@ static int _omap_hdq_reset(struct hdq_da
 	else {
 		hdq_reg_out(hdq_data, OMAP_HDQ_CTRL_STATUS,
 			OMAP_HDQ_CTRL_STATUS_CLOCKENABLE |
-			OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK);
+			OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK |
+			hdq_data->mode);
 		hdq_reg_out(hdq_data, OMAP_HDQ_SYSCONFIG,
 			OMAP_HDQ_SYSCONFIG_AUTOIDLE);
 	}
@@ -334,6 +344,18 @@ static int omap_hdq_break(struct hdq_dat
 		ret = -ETIMEDOUT;
 		goto out;
 	}
+
+	/*
+	 * check for the presence detect bit to get
+	 * set to show that the slave is responding
+	 */
+	if (!(hdq_reg_in(hdq_data, OMAP_HDQ_CTRL_STATUS) &
+			OMAP_HDQ_CTRL_STATUS_PRESENCE)) {
+		dev_dbg(hdq_data->dev, "Presence bit not set\n");
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
 	/*
 	 * wait for both INIT and GO bits rerurn to zero.
 	 * zero wait time expected for interrupt mode.
@@ -368,6 +390,8 @@ static int hdq_read_byte(struct hdq_data
 		goto out;
 	}
 
+	hdq_data->hdq_irqstatus = 0;
+
 	if (!(hdq_data->hdq_irqstatus & OMAP_HDQ_INT_STATUS_RXCOMPLETE)) {
 		hdq_reg_merge(hdq_data, OMAP_HDQ_CTRL_STATUS,
 			OMAP_HDQ_CTRL_STATUS_DIR | OMAP_HDQ_CTRL_STATUS_GO,
@@ -400,7 +424,7 @@ rtn:
 
 }
 
-/* Enable clocks and set the controller to HDQ mode */
+/* Enable clocks and set the controller to HDQ/1W mode */
 static int omap_hdq_get(struct hdq_data *hdq_data)
 {
 	int ret = 0;
@@ -422,7 +446,7 @@ static int omap_hdq_get(struct hdq_data
 
 			pm_runtime_get_sync(hdq_data->dev);
 
-			/* make sure HDQ is out of reset */
+			/* make sure HDQ/1W is out of reset */
 			if (!(hdq_reg_in(hdq_data, OMAP_HDQ_SYSSTATUS) &
 				OMAP_HDQ_SYSSTATUS_RESETDONE)) {
 				ret = _omap_hdq_reset(hdq_data);
@@ -430,12 +454,13 @@ static int omap_hdq_get(struct hdq_data
 					/* back up the count */
 					hdq_data->hdq_usecount--;
 			} else {
-				/* select HDQ mode & enable clocks */
+				/* select HDQ/1W mode & enable clocks */
 				hdq_reg_out(hdq_data, OMAP_HDQ_CTRL_STATUS,
 					OMAP_HDQ_CTRL_STATUS_CLOCKENABLE |
-					OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK);
+					OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK |
+					hdq_data->mode);
 				hdq_reg_out(hdq_data, OMAP_HDQ_SYSCONFIG,
-					OMAP_HDQ_SYSCONFIG_AUTOIDLE);
+					OMAP_HDQ_SYSCONFIG_NOIDLE);
 				hdq_reg_in(hdq_data, OMAP_HDQ_INT_STATUS);
 			}
 		}
@@ -456,6 +481,8 @@ static int omap_hdq_put(struct hdq_data
 	if (ret < 0)
 		return -EINTR;
 
+	hdq_reg_out(hdq_data, OMAP_HDQ_SYSCONFIG,
+		    OMAP_HDQ_SYSCONFIG_AUTOIDLE);
 	if (0 == hdq_data->hdq_usecount) {
 		dev_dbg(hdq_data->dev, "attempt to decrement use count"
 			" when it is zero");
@@ -471,6 +498,100 @@ static int omap_hdq_put(struct hdq_data
 	return ret;
 }
 
+/*
+ * W1 triplet callback function - used for searching ROM addresses.
+ * Registered only when controller is in 1-wire mode.
+ */
+static u8 omap_w1_triplet(void *_hdq, u8 bdir)
+{
+	u8 id_bit, comp_bit;
+	int err;
+	u8 ret = 0x3; /* no slaves responded */
+	struct hdq_data *hdq_data = _hdq;
+	u8 ctrl = OMAP_HDQ_CTRL_STATUS_SINGLE | OMAP_HDQ_CTRL_STATUS_GO |
+		  OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK;
+	u8 mask = ctrl | OMAP_HDQ_CTRL_STATUS_DIR;
+
+	omap_hdq_get(_hdq);
+
+	err = mutex_lock_interruptible(&hdq_data->hdq_mutex);
+	if (err < 0) {
+		dev_dbg(hdq_data->dev, "Could not acquire mutex\n");
+		goto rtn;
+	}
+
+	hdq_data->hdq_irqstatus = 0;
+	/* read id_bit */
+	hdq_reg_merge(_hdq, OMAP_HDQ_CTRL_STATUS,
+		      ctrl | OMAP_HDQ_CTRL_STATUS_DIR, mask);
+	err = wait_event_timeout(hdq_wait_queue,
+				 (hdq_data->hdq_irqstatus
+				  & OMAP_HDQ_INT_STATUS_RXCOMPLETE),
+				 OMAP_HDQ_TIMEOUT);
+	if (err == 0) {
+		dev_dbg(hdq_data->dev, "RX wait elapsed\n");
+		goto out;
+	}
+	id_bit = (hdq_reg_in(_hdq, OMAP_HDQ_RX_DATA) & 0x01);
+
+	hdq_data->hdq_irqstatus = 0;
+	/* read comp_bit */
+	hdq_reg_merge(_hdq, OMAP_HDQ_CTRL_STATUS,
+		      ctrl | OMAP_HDQ_CTRL_STATUS_DIR, mask);
+	err = wait_event_timeout(hdq_wait_queue,
+				 (hdq_data->hdq_irqstatus
+				  & OMAP_HDQ_INT_STATUS_RXCOMPLETE),
+				 OMAP_HDQ_TIMEOUT);
+	if (err == 0) {
+		dev_dbg(hdq_data->dev, "RX wait elapsed\n");
+		goto out;
+	}
+	comp_bit = (hdq_reg_in(_hdq, OMAP_HDQ_RX_DATA) & 0x01);
+
+	if (id_bit && comp_bit) {
+		ret = 0x03;  /* no slaves responded */
+		goto out;
+	}
+	if (!id_bit && !comp_bit) {
+		/* Both bits are valid, take the direction given */
+		ret = bdir ? 0x04 : 0;
+	} else {
+		/* Only one bit is valid, take that direction */
+		bdir = id_bit;
+		ret = id_bit ? 0x05 : 0x02;
+	}
+
+	/* write bdir bit */
+	hdq_reg_out(_hdq, OMAP_HDQ_TX_DATA, bdir);
+	hdq_reg_merge(_hdq, OMAP_HDQ_CTRL_STATUS, ctrl, mask);
+	err = wait_event_timeout(hdq_wait_queue,
+				 (hdq_data->hdq_irqstatus
+				  & OMAP_HDQ_INT_STATUS_TXCOMPLETE),
+				 OMAP_HDQ_TIMEOUT);
+	if (err == 0) {
+		dev_dbg(hdq_data->dev, "TX wait elapsed\n");
+		goto out;
+	}
+
+	hdq_reg_merge(_hdq, OMAP_HDQ_CTRL_STATUS, 0,
+		      OMAP_HDQ_CTRL_STATUS_SINGLE);
+
+out:
+	mutex_unlock(&hdq_data->hdq_mutex);
+rtn:
+	omap_hdq_put(_hdq);
+	return ret;
+}
+
+/* reset callback */
+static u8 omap_w1_reset_bus(void *_hdq)
+{
+	omap_hdq_get(_hdq);
+	omap_hdq_break(_hdq);
+	omap_hdq_put(_hdq);
+	return 0;
+}
+
 /* Read a byte of data from the device */
 static u8 omap_w1_read_byte(void *_hdq)
 {
@@ -478,6 +599,10 @@ static u8 omap_w1_read_byte(void *_hdq)
 	u8 val = 0;
 	int ret;
 
+	/* First write to initialize the transfer */
+	if (hdq_data->init_trans == 0)
+		omap_hdq_get(hdq_data);
+
 	ret = hdq_read_byte(hdq_data, &val);
 	if (ret) {
 		ret = mutex_lock_interruptible(&hdq_data->hdq_mutex);
@@ -491,6 +616,10 @@ static u8 omap_w1_read_byte(void *_hdq)
 		return -1;
 	}
 
+	hdq_disable_interrupt(hdq_data, OMAP_HDQ_CTRL_STATUS,
+			      ~OMAP_HDQ_CTRL_STATUS_INTERRUPTMASK);
+	hdq_data->hdq_usecount = 0;
+
 	/* Write followed by a read, release the module */
 	if (hdq_data->init_trans) {
 		ret = mutex_lock_interruptible(&hdq_data->hdq_mutex);
@@ -517,6 +646,14 @@ static void omap_w1_write_byte(void *_hd
 	if (hdq_data->init_trans == 0)
 		omap_hdq_get(hdq_data);
 
+	/*
+	 * We need to reset the slave before
+	 * issuing the SKIP ROM command, else
+	 * the slave will not work.
+	 */
+	if (byte == W1_SKIP_ROM)
+		omap_hdq_break(hdq_data);
+
 	ret = mutex_lock_interruptible(&hdq_data->hdq_mutex);
 	if (ret < 0) {
 		dev_dbg(hdq_data->dev, "Could not acquire mutex\n");
@@ -551,6 +688,7 @@ static int omap_hdq_probe(struct platfor
 	struct resource *res;
 	int ret, irq;
 	u8 rev;
+	const char *mode;
 
 	hdq_data = devm_kzalloc(dev, sizeof(*hdq_data), GFP_KERNEL);
 	if (!hdq_data) {
@@ -567,10 +705,21 @@ static int omap_hdq_probe(struct platfor
 		return PTR_ERR(hdq_data->hdq_base);
 
 	hdq_data->hdq_usecount = 0;
+	hdq_data->rrw = 0;
 	mutex_init(&hdq_data->hdq_mutex);
 
 	pm_runtime_enable(&pdev->dev);
-	pm_runtime_get_sync(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		dev_dbg(&pdev->dev, "pm_runtime_get_sync failed\n");
+		goto err_w1;
+	}
+
+	ret = _omap_hdq_reset(hdq_data);
+	if (ret) {
+		dev_dbg(&pdev->dev, "reset failed\n");
+		return -EINVAL;
+	}
 
 	rev = hdq_reg_in(hdq_data, OMAP_HDQ_REVISION);
 	dev_info(&pdev->dev, "OMAP HDQ Hardware Rev %c.%c. Driver in %s mode\n",
@@ -594,6 +743,15 @@ static int omap_hdq_probe(struct platfor
 
 	pm_runtime_put_sync(&pdev->dev);
 
+	ret = of_property_read_string(pdev->dev.of_node, "ti,mode", &mode);
+	if (ret < 0 || !strcmp(mode, "hdq")) {
+		hdq_data->mode = 0;
+		omap_w1_master.search = omap_w1_search_bus;
+	} else {
+		hdq_data->mode = 1;
+		omap_w1_master.triplet = omap_w1_triplet;
+	}
+
 	omap_w1_master.data = hdq_data;
 
 	ret = w1_add_master_device(&omap_w1_master);
@@ -635,8 +793,8 @@ static int omap_hdq_remove(struct platfo
 module_platform_driver(omap_hdq_driver);
 
 module_param(w1_id, int, S_IRUSR);
-MODULE_PARM_DESC(w1_id, "1-wire id for the slave detection");
+MODULE_PARM_DESC(w1_id, "1-wire id for the slave detection in HDQ mode");
 
 MODULE_AUTHOR("Texas Instruments");
-MODULE_DESCRIPTION("HDQ driver Library");
+MODULE_DESCRIPTION("HDQ-1W driver Library");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from vigneshr@ti.com are

w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch

