From: akpm@linux-foundation.org
Subject: + scsi-fix-another-crash-at-disconnect-of-usb-strorage.patch added to -mm tree
Date: Mon, 09 Nov 2009 16:32:00 -0800
Message-ID: <200911100032.nAA0W0ih028039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbZKJAcV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 19:32:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kuznet@ms2.inr.ac.ru, James.Bottomley@HansenPartnership.com, den@openvz.org


The patch titled
     scsi: fix another crash at disconnect of usb strorage
has been added to the -mm tree.  Its filename is
     scsi-fix-another-crash-at-disconnect-of-usb-strorage.patch

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
Subject: scsi: fix another crash at disconnect of usb strorage
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

Asynchronous scan (scsi_add_lun()) sets state to SDEV_RUNNING, but the
device is not registered in sysfs.  Before async scan it was OK, because
before releasing scan_mutex old code called either scsi_sysfs_add_sdev()
or scsi_destroy_sdev() and, therefore, completed the work or discarded it.

With async scan the invariant is broken and scsi crashes in
__scsi_remove_device() when trying to unregister not registered devices.

The fix could be introducing new state(s), which is equivalent to
SDEV_RUNNING, except for one thing, we know that scsi_sysfs_add_sdev() has
not been called yet.  Or a separate flag, because the state can be
SDEV_BLOCK or even something else.

Simpler way is just to check that the device is regstered in sysfs before
unregistering.  Another operations in __scsi_remove_device() seem to be
idempotent or even required, because scsi_add_lun() makes some part of
work duplicated in scsi_sysfs_add_sdev().

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/scsi/scsi_sysfs.c~scsi-fix-another-crash-at-disconnect-of-usb-strorage drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~scsi-fix-another-crash-at-disconnect-of-usb-strorage
+++ a/drivers/scsi/scsi_sysfs.c
@@ -965,9 +965,17 @@ void __scsi_remove_device(struct scsi_de
 		return;
 
 	bsg_unregister_queue(sdev->request_queue);
-	device_unregister(&sdev->sdev_dev);
+	/* Asynchronous scan violates invariant that SDEV_RUNNING
+	 * implies that device is registered in sysfs.
+	 * We could introduce new state flag or extend set of state,
+	 * but just plain checking that device is registered already
+	 * before trying to unregister it is enough.
+	 */
+	if (sdev->sdev_dev.kobj.parent)
+		device_unregister(&sdev->sdev_dev);
 	transport_remove_device(dev);
-	device_del(dev);
+	if (dev->kobj.parent)
+		device_del(dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
_

Patches currently in -mm which might be from kuznet@ms2.inr.ac.ru are

scsi-fix-crash-when-disconnecting-usb-storage.patch
scsi-fix-another-crash-at-disconnect-of-usb-strorage.patch

