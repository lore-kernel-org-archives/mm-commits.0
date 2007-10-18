From: akpm@linux-foundation.org
Subject: + fb-modedb-refactor-confusing-mode_option-assignment.patch added to -mm tree
Date: Wed, 17 Oct 2007 17:48:07 -0700
Message-ID: <200710180048.l9I0m7Mx016659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933112AbXJRAsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 20:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     fb modedb: Refactor confusing mode_option assignment
has been added to the -mm tree.  Its filename is
     fb-modedb-refactor-confusing-mode_option-assignment.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fb modedb: Refactor confusing mode_option assignment
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/modedb.c~fb-modedb-refactor-confusing-mode_option-assignment drivers/video/modedb.c
--- a/drivers/video/modedb.c~fb-modedb-refactor-confusing-mode_option-assignment
+++ a/drivers/video/modedb.c
@@ -510,7 +510,9 @@ int fb_find_mode(struct fb_var_screeninf
 	default_bpp = 8;
 
     /* Did the user specify a video mode? */
-    if (mode_option || (mode_option = fb_mode_option)) {
+    if (!mode_option)
+	mode_option = fb_mode_option;
+    if (mode_option) {
 	const char *name = mode_option;
 	unsigned int namelen = strlen(name);
 	int res_specified = 0, bpp_specified = 0, refresh_specified = 0;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
fb-modedb-refactor-confusing-mode_option-assignment.patch
