From: akpm@linux-foundation.org
Subject: + scsi-fix-crash-when-disconnecting-usb-storage.patch added to -mm tree
Date: Mon, 09 Nov 2009 16:31:56 -0800
Message-ID: <200911100031.nAA0Vuvq027885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755802AbZKJAc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 19:32:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kuznet@ms2.inr.ac.ru, James.Bottomley@HansenPartnership.com, den@openvz.org


The patch titled
     scsi: fix crash when disconnecting usb storage
has been added to the -mm tree.  Its filename is
     scsi-fix-crash-when-disconnecting-usb-storage.patch

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
Subject: scsi: fix crash when disconnecting usb storage
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

__scsi_remove_device() in scsi_forget_host() is executed out of scan_mutex
and races with scsi_destroy_sdev() <- scsi_sysfs_add_devices() <-
scsi_finish_async_scan().  The result is use after free and/or double
free, oops.

The fix is simple, move scsi_forget_host() under scan_mutex.

scsi_forget_host() is just sequence of __scsi_remove_device().  All
another calls of __scsi_remove_device() are made under scan_mutex.  So
that it is safe.

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/hosts.c~scsi-fix-crash-when-disconnecting-usb-storage drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c~scsi-fix-crash-when-disconnecting-usb-storage
+++ a/drivers/scsi/hosts.c
@@ -164,8 +164,8 @@ void scsi_remove_host(struct Scsi_Host *
 			return;
 		}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	mutex_unlock(&shost->scan_mutex);
 	scsi_forget_host(shost);
+	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
 	spin_lock_irqsave(shost->host_lock, flags);
_

Patches currently in -mm which might be from kuznet@ms2.inr.ac.ru are

scsi-fix-crash-when-disconnecting-usb-storage.patch
scsi-fix-another-crash-at-disconnect-of-usb-strorage.patch

