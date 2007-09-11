From: akpm@linux-foundation.org
Subject: + intel-fb-pixel-clock-calculation-fix.patch added to -mm tree
Date: Mon, 10 Sep 2007 22:42:52 -0700
Message-ID: <200709110542.l8B5gqTM027826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758275AbXIKFnK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 01:43:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khc@pm.waw.pl, adaplas@pol.net, akpm@linux-foundation.org


The patch titled
     Subject: [PATCH] Intel FB pixel clock calculation fix
has been added to the -mm tree.  Its filename is
     intel-fb-pixel-clock-calculation-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: [PATCH] Intel FB pixel clock calculation fix
From: Krzysztof Halasa <khc@pm.waw.pl>

Intel framebuffer mis-calculated pixel clocks.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/intelfb/intelfbhw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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

intel-fb-pixel-clock-calculation-fix.patch
