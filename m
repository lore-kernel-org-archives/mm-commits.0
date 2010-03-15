From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:34 -0400
Message-ID: <201003150655.o2F6t7cZ016127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759749Ab0COGzN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove unnecessary argument from [__]reschedule_timeout
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove unnecessary argument from [__]reschedule_timeout
From: Joe Perches <joe@perches.com>

Prior to patch "drivers/block/floppy.c: Use pr_<level>" only
reschedule_timeout(,"request done"...) printed a numeric value after a
reschedule_timeout event message.

Restore that behavior and remove the now unnecessary argument.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout
+++ a/drivers/block/floppy.c
@@ -668,7 +668,7 @@ static int output_log_pos;
 #define current_reqD -1
 #define MAXTIMEOUT -2
 
-static void __reschedule_timeout(int drive, const char *message, int marg)
+static void __reschedule_timeout(int drive, const char *message)
 {
 	if (drive == current_reqD)
 		drive = current_drive;
@@ -680,16 +680,16 @@ static void __reschedule_timeout(int dri
 		fd_timeout.expires = jiffies + UDP->timeout;
 	add_timer(&fd_timeout);
 	if (UDP->flags & FD_DEBUG)
-		DPRINT("reschedule timeout %s %d\n", message, marg);
+		DPRINT("reschedule timeout %s\n", message);
 	timeout_message = message;
 }
 
-static void reschedule_timeout(int drive, const char *message, int marg)
+static void reschedule_timeout(int drive, const char *message)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&floppy_lock, flags);
-	__reschedule_timeout(drive, message, marg);
+	__reschedule_timeout(drive, message);
 	spin_unlock_irqrestore(&floppy_lock, flags);
 }
 
@@ -900,7 +900,7 @@ static int _lock_fdc(int drive, bool int
 	}
 	command_status = FD_COMMAND_NONE;
 
-	__reschedule_timeout(drive, "lock fdc", 0);
+	__reschedule_timeout(drive, "lock fdc");
 	set_fdc(drive);
 	return 0;
 }
@@ -1983,7 +1983,7 @@ static void floppy_ready(void)
 
 static void floppy_start(void)
 {
-	reschedule_timeout(current_reqD, "floppy start", 0);
+	reschedule_timeout(current_reqD, "floppy start");
 
 	scandrives();
 	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
@@ -2007,7 +2007,7 @@ static void floppy_start(void)
 
 static void do_wakeup(void)
 {
-	reschedule_timeout(MAXTIMEOUT, "do wakeup", 0);
+	reschedule_timeout(MAXTIMEOUT, "do wakeup");
 	cont = NULL;
 	command_status += 2;
 	wake_up(&command_done);
@@ -2306,9 +2306,11 @@ static void request_done(int uptodate)
 	struct request *req = current_req;
 	unsigned long flags;
 	int block;
+	char msg[sizeof("request done ") + sizeof(int) * 3];
 
 	probing = 0;
-	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);
+	snprintf(msg, sizeof(msg), "request done %d", uptodate);
+	reschedule_timeout(MAXTIMEOUT, msg);
 
 	if (!req) {
 		pr_info("floppy.c: no request in request_done\n");
@@ -2908,7 +2910,7 @@ do_request:
 	}
 	drive = (long)current_req->rq_disk->private_data;
 	set_fdc(drive);
-	reschedule_timeout(current_reqD, "redo fd request", 0);
+	reschedule_timeout(current_reqD, "redo fd request");
 
 	set_floppy(drive);
 	raw_cmd = &default_raw_cmd;
@@ -4254,7 +4256,7 @@ static int __init floppy_init(void)
 		else
 			floppy_sizes[i] = MAX_DISK_SIZE << 1;
 
-	reschedule_timeout(MAXTIMEOUT, "floppy init", MAXTIMEOUT);
+	reschedule_timeout(MAXTIMEOUT, "floppy init");
 	config_types();
 
 	for (i = 0; i < N_FDC; i++) {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

