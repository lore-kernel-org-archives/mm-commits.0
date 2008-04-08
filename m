From: akpm@linux-foundation.org
Subject: + pxafb-preliminary-smart-panel-interface-support-update.patch added to -mm tree
Date: Tue, 08 Apr 2008 01:43:35 -0700
Message-ID: <200804080843.m388hZhn016897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863AbYDHInz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 04:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.miao@marvell.com, adaplas@pol.net, daniel@caiaq.de, rmk@arm.linux.org.uk


The patch titled
     pxafb: preliminary smart panel interface support (update)
has been added to the -mm tree.  Its filename is
     pxafb-preliminary-smart-panel-interface-support-update.patch

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
Subject: pxafb: preliminary smart panel interface support (update)
From: Eric Miao <eric.miao@marvell.com>

FB_PXA_SMARTPANEL defaults to "n" and removed the cast to void *.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Eric Miao <eric.miao@marvell.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 drivers/video/pxafb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/Kconfig~pxafb-preliminary-smart-panel-interface-support-update drivers/video/Kconfig
--- a/drivers/video/Kconfig~pxafb-preliminary-smart-panel-interface-support-update
+++ a/drivers/video/Kconfig
@@ -1769,7 +1769,7 @@ config FB_PXA
 
 config FB_PXA_SMARTPANEL
 	bool "PXA Smartpanel LCD support"
-	default y
+	default n
 	depends on FB_PXA
 
 config FB_PXA_PARAMETERS
diff -puN drivers/video/pxafb.c~pxafb-preliminary-smart-panel-interface-support-update drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-preliminary-smart-panel-interface-support-update
+++ a/drivers/video/pxafb.c
@@ -711,7 +711,7 @@ static void setup_smart_timing(struct px
 
 static int pxafb_smart_thread(void *arg)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *) arg;
+	struct pxafb_info *fbi = arg;
 	struct pxafb_mach_info *inf = fbi->dev->platform_data;
 
 	if (!fbi || !inf->smart_update) {
_

Patches currently in -mm which might be from eric.miao@marvell.com are

git-arm.patch
pxafb-un-nest-pxafb_parse_options-to-cleanup-the-coding-style-issue.patch
pxafb-fix-various-coding-style-issues-for-pxafb.patch
pxafb-purge-unnecessary-pr_debug-and-comments-from-pxafb.patch
pxafb-sanitize-the-usage-of-ifdef-processing-pxafb-parameters.patch
pxafb-convert-fb-driver-to-use-ioremap-and-__raw_readl-writel.patch
pxafb-introduce-struct-pxafb_dma_buff-for-palette-and-dma-descriptors.patch
pxafb-introduce-register-independent-lcd-connection-type-for-pxafb.patch
pxafb-make-lubbock-mainstone-zylonite-littleton-to-use-new-lcd-connection-type.patch
pxafb-introduce-lcd_readwritel-to-wrap-the-__raw_readwritel.patch
pxafb-use-completion-for-lcd-disable-wait-code.patch
pxafb-move-parallel-lcd-timing-setup-into-dedicate-function.patch
pxafb-preliminary-smart-panel-interface-support.patch
pxafb-preliminary-smart-panel-interface-support-update.patch
pxafb-preliminary-smart-panel-interface-support-fix.patch

