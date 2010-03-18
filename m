From: akpm@linux-foundation.org
Subject: + scsi-fix-convert-scsi_scanc-kernel-doc.patch added to -mm tree
Date: Thu, 18 Mar 2010 16:17:29 -0700
Message-ID: <201003182317.o2INHTuE021492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53376 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab0CRXSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 19:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: fix/convert scsi_scan.c kernel-doc
has been added to the -mm tree.  Its filename is
     scsi-fix-convert-scsi_scanc-kernel-doc.patch

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
Subject: scsi: fix/convert scsi_scan.c kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

scsi_scan.c: fix incorrectly formatted kernel-doc notation & convert
documentation of 2 functions into kernel-doc.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff -puN drivers/scsi/scsi_scan.c~scsi-fix-convert-scsi_scanc-kernel-doc drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-fix-convert-scsi_scanc-kernel-doc
+++ a/drivers/scsi/scsi_scan.c
@@ -1220,7 +1220,7 @@ static void scsi_sequential_lun_scan(str
 }
 
 /**
- * scsilun_to_int: convert a scsi_lun to an int
+ * scsilun_to_int - convert a scsi_lun to an int
  * @scsilun:	struct scsi_lun to be converted.
  *
  * Description:
@@ -1252,7 +1252,7 @@ int scsilun_to_int(struct scsi_lun *scsi
 EXPORT_SYMBOL(scsilun_to_int);
 
 /**
- * int_to_scsilun: reverts an int into a scsi_lun
+ * int_to_scsilun - reverts an int into a scsi_lun
  * @lun:        integer to be reverted
  * @scsilun:	struct scsi_lun to be set.
  *
@@ -1876,12 +1876,9 @@ void scsi_forget_host(struct Scsi_Host *
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
-/*
- * Function:    scsi_get_host_dev()
- *
- * Purpose:     Create a scsi_device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a scsi_device
+/**
+ * scsi_get_host_dev - Create a scsi_device that points to the host adapter itself
+ * @shost: Host that needs a scsi_device
  *
  * Lock status: None assumed.
  *
@@ -1894,7 +1891,7 @@ void scsi_forget_host(struct Scsi_Host *
  *
  *	Note - this device is not accessible from any high-level
  *	drivers (including generics), which is probably not
- *	optimal.  We can add hooks later to attach 
+ *	optimal.  We can add hooks later to attach.
  */
 struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
@@ -1920,18 +1917,13 @@ struct scsi_device *scsi_get_host_dev(st
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
 
-/*
- * Function:    scsi_free_host_dev()
- *
- * Purpose:     Free a scsi_device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a scsi_device
+/**
+ * scsi_free_host_dev - Free a scsi_device that points to the host adapter itself
+ * @sdev: Host device to be freed
  *
  * Lock status: None assumed.
  *
  * Returns:     Nothing
- *
- * Notes:
  */
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
scripts-kernel-doc-handle-struct-member-__aligned.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

