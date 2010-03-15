From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-unclutter-redo_fd_request-logic.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:31 -0400
Message-ID: <201003150655.o2F6t4Le016123@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759746Ab0COGzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: unclutter redo_fd_request logic
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-unclutter-redo_fd_request-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: unclutter redo_fd_request logic
From: Joe Perches <joe@perches.com>

Change for(;;) with continue; to label: goto label
Reduces indentation and adds a bit of clarity.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |  105 +++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 53 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-unclutter-redo_fd_request-logic drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-unclutter-redo_fd_request-logic
+++ a/drivers/block/floppy.c
@@ -2892,64 +2892,63 @@ static void redo_fd_request(void)
 	if (current_drive < N_DRIVE)
 		floppy_off(current_drive);
 
-	for (;;) {
-		if (!current_req) {
-			struct request *req;
-
-			spin_lock_irq(floppy_queue->queue_lock);
-			req = blk_fetch_request(floppy_queue);
-			spin_unlock_irq(floppy_queue->queue_lock);
-			if (!req) {
-				do_floppy = NULL;
-				unlock_fdc();
-				return;
-			}
-			current_req = req;
-		}
-		drive = (long)current_req->rq_disk->private_data;
-		set_fdc(drive);
-		reschedule_timeout(current_reqD, "redo fd request", 0);
-
-		set_floppy(drive);
-		raw_cmd = &default_raw_cmd;
-		raw_cmd->flags = 0;
-		if (start_motor(redo_fd_request))
+do_request:
+	if (!current_req) {
+		struct request *req;
+
+		spin_lock_irq(floppy_queue->queue_lock);
+		req = blk_fetch_request(floppy_queue);
+		spin_unlock_irq(floppy_queue->queue_lock);
+		if (!req) {
+			do_floppy = NULL;
+			unlock_fdc();
 			return;
-		disk_change(current_drive);
-		if (test_bit(current_drive, &fake_change) ||
-		    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
-			DPRINT("disk absent or changed during operation\n");
-			request_done(0);
-			continue;
-		}
-		if (!_floppy) {	/* Autodetection */
-			if (!probing) {
-				DRS->probed_format = 0;
-				if (next_valid_format()) {
-					DPRINT("no autodetectable formats\n");
-					_floppy = NULL;
-					request_done(0);
-					continue;
-				}
-			}
-			probing = 1;
-			_floppy =
-			    floppy_type + DP->autodetect[DRS->probed_format];
-		} else
-			probing = 0;
-		errors = &(current_req->errors);
-		tmp = make_raw_rw_request();
-		if (tmp < 2) {
-			request_done(tmp);
-			continue;
 		}
+		current_req = req;
+	}
+	drive = (long)current_req->rq_disk->private_data;
+	set_fdc(drive);
+	reschedule_timeout(current_reqD, "redo fd request", 0);
 
-		if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
-			twaddle();
-		schedule_bh(floppy_start);
-		debugt("queue fd request");
+	set_floppy(drive);
+	raw_cmd = &default_raw_cmd;
+	raw_cmd->flags = 0;
+	if (start_motor(redo_fd_request))
 		return;
+
+	disk_change(current_drive);
+	if (test_bit(current_drive, &fake_change) ||
+	    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
+		DPRINT("disk absent or changed during operation\n");
+		request_done(0);
+		goto do_request;
+	}
+	if (!_floppy) {	/* Autodetection */
+		if (!probing) {
+			DRS->probed_format = 0;
+			if (next_valid_format()) {
+				DPRINT("no autodetectable formats\n");
+				_floppy = NULL;
+				request_done(0);
+				goto do_request;
+			}
+		}
+		probing = 1;
+		_floppy = floppy_type + DP->autodetect[DRS->probed_format];
+	} else
+		probing = 0;
+	errors = &(current_req->errors);
+	tmp = make_raw_rw_request();
+	if (tmp < 2) {
+		request_done(tmp);
+		goto do_request;
 	}
+
+	if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
+		twaddle();
+	schedule_bh(floppy_start);
+	debugt("queue fd request");
+	return;
 }
 
 static struct cont_t rw_cont = {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

