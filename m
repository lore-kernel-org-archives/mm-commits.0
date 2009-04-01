From: akpm@linux-foundation.org
Subject: [merged] tgafb-fix-cmap-memory-leak.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:33 -0700
Message-ID: <200904011843.n31IhXfp010089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759525AbZDATWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     tgafb: fix cmap memory leak
has been removed from the -mm tree.  Its filename was
     tgafb-fix-cmap-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

