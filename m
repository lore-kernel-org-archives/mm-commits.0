From: akpm@osdl.org
Subject: + cx88xx-fix-lockup-on-suspend.patch added to -mm tree
Date: Fri, 05 Jan 2007 11:39:13 -0800
Message-ID: <200701051939.l05JdDTd030230@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54402 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422699AbXAETjb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 14:39:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca, mchehab@infradead.org


The patch titled
     cx88xx: Fix lockup on suspend
has been added to the -mm tree.  Its filename is
     cx88xx-fix-lockup-on-suspend.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cx88xx: Fix lockup on suspend
From: Robert Hancock <hancockr@shaw.ca>

Suspending with the cx88xx module loaded causes the system to lock up
because the cx88_audio_thread kthread was missing a try_to_freeze() call,
which caused it to go into a tight loop and result in softlockup when
suspending.  Fix that.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/media/video/cx88/cx88-tvaudio.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/media/video/cx88/cx88-tvaudio.c~cx88xx-fix-lockup-on-suspend drivers/media/video/cx88/cx88-tvaudio.c
--- a/drivers/media/video/cx88/cx88-tvaudio.c~cx88xx-fix-lockup-on-suspend
+++ a/drivers/media/video/cx88/cx88-tvaudio.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
+#include <linux/freezer.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
@@ -912,6 +913,7 @@ int cx88_audio_thread(void *data)
 		msleep_interruptible(1000);
 		if (kthread_should_stop())
 			break;
+		try_to_freeze();
 
 		/* just monitor the audio status for now ... */
 		memset(&t, 0, sizeof(t));
_

Patches currently in -mm which might be from hancockr@shaw.ca are

cx88xx-fix-lockup-on-suspend.patch
sata_nv-add-suspend-resume-support.patch
