From: akpm@linux-foundation.org
Subject: [merged] fb-put-framebuffer-drivers-back-under-the-frame-buffer-devices-menu.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:07 -0800
Message-ID: <200911131927.nADJR7cL029840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213AbZKMT1F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:27:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, mm-commits@vger.kernel.org


The patch titled
     fb: put framebuffer drivers back under the "frame buffer devices" menu
has been removed from the -mm tree.  Its filename was
     fb-put-framebuffer-drivers-back-under-the-frame-buffer-devices-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: put framebuffer drivers back under the "frame buffer devices" menu
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

The config FB_PRE_INIT_FB entry in drivers/video/Kconfig pushes all entries
below it out of the menuconfig selection. Fix this.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/Kconfig~fb-put-framebuffer-drivers-back-under-the-frame-buffer-devices-menu drivers/video/Kconfig
--- a/drivers/video/Kconfig~fb-put-framebuffer-drivers-back-under-the-frame-buffer-devices-menu
+++ a/drivers/video/Kconfig
@@ -2121,7 +2121,7 @@ config FB_EP93XX
 
 config FB_PRE_INIT_FB
 	bool "Don't reinitialize, use bootloader's GDC/Display configuration"
-	depends on FB_MB862XX_LIME
+	depends on FB && FB_MB862XX_LIME
 	---help---
 	  Select this option if display contents should be inherited as set by
 	  the bootloader.
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch

