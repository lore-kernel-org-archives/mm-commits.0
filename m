From: akpm@linux-foundation.org
Subject: [merged] intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:39 -0800
Message-ID: <200912162036.nBGKadDW013257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935452AbZLPUgt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, hramrach@centrum.cz, samanddeanus@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     intelfb: fix setting of active pipe with LVDS displays
has been removed from the -mm tree.  Its filename was
     intelfb-fix-setting-of-active-pipe-with-lvds-displays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intelfb: fix setting of active pipe with LVDS displays
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The intelfb driver sets color map depending on currently active pipe. 
However, if an LVDS display is attached (like in laptop) the active pipe
variable is never set.  The default value is PIPE_A and can be wrong.  Set
up the pipe variable during driver initialization after hardware state was
read.

Also, the detection of the active display (and hence the pipe) is wrong. 
The pipes are assigned to so called planes.  Both pipes are always enabled
on my laptop but only one plane is enabled (the plane A for the CRT or the
plane B for the LVDS).  Change active pipe detection code to take into
account a status of the plane assigned to each pipe.

The problem is visible in the 8 bpp mode if colors above 15 are used.  The
first 16 color entries are displayed correctly.

The graphics chip description is here (G45 vol. 3):
http://intellinuxgraphics.org/documentation.html

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13285

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Michal Suchanek <hramrach@centrum.cz>
Cc: Dean Menezes <samanddeanus@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbdrv.c |    3 +
 drivers/video/intelfb/intelfbhw.c  |   47 +++++++++++++++++----------
 drivers/video/intelfb/intelfbhw.h  |    1 
 3 files changed, 34 insertions(+), 17 deletions(-)

diff -puN drivers/video/intelfb/intelfbdrv.c~intelfb-fix-setting-of-active-pipe-with-lvds-displays drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~intelfb-fix-setting-of-active-pipe-with-lvds-displays
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -874,6 +874,9 @@ static int __devinit intelfb_pci_registe
 	if (bailearly == 18)
 		bailout(dinfo);
 
+	/* read active pipe */
+	dinfo->pipe = intelfbhw_active_pipe(&dinfo->save_state);
+
 	/* Cursor initialisation */
 	if (dinfo->hwcursor) {
 		intelfbhw_cursor_init(dinfo);
diff -puN drivers/video/intelfb/intelfbhw.c~intelfb-fix-setting-of-active-pipe-with-lvds-displays drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~intelfb-fix-setting-of-active-pipe-with-lvds-displays
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -469,6 +469,32 @@ void intelfbhw_do_blank(int blank, struc
 }
 
 
+/* Check which pipe is connected to an active display plane. */
+int intelfbhw_active_pipe(const struct intelfb_hwstate *hw)
+{
+	int pipe = -1;
+
+	/* keep old default behaviour - prefer PIPE_A */
+	if (hw->disp_b_ctrl & DISPPLANE_PLANE_ENABLE) {
+		pipe = (hw->disp_b_ctrl >> DISPPLANE_SEL_PIPE_SHIFT);
+		pipe &= PIPE_MASK;
+		if (unlikely(pipe == PIPE_A))
+			return PIPE_A;
+	}
+	if (hw->disp_a_ctrl & DISPPLANE_PLANE_ENABLE) {
+		pipe = (hw->disp_a_ctrl >> DISPPLANE_SEL_PIPE_SHIFT);
+		pipe &= PIPE_MASK;
+		if (likely(pipe == PIPE_A))
+			return PIPE_A;
+	}
+	/* Impossible that no pipe is selected - return PIPE_A */
+	WARN_ON(pipe == -1);
+	if (unlikely(pipe == -1))
+		pipe = PIPE_A;
+
+	return pipe;
+}
+
 void intelfbhw_setcolreg(struct intelfb_info *dinfo, unsigned regno,
 			 unsigned red, unsigned green, unsigned blue,
 			 unsigned transp)
@@ -1019,7 +1045,7 @@ int intelfbhw_mode_to_hw(struct intelfb_
 			 struct intelfb_hwstate *hw,
 			 struct fb_var_screeninfo *var)
 {
-	int pipe = PIPE_A;
+	int pipe = intelfbhw_active_pipe(hw);
 	u32 *dpll, *fp0, *fp1;
 	u32 m1, m2, n, p1, p2, clock_target, clock;
 	u32 hsync_start, hsync_end, hblank_start, hblank_end, htotal, hactive;
@@ -1033,12 +1059,6 @@ int intelfbhw_mode_to_hw(struct intelfb_
 	/* Disable VGA */
 	hw->vgacntrl |= VGA_DISABLE;
 
-	/* Check whether pipe A or pipe B is enabled. */
-	if (hw->pipe_a_conf & PIPECONF_ENABLE)
-		pipe = PIPE_A;
-	else if (hw->pipe_b_conf & PIPECONF_ENABLE)
-		pipe = PIPE_B;
-
 	/* Set which pipe's registers will be set. */
 	if (pipe == PIPE_B) {
 		dpll = &hw->dpll_b;
@@ -1262,7 +1282,6 @@ int intelfbhw_mode_to_hw(struct intelfb_
 int intelfbhw_program_mode(struct intelfb_info *dinfo,
 			   const struct intelfb_hwstate *hw, int blank)
 {
-	int pipe = PIPE_A;
 	u32 tmp;
 	const u32 *dpll, *fp0, *fp1, *pipe_conf;
 	const u32 *hs, *ht, *hb, *vs, *vt, *vb, *ss;
@@ -1272,7 +1291,7 @@ int intelfbhw_program_mode(struct intelf
 	u32 src_size_reg;
 	u32 count, tmp_val[3];
 
-	/* Assume single pipe, display plane A, analog CRT. */
+	/* Assume single pipe */
 
 #if VERBOSE > 0
 	DBG_MSG("intelfbhw_program_mode\n");
@@ -1283,15 +1302,9 @@ int intelfbhw_program_mode(struct intelf
 	tmp |= VGA_DISABLE;
 	OUTREG(VGACNTRL, tmp);
 
-	/* Check whether pipe A or pipe B is enabled. */
-	if (hw->pipe_a_conf & PIPECONF_ENABLE)
-		pipe = PIPE_A;
-	else if (hw->pipe_b_conf & PIPECONF_ENABLE)
-		pipe = PIPE_B;
+	dinfo->pipe = intelfbhw_active_pipe(hw);
 
-	dinfo->pipe = pipe;
