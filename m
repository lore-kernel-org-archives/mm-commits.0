From: akpm@linux-foundation.org
Subject: + scsi-select-crc_t10dif-only-when-necessary.patch added to -mm tree
Date: Thu, 14 Aug 2008 17:47:22 -0700
Message-ID: <200808150047.m7F0lMKQ005926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751901AbYHOArm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 20:47:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de


The patch titled
     scsi: select CRC_T10DIF only when necessary
has been added to the -mm tree.  Its filename is
     scsi-select-crc_t10dif-only-when-necessary.patch

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
Subject: scsi: select CRC_T10DIF only when necessary
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~scsi-select-crc_t10dif-only-when-necessary drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-select-crc_t10dif-only-when-necessary
+++ a/drivers/scsi/Kconfig
@@ -63,7 +63,7 @@ comment "SCSI support type (disk, tape, 
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
-	select CRC_T10DIF
+	select CRC_T10DIF if BLK_DEV_INTEGRITY
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

linux-next.patch
scsi-select-crc_t10dif-only-when-necessary.patch

