From: akpm@linux-foundation.org
Subject: - usb-elan-ftdi-check-for-driver-registration-status.patch removed from -mm tree
Date: Mon, 26 Mar 2007 12:51:03 -0700
Message-ID: <200703261951.l2QJp3fu028876@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXCZTvW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Mar 2007 15:51:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, greg@kroah.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     USB Elan FTDI: check for driver registration status
has been removed from the -mm tree.  Its filename was
     usb-elan-ftdi-check-for-driver-registration-status.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: USB Elan FTDI: check for driver registration status
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add checking of driver registration status and if it fails release
allocated resources.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/ftdi-elan.c |   37 ++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff -puN drivers/usb/misc/ftdi-elan.c~usb-elan-ftdi-check-for-driver-registration-status drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~usb-elan-ftdi-check-for-driver-registration-status
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -2909,27 +2909,36 @@ static int __init ftdi_elan_init(void)
         init_MUTEX(&ftdi_module_lock);
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
-	if (!status_queue)
-		goto err1;
         command_queue = create_singlethread_workqueue("ftdi-command-engine");
-	if (!command_queue)
-		goto err2;
         respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
-	if (!respond_queue)
-		goto err3;
+	if (!status_queue || !command_queue || !respond_queue) {
+		printk(KERN_ERR "%s couldn't create workqueue\n",
+		       ftdi_elan_driver.name);
+		result = -ENOMEM;
+		goto err;
+	}
         result = usb_register(&ftdi_elan_driver);
-        if (result)
+        if (result) {
                 printk(KERN_ERR "usb_register failed. Error number %d\n",
 		       result);
+		goto err;
+	}
         return result;
 
- err3:
-	destroy_workqueue(command_queue);
- err2:
-	destroy_workqueue(status_queue);
- err1:
-	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
-	return -ENOMEM;
+ err:
+	if (status_queue) {
+		destroy_workqueue(status_queue);
+		status_queue = NULL;
+	}
+	if (command_queue) {
+		destroy_workqueue(command_queue);
+		command_queue = NULL;
+	}
+	if (respond_queue) {
+		destroy_workqueue(respond_queue);
+		respond_queue = NULL;
+	}
+	return result;
 }
 
 static void __exit ftdi_elan_exit(void)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-kbuild.patch
sun3-3x-lance-trivial-fix-improved.patch
usb-elan-ftdi-check-for-driver-registration-status.patch
cris-check-for-memory-allocation.patch
