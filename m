From: akpm@linux-foundation.org
Subject: [merged] gpiolib-allow-poll-on-value.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:51 -0700
Message-ID: <200909231959.n8NJxqVZ011832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbZIWUAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:00:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dg@emlix.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: allow poll() on value
has been removed from the -mm tree.  Its filename was
     gpiolib-allow-poll-on-value.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpiolib: allow poll() on value
=46rom: Daniel Gl=F6ckner <dg@emlix.com>

Many gpio chips allow to generate interrupts when the value of a pin
changes.  This patch gives usermode application the opportunity to make
use of this feature by calling poll(2) on the /sys/class/gpio/gpioN/val=
ue
sysfs file.  The edge to trigger can be set in the edge file in the sam=
e
directory.  Possible values are "none", "rising", "falling", and "both"=
=2E

Using level triggers is not possible with current sysfs since nothing
changes the GPIO value (and the IRQ keeps triggering).  Edge triggering
will "just work".  Note that if there was an event between read() and
poll(), the poll() returns immediately.

Also note that this version only supports true GPIO interrupts.  Some
later patch might be able to synthesize this behavior by timer-driven
polling; some systems seem to need that.

[dbrownell@users.sourceforge.net: align ids to 16 bit ids; whitespace]
Signed-off-by: Daniel Gl=F6ckner <dg@emlix.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-gpio |    1=20
 Documentation/gpio.txt               |    7=20
 drivers/gpio/gpiolib.c               |  208 ++++++++++++++++++++++++-
 3 files changed, 211 insertions(+), 5 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-gpio~gpiolib-allow-poll-on-va=
lue Documentation/ABI/testing/sysfs-gpio
--- a/Documentation/ABI/testing/sysfs-gpio~gpiolib-allow-poll-on-value
+++ a/Documentation/ABI/testing/sysfs-gpio
@@ -19,6 +19,7 @@ Description:
 	/gpioN ... for each exported GPIO #N
 	    /value ... always readable, writes fail for input GPIOs
 	    /direction ... r/w as: in, out (default low); write: high, low
+	    /edge ... r/w as: none, falling, rising, both
 	/gpiochipN ... for each gpiochip; #N is its first GPIO
 	    /base ... (r/o) same as N
 	    /label ... (r/o) descriptive, not necessarily unique
diff -puN Documentation/gpio.txt~gpiolib-allow-poll-on-value Documentat=
ion/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-allow-poll-on-value
+++ a/Documentation/gpio.txt
@@ -524,6 +524,13 @@ and have the following read/write attrib
 		is configured as an output, this value may be written;
 		any nonzero value is treated as high.
