From: akpm@linux-foundation.org
Subject: - i810fb-fix-i810_check_params-section-mismatch.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:47:00 -0800
Message-ID: <200702211047.l1LAl0Nq006511@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161217AbXBUKsB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:48:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     i810fb: fix i810_check_params section mismatch
has been removed from the -mm tree.  Its filename was
     i810fb-fix-i810_check_params-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i810fb: fix i810_check_params section mismatch
From: Jean Delvare <khali@linux-fr.org>

WARNING: drivers/video/i810/i810fb.o - Section mismatch: reference
to .init.data: from .text between 'i810_check_params' (at offset
0x1123) and 'encode_fix'

yres cannot be declared __devinitdata as it is used in
i810_check_params(), which isn't __devinit.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/i810/i810_main.c~i810fb-fix-i810_check_params-section-mismatch drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~i810fb-fix-i810_check_params-section-mismatch
+++ a/drivers/video/i810/i810_main.c
@@ -142,7 +142,7 @@ static int hsync2     __devinitdata;
 static int vsync1     __devinitdata;
 static int vsync2     __devinitdata;
 static int xres       __devinitdata;
-static int yres       __devinitdata;
+static int yres;
 static int vyres      __devinitdata;
 static int sync       __devinitdata;
 static int extvga     __devinitdata;
_

Patches currently in -mm which might be from khali@linux-fr.org are
