From: akpm@linux-foundation.org
Subject: - driver-core-switch-firmware_class-to.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:45 -0700
Message-ID: <200704132328.l3DNSj6Q012547@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161062AbXDMX3C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, eric.rannaud@gmail.com, greg@kroah.com, heiko.carstens@de.ibm.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Driver core: switch firmware_class to  uevent_suppress
has been removed from the -mm tree.  Its filename was
     driver-core-switch-firmware_class-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Driver core: switch firmware_class to  uevent_suppress
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Use uevent_suppress instead of returning an error code in firmware_uevent(). 
Get rid of the now unneeded FW_STATUS_READY and FW_STATUS_READY_NOHOTPLUG.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/base/firmware_class.c~driver-core-switch-firmware_class-to drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~driver-core-switch-firmware_class-to
+++ a/drivers/base/firmware_class.c
@@ -31,8 +31,6 @@ enum {
 	FW_STATUS_LOADING,
 	FW_STATUS_DONE,
 	FW_STATUS_ABORT,
-	FW_STATUS_READY,
-	FW_STATUS_READY_NOHOTPLUG,
 };
 
 static int loading_timeout = 60;	/* In seconds */
@@ -96,9 +94,6 @@ static int firmware_uevent(struct device
 	struct firmware_priv *fw_priv = dev_get_drvdata(dev);
 	int i = 0, len = 0;
 
-	if (!test_bit(FW_STATUS_READY, &fw_priv->status))
-		return -ENODEV;
-
 	if (add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &len,
 			   "FIRMWARE=%s", fw_priv->fw_id))
 		return -ENOMEM;
@@ -333,6 +328,7 @@ static int fw_register_device(struct dev
 	f_dev->parent = device;
 	f_dev->class = &firmware_class;
 	dev_set_drvdata(f_dev, fw_priv);
+	f_dev->uevent_suppress = 1;
 	retval = device_register(f_dev);
 	if (retval) {
 		printk(KERN_ERR "%s: device_register failed\n",
@@ -382,9 +378,7 @@ static int fw_setup_device(struct firmwa
 	}
 
 	if (uevent)
-                set_bit(FW_STATUS_READY, &fw_priv->status);
-        else
-                set_bit(FW_STATUS_READY_NOHOTPLUG, &fw_priv->status);
+		f_dev->uevent_suppress = 0;
 	*dev_p = f_dev;
 	goto out;
 
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

s390-cio-delay-uevents-for-subchannels.patch
uevent-use-add_uevent_var-instead-of-open-coding-it.patch
device_schedule_callback-needs-a-module-reference-fix.patch
git-s390.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
