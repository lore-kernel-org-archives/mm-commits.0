From: akpm@linux-foundation.org
Subject: - xilinx-hwicap-use-fixed-device-major.patch removed from -mm tree
Date: Tue, 01 Apr 2008 14:38:43 -0700
Message-ID: <200804012138.m31Lchi4014947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758667AbYDAVjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 17:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.neuendorffer@xilinx.com, grant.likely@secretlab.ca, jwboyer@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     xilinx: hwicap: use fixed device major
has been removed from the -mm tree.  Its filename was
     xilinx-hwicap-use-fixed-device-major.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xilinx: hwicap: use fixed device major
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Major 259 has been assigned by lanana.  Use it.  Also, publish /dev/icap[0-k]
as the device entries, and register platform devices named 'icap' to be
consistent.

Signed-off-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/xilinx_hwicap/xilinx_hwicap.c |   43 ++++++-------------
 1 file changed, 14 insertions(+), 29 deletions(-)

diff -puN drivers/char/xilinx_hwicap/xilinx_hwicap.c~xilinx-hwicap-use-fixed-device-major drivers/char/xilinx_hwicap/xilinx_hwicap.c
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c~xilinx-hwicap-use-fixed-device-major
+++ a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -36,7 +36,7 @@
  *****************************************************************************/
 
 /*
- * This is the code behind /dev/xilinx_icap -- it allows a user-space
+ * This is the code behind /dev/icap* -- it allows a user-space
  * application to use the Xilinx ICAP subsystem.
  *
  * The following operations are possible:
@@ -67,7 +67,7 @@
  * user-space application code that uses this device.  The simplest
  * way to use this interface is simply:
  *
- * cp foo.bit /dev/xilinx_icap
+ * cp foo.bit /dev/icap0
  *
  * Note that unless foo.bit is an appropriately constructed partial
  * bitstream, this has a high likelyhood of overwriting the design
@@ -105,18 +105,14 @@
 #include "buffer_icap.h"
 #include "fifo_icap.h"
 
-#define DRIVER_NAME "xilinx_icap"
+#define DRIVER_NAME "icap"
 
 #define HWICAP_REGS   (0x10000)
 
-/* dynamically allocate device number */
-static int xhwicap_major;
-static int xhwicap_minor;
+#define XHWICAP_MAJOR 259
+#define XHWICAP_MINOR 0
 #define HWICAP_DEVICES 1
 
-module_param(xhwicap_major, int, S_IRUGO);
-module_param(xhwicap_minor, int, S_IRUGO);
-
 /* An array, which is set to true when the device is registered. */
 static bool probed_devices[HWICAP_DEVICES];
 static struct mutex icap_sem;
@@ -605,7 +601,7 @@ static int __devinit hwicap_setup(struct
 	probed_devices[id] = 1;
 	mutex_unlock(&icap_sem);
 
-	devt = MKDEV(xhwicap_major, xhwicap_minor + id);
+	devt = MKDEV(XHWICAP_MAJOR, XHWICAP_MINOR + id);
 
 	drvdata = kzalloc(sizeof(struct hwicap_drvdata), GFP_KERNEL);
 	if (!drvdata) {
@@ -710,7 +706,7 @@ static int __devexit hwicap_remove(struc
 	dev_set_drvdata(dev, NULL);
 
 	mutex_lock(&icap_sem);
-	probed_devices[MINOR(dev->devt)-xhwicap_minor] = 0;
+	probed_devices[MINOR(dev->devt)-XHWICAP_MINOR] = 0;
 	mutex_unlock(&icap_sem);
 	return 0;		/* success */
 }
@@ -850,23 +846,12 @@ static int __init hwicap_module_init(voi
 	icap_class = class_create(THIS_MODULE, "xilinx_config");
 	mutex_init(&icap_sem);
 
-	if (xhwicap_major) {
-		devt = MKDEV(xhwicap_major, xhwicap_minor);
-		retval = register_chrdev_region(
-				devt,
-				HWICAP_DEVICES,
-				DRIVER_NAME);
-		if (retval < 0)
-			return retval;
-	} else {
-		retval = alloc_chrdev_region(&devt,
-				xhwicap_minor,
-				HWICAP_DEVICES,
-				DRIVER_NAME);
-		if (retval < 0)
-			return retval;
-		xhwicap_major = MAJOR(devt);
-	}
+	devt = MKDEV(XHWICAP_MAJOR, XHWICAP_MINOR);
+	retval = register_chrdev_region(devt,
+					HWICAP_DEVICES,
+					DRIVER_NAME);
+	if (retval < 0)
+		return retval;
 
 	retval = platform_driver_register(&hwicap_platform_driver);
 
@@ -891,7 +876,7 @@ static int __init hwicap_module_init(voi
 
 static void __exit hwicap_module_cleanup(void)
 {
-	dev_t devt = MKDEV(xhwicap_major, xhwicap_minor);
+	dev_t devt = MKDEV(XHWICAP_MAJOR, XHWICAP_MINOR);
 
 	class_destroy(icap_class);
 
_

Patches currently in -mm which might be from stephen.neuendorffer@xilinx.com are

git-powerpc.patch

