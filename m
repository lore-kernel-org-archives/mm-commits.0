From: akpm@linux-foundation.org
Subject: - arcmsr-fix-error-handling.patch removed from -mm tree
Date: Wed, 12 Sep 2007 03:59:52 -0700
Message-ID: <200709121059.l8CAxq8I028714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54671 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965419AbXILLAN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 07:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.hampel@gmx.de, James.Bottomley@steeleye.com, erich@areca.com.tw, mm-commits@vger.kernel.org


The patch titled
     arcmsr: fix error handling
has been removed from the -mm tree.  Its filename was
     arcmsr-fix-error-handling.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: arcmsr: fix error handling
From: Maik Hampel <m.hampel@gmx.de>

Fixed error handling in queuecommand(), now all READ_ and WRITE_ commands
are aborted in case of RAID is gone.  Before only READ_6 and WRITE_6
commands were aborted.

Signed-off-by: Maik Hampel <m.hampel@gmx.de>
Cc: erich <erich@areca.com.tw>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/arcmsr/arcmsr_hba.c |   32 +++++++++++++++++++----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff -puN drivers/scsi/arcmsr/arcmsr_hba.c~arcmsr-fix-error-handling drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c~arcmsr-fix-error-handling
+++ a/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1133,17 +1133,27 @@ static int arcmsr_queue_command(struct s
 		uint8_t block_cmd;
 
 		block_cmd = cmd->cmnd[0] & 0x0f;
-		if (block_cmd == 0x08 || block_cmd == 0x0a) {
-			printk(KERN_NOTICE
-				"arcmsr%d: block 'read/write'"
-				"command with gone raid volume"
-				" Cmd = %2x, TargetId = %d, Lun = %d \n"
-				, acb->host->host_no
-				, cmd->cmnd[0]
-				, target, lun);
-			cmd->result = (DID_NO_CONNECT << 16);
-			cmd->scsi_done(cmd);
-			return 0;
+		switch (block_cmd) {
+			case READ_6:
+			case READ_10:
+			case READ_12:
+			case READ_16:
+			case WRITE_6:
+			case WRITE_10:
+			case WRITE_12:
+			case WRITE_16:
+				printk(KERN_NOTICE
+					"arcmsr%d: block 'read/write'"
+					"command with gone raid volume"
+					" Cmd = %2x, TargetId = %d, Lun = %d \n"
+					, acb->host->host_no
+					, cmd->cmnd[0]
+					, target, lun);
+				cmd->result = (DID_NO_CONNECT << 16);
+				cmd->scsi_done(cmd);
+				return 0;
+			default:
+				break;
 		}
 	}
 	if (atomic_read(&acb->ccboutstandingcount) >=
_

Patches currently in -mm which might be from m.hampel@gmx.de are

arcmsr-fix-error-handling.patch
