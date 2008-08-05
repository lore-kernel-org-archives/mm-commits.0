From: akpm@linux-foundation.org
Subject: + scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch added to -mm tree
Date: Tue, 05 Aug 2008 13:21:27 -0700
Message-ID: <200808052021.m75KLR7G021564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765323AbYHEUVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 16:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, James.Bottomley@HansenPartnership.com, rpjday@crashcourse.ca


The patch titled
     scsi: remove the unused SCSI_QLOGIC_FC_FIRMWARE option
has been added to the -mm tree.  Its filename is
     scsi-remove-the-unused-scsi_qlogic_fc_firmware-option.patch

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
Subject: scsi: remove the unused SCSI_QLOGIC_FC_FIRMWARE option
From: Adrian Bunk <bunk@kernel.org>

This option was forgotten when the SCSI_QLOGIC_FC driver was removed.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    8 --------
 1 file changed, 8 deletions(-)

diff -puN drivers/scsi/Kconfig~scsi-remove-the-unused-scsi_qlogic_fc_firmware-option drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-remove-the-unused-scsi_qlogic_fc_firmware-option
+++ a/drivers/scsi/Kconfig
@@ -1337,14 +1337,6 @@ config SCSI_QLOGIC_FAS
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicfas.
 
-config SCSI_QLOGIC_FC_FIRMWARE
-	bool "Include loadable firmware in driver"
-	depends on SCSI_QLOGIC_FC
-  	help
-	  Say Y to include ISP2X00 Fabric Initiator/Target Firmware, with
-	  expanded LUN addressing and FcTape (FCP-2) support, in the
-	  qlogicfc driver. This is required on some platforms.
