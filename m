From: akpm@linux-foundation.org
Subject: - isight_firmware-fix-a-leak-and-double-kfree.patch removed from -mm tree
Date: Wed, 13 Aug 2008 01:52:31 -0700
Message-ID: <200808130852.m7D8qVuB008213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754563AbYHMIxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Aug 2008 04:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: parag.warudkar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     isight_firmware: fix a leak and double kfree()
has been removed from the -mm tree.  Its filename was
     isight_firmware-fix-a-leak-and-double-kfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isight_firmware: fix a leak and double kfree()
From: "Parag Warudkar" <parag.warudkar@gmail.com>

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


