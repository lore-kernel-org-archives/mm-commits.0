From: akpm@linux-foundation.org
Subject: + drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:03:36 -0800
Message-ID: <20130308210336.6EF7E5A4123@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:63896 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702Ab3CHVDh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:03:37 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so147965vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:03:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, FlorianSchandinat@gmx.de


The patch titled
     Subject: drivers/video/console/fbcon_cw.c: fix compiler warning in cw_update_attr
has been added to the -mm tree.  Its filename is
     drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr.patch
drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch

