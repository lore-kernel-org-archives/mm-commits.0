From: akpm@linux-foundation.org
Subject: - input-touchscreen-driver-add-support-ad7877-touchscreen-driver-try-5.patch removed from -mm tree
Date: Wed, 29 Oct 2008 14:18:43 -0700
Message-ID: <200810292118.m9TLIifE018727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbYJ2VTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 17:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, dmitry.torokhov@gmail.com, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     Input/Touchscreen Driver: add support AD7877 touchscreen driver (try #5)
has been removed from the -mm tree.  Its filename was
     input-touchscreen-driver-add-support-ad7877-touchscreen-driver-try-5.patch

This patch was dropped because it was folded into input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Input/Touchscreen Driver: add support AD7877 touchscreen driver (try #5)
From: Bryan Wu <cooloney@kernel.org>


[try #5]
 - Fix indention
 - Lock spi_async()
 - Remove useless header comments
 - Use strict_strtoul
 - Use EDGE triggered interrupts ?\226?\128?\147 this simplifies some of the IRQ handling.
 - Fix error cleanup path
 - Remove duplicated code
 - SPI access functions parameter use struct spi_device

[try #4] Changelog (based on LKML feedback by Dmitry Torokhov)
 - Fix req use after free.
 - Fix sysfs interaction (we migh re-eanble irgs upon a sysfs read).
 - Fix DAC bogus data read case

[try #3] Changlog (Add feedback from Dmitry Torokhov):
 - Change handling of spi_sync / spi_async return value handling
 - Remove depreciated dev->power.power_state
 - Fix error return path in ad7877_probe
 - delete pending kernel timer
 - Some minor cleanup (indention, use dev_err etc.)

[try #2] Changelog:
 - move locking inside ad7877_enable and ad7877_disable
 - use setup_timer
 - use input_dev->dev.parent
 - fix unregister device
 - kill EV_KEY since it's not used
 - fix indention style

Apply patch from Philip Douglass:
Make ad7877 ts driver not dependent on Blackfin specific cs_change_per_word_option

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/ad7877.c |  498 ++++++++++++---------------
 1 file changed, 235 insertions(+), 263 deletions(-)

diff -puN drivers/input/touchscreen/ad7877.c~input-touchscreen-driver-add-support-ad7877-touchscreen-driver-try-5 drivers/input/touchscreen/ad7877.c
--- a/drivers/input/touchscreen/ad7877.c~input-touchscreen-driver-add-support-ad7877-touchscreen-driver-try-5
+++ a/drivers/input/touchscreen/ad7877.c
@@ -5,14 +5,8 @@
  *
  *		Copyright (C) 2006-2008 Michael Hennerich, Analog Devices Inc.
  *
- * Author:	Michael Hennerich, Analog Devices Inc.
- *
- * Created:	Nov, 10th 2006
  * Description:	AD7877 based touchscreen, sensor (ADCs), DAC and GPIO driver
  *
- *
- * Modified:
- *
  * Bugs:        Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
@@ -57,8 +51,6 @@
 
 #define	TS_PEN_UP_TIMEOUT	msecs_to_jiffies(50)
 
-/*--------------------------------------------------------------------------*/
-
 #define MAX_SPI_FREQ_HZ			20000000
 #define	MAX_12BIT			((1<<12)-1)
 
@@ -156,21 +148,20 @@ enum {
 		AD7877_MODE_SCC | AD7877_CHANADD(AD7877_REG_ ## x) | \
 		AD7877_READADD(AD7877_REG_ ## x))
 
-
 #define AD7877_MM_SEQUENCE (AD7877_SEQ_YPLUS_BIT | AD7877_SEQ_XPLUS_BIT | \
 		AD7877_SEQ_Z2_BIT | AD7877_SEQ_Z1_BIT)
-/*--------------------------------------------------------------------------*/
 
 /*
  * Non-touchscreen sensors only use single-ended conversions.
  */
 
 struct ser_req {
+	u16			reset;
 	u16			ref_on;
 	u16			command;
 	u16			sample;
 	struct spi_message	msg;
-	struct spi_transfer	xfer[5];
+	struct spi_transfer	xfer[6];
 };
 
 struct ad7877 {
@@ -196,17 +187,13 @@ struct ad7877 {
 
 	u16 			conversion_data[AD7877_NR_SENSE];
 
-	struct spi_transfer	xfer[13];
+	struct spi_transfer	xfer[AD7877_NR_SENSE + 2];
 	struct spi_message	msg;
 
-	int intr_flag;
-
 	spinlock_t		lock;
 	struct timer_list	timer;		/* P: lock */
 	unsigned		pendown:1;	/* P: lock */
 	unsigned		pending:1;	/* P: lock */
-
-	unsigned		irq_disabled:1;	/* P: lock */
 	unsigned		disabled:1;
 	unsigned		gpio3:1;
 	unsigned		gpio4:1;
@@ -214,14 +201,15 @@ struct ad7877 {
 
 static int gpio3;
 
-static void ad7877_enable(struct ad7877 *ts);
-static void ad7877_disable(struct ad7877 *ts);
+/*
+ * ad7877_read/write are only used for initial setup and for sysfs controls.
+ * The main traffic is done using spi_async() in the interrupt handler.
+ */
 
-static int ad7877_read(struct device *dev, u16 reg)
+static int ad7877_read(struct spi_device *spi, u16 reg)
 {
-	struct spi_device	*spi = to_spi_device(dev);
 	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
-	int			status;
+	int			status, ret;
 
 	if (!req)
 		return -ENOMEM;
@@ -244,13 +232,14 @@ static int ad7877_read(struct device *de
 	if (status == 0)
 		status = req->msg.status;
 
+	ret = status ? status : req->sample;
 	kfree(req);
-	return status ? status : req->sample;
+
+	return ret;
 }
 
-static int ad7877_write(struct device *dev, u16 reg, u16 val)
+static int ad7877_write(struct spi_device *spi, u16 reg, u16 val)
 {
-	struct spi_device	*spi = to_spi_device(dev);
 	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
 	int			status;
 
@@ -275,10 +264,9 @@ static int ad7877_write(struct device *d
 	return status;
 }
 
-static int ad7877_read_adc(struct device *dev, unsigned command)
+static int ad7877_read_adc(struct spi_device *spi, unsigned command)
 {
-	struct spi_device	*spi = to_spi_device(dev);
-	struct ad7877		*ts = dev_get_drvdata(dev);
+	struct ad7877 		*ts = dev_get_drvdata(&spi->dev);
 	struct ser_req		*req = kzalloc(sizeof *req, GFP_KERNEL);
 	int			status;
 	int			sample;
@@ -295,36 +283,37 @@ static int ad7877_read_adc(struct device
 			 AD7877_AVG(0) | AD7877_PM(2) | AD7877_TMR(0) |
 			 AD7877_ACQ(ts->acquisition_time) | AD7877_FCD(0);
 
+	req->reset = AD7877_WRITEADD(AD7877_REG_CTRL1) | AD7877_MODE_NOC;
+
 	req->command = (u16) command;
 
-	req->xfer[0].tx_buf = &req->ref_on;
+	req->xfer[0].tx_buf = &req->reset;
 	req->xfer[0].len = 2;
-	req->xfer[0].delay_usecs = ts->vref_delay_usecs;
 
-	req->xfer[1].tx_buf = &req->command;
+	req->xfer[1].tx_buf = &req->ref_on;
 	req->xfer[1].len = 2;
 	req->xfer[1].delay_usecs = ts->vref_delay_usecs;
 
-	req->xfer[2].rx_buf = &req->sample;
+	req->xfer[2].tx_buf = &req->command;
 	req->xfer[2].len = 2;
+	req->xfer[2].delay_usecs = ts->vref_delay_usecs;
 
-	req->xfer[3].tx_buf = &ts->cmd_crtl2;	/*REF OFF*/
+	req->xfer[3].rx_buf = &req->sample;
 	req->xfer[3].len = 2;
 
-	req->xfer[4].tx_buf = &ts->cmd_crtl1;	/*DEFAULT*/
+	req->xfer[4].tx_buf = &ts->cmd_crtl2;	/*REF OFF*/
 	req->xfer[4].len = 2;
 
+	req->xfer[5].tx_buf = &ts->cmd_crtl1;	/*DEFAULT*/
+	req->xfer[5].len = 2;
+
 	/* group all the transfers together, so we can't interfere with
 	 * reading touchscreen state; disable penirq while sampling
 	 */
-	for (i = 0; i < 5; i++)
+	for (i = 0; i < 6; i++)
 		spi_message_add_tail(&req->xfer[i], &req->msg);
 
-	ts->irq_disabled = 1;
-	disable_irq(spi->irq);
 	status = spi_sync(spi, &req->msg);
-	ts->irq_disabled = 0;
-	enable_irq(spi->irq);
 
 	if (status == 0)
 		status = req->msg.status;
@@ -335,10 +324,139 @@ static int ad7877_read_adc(struct device
 	return status ? status : sample;
 }
 
+static void ad7877_rx(struct ad7877 *ts)
+{
+	struct input_dev	*input_dev = ts->input;
+	unsigned		Rt;
+	u16			x, y, z1, z2;
+
+	x = ts->conversion_data[AD7877_SEQ_XPOS] & MAX_12BIT;
+	y = ts->conversion_data[AD7877_SEQ_YPOS] & MAX_12BIT;
+	z1 = ts->conversion_data[AD7877_SEQ_Z1] & MAX_12BIT;
+	z2 = ts->conversion_data[AD7877_SEQ_Z2] & MAX_12BIT;
+
+	/*
+	 * The samples processed here are already preprocessed by the AD7877.
+	 * The preprocessing function consists of an averaging filter.
+	 * The combination of 'first conversion delay' and averaging provides a robust solution,
+	 * discarding the spurious noise in the signal and keeping only the data of interest.
+	 * The size of the averaging filter is programmable. (dev.platform_data, see linux/spi/ad7877.h)
+	 * Other user-programmable conversion controls include variable acquisition time,
+	 * and first conversion delay. Up to 16 averages can be taken per conversion.
+	 */
+
+	if (likely(x && z1)) {
+		/* compute touch pressure resistance using equation #1 */
+		Rt = (z2 - z1) * x * ts->x_plate_ohms;
+		Rt /= z1;
+		Rt = (Rt + 2047) >> 12;
+	} else
+		Rt = 0;
+
+	if (Rt) {
+		input_report_abs(input_dev, ABS_X, x);
+		input_report_abs(input_dev, ABS_Y, y);
+		input_report_abs(input_dev, ABS_PRESSURE, Rt);
+		input_sync(input_dev);
+	}
+}
+
+static inline void ad7877_ts_event_release(struct ad7877 *ts)
+{
+	struct input_dev *input_dev = ts->input;
+
+	input_report_abs(input_dev, ABS_PRESSURE, 0);
+	input_sync(input_dev);
+}
+
+static void ad7877_timer(unsigned long handle)
+{
+	struct ad7877	*ts = (void *)handle;
+
+	ad7877_ts_event_release(ts);
+}
+
+static irqreturn_t ad7877_irq(int irq, void *handle)
+{
+	struct ad7877 *ts = handle;
+	unsigned long flags;
+	int status;
+
+	/* The repeated conversion sequencer controlled by TMR kicked off too fast.
+	 * We ignore the last and process the sample sequence currently in the queue
+	 * It can't be older than 9.4ms, and we need to avoid that ts->msg
+	 * doesn't get issued twice while in work.
+	 */
+
+	if (ts->pending)
+		return IRQ_HANDLED;
+
+	spin_lock_irqsave(&ts->lock, flags);
+	ts->pending = 1;
+	spin_unlock_irqrestore(&ts->lock, flags);
+
+	status = spi_async(ts->spi, &ts->msg);
+
+	if (status)
+		dev_err(&ts->spi->dev, "spi_sync --> %d\n", status);
+
+	return IRQ_HANDLED;
+}
+
+static void ad7877_callback(void *_ts)
+{
+	struct ad7877 *ts = _ts;
+	unsigned long flags;
+
+	ad7877_rx(ts);
+
+	spin_lock_irqsave(&ts->lock, flags);
+	ts->pending = 0;
+	mod_timer(&ts->timer, jiffies + TS_PEN_UP_TIMEOUT);
+	spin_unlock_irqrestore(&ts->lock, flags);
+}
+
+static void ad7877_disable(struct ad7877 *ts)
+{
+	unsigned long flags;
+
+	if (ts->disabled)
+		return;
+
+	spin_lock_irqsave(&ts->lock, flags);
+	ts->disabled = 1;
+	disable_irq(ts->spi->irq);
+	spin_unlock_irqrestore(&ts->lock, flags);
+
+	while (ts->pending) /* Wait for spi_async callback */
+		msleep(1);
+
+	if (del_timer_sync(&ts->timer))
+		ad7877_ts_event_release(ts);
+
+	/* we know the chip's in lowpower mode since we always
+	 * leave it that way after every request
+	 */
+}
+
+static void ad7877_enable(struct ad7877 *ts)
+{
+	unsigned long flags;
+
+	if (!ts->disabled)
+		return;
+
+	spin_lock_irqsave(&ts->lock, flags);
+	ts->disabled = 0;
+	enable_irq(ts->spi->irq);
+	spin_unlock_irqrestore(&ts->lock, flags);
+}
+
 #define SHOW(name) static ssize_t \
 name ## _show(struct device *dev, struct device_attribute *attr, char *buf) \
 { \
-	ssize_t v = ad7877_read_adc(dev, \
+	struct ad7877	*ts = dev_get_drvdata(dev); \
+	ssize_t v = ad7877_read_adc(ts->spi, \
 			AD7877_READ_CHAN(name)); \
 	if (v < 0) \
 		return v; \
@@ -367,12 +485,15 @@ static ssize_t ad7877_disable_store(stru
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	char *endp;
-	int i;
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
 
-	i = simple_strtoul(buf, &endp, 10);
+	if (ret)
+		return ret;
 
-	if (i)
+	if (val)
 		ad7877_disable(ts);
 	else
 		ad7877_enable(ts);
@@ -395,14 +516,17 @@ static ssize_t ad7877_dac_store(struct d
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	char *endp;
-	int i;
+	unsigned long val;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &val);
 
-	i = simple_strtoul(buf, &endp, 10);
+	if (ret)
+		return ret;
 
-	ts->dac = i & 0xFF;
+	ts->dac = val & 0xFF;
 
-	ad7877_write(dev, AD7877_REG_DAC, (ts->dac << 4) | AD7877_DAC_CONF);
+	ad7877_write(ts->spi, AD7877_REG_DAC, (ts->dac << 4) | AD7877_DAC_CONF);
 
 	return count;
 }
@@ -422,14 +546,16 @@ static ssize_t ad7877_gpio3_store(struct
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	char *endp;
-	int i;
+	unsigned long val;
+	int ret;
 
-	i = simple_strtoul(buf, &endp, 10);
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		return ret;
 
-	ts->gpio3 = !!i;
+	ts->gpio3 = !!val;
 
-	ad7877_write(dev, AD7877_REG_EXTWRITE, AD7877_EXTW_GPIO_DATA |
+	ad7877_write(ts->spi, AD7877_REG_EXTWRITE, AD7877_EXTW_GPIO_DATA |
 		 (ts->gpio4 << 4) | (ts->gpio3 << 5));
 
 	return count;
@@ -450,14 +576,16 @@ static ssize_t ad7877_gpio4_store(struct
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	char *endp;
-	int i;
+	unsigned long val;
+	int ret;
 
-	i = simple_strtoul(buf, &endp, 10);
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret)
+		return ret;
 
-	ts->gpio4 = !!i;
+	ts->gpio4 = !!val;
 
-	ad7877_write(dev, AD7877_REG_EXTWRITE, AD7877_EXTW_GPIO_DATA |
+	ad7877_write(ts->spi, AD7877_REG_EXTWRITE, AD7877_EXTW_GPIO_DATA |
 		 (ts->gpio4 << 4) | (ts->gpio3 << 5));
 
 	return count;
@@ -482,180 +610,7 @@ static const struct attribute_group ad78
 	.attrs = ad7877_attributes,
 };
 
-/*--------------------------------------------------------------------------*/
-
-/*
- * /DAV Data available Interrupt only kicks the kthread.
- * The kthread kicks the timer only to issue the Pen Up Event if
- * no new data is available
- *
- */
-
-static void ad7877_rx(void *ads)
-{
-	struct ad7877		*ts = ads;
-	struct input_dev	*input_dev = ts->input;
-	unsigned		Rt;
-	u16			x, y, z1, z2;
-
-	x = ts->conversion_data[AD7877_SEQ_XPOS] & MAX_12BIT;
-	y = ts->conversion_data[AD7877_SEQ_YPOS]& MAX_12BIT;
-	z1 = ts->conversion_data[AD7877_SEQ_Z1] & MAX_12BIT;
-	z2 = ts->conversion_data[AD7877_SEQ_Z2] & MAX_12BIT;
-
-	/* range filtering */
-	if (x == MAX_12BIT)
-		x = 0;
-
-	if (likely(x && z1)) {
-		/* compute touch pressure resistance using equation #2 */
-		Rt = z2;
-		Rt -= z1;
-		Rt *= x;
-		Rt *= ts->x_plate_ohms;
-		Rt /= z1;
-		Rt = (Rt + 2047) >> 12;
-	} else
-		Rt = 0;
-
-	if (Rt) {
-		input_report_abs(input_dev, ABS_X, x);
-		input_report_abs(input_dev, ABS_Y, y);
-		input_report_abs(input_dev, ABS_PRESSURE, Rt);
-		input_sync(input_dev);
-#ifdef	VERBOSE
-		pr_debug("%s: %d/%d/%d%s\n", ts->spi->dev.bus_id,
-			x, y, Rt, Rt ? "" : " UP");
-#endif
-	}
-}
-
-static inline void ad7877_ts_event_release(struct ad7877 *ts)
-{
-	struct input_dev *input_dev = ts->input;
-
-	input_report_abs(input_dev, ABS_PRESSURE, 0);
-	input_sync(input_dev);
-}
-
-static void ad7877_timer(unsigned long handle)
-{
-	struct ad7877	*ts = (void *)handle;
-
-	ad7877_ts_event_release(ts);
-}
-
-
-static irqreturn_t ad7877_irq(int irq, void *handle)
-{
-	struct ad7877 *ts = handle;
-	unsigned long flags;
-	int status;
-
-	spin_lock_irqsave(&ts->lock, flags);
-
-	if (!ts->irq_disabled) {
-		ts->irq_disabled = 1;
-		disable_irq(ts->spi->irq);
-		ts->pending = 1;
-	}
-
-	ts->intr_flag = 1;
-
-	spin_unlock_irqrestore(&ts->lock, flags);
-
-	status = spi_async(ts->spi, &ts->msg);
-
-	if (status)
-		dev_err(&ts->spi->dev, "spi_sync --> %d\n", status);
-
-	return IRQ_HANDLED;
-}
-
-
-static void ad7877_callback(void *_ts)
-{
-	struct ad7877 *ts = _ts;
-	unsigned long flags;
-
-	if (ts->intr_flag) {
-
-		ad7877_rx(ts);
-
-		spin_lock_irqsave(&ts->lock, flags);
-
-		ts->intr_flag = 0;
-		ts->pending = 0;
-		ts->irq_disabled = 0;
-		enable_irq(ts->spi->irq);
-		mod_timer(&ts->timer, jiffies + TS_PEN_UP_TIMEOUT);
-
-		spin_unlock_irqrestore(&ts->lock, flags);
-	}
-}
-
-
-/*--------------------------------------------------------------------------*/
-
-static void ad7877_disable(struct ad7877 *ts)
-{
-	unsigned long flags;
-
-	if (ts->disabled)
-		return;
-
-	ts->disabled = 1;
-
-	spin_lock_irqsave(&ts->lock, flags);
-	ts->irq_disabled = 1;
-	disable_irq(ts->spi->irq);
-	spin_unlock_irqrestore(&ts->lock, flags);
-
-	while (ts->pending) /* Wait for spi_async callback */
-		msleep(1);
-
-	if (del_timer_sync(&ts->timer))
-		ad7877_ts_event_release(ts);
-
-	/* we know the chip's in lowpower mode since we always
-	 * leave it that way after every request
-	 */
-}
-
-/* Must be called with ts->lock held */
-static void ad7877_enable(struct ad7877 *ts)
-{
-	unsigned long flags;
-
-	if (!ts->disabled)
-		return;
-
-	spin_lock_irqsave(&ts->lock, flags);
-	ts->disabled = 0;
-	ts->irq_disabled = 0;
-	enable_irq(ts->spi->irq);
-	spin_unlock_irqrestore(&ts->lock, flags);
-}
-
-static int ad7877_suspend(struct spi_device *spi, pm_message_t message)
-{
-	struct ad7877 *ts = dev_get_drvdata(&spi->dev);
-
-	ad7877_disable(ts);
-
-	return 0;
-}
-
-static int ad7877_resume(struct spi_device *spi)
-{
-	struct ad7877 *ts = dev_get_drvdata(&spi->dev);
-
-	ad7877_enable(ts);
-
-	return 0;
-}
-
-static inline void ad7877_setup_ts_def_msg(struct spi_device *spi, struct ad7877 *ts)
+static void ad7877_setup_ts_def_msg(struct spi_device *spi, struct ad7877 *ts)
 {
 	struct spi_message *m;
 	int i;
@@ -667,13 +622,13 @@ static inline void ad7877_setup_ts_def_m
 			AD7877_ACQ(ts->acquisition_time) |
 			AD7877_FCD(ts->first_conversion_delay);
 
-	ad7877_write((struct device *) spi, AD7877_REG_CTRL2, ts->cmd_crtl2);
+	ad7877_write(spi, AD7877_REG_CTRL2, ts->cmd_crtl2);
 
 	ts->cmd_crtl1 = AD7877_WRITEADD(AD7877_REG_CTRL1) |
 			AD7877_READADD(AD7877_REG_XPLUS-1) |
 			AD7877_MODE_SEQ1 | AD7877_DFR;
 
-	ad7877_write((struct device *) spi, AD7877_REG_CTRL1, ts->cmd_crtl1);
+	ad7877_write(spi, AD7877_REG_CTRL1, ts->cmd_crtl1);
 
 	ts->cmd_dummy = 0;
 
@@ -697,8 +652,7 @@ static inline void ad7877_setup_ts_def_m
 	for (i = 0; i < 11; i++) {
 		ts->xfer[i + 2].rx_buf = &ts->conversion_data[AD7877_SEQ_YPOS + i];
 		ts->xfer[i + 2].len = 2;
-
-		spi_message_add_tail(&ts->xfer[i+2], m);
+		spi_message_add_tail(&ts->xfer[i + 2], m);
 	}
 }
 
@@ -727,20 +681,21 @@ static int __devinit ad7877_probe(struct
 	}
 
 	ts = kzalloc(sizeof(struct ad7877), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+
 	input_dev = input_allocate_device();
-	if (!ts || !input_dev) {
-		err = -ENOMEM;
-		goto err_free_mem;
+	if (!input_dev) {
+		kfree(ts);
+		return -ENOMEM;
 	}
 
 	dev_set_drvdata(&spi->dev, ts);
-
 	ts->spi = spi;
 	ts->input = input_dev;
-	ts->intr_flag = 0;
 
 	setup_timer(&ts->timer, ad7877_timer, (unsigned long) ts);
-
 	spin_lock_init(&ts->lock);
 
 	ts->model = pdata->model ? : 7877;
@@ -754,7 +709,7 @@ static int __devinit ad7877_probe(struct
 	ts->averaging = pdata->averaging;
 	ts->pen_down_acc_interval = pdata->pen_down_acc_interval;
 
-	snprintf(ts->phys, sizeof(ts->phys), "%s/input0", spi->dev.bus_id);
+	snprintf(ts->phys, sizeof(ts->phys), "%s/inputX", spi->dev.bus_id);
 
 	input_dev->name = "AD7877 Touchscreen";
 	input_dev->phys = ts->phys;
@@ -776,9 +731,9 @@ static int __devinit ad7877_probe(struct
 	input_set_abs_params(input_dev, ABS_PRESSURE,
 			pdata->pressure_min, pdata->pressure_max, 0, 0);
 
-	ad7877_write((struct device *) spi, AD7877_REG_SEQ1, AD7877_MM_SEQUENCE);
+	ad7877_write(spi, AD7877_REG_SEQ1, AD7877_MM_SEQUENCE);
 
-	verify = ad7877_read((struct device *) spi, AD7877_REG_SEQ1);
+	verify = ad7877_read(spi, AD7877_REG_SEQ1);
 
 	if (verify != AD7877_MM_SEQUENCE){
 		dev_err(&spi->dev, "%s: Failed to probe %s\n", spi->dev.bus_id,
@@ -788,53 +743,46 @@ static int __devinit ad7877_probe(struct
 	}
 
 	if (gpio3)
-		ad7877_write((struct device *) spi, AD7877_REG_EXTWRITE,
-			 AD7877_EXTW_GPIO_3_CONF);
+		ad7877_write(spi, AD7877_REG_EXTWRITE, AD7877_EXTW_GPIO_3_CONF);
 
 	ad7877_setup_ts_def_msg(spi, ts);
 
 	/* Request AD7877 /DAV GPIO interrupt */
 
-	if (request_irq(spi->irq, ad7877_irq, IRQF_TRIGGER_LOW | IRQF_SAMPLE_RANDOM,
-			spi->dev.driver->name, ts)) {
+	err = request_irq(spi->irq, ad7877_irq, IRQF_TRIGGER_FALLING |
+			IRQF_SAMPLE_RANDOM, spi->dev.driver->name, ts);
+	if (err) {
 		dev_dbg(&spi->dev, "irq %d busy?\n", spi->irq);
-		err = -EBUSY;
 		goto err_free_mem;
 	}
 
-	dev_info(&spi->dev, "touchscreen, irq %d\n", spi->irq);
-
 	err = sysfs_create_group(&spi->dev.kobj, &ad7877_attr_group);
-	if (err)
-		goto err_remove_attr;
 
 	if (gpio3)
-		err = device_create_file(&spi->dev, &dev_attr_gpio3);
+		err |= device_create_file(&spi->dev, &dev_attr_gpio3);
 	else
-		err = device_create_file(&spi->dev, &dev_attr_aux3);
+		err |= device_create_file(&spi->dev, &dev_attr_aux3);
 
 	if (err)
-		goto err_remove_attr;
+		goto err_free_irq;
 
 	err = input_register_device(input_dev);
 	if (err)
 		goto err_remove_attr;
 
-	ts->intr_flag = 0;
+	dev_info(&spi->dev, "touchscreen, irq %d\n", spi->irq);
 
 	return 0;
 
 err_remove_attr:
-
 	sysfs_remove_group(&spi->dev.kobj, &ad7877_attr_group);
 
 	if (gpio3)
 		device_remove_file(&spi->dev, &dev_attr_gpio3);
 	else
 		device_remove_file(&spi->dev, &dev_attr_aux3);
-
+err_free_irq:
 	free_irq(spi->irq, ts);
-
 err_free_mem:
 	input_free_device(input_dev);
 	kfree(ts);
@@ -846,7 +794,7 @@ static int __devexit ad7877_remove(struc
 {
 	struct ad7877		*ts = dev_get_drvdata(&spi->dev);
 
-	ad7877_suspend(spi, PMSG_SUSPEND);
+	ad7877_disable(ts);
 
 	sysfs_remove_group(&spi->dev.kobj, &ad7877_attr_group);
 
@@ -867,6 +815,29 @@ static int __devexit ad7877_remove(struc
 	return 0;
 }
 
+#ifdef CONFIG_PM
+static int ad7877_suspend(struct spi_device *spi, pm_message_t message)
+{
+	struct ad7877 *ts = dev_get_drvdata(&spi->dev);
+
+	ad7877_disable(ts);
+
+	return 0;
+}
+
+static int ad7877_resume(struct spi_device *spi)
+{
+	struct ad7877 *ts = dev_get_drvdata(&spi->dev);
+
+	ad7877_enable(ts);
+
+	return 0;
+}
+#else
+#define ad7877_suspend NULL
+#define ad7877_resume  NULL
+#endif
+
 static struct spi_driver ad7877_driver = {
 	.driver = {
 		.name	= "ad7877",
@@ -895,5 +866,6 @@ module_param(gpio3, int, 0);
 MODULE_PARM_DESC(gpio3,
 	"If gpio3 is set to 1 AUX3 acts as GPIO3");
 
-MODULE_DESCRIPTION("ad7877 TouchScreen Driver");
+MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
+MODULE_DESCRIPTION("AD7877 touchscreen Driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from cooloney@kernel.org are

origin.patch
cpu-freq-documentation-add-blackfin-to-list-of-supported-processors.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver-try-5.patch
input-ad7879-touchscreen-driver.patch
gpio_free-might-sleep-blackfin-architecture.patch

