From: akpm@osdl.org
Subject: - cx88xx-fix-lockup-on-suspend.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:08:05 -0800
Message-ID: <200701092008.l09K86Tp013880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39490 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348AbXAIUIl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:08:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     cx88xx: Fix lockup on suspend
has been removed from the -mm tree.  Its filename was
     cx88xx-fix-lockup-on-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-dvb.patch
git-libata-all.patch
sata_nv-add-suspend-resume-support.patch
