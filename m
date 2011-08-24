From: akpm@linux-foundation.org
Subject: + drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface.patch added to -mm tree
Date: Wed, 24 Aug 2011 11:51:04 -0700
Message-ID: <201108241851.p7OIp4Jg032563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753798Ab1HXSvN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Aug 2011 14:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cabarnes@indesign-llc.com, zbr@ioremap.net


The patch titled
     drivers/power/ds2780_battery.c: add a nolock function to w1 interface
has been added to the -mm tree.  Its filename is
     drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface.patch

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
Subject: drivers/power/ds2780_battery.c: add a nolock function to w1 interface
From: Clifton Barnes <cabarnes@indesign-llc.com>

Adds a nolock function to the w1 interface to avoid locking the
mutex if needed.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
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

linux-next.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch
drivers-power-ds2780_batteryc-create-central-point-for-calling-w1-interface.patch
drivers-power-ds2780_batteryc-add-a-nolock-function-to-w1-interface.patch
drivers-power-ds2780_batteryc-fix-deadlock-upon-insertion-and-removal.patch

