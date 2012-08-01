From: akpm@linux-foundation.org
Subject: + cs5535-clockevt-typo-its-mfgpt-not-mfpgt.patch added to -mm tree
Date: Wed, 01 Aug 2012 14:06:23 -0700
Message-ID: <20120801210624.1048B5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:41960 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936Ab2HAVG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 17:06:26 -0400
Received: by lagr15 with SMTP id r15so345100lag.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 14:06:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JRottmann@LiPPERTEmbedded.de, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     Subject: cs5535-clockevt: typo, it's MFGPT, not MFPGT
has been added to the -mm tree.  Its filename is
     cs5535-clockevt-typo-its-mfgpt-not-mfpgt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Subject: cs5535-clockevt: typo, it's MFGPT, not MFPGT

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-typo-its-mfgpt-not-mfpgt drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-typo-its-mfgpt-not-mfpgt
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -53,7 +53,7 @@ static struct cs5535_mfgpt_timer *cs5535
 #define MFGPT_PERIODIC (MFGPT_HZ / HZ)
 
 /*
- * The MFPGT timers on the CS5536 provide us with suitable timers to use
+ * The MFGPT timers on the CS5536 provide us with suitable timers to use
  * as clock event sources - not as good as a HPET or APIC, but certainly
  * better than the PIT.  This isn't a general purpose MFGPT driver, but
  * a simplified one designed specifically to act as a clock event source.
@@ -144,7 +144,7 @@ static int __init cs5535_mfgpt_init(void
 
 	timer = cs5535_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 	if (!timer) {
-		printk(KERN_ERR DRV_NAME ": Could not allocate MFPGT timer\n");
+		printk(KERN_ERR DRV_NAME ": Could not allocate MFGPT timer\n");
 		return -ENODEV;
 	}
 	cs5535_event_clock = timer;
_

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

cs5535-clockevt-typo-its-mfgpt-not-mfpgt.patch

