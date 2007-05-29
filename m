From: akpm@linux-foundation.org
Subject: + fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch added to -mm tree
Date: Tue, 29 May 2007 15:52:44 -0700
Message-ID: <200705292252.l4TMqi9U013684@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbXE2Wws (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 18:52:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: Allow fbcon to use the primary display driver fix
has been added to the -mm tree.  Its filename is
     fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: Allow fbcon to use the primary display driver fix
From: "Antonino A. Daplas" <adaplas@gmail.com>

unbind_con_driver() should be EXPORT_SYBOL.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/char/vt.c~fbcon-allow-fbcon-to-use-the-primary-display-driver-fix drivers/char/vt.c
--- a/drivers/char/vt.c~fbcon-allow-fbcon-to-use-the-primary-display-driver-fix
+++ a/drivers/char/vt.c
@@ -2962,6 +2962,7 @@ err:
 	module_put(owner);
 	return retval;
 };
+EXPORT_SYMBOL(bind_con_driver);
 
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int last)
_

Patches currently in -mm which might be from adaplas@gmail.com are

skeletonfb-fix-of-xxxfb_setup-ifdef.patch
vt8623fb-arkfb-null-pointer-dereference-fix.patch
cfag12864bfb-use-sys_-instead-of-cfb_-framebuffer-accessors.patch
fbdev-move-declaration-of-fb_class-to-linux-fbh.patch
fbcon-smart-blitter-usage-for-scrolling.patch
nvidiafb-adjust-flags-to-take-advantage-of-new-scroll-method.patch
fbcon-cursor-blink-control.patch
fbcon-use-struct-device-instead-of-struct-class_device.patch
fbdev-move-arch-specific-bits-to-their-respective.patch
fbdev-detect-primary-display-device.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver-fix.patch
