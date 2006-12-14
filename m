From: akpm@osdl.org
Subject: + tgafb-fix-the-mode-register-setting.patch added to -mm tree
Date: Wed, 13 Dec 2006 16:16:11 -0800
Message-ID: <200612140016.kBE0GBiF025772@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbWLNAQc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 19:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     tgafb: fix the mode register setting
has been added to the -mm tree.  Its filename is
     tgafb-fix-the-mode-register-setting.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tgafb: fix the mode register setting
From: "Maciej W. Rozycki" <macro@linux-mips.org>

There is no need to set the GE bit (Win32 compatibility) in the mode register;
it shall get cleared with the next subsequent update to the register anyway.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tgafb.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-fix-the-mode-register-setting drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-fix-the-mode-register-setting
+++ a/drivers/video/tgafb.c
@@ -143,10 +143,10 @@ tgafb_set_par(struct fb_info *info)
 		0x00000303
 	};
 	static unsigned int const mode_presets[4] = {
-		0x00002000,
-		0x00002300,
+		0x00000000,
+		0x00000300,
 		0xffffffff,
-		0x00002300
+		0x00000300
 	};
 	static unsigned int const base_addr_presets[4] = {
 		0x00000000,
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch

