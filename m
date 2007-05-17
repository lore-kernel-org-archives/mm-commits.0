From: akpm@linux-foundation.org
Subject: + aic94xx-asd_clear_nexus-should-fail-if-the-cleared-task-does-not-complete.patch added to -mm tree
Date: Thu, 17 May 2007 11:55:51 -0700
Message-ID: <200705171855.l4HItpTD030474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXEQS7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:59:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, Dennis_Tan@adaptec.com, Gilbert_Wu@adaptec.com, alexisb@us.ibm.com, ed_chim@adaptec.com


The patch titled
     aic94xx: asd_clear_nexus should fail if the cleared task does not complete
has been added to the -mm tree.  Its filename is
     aic94xx-asd_clear_nexus-should-fail-if-the-cleared-task-does-not-complete.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aic94xx: asd_clear_nexus should fail if the cleared task does not complete
From: "Darrick J. Wong" <djwong@us.ibm.com>

Every so often, the driver will call asd_clear_nexus to clean out a task. 
It is supposed to be the case that the CLEAR NEXUS does not go on the done
list until after the task itself has been put on the done list, but for
some reason this doesn't always happen.  Thus, the
wait_for_completion_timeout call times out, and we return success.  This
makes libsas free the task even though the task hasn't completed, leading
to a BUG_ON message from aic94xx_hwi.c around line 341.

We should return failure from asd_clear_nexus so that libsas tries again;
at a bare minimum it shouldn't be freeing active tasks.  I _think_ this
will fix one of the SCB timeout crash problems (though I've not been able
to reproduce it lately...)

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: "Tan, Dennis" <Dennis_Tan@adaptec.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: "Chim, Ed" <ed_chim@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_tmf.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_tmf.c~aic94xx-asd_clear_nexus-should-fail-if-the-cleared-task-does-not-complete drivers/scsi/aic94xx/aic94xx_tmf.c
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c~aic94xx-asd_clear_nexus-should-fail-if-the-cleared-task-does-not-complete
+++ a/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -290,6 +290,7 @@ static void asd_tmf_tasklet_complete(str
 static inline int asd_clear_nexus(struct sas_task *task)
 {
 	int res = TMF_RESP_FUNC_FAILED;
+	int leftover;
 	struct asd_ascb *tascb = task->lldd_task;
 	unsigned long flags;
 
@@ -298,10 +299,12 @@ static inline int asd_clear_nexus(struct
 		res = asd_clear_nexus_tag(task);
 	else
 		res = asd_clear_nexus_index(task);
-	wait_for_completion_timeout(&tascb->completion,
-				    AIC94XX_SCB_TIMEOUT);
+	leftover = wait_for_completion_timeout(&tascb->completion,
+					       AIC94XX_SCB_TIMEOUT);
 	ASD_DPRINTK("came back from clear nexus\n");
 	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (leftover < 1)
+		res = TMF_RESP_FUNC_FAILED;
 	if (task->task_state_flags & SAS_TASK_STATE_DONE)
 		res = TMF_RESP_FUNC_COMPLETE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -350,6 +353,7 @@ int asd_abort_task(struct sas_task *task
 	unsigned long flags;
 	struct asd_ascb *ascb = NULL;
 	struct scb *scb;
+	int leftover;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
@@ -455,9 +459,11 @@ int asd_abort_task(struct sas_task *task
 		break;
 	case TF_TMF_TASK_DONE + 0xFF00:	/* done but not reported yet */
 		res = TMF_RESP_FUNC_FAILED;
-		wait_for_completion_timeout(&tascb->completion,
-					    AIC94XX_SCB_TIMEOUT);
+		leftover = wait_for_completion_timeout(&tascb->completion,
+						       AIC94XX_SCB_TIMEOUT);
 		spin_lock_irqsave(&task->task_state_lock, flags);
+		if (leftover < 1)
+			res = TMF_RESP_FUNC_FAILED;
 		if (task->task_state_flags & SAS_TASK_STATE_DONE)
 			res = TMF_RESP_FUNC_COMPLETE;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

aic94xx-asd_clear_nexus-should-fail-if-the-cleared-task-does-not-complete.patch
