From: akpm@linux-foundation.org
Subject: + nv-drop-useless-config_pci-checks.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:10:37 -0700
Message-ID: <200803242210.m2OMAbeB027904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752804AbYCXWKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, adaplas@gmail.com


The patch titled
     fbdev: nv: drop useless CONFIG_PCI checks
has been added to the -mm tree.  Its filename is
     nv-drop-useless-config_pci-checks.patch

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
Subject: fbdev: nv: drop useless CONFIG_PCI checks
From: Alexey Dobriyan <adobriyan@gmail.com>

Both FB_RIVA and FB_NVIDIA depends on PCI, so CONFIG_PCI always defined for
them.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Antonino A. Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/fbdev.c     |    4 ----
 drivers/video/riva/nv_driver.c |    5 -----
 2 files changed, 9 deletions(-)

diff -puN drivers/video/riva/fbdev.c~nv-drop-useless-config_pci-checks drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~nv-drop-useless-config_pci-checks
+++ a/drivers/video/riva/fbdev.c
@@ -56,10 +56,6 @@
 #include "rivafb.h"
 #include "nvreg.h"
 
-#ifndef CONFIG_PCI		/* sanity check */
-#error This driver requires PCI support.
-#endif
-
 /* version number of this driver */
 #define RIVAFB_VERSION "0.9.5b"
 
diff -puN drivers/video/riva/nv_driver.c~nv-drop-useless-config_pci-checks drivers/video/riva/nv_driver.c
--- a/drivers/video/riva/nv_driver.c~nv-drop-useless-config_pci-checks
+++ a/drivers/video/riva/nv_driver.c
@@ -41,11 +41,6 @@
 #include "rivafb.h"
 #include "nvreg.h"
 
-
-#ifndef CONFIG_PCI		/* sanity check */
-#error This driver requires PCI support.
-#endif
