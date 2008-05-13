From: akpm@linux-foundation.org
Subject: - drivers-scsi-qla1280c-was-re-buffered-i-o-to-block-device-very-slow-and-other-scsi-issues.patch removed from -mm tree
Date: Tue, 13 May 2008 14:35:05 -0700
Message-ID: <200805132135.m4DLZ5NK001058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756711AbYEMVfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@sgi.com, James.Bottomley@SteelEye.com, andrew.vasquez@qlogic.com, dgc@sgi.com, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, jes@sgi.com, stable@kernel.org, mm-commits@


The patch titled
     drivers/scsi/qla1280.c: fix mailbox handling
has been removed from the -mm tree.  Its filename was
     drivers-scsi-qla1280c-was-re-buffered-i-o-to-block-device-very-slow-and-other-scsi-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/qla1280.c: fix mailbox handling
From: Jeremy Higdon <jeremy@sgi.com>

The qla1280 driver was ANDing the output value of mailbox register 0 with
(1 << target-number) to determine whether to enable queueing on the target
in question.

But mailbox register 0 has the status code for the mailbox command (in
this case, Set Target Parameters).  Potential values are:

/*
 * ISP mailbox command complete status codes
 */
#define MBS_CMD_CMP             0x4000  /* Command Complete. */
#define MBS_INV_CMD             0x4001  /* Invalid Command. */
#define MBS_HOST_INF_ERR        0x4002  /* Host Interface Error. */
#define MBS_TEST_FAILED         0x4003  /* Test Failed. */
#define MBS_CMD_ERR             0x4005  /* Command Error. */
#define MBS_CMD_PARAM_ERR       0x4006  /* Command Parameter Error. */

So clearly that is in error.  I can't think what the author of that line
was looking for in a mailbox register, so I just eliminated the AND.  flag
is used later in the function, and I think that the later usage was also
wrong, though it was used to set values that aren't used.  Oh well, an
overhaul of this driver is not what I want to do now -- just a bugfix.

After the fix, I found that my disks were getting a queue depth of 255,
which is far too many.  Most SCSI disks are limited to 32 or 64.  In any
case, there's no point, queueing up a bunch of commands to the adapter
that will just result in queue full or starve other targets from being
issued commands due to running out of internal memory.  So I dropped
default queue depth to 32 (from which 1 is subtracted elsewhere, giving
net of 31).

I tested with a Seagate ST336753LC, and results look good, so I'm
satisfied with this patch.

Signed-off-by: Jeremy Higdon <jeremy@sgi.com>
Tested-by: Dave Chinner <dgc@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jes Sorensen <jes@sgi.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla1280.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/qla1280.c~drivers-scsi-qla1280c-was-re-buffered-i-o-to-block-device-very-slow-and-other-scsi-issues drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~drivers-scsi-qla1280c-was-re-buffered-i-o-to-block-device-very-slow-and-other-scsi-issues
+++ a/drivers/scsi/qla1280.c
@@ -2007,7 +2007,7 @@ qla1280_set_defaults(struct scsi_qla_hos
 		nv->bus[bus].config_2.req_ack_active_negation = 1;
 		nv->bus[bus].config_2.data_line_active_negation = 1;
 		nv->bus[bus].selection_timeout = 250;
-		nv->bus[bus].max_queue_depth = 256;
+		nv->bus[bus].max_queue_depth = 32;
 
 		if (IS_ISP1040(ha)) {
 			nv->bus[bus].bus_reset_delay = 3;
@@ -2051,7 +2051,7 @@ qla1280_config_target(struct scsi_qla_ho
 	status = qla1280_mailbox_command(ha, 0x0f, mb);
 
 	/* Save Tag queuing enable flag. */
-	flag = (BIT_0 << target) & mb[0];
+	flag = (BIT_0 << target);
 	if (nv->bus[bus].target[target].parameter.tag_queuing)
 		ha->bus_settings[bus].qtag_enables |= flag;
 
_

Patches currently in -mm which might be from jeremy@sgi.com are

origin.patch
linux-next.patch

