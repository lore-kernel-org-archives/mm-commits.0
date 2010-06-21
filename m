From: akpm@linux-foundation.org
Subject: + fbdev-efifb-section-fixes.patch added to -mm tree
Date: Mon, 21 Jun 2010 14:26:58 -0700
Message-ID: <201006212126.o5LLQwM6005831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55674 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756757Ab0FUV1o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 17:27:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, pjones@redhat.com


The patch titled
     fbdev: efifb: section fixes
has been added to the -mm tree.  Its filename is
     fbdev-efifb-section-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: efifb: section fixes
From: Henrik Kretzschmar <henne@nachtwindheim.de>

Remove 43 section mismatches by moving the two structures efifb_defined
and efifb_fix from .init.data to .devinit.data.

Also the two structure arrays dmi_system_table[] and dmi_list[] have been
moved from .data to .init.rodata and .init.data, which saves, if built-in,
some space.

On x86_64 'size -A' showed that these sections changed size:

efifb.o:
section                     size-old        size-new
.data                       1200            688
.init.data                  7840            512
.init.rodata                0               7568
.devinit.data               0               256

Total                       11927           11911

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/efifb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/efifb.c~fbdev-efifb-section-fixes drivers/video/efifb.c
--- a/drivers/video/efifb.c~fbdev-efifb-section-fixes
+++ a/drivers/video/efifb.c
@@ -16,7 +16,7 @@
 
 #include <video/vga.h>
 
-static struct fb_var_screeninfo efifb_defined __initdata = {
+static struct fb_var_screeninfo efifb_defined __devinitdata = {
 	.activate		= FB_ACTIVATE_NOW,
 	.height			= -1,
 	.width			= -1,
@@ -27,7 +27,7 @@ static struct fb_var_screeninfo efifb_de
 	.vmode			= FB_VMODE_NONINTERLACED,
 };
 
-static struct fb_fix_screeninfo efifb_fix __initdata = {
+static struct fb_fix_screeninfo efifb_fix __devinitdata = {
 	.id			= "EFI VGA",
 	.type			= FB_TYPE_PACKED_PIXELS,
 	.accel			= FB_ACCEL_NONE,
@@ -59,7 +59,7 @@ static struct efifb_dmi_info {
 	int stride;
 	int width;
 	int height;
-} dmi_list[] = {
+} dmi_list[] __initdata = {
 	[M_I17] = { "i17", 0x80010000, 1472 * 4, 1440, 900 },
 	[M_I20] = { "i20", 0x80010000, 1728 * 4, 1680, 1050 }, /* guess */
 	[M_I20_SR] = { "imac7", 0x40010000, 1728 * 4, 1680, 1050 },
@@ -83,7 +83,7 @@ static int set_system(const struct dmi_s
 		DMI_MATCH(DMI_PRODUCT_NAME, name) },		\
 	  &dmi_list[enumid] }
 
-static struct dmi_system_id __initdata dmi_system_table[] = {
+static const struct dmi_system_id dmi_system_table[] __initconst = {
 	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac4,1", M_I17),
 	/* At least one of these two will be right; maybe both? */
 	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac5,1", M_I20),
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

fbdev-section-fixes-in-viafb-driver.patch
fbdev-efifb-section-fixes.patch

