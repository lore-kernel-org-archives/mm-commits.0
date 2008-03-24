From: akpm@linux-foundation.org
Subject: + nv-drop-useless-module-ifdefs.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:10:34 -0700
Message-ID: <200803242210.m2OMAYlm027901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbYCXWKj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:10:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, adaplas@gmail.com


The patch titled
     fbdev: nv: drop useless MODULE ifdefs
has been added to the -mm tree.  Its filename is
     nv-drop-useless-module-ifdefs.patch

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
Subject: fbdev: nv: drop useless MODULE ifdefs
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/nvidia/nvidia.c |    3 ---
 drivers/video/riva/fbdev.c    |    2 --
 2 files changed, 5 deletions(-)

diff -puN drivers/video/nvidia/nvidia.c~nv-drop-useless-module-ifdefs drivers/video/nvidia/nvidia.c
--- a/drivers/video/nvidia/nvidia.c~nv-drop-useless-module-ifdefs
+++ a/drivers/video/nvidia/nvidia.c
@@ -1559,7 +1559,6 @@ static int __devinit nvidiafb_init(void)
 
 module_init(nvidiafb_init);
 
-#ifdef MODULE
 static void __exit nvidiafb_exit(void)
 {
 	pci_unregister_driver(&nvidiafb_driver);
@@ -1615,5 +1614,3 @@ MODULE_PARM_DESC(nomtrr, "Disables MTRR 
 MODULE_AUTHOR("Antonino Daplas");
 MODULE_DESCRIPTION("Framebuffer driver for nVidia graphics chipset");
 MODULE_LICENSE("GPL");
-#endif				/* MODULE */
-
diff -puN drivers/video/riva/fbdev.c~nv-drop-useless-module-ifdefs drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~nv-drop-useless-module-ifdefs
+++ a/drivers/video/riva/fbdev.c
@@ -2213,14 +2213,12 @@ static int __devinit rivafb_init(void)
 
 module_init(rivafb_init);
 
-#ifdef MODULE
 static void __exit rivafb_exit(void)
 {
 	pci_unregister_driver(&rivafb_driver);
 }
 
 module_exit(rivafb_exit);
-#endif /* MODULE */
 
 module_param(noaccel, bool, 0);
 MODULE_PARM_DESC(noaccel, "bool: disable acceleration");
_

Patches currently in -mm which might be from adobriyan@gmail.com are

tags-add-menuconfig-symbols-as-well.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
likely_prof-changed-to-use-proc_create.patch

