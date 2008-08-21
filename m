From: akpm@linux-foundation.org
Subject: - pm2fb-free-cmap-memory-on-module-remove.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:49:31 -0700
Message-ID: <200808210349.m7L3nVrm015644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbYHUDtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     pm2fb: free cmap memory on module remove
has been removed from the -mm tree.  Its filename was
     pm2fb-free-cmap-memory-on-module-remove.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pm2fb: free cmap memory on module remove
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Release cmap memory allocated in the probe function.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/pm2fb.c~pm2fb-free-cmap-memory-on-module-remove drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~pm2fb-free-cmap-memory-on-module-remove
+++ a/drivers/video/pm2fb.c
@@ -1746,6 +1746,7 @@ static void __devexit pm2fb_remove(struc
 	release_mem_region(fix->mmio_start, fix->mmio_len);
 
 	pci_set_drvdata(pdev, NULL);
+	fb_dealloc_cmap(&info->cmap);
 	kfree(info->pixmap.addr);
 	kfree(info);
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

linux-next.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch

