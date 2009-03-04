From: akpm@linux-foundation.org
Subject: [to-be-updated] scsi-fix-proc-memory-leak-in-the-scsi-core.patch removed from -mm tree
Date: Wed, 04 Mar 2009 13:03:43 -0800
Message-ID: <200903042103.n24L3iZp002485@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbZCDVEU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 16:04:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix /proc memory leak in the SCSI core
has been removed from the -mm tree.  Its filename was
     scsi-fix-proc-memory-leak-in-the-scsi-core.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: fix /proc memory leak in the SCSI core
From: Alan Stern <stern@rowland.harvard.edu>

The SCSI core calls scsi_proc_hostdir_add() from within scsi_host_alloc(),
but the corresponding scsi_proc_hostdir_rm() routine is called from within
scsi_remove_host().  As a result, if a host is allocated and then
deallocated without ever being registered, the host's directory in /proc
is leaked.

This patch (as1181) fixes this bug in the SCSI core by moving
scsi_proc_hostdir_add() into scsi_host_add().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/hosts.c~scsi-fix-proc-memory-leak-in-the-scsi-core drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-fix-proc-memory-leak-in-the-scsi-core
+++ a/drivers/scsi/hosts.c
@@ -206,9 +206,10 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		goto fail;
 
+	scsi_proc_hostdir_add(shost->hostt);
+
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
-
 	error = device_add(&shost->shost_gendev);
 	if (error)
 		goto out;
@@ -259,6 +260,7 @@ int scsi_add_host(struct Scsi_Host *shos
  out_del_gendev:
 	device_del(&shost->shost_gendev);
  out:
+	scsi_proc_hostdir_rm(shost->hostt);
 	scsi_destroy_command_freelist(shost);
  fail:
 	return error;
@@ -407,7 +409,6 @@ struct Scsi_Host *scsi_host_alloc(struct
 		goto fail_kfree;
 	}
 
-	scsi_proc_hostdir_add(shost->hostt);
 	return shost;
 
  fail_kfree:
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

linux-next.patch
scsi-fix-proc-memory-leak-in-the-scsi-core.patch
sd-tell-the-user-when-a-disks-capacity-is-adjusted.patch

