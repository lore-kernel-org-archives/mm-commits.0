From: akpm@linux-foundation.org
Subject: + libsas-dereferencing-variable-before-check.patch added to -mm tree
Date: Thu, 13 May 2010 13:11:20 -0700
Message-ID: <201005132011.o4DKBKR2017633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692Ab0EMUMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 16:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, James.Bottomley@HansenPartnership.com, tj@kernel.org


The patch titled
     libsas: dereferencing variable before check
has been added to the -mm tree.  Its filename is
     libsas-dereferencing-variable-before-check.patch

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
Subject: libsas: dereferencing variable before check
From: Dan Carpenter <error27@gmail.com>

The "qc->scsicmd" could be null so I moved the dereference inside the
check.  This was introduced by 70b25f890: "[SCSI] fix locking around
blk_abort_request()"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/libsas/sas_ata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/libsas/sas_ata.c~libsas-dereferencing-variable-before-check drivers/scsi/libsas/sas_ata.c
--- a/drivers/scsi/libsas/sas_ata.c~libsas-dereferencing-variable-before-check
+++ a/drivers/scsi/libsas/sas_ata.c
@@ -395,12 +395,13 @@ int sas_ata_init_host_and_port(struct do
 void sas_ata_task_abort(struct sas_task *task)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
-	struct request_queue *q = qc->scsicmd->device->request_queue;
+	struct request_queue *q;
 	struct completion *waiting;
 	unsigned long flags;
 
 	/* Bounce SCSI-initiated commands to the SCSI EH */
 	if (qc->scsicmd) {
+		q = qc->scsicmd->device->request_queue;
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_abort_request(qc->scsicmd->request);
 		spin_unlock_irqrestore(q->queue_lock, flags);
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
libsas-dereferencing-variable-before-check.patch
mm-document-follow_page.patch
include-linux-gfph-spelling-fixes.patch
include-linux-gfph-fix-coding-style.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch
fs-sysv-dereferencing-err_ptr.patch

