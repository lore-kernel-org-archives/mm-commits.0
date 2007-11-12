From: akpm@linux-foundation.org
Subject: + drivers-video-s1d13xxxfbc-as-module-with-dbg.patch added to -mm tree
Date: Mon, 12 Nov 2007 14:14:27 -0800
Message-ID: <200711122214.lACMERtH011519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbXKLWOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 17:14:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: utx@penguin.cz, adaplas@pol.net


The patch titled
     drivers/video/s1d13xxxfb.c: fix build as module with dbg
has been added to the -mm tree.  Its filename is
     drivers-video-s1d13xxxfbc-as-module-with-dbg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-video-s1d13xxxfbc-as-module-with-dbg.patch
