From: akpm@linux-foundation.org
Subject: - v4l-link-tuner-before-saa7134.patch removed from -mm tree
Date: Tue, 02 Sep 2008 13:41:08 -0700
Message-ID: <200809022041.m82Kf8Ae011611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbYIBUly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 16:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: link tuner before saa7134
has been removed from the -mm tree.  Its filename was
     v4l-link-tuner-before-saa7134.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l: link tuner before saa7134
From: Simon Arlott <simon@fire.lp0.eu>

If saa7134_init is run before v4l2_i2c_drv_init (tuner), then
saa7134_board_init2 will try to set the tuner type for devices that don't
exist yet.  This moves tuner to before all of the device-specific drivers
so that it's loaded early enough on boot.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/video/Makefile~v4l-link-tuner-before-saa7134 drivers/media/video/Makefile
--- a/drivers/media/video/Makefile~v4l-link-tuner-before-saa7134
+++ a/drivers/media/video/Makefile
@@ -20,6 +20,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
   obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
 endif
 
+obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
@@ -83,8 +85,6 @@ obj-$(CONFIG_VIDEO_MXB) += mxb.o
 obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
 obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
