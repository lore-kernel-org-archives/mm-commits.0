From: akpm@linux-foundation.org
Subject: + vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch added to -mm tree
Date: Tue, 11 Dec 2007 16:57:38 -0800
Message-ID: <200712120057.lBC0vcuU017802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbXLLA5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 19:57:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, adaplas@pol.net


The patch titled
     vgacon: fix sparse warning about shadowing 'i' symbol
has been added to the -mm tree.  Its filename is
     vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vgacon: fix sparse warning about shadowing 'i' symbol
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/vgacon.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/console/vgacon.c~vgacon-fix-sparse-warning-about-shadowing-i-symbol drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vgacon-fix-sparse-warning-about-shadowing-i-symbol
+++ a/drivers/video/console/vgacon.c
@@ -1153,8 +1153,6 @@ static int vgacon_do_font_op(struct vgas
 
 	/* if 512 char mode is already enabled don't re-enable it. */
 	if ((set) && (ch512 != vga_512_chars)) {
-		int i;	
-		
 		/* attribute controller */
 		for (i = 0; i < MAX_NR_CONSOLES; i++) {
 			struct vc_data *c = vc_cons[i].d;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
