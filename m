From: akpm@linux-foundation.org
Subject: [merged] matroxfb-fix-problems-with-display-stability.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:27 -0800
Message-ID: <200912162036.nBGKaRkQ013172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964828AbZLPUhp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@linux.intel.com, VANDROVE@vc.cvut.cz, account@bugzilla.kernel.org.juxtaposition.net, pc@us.ibm.com, penberg@cs.helsinki.fi, rvm1974@raketnet.nl, stable@kernel.org, mm-commits@vge


The patch titled
     matroxfb: fix problems with display stability
has been removed from the -mm tree.  Its filename was
     matroxfb-fix-problems-with-display-stability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matroxfb: fix problems with display stability
From: Alan Cox <alan@linux.intel.com>

Regression caused in 2.6.23 and then despite repeated requests never fixed
or dealt with (Petr promised to sort it in 2008 but seems to have
forgotten).

Enough is enough - remove the problem line that was added.  If it upsets
someone they've had two years to deal with it and at the very least it'll
rattle their cage and wake them up.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9709

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Damon <account@bugzilla.kernel.org.juxtaposition.net>
Tested-by: Ruud van Melick <rvm1974@raketnet.nl>
Cc: Petr Vandrovec <VANDROVE@vc.cvut.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul A. Clarke <pc@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/g450_pll.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/matrox/g450_pll.c~matroxfb-fix-problems-with-display-stability drivers/video/matrox/g450_pll.c
--- a/drivers/video/matrox/g450_pll.c~matroxfb-fix-problems-with-display-stability
+++ a/drivers/video/matrox/g450_pll.c
@@ -368,7 +368,8 @@ static int __g450_setclk(struct matrox_f
 					M1064_XDVICLKCTRL_C1DVICLKEN |
 					M1064_XDVICLKCTRL_DVILOOPCTL |
 					M1064_XDVICLKCTRL_P1LOOPBWDTCTL;
-				matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp);
+                                /* Setting this breaks PC systems so don't do it */
+				/* matroxfb_DAC_out(minfo, M1064_XDVICLKCTRL, tmp); */
 				matroxfb_DAC_out(minfo, M1064_XPWRCTRL,
 						 xpwrctrl);
 
_

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
8250-add-serial-transmitter-fully-empty-test.patch
imx-bit-confusion.patch
char-cyclades-fix-compiler-warning.patch
revert-tty-sdio_uart-use-kfifo-instead-of-the-messy-circ-stuff.patch

