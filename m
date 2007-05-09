From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-in-hdaps-driver.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:49 -0700
Message-ID: <200705090252.l492qnOC009618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030323AbXEICwz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, rlove@rlove.org, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore in hdaps driver
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-in-hdaps-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use mutex instead of semaphore in hdaps driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The hdaps driver uses a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Robert Love <rlove@rlove.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hdaps.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff -puN drivers/hwmon/hdaps.c~use-mutex-instead-of-semaphore-in-hdaps-driver drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~use-mutex-instead-of-semaphore-in-hdaps-driver
+++ a/drivers/hwmon/hdaps.c
@@ -30,10 +30,12 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/kernel.h>
+#include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/dmi.h>
 #include <linux/jiffies.h>
+
 #include <asm/io.h>
 
 #define HDAPS_LOW_PORT		0x1600	/* first port used by hdaps */
@@ -71,10 +73,10 @@ static u8 km_activity;
 static int rest_x;
 static int rest_y;
 
-static DECLARE_MUTEX(hdaps_sem);
+static DEFINE_MUTEX(hdaps_mtx);
 
 /*
- * __get_latch - Get the value from a given port.  Callers must hold hdaps_sem.
+ * __get_latch - Get the value from a given port.  Callers must hold hdaps_mtx.
  */
 static inline u8 __get_latch(u16 port)
 {
@@ -83,7 +85,7 @@ static inline u8 __get_latch(u16 port)
 
 /*
  * __check_latch - Check a port latch for a given value.  Returns zero if the
- * port contains the given value.  Callers must hold hdaps_sem.
+ * port contains the given value.  Callers must hold hdaps_mtx.
  */
 static inline int __check_latch(u16 port, u8 val)
 {
@@ -94,7 +96,7 @@ static inline int __check_latch(u16 port
 
 /*
  * __wait_latch - Wait up to 100us for a port latch to get a certain value,
- * returning zero if the value is obtained.  Callers must hold hdaps_sem.
+ * returning zero if the value is obtained.  Callers must hold hdaps_mtx.
  */
 static int __wait_latch(u16 port, u8 val)
 {
@@ -111,7 +113,7 @@ static int __wait_latch(u16 port, u8 val
 
 /*
  * __device_refresh - request a refresh from the accelerometer.  Does not wait
- * for refresh to complete.  Callers must hold hdaps_sem.
+ * for refresh to complete.  Callers must hold hdaps_mtx.
  */
 static void __device_refresh(void)
 {
@@ -125,7 +127,7 @@ static void __device_refresh(void)
 /*
  * __device_refresh_sync - request a synchronous refresh from the
  * accelerometer.  We wait for the refresh to complete.  Returns zero if
- * successful and nonzero on error.  Callers must hold hdaps_sem.
+ * successful and nonzero on error.  Callers must hold hdaps_mtx.
  */
 static int __device_refresh_sync(void)
 {
@@ -135,7 +137,7 @@ static int __device_refresh_sync(void)
 
 /*
  * __device_complete - indicate to the accelerometer that we are done reading
- * data, and then initiate an async refresh.  Callers must hold hdaps_sem.
+ * data, and then initiate an async refresh.  Callers must hold hdaps_mtx.
  */
 static inline void __device_complete(void)
 {
@@ -153,7 +155,7 @@ static int hdaps_readb_one(unsigned int 
 {
 	int ret;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 
 	/* do a sync refresh -- we need to be sure that we read fresh data */
 	ret = __device_refresh_sync();
@@ -164,7 +166,7 @@ static int hdaps_readb_one(unsigned int 
 	__device_complete();
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 	return ret;
 }
 
@@ -199,9 +201,9 @@ static int hdaps_read_pair(unsigned int 
 {
 	int ret;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 	ret = __hdaps_read_pair(port1, port2, val1, val2);
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 
 	return ret;
 }
@@ -214,7 +216,7 @@ static int hdaps_device_init(void)
 {
 	int total, ret = -ENXIO;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 
 	outb(0x13, 0x1610);
 	outb(0x01, 0x161f);
@@ -280,7 +282,7 @@ static int hdaps_device_init(void)
 	}
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 	return ret;
 }
 
@@ -314,7 +316,7 @@ static struct platform_driver hdaps_driv
 };
 
 /*
- * hdaps_calibrate - Set our "resting" values.  Callers must hold hdaps_sem.
+ * hdaps_calibrate - Set our "resting" values.  Callers must hold hdaps_mtx.
  */
 static void hdaps_calibrate(void)
 {
@@ -326,7 +328,7 @@ static void hdaps_mousedev_poll(unsigned
 	int x, y;
 
 	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
-	if (down_trylock(&hdaps_sem)) {
+	if (mutex_trylock(&hdaps_mtx)) {
 		mod_timer(&hdaps_timer,jiffies + HDAPS_POLL_PERIOD);
 		return;
 	}
@@ -341,7 +343,7 @@ static void hdaps_mousedev_poll(unsigned
 	mod_timer(&hdaps_timer, jiffies + HDAPS_POLL_PERIOD);
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 }
 
 
@@ -421,9 +423,9 @@ static ssize_t hdaps_calibrate_store(str
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 	hdaps_calibrate();
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 
 	return count;
 }
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
git-scsi-misc.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
git-watchdog.patch
