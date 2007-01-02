From: akpm@osdl.org
Subject: + fix-bug-at-drivers-scsi-scsi_libc1118-caused-by-pktsetup-dvd-dev-sr0.patch added to -mm tree
Date: Tue, 02 Jan 2007 15:30:17 -0800
Message-ID: <200701022330.l02NUHW2001194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:44257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbXABXao (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 18:30:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, petero2@telia.com


The patch titled
     Fix BUG at drivers/scsi/scsi_lib.c:1118 caused by "pktsetup dvd /dev/sr0"
has been added to the -mm tree.  Its filename is
     fix-bug-at-drivers-scsi-scsi_libc1118-caused-by-pktsetup-dvd-dev-sr0.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix BUG at drivers/scsi/scsi_lib.c:1118 caused by "pktsetup dvd /dev/sr0"
From: Christoph Hellwig <hch@lst.de>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=7667

This is because the packet driver tries to send down read/write BLOCK_PC
commands that don't use a bio and do not use sg lists.

The right fix is to replace all the packet_command stuff in the packet
driver by scsi_execute() which needs to be lifted from scsi code to
the block code for that.

Fix the bug for now.  It's not the full way to a generic execute block pc
infrastcuture but fixes the bug for the time being.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Peter Osterlund <petero2@telia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/pktcdvd.c |   49 +++++++++++++-------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff -puN drivers/block/pktcdvd.c~fix-bug-at-drivers-scsi-scsi_libc1118-caused-by-pktsetup-dvd-dev-sr0 drivers/block/pktcdvd.c
--- a/drivers/block/pktcdvd.c~fix-bug-at-drivers-scsi-scsi_libc1118-caused-by-pktsetup-dvd-dev-sr0
+++ a/drivers/block/pktcdvd.c
@@ -765,47 +765,34 @@ static inline struct bio *pkt_get_list_f
  */
 static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *cgc)
 {
-	char sense[SCSI_SENSE_BUFFERSIZE];
-	request_queue_t *q;
+	request_queue_t *q = bdev_get_queue(pd->bdev);
 	struct request *rq;
-	DECLARE_COMPLETION_ONSTACK(wait);
-	int err = 0;
+	int ret = 0;
 
-	q = bdev_get_queue(pd->bdev);
+	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
+			     WRITE : READ, __GFP_WAIT);
+
+	if (cgc->buflen) {
+		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
+			goto out;
+	}
+
+	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
+	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
+	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
+		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
 
-	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ? WRITE : READ,
-			     __GFP_WAIT);
-	rq->errors = 0;
-	rq->rq_disk = pd->bdev->bd_disk;
-	rq->bio = NULL;
-	rq->buffer = NULL;
 	rq->timeout = 60*HZ;
-	rq->data = cgc->buffer;
-	rq->data_len = cgc->buflen;
-	rq->sense = sense;
-	memset(sense, 0, sizeof(sense));
-	rq->sense_len = 0;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_HARDBARRIER;
 	if (cgc->quiet)
 		rq->cmd_flags |= REQ_QUIET;
-	memcpy(rq->cmd, cgc->cmd, CDROM_PACKET_SIZE);
-	if (sizeof(rq->cmd) > CDROM_PACKET_SIZE)
-		memset(rq->cmd + CDROM_PACKET_SIZE, 0, sizeof(rq->cmd) - CDROM_PACKET_SIZE);
-	rq->cmd_len = COMMAND_SIZE(rq->cmd[0]);
-
-	rq->ref_count++;
-	rq->end_io_data = &wait;
-	rq->end_io = blk_end_sync_rq;
-	elv_add_request(q, rq, ELEVATOR_INSERT_BACK, 1);
-	generic_unplug_device(q);
-	wait_for_completion(&wait);
-
-	if (rq->errors)
-		err = -EIO;
 
+	blk_execute_rq(rq->q, pd->bdev->bd_disk, rq, 0);
+	ret = rq->errors;
+out:
 	blk_put_request(rq);
-	return err;
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from hch@lst.de are

fix-bug-at-drivers-scsi-scsi_libc1118-caused-by-pktsetup-dvd-dev-sr0.patch
fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_slow.patch
fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-filesystem-aio-read-tidy.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
