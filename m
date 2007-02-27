From: akpm@linux-foundation.org
Subject: + usb-elan-ftdi-check-for-workqueue-creation-v2.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:50:51 -0800
Message-ID: <200702272050.l1RKotsj028107@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51330 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXB0UvJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:51:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, greg@kroah.com, zaitcev@redhat.com


The patch titled
     USB Elan FTDI: check for workqueue creation
has been added to the -mm tree.  Its filename is
     usb-elan-ftdi-check-for-workqueue-creation-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB Elan FTDI: check for workqueue creation
From: Cyrill Gorcunov <gorcunov@gmail.com>

Avoid NULL pointer usage if workqueue creation failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/ftdi-elan.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/usb/misc/ftdi-elan.c~usb-elan-ftdi-check-for-workqueue-creation-v2 drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~usb-elan-ftdi-check-for-workqueue-creation-v2
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -2905,17 +2905,31 @@ static int __init ftdi_elan_init(void)
 {
         int result;
         printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
-                 __TIME__, __DATE__);
+	       __TIME__, __DATE__);
         init_MUTEX(&ftdi_module_lock);
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
+	if (!status_queue)
+		goto err1;
         command_queue = create_singlethread_workqueue("ftdi-command-engine");
+	if (!command_queue)
+		goto err2;
         respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
+	if (!respond_queue)
+		goto err3;
         result = usb_register(&ftdi_elan_driver);
         if (result)
                 printk(KERN_ERR "usb_register failed. Error number %d\n",
-                        result);
+		       result);
         return result;
+
+ err3:
+	destroy_workqueue(command_queue);
+ err2:
+	destroy_workqueue(status_queue);
+ err1:
+	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
+	return -ENOMEM;
 }
 
 static void __exit ftdi_elan_exit(void)
_

Patches currently in -mm which might be from gorcunov@gmail.com are

ds1374-check-for-workqueue-creation.patch
usb-elan-ftdi-check-for-workqueue-creation-v2.patch
