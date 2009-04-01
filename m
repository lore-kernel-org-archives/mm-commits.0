From: akpm@linux-foundation.org
Subject: [merged] sunxvr500-fix-cmap-memory-leaks.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:31 -0700
Message-ID: <200904011843.n31IhVAs010086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761231AbZDASrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:47:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, davem@davemloft.net, dilinger@debian.org, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     sunxvr500: fix cmap memory leaks
has been removed from the -mm tree.  Its filename was
     sunxvr500-fix-cmap-memory-leaks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

