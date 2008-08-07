From: akpm@linux-foundation.org
Subject: + isight_firmware-fix-a-leak-and-double-kfree.patch added to -mm tree
Date: Thu, 07 Aug 2008 13:10:12 -0700
Message-ID: <200808072010.m77KACUZ003059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbYHGUKm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2008 16:10:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: parag.warudkar@gmail.com


The patch titled
     From: "Parag Warudkar" <parag.warudkar@gmail.com>
has been added to the -mm tree.  Its filename is
     isight_firmware-fix-a-leak-and-double-kfree.patch

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
Subject: From: "Parag Warudkar" <parag.warudkar@gmail.com>


Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/isight_firmware.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/misc/isight_firmware.c~isight_firmware-fix-a-leak-and-double-kfree drivers/usb/misc/isight_firmware.c
--- a/drivers/usb/misc/isight_firmware.c~isight_firmware-fix-a-leak-and-double-kfree
+++ a/drivers/usb/misc/isight_firmware.c
@@ -48,7 +48,8 @@ static int isight_firmware_load(struct u
 
 	if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
 		printk(KERN_ERR "Unable to load isight firmware\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out;
 	}
 
 	ptr = firmware->data;
@@ -91,7 +92,6 @@ static int isight_firmware_load(struct u
 			     buf, llen, 300) != llen) {
 				printk(KERN_ERR
 				       "Failed to load isight firmware\n");
-				kfree(buf);
 				ret = -ENODEV;
 				goto out;
 			}
_

Patches currently in -mm which might be from parag.warudkar@gmail.com are

isight_firmware-fix-a-leak-and-double-kfree.patch

