From: akpm@linux-foundation.org
Subject: + omapfb-dispc-enable-wake-up-capability.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:12 -0700
Message-ID: <200906250008.n5P08CRL005065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbZFYAIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jouni.hogander@nokia.com, imre.deak@nokia.com, krzysztof.h1@wp.pl, tony@atomide.com


The patch titled
     omapfb: dispc: enable wake up capability
has been added to the -mm tree.  Its filename is
     omapfb-dispc-enable-wake-up-capability.patch

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
Subject: omapfb: dispc: enable wake up capability
From: Jouni Hogander <jouni.hogander@nokia.com>

Without wakeup enable omap doesn't wake up on dispc interrupts.  This
causes problems in a case where mpu is in sleep state and dispc interrupt
fires.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/omap/dispc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/omap/dispc.c~omapfb-dispc-enable-wake-up-capability drivers/video/omap/dispc.c
--- a/drivers/video/omap/dispc.c~omapfb-dispc-enable-wake-up-capability
+++ a/drivers/video/omap/dispc.c
@@ -1395,10 +1395,10 @@ static int omap_dispc_init(struct omapfb
 		enable_digit_clocks(0);
 	}
 
-	/* Enable smart idle and autoidle */
+	/* Enable smart standby/idle, autoidle and wakeup */
 	l = dispc_read_reg(DISPC_SYSCONFIG);
 	l &= ~((3 << 12) | (3 << 3));
-	l |= (2 << 12) | (2 << 3) | (1 << 0);
+	l |= (2 << 12) | (2 << 3) | (1 << 2) | (1 << 0);
 	dispc_write_reg(DISPC_SYSCONFIG, l);
 	omap_writel(1 << 0, DSS_BASE + DSS_SYSCONFIG);
 
_

Patches currently in -mm which might be from jouni.hogander@nokia.com are

origin.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch

