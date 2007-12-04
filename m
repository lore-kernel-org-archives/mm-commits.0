From: akpm@linux-foundation.org
Subject: + usb-testing-driver-convert-dev-sem-to-mutex.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:20:01 -0800
Message-ID: <200712042020.lB4KK2Hk003152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751239AbXLDUUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:20:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     USB testing driver: convert dev->sem to mutex
has been added to the -mm tree.  Its filename is
     usb-testing-driver-convert-dev-sem-to-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB testing driver: convert dev->sem to mutex
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

USB testing driver: convert semaphore dev->sem to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/usbtest.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/usb/misc/usbtest.c~usb-testing-driver-convert-dev-sem-to-mutex drivers/usb/misc/usbtest.c
--- a/drivers/usb/misc/usbtest.c~usb-testing-driver-convert-dev-sem-to-mutex
+++ a/drivers/usb/misc/usbtest.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
+#include <linux/mutex.h>
 
 #include <linux/usb.h>
 
@@ -64,7 +65,7 @@ struct usbtest_dev {
 	int			in_iso_pipe;
 	int			out_iso_pipe;
 	struct usb_endpoint_descriptor	*iso_in, *iso_out;
-	struct semaphore	sem;
+	struct mutex		lock;
 
 #define TBUF_SIZE	256
 	u8			*buf;
@@ -1558,11 +1559,11 @@ usbtest_ioctl (struct usb_interface *int
 			|| param->sglen < 0 || param->vary < 0)
 		return -EINVAL;
 
-	if (down_interruptible (&dev->sem))
+	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
 
 	if (intf->dev.power.power_state.event != PM_EVENT_ON) {
-		up (&dev->sem);
+		mutex_unlock(&dev->lock);
 		return -EHOSTUNREACH;
 	}
 
@@ -1574,7 +1575,7 @@ usbtest_ioctl (struct usb_interface *int
 	    	int	res;
 
 		if (intf->altsetting->desc.bInterfaceNumber) {
-			up (&dev->sem);
+			mutex_unlock(&dev->lock);
 			return -ENODEV;
 		}
 		res = set_altsetting (dev, dev->info->alt);
@@ -1582,7 +1583,7 @@ usbtest_ioctl (struct usb_interface *int
 			dev_err (&intf->dev,
 					"set altsetting to %d failed, %d\n",
 					dev->info->alt, res);
-			up (&dev->sem);
+			mutex_unlock(&dev->lock);
 			return res;
 		}
 	}
@@ -1855,7 +1856,7 @@ usbtest_ioctl (struct usb_interface *int
 		param->duration.tv_usec += 1000 * 1000;
 		param->duration.tv_sec -= 1;
 	}
-	up (&dev->sem);
+	mutex_unlock(&dev->lock);
 	return retval;
 }
 
@@ -1905,7 +1906,7 @@ usbtest_probe (struct usb_interface *int
 		return -ENOMEM;
 	info = (struct usbtest_info *) id->driver_info;
 	dev->info = info;
-	init_MUTEX (&dev->sem);
+	mutex_init(&dev->lock);
 
 	dev->intf = intf;
 
@@ -1990,7 +1991,7 @@ static void usbtest_disconnect (struct u
 {
 	struct usbtest_dev	*dev = usb_get_intfdata (intf);
 
-	down (&dev->sem);
+	mutex_lock(&dev->lock);
 
 	usb_set_intfdata (intf, NULL);
 	dev_dbg (&intf->dev, "disconnect\n");
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

git-dvb.patch
git-infiniband.patch
git-netdev-all.patch
git-scsi-misc.patch
edgeport-usb-serial-converter-convert-es_sem-to-mutex.patch
usb-testing-driver-convert-dev-sem-to-mutex.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
