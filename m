From: akpm@linux-foundation.org
Subject: + jffs2-use-cond_resched-instead-of-yield.patch added to -mm tree
Date: Thu, 16 Sep 2010 15:53:58 -0700
Message-ID: <201009162253.o8GMrwlm018646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146Ab0IPWy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 18:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: w.sang@pengutronix.de, Artem.Bityutskiy@nokia.com, dedekind@infradead.org, dwmw2@infradead.org, mingo@elte.hu


The patch titled
     jffs2: use cond_resched() instead of yield()
has been added to the -mm tree.  Its filename is
     jffs2-use-cond_resched-instead-of-yield.patch

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
Subject: jffs2: use cond_resched() instead of yield()
From: Wolfram Sang <w.sang@pengutronix.de>

yield() has different semantics meanwhile and even causes RT-kernels to
BUG.  Replace the only appearance left in jffs2.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/erase.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jffs2/erase.c~jffs2-use-cond_resched-instead-of-yield fs/jffs2/erase.c
--- a/fs/jffs2/erase.c~jffs2-use-cond_resched-instead-of-yield
+++ a/fs/jffs2/erase.c
@@ -151,7 +151,7 @@ int jffs2_erase_pending_blocks(struct jf
 		}
 
 		/* Be nice */
-		yield();
+		cond_resched();
 		mutex_lock(&c->erase_free_sem);
 		spin_lock(&c->erase_completion_lock);
 	}
_

Patches currently in -mm which might be from w.sang@pengutronix.de are

origin.patch
linux-next.patch
jffs2-use-cond_resched-instead-of-yield.patch
sdhci-turn-timeout-timer-into-delayed-work.patch
sdhci-use-work-structs-instead-of-tasklets.patch
sdhci-use-work-structs-instead-of-tasklets-fix.patch
sdhci-clear-interrupt-status-register-just-once.patch
sdhci-use-threaded-irq-handler.patch
sdhci-turn-host-lock-into-a-mutex.patch
sdhci-get-rid-of-card-detect-work.patch
sdhci-get-rid-of-card-detect-work-fix.patch
sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
sdhci-use-jiffies-instead-of-a-timeout-counter.patch
rtc-rtc-lpc32xx-introduce-rtc-driver-for-the-lpc32xx-soc-v4.patch

