From: akpm@linux-foundation.org
Subject: + uevent-improve-error-checking-and-handling-fix.patch added to -mm tree
Date: Sat, 24 Mar 2007 07:42:03 -0800
Message-ID: <200703241542.l2OFg32k008649@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42517 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbXCXPmK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 24 Mar 2007 11:42:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com


The patch titled
     uevent-improve-error-checking-and-handling fix
has been added to the -mm tree.  Its filename is
     uevent-improve-error-checking-and-handling-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uevent-improve-error-checking-and-handling fix
From: Cornelia Huck <cornelia.huck@de.ibm.com>

The firmware class tried to suppress the first KOBJ_ADD uevent by
returning -ENODEV in firmware_uevent if FW_STATUS_READY was not set.
This only worked as long as the return code of kobject_uevent was not
checked in device_add. hack-to-make-wireless-work.patch made that first
uevent return successfully, but this possible triggered some udev rule
too early, leading to firmware load failures.

The following patch uses uevent_suppress to stop the uevent from being
generated during device_add.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/firmware_class.c~uevent-improve-error-checking-and-handling-fix drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~uevent-improve-error-checking-and-handling-fix
+++ a/drivers/base/firmware_class.c
@@ -333,6 +333,7 @@ static int fw_register_device(struct dev
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
+	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
@@ -385,6 +386,7 @@ static int fw_setup_device(struct firmwa
                 set_bit(FW_STATUS_READY, &fw_priv->status);
         else
                 set_bit(FW_STATUS_READY_NOHOTPLUG, &fw_priv->status);
+	f_dev->uevent_suppress = 0;
 	*dev_p = f_dev;
 	goto out;
 
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

uevent-improve-error-checking-and-handling-fix.patch
