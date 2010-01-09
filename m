From: akpm@linux-foundation.org
Subject: + scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch added to -mm tree
Date: Fri, 08 Jan 2010 16:33:18 -0800
Message-ID: <201001090033.o090XI1P023828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754058Ab0AIAdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 19:33:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, corbet@lwn.net, error27@gmail.com, eteo@redhat.com


The patch titled
     scsi: remove superfluous NULL pointer check from scsi_kill_request()
has been added to the -mm tree.  Its filename is
     scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch

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
Subject: scsi: remove superfluous NULL pointer check from scsi_kill_request()
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Dan's list included:

drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced in initializer 'cmd'
drivers/scsi/scsi_lib.c +1365 scsi_kill_request(9) warning: variable derefenced before check 'cmd'

We dereference cmd (and possible OOPS if cmd == NULL) before starting the
request so just remove the superfluous debugging code altogether.

[ bart: the potential NULL pointer dereference was finally fixed in
  (much later than mine) commit 03b1470 but my patch is still valid ]

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Eugene Teo <eteo@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request
+++ a/drivers/scsi/scsi_lib.c
@@ -1366,12 +1366,6 @@ static void scsi_kill_request(struct req
 
 	blk_start_request(req);
 
-	if (unlikely(cmd == NULL)) {
-		printk(KERN_CRIT "impossible request in %s.\n",
-				 __func__);
-		BUG();
-	}
