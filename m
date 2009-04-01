From: akpm@linux-foundation.org
Subject: [merged] tdfxfb-fix-memory-leaks-in-removal-path.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:43:14 -0700
Message-ID: <200904011843.n31IhEJw009981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933600AbZDASqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     tdfxfb: fix memory leaks in removal path
has been removed from the -mm tree.  Its filename was
     tdfxfb-fix-memory-leaks-in-removal-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tdfxfb: fix memory leaks in removal path
From: Andres Salomon <dilinger@queued.net>

We were leaking the cmap memory.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tdfxfb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/tdfxfb.c~tdfxfb-fix-memory-leaks-in-removal-path drivers/video/tdfxfb.c
--- a/drivers/video/tdfxfb.c~tdfxfb-fix-memory-leaks-in-removal-path
+++ a/drivers/video/tdfxfb.c
@@ -1393,6 +1393,7 @@ static void __devexit tdfxfb_remove(stru
 	release_mem_region(pci_resource_start(pdev, 0),
 			   pci_resource_len(pdev, 0));
 	pci_set_drvdata(pdev, NULL);
+	fb_dealloc_cmap(&info->cmap);
 	framebuffer_release(info);
 }
 
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support.patch
alsa-cs5535audio-free-olpc-quirks-from-reliance-on-mgeode_lx-cpu-optimization.patch

