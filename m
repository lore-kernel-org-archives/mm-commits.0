From: akpm@linux-foundation.org
Subject: + fbdev-vt8623fb-better-resume-from-str.patch added to -mm tree
Date: Wed, 05 Mar 2008 23:07:55 -0800
Message-ID: <200803060707.m2677tWl014053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758019AbYCFHIE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 02:08:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, adaplas@pol.net


The patch titled
     fbdev: vt8623fb: better resume from STR
has been added to the -mm tree.  Its filename is
     fbdev-vt8623fb-better-resume-from-str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fbdev-vt8623fb-better-resume-from-str.patch

