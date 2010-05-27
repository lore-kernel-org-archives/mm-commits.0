From: akpm@linux-foundation.org
Subject: + tty-n_gsm-potential-double-lock.patch added to -mm tree
Date: Thu, 27 May 2010 14:02:45 -0700
Message-ID: <201005272102.o4RL2jtk013900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227Ab0E0VCt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 May 2010 17:02:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, alan@linux.intel.com, greg@kroah.com


The patch titled
     tty/n_gsm: potential double lock
has been added to the -mm tree.  Its filename is
     tty-n_gsm-potential-double-lock.patch

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
Subject: tty/n_gsm: potential double lock
From: Dan Carpenter <error27@gmail.com>

In gsm_dlci_data_kick() we call gsm_dlci_data_sweep() with the
"gsm->tx_lock" held so we can't lock it again inside
gsm_dlci_data_sweep().  I removed that lock from and added one to
gsmld_write_wakeup() instead.  The sweep function is only called from
those two places.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/n_gsm.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/char/n_gsm.c~tty-n_gsm-potential-double-lock drivers/char/n_gsm.c
--- a/drivers/char/n_gsm.c~tty-n_gsm-potential-double-lock
+++ a/drivers/char/n_gsm.c
@@ -904,9 +904,7 @@ static void gsm_dlci_data_sweep(struct g
 	int len;
 	/* Priority ordering: We should do priority with RR of the groups */
 	int i = 1;
-	unsigned long flags;
 
-	spin_lock_irqsave(&gsm->tx_lock, flags);
 	while (i < NUM_DLCI) {
 		struct gsm_dlci *dlci;
 
@@ -927,7 +925,6 @@ static void gsm_dlci_data_sweep(struct g
 		if (len == 0)
 			i++;
 	}
-	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**
@@ -2230,12 +2227,16 @@ static int gsmld_open(struct tty_struct 
 static void gsmld_write_wakeup(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	gsm_data_kick(gsm);
-	if (gsm->tx_bytes < TX_THRESH_LO)
+	if (gsm->tx_bytes < TX_THRESH_LO) {
+		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_dlci_data_sweep(gsm);
+		spin_unlock_irqrestore(&gsm->tx_lock, flags);
+	}
 }
 
 /**
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
proc-cleanup-remove-unused-assignments.patch
linux-next.patch
tty-n_gsm-potential-double-lock.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
padata-add-parenthesis-in-max_seq_nr-macro.patch

