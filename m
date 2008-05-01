From: akpm@linux-foundation.org
Subject: - pxafb-preliminary-smart-panel-interface-support-update.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:25 -0700
Message-ID: <200805010925.m419PPtj030199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33495 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754925AbYEAJ0G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.miao@marvell.com, adaplas@pol.net, daniel@caiaq.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pxafb: preliminary smart panel interface support (update)
has been removed from the -mm tree.  Its filename was
     pxafb-preliminary-smart-panel-interface-support-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1776,7 +1776,7 @@ config FB_PXA
 
 config FB_PXA_SMARTPANEL
 	bool "PXA Smartpanel LCD support"
-	default y
+	default n
 	depends on FB_PXA
 
 config FB_PXA_PARAMETERS
diff -puN drivers/video/pxafb.c~pxafb-preliminary-smart-panel-interface-support-update drivers/video/pxafb.c
--- a/drivers/video/pxafb.c~pxafb-preliminary-smart-panel-interface-support-update
+++ a/drivers/video/pxafb.c
@@ -720,7 +720,7 @@ static void setup_smart_timing(struct px
 
 static int pxafb_smart_thread(void *arg)
 {
-	struct pxafb_info *fbi = (struct pxafb_info *) arg;
+	struct pxafb_info *fbi = arg;
 	struct pxafb_mach_info *inf = fbi->dev->platform_data;
 
 	if (!fbi || !inf->smart_update) {
_

Patches currently in -mm which might be from eric.miao@marvell.com are

origin.patch
git-arm.patch
gpio-pca953x-add-support-for-pca9555-i2c-i-o-expander.patch

