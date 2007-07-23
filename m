From: akpm@linux-foundation.org
Subject: - ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:41 -0700
Message-ID: <200707230934.l6N9Yfwx016414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759625AbXGWJpu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3fb: Enable VT_HW_CONSOLE_BINDING for proper kexec
has been removed from the -mm tree.  Its filename was
     ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ps3fb: Enable VT_HW_CONSOLE_BINDING for proper kexec
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3fb: VT_HW_CONSOLE_BINDING must be enabled to make console unbinding work,
which is needed to give up all hypervisor resources before reboot or kexec.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/Kconfig~ps3fb-enable-vt_hw_console_binding-for-proper-kexec drivers/video/Kconfig
--- a/drivers/video/Kconfig~ps3fb-enable-vt_hw_console_binding-for-proper-kexec
+++ a/drivers/video/Kconfig
@@ -1796,6 +1796,7 @@ config FB_PS3
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_SYS_FOPS
+	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
 	---help---
 	  Include support for the virtual frame buffer in the PS3 platform.
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are
