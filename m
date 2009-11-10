From: akpm@linux-foundation.org
Subject: + gpiolib-add-support-for-changing-value-polarity-in-the-sysfs.patch added to -mm tree
Date: Tue, 10 Nov 2009 14:26:59 -0800
Message-ID: <200911102226.nAAMQx7P017825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044AbZKJW1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Nov 2009 17:27:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-jani.1.nikula@nokia.com, david-b@pacbell.net


The patch titled
     gpiolib: add support for changing value polarity in sysfs
has been added to the -mm tree.  Its filename is
     gpiolib-add-support-for-changing-value-polarity-in-the-sysfs.patch

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
Subject: gpiolib: add support for changing value polarity in sysfs
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Drivers may use gpiolib sysfs as part of their public user space
interface. The GPIO number and polarity might change from board to
board. The gpio_export_link() call can be used to hide the GPIO number
from user space. Add support for also hiding the GPIO line polarity
changes from user space.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/gpio.txt~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs
+++ a/Documentation/gpio.txt
@@ -531,6 +531,13 @@ and have the following read/write attrib
 		This file exists only if the pin can be configured as an
 		interrupt generating input pin.
 
+	"active_low" ... reads as either 0 (false) or 1 (true).  Write
+		any nonzero value to invert the value attribute both
+		for reading and writing.  Existing and subsequent
+		poll(2) support configuration via the edge attribute
+		for "rising" and "falling" edges will follow this
+		setting.
+
 GPIO controllers have paths like /sys/class/gpio/gpiochip42/ (for the
 controller implementing GPIOs starting at #42) and have the following
 read-only attributes:
@@ -566,6 +573,8 @@ requested using gpio_request():
 	int gpio_export_link(struct device *dev, const char *name,
 		unsigned gpio)
 
+	/* change the polarity of a GPIO node in sysfs */
+	int gpio_sysfs_set_active_low(unsigned gpio, int value);
 
 After a kernel driver requests a GPIO, it may only be made available in
 the sysfs interface by gpio_export().  The driver can control whether the
@@ -580,3 +589,9 @@ After the GPIO has been exported, gpio_e
 symlinks from elsewhere in sysfs to the GPIO sysfs node.  Drivers can
 use this to provide the interface under their own device in sysfs with
 a descriptive name.
+
+Drivers can use gpio_sysfs_set_active_low() to hide GPIO line polarity
+differences between boards from user space.  This only affects the
+sysfs interface.  Polarity change can be done both before and after
+gpio_export(), and previously enabled poll(2) support for either
+rising or falling edge will be reconfigured to follow this setting.
diff -puN drivers/gpio/gpiolib.c~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs
+++ a/drivers/gpio/gpiolib.c
@@ -53,6 +53,7 @@ struct gpio_desc {
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
 #define FLAG_TRIG_FALL	5	/* trigger on falling edge */
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
+#define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
 
 #define PDESC_ID_SHIFT	16	/* add new flags before this one */
 
@@ -210,6 +211,11 @@ static DEFINE_MUTEX(sysfs_lock);
  *      * configures behavior of poll(2) on /value
  *      * available only if pin can generate IRQs on input
  *      * is read/write as "none", "falling", "rising", or "both"
+ *   /active_low
+ *      * configures polarity of /value
+ *      * is read/write as zero/nonzero
+ *      * also affects existing and subsequent "falling" and "rising"
+ *        /edge configuration
  */
 
 static ssize_t gpio_direction_show(struct device *dev,
@@ -255,7 +261,7 @@ static ssize_t gpio_direction_store(stru
 	return status ? : size;
 }
 
-static const DEVICE_ATTR(direction, 0644,
+static /* const */ DEVICE_ATTR(direction, 0644,
 		gpio_direction_show, gpio_direction_store);
 
 static ssize_t gpio_value_show(struct device *dev,
@@ -267,10 +273,17 @@ static ssize_t gpio_value_show(struct de
 
 	mutex_lock(&sysfs_lock);
 
-	if (!test_bit(FLAG_EXPORT, &desc->flags))
+	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
 		status = -EIO;
-	else
-		status = sprintf(buf, "%d\n", !!gpio_get_value_cansleep(gpio));
+	} else {
+		int value;
+
+		value = !!gpio_get_value_cansleep(gpio);
+		if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
+			value = !value;
+
+		status = sprintf(buf, "%d\n", value);
+	}
 
 	mutex_unlock(&sysfs_lock);
 	return status;
@@ -294,6 +307,8 @@ static ssize_t gpio_value_store(struct d
 
 		status = strict_strtol(buf, 0, &value);
 		if (status == 0) {
+			if (test_bit(FLAG_ACTIVE_LOW, &desc->flags))
+				value = !value;
 			gpio_set_value_cansleep(gpio, value != 0);
 			status = size;
 		}
@@ -303,7 +318,7 @@ static ssize_t gpio_value_store(struct d
 	return status;
 }
 
-static /*const*/ DEVICE_ATTR(value, 0644,
+static const DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
 
 static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
@@ -352,9 +367,11 @@ static int gpio_setup_irq(struct gpio_de
 
 	irq_flags = IRQF_SHARED;
 	if (test_bit(FLAG_TRIG_FALL, &gpio_flags))
-		irq_flags |= IRQF_TRIGGER_FALLING;
+		irq_flags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
+			IRQF_TRIGGER_RISING : IRQF_TRIGGER_FALLING;
 	if (test_bit(FLAG_TRIG_RISE, &gpio_flags))
-		irq_flags |= IRQF_TRIGGER_RISING;
+		irq_flags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
+			IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
 
 	if (!pdesc) {
 		pdesc = kmalloc(sizeof(*pdesc), GFP_KERNEL);
@@ -475,9 +492,79 @@ found:
 
 static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
 
+static int sysfs_set_active_low(struct gpio_desc *desc, struct device *dev,
+				int value)
+{
+	int			status = 0;
+
+	if (!!test_bit(FLAG_ACTIVE_LOW, &desc->flags) == !!value)
+		return 0;
+
+	if (value)
+		set_bit(FLAG_ACTIVE_LOW, &desc->flags);
+	else
+		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
+
+	/* reconfigure poll(2) support if enabled on one edge only */
+	if (dev != NULL && (!!test_bit(FLAG_TRIG_RISE, &desc->flags) ^
+				!!test_bit(FLAG_TRIG_FALL, &desc->flags))) {
+		unsigned long trigger_flags = desc->flags & GPIO_TRIGGER_MASK;
+
+		gpio_setup_irq(desc, dev, 0);
+		status = gpio_setup_irq(desc, dev, trigger_flags);
+	}
+
+	return status;
+}
+
+static ssize_t gpio_active_low_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status = -EIO;
+	else
+		status = sprintf(buf, "%d\n",
+				!!test_bit(FLAG_ACTIVE_LOW, &desc->flags));
+
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+
+static ssize_t gpio_active_low_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc = dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags)) {
+		status = -EIO;
+	} else {
+		long		value;
+
+		status = strict_strtol(buf, 0, &value);
+		if (status == 0)
+			status = sysfs_set_active_low(desc, dev, value != 0);
+	}
+
+	mutex_unlock(&sysfs_lock);
+
+	return status ? : size;
+}
+
+static const DEVICE_ATTR(active_low, 0644,
+		gpio_active_low_show, gpio_active_low_store);
+
 static const struct attribute *gpio_attrs[] = {
-	&dev_attr_direction.attr,
 	&dev_attr_value.attr,
+	&dev_attr_active_low.attr,
 	NULL,
 };
 
@@ -662,12 +749,12 @@ int gpio_export(unsigned gpio, bool dire
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
 				desc, ioname ? ioname : "gpio%d", gpio);
 		if (!IS_ERR(dev)) {
-			if (direction_may_change)
-				status = sysfs_create_group(&dev->kobj,
+			status = sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
-			else
+
+			if (!status && direction_may_change)
 				status = device_create_file(dev,
-						&dev_attr_value);
+						&dev_attr_direction);
 
 			if (!status && gpio_to_irq(gpio) >= 0
 					&& (direction_may_change
@@ -744,6 +831,55 @@ done:
 }
 EXPORT_SYMBOL_GPL(gpio_export_link);
 
+
+/**
+ * gpio_sysfs_set_active_low - set the polarity of gpio sysfs value
+ * @gpio: gpio to change
+ * @value: non-zero to use active low, i.e. inverted values
+ *
+ * Set the polarity of /sys/class/gpio/gpioN/value sysfs attribute.
+ * The GPIO does not have to be exported yet.  If poll(2) support has
+ * been enabled for either rising or falling edge, it will be
+ * reconfigured to follow the new polarity.
+ *
+ * Returns zero on success, else an error.
+ */
+int gpio_sysfs_set_active_low(unsigned gpio, int value)
+{
+	struct gpio_desc	*desc;
+	struct device		*dev = NULL;
+	int			status = -EINVAL;
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+
+	mutex_lock(&sysfs_lock);
+
+	desc = &gpio_desc[gpio];
+
+	if (test_bit(FLAG_EXPORT, &desc->flags)) {
+		struct device *dev;
+
+		dev = class_find_device(&gpio_class, NULL, desc, match_export);
+		if (dev == NULL) {
+			status = -ENODEV;
+			goto unlock;
+		}
+	}
+
+	status = sysfs_set_active_low(desc, dev, value);
+
+unlock:
+	mutex_unlock(&sysfs_lock);
+
+done:
+	if (status)
+		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_sysfs_set_active_low);
+
 /**
  * gpio_unexport - reverse effect of gpio_export()
  * @gpio: gpio to make unavailable
@@ -1094,6 +1230,7 @@ void gpio_free(unsigned gpio)
 		}
 		desc_set_label(desc, NULL);
 		module_put(desc->chip->owner);
+		clear_bit(FLAG_ACTIVE_LOW, &desc->flags);
 		clear_bit(FLAG_REQUESTED, &desc->flags);
 	} else
 		WARN_ON(extra_checks);
diff -puN include/asm-generic/gpio.h~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs
+++ a/include/asm-generic/gpio.h
@@ -144,6 +144,7 @@ extern int __gpio_to_irq(unsigned gpio);
 extern int gpio_export(unsigned gpio, bool direction_may_change);
 extern int gpio_export_link(struct device *dev, const char *name,
 			unsigned gpio);
+extern int gpio_sysfs_set_active_low(unsigned gpio, int value);
 extern void gpio_unexport(unsigned gpio);
 
 #endif	/* CONFIG_GPIO_SYSFS */
@@ -194,6 +195,11 @@ static inline int gpio_export_link(struc
 	return -ENOSYS;
 }
 
+static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
+{
+	return -ENOSYS;
+}
+
 static inline void gpio_unexport(unsigned gpio)
 {
 }
diff -puN include/linux/gpio.h~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs include/linux/gpio.h
--- a/include/linux/gpio.h~gpiolib-add-support-for-changing-value-polarity-in-the-sysfs
+++ a/include/linux/gpio.h
@@ -99,6 +99,12 @@ static inline int gpio_export_link(struc
 	return -EINVAL;
 }
 
+static inline int gpio_sysfs_set_active_low(unsigned gpio, int value)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -EINVAL;
+}
 
 static inline void gpio_unexport(unsigned gpio)
 {
_

Patches currently in -mm which might be from ext-jani.1.nikula@nokia.com are

gpiolib-add-support-for-changing-value-polarity-in-the-sysfs.patch

