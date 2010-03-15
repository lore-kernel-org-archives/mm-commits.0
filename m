From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-add-debug_dcl-macro.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:49 -0400
Message-ID: <201003150654.o2F6sN1p016063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759617Ab0COGyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: add debug_dcl(...) macro
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-add-debug_dcl-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: add debug_dcl(...) macro
From: Joe Perches <joe@perches.com>

Converted #ifdef DCL_DEBUG if (test) DPRINTK(...); #endif
to debug_dcl(test, ...);

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   83 ++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 52 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-add-debug_dcl-macro drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-add-debug_dcl-macro
+++ a/drivers/block/floppy.c
@@ -152,6 +152,15 @@
 #define DEBUGT 2
 #define DCL_DEBUG		/* debug disk change line */
 
+#ifdef DCL_DEBUG
+#define debug_dcl(test, fmt, args...) \
+	do { if ((test) & FD_DEBUG) DPRINT(fmt, ##args); } while (0)
+#else
+#define debug_dcl(test, fmt, args...) \
+	do { if (0) DPRINT(fmt, ##args); } while (0)
+#endif
+
+
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
 #include <linux/module.h>
@@ -748,14 +757,12 @@ static int disk_change(int drive)
 	}
 #endif
 
-#ifdef DCL_DEBUG
-	if (UDP->flags & FD_DEBUG) {
-		DPRINT("checking disk change line for drive %d\n", drive);
-		DPRINT("jiffies=%lu\n", jiffies);
-		DPRINT("disk change line=%x\n", fd_inb(FD_DIR) & 0x80);
-		DPRINT("flags=%lx\n", UDRS->flags);
-	}
-#endif
+	debug_dcl(UDP->flags,
+		  "checking disk change line for drive %d\n", drive);
+	debug_dcl(UDP->flags, "jiffies=%lu\n", jiffies);
+	debug_dcl(UDP->flags, "disk change line=%x\n", fd_inb(FD_DIR) & 0x80);
+	debug_dcl(UDP->flags, "flags=%lx\n", UDRS->flags);
+
 	if (UDP->flags & FD_BROKEN_DCL)
 		return UTESTF(FD_DISK_CHANGED);
 	if ((fd_inb(FD_DIR) ^ UDP->flags) & 0x80) {
@@ -804,10 +811,8 @@ static int set_dor(int fdc, char mask, c
 		unit = olddor & 0x3;
 		if (is_selected(olddor, unit) && !is_selected(newdor, unit)) {
 			drive = REVDRIVE(fdc, unit);
-#ifdef DCL_DEBUG
-			if (UDP->flags & FD_DEBUG)
-				DPRINT("calling disk change from set_dor\n");
-#endif
+			debug_dcl(UDP->flags,
+				  "calling disk change from set_dor\n");
 			disk_change(drive);
 		}
 		FDCS->dor = newdor;
@@ -1020,10 +1025,7 @@ static void cancel_activity(void)
  * transfer */
 static void fd_watchdog(void)
 {
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from watchdog\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from watchdog\n");
 
 	if (disk_change(current_drive)) {
 		DPRINT("disk removed during i/o\n");
@@ -1582,12 +1584,9 @@ static void seek_interrupt(void)
 		return;
 	}
 	if (DRS->track >= 0 && DRS->track != ST1 && !blind_seek) {
-#ifdef DCL_DEBUG
-		if (DP->flags & FD_DEBUG) {
-			DPRINT("clearing NEWCHANGE flag because of effective seek\n");
-			DPRINT("jiffies=%lu\n", jiffies);
-		}
-#endif
+		debug_dcl(DP->flags,
+			  "clearing NEWCHANGE flag because of effective seek\n");
+		debug_dcl(DP->flags, "jiffies=%lu\n", jiffies);
 		CLEARF(FD_DISK_NEWCHANGE);	/* effective seek */
 		DRS->select_date = jiffies;
 	}
@@ -1607,12 +1606,9 @@ static void check_wp(void)
 		}
 		CLEARF(FD_VERIFY);
 		CLEARF(FD_NEED_TWADDLE);
-#ifdef DCL_DEBUG
-		if (DP->flags & FD_DEBUG) {
-			DPRINT("checking whether disk is write protected\n");
-			DPRINT("wp=%x\n", ST3 & 0x40);
-		}
-#endif
+		debug_dcl(DP->flags,
+			  "checking whether disk is write protected\n");
+		debug_dcl(DP->flags, "wp=%x\n", ST3 & 0x40);
 		if (!(ST3 & 0x40))
 			SETF(FD_DISK_WRITABLE);
 		else
@@ -1626,10 +1622,7 @@ static void seek_floppy(void)
 
 	blind_seek = 0;
 
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from seek\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from seek\n");
 
 	if (!TESTF(FD_DISK_NEWCHANGE) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
@@ -1705,10 +1698,8 @@ static void recal_interrupt(void)
 			 * not to move at recalibration is to
 			 * be already at track 0.) Clear the
 			 * new change flag */
-#ifdef DCL_DEBUG
-			if (DP->flags & FD_DEBUG)
-				DPRINT("clearing NEWCHANGE flag because of second recalibrate\n");
-#endif
+			debug_dcl(DP->flags,
+				  "clearing NEWCHANGE flag because of second recalibrate\n");
 
 			CLEARF(FD_DISK_NEWCHANGE);
 			DRS->select_date = jiffies;
@@ -1968,10 +1959,7 @@ static void floppy_ready(void)
 	if (fdc_dtr())
 		return;
 
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from floppy_ready\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from floppy_ready\n");
 	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR) &&
 	    disk_change(current_drive) && !DP->select_delay)
 		twaddle();	/* this clears the dcl on certain
@@ -2002,10 +1990,7 @@ static void floppy_start(void)
 	reschedule_timeout(current_reqD, "floppy start", 0);
 
 	scandrives();
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("setting NEWCHANGE in floppy_start\n");
-#endif
+	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
 	SETF(FD_DISK_NEWCHANGE);
 	floppy_ready();
 }
@@ -3024,10 +3009,7 @@ static int poll_drive(int interruptible,
 	raw_cmd->track = 0;
 	raw_cmd->cmd_count = 0;
 	cont = &poll_cont;
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("setting NEWCHANGE in poll_drive\n");
-#endif
+	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
 	SETF(FD_DISK_NEWCHANGE);
 	WAIT(floppy_ready);
 	return ret;
@@ -3290,10 +3272,7 @@ static int raw_cmd_ioctl(int cmd, void _
 	raw_cmd = my_raw_cmd;
 	cont = &raw_cmd_cont;
 	ret = wait_til_done(floppy_start, 1);
-#ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG)
-		DPRINT("calling disk change from raw_cmd ioctl\n");
-#endif
+	debug_dcl(DP->flags, "calling disk change from raw_cmd ioctl\n");
 
 	if (ret != -EINTR && FDCS->reset)
 		ret = -EIO;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

