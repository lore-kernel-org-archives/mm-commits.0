From: akpm@linux-foundation.org
Subject: + driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-update.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:42:56 -0700
Message-ID: <200704280042.l3S0gugI011736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757974AbXD1AnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mreimer@vpop.net, johnpol@2ka.mipt.ru


The patch titled
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core update
has been added to the -mm tree.  Its filename is
     driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core update
From: Matt Reimer <mreimer@vpop.net>

Thanks for your review Andrew. I made all the code changes you
suggested in the attached patch.

Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |   94 +++++++++++++++++------------------
 include/linux/ds1wm.h      |    1 
 2 files changed, 46 insertions(+), 49 deletions(-)

diff -puN drivers/w1/masters/ds1wm.c~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-update drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-update
+++ a/drivers/w1/masters/ds1wm.c
@@ -32,26 +32,27 @@
 #define DS1WM_INT_EN	0x03	/* R/W interrupt enable */
 #define DS1WM_CLKDIV	0x04	/* R/W 5 bits of divisor and pre-scale */
 
-#define DS1WM_CMD_1W_RESET  1 << 0	/* force reset on 1-wire bus */
-#define DS1WM_CMD_SRA	    1 << 1	/* enable Search ROM accelerator mode */
-#define DS1WM_CMD_DQ_OUTPUT 1 << 2	/* write only - forces bus low */
-#define DS1WM_CMD_DQ_INPUT  1 << 3	/* read only - reflects state of bus */
-
-#define DS1WM_INT_PD	    1 << 0	/* presence detect */
-#define DS1WM_INT_PDR	    1 << 1	/* presence detect result */
-#define DS1WM_INT_TBE	    1 << 2	/* tx buffer empty */
-#define DS1WM_INT_TSRE	    1 << 3	/* tx shift register empty */
-#define DS1WM_INT_RBF	    1 << 4	/* rx buffer full */
-#define DS1WM_INT_RSRF	    1 << 5	/* rx shift register full */
-
-#define DS1WM_INTEN_EPD	    1 << 0	/* enable presence detect int */
-#define DS1WM_INTEN_IAS	    1 << 1	/* INTR active state */
-#define DS1WM_INTEN_ETBE    1 << 2	/* enable tx buffer empty int */
-#define DS1WM_INTEN_ETMT    1 << 3	/* enable tx shift register empty int */
-#define DS1WM_INTEN_ERBF    1 << 4	/* enable rx buffer full int */
-#define DS1WM_INTEN_ERSRF   1 << 5	/* enable rx shift register full int */
-#define DS1WM_INTEN_DQO	    1 << 6	/* enable direct bus driving ops
-					   (undocumented), Szabolcs Gyurko */
+#define DS1WM_CMD_1W_RESET  (1 << 0)	/* force reset on 1-wire bus */
+#define DS1WM_CMD_SRA	    (1 << 1)	/* enable Search ROM accelerator mode */
+#define DS1WM_CMD_DQ_OUTPUT (1 << 2)	/* write only - forces bus low */
+#define DS1WM_CMD_DQ_INPUT  (1 << 3)	/* read only - reflects state of bus */
+#define DS1WM_CMD_RST	    (1 << 5)	/* software reset */
+#define DS1WM_CMD_OD	    (1 << 7)	/* overdrive */
+
+#define DS1WM_INT_PD	    (1 << 0)	/* presence detect */
+#define DS1WM_INT_PDR	    (1 << 1)	/* presence detect result */
+#define DS1WM_INT_TBE	    (1 << 2)	/* tx buffer empty */
+#define DS1WM_INT_TSRE	    (1 << 3)	/* tx shift register empty */
+#define DS1WM_INT_RBF	    (1 << 4)	/* rx buffer full */
+#define DS1WM_INT_RSRF	    (1 << 5)	/* rx shift register full */
+
+#define DS1WM_INTEN_EPD	    (1 << 0)	/* enable presence detect int */
+#define DS1WM_INTEN_IAS	    (1 << 1)	/* INTR active state */
+#define DS1WM_INTEN_ETBE    (1 << 2)	/* enable tx buffer empty int */
+#define DS1WM_INTEN_ETMT    (1 << 3)	/* enable tx shift register empty int */
+#define DS1WM_INTEN_ERBF    (1 << 4)	/* enable rx buffer full int */
+#define DS1WM_INTEN_ERSRF   (1 << 5)	/* enable rx shift register full int */
+#define DS1WM_INTEN_DQO	    (1 << 6)	/* enable direct bus driving ops */
 
 
 #define DS1WM_TIMEOUT (HZ * 5)
