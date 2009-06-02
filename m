From: akpm@linux-foundation.org
Subject: + fbdev-use-framebuffer_release-for-freeing-fb_info-structures.patch added to -mm tree
Date: Mon, 01 Jun 2009 20:30:07 -0700
Message-ID: <200906020330.n523U7ms026777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbZFBDaI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 23:30:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     fbdev: use framebuffer_release() for freeing fb_info structures
has been added to the -mm tree.  Its filename is
     fbdev-use-framebuffer_release-for-freeing-fb_info-structures.patch

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
Subject: fbdev: use framebuffer_release() for freeing fb_info structures
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use the framebuffer_release() for freeing fb_info structures allocated
with framebuffer_alloc().

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/offb.c         |    2 +-
 drivers/video/pm2fb.c        |    2 +-
 drivers/video/sis/sis_main.c |    4 ++--
 drivers/video/stifb.c        |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/offb.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures drivers/video/offb.c
--- a/drivers/video/offb.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures
+++ a/drivers/video/offb.c
@@ -493,7 +493,7 @@ static void __init offb_init_fb(const ch
 		iounmap(par->cmap_adr);
 		par->cmap_adr = NULL;
 		iounmap(info->screen_base);
-		kfree(info);
+		framebuffer_release(info);
 		release_mem_region(res_start, res_size);
 		return;
 	}
diff -puN drivers/video/pm2fb.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures
+++ a/drivers/video/pm2fb.c
@@ -1748,7 +1748,7 @@ static void __devexit pm2fb_remove(struc
 	pci_set_drvdata(pdev, NULL);
 	fb_dealloc_cmap(&info->cmap);
 	kfree(info->pixmap.addr);
-	kfree(info);
+	framebuffer_release(info);
 }
 
 static struct pci_device_id pm2fb_id_table[] = {
diff -puN drivers/video/sis/sis_main.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures
+++ a/drivers/video/sis/sis_main.c
@@ -5928,7 +5928,7 @@ sisfb_probe(struct pci_dev *pdev, const 
 		if(pci_enable_device(pdev)) {
 			if(ivideo->nbridge) pci_dev_put(ivideo->nbridge);
 			pci_set_drvdata(pdev, NULL);
-			kfree(sis_fb_info);
+			framebuffer_release(sis_fb_info);
 			return -EIO;
 		}
 	}
@@ -6134,7 +6134,7 @@ error_3:	vfree(ivideo->bios_abase);
 		pci_set_drvdata(pdev, NULL);
 		if(!ivideo->sisvga_enabled)
 			pci_disable_device(pdev);
-		kfree(sis_fb_info);
+		framebuffer_release(sis_fb_info);
 		return ret;
 	}
 
diff -puN drivers/video/stifb.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures drivers/video/stifb.c
--- a/drivers/video/stifb.c~fbdev-use-framebuffer_release-for-freeing-fb_info-structures
+++ a/drivers/video/stifb.c
@@ -1380,7 +1380,7 @@ stifb_cleanup(void)
 				if (info->screen_base)
 					iounmap(info->screen_base);
 		        fb_dealloc_cmap(&info->cmap);
-		        kfree(info); 
+		        framebuffer_release(info);
 		}
 		sti->info = NULL;
 	}
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch
revert-fbdev-uninline-lock_fb_info.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch
fbdev-move-back-to-bkl-solution.patch
linux-next.patch
intelfb-fix-color-map-setting-with-an-lvds-display.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
acornfb-remove-fb_mmap-function.patch
s3c-fb-fix-resource-releasing-on-error-during-probing.patch
fbdev-use-framebuffer_release-for-freeing-fb_info-structures.patch
bw2-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg14-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg3-use-standard-fields-for-framebuffer-physical-address-and-length.patch
cg6-use-standard-fields-for-framebuffer-physical-address-and-length.patch
leo-use-standard-fields-for-framebuffer-physical-address-and-length.patch
p9100-use-standard-fields-for-framebuffer-physical-address-and-length.patch
tcx-use-standard-fields-for-framebuffer-physical-address-and-length.patch

