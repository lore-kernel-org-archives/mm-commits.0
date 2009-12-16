From: akpm@linux-foundation.org
Subject: [merged] add-palette-register-check.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:35:39 -0800
Message-ID: <200912162035.nBGKZdbA013112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935272AbZLPUfm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:35:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     fbdev: add palette register check to several drivers
has been removed from the -mm tree.  Its filename was
     add-palette-register-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: add palette register check to several drivers
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add check if palette register number is in correct range for few drivers
which miss it.  The regno value comes indirectly from user space.

Two drivers has converted check from BUG_ON() macro to just return an
error (non-zero value).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atafb.c      |    3 +++
 drivers/video/ep93xx-fb.c  |    2 ++
 drivers/video/maxinefb.c   |    3 +++
 drivers/video/pmag-ba-fb.c |    3 ++-
 drivers/video/pmagb-b-fb.c |    3 ++-
 5 files changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/video/atafb.c~add-palette-register-check drivers/video/atafb.c
--- a/drivers/video/atafb.c~add-palette-register-check
+++ a/drivers/video/atafb.c
@@ -2245,6 +2245,9 @@ static int ext_setcolreg(unsigned int re
 	if (regno > 255)
 		return 1;
 
+	if (regno > 255)
+		return 1;
+
 	switch (external_card_type) {
 	case IS_VGA:
 		OUTB(0x3c8, regno);
diff -puN drivers/video/ep93xx-fb.c~add-palette-register-check drivers/video/ep93xx-fb.c
--- a/drivers/video/ep93xx-fb.c~add-palette-register-check
+++ a/drivers/video/ep93xx-fb.c
@@ -358,6 +358,8 @@ static int ep93xxfb_setcolreg(unsigned i
 
 	switch (info->fix.visual) {
 	case FB_VISUAL_PSEUDOCOLOR:
+		if (regno > 255)
+			return 1;
 		rgb = ((red & 0xff00) << 8) | (green & 0xff00) |
 			((blue & 0xff00) >> 8);
 
diff -puN drivers/video/maxinefb.c~add-palette-register-check drivers/video/maxinefb.c
--- a/drivers/video/maxinefb.c~add-palette-register-check
+++ a/drivers/video/maxinefb.c
@@ -92,6 +92,9 @@ static int maxinefb_setcolreg(unsigned r
 	/* value to be written into the palette reg. */
 	unsigned long hw_colorvalue = 0;
 
+	if (regno > 255)
+		return 1;
+
 	red   >>= 8;    /* The cmap fields are 16 bits    */
 	green >>= 8;    /* wide, but the harware colormap */
 	blue  >>= 8;    /* registers are only 8 bits wide */
diff -puN drivers/video/pmag-ba-fb.c~add-palette-register-check drivers/video/pmag-ba-fb.c
--- a/drivers/video/pmag-ba-fb.c~add-palette-register-check
+++ a/drivers/video/pmag-ba-fb.c
@@ -98,7 +98,8 @@ static int pmagbafb_setcolreg(unsigned i
 {
 	struct pmagbafb_par *par = info->par;
 
-	BUG_ON(regno >= info->cmap.len);
+	if (regno >= info->cmap.len)
+		return 1;
 
 	red   >>= 8;	/* The cmap fields are 16 bits    */
 	green >>= 8;	/* wide, but the hardware colormap */
diff -puN drivers/video/pmagb-b-fb.c~add-palette-register-check drivers/video/pmagb-b-fb.c
--- a/drivers/video/pmagb-b-fb.c~add-palette-register-check
+++ a/drivers/video/pmagb-b-fb.c
@@ -102,7 +102,8 @@ static int pmagbbfb_setcolreg(unsigned i
 {
 	struct pmagbbfb_par *par = info->par;
 
-	BUG_ON(regno >= info->cmap.len);
+	if (regno >= info->cmap.len)
+		return 1;
 
 	red   >>= 8;	/* The cmap fields are 16 bits    */
 	green >>= 8;	/* wide, but the hardware colormap */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch

