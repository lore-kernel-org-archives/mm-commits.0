From: akpm@linux-foundation.org
Subject: + mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock.patch added to -mm tree
Date: Thu, 25 Aug 2011 15:03:25 -0700
Message-ID: <201108252203.p7PM3PqD014138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755568Ab1HYWDx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Aug 2011 18:03:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khoroshilov@ispras.ru, kashyap.desai@lsi.com


The patch titled
     drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock
has been added to the -mm tree.  Its filename is
     mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock.patch

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
Subject: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock
From: Alexey Khoroshilov <khoroshilov@ispras.ru>

If ioc->pci_error_recovery is set, goto out in
mpt2sas_base_hard_reset_handler() leads to unlock unheld
ioc->reset_in_progress_mutex.

Fix the issue by jumping afer mutex_unlock() call.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock drivers/scsi/mpt2sas/mpt2sas_base.c
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c~mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock
+++ a/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4130,7 +4130,7 @@ mpt2sas_base_hard_reset_handler(struct M
 		printk(MPT2SAS_ERR_FMT "%s: pci error recovery reset\n",
 		    ioc->name, __func__);
 		r = 0;
-		goto out;
+		goto out_unlocked;
 	}
 
 	if (mpt2sas_fwfault_debug)
@@ -4186,6 +4186,7 @@ mpt2sas_base_hard_reset_handler(struct M
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	mutex_unlock(&ioc->reset_in_progress_mutex);
 
+ out_unlocked:
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 	    __func__));
 	return r;
_

Patches currently in -mm which might be from khoroshilov@ispras.ru are

linux-next.patch
mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock.patch

