From: akpm@linux-foundation.org
Subject: + tgafb-fix-cmap-memory-leak.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:48:02 -0800
Message-ID: <200902092348.n19Nm2I5007261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52523 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752400AbZBIXsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:48:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@poczta.fm


The patch titled
     tgafb: fix cmap memory leak
has been added to the -mm tree.  Its filename is
     tgafb-fix-cmap-memory-leak.patch

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
Subject: tgafb: fix cmap memory leak
From: Andres Salomon <dilinger@queued.net>

Fix cmap leak when register_framebuffer fails.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/tgafb.c~tgafb-fix-cmap-memory-leak drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-fix-cmap-memory-leak
+++ a/drivers/video/tgafb.c
@@ -1663,7 +1663,7 @@ tgafb_register(struct device *dev)
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR "tgafb: Could not register framebuffer\n");
 		ret = -EINVAL;
-		goto err1;
+		goto err2;
 	}
 
 	if (tga_bus_pci) {
@@ -1682,6 +1682,8 @@ tgafb_register(struct device *dev)
 
 	return 0;
 
+ err2:
+	fb_dealloc_cmap(&info->cmap);
  err1:
 	if (mem_base)
 		iounmap(mem_base);
_

Patches currently in -mm which might be from dilinger@queued.net are

gxfb-properly-alloc-cmap-and-plug-cmap-leak.patch
gx1fb-properly-alloc-cmap-and-plug-cmap-leak.patch
jffs2-force-the-jffs2-gc-daemon-to-behave-a-bit-better.patch
drivers-video-sgivwfbc-fix-memory-leaks-in-removal-path.patch
tdfxfb-fix-memory-leaks-in-removal-path.patch
tridentfb-fix-memory-leaks-in-removal-path.patch
vfb-fix-memory-leaks-in-removal-path.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sstfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
stifb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
valkyriefb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sunxvr500-fix-cmap-memory-leaks.patch
tgafb-fix-cmap-memory-leak.patch

