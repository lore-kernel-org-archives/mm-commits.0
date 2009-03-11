From: akpm@linux-foundation.org
Subject: [merged] scsi-fix-proc-memory-leak-in-the-scsi-core-2.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:10:09 -0700
Message-ID: <200903111810.n2BIA9AH020049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34624 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbZCKSLr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:11:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix /proc memory leak in the SCSI core
has been removed from the -mm tree.  Its filename was
     scsi-fix-proc-memory-leak-in-the-scsi-core-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

