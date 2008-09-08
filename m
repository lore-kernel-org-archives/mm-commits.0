From: akpm@linux-foundation.org
Subject: - v4l-dvb-gspca-fix-wrong-retry-counting.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:12 -0700
Message-ID: <200809081907.m88J7CPa005535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078AbYIHTHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l/dvb: gspca: fix wrong retry counting
has been removed from the -mm tree.  Its filename was
     v4l-dvb-gspca-fix-wrong-retry-counting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -223,11 +223,11 @@ static int i2c_read(struct gspca_dev *gs
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
linux-next.patch
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

