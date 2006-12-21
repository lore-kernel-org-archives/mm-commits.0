From: akpm@osdl.org
Subject: + libata-scsi-ata_task_ioctl-should-return-ata-registers-from.patch added to -mm tree
Date: Wed, 20 Dec 2006 19:32:49 -0800
Message-ID: <200612210332.kBL3WnS1014574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34156 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422647AbWLUDdI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 22:33:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmilburn@redhat.com, htejun@gmail.com, jeff@garzik.org


The patch titled
     libata-scsi: ata_task_ioctl should return ATA registers from sense data
has been added to the -mm tree.  Its filename is
     libata-scsi-ata_task_ioctl-should-return-ata-registers-from.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: libata-scsi: ata_task_ioctl should return ATA registers from sense data
From: David Milburn <dmilburn@redhat.com>

User applications using the HDIO_DRIVE_TASK ioctl through libata expect
specific ATA registers to be returned to userspace.  Verified that
ata_task_ioctl correctly returns register values to the smartctl
application.

Signed-off-by: David Milburn <dmilburn@redhat.com>
Acked-by: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ata/libata-scsi.c |   51 +++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff -puN drivers/ata/libata-scsi.c~libata-scsi-ata_task_ioctl-should-return-ata-registers-from drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c~libata-scsi-ata_task_ioctl-should-return-ata-registers-from
+++ a/drivers/ata/libata-scsi.c
@@ -273,8 +273,8 @@ int ata_task_ioctl(struct scsi_device *s
 {
 	int rc = 0;
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
-	u8 args[7];
-	struct scsi_sense_hdr sshdr;
+	u8 args[7], *sensebuf = NULL;
+	int cmd_result;
 
 	if (arg == NULL)
 		return -EINVAL;
@@ -282,10 +282,14 @@ int ata_task_ioctl(struct scsi_device *s
 	if (copy_from_user(args, arg, sizeof(args)))
 		return -EFAULT;
 
+	sensebuf = kzalloc(SCSI_SENSE_BUFFERSIZE, GFP_NOIO);
+	if (!sensebuf)
+		return -ENOMEM;
+
 	memset(scsi_cmd, 0, sizeof(scsi_cmd));
 	scsi_cmd[0]  = ATA_16;
 	scsi_cmd[1]  = (3 << 1); /* Non-data */
-	/* scsi_cmd[2] is already 0 -- no off.line, cc, or data xfer */
+	scsi_cmd[2]  = 0x20;     /* cc but no off.line or data xfer */
 	scsi_cmd[4]  = args[1];
 	scsi_cmd[6]  = args[2];
 	scsi_cmd[8]  = args[3];
@@ -295,11 +299,46 @@ int ata_task_ioctl(struct scsi_device *s
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	if (scsi_execute_req(scsidev, scsi_cmd, DMA_NONE, NULL, 0, &sshdr,
-			     (10*HZ), 5))
+	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
+				sensebuf, (10*HZ), 5, 0);
+
+	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
+		u8 *desc = sensebuf + 8;
+		cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
+
+		/* If we set cc then ATA pass-through will cause a
+		 * check condition even if no error. Filter that. */
+		if (cmd_result & SAM_STAT_CHECK_CONDITION) {
+			struct scsi_sense_hdr sshdr;
+			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
+						&sshdr);
+			if (sshdr.sense_key==0 &&
+				sshdr.asc==0 && sshdr.ascq==0)
+				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
+		}
+
+		/* Send userspace ATA registers */
+		if (sensebuf[0] == 0x72 &&	/* format is "descriptor" */
+				desc[0] == 0x09) {/* code is "ATA Descriptor" */
+			args[0] = desc[13];	/* status */
+			args[1] = desc[3];	/* error */
+			args[2] = desc[5];	/* sector count (0:7) */
+			args[3] = desc[7];	/* lbal */
+			args[4] = desc[9];	/* lbam */
+			args[5] = desc[11];	/* lbah */
+			args[6] = desc[12];	/* select */
+			if (copy_to_user(arg, args, sizeof(args)))
+				rc = -EFAULT;
+		}
+	}
+
+	if (cmd_result) {
 		rc = -EIO;
+		goto error;
+	}
 
-	/* Need code to retrieve data from check condition? */
+ error:
+	kfree(sensebuf);
 	return rc;
 }
 
_

Patches currently in -mm which might be from dmilburn@redhat.com are

libata-scsi-ata_task_ioctl-should-return-ata-registers-from.patch

