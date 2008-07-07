From: akpm@linux-foundation.org
Subject: - w100fb-do-not-depend-on-sharpsl.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:04:51 -0700
Message-ID: <200807070304.m6734pxd004697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215AbYGGDFA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:05:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: philipp.zabel@gmail.com, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     w100fb: do not depend on SHARPSL
has been removed from the -mm tree.  Its filename was
     w100fb-do-not-depend-on-sharpsl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w100fb: do not depend on SHARPSL
From: Philipp Zabel <philipp.zabel@gmail.com>

Apart from Sharp SL-Cxx series, there are a few other devices that have
ATI Imageon chips, among them HP iPAQ hx4700.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Acked-by: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~w100fb-do-not-depend-on-sharpsl drivers/video/Kconfig
--- a/drivers/video/Kconfig~w100fb-do-not-depend-on-sharpsl
+++ a/drivers/video/Kconfig
@@ -1825,12 +1825,13 @@ config FB_FSL_DIU
 
 config FB_W100
 	tristate "W100 frame buffer support"
-	depends on FB && PXA_SHARPSL
+	depends on FB && ARCH_PXA
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
 	---help---
 	  Frame buffer driver for the w100 as found on the Sharp SL-Cxx series.
+	  It can also drive the w3220 chip found on iPAQ hx4700.
 
 	  This driver is also available as a module ( = code which can be
 	  inserted and removed from the running kernel whenever you want). The
_

Patches currently in -mm which might be from philipp.zabel@gmail.com are

origin.patch
linux-next.patch

