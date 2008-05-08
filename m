From: akpm@linux-foundation.org
Subject: + tridentfb-use-mmio-access-for-clock-setting.patch added to -mm tree
Date: Thu, 08 May 2008 13:45:23 -0700
Message-ID: <200805082045.m48KjN2H004987@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759924AbYEHUp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 16:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     tridentfb: use mmio access for clock setting
has been added to the -mm tree.  Its filename is
     tridentfb-use-mmio-access-for-clock-setting.patch

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
Subject: tridentfb: use mmio access for clock setting
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Use the mmio outb function instead of direct one.  The mmio registers are
already mapped (in the probe function).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-use-mmio-access-for-clock-setting drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-use-mmio-access-for-clock-setting
+++ a/drivers/video/tridentfb.c
@@ -680,8 +680,8 @@ static void set_vclk(struct tridentfb_pa
 		vga_mm_wseq(par->io_virt, ClockHigh, hi);
 		vga_mm_wseq(par->io_virt, ClockLow, lo);
 	} else {
-		outb(lo, 0x43C8);
-		outb(hi, 0x43C9);
+		t_outb(par, lo, 0x43C8);
+		t_outb(par, hi, 0x43C9);
 	}
 	debug("VCLK = %X %X\n", hi, lo);
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

tridentfb-remove-misplaced-enable_mmio.patch
tridentfb-improve-clock-setting-accuracy.patch
drivers-video-pnx4008-eliminate-double-free.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

