From: akpm@linux-foundation.org
Subject: + s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch added to -mm tree
Date: Fri, 09 Jul 2010 16:09:03 -0700
Message-ID: <201007092309.o69N93ax030974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab0GIXNg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jul 2010 19:13:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: p.osciak@samsung.com, ben-linux@fluff.org, inki.dae@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com


The patch titled
     s3c-fb: separate S5PC100 and S5PV210 framebuffer driver data structures
has been added to the -mm tree.  Its filename is
     s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch

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
Subject: s3c-fb: separate S5PC100 and S5PV210 framebuffer driver data structures
From: Pawel Osciak <p.osciak@samsung.com>

S5PC100 and S5PV210 framebuffer devices differ slightly in terms of
available registers and their driver data structures have to be separate. 
Those differences include dissimilar ways to control shadow register
updates.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s3c-fb.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff -puN drivers/video/s3c-fb.c~s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures drivers/video/s3c-fb.c
--- a/drivers/video/s3c-fb.c~s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures
+++ a/drivers/video/s3c-fb.c
@@ -1251,7 +1251,35 @@ static struct s3c_fb_driverdata s3c_fb_d
 	.win[4]	= &s3c_fb_data_64xx_wins[4],
 };
 
-static struct s3c_fb_driverdata s3c_fb_data_s5p __devinitdata = {
+static struct s3c_fb_driverdata s3c_fb_data_s5pc100 __devinitdata = {
+	.variant = {
+		.nr_windows	= 5,
+		.vidtcon	= VIDTCON0,
+		.wincon		= WINCON(0),
+		.winmap		= WINxMAP(0),
+		.keycon		= WKEYCON,
+		.osd		= VIDOSD_BASE,
+		.osd_stride	= 16,
+		.buf_start	= VIDW_BUF_START(0),
+		.buf_size	= VIDW_BUF_SIZE(0),
+		.buf_end	= VIDW_BUF_END(0),
+
+		.palette = {
+			[0] = 0x2400,
+			[1] = 0x2800,
+			[2] = 0x2c00,
+			[3] = 0x3000,
+			[4] = 0x3400,
+		},
+	},
+	.win[0]	= &s3c_fb_data_64xx_wins[0],
+	.win[1]	= &s3c_fb_data_64xx_wins[1],
+	.win[2]	= &s3c_fb_data_64xx_wins[2],
+	.win[3]	= &s3c_fb_data_64xx_wins[3],
+	.win[4]	= &s3c_fb_data_64xx_wins[4],
+};
+
+static struct s3c_fb_driverdata s3c_fb_data_s5pv210 __devinitdata = {
 	.variant = {
 		.nr_windows	= 5,
 		.vidtcon	= VIDTCON0,
@@ -1319,8 +1347,11 @@ static struct platform_device_id s3c_fb_
 		.name		= "s3c-fb",
 		.driver_data	= (unsigned long)&s3c_fb_data_64xx,
 	}, {
-		.name		= "s5p-fb",
-		.driver_data	= (unsigned long)&s3c_fb_data_s5p,
+		.name		= "s5pc100-fb",
+		.driver_data	= (unsigned long)&s3c_fb_data_s5pc100,
+	}, {
+		.name		= "s5pv210-fb",
+		.driver_data	= (unsigned long)&s3c_fb_data_s5pv210,
 	}, {
 		.name		= "s3c2443-fb",
 		.driver_data	= (unsigned long)&s3c_fb_data_s3c2443,
_

Patches currently in -mm which might be from p.osciak@samsung.com are

linux-next.patch
s3c-fb-change-to-depending-on-config_s3c_fb_dev.patch
s3c-fb-add-default-window-feature.patch
s3c-fb-fix-distortedness-situation-for-the-mode-more-then-24bpp.patch
s3c-fb-only-init-window-colour-key-controls-for-windows-with-blending.patch
s3c-fb-initial-move-to-unifying-the-header-files.patch
s3c-fb-udpate-to-support-s3c2416-s3c2443-style-hardware.patch
s3c-fb-integrate-palette-setup-code-into-main-driver.patch
s3c-fb-fix-various-null-references-on-framebuffer-memory-alloc-failure.patch
s3c-fb-correct-framesel1-bitfield-defines-for-vidintcon0-register.patch
s3c-fb-separate-s5pc100-and-s5pv210-framebuffer-driver-data-structures.patch
s3c-fb-add-device-name-initialization.patch
s3c-fb-add-support-for-display-panning.patch
s3c-fb-add-wait-for-vsync-ioctl.patch
s3c-fb-window-3-of-64xx-does-not-have-an-osd_d-register.patch
s3c-fb-add-shadowcon-shadow-register-locking-support-for-s5pv210.patch
s3c-fb-correct-window-osd-size-and-alpha-register-handling.patch
s3c-fb-protect-window-specific-registers-during-updates.patch
s3c-fb-add-support-for-dma-channel-control-on-s5pv210.patch

