From: akpm@linux-foundation.org
Subject: + usb-elan-ftdi-check-for-driver-registration-status-v2.patch added to -mm tree
Date: Wed, 28 Mar 2007 18:34:01 -0700
Message-ID: <200703290134.l2T1Y13v024824@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38017 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965811AbXC2Bew (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 21:34:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, greg@kroah.com, lcapitulino@mandriva.com.br, zaitcev@redhat.com


The patch titled
     USB Elan FTDI: check for driver registration status
has been added to the -mm tree.  Its filename is
     usb-elan-ftdi-check-for-driver-registration-status-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB Elan FTDI: check for driver registration status
From: Cyrill Gorcunov <gorcunov@gmail.com>

Add checking of driver registration status and release allocated resources
if it failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/ftdi-elan.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN drivers/usb/misc/ftdi-elan.c~usb-elan-ftdi-check-for-driver-registration-status-v2 drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~usb-elan-ftdi-check-for-driver-registration-status-v2
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -2910,24 +2910,28 @@ static int __init ftdi_elan_init(void)
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
 	if (!status_queue)
-		goto err1;
+		goto err_status_queue;
         command_queue = create_singlethread_workqueue("ftdi-command-engine");
 	if (!command_queue)
-		goto err2;
+		goto err_command_queue;
         respond_queue = create_singlethread_workqueue("ftdi-respond-engine");
 	if (!respond_queue)
-		goto err3;
+		goto err_respond_queue;
         result = usb_register(&ftdi_elan_driver);
-        if (result)
+        if (result) {
+		destroy_workqueue(status_queue);
+		destroy_workqueue(command_queue);
+		destroy_workqueue(respond_queue);
                 printk(KERN_ERR "usb_register failed. Error number %d\n",
 		       result);
+	}
         return result;
 
- err3:
+ err_respond_queue:
 	destroy_workqueue(command_queue);
- err2:
+ err_command_queue:
 	destroy_workqueue(status_queue);
- err1:
+ err_status_queue:
 	printk(KERN_ERR "%s couldn't create workqueue\n", ftdi_elan_driver.name);
 	return -ENOMEM;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

git-kbuild.patch
sun3-3x-lance-trivial-fix-improved.patch
usb-elan-ftdi-check-for-driver-registration-status-v2.patch
cris-check-for-memory-allocation.patch
