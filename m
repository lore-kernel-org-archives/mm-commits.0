From: akpm@linux-foundation.org
Subject: + fix-firmware-sample-code.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:00:20 -0800
Message-ID: <200703250900.l2P90KAh024290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36860 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932773AbXCYJA1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:00:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, greg@kroah.com


The patch titled
     Fix firmware sample code
has been added to the -mm tree.  Its filename is
     fix-firmware-sample-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix firmware sample code
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>

The firmware_sample_driver driver from Documentation/firmware_class/ is
initializing the ghost device but doesn't register it, leading to a failure
in fw_register_device.  To fix it, one only needs to use device_register
instead of device_initialize.

Signed-off-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/firmware_class/firmware_sample_driver.c |   18 ++++++++--
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN Documentation/firmware_class/firmware_sample_driver.c~fix-firmware-sample-code Documentation/firmware_class/firmware_sample_driver.c
--- a/Documentation/firmware_class/firmware_sample_driver.c~fix-firmware-sample-code
+++ a/Documentation/firmware_class/firmware_sample_driver.c
@@ -13,13 +13,17 @@
 #include <linux/device.h>
 #include <linux/string.h>
 
-#include "linux/firmware.h"
+#include <linux/firmware.h>
+
+void sample_release(struct device *dev)
+{
+}
 
 static struct device ghost_device = {
 	.bus_id    = "ghost0",
+	.release   = sample_release,
 };
 
-
 static void sample_firmware_load(char *firmware, int size)
 {
 	u8 buf[size+1];
@@ -97,7 +101,14 @@ static void sample_probe_async(void)
 
 static int sample_init(void)
 {
-	device_initialize(&ghost_device);
+	int err;
+
+	err = device_register(&ghost_device);
+	if (err) {
+		printk(KERN_ERR "device_register failed (%d)\n",err);
+		return err;
+	}
+
 	/* since there is no real hardware insertion I just call the
 	 * sample probe functions here */
 	sample_probe_specific();
@@ -107,6 +118,7 @@ static int sample_init(void)
 }
 static void __exit sample_exit(void)
 {
+	device_unregister(&ghost_device);
 }
 
 module_init (sample_init);
_

Patches currently in -mm which might be from arnaud.patard@rtp-net.org are

origin.patch
fix-firmware-sample-code.patch
