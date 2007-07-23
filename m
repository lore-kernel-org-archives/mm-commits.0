From: akpm@linux-foundation.org
Subject: + fix-failure-exits-in-asus-laptop.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:27:24 -0700
Message-ID: <200707232127.l6NLROui012661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50044 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbXGWV2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:28:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, corentincj@iksaif.net, michal.k.k.piotrowski@gmail.com, sziwan@users.sourceforge.net, viro@zeniv.linux.org.uk


The patch titled
     Fix failure exits in asus-laptop
has been added to the -mm tree.  Its filename is
     fix-failure-exits-in-asus-laptop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix failure exits in asus-laptop
From: Al Viro <viro@ftp.linux.org.uk>

Fallout from f8a7c6fe14f556ca8eeddce258cb21392d0c3a2f.  However, looking
at it shows that checks done in ASUS_LED_UNREGISTER() can't trigger
at all (we never get to asus_led_exit() if registration fails) and
if that registration fails, we actually leak stuff.  IOW, it's worse
than just replacing class_dev with dev in there - the tests themselves
had been papering over the lousy cleanup logics.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/asus-laptop.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff -puN drivers/misc/asus-laptop.c~fix-failure-exits-in-asus-laptop drivers/misc/asus-laptop.c
--- a/drivers/misc/asus-laptop.c~fix-failure-exits-in-asus-laptop
+++ a/drivers/misc/asus-laptop.c
@@ -1067,19 +1067,16 @@ static void asus_backlight_exit(void)
 }
 
 #define  ASUS_LED_UNREGISTER(object)				\
-	if(object##_led.class_dev				\
-	   && !IS_ERR(object##_led.class_dev))			\
-		led_classdev_unregister(&object##_led)
+	led_classdev_unregister(&object##_led)
 
 static void asus_led_exit(void)
 {
+	destroy_workqueue(led_workqueue);
 	ASUS_LED_UNREGISTER(mled);
 	ASUS_LED_UNREGISTER(tled);
 	ASUS_LED_UNREGISTER(pled);
 	ASUS_LED_UNREGISTER(rled);
 	ASUS_LED_UNREGISTER(gled);
-
-	destroy_workqueue(led_workqueue);
 }
 
 static void __exit asus_laptop_exit(void)
@@ -1135,29 +1132,42 @@ static int asus_led_init(struct device *
 
 	rv = ASUS_LED_REGISTER(mled, dev);
 	if (rv)
-		return rv;
+		goto out;
 
 	rv = ASUS_LED_REGISTER(tled, dev);
 	if (rv)
-		return rv;
+		goto out1;
 
 	rv = ASUS_LED_REGISTER(rled, dev);
 	if (rv)
-		return rv;
+		goto out2;
 
 	rv = ASUS_LED_REGISTER(pled, dev);
 	if (rv)
-		return rv;
+		goto out3;
 
 	rv = ASUS_LED_REGISTER(gled, dev);
 	if (rv)
-		return rv;
+		goto out4;
 
 	led_workqueue = create_singlethread_workqueue("led_workqueue");
 	if (!led_workqueue)
-		return -ENOMEM;
+		goto out5;
 
 	return 0;
+out5:
+	rv = -ENOMEM;
+	ASUS_LED_UNREGISTER(gled);
+out4:
+	ASUS_LED_UNREGISTER(pled);
+out3:
+	ASUS_LED_UNREGISTER(rled);
+out2:
+	ASUS_LED_UNREGISTER(tled);
+out1:
+	ASUS_LED_UNREGISTER(mled);
+out:
+	return rv;
 }
 
 static int __init asus_laptop_init(void)
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

fix-failure-exits-in-asus-laptop.patch
introduce-i_sync.patch
slab-leaks3-default-y.patch
