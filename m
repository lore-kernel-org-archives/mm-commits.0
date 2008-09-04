From: akpm@linux-foundation.org
Subject: + v4l-dvb-gspca-fix-wrong-retry-counting.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:15:47 -0700
Message-ID: <200809042015.m84KFlV1028645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631AbYIDUQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 16:16:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, mchehab@infradead.org


The patch titled
     v4l/dvb: gspca: fix wrong retry counting
has been added to the -mm tree.  Its filename is
     v4l-dvb-gspca-fix-wrong-retry-counting.patch

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
Subject: v4l/dvb: gspca: fix wrong retry counting
From: Li Zefan <lizf@cn.fujitsu.com>

After 'while (retry--) {...}', retry will be -1 but not 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/conex.c   |    4 ++--
 drivers/media/video/gspca/spca561.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/media/video/gspca/conex.c~v4l-dvb-gspca-fix-wrong-retry-counting drivers/media/video/gspca/conex.c
--- a/drivers/media/video/gspca/conex.c~v4l-dvb-gspca-fix-wrong-retry-counting
+++ a/drivers/media/video/gspca/conex.c
@@ -731,13 +731,13 @@ static void cx11646_jpeg(struct gspca_de
 	reg_w_val(gspca_dev, 0x0000, 0x00);
 	/* wait for completion */
 	retry = 50;
-	while (retry--) {
+	do {
 		reg_r(gspca_dev, 0x0002, 1);
 							/* 0x07 until 0x00 */
 		if (gspca_dev->usb_buf[0] == 0x00)
 			break;
 		reg_w_val(gspca_dev, 0x0053, 0x00);
-	}
+	} while (--retry);
 	if (retry == 0)
 		PDEBUG(D_ERR, "Damned Errors sending jpeg Table");
 	/* send the qtable now */
diff -puN drivers/media/video/gspca/spca561.c~v4l-dvb-gspca-fix-wrong-retry-counting drivers/media/video/gspca/spca561.c
--- a/drivers/media/video/gspca/spca561.c~v4l-dvb-gspca-fix-wrong-retry-counting
+++ a/drivers/media/video/gspca/spca561.c
@@ -200,11 +200,11 @@ static int i2c_read(struct gspca_dev *gs
 	reg_w_val(gspca_dev->dev, 0x8804, 0x92);
 	reg_w_val(gspca_dev->dev, 0x8801, reg);
 	reg_w_val(gspca_dev->dev, 0x8802, (mode | 0x01));
-	while (retry--) {
+	do {
 		reg_r(gspca_dev, 0x8803, 1);
 		if (!gspca_dev->usb_buf)
 			break;
-	}
+	} while (--retry);
 	if (retry == 0)
 		return -1;
 	reg_r(gspca_dev, 0x8800, 1);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
res_counter-fix-off-by-one-bug-in-setting-limit.patch
linux-next.patch
v4l-dvb-gspca-fix-wrong-retry-counting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

