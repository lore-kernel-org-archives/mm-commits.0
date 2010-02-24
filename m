From: akpm@linux-foundation.org
Subject: [merged] geode-mfgpt-restore-previous-behavior-for-selecting-irq.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:39:34 -0800
Message-ID: <201002241939.o1OJdYwr016305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757862Ab0BXTka (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JRottmann@LiPPERTEmbedded.de, dilinger@collabora.co.uk, johnstul@us.ibm.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     geode-mfgpt: restore previous behavior for selecting IRQ
has been removed from the -mm tree.  Its filename was
     geode-mfgpt-restore-previous-behavior-for-selecting-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: geode-mfgpt: restore previous behavior for selecting IRQ
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

geode-mfgpt: restore previous behavior for selecting IRQ

The MFGPT IRQ used to be, in order of decreasing priority,
* IRQ supplied by the user as a boot-time parameter,
* IRQ previously set by the BIOS or another driver,
* default IRQ given at compile time.

Return to this behavior, which got broken when splitting the
MFGPT/clocksource driver for 2.6.33-rc1.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/clocksource/cs5535-clockevt.c~geode-mfgpt-restore-previous-behavior-for-selecting-irq drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~geode-mfgpt-restore-previous-behavior-for-selecting-irq
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -21,7 +21,7 @@
 
 #define DRV_NAME "cs5535-clockevt"
 
-static int timer_irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;
+static int timer_irq;
 module_param_named(irq, timer_irq, int, 0644);
 MODULE_PARM_DESC(irq, "Which IRQ to use for the clock source MFGPT ticks.");
 
_

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

origin.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch

