From: akpm@osdl.org
Subject: + scsi_ioctl-sg_io-timeout-conversion-fix.patch added to -mm tree
Date: Mon, 29 Jan 2007 19:35:28 -0800
Message-ID: <200701300335.l0U3ZSqR008206@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40240 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXA3Dfp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 22:35:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@steeleye.com


The patch titled
     scsi_ioctl: sg_io timeout conversion fix
has been added to the -mm tree.  Its filename is
     scsi_ioctl-sg_io-timeout-conversion-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: scsi_ioctl: sg_io timeout conversion fix
From: Mike Christie <michaelc@cs.wisc.edu>

The recent conversion to jiffies_to_msecs() was wrong - it should have been to
msecs_to_jiffies().  Include the overflow check which sg.c has.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/scsi_ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN block/scsi_ioctl.c~scsi_ioctl-sg_io-timeout-conversion-fix block/scsi_ioctl.c
--- a/block/scsi_ioctl.c~scsi_ioctl-sg_io-timeout-conversion-fix
+++ a/block/scsi_ioctl.c
@@ -224,6 +224,7 @@ static int sg_io(struct file *file, requ
 		struct gendisk *bd_disk, struct sg_io_hdr *hdr)
 {
 	unsigned long start_time;
+	unsigned long timeout;
 	int writing = 0, ret = 0;
 	struct request *rq;
 	char sense[SCSI_SENSE_BUFFERSIZE];
@@ -271,7 +272,8 @@ static int sg_io(struct file *file, requ
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
-	rq->timeout = jiffies_to_msecs(hdr->timeout);
+	timeout = msecs_to_jiffies(hdr->timeout);
+	rq->timeout = (timeout < INT_MAX) ? timeout : INT_MAX;
 	if (!rq->timeout)
 		rq->timeout = q->sg_timeout;
 	if (!rq->timeout)
_

Patches currently in -mm which might be from michaelc@cs.wisc.edu are

scsi_ioctl-sg_io-timeout-conversion-fix.patch