=20
+	"edge" ... reads as either "none", "rising", "falling", or
+		"both". Write these strings to select the signal edge(s)
+		that will make poll(2) on the "value" file return.
+
+		This file exists only if the pin can be configured as an
+		interrupt generating input pin.
+
 GPIO controllers have paths like /sys/class/gpio/chipchip42/ (for the
 controller implementing GPIOs starting at #42) and have the following
 read-only attributes:
diff -puN drivers/gpio/gpiolib.c~gpiolib-allow-poll-on-value drivers/gp=
io/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-allow-poll-on-value
+++ a/drivers/gpio/gpiolib.c
@@ -1,5 +1,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
@@ -7,6 +8,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
+#include <linux/idr.h>
=20
=20
 /* Optional implementation infrastructure for GPIO interfaces.
@@ -49,6 +51,13 @@ struct gpio_desc {
 #define FLAG_RESERVED	2
 #define FLAG_EXPORT	3	/* protected by sysfs_lock */
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
+#define FLAG_TRIG_FALL	5	/* trigger on falling edge */
+#define FLAG_TRIG_RISE	6	/* trigger on rising edge */
+
+#define PDESC_ID_SHIFT	16	/* add new flags before this one */
+
+#define GPIO_FLAGS_MASK		((1 << PDESC_ID_SHIFT) - 1)
+#define GPIO_TRIGGER_MASK	(BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE))
=20
 #ifdef CONFIG_DEBUG_FS
 	const char		*label;
@@ -56,6 +65,15 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
=20
+#ifdef CONFIG_GPIO_SYSFS
+struct poll_desc {
+	struct work_struct	work;
+	struct sysfs_dirent	*value_sd;
+};
+
+static struct idr pdesc_idr;
+#endif
+
 static inline void desc_set_label(struct gpio_desc *d, const char *lab=
el)
 {
 #ifdef CONFIG_DEBUG_FS
@@ -188,10 +206,10 @@ static DEFINE_MUTEX(sysfs_lock);
  *   /value
  *      * always readable, subject to hardware behavior
  *      * may be writable, as zero/nonzero
- *
- * REVISIT there will likely be an attribute for configuring async
- * notifications, e.g. to specify polling interval or IRQ trigger type
- * that would for example trigger a poll() on the "value".
+ *   /edge
+ *      * configures behavior of poll(2) on /value
+ *      * available only if pin can generate IRQs on input
+ *      * is read/write as "none", "falling", "rising", or "both"
  */
=20
 static ssize_t gpio_direction_show(struct device *dev,
@@ -288,6 +306,175 @@ static ssize_t gpio_value_store(struct d
 static /*const*/ DEVICE_ATTR(value, 0644,
 		gpio_value_show, gpio_value_store);
=20
+static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
+{
+	struct work_struct	*work =3D priv;
+
+	schedule_work(work);
+	return IRQ_HANDLED;
+}
+
+static void gpio_notify_sysfs(struct work_struct *work)
+{
+	struct poll_desc	*pdesc;
+
+	pdesc =3D container_of(work, struct poll_desc, work);
+	sysfs_notify_dirent(pdesc->value_sd);
+}
+
+static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
+		unsigned long gpio_flags)
+{
+	struct poll_desc	*pdesc;
+	unsigned long		irq_flags;
+	int			ret, irq, id;
+
+	if ((desc->flags & GPIO_TRIGGER_MASK) =3D=3D gpio_flags)
+		return 0;
+
+	irq =3D gpio_to_irq(desc - gpio_desc);
+	if (irq < 0)
+		return -EIO;
+
+	id =3D desc->flags >> PDESC_ID_SHIFT;
+	pdesc =3D idr_find(&pdesc_idr, id);
+	if (pdesc) {
+		free_irq(irq, &pdesc->work);
+		cancel_work_sync(&pdesc->work);
+	}
+
+	desc->flags &=3D ~GPIO_TRIGGER_MASK;
+
+	if (!gpio_flags) {
+		ret =3D 0;
+		goto free_sd;
+	}
+
+	irq_flags =3D IRQF_SHARED;
+	if (test_bit(FLAG_TRIG_FALL, &gpio_flags))
+		irq_flags |=3D IRQF_TRIGGER_FALLING;
+	if (test_bit(FLAG_TRIG_RISE, &gpio_flags))
+		irq_flags |=3D IRQF_TRIGGER_RISING;
+
+	if (!pdesc) {
+		pdesc =3D kmalloc(sizeof(*pdesc), GFP_KERNEL);
+		if (!pdesc) {
+			ret =3D -ENOMEM;
+			goto err_out;
+		}
+
+		do {
+			ret =3D -ENOMEM;
+			if (idr_pre_get(&pdesc_idr, GFP_KERNEL))
+				ret =3D idr_get_new_above(&pdesc_idr,
+						pdesc, 1, &id);
+		} while (ret =3D=3D -EAGAIN);
+
+		if (ret)
+			goto free_mem;
+
+		desc->flags &=3D GPIO_FLAGS_MASK;
+		desc->flags |=3D (unsigned long)id << PDESC_ID_SHIFT;
+
+		if (desc->flags >> PDESC_ID_SHIFT !=3D id) {
+			ret =3D -ERANGE;
+			goto free_id;
+		}
+
+		pdesc->value_sd =3D sysfs_get_dirent(dev->kobj.sd, "value");
+		if (!pdesc->value_sd) {
+			ret =3D -ENODEV;
+			goto free_id;
+		}
+		INIT_WORK(&pdesc->work, gpio_notify_sysfs);
+	}
+
+	ret =3D request_irq(irq, gpio_sysfs_irq, irq_flags,
+			"gpiolib", &pdesc->work);
+	if (ret)
+		goto free_sd;
+
+	desc->flags |=3D gpio_flags;
+	return 0;
+
+free_sd:
+	sysfs_put(pdesc->value_sd);
+free_id:
+	idr_remove(&pdesc_idr, id);
+	desc->flags &=3D GPIO_FLAGS_MASK;
+free_mem:
+	kfree(pdesc);
+err_out:
+	return ret;
+}
+
+static const struct {
+	const char *name;
+	unsigned long flags;
+} trigger_types[] =3D {
+	{ "none",    0 },
+	{ "falling", BIT(FLAG_TRIG_FALL) },
+	{ "rising",  BIT(FLAG_TRIG_RISE) },
+	{ "both",    BIT(FLAG_TRIG_FALL) | BIT(FLAG_TRIG_RISE) },
+};
+
+static ssize_t gpio_edge_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	const struct gpio_desc	*desc =3D dev_get_drvdata(dev);
+	ssize_t			status;
+
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status =3D -EIO;
+	else {
+		int i;
+
+		status =3D 0;
+		for (i =3D 0; i < ARRAY_SIZE(trigger_types); i++)
+			if ((desc->flags & GPIO_TRIGGER_MASK)
+					=3D=3D trigger_types[i].flags) {
+				status =3D sprintf(buf, "%s\n",
+						 trigger_types[i].name);
+				break;
+			}
+	}
+
+	mutex_unlock(&sysfs_lock);
+	return status;
+}
+
+static ssize_t gpio_edge_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct gpio_desc	*desc =3D dev_get_drvdata(dev);
+	ssize_t			status;
+	int			i;
+
+	for (i =3D 0; i < ARRAY_SIZE(trigger_types); i++)
+		if (sysfs_streq(trigger_types[i].name, buf))
+			goto found;
+	return -EINVAL;
+
+found:
+	mutex_lock(&sysfs_lock);
+
+	if (!test_bit(FLAG_EXPORT, &desc->flags))
+		status =3D -EIO;
+	else {
+		status =3D gpio_setup_irq(desc, dev, trigger_types[i].flags);
+		if (!status)
+			status =3D size;
+	}
+
+	mutex_unlock(&sysfs_lock);
+
+	return status;
+}
+
+static DEVICE_ATTR(edge, 0644, gpio_edge_show, gpio_edge_store);
+
 static const struct attribute *gpio_attrs[] =3D {
 	&dev_attr_direction.attr,
 	&dev_attr_value.attr,
@@ -473,7 +660,7 @@ int gpio_export(unsigned gpio, bool dire
 		struct device	*dev;
=20
 		dev =3D device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-				    desc, ioname ? ioname : "gpio%d", gpio);
+				desc, ioname ? ioname : "gpio%d", gpio);
 		if (dev) {
 			if (direction_may_change)
 				status =3D sysfs_create_group(&dev->kobj,
@@ -481,6 +668,14 @@ int gpio_export(unsigned gpio, bool dire
 			else
 				status =3D device_create_file(dev,
 						&dev_attr_value);
+
+			if (!status && gpio_to_irq(gpio) >=3D 0
+					&& (direction_may_change
+						|| !test_bit(FLAG_IS_OUT,
+							&desc->flags)))
+				status =3D device_create_file(dev,
+						&dev_attr_edge);
+
 			if (status !=3D 0)
 				device_unregister(dev);
 		} else
@@ -572,6 +767,7 @@ void gpio_unexport(unsigned gpio)
=20
 		dev =3D class_find_device(&gpio_class, NULL, desc, match_export);
 		if (dev) {
+			gpio_setup_irq(desc, dev, 0);
 			clear_bit(FLAG_EXPORT, &desc->flags);
 			put_device(dev);
 			device_unregister(dev);
@@ -656,6 +852,8 @@ static int __init gpiolib_sysfs_init(voi
 	unsigned long	flags;
 	unsigned	gpio;
=20
+	idr_init(&pdesc_idr);
+
 	status =3D class_register(&gpio_class);
 	if (status < 0)
 		return status;
_

Patches currently in -mm which might be from dg@emlix.com are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
