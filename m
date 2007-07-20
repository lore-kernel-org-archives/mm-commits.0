From: akpm@linux-foundation.org
Subject: + ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch added to -mm tree
Date: Fri, 20 Jul 2007 11:12:37 -0700
Message-ID: <200707201812.l6KICbaR009476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761134AbXGTSOB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 14:14:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, geoffrey.levand@am.sony.com, paulus@samba.org


The patch titled
     ps3fb: Enable VT_HW_CONSOLE_BINDING for proper kexec
has been added to the -mm tree.  Its filename is
     ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

diff -puN drivers/video/Kconfig~ps3fb-enable-vt_hw_console_binding-for-proper-kexec drivers/video/Kconfig
--- a/drivers/video/Kconfig~ps3fb-enable-vt_hw_console_binding-for-proper-kexec
+++ a/drivers/video/Kconfig
@@ -1791,6 +1791,7 @@ config FB_PS3
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
 	select FB_SYS_FOPS
+	select VT_HW_CONSOLE_BINDING if FRAMEBUFFER_CONSOLE
 	---help---
 	  Include support for the virtual frame buffer in the PS3 platform.
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-disk-storage-driver.patch
ps3-disk-storage-driver-use-correct-bio-vector-size.patch
ps3-disk-storage-driver-updates-after-final-review.patch
ps3-bd-dvd-cd-rom-storage-driver.patch
ps3-bd-dvd-cd-rom-storage-driver-updates-after-final-review.patch
ps3-flash-rom-storage-driver.patch
ps3-flash-rom-storage-driver-updates-after-final-review.patch
ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch
ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib.patch
ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch
