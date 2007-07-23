From: akpm@linux-foundation.org
Subject: + fix-au1100-fb-dependencies-add-helptext.patch added to -mm tree
Date: Mon, 23 Jul 2007 14:17:26 -0700
Message-ID: <200707232117.l6NLHQAw012231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50711 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbXGWVSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 17:18:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, adaplas@pol.net


The patch titled
     Fix Au1100 fb dependencies, add helptext
has been added to the -mm tree.  Its filename is
     fix-au1100-fb-dependencies-add-helptext.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix Au1100 fb dependencies, add helptext
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~fix-au1100-fb-dependencies-add-helptext drivers/video/Kconfig
--- a/drivers/video/Kconfig~fix-au1100-fb-dependencies-add-helptext
+++ a/drivers/video/Kconfig
@@ -1570,7 +1570,14 @@ config FB_PM3
 
 config FB_AU1100
 	bool "Au1100 LCD Driver"
-	depends on (FB = y) && EXPERIMENTAL && PCI && MIPS && MIPS_PB1100=y
+	depends on (FB = y) && MIPS && SOC_AU1100
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	help
+	  This is the framebuffer driver for the AMD Au1100 SOC.  It can drive
+	  various panels and CRTs by passing in kernel cmd line option
+	  au1100fb:panel=<name>.
 
 config FB_AU1200
 	bool "Au1200 LCD Driver"
_

Patches currently in -mm which might be from ralf@linux-mips.org are

fix-au1100-fb-dependencies-add-helptext.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial_txx9-cleanup-includes.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
whitelist-references-from-__dbe_table-to-init.patch
bpqether-fix-rcu-usage.patch
serial-fix-section-mismatch-vr41xx_siu.patch
serial-fix-vr41xx_siu-interface-select.patch
serial-fix-vr41xx_siu-serial-console-support.patch
remove-tx3912fb.patch
sb1250-duart-__maybe_unused-etc-fixes.patch