@@ -114,11 +115,14 @@ static irqreturn_t ds1wm_isr(int isr, vo
 	struct ds1wm_data *ds1wm_data = data;
 	u8 intr = ds1wm_read_register(ds1wm_data, DS1WM_INT);
 
-	ds1wm_data->slave_present = intr & DS1WM_INT_PDR ? 0 : 1;
+	ds1wm_data->slave_present = (intr & DS1WM_INT_PDR) ? 0 : 1;
 
-	if (intr & DS1WM_INT_PD && ds1wm_data->reset_complete)
+	if ((intr & DS1WM_INT_PD) && ds1wm_data->reset_complete)
 		complete(ds1wm_data->reset_complete);
 
+	if ((intr & DS1WM_INT_TSRE) && ds1wm_data->write_complete)
+		complete(ds1wm_data->write_complete);
+
 	if (intr & DS1WM_INT_RBF) {
 		ds1wm_data->read_byte = ds1wm_read_register(ds1wm_data,
 							    DS1WM_DATA);
@@ -126,16 +130,13 @@ static irqreturn_t ds1wm_isr(int isr, vo
 			complete(ds1wm_data->read_complete);
 	}
 
-	if (intr & DS1WM_INT_TSRE && ds1wm_data->write_complete)
-		complete(ds1wm_data->write_complete);
-
 	return IRQ_HANDLED;
 }
 
 static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 {
 	unsigned long timeleft;
-	DECLARE_COMPLETION(reset_done);
+	DECLARE_COMPLETION_ONSTACK(reset_done);
 
 	ds1wm_data->reset_complete = &reset_done;
 
@@ -174,7 +175,7 @@ static int ds1wm_reset(struct ds1wm_data
 
 static int ds1wm_write(struct ds1wm_data *ds1wm_data, u8 data)
 {
-	DECLARE_COMPLETION(write_done);
+	DECLARE_COMPLETION_ONSTACK(write_done);
 	ds1wm_data->write_complete = &write_done;
 
 	ds1wm_write_register(ds1wm_data, DS1WM_DATA, data);
@@ -187,7 +188,7 @@ static int ds1wm_write(struct ds1wm_data
 
 static int ds1wm_read(struct ds1wm_data *ds1wm_data, unsigned char write_data)
 {
-	DECLARE_COMPLETION(read_done);
+	DECLARE_COMPLETION_ONSTACK(read_done);
 	ds1wm_data->read_complete = &read_done;
 
 	ds1wm_write(ds1wm_data, write_data);
@@ -201,7 +202,7 @@ static int ds1wm_find_divisor(int gclk)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE (freq); i++)
+	for (i = 0; i < ARRAY_SIZE(freq); i++)
 		if (gclk <= freq[i].freq)
 			return freq[i].divisor;
 
@@ -228,12 +229,13 @@ static void ds1wm_up(struct ds1wm_data *
 	/* Let the w1 clock stabilize. */
 	msleep(1);
 
-	enable_irq(ds1wm_data->irq);
+	ds1wm_reset(ds1wm_data);
 }
 
 static void ds1wm_down(struct ds1wm_data *ds1wm_data)
 {
-	disable_irq(ds1wm_data->irq);
+	ds1wm_reset(ds1wm_data);
+
 	if (ds1wm_data->pdata->disable)
 		ds1wm_data->pdata->disable(ds1wm_data->pdev);
 
@@ -348,23 +350,20 @@ static int ds1wm_probe(struct platform_d
 	ds1wm_data->pdev = pdev;
 	ds1wm_data->pdata = plat;
 
-	ds1wm_data->irq = platform_get_irq(pdev, 0);
-	if (ds1wm_data->irq < 0) {
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
 		ret = -ENXIO;
 		goto err1;
 	}
+	ds1wm_data->irq = res->start;
+
+	set_irq_type(ds1wm_data->irq, res->flags & IORESOURCE_IRQ_LOWEDGE ?
+			IRQ_TYPE_EDGE_FALLING : IRQ_TYPE_EDGE_RISING);
 
-	if (plat->falling_edge)
-		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
-	else
-		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
-
-	ret = request_irq(ds1wm_data->irq, ds1wm_isr,
-			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM, "ds1wm",
-			  ds1wm_data);
+	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
+			  "ds1wm", ds1wm_data);
 	if (ret)
 		goto err1;
-	disable_irq(ds1wm_data->irq);
 
 	ds1wm_data->clk = clk_get(&pdev->dev, "ds1wm");
 	if (!ds1wm_data->clk) {
@@ -383,7 +382,6 @@ static int ds1wm_probe(struct platform_d
 	return 0;
 
 err3:
-	ds1wm_reset(ds1wm_data);
 	ds1wm_down(ds1wm_data);
 	clk_put(ds1wm_data->clk);
 err2:
@@ -414,6 +412,9 @@ static int ds1wm_resume(struct platform_
 
 	return 0;
 }
+#else
+#define ds1wm_suspend NULL
+#define ds1wm_resume NULL
 #endif
 
 static int ds1wm_remove(struct platform_device *pdev)
@@ -421,7 +422,6 @@ static int ds1wm_remove(struct platform_
 	struct ds1wm_data *ds1wm_data = platform_get_drvdata(pdev);
 
 	w1_remove_master_device(&ds1wm_master);
-	ds1wm_reset(ds1wm_data);
 	ds1wm_down(ds1wm_data);
 	clk_put(ds1wm_data->clk);
 	free_irq(ds1wm_data->irq, ds1wm_data);
@@ -437,19 +437,17 @@ static struct platform_driver ds1wm_driv
 	},
 	.probe    = ds1wm_probe,
 	.remove   = ds1wm_remove,
-#ifdef CONFIG_PM
 	.suspend  = ds1wm_suspend,
 	.resume   = ds1wm_resume
-#endif
 };
 
-static int ds1wm_init(void)
+static int __init ds1wm_init(void)
 {
 	printk("DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko\n");
 	return platform_driver_register(&ds1wm_driver);
 }
 
-static void ds1wm_exit(void)
+static void __exit ds1wm_exit(void)
 {
 	platform_driver_unregister(&ds1wm_driver);
 }
diff -puN include/linux/ds1wm.h~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-update include/linux/ds1wm.h
--- a/include/linux/ds1wm.h~driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-update
+++ a/include/linux/ds1wm.h
@@ -6,7 +6,6 @@ struct ds1wm_platform_data {
 			     * e.g. on h5xxx and h2200 this is 2
 			     * (registers aligned to 4-byte boundaries),
 			     * while on hx4700 this is 1 */
-	int falling_edge;   /* interrupt edge - passed to set_irq_type() */
 	int active_high;    /* interrupt polarity, passed to DS1WM as IAS bit */
 	void (*enable)(struct platform_device *pdev);
 	void (*disable)(struct platform_device *pdev);
_

Patches currently in -mm which might be from mreimer@vpop.net are

w1-allow-bus-master-to-have-reset-and-byte-ops.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-update.patch
