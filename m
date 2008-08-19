From: akpm@linux-foundation.org
Subject: + pm2fb-free-cmap-memory-on-module-remove.patch added to -mm tree
Date: Tue, 19 Aug 2008 13:41:29 -0700
Message-ID: <200808192041.m7JKfTcS005313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753436AbYHSUlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Aug 2008 16:41:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     pm2fb: free cmap memory on module remove
has been added to the -mm tree.  Its filename is
     pm2fb-free-cmap-memory-on-module-remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
pm2fb-free-cmap-memory-on-module-remove.patch
linux-next.patch
video-framebuffer-add-fuctional-power-management-support-to-blackfin-bf54x-lq043-framebuffer-driver.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch

