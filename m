From: akpm@linux-foundation.org
Subject: - fbcon-make-logo_height-a-local-variable.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:32:03 -0700
Message-ID: <200807242332.m6ONW3Hm011791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756126AbYGXXcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:32:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     fbcon: make logo_height a local variable
has been removed from the -mm tree.  Its filename was
     fbcon-make-logo_height-a-local-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: make logo_height a local variable
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Make logo_height variable local in the only function it is used.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-make-logo_height-a-local-variable drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-make-logo_height-a-local-variable
+++ a/drivers/video/console/fbcon.c
@@ -107,9 +107,7 @@ static struct display fb_display[MAX_NR_
 
 static signed char con2fb_map[MAX_NR_CONSOLES];
 static signed char con2fb_map_boot[MAX_NR_CONSOLES];
-#ifndef MODULE
-static int logo_height;
-#endif
+
 static int logo_lines;
 /* logo_shown is an index to vc_cons when >= 0; otherwise follows FBCON_LOGO
    enums.  */
@@ -607,6 +605,7 @@ static void fbcon_prepare_logo(struct vc
 	struct fbcon_ops *ops = info->fbcon_par;
 	int cnt, erase = vc->vc_video_erase_char, step;
 	unsigned short *save = NULL, *r, *q;
+	int logo_height;
 
 	if (info->flags & FBINFO_MODULE) {
 		logo_shown = FBCON_LOGO_DONTSHOW;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

