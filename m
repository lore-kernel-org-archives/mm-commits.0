From: akpm@linux-foundation.org
Subject: - fbdev-vt8623fb-better-resume-from-str.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:30 -0700
Message-ID: <200804282158.m3SLwU6s018498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965359AbYD1V6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: vt8623fb: better resume from STR
has been removed from the -mm tree.  Its filename was
     fbdev-vt8623fb-better-resume-from-str.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: vt8623fb: better resume from STR
From: Ondrej Zajicek <santiago@crfreenet.org>

After resume from STR, image is shifted by 8 pixels to the left.  This patch
fixes it.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vt8623fb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/video/vt8623fb.c~fbdev-vt8623fb-better-resume-from-str drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~fbdev-vt8623fb-better-resume-from-str
+++ a/drivers/video/vt8623fb.c
@@ -436,6 +436,10 @@ static int vt8623fb_set_par(struct fb_in
 	svga_wcrt_multi(vt8623_offset_regs, offset_value);
 	svga_wseq_multi(vt8623_fetch_count_regs, fetch_value);
 
+	/* Clear H/V Skew */
+	svga_wcrt_mask(0x03, 0x00, 0x60);
+	svga_wcrt_mask(0x05, 0x00, 0x60);
+
 	if (info->var.vmode & FB_VMODE_DOUBLE)
 		svga_wcrt_mask(0x09, 0x80, 0x80);
 	else
_

Patches currently in -mm which might be from santiago@crfreenet.org are

origin.patch

