From: akpm@linux-foundation.org
Subject: - fbcon-check-if-the-character-count-can-be-handled.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:48 -0700
Message-ID: <200705090301.l4931mZh010756@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032501AbXEIDBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: check if the character count can be handled
has been removed from the -mm tree.  Its filename was
     fbcon-check-if-the-character-count-can-be-handled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: check if the character count can be handled
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fontmaps can be 256 or 512 in length. The only driver that can do tileblitting
can only handle 256 characters.  Check for this when setting the font.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/video/console/fbcon.c~fbcon-check-if-the-character-count-can-be-handled drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-check-if-the-character-count-can-be-handled
+++ a/drivers/video/console/fbcon.c
@@ -685,6 +685,17 @@ static void set_blitting_type(struct vc_
 		fbcon_set_bitops(ops);
 	}
 }
+
+static int fbcon_invalid_charcount(struct fb_info *info, unsigned charcount)
+{
+	int err = 0;
+
+	if (info->flags & FBINFO_MISC_TILEBLITTING &&
+	    info->tileops->fb_get_tilemax(info) < charcount)
+		err = 1;
+
+	return err;
+}
 #else
 static void set_blitting_type(struct vc_data *vc, struct fb_info *info)
 {
@@ -695,6 +706,12 @@ static void set_blitting_type(struct vc_
 	fbcon_set_rotation(info);
 	fbcon_set_bitops(ops);
 }
+
+static int fbcon_invalid_charcount(struct fb_info *info, unsigned charcount)
+{
+	return 0;
+}
+
 #endif /* CONFIG_MISC_TILEBLITTING */
 
 
@@ -2518,6 +2535,10 @@ static int fbcon_set_font(struct vc_data
 	    !(info->pixmap.blit_y & (1 << (font->height - 1))))
 		return -EINVAL;
 
+	/* Make sure driver can handle the font length */
+	if (fbcon_invalid_charcount(info, charcount))
+		return -EINVAL;
+
 	size = h * pitch * charcount;
 
 	new_data = kmalloc(FONT_EXTRA_WORDS * sizeof(int) + size, GFP_USER);
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
