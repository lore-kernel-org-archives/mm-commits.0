From: akpm@linux-foundation.org
Subject: + intelfb-fix-a-bug-when-changing-video-timing.patch added to -mm tree
Date: Wed, 03 Jun 2009 14:29:02 -0700
Message-ID: <200906032129.n53LT2sl004251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950AbZFCV3o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 17:29:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulepanter@users.sourceforge.net, krzysztof.h1@poczta.fm, sparkie@lowbyte.de


The patch titled
     intelfb: fix a bug when changing video timing
has been added to the -mm tree.  Its filename is
     intelfb-fix-a-bug-when-changing-video-timing.patch

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
Subject: intelfb: fix a bug when changing video timing
From: Paul Menzel <paulepanter@users.sourceforge.net>

When changing video timing dynamically via fbset the screen sporadically
is rendered black.

With the attached fix which disables VCO prior to timing register change
the problem disappears.

I had a look at the Xserver register setup code. Here the VCO is
disabled in the same way [1].

This patch is taken from vga-sync-field version 0.0.11 [2][3].

[1] http://cgit.freedesktop.org/xorg/driver/xf86-video-intel/tree/src/i830_=
driver.c
[2] http://lowbyte.de/vga-sync-fields/vga-sync-fields-0.0.11.tgz
[3] http://easy-vdr.de/git?p=frc.git/.git;a=commit;h=dcc3b863e5a663652587619c357bd20075af6896
2587619c357bd20075af6896

Signed-off-by: Thomas Hilber <sparkie@lowbyte.de>
Signed-off-by: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbdrv.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/video/intelfb/intelfbdrv.c~intelfb-fix-a-bug-when-changing-video-timing drivers/video/intelfb/intelfbdrv.c
--- a/drivers/video/intelfb/intelfbdrv.c~intelfb-fix-a-bug-when-changing-video-timing
+++ a/drivers/video/intelfb/intelfbdrv.c
@@ -1374,6 +1374,11 @@ static int intelfb_set_par(struct fb_inf
 	DBG_MSG("intelfb_set_par (%dx%d-%d)\n", info->var.xres,
 		info->var.yres, info->var.bits_per_pixel);
 
+	/*
+	 * Disable VCO prior to timing register change.
+	 */
+	OUTREG(DPLL_A, INREG(DPLL_A) & ~DPLL_VCO_ENABLE);
+
 	intelfb_blank(FB_BLANK_POWERDOWN, info);
 
 	if (ACCEL(dinfo, info))
_

Patches currently in -mm which might be from paulepanter@users.sourceforge.net are

fbdev-add-video-modes-for-resolutions-and-timings-of-pal-rgb.patch
documentation-fb-vesafbtxt-fix-typo.patch
intelfb-fix-a-bug-when-changing-video-timing.patch

