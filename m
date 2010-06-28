From: akpm@linux-foundation.org
Subject: + scsi-mvsas-fix-potential-null-dereference.patch added to -mm tree
Date: Mon, 28 Jun 2010 12:20:57 -0700
Message-ID: <201006281920.o5SJKvgm026082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab0F1TVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jun 2010 15:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, James.Bottomley@suse.de, satyasrinivasp@hcl.in


The patch titled
     drivers/scsi/mvsas/mv_sas.c: fix potential NULL dereference
has been added to the -mm tree.  Its filename is
     scsi-mvsas-fix-potential-null-dereference.patch

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
Subject: drivers/scsi/mvsas/mv_sas.c: fix potential NULL dereference
From: Jiri Slaby <jslaby@suse.cz>

Stanse found that in mvs_abort_task, mvi_dev is dereferenced earlier than
tested for being NULL.  Move the assignment below the test.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Srinivas <satyasrinivasp@hcl.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mvsas/mv_sas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mvsas/mv_sas.c~scsi-mvsas-fix-potential-null-dereference drivers/scsi/mvsas/mv_sas.c
--- a/drivers/scsi/mvsas/mv_sas.c~scsi-mvsas-fix-potential-null-dereference
+++ a/drivers/scsi/mvsas/mv_sas.c
@@ -1640,7 +1640,7 @@ int mvs_abort_task(struct sas_task *task
 	struct mvs_tmf_task tmf_task;
 	struct domain_device *dev = task->dev;
 	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
+	struct mvs_info *mvi;
 	int rc = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
 	u32 tag;
@@ -1650,6 +1650,8 @@ int mvs_abort_task(struct sas_task *task
 		rc = TMF_RESP_FUNC_FAILED;
 	}
 
+	mvi = mvi_dev->mvi_info;
+
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix.patch
cpuidle-avoid-using-smp_processor_id-in-preemptible-code-nr_iowait_cpu-v4-fix-fix-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix-sleep-inside-atomic.patch
scsi-mvsas-fix-potential-null-dereference.patch
vfs-attr-check-attr_size-in-ia_valid-not-ia_mode.patch
vfs-use-kmalloc-to-allocate-fdmem-if-possible.patch

