From: akpm@linux-foundation.org
Subject: + mmc-core-corec-fixed-delayed_work-was-never-cancelled.patch added to -mm tree
Date: Fri, 20 Feb 2009 13:34:32 -0800
Message-ID: <200902202134.n1KLYW5H001196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbZBTVfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 16:35:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-jorg.2.schummer@nokia.com


The patch titled
     mmc: core/core.c: delayed_work was never cancelled
has been added to the -mm tree.  Its filename is
     mmc-core-corec-fixed-delayed_work-was-never-cancelled.patch

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
Subject: mmc: core/core.c: delayed_work was never cancelled
From: Jorg Schummer <ext-jorg.2.schummer@nokia.com>

The delayed work item mmc_host.detect is now cancelled before flushing the
work queue.  This takes care of cases when delayed_work was scheduled for
mmc_host.detect, but not yet placed in the work queue.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/mmc/core/core.c~mmc-core-corec-fixed-delayed_work-was-never-cancelled drivers/mmc/core/core.c
--- a/drivers/mmc/core/core.c~mmc-core-corec-fixed-delayed_work-was-never-cancelled
+++ a/drivers/mmc/core/core.c
@@ -815,6 +815,7 @@ void mmc_stop_host(struct mmc_host *host
 	spin_unlock_irqrestore(&host->lock, flags);
 #endif
 
+	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
@@ -842,6 +843,7 @@ void mmc_stop_host(struct mmc_host *host
  */
 int mmc_suspend_host(struct mmc_host *host, pm_message_t state)
 {
+	cancel_delayed_work(&host->detect);
 	mmc_flush_scheduled_work();
 
 	mmc_bus_get(host);
_

Patches currently in -mm which might be from ext-jorg.2.schummer@nokia.com are

mmc-core-corec-fixed-delayed_work-was-never-cancelled.patch

