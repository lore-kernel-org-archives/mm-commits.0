From: akpm@linux-foundation.org
Subject: [merged] omapfb-dispc-various-typo-fixes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:00:36 -0700
Message-ID: <200909232000.n8NK0arR013481@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbZIWUBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:01:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@nokia.com, arunedarath@mistralsolutions.com, balrog@zabor.org, ext-kalle.jokiniemi@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omapfb: dispc: various typo fixes
has been removed from the -mm tree.  Its filename was
     omapfb-dispc-various-typo-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

