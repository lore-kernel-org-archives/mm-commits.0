From: akpm@linux-foundation.org
Subject: [merged] mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:11 -0800
Message-ID: <20120227222912.3E6B5A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:46454 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2B0W3O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:14 -0500
Received: by wgbdt11 with SMTP id dt11so67256wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khoroshilov@ispras.ru, kashyap.desai@lsi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock
has been removed from the -mm tree.  Its filename was
     mpt2sas-fix-mismatch-in-mpt2sas_base_hard_reset_handler-mutex-lock-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: drivers/scsi/mpt2sas/mpt2sas_base.c: fix mismatch in mpt2sas_base_hard_reset_handler() mutex lock-unlock

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
@@ -4548,7 +4548,7 @@ mpt2sas_base_hard_reset_handler(struct M
 		printk(MPT2SAS_ERR_FMT "%s: pci error recovery reset\n",
 		    ioc->name, __func__);
 		r = 0;
-		goto out;
+		goto out_unlocked;
 	}
 
 	if (mpt2sas_fwfault_debug)
@@ -4604,6 +4604,7 @@ mpt2sas_base_hard_reset_handler(struct M
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 	mutex_unlock(&ioc->reset_in_progress_mutex);
 
+ out_unlocked:
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: exit\n", ioc->name,
 	    __func__));
 	return r;
_

Patches currently in -mm which might be from khoroshilov@ispras.ru are

origin.patch

