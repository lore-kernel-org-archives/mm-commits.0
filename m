From: akpm@linux-foundation.org
Subject: + i2o-handle-sysfs_create_link-failures.patch added to -mm tree
Date: Wed, 28 May 2008 15:44:20 -0700
Message-ID: <200805282244.m4SMiKeq004077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753628AbYE1WpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 May 2008 18:45:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wangchen@cn.fujitsu.com, Markus.Lidel@shadowconnect.com, jens.axboe@oracle.com


The patch titled
     I2O: handle sysfs_create_link() failures
has been added to the -mm tree.  Its filename is
     i2o-handle-sysfs_create_link-failures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: I2O: handle sysfs_create_link() failures
From: Wang Chen <wangchen@cn.fujitsu.com>

Compile warning:
ignoring return value of `sysfs_create_link', declared with attribute warn_unused_result.

If sysfs_create_link failed, take care of the return value and do some
error handle after the failure.

Since sysfs_remove_link() will check whether a link exists, when removing the
link in error path, we don't need to care whether a link was created.

Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/device.c |   54 +++++++++++++++++++++++++--------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff -puN drivers/message/i2o/device.c~i2o-handle-sysfs_create_link-failures drivers/message/i2o/device.c
--- a/drivers/message/i2o/device.c~i2o-handle-sysfs_create_link-failures
+++ a/drivers/message/i2o/device.c
@@ -243,29 +243,41 @@ static int i2o_device_add(struct i2o_con
 
 	/* create user entries for this device */
 	tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.user_tid);
-	if (tmp && (tmp != i2o_dev))
-		sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-				  "user");
+	if (tmp && (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&i2o_dev->device.kobj,
+				       &tmp->device.kobj, "user");
+		if (rc)
+			goto unreg_dev;
+	}
 
 	/* create user entries refering to this device */
 	list_for_each_entry(tmp, &c->devices, list)
 	    if ((tmp->lct_data.user_tid == i2o_dev->lct_data.tid)
-		&& (tmp != i2o_dev))
-		sysfs_create_link(&tmp->device.kobj,
-				  &i2o_dev->device.kobj, "user");
+		&& (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&tmp->device.kobj,
+				       &i2o_dev->device.kobj, "user");
+		if (rc)
+			goto rmlink1;
+	}
 
 	/* create parent entries for this device */
 	tmp = i2o_iop_find_device(i2o_dev->iop, i2o_dev->lct_data.parent_tid);
-	if (tmp && (tmp != i2o_dev))
-		sysfs_create_link(&i2o_dev->device.kobj, &tmp->device.kobj,
-				  "parent");
+	if (tmp && (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&i2o_dev->device.kobj,
+				       &tmp->device.kobj, "parent");
+		if (rc)
+			goto rmlink1;
+	}
 
 	/* create parent entries refering to this device */
 	list_for_each_entry(tmp, &c->devices, list)
 	    if ((tmp->lct_data.parent_tid == i2o_dev->lct_data.tid)
-		&& (tmp != i2o_dev))
-		sysfs_create_link(&tmp->device.kobj,
-				  &i2o_dev->device.kobj, "parent");
+		&& (tmp != i2o_dev)) {
+		rc = sysfs_create_link(&tmp->device.kobj,
+				       &i2o_dev->device.kobj, "parent");
+		if (rc)
+			goto rmlink2;
+	}
 
 	i2o_driver_notify_device_add_all(i2o_dev);
 
@@ -273,6 +285,24 @@ static int i2o_device_add(struct i2o_con
 
 	return 0;
 
+rmlink2:
+	/* If link creating failed halfway, we loop whole list to cleanup.
+	 * And we don't care wrong removing of link, because sysfs_remove_link
+	 * will take care of it.
+	 */
+	list_for_each_entry(tmp, &c->devices, list) {
+		if (tmp->lct_data.parent_tid == i2o_dev->lct_data.tid)
+			sysfs_remove_link(&tmp->device.kobj, "parent");
+	}
+	sysfs_remove_link(&i2o_dev->device.kobj, "parent");
+rmlink1:
+	list_for_each_entry(tmp, &c->devices, list)
+		if (tmp->lct_data.user_tid == i2o_dev->lct_data.tid)
+			sysfs_remove_link(&tmp->device.kobj, "user");
+	sysfs_remove_link(&i2o_dev->device.kobj, "user");
+unreg_dev:
+	list_del(&i2o_dev->list);
+	device_unregister(&i2o_dev->device);
 err:
 	kfree(i2o_dev);
 	return rc;
_

Patches currently in -mm which might be from wangchen@cn.fujitsu.com are

linux-next.patch
i2o-handle-sysfs_create_link-failures.patch

