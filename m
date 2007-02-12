From: akpm@linux-foundation.org
Subject: - tgafb-fix-the-mode-register-setting.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:24 -0800
Message-ID: <200702122249.l1CMnOtk014105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45938 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030431AbXBLWwx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:52:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tgafb: fix the mode register setting
has been removed from the -mm tree.  Its filename was
     tgafb-fix-the-mode-register-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb: fix the mode register setting
From: "Maciej W. Rozycki" <macro@linux-mips.org>

There is no need to set the GE bit (Win32 compatibility) in the mode register;
it shall get cleared with the next subsequent update to the register anyway.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
