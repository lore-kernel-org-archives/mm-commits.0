From: akpm@linux-foundation.org
Subject: [merged] lis3-fix-misc-device-unregistering-and-printk.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:50 -0700
Message-ID: <200906171838.n5HIcoKF004842@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756667AbZFQSjm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     lis3: fix misc device unregistering and printk
has been removed from the -mm tree.  Its filename was
     lis3-fix-misc-device-unregistering-and-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lis3: fix misc device unregistering and printk
From: Eric Piel <eric.piel@tremplin-utc.net>

Can only unregister the misc device if it was registered before.  Also
remove debugging messages, which in addition were not properly formated.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lis3lv02d.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/lis3lv02d.c~lis3-fix-misc-device-unregistering-and-printk drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~lis3-fix-misc-device-unregistering-and-printk
+++ a/drivers/hwmon/lis3lv02d.c
@@ -199,7 +199,6 @@ static int lis3lv02d_misc_open(struct in
 		return -EBUSY;
 	}
 	lis3lv02d_increase_use(&lis3_dev);
-	printk("lis3: registered interrupt %d\n", lis3_dev.irq);
 	return 0;
 }
 
@@ -378,7 +377,8 @@ void lis3lv02d_joystick_disable(void)
 	if (!lis3_dev.idev)
 		return;
 
-	misc_deregister(&lis3lv02d_misc_device);
+	if (lis3_dev.irq)
+		misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_device(lis3_dev.idev);
 	lis3_dev.idev = NULL;
 }
@@ -493,8 +493,6 @@ int lis3lv02d_init_device(struct lis3lv0
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
 
-	printk("lis3_init_device: irq %d\n", dev->irq);
