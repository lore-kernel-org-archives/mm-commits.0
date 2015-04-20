From: akpm@linux-foundation.org
Subject: [merged] bfs-bfad_worker-cleanup.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:20:16 -0700
Message-ID: <55355170.hlOMH2gdIOk05psk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbbDTTNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, anil.gurumurthy@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bfs: bfad_worker cleanup
has been removed from the -mm tree.  Its filename was
     bfs-bfad_worker-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: bfs: bfad_worker cleanup

This kthread is not loop at all due to break at the end of the loop.  Make
that function linear, with no while loop.

And remove an unnecessary cast.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfad.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/bfa/bfad.c~bfs-bfad_worker-cleanup drivers/scsi/bfa/bfad.c
--- a/drivers/scsi/bfa/bfad.c~bfs-bfad_worker-cleanup
+++ a/drivers/scsi/bfa/bfad.c
@@ -1079,22 +1079,18 @@ bfad_start_ops(struct bfad_s *bfad) {
 int
 bfad_worker(void *ptr)
 {
-	struct bfad_s *bfad;
-	unsigned long   flags;
+	struct bfad_s *bfad = ptr;
+	unsigned long flags;
 
-	bfad = (struct bfad_s *)ptr;
+	if (kthread_should_stop())
+		return 0;
 
-	while (!kthread_should_stop()) {
+	/* Send event BFAD_E_INIT_SUCCESS */
+	bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
 
-		/* Send event BFAD_E_INIT_SUCCESS */
-		bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
-
-		spin_lock_irqsave(&bfad->bfad_lock, flags);
-		bfad->bfad_tsk = NULL;
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
