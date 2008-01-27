From: akpm@linux-foundation.org
Subject: + ps3fb-make-frame-buffer-offsets-unsigned-int.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:14:32 -0800
Message-ID: <200801270514.m0R5ET4q031007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbYA0FOw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net


The patch titled
     ps3fb: make frame buffer offsets unsigned int
has been added to the -mm tree.  Its filename is
     ps3fb-make-frame-buffer-offsets-unsigned-int.patch

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
Subject: ps3fb: make frame buffer offsets unsigned int
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Frame buffer offsets don't have to be `unsigned long', `unsigned int' is
sufficient

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/ps3fb.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/video/ps3fb.c~ps3fb-make-frame-buffer-offsets-unsigned-int drivers/video/ps3fb.c
--- a/drivers/video/ps3fb.c~ps3fb-make-frame-buffer-offsets-unsigned-int
+++ a/drivers/video/ps3fb.c
@@ -140,9 +140,9 @@ struct ps3fb_par {
 	unsigned int ddr_line_length;
 	unsigned int ddr_frame_size;
 	unsigned int xdr_frame_size;
-	unsigned long full_offset;	/* start of fullscreen DDR fb */
-	unsigned long fb_offset;	/* start of actual DDR fb */
-	unsigned long pan_offset;
+	unsigned int full_offset;	/* start of fullscreen DDR fb */
+	unsigned int fb_offset;		/* start of actual DDR fb */
+	unsigned int pan_offset;
 };
 
 
@@ -512,8 +512,7 @@ static int ps3fb_set_par(struct fb_info 
 {
 	struct ps3fb_par *par = info->par;
 	unsigned int mode, ddr_line_length, xdr_line_length, lines, maxlines;
-	unsigned int ddr_xoff, ddr_yoff;
-	unsigned long offset;
+	unsigned int ddr_xoff, ddr_yoff, offset;
 	const struct fb_videomode *vmode;
 	u64 dst;
 
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

git-powerpc.patch
git-kbuild.patch
git-x86.patch
ps3-checkpatch-drivers-ps3-ps3-sys-managerc.patch
ps3-checkpatch-drivers-ps3-ps3-vuartc.patch
ps3av-ps3av_get_scanmode-and-ps3av_get_refresh_rate-are-unused.patch
ps3-use-symbolic-names-for-video-modes.patch
ps3fb-kill-ps3fb_full_mode_bit.patch
ps3fb-inline-macros-that-are-used-only-once.patch
ps3fb-kill-ps3fb_res.patch
ps3fb-make-frame-buffer-offsets-unsigned-int.patch
ps3fb-add-support-for-configurable-black-borders.patch
ps3fb-reorganize-modedb-handling.patch
ps3fb-round-up-video-modes.patch
ps3fb-cleanup-sweep.patch
ps3fb-fix-modedb-typos.patch
