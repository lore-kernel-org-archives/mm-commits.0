From: akpm@linux-foundation.org
Subject: + sht15-humidity-sensor-driver.patch added to -mm tree
Date: Tue, 31 Mar 2009 16:36:28 -0700
Message-ID: <200903312336.n2VNaSg8010622@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765371AbZCaXiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 19:38:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk


The patch titled
     hwmon: sht15 humidity sensor driver
has been added to the -mm tree.  Its filename is
     sht15-humidity-sensor-driver.patch

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
Subject: hwmon: sht15 humidity sensor driver
From: Jonathan Cameron <jic23@cam.ac.uk>

Data sheet at:
http://www.sensirion.ch/en/pdf/product_information/Datasheet-humidity-sensor-SHT1x.pdf

These sensors communicate over a 2 wire bus running a device specific
protocol.  The complexity of the driver is mainly due to handling the
substantial delays between requesting a reading and the device pulling the
data line low to indicate that the data is available.  This is handled by
an interrupt that is disabled under all other conditions.

I wasn't terribly clear on the best way to handle this, so comments on
that aspect would be particularly welcome!

Interpretation of the temperature depends on knowing the supply voltage. 
If configured in a board config as a regulator consumer this is obtained
from the regulator subsystem.  If not it should be provided in the
platform data.

I've placed this driver in the hwmon subsystem as it is definitely a
device that may be used for hardware monitoring and with it's relatively
slow response times (up to 120 millisecs to get a reading) a caching
strategy certainly seems to make sense!

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/Kconfig  |   10 
 drivers/hwmon/Makefile |    1 
 drivers/hwmon/sht15.c  |  692 +++++++++++++++++++++++++++++++++++++++
 include/linux/sht15.h  |   24 +
 4 files changed, 727 insertions(+)

diff -puN drivers/hwmon/Kconfig~sht15-humidity-sensor-driver drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~sht15-humidity-sensor-driver
+++ a/drivers/hwmon/Kconfig
@@ -670,6 +670,16 @@ config SENSORS_PCF8591
 	  These devices are hard to detect and rarely found on mainstream
 	  hardware.  If unsure, say N.
 
+config SENSORS_SHT15
+	tristate "Sensiron humidity and temperature sensors. SHT15 and compat."
+	depends on GENERIC_GPIO
+	help
+	  If you say yes here you get support for the Sensiron SHT10, SHT11,
+	  SHT15, SHT71, SHT75 humidity and temperature sensors.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called sht15.
+
 config SENSORS_SIS5595
 	tristate "Silicon Integrated Systems Corp. SiS5595"
 	depends on PCI
diff -puN drivers/hwmon/Makefile~sht15-humidity-sensor-driver drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~sht15-humidity-sensor-driver
+++ a/drivers/hwmon/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_SENSORS_MAX6650)	+= max6650
 obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
 obj-$(CONFIG_SENSORS_PC87427)	+= pc87427.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
+obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
 obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
 obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
 obj-$(CONFIG_SENSORS_SMSC47M1)	+= smsc47m1.o
