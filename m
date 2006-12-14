From: akpm@osdl.org
Subject: - rtc-remove-syslog-spam-on-registration.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:12:36 -0800
Message-ID: <200612140612.kBE6CaOp002083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbWLNGNT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:13:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc: remove syslog spam on registration
has been removed from the -mm tree.  Its filename was
     rtc-remove-syslog-spam-on-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc: remove syslog spam on registration
From: David Brownell <david-b@pacbell.net>

This removes some syslog spam as RTC drivers register; debug messages
shouldn't come out at "info" level.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/rtc/rtc-dev.c   |    2 +-
 drivers/rtc/rtc-proc.c  |    2 +-
 drivers/rtc/rtc-sysfs.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-dev.c~rtc-remove-syslog-spam-on-registration drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-remove-syslog-spam-on-registration
+++ a/drivers/rtc/rtc-dev.c
@@ -435,7 +435,7 @@ static int rtc_dev_add_device(struct cla
 		goto err_cdev_del;
 	}
 
-	dev_info(class_dev->dev, "rtc intf: dev (%d:%d)\n",
+	dev_dbg(class_dev->dev, "rtc intf: dev (%d:%d)\n",
 		MAJOR(rtc->rtc_dev->devt),
 		MINOR(rtc->rtc_dev->devt));
 
diff -puN drivers/rtc/rtc-proc.c~rtc-remove-syslog-spam-on-registration drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~rtc-remove-syslog-spam-on-registration
+++ a/drivers/rtc/rtc-proc.c
@@ -120,7 +120,7 @@ static int rtc_proc_add_device(struct cl
 			ent->owner = rtc->owner;
 			ent->data = class_dev;
 
-			dev_info(class_dev->dev, "rtc intf: proc\n");
+			dev_dbg(class_dev->dev, "rtc intf: proc\n");
 		}
 		else
 			rtc_dev = NULL;
diff -puN drivers/rtc/rtc-sysfs.c~rtc-remove-syslog-spam-on-registration drivers/rtc/rtc-sysfs.c
--- a/drivers/rtc/rtc-sysfs.c~rtc-remove-syslog-spam-on-registration
+++ a/drivers/rtc/rtc-sysfs.c
@@ -83,7 +83,7 @@ static int __devinit rtc_sysfs_add_devic
 {
 	int err;
 
-	dev_info(class_dev->dev, "rtc intf: sysfs\n");
+	dev_dbg(class_dev->dev, "rtc intf: sysfs\n");
 
 	err = sysfs_create_group(&class_dev->kobj, &rtc_attr_group);
 	if (err)
_

Patches currently in -mm which might be from david-b@pacbell.net are


