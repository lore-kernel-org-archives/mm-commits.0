From: akpm@osdl.org
Subject: - mmc-fix-prev-state-2-=-task_running-problem-on-sd-mmc-card-removal.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:42 -0800
Message-ID: <200612130656.kBD6ugE6030750@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57987 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965061AbWLMG4s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vitalywool@gmail.com, drzeus-list@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: fix "prev->state: 2 != TASK_RUNNING??" problem on SD/MMC  card removal
has been removed from the -mm tree.  Its filename was
     mmc-fix-prev-state-2-=-task_running-problem-on-sd-mmc-card-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mmc: fix "prev->state: 2 != TASK_RUNNING??" problem on SD/MMC  card removal
From: Vitaly Wool <vitalywool@gmail.com>

Currently on SD/MMC card removal the system exhibits the following message (the platform is ARM Versatile):

    prev->state: 2 != TASK_RUNNING??
    mmcqd/762[CPU#0]: BUG in __schedule at linux-2.6/kernel/sched.c:3826

(akpm: someone tried to fix this, but it's still wrong)

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/mmc_queue.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/mmc_queue.c~mmc-fix-prev-state-2-=-task_running-problem-on-sd-mmc-card-removal drivers/mmc/mmc_queue.c
--- a/drivers/mmc/mmc_queue.c~mmc-fix-prev-state-2-=-task_running-problem-on-sd-mmc-card-removal
+++ a/drivers/mmc/mmc_queue.c
@@ -78,8 +78,10 @@ static int mmc_queue_thread(void *d)
 		spin_unlock_irq(q->queue_lock);
 
 		if (!req) {
-			if (kthread_should_stop())
+			if (kthread_should_stop()) {
+				set_current_state(TASK_RUNNING);
 				break;
+			}
 			up(&mq->thread_sem);
 			schedule();
 			down(&mq->thread_sem);
_

Patches currently in -mm which might be from vitalywool@gmail.com are

origin.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch

