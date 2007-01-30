From: akpm@osdl.org
Subject: - libata-fix-translation-for-start-stop-unit.patch removed from -mm tree
Date: Tue, 30 Jan 2007 13:47:12 -0800
Message-ID: <200701302147.l0ULlCMi030167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXA3VrN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 16:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hancockr@shaw.ca, mm-commits@vger.kernel.org


The patch titled
     libata: fix translation for START STOP UNIT
has been removed from the -mm tree.  Its filename was
     libata-fix-translation-for-start-stop-unit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: libata: fix translation for START STOP UNIT
From: Robert Hancock <hancockr@shaw.ca>

libata's SCSI translation for the SCSI START STOP UNIT command with the
START bit clear (i.e.  stopping the drive) appears to be incorrect.  It
sends an ATA STANDBY command with the time period set to 0, which the code
comment says means "now", but the ATA standard says this means disable the
standby timer, which effectively does nothing.  Change this to issue a
STANDBY IMMEDIATE command which will actually spin the drive down.  The SAT
(SCSI/ATA Translation) standard revision 9 concurs with this choice.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-scsi.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-fix-translation-for-start-stop-unit drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-fix-translation-for-start-stop-unit
+++ a/drivers/ata/libata-scsi.c
@@ -1063,11 +1063,10 @@ static unsigned int ata_scsi_start_stop_
 		}
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
-	} else {
-		tf->nsect = 0;	/* time period value (0 implies now) */
-		tf->command = ATA_CMD_STANDBY;
-		/* Consider: ATA STANDBY IMMEDIATE command */
-	}
+	} else
+		/* Issue ATA STANDBY IMMEDIATE command */
+		tf->command = ATA_CMD_STANDBYNOW1;
+
 	/*
 	 * Standby and Idle condition timers could be implemented but that
 	 * would require libata to implement the Power condition mode page
_

Patches currently in -mm which might be from hancockr@shaw.ca are

origin.patch
git-libata-all.patch
sata_nv-cleanup-adma-error-handling-v2.patch
sata_nv-use-adma-for-nodata-commands.patch
