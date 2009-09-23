From: akpm@linux-foundation.org
Subject: [merged] gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:59:28 -0700
Message-ID: <200909231959.n8NJxSAR011054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630AbZIWT7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-jani.1.nikula@nokia.com, david-b@pacbell.net, dsilvers@simtec.co.uk, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     gpiolib: allow exported GPIO nodes to be named using sysfs links
has been removed from the -mm tree.  Its filename was
     gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: allow exported GPIO nodes to be named using sysfs links
From: Jani Nikula <ext-jani.1.nikula@nokia.com>

Commit 926b663ce8215ba448960e1ff6e58b67a2c3b99b (gpiolib: allow GPIOs to
be named) already provides naming on the chip level. This patch provides
more flexibility by allowing multiple names where ever in sysfs on a per
GPIO basis.

Adapted from David Brownell's comments on a similar concept:
http://lkml.org/lkml/2009/4/20/203.

[randy.dunlap@oracle.com: fix build for CONFIG_GENERIC_GPIO=n]
Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
Acked-by: David Brownell <david-b@pacbell.net>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/gpio.txt     |   10 +++++++
 drivers/gpio/gpiolib.c     |   45 +++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |    8 ++++++
 include/linux/gpio.h       |   11 ++++++++
 4 files changed, 74 insertions(+)

diff -puN Documentation/gpio.txt~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links Documentation/gpio.txt
--- a/Documentation/gpio.txt~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links
+++ a/Documentation/gpio.txt
@@ -555,6 +555,11 @@ requested using gpio_request():
 	/* reverse gpio_export() */
 	void gpio_unexport();
 
+	/* create a sysfs link to an exported GPIO node */
+	int gpio_export_link(struct device *dev, const char *name,
+		unsigned gpio)
+
+
 After a kernel driver requests a GPIO, it may only be made available in
 the sysfs interface by gpio_export().  The driver can control whether the
 signal direction may change.  This helps drivers prevent userspace code
@@ -563,3 +568,8 @@ from accidentally clobbering important s
 This explicit exporting can help with debugging (by making some kinds
 of experiments easier), or can provide an always-there interface that's
 suitable for documenting as part of a board support package.
+
+After the GPIO has been exported, gpio_export_link() allows creating
+symlinks from elsewhere in sysfs to the GPIO sysfs node.  Drivers can
+use this to provide the interface under their own device in sysfs with
+a descriptive name.
diff -puN drivers/gpio/gpiolib.c~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links
+++ a/drivers/gpio/gpiolib.c
@@ -505,6 +505,51 @@ static int match_export(struct device *d
 }
 
 /**
+ * gpio_export_link - create a sysfs link to an exported GPIO node
+ * @dev: device under which to create symlink
+ * @name: name of the symlink
+ * @gpio: gpio to create symlink to, already exported
+ *
+ * Set up a symlink from /sys/.../dev/name to /sys/class/gpio/gpioN
+ * node. Caller is responsible for unlinking.
+ *
+ * Returns zero on success, else an error.
+ */
+int gpio_export_link(struct device *dev, const char *name, unsigned gpio)
+{
+	struct gpio_desc	*desc;
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
+		struct device *tdev;
+
+		tdev = class_find_device(&gpio_class, NULL, desc, match_export);
+		if (tdev != NULL) {
+			status = sysfs_create_link(&dev->kobj, &tdev->kobj,
+						name);
+		} else {
+			status = -ENODEV;
+		}
+	}
+
+	mutex_unlock(&sysfs_lock);
+
+done:
+	if (status)
+		pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(gpio_export_link);
+
+/**
  * gpio_unexport - reverse effect of gpio_export()
  * @gpio: gpio to make unavailable
  *
diff -puN include/asm-generic/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links
+++ a/include/asm-generic/gpio.h
@@ -141,6 +141,8 @@ extern int __gpio_to_irq(unsigned gpio);
  * but more typically is configured entirely from userspace.
  */
 extern int gpio_export(unsigned gpio, bool direction_may_change);
+extern int gpio_export_link(struct device *dev, const char *name,
+			unsigned gpio);
 extern void gpio_unexport(unsigned gpio);
 
 #endif	/* CONFIG_GPIO_SYSFS */
@@ -185,6 +187,12 @@ static inline int gpio_export(unsigned g
 	return -ENOSYS;
 }
 
+static inline int gpio_export_link(struct device *dev, const char *name,
+				unsigned gpio)
+{
+	return -ENOSYS;
+}
+
 static inline void gpio_unexport(unsigned gpio)
 {
 }
diff -puN include/linux/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links include/linux/gpio.h
--- a/include/linux/gpio.h~gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links
+++ a/include/linux/gpio.h
@@ -12,6 +12,8 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 
+struct device;
+
 /*
  * Some platforms don't support the GPIO programming interface.
  *
@@ -89,6 +91,15 @@ static inline int gpio_export(unsigned g
 	return -EINVAL;
 }
 
+static inline int gpio_export_link(struct device *dev, const char *name,
+				unsigned gpio)
+{
+	/* GPIO can never have been exported */
+	WARN_ON(1);
+	return -EINVAL;
+}
+
+
 static inline void gpio_unexport(unsigned gpio)
 {
 	/* GPIO can never have been exported */
_

Patches currently in -mm which might be from ext-jani.1.nikula@nokia.com are

origin.patch

