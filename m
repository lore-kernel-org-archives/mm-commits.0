From: akpm@linux-foundation.org
Subject: - drivers-video-s1d13xxxfbc-as-module-with-dbg.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:44 -0800
Message-ID: <200711152108.lAFL8iHc015384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761698AbXKOVRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: utx@penguin.cz, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/s1d13xxxfb.c: fix build as module with dbg
has been removed from the -mm tree.  Its filename was
     drivers-video-s1d13xxxfbc-as-module-with-dbg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/s1d13xxxfb.c: fix build as module with dbg
From: Stanislav Brabec <utx@penguin.cz>

Attached patch fixes two compilation problems of s1d13xxxfb.c:

- Fixes outdated dbg() message to fix compilation error with debugging enabled.

- Do not read kernel command line options when compiled as module.

Signed-off-by: Stanislav Brabec <utx@penguin.cz>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/s1d13xxxfb.c~drivers-video-s1d13xxxfbc-as-module-with-dbg drivers/video/s1d13xxxfb.c
--- a/drivers/video/s1d13xxxfb.c~drivers-video-s1d13xxxfbc-as-module-with-dbg
+++ a/drivers/video/s1d13xxxfb.c
@@ -540,7 +540,7 @@ s1d13xxxfb_probe(struct platform_device 
 	int ret = 0;
 	u8 revision;
 
-	dbg("probe called: device is %p\n", dev);
+	dbg("probe called: device is %p\n", pdev);
 
 	printk(KERN_INFO "Epson S1D13XXX FB Driver\n");
 
@@ -753,8 +753,11 @@ static struct platform_driver s1d13xxxfb
 static int __init
 s1d13xxxfb_init(void)
 {
+
+#ifndef MODULE
 	if (fb_get_options("s1d13xxxfb", NULL))
 		return -ENODEV;
+#endif
 
 	return platform_driver_register(&s1d13xxxfb_driver);
 }
_

Patches currently in -mm which might be from utx@penguin.cz are

origin.patch
git-alsa.patch
