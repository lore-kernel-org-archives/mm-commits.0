From: akpm@linux-foundation.org
Subject: + v4l-link-tuner-before-saa7134.patch added to -mm tree
Date: Tue, 22 Jul 2008 02:06:49 -0700
Message-ID: <200807220906.m6M96nV6020088@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752437AbYGVJHa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 05:07:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@fire.lp0.eu, mchehab@infradead.org


The patch titled
     v4l: link tuner before saa7134
has been added to the -mm tree.  Its filename is
     v4l-link-tuner-before-saa7134.patch

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
@@ -18,6 +18,8 @@ ifeq ($(CONFIG_VIDEO_V4L1_COMPAT),y)
   obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
 endif
 
+obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+
 obj-$(CONFIG_VIDEO_BT848) += bt8xx/
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
@@ -84,8 +86,6 @@ obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hex
 obj-$(CONFIG_VIDEO_DPC) += dpc7146.o
 obj-$(CONFIG_TUNER_3036) += tuner-3036.o
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
