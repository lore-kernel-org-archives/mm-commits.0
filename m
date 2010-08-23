From: akpm@linux-foundation.org
Subject: + rtc-bfin-fix-inverted-logic-in-suspend-path.patch added to -mm tree
Date: Mon, 23 Aug 2010 12:15:05 -0700
Message-ID: <201008231915.o7NJF50n009631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754307Ab0HWTPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 15:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it


The patch titled
     rtc-bfin: fix inverted logic in suspend path
has been added to the -mm tree.  Its filename is
     rtc-bfin-fix-inverted-logic-in-suspend-path.patch

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
Subject: rtc-bfin: fix inverted logic in suspend path
From: Mike Frysinger <vapier@gentoo.org>

The int_clear helper takes a bitmask of interrupts to keep, not to
disable.  When suspending without wakeup enabled, we want to disable
all interrupts, so use 0 (keep none) instead of -1 (keep all).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-bfin.c~rtc-bfin-fix-inverted-logic-in-suspend-path drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-bfin-fix-inverted-logic-in-suspend-path
+++ a/drivers/rtc/rtc-bfin.c
@@ -426,7 +426,7 @@ static int bfin_rtc_suspend(struct platf
 		enable_irq_wake(IRQ_RTC);
 		bfin_rtc_sync_pending(&pdev->dev);
 	} else
-		bfin_rtc_int_clear(-1);
+		bfin_rtc_int_clear(0);
 
 	return 0;
 }
_

Patches currently in -mm which might be from vapier@gentoo.org are

rtc-bfin-fix-inverted-logic-in-suspend-path.patch
rtc-bfin-fix-state-restoration-when-resuming.patch
linux-next.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patch
rtc-bfin-shrink-optimize-interrupt-handler-a-bit.patch
rtc-bfin-add-debug-markers-to-suspend-resume-paths.patch

