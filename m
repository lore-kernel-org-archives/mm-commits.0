From: akpm@linux-foundation.org
Subject: - au1100fb-fix-modpost-warnings.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:19 -0700
Message-ID: <200710190340.l9J3eJVX012700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965706AbXJSDlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     au1100fb: fix modpost warnings
has been removed from the -mm tree.  Its filename was
     au1100fb-fix-modpost-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: au1100fb: fix modpost warnings
From: Ralf Baechle <ralf@linux-mips.org>

  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x170be8): Section mismatch: reference to .init.data:au1100fb_fix (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170dc4): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170dd0): Section mismatch: reference to .init.data:au1100fb_fix (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170de0): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170e70): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/au1100fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/au1100fb.c~au1100fb-fix-modpost-warnings drivers/video/au1100fb.c
--- a/drivers/video/au1100fb.c~au1100fb-fix-modpost-warnings
+++ a/drivers/video/au1100fb.c
@@ -457,7 +457,7 @@ static struct fb_ops au1100fb_ops =
 
 /* AU1100 LCD controller device driver */
 
-int au1100fb_drv_probe(struct device *dev)
+static int __init au1100fb_drv_probe(struct device *dev)
 {
 	struct au1100fb_device *fbdev = NULL;
 	struct resource *regs_res;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
define-global-bit-macro.patch
