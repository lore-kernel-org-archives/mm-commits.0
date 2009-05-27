From: akpm@linux-foundation.org
Subject: + lis3-fix-misc-device-unregistering-and-printk.patch added to -mm tree
Date: Tue, 26 May 2009 19:22:24 -0700
Message-ID: <200905270222.n4R2MOJT030831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbZE0CWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 22:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.piel@tremplin-utc.net, pavel@ucw.cz


The patch titled
     lis3: fix misc device unregistering and printk
has been added to the -mm tree.  Its filename is
     lis3-fix-misc-device-unregistering-and-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
