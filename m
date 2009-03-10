From: akpm@linux-foundation.org
Subject: [merged] mmc-core-corec-fixed-delayed_work-was-never-cancelled.patch removed from -mm tree
Date: Tue, 10 Mar 2009 11:26:46 -0700
Message-ID: <200903101826.n2AIQkFL022668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754749AbZCJS1z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 14:27:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ext-jorg.2.schummer@nokia.com, mm-commits@vger.kernel.org


The patch titled
     mmc: core/core.c: delayed_work was never cancelled
has been removed from the -mm tree.  Its filename was
     mmc-core-corec-fixed-delayed_work-was-never-cancelled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

