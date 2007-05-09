From: akpm@linux-foundation.org
Subject: - epson1355fbc-fix-error-handling-code.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:42 -0700
Message-ID: <200705090300.l4930gum010598@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032885AbXEIDAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stigge@antcom.de, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     epson1355fb.c: fix error handling code
has been removed from the -mm tree.  Its filename was
     epson1355fbc-fix-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: epson1355fb.c: fix error handling code
From: Roland Stigge <stigge@antcom.de>

Fix error handling code

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/epson1355fb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/epson1355fb.c~epson1355fbc-fix-error-handling-code drivers/video/epson1355fb.c
--- a/drivers/video/epson1355fb.c~epson1355fbc-fix-error-handling-code
+++ a/drivers/video/epson1355fb.c
@@ -650,9 +650,10 @@ int __init epson1355fb_probe(struct plat
 	}
 
 	info = framebuffer_alloc(sizeof(struct epson1355_par) + sizeof(u32) * 256, &dev->dev);
-	if (!info)
+	if (!info) {
 		rc = -ENOMEM;
 		goto bail;
+	}
 
 	default_par = info->par;
 	default_par->reg_addr = (unsigned long) ioremap(EPSON1355FB_REGS_PHYS, EPSON1355FB_REGS_LEN);
_

Patches currently in -mm which might be from stigge@antcom.de are

origin.patch
