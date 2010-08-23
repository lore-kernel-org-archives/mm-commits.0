From: akpm@linux-foundation.org
Subject: + rtc-bfin-fix-state-restoration-when-resuming.patch added to -mm tree
Date: Mon, 23 Aug 2010 12:15:07 -0700
Message-ID: <201008231915.o7NJF7iK009634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754321Ab0HWTPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 15:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, a.zummo@towertech.it, mdean@aeronix.com, michael.hennerich@analog.com


The patch titled
     rtc-bfin: fix state restoration when resuming
has been added to the -mm tree.  Its filename is
     rtc-bfin-fix-state-restoration-when-resuming.patch

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
Subject: rtc-bfin: fix state restoration when resuming
From: Mike Frysinger <vapier@gentoo.org>

Much (but not all) of the RTC state is kept in the RTC peripheral which
has its own power domain.  Periodically (1 HZ), that state is synced from
one power domain to the other (peripheral->core).  When we are resuming,
we need to wait for the sync to occur so that we don't get a mismatch of
reading undefined state in the rest of the driver.

Further, once the externally maintained bits have been synced back into
the core, we then need to restore the bits maintained in the core.  In our
particular case, that is just the write completion interrupt bit.

If we don't do any of this, working with the RTC causes ~5 second delays
from time to time after waking up due to the write completion interrupt
never firing.

Reported-by: Michael Dean <mdean@aeronix.com>
Reported-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-bfin.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-bfin.c~rtc-bfin-fix-state-restoration-when-resuming drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-bfin-fix-state-restoration-when-resuming
+++ a/drivers/rtc/rtc-bfin.c
@@ -435,8 +435,17 @@ static int bfin_rtc_resume(struct platfo
 {
 	if (device_may_wakeup(&pdev->dev))
 		disable_irq_wake(IRQ_RTC);
-	else
-		bfin_write_RTC_ISTAT(-1);
+
+	/*
+	 * Since only some of the RTC bits are maintained externally in the
+	 * Vbat domain, we need to wait for the RTC MMRs to be synced into
+	 * the core after waking up.  This happens every RTC 1HZ.  Once that
+	 * has happened, we can go ahead and re-enable the important write
+	 * complete interrupt event.
+	 */
+	while (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_SEC))
+		continue;
+	bfin_rtc_int_set(RTC_ISTAT_WRITE_COMPLETE);
 
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

