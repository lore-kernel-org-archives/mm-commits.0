From: akpm@linux-foundation.org
Subject: + scsi-fix-proc-memory-leak-in-the-scsi-core-2.patch added to -mm tree
Date: Wed, 04 Mar 2009 13:04:31 -0800
Message-ID: <200903042104.n24L4V7q002565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752773AbZCDVFG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:05:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: fix /proc memory leak in the SCSI core
has been added to the -mm tree.  Its filename is
     scsi-fix-proc-memory-leak-in-the-scsi-core-2.patch

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
Subject: scsi: fix /proc memory leak in the SCSI core
From: Alan Stern <stern@rowland.harvard.edu>

The SCSI core calls scsi_proc_hostdir_add() from within
scsi_host_alloc(), but the corresponding scsi_proc_hostdir_rm() routine
is called from within scsi_remove_host().  As a result, if a host is
allocated and then deallocated without ever being registered, the
host's directory in /proc is leaked.

This patch (as1181b) fixes this bug in the SCSI core by moving
scsi_proc_hostdir_rm() into scsi_host_dev_release().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/hosts.c~scsi-fix-proc-memory-leak-in-the-scsi-core-2 drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-fix-proc-memory-leak-in-the-scsi-core-2
+++ a/drivers/scsi/hosts.c
@@ -176,7 +176,6 @@ void scsi_remove_host(struct Scsi_Host *
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
 	device_del(&shost->shost_gendev);
-	scsi_proc_hostdir_rm(shost->hostt);
 }
 EXPORT_SYMBOL(scsi_remove_host);
 
@@ -270,6 +269,8 @@ static void scsi_host_dev_release(struct
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
+	scsi_proc_hostdir_rm(shost->hostt);
+
 	if (shost->ehandler)
 		kthread_stop(shost->ehandler);
 	if (shost->work_q)
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

linux-next.patch
sd-tell-the-user-when-a-disks-capacity-is-adjusted.patch
scsi-fix-proc-memory-leak-in-the-scsi-core-2.patch

