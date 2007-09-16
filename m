From: akpm@linux-foundation.org
Subject: - intel-fb-pixel-clock-calculation-fix.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:26:29 -0700
Message-ID: <200709160926.l8G9QTVM009187@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbXIPJic (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:38:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khc@pm.waw.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     Subject: [PATCH] Intel FB pixel clock calculation fix
has been removed from the -mm tree.  Its filename was
     intel-fb-pixel-clock-calculation-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Subject: [PATCH] Intel FB pixel clock calculation fix
From: Krzysztof Halasa <khc@pm.waw.pl>

Intel framebuffer mis-calculated pixel clocks.

The pixel clock (and thus both H and V sync) will be slower than requested, so
if you set the minimum allowed the display may not sync.  In case of really
old CRT display it could theoretically damage it.

I'm using it with PAL TV (using RGB input - SCART connector) and the bug
prevented it from working at all (TV requirements are more strict and made the
bug visible).

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbhw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/intelfb/intelfbhw.c~intel-fb-pixel-clock-calculation-fix drivers/video/intelfb/intelfbhw.c
--- a/drivers/video/intelfb/intelfbhw.c~intel-fb-pixel-clock-calculation-fix
+++ a/drivers/video/intelfb/intelfbhw.c
@@ -924,10 +924,10 @@ calc_pll_params(int index, int clock, u3
 			if (m > pll->max_m)
 				m = pll->max_m - 1;
 			for (testm = m - 1; testm <= m; testm++) {
-				f_out = calc_vclock3(index, m, n, p);
+				f_out = calc_vclock3(index, testm, n, p);
 				if (splitm(index, testm, &m1, &m2)) {
-					WRN_MSG("cannot split m = %d\n", m);
-					n++;
+					WRN_MSG("cannot split m = %d\n",
+						testm);
 					continue;
 				}
 				if (clock > f_out)
_

Patches currently in -mm which might be from khc@pm.waw.pl are

origin.patch
ath5k-panic-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
