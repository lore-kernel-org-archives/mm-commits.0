From: akpm@linux-foundation.org
Subject: - fbdev-make-fb_append_extra_logo-depend-on-fb=y.patch removed from -mm tree
Date: Wed, 18 Jul 2007 11:51:57 -0700
Message-ID: <200707181851.l6IIpvnv023624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934613AbXGRSxI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 14:53:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fbdev: make fb_append_extra_logo() depend on fb=y
has been removed from the -mm tree.  Its filename was
     fbdev-make-fb_append_extra_logo-depend-on-fb=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbdev: make fb_append_extra_logo() depend on fb=y
From: Arnd Bergmann <arnd@arndb.de>

We can't show the extra logo from boot code if FB is built as a module. 
Make the FB_LOGO_EXTRA depend on FB=y.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/logo/Kconfig~fbdev-make-fb_append_extra_logo-depend-on-fb=y drivers/video/logo/Kconfig
--- a/drivers/video/logo/Kconfig~fbdev-make-fb_append_extra_logo-depend-on-fb=y
+++ a/drivers/video/logo/Kconfig
@@ -12,7 +12,7 @@ if LOGO
 
 config FB_LOGO_EXTRA
 	bool
-	depends on FB
+	depends on FB=y
 	default y if SPU_BASE
 
 config LOGO_LINUX_MONO
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
