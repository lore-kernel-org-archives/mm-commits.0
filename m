From: akpm@linux-foundation.org
Subject: + omapfb-dispc-various-typo-fixes.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:07 -0700
Message-ID: <200906250008.n5P0871T004954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757054AbZFYAIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@nokia.com, arunedarath@mistralsolutions.com, balrog@zabor.org, ext-kalle.jokiniemi@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: dispc: various typo fixes
has been added to the -mm tree.  Its filename is
     omapfb-dispc-various-typo-fixes.patch

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
Subject: omapfb: dispc: various typo fixes
From: Imre Deak <imre.deak@nokia.com>

- value and register offset was swapped in a dispc write
- DISPC_CONTROL register was used instead of DISPC_SYSCONFIG
- FIFO size bit field had incorrect length for OMAP3

Fixed-by: arun <arunedarath@mistralsolutions.com>
Fixed-by: Kalle Jokiniemi <ext-kalle.jokiniemi@nokia.com>
Fixed-by: Andrzej Zaborowski <balrog@zabor.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/dispc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/omap/dispc.c~omapfb-dispc-various-typo-fixes drivers/video/omap/dispc.c
--- a/drivers/video/omap/dispc.c~omapfb-dispc-various-typo-fixes
+++ a/drivers/video/omap/dispc.c
@@ -286,7 +286,7 @@ static void setup_plane_fifo(int plane, 
 	BUG_ON(plane > 2);
 
 	l = dispc_read_reg(fsz_reg[plane]);
-	l &= FLD_MASK(0, 9);
+	l &= FLD_MASK(0, 11);
 	if (ext_mode) {
 		low = l * 3 / 4;
 		high = l;
@@ -294,7 +294,7 @@ static void setup_plane_fifo(int plane, 
 		low = l / 4;
 		high = l * 3 / 4;
 	}
-	MOD_REG_FLD(ftrs_reg[plane], FLD_MASK(16, 9) | FLD_MASK(0, 9),
+	MOD_REG_FLD(ftrs_reg[plane], FLD_MASK(16, 12) | FLD_MASK(0, 12),
 			(high << 16) | low);
 }
 
@@ -1397,7 +1397,7 @@ static int omap_dispc_init(struct omapfb
 	}
 
 	/* Enable smart idle and autoidle */
-	l = dispc_read_reg(DISPC_CONTROL);
+	l = dispc_read_reg(DISPC_SYSCONFIG);
 	l &= ~((3 << 12) | (3 << 3));
 	l |= (2 << 12) | (2 << 3) | (1 << 0);
 	dispc_write_reg(DISPC_SYSCONFIG, l);
@@ -1409,7 +1409,7 @@ static int omap_dispc_init(struct omapfb
 	dispc_write_reg(DISPC_CONFIG, l);
 
 	l = dispc_read_reg(DISPC_IRQSTATUS);
-	dispc_write_reg(l, DISPC_IRQSTATUS);
+	dispc_write_reg(DISPC_IRQSTATUS, l);
 
 	/* Enable those that we handle always */
 	omap_dispc_enable_irqs(DISPC_IRQ_FRAMEMASK);
_

Patches currently in -mm which might be from imre.deak@nokia.com are

origin.patch
linux-next.patch
omapfb-add-support-for-the-apollon-lcd.patch
omapfb-add-support-for-mipi-dcs-compatible-lcds.patch
omapfb-add-support-for-the-amstrad-delta-lcd.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-3430sdp-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch
omapfb-add-support-for-the-gumstix-overo-lcd.patch
omapfb-add-support-for-the-zoom-mdk-lcd.patch
omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch
n770-enable-lcd-mipi-dcs-in-kconfig.patch
omapfb-dispc-various-typo-fixes.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-dispc-allow-multiple-external-irq-handlers.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch
omapfb-fix-coding-style-remove-dead-line.patch
omapfb-add-fb-manual-update-option-to-kconfig.patch
omapfb-hwa742-fix-pointer-to-be-const.patch

