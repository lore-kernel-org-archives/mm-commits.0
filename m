From: akpm@linux-foundation.org
Subject: [merged] scsi-fix-crash-when-disconnecting-usb-storage.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:23 -0800
Message-ID: <200911302033.nAUKXNqr020954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbZK3UeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuznet@ms2.inr.ac.ru, James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk, den@openvz.org, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     scsi: fix crash when disconnecting usb storage
has been removed from the -mm tree.  Its filename was
     scsi-fix-crash-when-disconnecting-usb-storage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/hosts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

linux-next.patch

