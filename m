From: akpm@linux-foundation.org
Subject: + fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch added to -mm tree
Date: Tue, 11 Dec 2007 16:57:42 -0800
Message-ID: <200712120057.lBC0vg8X017810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbXLLA5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 19:57:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, adaplas@pol.net


The patch titled
     fbcon: fix sparse warning about shadowing 'rotate' symbol
has been added to the -mm tree.  Its filename is
     fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: fix sparse warning about shadowing 'rotate' symbol
From: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-fix-sparse-warning-about-shadowing-rotate-symbol drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-fix-sparse-warning-about-shadowing-rotate-symbol
+++ a/drivers/video/console/fbcon.c
@@ -147,7 +147,7 @@ static char fontname[40];
 static int info_idx = -1;
 
 /* console rotation */
-static int rotate;
+static int initial_rotation;
 static int fbcon_has_sysfs;
 
 static const struct consw fb_con;
@@ -537,9 +537,9 @@ static int __init fb_console_setup(char 
 		if (!strncmp(options, "rotate:", 7)) {
 			options += 7;
 			if (*options)
-				rotate = simple_strtoul(options, &options, 0);
-			if (rotate > 3)
-				rotate = 0;
+				initial_rotation = simple_strtoul(options, &options, 0);
+			if (initial_rotation > 3)
+				initial_rotation = 0;
 		}
 	}
 	return 1;
@@ -989,7 +989,7 @@ static const char *fbcon_startup(void)
 	ops->graphics = 1;
 	ops->cur_rotate = -1;
 	info->fbcon_par = ops;
-	p->con_rotate = rotate;
+	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);
 
 	if (info->fix.type != FB_TYPE_TEXT) {
@@ -1176,7 +1176,7 @@ static void fbcon_init(struct vc_data *v
 		con_copy_unimap(vc, svc);
 
 	ops = info->fbcon_par;
-	p->con_rotate = rotate;
+	p->con_rotate = initial_rotation;
 	set_blitting_type(vc, info);
 
 	cols = vc->vc_cols;
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
