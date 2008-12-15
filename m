From: akpm@linux-foundation.org
Subject: - vt-fix-console-ascii-glyph-1-1-mapping.patch removed from -mm tree
Date: Mon, 15 Dec 2008 12:02:31 -0800
Message-ID: <200812152002.mBFK2ViU031017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbYLOUDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Dec 2008 15:03:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ib@wupperonline.de, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, samuel.thibault@ens-lyon.org, mm-commits@vger.kernel.org


The patch titled
     vt: fix console ASCII glyph 1:1 mapping
has been removed from the -mm tree.  Its filename was
     vt-fix-console-ascii-glyph-1-1-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: fix console ASCII glyph 1:1 mapping
From: Ingo Brueckl <ib@wupperonline.de>

For the console, there is a 1:1 mapping of glyphs which cannot be found in
the current font.  This seems to be meant as a kind of 'emergency
fallback' for fonts without unicode mapping which otherwise would display
nothing readable on the screen.

At the moment it affects all chars for which no substitution character is
defined.  In particular this means that for all chars (>= 128) where there
is no iso88591-1/unicode character (e.g.  control character area) you'll
get the very strange 1:1 mapping of the (cp437) graphics card glyphs.

I'm pretty sure that the 1:1 mapping should only affect strict ASCII code
characters, i.e.  chars < 128.

The patch limits the mapping as it probably was meant anyway.

Signed-off-by: Ingo Brueckl <ib@wupperonline.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/vt.c~vt-fix-console-ascii-glyph-1-1-mapping drivers/char/vt.c
--- a/drivers/char/vt.c~vt-fix-console-ascii-glyph-1-1-mapping
+++ a/drivers/char/vt.c
@@ -2272,7 +2272,7 @@ rescan_last_byte:
 				    continue; /* nothing to display */
 				}
 				/* Glyph not found */
-				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
+				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) && c < 128) && !(c & ~charmask)) {
 				    /* In legacy mode use the glyph we get by a 1:1 mapping.
 				       This would make absolutely no sense with Unicode in mind,
 				       but do this for ASCII characters since a font may lack
_

Patches currently in -mm which might be from ib@wupperonline.de are

origin.patch

