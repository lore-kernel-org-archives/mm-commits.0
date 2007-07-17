From: akpm@linux-foundation.org
Subject: + fbdev-make-fb_append_extra_logo-depend-on-fb=y.patch added to -mm tree
Date: Tue, 17 Jul 2007 16:52:05 -0700
Message-ID: <200707172352.l6HNq5gP013956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756725AbXGQXwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:52:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, adaplas@pol.net, geert@linux-m68k.org, viro@zeniv.linux.org.uk


The patch titled
     fbdev: make fb_append_extra_logo() depend on fb=y
has been added to the -mm tree.  Its filename is
     fbdev-make-fb_append_extra_logo-depend-on-fb=y.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: make fb_append_extra_logo() depend on fb=y
From: Arnd Bergmann <arnd@arndb.de>

We can't show the extra logo from boot code if FB is built as a module. 
Make the FB_LOGO_EXTRA depend on FB=y.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/logo/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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
fbdev-make-fb_append_extra_logo-depend-on-fb=y.patch
