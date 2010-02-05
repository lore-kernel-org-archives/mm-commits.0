From: akpm@linux-foundation.org
Subject: + geode-mfgpt-restore-previous-behavior-for-selecting-irq.patch added to -mm tree
Date: Fri, 05 Feb 2010 06:17:16 -0800
Message-ID: <201002051417.o15EHG08001801@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932965Ab0BEOS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 09:18:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JRottmann@LiPPERTEmbedded.de, dilinger@collabora.co.uk, johnstul@us.ibm.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     geode-mfgpt: restore previous behavior for selecting IRQ
has been added to the -mm tree.  Its filename is
     geode-mfgpt-restore-previous-behavior-for-selecting-irq.patch

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

geode-mfgpt-restore-previous-behavior-for-selecting-irq.patch

