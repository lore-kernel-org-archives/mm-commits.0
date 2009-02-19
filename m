From: akpm@linux-foundation.org
Subject: + scsi-fix-proc-memory-leak-in-the-scsi-core.patch added to -mm tree
Date: Thu, 19 Feb 2009 13:49:49 -0800
Message-ID: <200902192149.n1JLnnEp025264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759035AbZBSVuZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 16:50:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: fix /proc memory leak in the SCSI core
has been added to the -mm tree.  Its filename is
     scsi-fix-proc-memory-leak-in-the-scsi-core.patch

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