diff -puN /dev/null drivers/hwmon/sht15.c
--- /dev/null
+++ a/drivers/hwmon/sht15.c
@@ -0,0 +1,692 @@
+/*
+ * sht15.c - support for the SHT15 Temperature and Humidity Sensor
+ *
+ * Copyright (c) 2009 Jonathan Cameron
+ *
+ * Copyright (c) 2007 Wouter Horre
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Currently ignoring checksum on readings.
+ * Default resolution only (14bit temp, 12bit humidity)
+ * Ignoring battery status.
+ * Heater not enabled.
+ * Timings are all conservative.
+ *
+ * Data sheet available (1/2009) at
+ * http://www.sensirion.ch/en/pdf/product_information/Datasheet-humidity-sensor-SHT1x.pdf
+ *
+ * Regulator supply name = vcc
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/err.h>
+#include <linux/sht15.h>
+#include <linux/regulator/consumer.h>
+#include <asm/atomic.h>
+
+#define SHT15_MEASURE_TEMP	3
+#define SHT15_MEASURE_RH	5
+
+#define SHT15_READING_NOTHING	0
+#define SHT15_READING_TEMP	1
+#define SHT15_READING_HUMID	2
+
+/* Min timings in nsecs */
+#define SHT15_TSCKL		100	/* clock low */
+#define SHT15_TSCKH		100	/* clock high */
+#define SHT15_TSU		150	/* data setup time */
+
+/**
+ * struct sht15_temppair - elements of voltage dependant temp calc
+ * @vdd:	supply voltage in microvolts
+ * @d1:		see data sheet
+ */
+struct sht15_temppair {
+	int vdd; /* microvolts */
+	int d1;
+};
+
+/* Table 9 from data sheet - relates temperature calculation
+ * to supply voltage.
+ */
+static const struct sht15_temppair temppoints[] = {
+	{ 2500000, -39400 },
+	{ 3000000, -39600 },
+	{ 3500000, -39700 },
+	{ 4000000, -39800 },
+	{ 5000000, -40100 },
+};
+
+/**
+ * struct sht15_data - device instance specific data
+ * @pdata:	platform data (gpio's etc)
+ * @read_work:	bh of interrupt handler
+ * @wait_queue:	wait queue for getting values from device
+ * @val_temp:	last temperature value read from device
+ * @val_humid: 	last humidity value read from device
+ * @flag:	status flag used to identify what the last request was
+ * @valid:	are the current stored values valid (start condition)
+ * @last_updat:	time of last update
+ * @read_lock:	mutex to ensure only one read in progress
+ *		at a time.
+ * @dev:	associate device structure
+ * @hwmon_dev:	device associated with hwmon subsystem
+ * @reg:	associated regulator (if specified)
+ * @nb:		notifier block to handle notifications of voltage changes
+ * @supply_uV:	local copy of supply voltage used to allow
+ *		use of regulator consumer if available
+ * @supply_uV_valid:   indicates that an updated value has not yet
+ *		been obtained from the regulator and so any calculations
+ *		based upon it will be invalid.
+ * @update_supply_work:	work struct that is used to update the supply_uV
+ * @interrupt_handled:	flag used to indicate a hander has been scheduled
+ */
+struct sht15_data {
+	struct sht15_platform_data	*pdata;
+	struct work_struct		read_work;
+	wait_queue_head_t		wait_queue;
+	uint16_t			val_temp;
+	uint16_t			val_humid;
+	u8				flag;
+	u8				valid;
+	unsigned long			last_updat;
+	struct mutex			read_lock;
+	struct device			*dev;
+	struct device			*hwmon_dev;
+	struct regulator		*reg;
+	struct notifier_block		nb;
+	int				supply_uV;
+	int				supply_uV_valid;
+	struct work_struct		update_supply_work;
+	atomic_t			interrupt_handled;
+};
+
+/**
+ * sht15_connection_reset() - reset the comms interface
+ * @data:	sht15 specific data
+ *
+ * This implements section 3.4 of the data sheet
+ */
+static void sht15_connection_reset(struct sht15_data *data)
+{
+	int i;
+	gpio_direction_output(data->pdata->gpio_data, 1);
+	ndelay(SHT15_TSCKL);
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSCKL);
+	for (i = 0; i < 9; ++i) {
+		gpio_set_value(data->pdata->gpio_sck, 1);
+		ndelay(SHT15_TSCKH);
+		gpio_set_value(data->pdata->gpio_sck, 0);
+		ndelay(SHT15_TSCKL);
+	}
+}
+/**
+ * sht15_send_bit() - send an individual bit to the device
+ * @data:	device state data
+ * @val:	value of bit to be sent
+ **/
+static inline void sht15_send_bit(struct sht15_data *data, int val)
+{
+
+	gpio_set_value(data->pdata->gpio_data, val);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_sck, 1);
+	ndelay(SHT15_TSCKH);
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSCKL); /* clock low time */
+}
+
+/**
+ * sht15_transmission_start() - specific sequence for new transmission
+ *
+ * @data:	device state data
+ * Timings for this are not documented on the data sheet, so very
+ * conservative ones used in implementation. This implements
+ * figure 12 on the data sheet.
+ **/
+static void sht15_transmission_start(struct sht15_data *data)
+{
+	/* ensure data is high and output */
+	gpio_direction_output(data->pdata->gpio_data, 1);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSCKL);
+	gpio_set_value(data->pdata->gpio_sck, 1);
+	ndelay(SHT15_TSCKH);
+	gpio_set_value(data->pdata->gpio_data, 0);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSCKL);
+	gpio_set_value(data->pdata->gpio_sck, 1);
+	ndelay(SHT15_TSCKH);
+	gpio_set_value(data->pdata->gpio_data, 1);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSCKL);
+}
+/**
+ * sht15_send_byte() - send a single byte to the device
+ * @data:	device state
+ * @byte:	value to be sent
+ **/
+static void sht15_send_byte(struct sht15_data *data, u8 byte)
+{
+	int i;
+	for (i = 0; i < 8; i++) {
+		sht15_send_bit(data, !!(byte & 0x80));
+		byte <<= 1;
+	}
+}
+/**
+ * sht15_wait_for_response() - checks for ack from device
+ * @data:	device state
+ **/
+static int sht15_wait_for_response(struct sht15_data *data)
+{
+	gpio_direction_input(data->pdata->gpio_data);
+	gpio_set_value(data->pdata->gpio_sck, 1);
+	ndelay(SHT15_TSCKH);
+	if (gpio_get_value(data->pdata->gpio_data)) {
+		gpio_set_value(data->pdata->gpio_sck, 0);
+		dev_err(data->dev, "Command not acknowledged\n");
+		sht15_connection_reset(data);
+		return -EIO;
+	}
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSCKL);
+	return 0;
+}
+
+/**
+ * sht15_send_cmd() - Sends a command to the device.
+ * @data:	device state
+ * @cmd:	command byte to be sent
+ *
+ * On entry, sck is output low, data is output pull high
+ * and the interrupt disabled.
+ **/
+static int sht15_send_cmd(struct sht15_data *data, u8 cmd)
+{
+	int ret = 0;
+	sht15_transmission_start(data);
+	sht15_send_byte(data, cmd);
+	ret = sht15_wait_for_response(data);
+	return ret;
+}
+/**
+ * sht15_update_single_val() - get a new value from device
+ * @data:		device instance specific data
+ * @command:		command sent to request value
+ * @timeout_msecs:	timeout after which comms are assumed
+ *			to have failed are reset.
+ **/
+static inline int sht15_update_single_val(struct sht15_data *data,
+					  int command,
+					  int timeout_msecs)
+{
+	int ret;
+	ret = sht15_send_cmd(data, command);
+	if (ret)
+		return ret;
+
+	gpio_direction_input(data->pdata->gpio_data);
+	atomic_set(&data->interrupt_handled, 0);
+
+	enable_irq(gpio_to_irq(data->pdata->gpio_data));
+	if (gpio_get_value(data->pdata->gpio_data) == 0) {
+		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
+		/* Only relevant if the interrupt hasn't occured. */
+		if (!atomic_read(&data->interrupt_handled))
+			schedule_work(&data->read_work);
+	}
+	ret = wait_event_timeout(data->wait_queue,
+				 (data->flag == SHT15_READING_NOTHING),
+				 msecs_to_jiffies(timeout_msecs));
+	if (ret == 0) {/* timeout occurred */
+		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));;
+		sht15_connection_reset(data);
+		return -ETIME;
+	}
+	return 0;
+}
+
+/**
+ * sht15_update_vals() - get updated readings from device if too old
+ * @data:	device state
+ **/
+static int sht15_update_vals(struct sht15_data *data)
+{
+	int ret = 0;
+	int timeout = HZ;
+
+	mutex_lock(&data->read_lock);
+	if (time_after(jiffies, data->last_updat + timeout)
+	    || !data->valid) {
+		data->flag = SHT15_READING_HUMID;
+		ret = sht15_update_single_val(data, SHT15_MEASURE_RH, 160);
+		if (ret)
+			goto error_ret;
+		data->flag = SHT15_READING_TEMP;
+		ret = sht15_update_single_val(data, SHT15_MEASURE_TEMP, 400);
+		if (ret)
+			goto error_ret;
+		data->valid = 1;
+		data->last_updat = jiffies;
+	}
+error_ret:
+	mutex_unlock(&data->read_lock);
+
+	return ret;
+}
+
+/**
+ * sht15_calc_temp() - convert the raw reading to a temperature
+ * @data:	device state
+ *
+ * As per section 4.3 of the data sheet.
+ **/
+static inline int sht15_calc_temp(struct sht15_data *data)
+{
+	int d1 = 0;
+	int i;
+
+	for (i = 1; i < ARRAY_SIZE(temppoints) - 1; i++)
+		/* Find pointer to interpolate */
+		if (data->supply_uV > temppoints[i - 1].vdd) {
+			d1 = (data->supply_uV/1000 - temppoints[i - 1].vdd)
+				* (temppoints[i].d1 - temppoints[i - 1].d1)
+				/ (temppoints[i].vdd - temppoints[i - 1].vdd)
+				+ temppoints[i - 1].d1;
+			break;
+		}
+
+	return data->val_temp*10 + d1;
+}
+
+/**
+ * sht15_calc_humid() - using last temperature convert raw to humid
+ * @data:	device state
+ *
+ * This is the temperature compensated version as per section 4.2 of
+ * the data sheet.
+ **/
+static inline int sht15_calc_humid(struct sht15_data *data)
+{
+	int RHlinear; /* milli percent */
+	int temp = sht15_calc_temp(data);
+
+	const int c1 = -4;
+	const int c2 = 40500; /* x 10 ^ -6 */
+	const int c3 = 2800; /* x10 ^ -9 */
+
+	RHlinear = c1*1000
+		+ c2 * data->val_humid/1000
+		+ (data->val_humid * data->val_humid * c3)/1000000;
+	return (temp - 25000) * (10000 + 800 * data->val_humid)
+		/ 1000000 + RHlinear;
+}
+
+static ssize_t sht15_show_temp(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	int ret;
+	struct sht15_data *data = dev_get_drvdata(dev);
+
+	/* Technically no need to read humidity as well */
+	ret = sht15_update_vals(data);
+
+	return ret ? ret : sprintf(buf, "%d\n",
+				   sht15_calc_temp(data));
+}
+
+static ssize_t sht15_show_humidity(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	int ret;
+	struct sht15_data *data = dev_get_drvdata(dev);
+
+	ret = sht15_update_vals(data);
+
+	return ret ? ret : sprintf(buf, "%d\n", sht15_calc_humid(data));
+
+};
+static ssize_t show_name(struct device *dev,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	return sprintf(buf, "%s\n", pdev->name);
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input,
+			  S_IRUGO, sht15_show_temp,
+			  NULL, 0);
+static SENSOR_DEVICE_ATTR(humidity1_input,
+			  S_IRUGO, sht15_show_humidity,
+			  NULL, 0);
+static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
+static struct attribute *sht15_attrs[] = {
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_humidity1_input.dev_attr.attr,
+	&dev_attr_name.attr,
+	NULL,
+};
+
+static const struct attribute_group sht15_attr_group = {
+	.attrs = sht15_attrs,
+};
+
+static irqreturn_t sht15_interrupt_fired(int irq, void *d)
+{
+	struct sht15_data *data = d;
+	/* First disable the interrupt */
+	disable_irq_nosync(irq);
+	atomic_inc(&data->interrupt_handled);
+	/* Then schedule a reading work struct */
+	if (data->flag != SHT15_READING_NOTHING)
+		schedule_work(&data->read_work);
+	return IRQ_HANDLED;
+}
+
+/* Each byte of data is acknowledged by pulling the data line
+ * low for one clock pulse.
+ */
+static void sht15_ack(struct sht15_data *data)
+{
+	gpio_direction_output(data->pdata->gpio_data, 0);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_sck, 1);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_data, 1);
+
+	gpio_direction_input(data->pdata->gpio_data);
+}
+/**
+ * sht15_end_transmission() - notify device of end of transmission
+ * @data:	device state
+ *
+ * This is basically a NAK. (single clock pulse, data high)
+ **/
+static void sht15_end_transmission(struct sht15_data *data)
+{
+	gpio_direction_output(data->pdata->gpio_data, 1);
+	ndelay(SHT15_TSU);
+	gpio_set_value(data->pdata->gpio_sck, 1);
+	ndelay(SHT15_TSCKH);
+	gpio_set_value(data->pdata->gpio_sck, 0);
+	ndelay(SHT15_TSCKL);
+}
+
+static void sht15_bh_read_data(struct work_struct *work_s)
+{
+	int i;
+	uint16_t val = 0;
+	struct sht15_data *data
+		= container_of(work_s, struct sht15_data,
+			       read_work);
+	/* Firstly, verify the line is low */
+	if (gpio_get_value(data->pdata->gpio_data)) {
+		/* If not, then start the interrupt again - care
+		   here as could have gone low in meantime so verify
+		   it hasn't!
+		*/
+		atomic_set(&data->interrupt_handled, 0);
+		enable_irq(gpio_to_irq(data->pdata->gpio_data));
+		/* If still not occured or another handler has been scheduled */
+		if (gpio_get_value(data->pdata->gpio_data)
+		    || atomic_read(&data->interrupt_handled))
+			return;
+	}
+	/* Read the data back from the device */
+	for (i = 0; i < 16; ++i) {
+		val <<= 1;
+		gpio_set_value(data->pdata->gpio_sck, 1);
+		ndelay(SHT15_TSCKH);
+		val |= !!gpio_get_value(data->pdata->gpio_data);
+		gpio_set_value(data->pdata->gpio_sck, 0);
+		ndelay(SHT15_TSCKL);
+		if (i == 7)
+			sht15_ack(data);
+	}
+	/* Tell the device we are done */
+	sht15_end_transmission(data);
+
+	switch (data->flag) {
+	case SHT15_READING_TEMP:
+		data->val_temp = val;
+		break;
+	case SHT15_READING_HUMID:
+		data->val_humid = val;
+		break;
+	}
+
+	data->flag = SHT15_READING_NOTHING;
+	wake_up(&data->wait_queue);
+}
+
+static void sht15_update_voltage(struct work_struct *work_s)
+{
+	struct sht15_data *data
+		= container_of(work_s, struct sht15_data,
+			       update_supply_work);
+	data->supply_uV = regulator_get_voltage(data->reg);
+}
+
+/**
+ * sht15_invalidate_voltage() - mark supply voltage invalid when notified by reg
+ * @nb:		associated notification structure
+ * @event:	voltage regulator state change event code
+ * @ignored:	function parameter - ignored here
+ *
+ * Note that as the notification code holds the regulator lock, we have
+ * to schedule an update of the supply voltage rather than getting it directly.
+ **/
+static int sht15_invalidate_voltage(struct notifier_block *nb,
+				unsigned long event,
+				void *ignored)
+{
+	struct sht15_data *data = container_of(nb, struct sht15_data, nb);
+
+	if (event == REGULATOR_EVENT_VOLTAGE_CHANGE)
+		data->supply_uV_valid = false;
+	schedule_work(&data->update_supply_work);
+
+	return NOTIFY_OK;
+}
+
+static int __devinit sht15_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct sht15_data *data = kzalloc(sizeof(*data), GFP_KERNEL);
+
+	if (!data) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "kzalloc failed");
+		goto error_ret;
+	}
+
+	INIT_WORK(&data->read_work, sht15_bh_read_data);
+	INIT_WORK(&data->update_supply_work, sht15_update_voltage);
+	platform_set_drvdata(pdev, data);
+	mutex_init(&data->read_lock);
+	data->dev = &pdev->dev;
+	init_waitqueue_head(&data->wait_queue);
+
+	if (pdev->dev.platform_data == NULL) {
+		dev_err(&pdev->dev, "no platform data supplied");
+		goto err_free_data;
+	}
+	data->pdata = pdev->dev.platform_data;
+	data->supply_uV = data->pdata->supply_mv*1000;
+
+/* If a regulator is available, query what the supply voltage actually is!*/
+	data->reg = regulator_get(data->dev, "vcc");
+	if (!IS_ERR(data->reg)) {
+		data->supply_uV = regulator_get_voltage(data->reg);
+		regulator_enable(data->reg);
+		/* setup a notifier block to update this if another device
+		 *  causes the voltage to change */
+		data->nb.notifier_call = &sht15_invalidate_voltage;
+		ret = regulator_register_notifier(data->reg, &data->nb);
+	}
+/* Try requesting the GPIOs */
+	ret = gpio_request(data->pdata->gpio_sck, "SHT15 sck");
+	if (ret) {
+		dev_err(&pdev->dev, "gpio request failed");
+		goto err_free_data;
+	}
+	gpio_direction_output(data->pdata->gpio_sck, 0);
+	ret = gpio_request(data->pdata->gpio_data, "SHT15 data");
+	if (ret) {
+		dev_err(&pdev->dev, "gpio request failed");
+		goto err_release_gpio_sck;
+	}
+	ret = sysfs_create_group(&pdev->dev.kobj, &sht15_attr_group);
+	if (ret) {
+		dev_err(&pdev->dev, "sysfs create failed");
+		goto err_free_data;
+	}
+
+	ret = request_irq(gpio_to_irq(data->pdata->gpio_data),
+			  sht15_interrupt_fired,
+			  IRQF_TRIGGER_FALLING,
+			  "sht15 data",
+			  data);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to get irq for data line");
+		goto err_release_gpio_data;
+	}
+	disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
+	sht15_connection_reset(data);
+	sht15_send_cmd(data, 0x1E);
+
+	data->hwmon_dev = hwmon_device_register(data->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		ret = PTR_ERR(data->hwmon_dev);
+		goto err_release_gpio_data;
+	}
+	return 0;
+
+err_release_gpio_data:
+	gpio_free(data->pdata->gpio_data);
+err_release_gpio_sck:
+	gpio_free(data->pdata->gpio_sck);
+err_free_data:
+	kfree(data);
+error_ret:
+
+	return ret;
+}
+
+static int __devexit sht15_remove(struct platform_device *pdev)
+{
+	struct sht15_data *data = platform_get_drvdata(pdev);
+
+	/* Make sure any reads from the device are done and
+	 * prevent new ones beginnning */
+	mutex_lock(&data->read_lock);
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &sht15_attr_group);
+	if (!IS_ERR(data->reg)) {
+		regulator_unregister_notifier(data->reg, &data->nb);
+		regulator_disable(data->reg);
+		regulator_put(data->reg);
+	}
+
+	free_irq(gpio_to_irq(data->pdata->gpio_data), data);
+	gpio_free(data->pdata->gpio_data);
+	gpio_free(data->pdata->gpio_sck);
+	mutex_unlock(&data->read_lock);
+	kfree(data);
+	return 0;
+}
+
+
+static struct platform_driver sht_drivers[] = {
+	{
+		.driver = {
+			.name = "sht10",
+			.owner = THIS_MODULE,
+		},
+		.probe = sht15_probe,
+		.remove = sht15_remove,
+	}, {
+		.driver = {
+			.name = "sht11",
+			.owner = THIS_MODULE,
+		},
+		.probe = sht15_probe,
+		.remove = sht15_remove,
+	}, {
+		.driver = {
+			.name = "sht15",
+			.owner = THIS_MODULE,
+		},
+		.probe = sht15_probe,
+		.remove = sht15_remove,
+	}, {
+		.driver = {
+			.name = "sht71",
+			.owner = THIS_MODULE,
+		},
+		.probe = sht15_probe,
+		.remove = sht15_remove,
+	}, {
+		.driver = {
+			.name = "sht75",
+			.owner = THIS_MODULE,
+		},
+		.probe = sht15_probe,
+		.remove = sht15_remove,
+	},
+};
+
+
+static int __init sht15_init(void)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sht_drivers); i++) {
+		ret = platform_driver_register(&sht_drivers[i]);
+		if (ret)
+			goto error_unreg;
+	}
+
+	return 0;
+
+error_unreg:
+	while (--i >= 0)
+		platform_driver_unregister(&sht_drivers[i]);
+
+	return ret;
+}
+module_init(sht15_init);
+
+static void __exit sht15_exit(void)
+{
+	int i;
+	for (i = ARRAY_SIZE(sht_drivers) - 1; i >= 0; i--)
+		platform_driver_unregister(&sht_drivers[i]);
+}
+module_exit(sht15_exit);
+
+MODULE_LICENSE("GPL");
diff -puN /dev/null include/linux/sht15.h
--- /dev/null
+++ a/include/linux/sht15.h
@@ -0,0 +1,24 @@
+/*
+ * sht15.h - support for the SHT15 Temperature and Humidity Sensor
+ *
+ * Copyright (c) 2009 Jonathan Cameron
+ *
+ * Copyright (c) 2007 Wouter Horre
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/**
+ * struct sht15_platform_data - sht15 connectivity info
+ * @gpio_data:	no. of gpio to which bidirectional data line is connected
+ * @gpio_sck:	no. of gpio to which the data clock is connected.
+ * @supply_mv:	supply voltage in mv. Overridden by regulator if available.
+ **/
+struct sht15_platform_data {
+	int gpio_data;
+	int gpio_sck;
+	int supply_mv;
+};
+
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

drivers-misc-isl29003c-driver-for-the-isl29003-ambient-light-sensor.patch
linux-next.patch
sht15-humidity-sensor-driver.patch

