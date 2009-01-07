From: akpm@linux-foundation.org
Subject: - fbdev-logo-check-compatibility-of-main-and-extra-logos.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:01 -0800
Message-ID: <200901072220.n07MK1Zt019270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932350AbZAGWfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:35:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev/logo: check compatibility of main and extra logos
has been removed from the -mm tree.  Its filename was
     fbdev-logo-check-compatibility-of-main-and-extra-logos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev/logo: check compatibility of main and extra logos
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Subject: [PATCH] fbdev/logo: Check compatibility of main and extra logos

The code to draw penguin logos always uses some properties of the main logo.
This is incorrect if additional logos (CONFIG_FB_LOGO_EXTRA=y) have different
types than the main logo, which causes corrupted logo images.

http://bugzilla.kernel.org/show_bug.cgi?id=12181

Hence skip additional logos that are not compatible with the main logo.

Technically, it's possible to draw multiple logos of different types on
truecolor displays, but this would complicate the (already quite
complicated) logo drawing code even more.

This patch fixes a problem with Debian's linux-image-2.6.26-1-powerpc64
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=508173

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/video/fbmem.c~fbdev-logo-check-compatibility-of-main-and-extra-logos drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-logo-check-compatibility-of-main-and-extra-logos
+++ a/drivers/video/fbmem.c
@@ -510,6 +510,10 @@ static int fb_prepare_extra_logos(struct
 		fb_logo_ex_num = 0;
 
 	for (i = 0; i < fb_logo_ex_num; i++) {
+		if (fb_logo_ex[i].logo->type != fb_logo.logo->type) {
+			fb_logo_ex[i].logo = NULL;
+			continue;
+		}
 		height += fb_logo_ex[i].logo->height;
 		if (height > yres) {
 			height -= fb_logo_ex[i].logo->height;
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch

