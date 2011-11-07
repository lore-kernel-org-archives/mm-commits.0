From: akpm@linux-foundation.org
Subject: [merged] drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:35 -0800
Message-ID: <201111072029.pA7KTZpb024485@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5930 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1KGU3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cabarnes@indesign-llc.com, stable@kernel.org, stable@vger.kernel.org, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/power/ds2780_battery.c: add a nolock function to w1 interface
has been removed from the -mm tree.  Its filename was
     drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Clifton Barnes <cabarnes@indesign-llc.com>
Subject: drivers/power/ds2780_battery.c: add a nolock function to w1 interface

Adds a nolock function to the w1 interface to avoid locking the
mutex if needed.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: <stable@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2780.c |   48 +++++++++++++++++++++++---------
 drivers/w1/slaves/w1_ds2780.h |    2 +
 2 files changed, 37 insertions(+), 13 deletions(-)

diff -puN drivers/w1/slaves/w1_ds2780.c~drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -26,20 +26,14 @@
 #include "../w1_family.h"
 #include "w1_ds2780.h"
 
-int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
-			int io)
+static int w1_ds2780_do_io(struct device *dev, char *buf, int addr,
+			size_t count, int io)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
 
-	if (!dev)
-		return -ENODEV;
+	if (addr > DS2780_DATA_SIZE || addr < 0)
+		return 0;
 
-	mutex_lock(&sl->master->mutex);
-
-	if (addr > DS2780_DATA_SIZE || addr < 0) {
-		count = 0;
-		goto out;
-	}
 	count = min_t(int, count, DS2780_DATA_SIZE - addr);
 
 	if (w1_reset_select_slave(sl) == 0) {
@@ -47,7 +41,6 @@ int w1_ds2780_io(struct device *dev, cha
 			w1_write_8(sl->master, W1_DS2780_WRITE_DATA);
 			w1_write_8(sl->master, addr);
 			w1_write_block(sl->master, buf, count);
-			/* XXX w1_write_block returns void, not n_written */
 		} else {
 			w1_write_8(sl->master, W1_DS2780_READ_DATA);
 			w1_write_8(sl->master, addr);
@@ -55,13 +48,42 @@ int w1_ds2780_io(struct device *dev, cha
 		}
 	}
 
-out:
+	return count;
+}
+
+int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	mutex_lock(&sl->master->mutex);
+
+	ret = w1_ds2780_do_io(dev, buf, addr, count, io);
+
 	mutex_unlock(&sl->master->mutex);
 
-	return count;
+	return ret;
 }
 EXPORT_SYMBOL(w1_ds2780_io);
 
+int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr, size_t count,
+			int io)
+{
+	int ret;
+
+	if (!dev)
+		return -ENODEV;
+
+	ret = w1_ds2780_do_io(dev, buf, addr, count, io);
+
+	return ret;
+}
+EXPORT_SYMBOL(w1_ds2780_io_nolock);
+
 int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd)
 {
 	struct w1_slave *sl = container_of(dev, struct w1_slave, dev);
diff -puN drivers/w1/slaves/w1_ds2780.h~drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface drivers/w1/slaves/w1_ds2780.h
--- a/drivers/w1/slaves/w1_ds2780.h~drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface
+++ a/drivers/w1/slaves/w1_ds2780.h
@@ -124,6 +124,8 @@
 
 extern int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
 			int io);
+extern int w1_ds2780_io_nolock(struct device *dev, char *buf, int addr,
+			size_t count, int io);
 extern int w1_ds2780_eeprom_cmd(struct device *dev, int addr, int cmd);
 
 #endif /* !_W1_DS2780_H */
_

Patches currently in -mm which might be from cabarnes@indesign-llc.com are

origin.patch
linux-next.patch

