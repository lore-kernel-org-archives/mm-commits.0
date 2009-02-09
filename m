From: akpm@linux-foundation.org
Subject: + sunxvr500-fix-cmap-memory-leaks.patch added to -mm tree
Date: Mon, 09 Feb 2009 15:47:31 -0800
Message-ID: <200902092347.n19NlVTL006581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbZBIXsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 18:48:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, davem@davemloft.net, dilinger@debian.org, krzysztof.h1@poczta.fm


The patch titled
     sunxvr500: fix cmap memory leaks
has been added to the -mm tree.  Its filename is
     sunxvr500-fix-cmap-memory-leaks.patch

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
Subject: sunxvr500: fix cmap memory leaks
From: Andres Salomon <dilinger@queued.net>

 - fix cmap leak in removal path
 - fix cmap leak when register_framebuffer fails

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sunxvr500.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/video/sunxvr500.c~sunxvr500-fix-cmap-memory-leaks drivers/video/sunxvr500.c
--- a/drivers/video/sunxvr500.c~sunxvr500-fix-cmap-memory-leaks
+++ a/drivers/video/sunxvr500.c
@@ -349,11 +349,14 @@ static int __devinit e3d_pci_register(st
 	if (err < 0) {
 		printk(KERN_ERR "e3d: Could not register framebuffer %s\n",
 		       pci_name(pdev));
-		goto err_unmap_fb;
+		goto err_free_cmap;
 	}
 
 	return 0;
 
+err_free_cmap:
+	fb_dealloc_cmap(&info->cmap);
+
 err_unmap_fb:
 	iounmap(ep->fb_base);
 
@@ -389,6 +392,7 @@ static void __devexit e3d_pci_unregister
 	pci_release_region(pdev, 0);
 	pci_release_region(pdev, 1);
 
+	fb_dealloc_cmap(&info->cmap);
         framebuffer_release(info);
 
 	pci_disable_device(pdev);
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

