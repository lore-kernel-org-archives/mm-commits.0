From: akpm@linux-foundation.org
Subject: + console-utf-8-fixes-fix.patch added to -mm tree
Date: Tue, 19 Jun 2007 11:13:10 -0700
Message-ID: <200706191813.l5JIDAha017750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759310AbXFSSNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 14:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: egmont@uhulinux.hu


The patch titled
     console UTF-8 fixes (fix)
has been added to the -mm tree.  Its filename is
     console-utf-8-fixes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: console UTF-8 fixes (fix)
From: Egmont Koblinger <egmont@uhulinux.hu>

Recently my console UTF-8 patch went mainline.  Here is an additional patch
that fixes two nasty issues and improves a third one, namely:

1. My patch changed the behavior if a glyph is not found in the Unicode
   mapping table. Previously for Unicode values less than 256 or 512 the
   kernel tried to display the glyph from that position of the glyph table,
   which could lead to a different accented letter being displayed. I
   removed this fallback possibility and changed it to display the
   replacement symbol.

   As Behdad pointed out, some fonts (e.g. sun12x22 from the kbd package)
   lack Unicode mapping information, hence all you get is lots of question
   marks. Though theoretically it's actually a user-space bug (the font
   should be fixed), Behdad and I both believe that it'd be good to work
   around in the kernel by re-introducing the fallback solution for ASCII
   characters only. This sounds a quite reasonable decision, since all fonts
   ship the ASCII characters in the first 128 positions. This way users
   won't be surprised by lots of question marks just because s/he issued a
   not-so-perfectly parameterized setfont command. As this fallback is only
   re-introduced for code points below 128, you still won't see an accented
   letter replaced by another, but at least you'll always get the English
   letters right.

2. My patch introduced "question mark with inverted color attributes" as a
   last resort fallback glyph. Though it perfectly works on VGA console, on
   framebuffer you may end up with question marks that are highlighed but
   shouldn't be, and normal characters that are accidentally highlighed.
   This is caused by missing FLUSHes when changing the color attribute.

3. I've updated the table of double-width character based on Markus's
   updated version. Only ten new code poings (one interval) is added.

Signed-off-by: Egmont Koblinger <egmont@uhulinux.hu>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/char/vt.c~console-utf-8-fixes-fix drivers/char/vt.c
--- a/drivers/char/vt.c~console-utf-8-fixes-fix
+++ a/drivers/char/vt.c
@@ -1956,7 +1956,7 @@ char con_buf[CON_BUF_SIZE];
 DEFINE_MUTEX(con_buf_mtx);
 
 /* is_double_width() is based on the wcwidth() implementation by
- * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
+ * Markus Kuhn -- 2007-05-26 (Unicode 5.0)
  * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
  */
 struct interval {
@@ -1988,8 +1988,8 @@ static int is_double_width(uint32_t ucs)
 	static const struct interval double_width[] = {
 		{ 0x1100, 0x115F }, { 0x2329, 0x232A }, { 0x2E80, 0x303E },
 		{ 0x3040, 0xA4CF }, { 0xAC00, 0xD7A3 }, { 0xF900, 0xFAFF },
-		{ 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
-		{ 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
+		{ 0xFE10, 0xFE19 }, { 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 },
+		{ 0xFFE0, 0xFFE6 }, { 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
 	};
 	return bisearch(ucs, double_width,
 		sizeof(double_width) / sizeof(*double_width) - 1);
@@ -2187,9 +2187,12 @@ rescan_last_byte:
 				    continue; /* nothing to display */
 				}
 				/* Glyph not found */
-				if (!(vc->vc_utf && !vc->vc_disp_ctrl) && !(c & ~charmask)) {
+				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
 				    /* In legacy mode use the glyph we get by a 1:1 mapping.
-				       This would make absolutely no sense with Unicode in mind. */
+				       This would make absolutely no sense with Unicode in mind,
+				       but do this for ASCII characters since a font may lack
+				       Unicode mapping info and we don't want to end up with
+				       having question marks only. */
 				    tc = c;
 				} else {
 				    /* Display U+FFFD. If it's not found, display an inverse question mark. */
@@ -2213,6 +2216,7 @@ rescan_last_byte:
 				} else {
 					vc_attr = ((vc->vc_attr) & 0x88) | (((vc->vc_attr) & 0x70) >> 4) | (((vc->vc_attr) & 0x07) << 4);
 				}
+				FLUSH
 			}
 
 			while (1) {
@@ -2246,6 +2250,10 @@ rescan_last_byte:
 				if (tc < 0) tc = ' ';
 			}
 
+			if (inverse) {
+				FLUSH
+			}
+
 			if (rescan) {
 				rescan = 0;
 				inverse = 0;
_

Patches currently in -mm which might be from egmont@uhulinux.hu are

console-utf-8-fixes-fix.patch
