From: akpm@linux-foundation.org
Subject: + scsi-arcmsr-update-driver-version.patch added to -mm tree
Date: Thu, 28 Feb 2008 12:01:27 -0800
Message-ID: <200802282001.m1SK1RfM017748@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765807AbYB1UCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 15:02:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nick.cheng@areca.com.tw, James.Bottomley@HansenPartnership.com


The patch titled
     scsi: arcmsr: update driver version
has been added to the -mm tree.  Its filename is
     scsi-arcmsr-update-driver-version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: arcmsr: update driver version
From: Nick Cheng <nick.cheng@areca.com.tw>

Update the driver version of arcmsr and ChangeLog.arcmsr.

Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.arcmsr |    6 ++++++
 drivers/scsi/arcmsr/arcmsr.h        |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-update-driver-version Documentation/scsi/ChangeLog.arcmsr
--- a/Documentation/scsi/ChangeLog.arcmsr~scsi-arcmsr-update-driver-version
+++ a/Documentation/scsi/ChangeLog.arcmsr
@@ -109,4 +109,10 @@
 **						8.replace pci_alloc_consistent()/pci_free_consistent() with kmalloc()/kfree() in arcmsr_iop_message_xfer()
 **						9. fix the release of dma memory for type B in arcmsr_free_ccb_pool()
 **						10.fix the arcmsr_polling_hbb_ccbdone()
+** 1.20.00.15	02/27/2008	Erich Chen & Nick Cheng
+**						1.arcmsr_iop_message_xfer() is called from atomic context under the
+**						queuecommand scsi_host_template handler. James Bottomley pointed out
+**						that the current GFP_KERNEL|GFP_DMA flags are wrong: firstly we are in
+**						atomic context, secondly this memory is not used for DMA.
+**						Also removed some unneeded casts. Thanks to Daniel Drake <dsd@gentoo.org>
 **************************************************************************
diff -puN drivers/scsi/arcmsr/arcmsr.h~scsi-arcmsr-update-driver-version drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h~scsi-arcmsr-update-driver-version
+++ a/drivers/scsi/arcmsr/arcmsr.h
@@ -48,7 +48,7 @@ struct class_device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
 #define ARCMSR_MAX_OUTSTANDING_CMD						256
 #define ARCMSR_MAX_FREECCB_NUM							320
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2007/12/24"
+#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 2008/02/27"
 #define ARCMSR_SCSI_INITIATOR_ID						255
 #define ARCMSR_MAX_XFER_SECTORS							512
 #define ARCMSR_MAX_XFER_SECTORS_B						4096
_

Patches currently in -mm which might be from nick.cheng@areca.com.tw are

scsi-arcmsr-update-driver-version.patch

