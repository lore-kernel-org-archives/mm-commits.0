From: akpm@linux-foundation.org
Subject: + cs5535-mfgpt-reuse-timers-that-have-never-been-set-up.patch added to -mm tree
Date: Thu, 15 Jul 2010 13:09:24 -0700
Message-ID: <201007152009.o6FK9Odt016638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934620Ab0GOUKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 16:10:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JRottmann@LiPPERTEmbedded.de, dilinger@queued.net, jordan@cosmicpenguin.net, tglx@linutronix.de


The patch titled
     cs5535-mfgpt: reuse timers that have never been set up
has been added to the -mm tree.  Its filename is
     cs5535-mfgpt-reuse-timers-that-have-never-been-set-up.patch

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
Subject: cs5535-mfgpt: reuse timers that have never been set up
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

The MFGPT hardware may be set up only once, therefore
cs5535_mfgpt_free_timer() didn't re-set the timer's "avail" bit.  However
if a timer is freed before it has actually been in use then it may be made
available again.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Acked-by: Andres Salomon <dilinger@queued.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/cs5535-mfgpt.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN drivers/misc/cs5535-mfgpt.c~cs5535-mfgpt-reuse-timers-that-have-never-been-set-up drivers/misc/cs5535-mfgpt.c
--- a/drivers/misc/cs5535-mfgpt.c~cs5535-mfgpt-reuse-timers-that-have-never-been-set-up
+++ a/drivers/misc/cs5535-mfgpt.c
@@ -211,6 +211,17 @@ EXPORT_SYMBOL_GPL(cs5535_mfgpt_alloc_tim
  */
 void cs5535_mfgpt_free_timer(struct cs5535_mfgpt_timer *timer)
 {
+	unsigned long flags;
+	uint16_t val;
+
+	/* timer can be made available again only if never set up */
+	val = cs5535_mfgpt_read(timer, MFGPT_REG_SETUP);
+	if (!(val & MFGPT_SETUP_SETUP)) {
+		spin_lock_irqsave(&timer->chip->lock, flags);
+		__set_bit(timer->nr, timer->chip->avail);
+		spin_unlock_irqrestore(&timer->chip->lock, flags);
+	}
+
 	kfree(timer);
 }
 EXPORT_SYMBOL_GPL(cs5535_mfgpt_free_timer);
_

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

cs5535-mfgpt-reuse-timers-that-have-never-been-set-up.patch

