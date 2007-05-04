From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-hdaps-driver.patch added to -mm tree
Date: Thu, 03 May 2007 20:16:15 -0700
Message-ID: <200705040316.l443GF7A027962@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767598AbXEDDQW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:16:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, rlove@rlove.org


The patch titled
     use mutex instead of semaphore in hdaps driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-hdaps-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in hdaps driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The hdaps driver uses a semaphore as mutex.  Use the mutex API instead of the
(binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Robert Love <rlove@rlove.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/hdaps.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/hwmon/hdaps.c~use-mutex-instead-of-semaphore-in-hdaps-driver drivers/hwmon/hdaps.c
--- a/drivers/hwmon/hdaps.c~use-mutex-instead-of-semaphore-in-hdaps-driver
+++ a/drivers/hwmon/hdaps.c
@@ -71,10 +71,10 @@ static u8 km_activity;
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
@@ -83,7 +83,7 @@ static inline u8 __get_latch(u16 port)
 
 /*
  * __check_latch - Check a port latch for a given value.  Returns zero if the
- * port contains the given value.  Callers must hold hdaps_sem.
+ * port contains the given value.  Callers must hold hdaps_mtx.
  */
 static inline int __check_latch(u16 port, u8 val)
 {
@@ -94,7 +94,7 @@ static inline int __check_latch(u16 port
 
 /*
  * __wait_latch - Wait up to 100us for a port latch to get a certain value,
- * returning zero if the value is obtained.  Callers must hold hdaps_sem.
+ * returning zero if the value is obtained.  Callers must hold hdaps_mtx.
  */
 static int __wait_latch(u16 port, u8 val)
 {
@@ -111,7 +111,7 @@ static int __wait_latch(u16 port, u8 val
 
 /*
  * __device_refresh - request a refresh from the accelerometer.  Does not wait
- * for refresh to complete.  Callers must hold hdaps_sem.
+ * for refresh to complete.  Callers must hold hdaps_mtx.
  */
 static void __device_refresh(void)
 {
@@ -125,7 +125,7 @@ static void __device_refresh(void)
 /*
  * __device_refresh_sync - request a synchronous refresh from the
  * accelerometer.  We wait for the refresh to complete.  Returns zero if
- * successful and nonzero on error.  Callers must hold hdaps_sem.
+ * successful and nonzero on error.  Callers must hold hdaps_mtx.
  */
 static int __device_refresh_sync(void)
 {
@@ -135,7 +135,7 @@ static int __device_refresh_sync(void)
 
 /*
  * __device_complete - indicate to the accelerometer that we are done reading
- * data, and then initiate an async refresh.  Callers must hold hdaps_sem.
+ * data, and then initiate an async refresh.  Callers must hold hdaps_mtx.
  */
 static inline void __device_complete(void)
 {
@@ -153,7 +153,7 @@ static int hdaps_readb_one(unsigned int 
 {
 	int ret;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 
 	/* do a sync refresh -- we need to be sure that we read fresh data */
 	ret = __device_refresh_sync();
@@ -164,7 +164,7 @@ static int hdaps_readb_one(unsigned int 
 	__device_complete();
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 	return ret;
 }
 
@@ -199,9 +199,9 @@ static int hdaps_read_pair(unsigned int 
 {
 	int ret;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 	ret = __hdaps_read_pair(port1, port2, val1, val2);
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 
 	return ret;
 }
@@ -214,7 +214,7 @@ static int hdaps_device_init(void)
 {
 	int total, ret = -ENXIO;
 
-	down(&hdaps_sem);
+	mutex_lock(&hdaps_mtx);
 
 	outb(0x13, 0x1610);
 	outb(0x01, 0x161f);
@@ -280,7 +280,7 @@ static int hdaps_device_init(void)
 	}
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 	return ret;
 }
 
@@ -314,7 +314,7 @@ static struct platform_driver hdaps_driv
 };
 
 /*
- * hdaps_calibrate - Set our "resting" values.  Callers must hold hdaps_sem.
+ * hdaps_calibrate - Set our "resting" values.  Callers must hold hdaps_mtx.
  */
 static void hdaps_calibrate(void)
 {
@@ -326,7 +326,7 @@ static void hdaps_mousedev_poll(unsigned
 	int x, y;
 
 	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
-	if (down_trylock(&hdaps_sem)) {
+	if (mutex_trylock(&hdaps_mtx)) {
 		mod_timer(&hdaps_timer,jiffies + HDAPS_POLL_PERIOD);
 		return;
 	}
@@ -341,7 +341,7 @@ static void hdaps_mousedev_poll(unsigned
 	mod_timer(&hdaps_timer, jiffies + HDAPS_POLL_PERIOD);
 
 out:
-	up(&hdaps_sem);
+	mutex_unlock(&hdaps_mtx);
 }
 
 
@@ -421,9 +421,9 @@ static ssize_t hdaps_calibrate_store(str
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
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
git-dvb.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
qla1280-use-dma_64bit_mask-instead-of-0ull.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
