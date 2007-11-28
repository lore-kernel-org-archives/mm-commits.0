From: akpm@linux-foundation.org
Subject: - ide-scsi-use-print_hex_dump-from-linux-kernelh.patch removed from -mm tree
Date: Tue, 27 Nov 2007 18:09:49 -0800
Message-ID: <200711280209.lAS29nSN010950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48375 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759684AbXK1CLE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 21:11:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, bzolnier@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ide-scsi: use print_hex_dump from <linux/kernel.h>
has been removed from the -mm tree.  Its filename was
     ide-scsi-use-print_hex_dump-from-linux-kernelh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide-scsi: use print_hex_dump from <linux/kernel.h>
From: Denis Cheng <crquan@gmail.com>

these utilities implemented in lib/hexdump.c are more handy, please use this.

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ide-scsi.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ide-scsi.c~ide-scsi-use-print_hex_dump-from-linux-kernelh drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c~ide-scsi-use-print_hex_dump-from-linux-kernelh
+++ a/drivers/scsi/ide-scsi.c
@@ -242,16 +242,6 @@ static void idescsi_output_buffers (ide_
 	}
 }
 
-static void hexdump(u8 *x, int len)
-{
-	int i;
-
-	printk("[ ");
-	for (i = 0; i < len; i++)
-		printk("%x ", x[i]);
-	printk("]\n");
-}
-
 static int idescsi_check_condition(ide_drive_t *drive, struct request *failed_command)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -282,7 +272,7 @@ static int idescsi_check_condition(ide_d
 	pc->scsi_cmd = ((idescsi_pc_t *) failed_command->special)->scsi_cmd;
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: queue cmd = ", drive->name);
-		hexdump(pc->c, 6);
+		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->c, 6, 1);
 	}
 	rq->rq_disk = scsi->disk;
 	return ide_do_drive_cmd(drive, rq, ide_preempt);
@@ -337,7 +327,7 @@ static int idescsi_end_request (ide_driv
 		idescsi_pc_t *opc = (idescsi_pc_t *) rq->buffer;
 		if (log) {
 			printk ("ide-scsi: %s: wrap up check %lu, rst = ", drive->name, opc->scsi_cmd->serial_number);
-			hexdump(pc->buffer,16);
+			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->buffer, 16, 1);
 		}
 		memcpy((void *) opc->scsi_cmd->sense_buffer, pc->buffer, SCSI_SENSE_BUFFERSIZE);
 		kfree(pc->buffer);
@@ -813,10 +803,10 @@ static int idescsi_queue (struct scsi_cm
 
 	if (test_bit(IDESCSI_LOG_CMD, &scsi->log)) {
 		printk ("ide-scsi: %s: que %lu, cmd = ", drive->name, cmd->serial_number);
-		hexdump(cmd->cmnd, cmd->cmd_len);
+		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, cmd->cmnd, cmd->cmd_len, 1);
 		if (memcmp(pc->c, cmd->cmnd, cmd->cmd_len)) {
 			printk ("ide-scsi: %s: que %lu, tsl = ", drive->name, cmd->serial_number);
-			hexdump(pc->c, 12);
+			print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1, pc->c, 12, 1);
 		}
 	}
 
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
