From: akpm@linux-foundation.org
Subject: + vga-vgastate-fix.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:33:38 -0700
Message-ID: <200704290933.l3T9XcU9012965@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136AbXD2Jd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, adaplas@gmail.com


The patch titled
     vga: vgastate fix
has been added to the -mm tree.  Its filename is
     vga-vgastate-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vga: vgastate fix
From: Ondrej Zajicek <santiago@crfreenet.org>

1) sets 'palette access disabled' during read from AR10.
   This is usually documented as needed for access AR01-AR0F,
   but on ARK Logic card it is needed for AR10 (otherwise read
   returns some nonsence and save_vga_text() returns before do
   anything).

2) do not restore AR10, because it was not changed during

3) remove modification of misc reg:
        /* force graphics mode */
        vga_w(state->vgabase, VGA_MIS_W, misc | 1);

   as comment is misleading - LSB of misc reg does not set/reset graphics
   mode, but set color/mono adresses of CRT and some other regs.
   but these regs are not used during save/restore fonts.
   (it worked even when (misc | 1) was replaced by (misc & ~1) ).

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vgastate.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff -puN drivers/video/vgastate.c~vga-vgastate-fix drivers/video/vgastate.c
--- a/drivers/video/vgastate.c~vga-vgastate-fix
+++ a/drivers/video/vgastate.c
@@ -50,23 +50,28 @@ static void save_vga_text(struct vgastat
 	struct regstate *saved = (struct regstate *) state->vidstate;
 	int i;
 	u8 misc, attr10, gr4, gr5, gr6, seq1, seq2, seq4;
+	unsigned short iobase;
 
 	/* if in graphics mode, no need to save */
+	misc = vga_r(state->vgabase, VGA_MIS_R);
+	iobase = (misc & 1) ? 0x3d0 : 0x3b0;
+
+	vga_r(state->vgabase, iobase + 0xa);
+	vga_w(state->vgabase, VGA_ATT_W, 0x00);
 	attr10 = vga_rattr(state->vgabase, 0x10);
+	vga_r(state->vgabase, iobase + 0xa);
+	vga_w(state->vgabase, VGA_ATT_W, 0x20);
+
 	if (attr10 & 1)
 		return;
-	
+
 	/* save regs */
-	misc = vga_r(state->vgabase, VGA_MIS_R);
 	gr4 = vga_rgfx(state->vgabase, VGA_GFX_PLANE_READ);
 	gr5 = vga_rgfx(state->vgabase, VGA_GFX_MODE);
 	gr6 = vga_rgfx(state->vgabase, VGA_GFX_MISC);
 	seq2 = vga_rseq(state->vgabase, VGA_SEQ_PLANE_WRITE);
 	seq4 = vga_rseq(state->vgabase, VGA_SEQ_MEMORY_MODE);
 	
-	/* force graphics mode */
-	vga_w(state->vgabase, VGA_MIS_W, misc | 1);
-
 	/* blank screen */
 	seq1 = vga_rseq(state->vgabase, VGA_SEQ_CLOCK_MODE);
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
@@ -115,15 +120,12 @@ static void save_vga_text(struct vgastat
 	}
 
 	/* restore regs */
-	vga_wattr(state->vgabase, 0x10, attr10);
-
 	vga_wseq(state->vgabase, VGA_SEQ_PLANE_WRITE, seq2);
 	vga_wseq(state->vgabase, VGA_SEQ_MEMORY_MODE, seq4);
 
 	vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, gr4);
 	vga_wgfx(state->vgabase, VGA_GFX_MODE, gr5);
 	vga_wgfx(state->vgabase, VGA_GFX_MISC, gr6);
-	vga_w(state->vgabase, VGA_MIS_W, misc);
 
 	/* unblank screen */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
@@ -137,11 +139,10 @@ static void restore_vga_text(struct vgas
 {
 	struct regstate *saved = (struct regstate *) state->vidstate;
 	int i;
-	u8 misc, gr1, gr3, gr4, gr5, gr6, gr8; 
+	u8 gr1, gr3, gr4, gr5, gr6, gr8;
 	u8 seq1, seq2, seq4;
 
 	/* save regs */
-	misc = vga_r(state->vgabase, VGA_MIS_R);
 	gr1 = vga_rgfx(state->vgabase, VGA_GFX_SR_ENABLE);
 	gr3 = vga_rgfx(state->vgabase, VGA_GFX_DATA_ROTATE);
 	gr4 = vga_rgfx(state->vgabase, VGA_GFX_PLANE_READ);
@@ -151,9 +152,6 @@ static void restore_vga_text(struct vgas
 	seq2 = vga_rseq(state->vgabase, VGA_SEQ_PLANE_WRITE);
 	seq4 = vga_rseq(state->vgabase, VGA_SEQ_MEMORY_MODE);
 	
-	/* force graphics mode */
-	vga_w(state->vgabase, VGA_MIS_W, misc | 1);
-
 	/* blank screen */
 	seq1 = vga_rseq(state->vgabase, VGA_SEQ_CLOCK_MODE);
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
@@ -213,8 +211,6 @@ static void restore_vga_text(struct vgas
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x3);
 
 	/* restore regs */
-	vga_w(state->vgabase, VGA_MIS_W, misc);
-
 	vga_wgfx(state->vgabase, VGA_GFX_SR_ENABLE, gr1);
 	vga_wgfx(state->vgabase, VGA_GFX_DATA_ROTATE, gr3);
 	vga_wgfx(state->vgabase, VGA_GFX_PLANE_READ, gr4);
_

Patches currently in -mm which might be from santiago@crfreenet.org are

s3fb-driver-fixes.patch
vga-vgastate-fix.patch
