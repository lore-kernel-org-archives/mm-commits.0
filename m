From: akpm@linux-foundation.org
Subject: [merged] uvesafb-fix-color-component-length-for-pseudocolor-modes.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:44 -0700
Message-ID: <200904141948.n3EJmiuW019199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbZDNTwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: spock@gentoo.org, geert.uytterhoeven@gmail.com, krzysztof.h1@poczta.fm, syrjala@sci.fi, mm-commits@vger.kernel.org


The patch titled
     uvesafb: fix color component length for pseudocolor modes
has been removed from the -mm tree.  Its filename was
     uvesafb-fix-color-component-length-for-pseudocolor-modes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uvesafb: fix color component length for pseudocolor modes
From: Michal Januszewski <spock@gentoo.org>

uvesafb incorrectly sets the length of the color fields to 6 bits for
PSEUDOCOLOR modes, even though 8 bits are always used per pixel.  Fix this
by setting the length to 8.

The switch of the DAC width from the default 6 bits to 8 bits is retained
and tracked internally in the driver, but never exposed to userspace.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: <syrjala@sci.fi>
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-fix-color-component-length-for-pseudocolor-modes drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-fix-color-component-length-for-pseudocolor-modes
+++ a/drivers/video/uvesafb.c
@@ -55,6 +55,7 @@ static u16 maxvf	__devinitdata; /* maxim
 static u16 maxhf	__devinitdata; /* maximum horizontal frequency */
 static u16 vbemode	__devinitdata; /* force use of a specific VBE mode */
 static char *mode_option __devinitdata;
+static u8  dac_width	= 6;
 
 static struct uvesafb_ktask *uvfb_tasks[UVESAFB_TASKS_MAX];
 static DEFINE_MUTEX(uvfb_lock);
@@ -303,22 +304,10 @@ static void uvesafb_setup_var(struct fb_
 		var->blue.offset   = 0;
 		var->transp.offset = 0;
 
-		/*
-		 * We're assuming that we can switch the DAC to 8 bits. If
-		 * this proves to be incorrect, we'll update the fields
-		 * later in set_par().
-		 */
-		if (par->vbe_ib.capabilities & VBE_CAP_CAN_SWITCH_DAC) {
-			var->red.length    = 8;
-			var->green.length  = 8;
-			var->blue.length   = 8;
-			var->transp.length = 0;
-		} else {
-			var->red.length    = 6;
-			var->green.length  = 6;
-			var->blue.length   = 6;
-			var->transp.length = 0;
-		}
+		var->red.length    = 8;
+		var->green.length  = 8;
+		var->blue.length   = 8;
+		var->transp.length = 0;
 	}
 }
 
@@ -1006,7 +995,7 @@ static int uvesafb_setcolreg(unsigned re
 		struct fb_info *info)
 {
 	struct uvesafb_pal_entry entry;
-	int shift = 16 - info->var.green.length;
+	int shift = 16 - dac_width;
 	int err = 0;
 
 	if (regno >= info->cmap.len)
@@ -1055,7 +1044,7 @@ static int uvesafb_setcolreg(unsigned re
 static int uvesafb_setcmap(struct fb_cmap *cmap, struct fb_info *info)
 {
 	struct uvesafb_pal_entry *entries;
-	int shift = 16 - info->var.green.length;
+	int shift = 16 - dac_width;
 	int i, err = 0;
 
 	if (info->var.bits_per_pixel == 8) {
@@ -1317,13 +1306,9 @@ setmode:
 		err = uvesafb_exec(task);
 		if (err || (task->t.regs.eax & 0xffff) != 0x004f ||
 		    ((task->t.regs.ebx & 0xff00) >> 8) != 8) {
-			/*
-			 * We've failed to set the DAC palette format -
-			 * time to correct var.
-			 */
-			info->var.red.length    = 6;
-			info->var.green.length  = 6;
-			info->var.blue.length   = 6;
+			dac_width = 6;
+		} else {
+			dac_width = 8;
 		}
 	}
 
_

Patches currently in -mm which might be from spock@gentoo.org are

origin.patch
linux-next.patch

