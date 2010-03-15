From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-add-__func__-to-debugt.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:59 -0400
Message-ID: <201003150655.o2F6tXBp016158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759764Ab0COGzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: add __func__ to debugt
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-add-__func__-to-debugt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: add __func__ to debugt
From: Joe Perches <joe@perches.com>

Make debugt messages a little neater.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-add-__func__-to-debugt drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-add-__func__-to-debugt
+++ a/drivers/block/floppy.c
@@ -616,14 +616,14 @@ static inline void set_debugt(void)
 	debugtimer = jiffies;
 }
 
-static inline void debugt(const char *message)
+static inline void debugt(const char *func, const char *msg)
 {
 	if (DP->flags & DEBUGT)
-		pr_info("%s dtime=%lu\n", message, jiffies - debugtimer);
+		pr_info("%s:%s dtime=%lu\n", func, msg, jiffies - debugtimer);
 }
 #else
 static inline void set_debugt(void) { }
-static inline void debugt(const char *message) { }
+static inline void debugt(const char *func, const char *msg) { }
 #endif /* DEBUGT */
 
 typedef void (*timeout_fn)(unsigned long);
@@ -1533,7 +1533,7 @@ static void setup_rw_floppy(void)
 	for (i = 0; i < raw_cmd->cmd_count; i++)
 		r |= output_byte(raw_cmd->cmd[i]);
 
-	debugt("rw_command: ");
+	debugt(__func__, "rw_command");
 
 	if (r) {
 		cont->error();
@@ -1556,7 +1556,7 @@ static int blind_seek;
  */
 static void seek_interrupt(void)
 {
-	debugt("seek interrupt:");
+	debugt(__func__, "");
 	if (inr != 2 || (ST0 & 0xF8) != 0x20) {
 		DPRINT("seek failed\n");
 		DRS->track = NEED_2_RECAL;
@@ -1604,7 +1604,7 @@ static void seek_floppy(void)
 
 	blind_seek = 0;
 
-	debug_dcl(DP->flags, "calling disk change from seek\n");
+	debug_dcl(DP->flags, "calling disk change from %s\n", __func__);
 
 	if (!test_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
@@ -1653,18 +1653,18 @@ static void seek_floppy(void)
 		reset_fdc();
 		return;
 	}
-	debugt("seek command:");
+	debugt(__func__, "");
 }
 
 static void recal_interrupt(void)
 {
-	debugt("recal interrupt:");
+	debugt(__func__, "");
 	if (inr != 2)
 		FDCS->reset = 1;
 	else if (ST0 & ST0_ECE) {
 		switch (DRS->track) {
 		case NEED_1_RECAL:
-			debugt("recal interrupt need 1 recal:");
+			debugt(__func__, "need 1 recal");
 			/* after a second recalibrate, we still haven't
 			 * reached track 0. Probably no drive. Raise an
 			 * error, as failing immediately might upset
@@ -1673,7 +1673,7 @@ static void recal_interrupt(void)
 			cont->redo();
 			return;
 		case NEED_2_RECAL:
-			debugt("recal interrupt need 2 recal:");
+			debugt(__func__, "need 2 recal");
 			/* If we already did a recalibrate,
 			 * and we are not at track 0, this
 			 * means we have moved. (The only way
@@ -1687,7 +1687,7 @@ static void recal_interrupt(void)
 			DRS->select_date = jiffies;
 			/* fall through */
 		default:
-			debugt("recal interrupt default:");
+			debugt(__func__, "default");
 			/* Recalibrate moves the head by at
 			 * most 80 steps. If after one
 			 * recalibrate we don't have reached
@@ -1777,7 +1777,7 @@ irqreturn_t floppy_interrupt(int irq, vo
 
 static void recalibrate_floppy(void)
 {
-	debugt("recalibrate floppy:");
+	debugt(__func__, "");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
 	if (output_byte(UNIT(current_drive)) < 0)
@@ -1789,7 +1789,7 @@ static void recalibrate_floppy(void)
  */
 static void reset_interrupt(void)
 {
-	debugt("reset interrupt:");
+	debugt(__func__, "");
 	result();		/* get the status ready for set_fdc */
 	if (FDCS->reset) {
 		pr_info("reset set in interrupt, calling %pf\n", cont->error);
@@ -2221,7 +2221,7 @@ static void redo_format(void)
 	buffer_track = -1;
 	setup_format_params(format_req.track << STRETCH(_floppy));
 	floppy_start();
-	debugt("queue format request");
+	debugt(__func__, "queue format request");
 }
 
 static struct cont_t format_cont = {
@@ -2918,7 +2918,7 @@ do_request:
 	if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
 		twaddle();
 	schedule_bh(floppy_start);
-	debugt("queue fd request");
+	debugt(__func__, "queue fd request");
 	return;
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

