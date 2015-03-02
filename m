From: akpm@linux-foundation.org
Subject: + bfs-bfad_worker-cleanup.patch added to -mm tree
Date: Mon, 02 Mar 2015 14:17:30 -0800
Message-ID: <54f4e17a.iXLiVLWo4Dn+N8Le%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbbCBWRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2015 17:17:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, anil.gurumurthy@qlogic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bfs: bfad_worker cleanup
has been added to the -mm tree.  Its filename is
     bfs-bfad_worker-cleanup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bfs-bfad_worker-cleanup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bfs-bfad_worker-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
