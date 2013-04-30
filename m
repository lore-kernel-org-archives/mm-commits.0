From: akpm@linux-foundation.org
Subject: [merged] drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:43:36 -0700
Message-ID: <20130430184336.6FC9131C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:48659 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3D3Snh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:43:37 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so84425vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:43:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, FlorianSchandinat@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/console/fbcon_cw.c: fix compiler warning in cw_update_attr
has been removed from the -mm tree.  Its filename was
     drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/video/console/fbcon_cw.c: fix compiler warning in cw_update_attr

with make W=1

saw

drivers/video/console/fbcon_cw.c: In function `cw_update_attr':
drivers/video/console/fbcon_cw.c:30:8: warning: variable `t' set but not used [-Wunused-but-set-variable]

fixed by removing as since its used nowhere

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon_cw.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/console/fbcon_cw.c~drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr drivers/video/console/fbcon_cw.c
--- a/drivers/video/console/fbcon_cw.c~drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr
+++ a/drivers/video/console/fbcon_cw.c
@@ -27,7 +27,7 @@ static void cw_update_attr(u8 *dst, u8 *
 {
 	int i, j, offset = (vc->vc_font.height < 10) ? 1 : 2;
 	int width = (vc->vc_font.height + 7) >> 3;
-	u8 c, t = 0, msk = ~(0xff >> offset);
+	u8 c, msk = ~(0xff >> offset);
 
 	for (i = 0; i < vc->vc_font.width; i++) {
 		for (j = 0; j < width; j++) {
@@ -40,7 +40,6 @@ static void cw_update_attr(u8 *dst, u8 *
 				c = ~c;
 			src++;
 			*dst++ = c;
-			t = c;
 		}
 	}
 }
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

origin.patch
linux-next.patch

