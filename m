From: akpm@linux-foundation.org
Subject: + i2c-use-class_for_each_device.patch added to -mm tree
Date: Mon, 12 May 2008 14:53:49 -0700
Message-ID: <200805122153.m4CLrnT6011070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107AbYELVyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 17:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com


The patch titled
     i2c: use class_for_each_device
has been added to the -mm tree.  Its filename is
     i2c-use-class_for_each_device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i2c: use class_for_each_device
From: Dave Young <hidave.darkstar@gmail.com>

Use class_for_each_device for iteration.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/i2c-core.c |   96 +++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 44 deletions(-)

diff -puN drivers/i2c/i2c-core.c~i2c-use-class_for_each_device drivers/i2c/i2c-core.c
--- a/drivers/i2c/i2c-core.c~i2c-use-class_for_each_device
+++ a/drivers/i2c/i2c-core.c
@@ -35,7 +35,6 @@
 #include <linux/completion.h>
 #include <linux/hardirq.h>
 #include <linux/irqflags.h>
-#include <linux/semaphore.h>
 #include <asm/uaccess.h>
 
 #include "i2c-core.h"
@@ -657,6 +656,16 @@ EXPORT_SYMBOL(i2c_del_adapter);
 
 
 /* ------------------------------------------------------------------------- */
+static int __attach_adapter(struct device *dev, void *data)
+{
+	struct i2c_adapter *adapter;
+	struct i2c_driver *driver = data;
+
+	adapter = container_of(dev, struct i2c_adapter, dev);
+	driver->attach_adapter(adapter);
+
+	return 0;
+}
 
 /*
  * An i2c_driver is used with one or more i2c_client (device) nodes to access
@@ -698,21 +707,52 @@ int i2c_register_driver(struct module *o
 	pr_debug("i2c-core: driver [%s] registered\n", driver->driver.name);
 
 	/* legacy drivers scan i2c busses directly */
-	if (driver->attach_adapter) {
-		struct i2c_adapter *adapter;
+	if (driver->attach_adapter)
+		class_for_each_device(&i2c_adapter_class, driver,
+					__attach_adapter);
+
+	mutex_unlock(&core_lock);
+	return 0;
+}
+EXPORT_SYMBOL(i2c_register_driver);
+
+static int __detach_adapter(struct device *dev, void *data)
+{
+	struct list_head   *item2, *_n;
+	struct i2c_client  *client;
+	struct i2c_adapter *adap;
+	struct i2c_driver *driver = data;
 
-		down(&i2c_adapter_class.sem);
-		list_for_each_entry(adapter, &i2c_adapter_class.devices,
-				    dev.node) {
-			driver->attach_adapter(adapter);
+	/* Have a look at each adapter, if clients of this driver
+	 * are still attached. If so, detach them to be able to
+	 * kill the driver afterwards.
+	 */
+	adap = container_of(dev, struct i2c_adapter, dev);
+	if (driver->detach_adapter) {
+		if (driver->attach_adapter(adap))
+			dev_err(&adap->dev, "detach_adapter failed "
+					"for driver [%s]\n",
+					driver->driver.name);
+	} else {
+		list_for_each_safe(item2, _n, &adap->clients) {
+			client = list_entry(item2, struct i2c_client,
+					list);
+			if (client->driver != driver)
+				continue;
+			dev_dbg(&adap->dev, "detaching client [%s] "
+				"at 0x%02x\n", client->name,
+				client->addr);
+			if (driver->detach_client(client)) {
+				dev_err(&adap->dev, "detach_client "
+					"failed for client [%s] at "
+					"0x%02x\n", client->name,
+					client->addr);
+			}
 		}
-		up(&i2c_adapter_class.sem);
 	}
 
-	mutex_unlock(&core_lock);
 	return 0;
 }
-EXPORT_SYMBOL(i2c_register_driver);
 
 /**
  * i2c_del_driver - unregister I2C driver
@@ -721,46 +761,14 @@ EXPORT_SYMBOL(i2c_register_driver);
  */
 void i2c_del_driver(struct i2c_driver *driver)
 {
-	struct list_head   *item2, *_n;
-	struct i2c_client  *client;
-	struct i2c_adapter *adap;
-
 	mutex_lock(&core_lock);
 
 	/* new-style driver? */
 	if (is_newstyle_driver(driver))
 		goto unregister;
 
-	/* Have a look at each adapter, if clients of this driver are still
-	 * attached. If so, detach them to be able to kill the driver
-	 * afterwards.
-	 */
-	down(&i2c_adapter_class.sem);
-	list_for_each_entry(adap, &i2c_adapter_class.devices, dev.node) {
-		if (driver->detach_adapter) {
-			if (driver->detach_adapter(adap)) {
-				dev_err(&adap->dev, "detach_adapter failed "
-					"for driver [%s]\n",
-					driver->driver.name);
-			}
-		} else {
-			list_for_each_safe(item2, _n, &adap->clients) {
-				client = list_entry(item2, struct i2c_client, list);
-				if (client->driver != driver)
-					continue;
-				dev_dbg(&adap->dev, "detaching client [%s] "
-					"at 0x%02x\n", client->name,
-					client->addr);
-				if (driver->detach_client(client)) {
-					dev_err(&adap->dev, "detach_client "
-						"failed for client [%s] at "
-						"0x%02x\n", client->name,
-						client->addr);
-				}
-			}
-		}
-	}
-	up(&i2c_adapter_class.sem);
+	class_for_each_device(&i2c_adapter_class, driver,
+				__detach_adapter);
 
  unregister:
 	driver_unregister(&driver->driver);
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

i2c-use-class_for_each_device.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
printk-ratelimiting-rewrite.patch
printk-ratelimiting-rewrite-fix.patch
struct-class-sem-to-mutex-converting.patch
struct-class-remove-children-list.patch

