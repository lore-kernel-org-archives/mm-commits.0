From: akpm@linux-foundation.org
Subject: [merged] tridentfb-fix-memory-leaks-in-removal-path.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:16 -0700
Message-ID: <200904011843.n31IhGMY009984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759167AbZDATVs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:21:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix memory leaks in removal path
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-memory-leaks-in-removal-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: fix memory leaks in removal path
From: Andres Salomon <dilinger@queued.net>

We were leaking the cmap memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-memory-leaks-in-removal-path drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-memory-leaks-in-removal-path
+++ a/drivers/video/tridentfb.c
@@ -1563,6 +1563,7 @@ static void __devexit trident_pci_remove
 	release_mem_region(tridentfb_fix.mmio_start, tridentfb_fix.mmio_len);
 	pci_set_drvdata(dev, NULL);
 	kfree(info->pixmap.addr);
+	fb_dealloc_cmap(&info->cmap);
 	framebuffer_release(info);
 }
 
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

