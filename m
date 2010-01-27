From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-unnecessary-braces.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:26 -0800
Message-ID: <201001270037.o0R0bQAC032520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754232Ab0A0AiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove unnecessary braces
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-unnecessary-braces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove unnecessary braces
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   44 +++++++++++++++------------------------
 1 file changed, 17 insertions(+), 27 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-braces drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-braces
+++ a/drivers/block/floppy.c
@@ -686,9 +686,8 @@ static void __reschedule_timeout(int dri
 	} else
 		fd_timeout.expires = jiffies + UDP->timeout;
 	add_timer(&fd_timeout);
-	if (UDP->flags & FD_DEBUG) {
+	if (UDP->flags & FD_DEBUG)
 		DPRINT("reschedule timeout %s %d\n", message, marg);
-	}
 	timeout_message = message;
 }
 
@@ -809,9 +808,8 @@ static int set_dor(int fdc, char mask, c
 		if (is_selected(olddor, unit) && !is_selected(newdor, unit)) {
 			drive = REVDRIVE(fdc, unit);
 #ifdef DCL_DEBUG
-			if (UDP->flags & FD_DEBUG) {
+			if (UDP->flags & FD_DEBUG)
 				DPRINT("calling disk change from set_dor\n");
-			}
 #endif
 			disk_change(drive);
 		}
@@ -1030,9 +1028,8 @@ static void cancel_activity(void)
 static void fd_watchdog(void)
 {
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from watchdog\n");
-	}
 #endif
 
 	if (disk_change(current_drive)) {
@@ -1369,9 +1366,9 @@ static void fdc_specify(void)
 
 	/* Convert step rate from microseconds to milliseconds and 4 bits */
 	srt = 16 - DIV_ROUND_UP(DP->srt * scale_dtr / 1000, NOMINAL_DTR);
-	if (slow_floppy) {
+	if (slow_floppy)
 		srt = srt / 4;
-	}
+
 	SUPBOUND(srt, 0xf);
 	INFBOUND(srt, 0);
 
@@ -1635,9 +1632,8 @@ static void seek_floppy(void)
 	blind_seek = 0;
 
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from seek\n");
-	}
 #endif
 
 	if (!TESTF(FD_DISK_NEWCHANGE) &&
@@ -1969,9 +1965,8 @@ static void floppy_ready(void)
 		return;
 
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from floppy_ready\n");
-	}
 #endif
 	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR) &&
 	    disk_change(current_drive) && !DP->select_delay)
@@ -2004,9 +1999,8 @@ static void floppy_start(void)
 
 	scandrives();
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("setting NEWCHANGE in floppy_start\n");
-	}
 #endif
 	SETF(FD_DISK_NEWCHANGE);
 	floppy_ready();
@@ -2758,9 +2752,8 @@ static int make_raw_rw_request(void)
 		dma_limit =
 		    (MAX_DMA_ADDRESS -
 		     ((unsigned long)current_req->buffer)) >> 9;
-		if ((unsigned long)max_size > dma_limit) {
+		if ((unsigned long)max_size > dma_limit)
 			max_size = dma_limit;
-		}
 		/* 64 kb boundaries */
 		if (CROSS_64KB(current_req->buffer, max_size << 9))
 			max_size = (K_64 -
@@ -3026,9 +3019,8 @@ static int poll_drive(int interruptible,
 	raw_cmd->cmd_count = 0;
 	cont = &poll_cont;
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("setting NEWCHANGE in poll_drive\n");
-	}
 #endif
 	SETF(FD_DISK_NEWCHANGE);
 	WAIT(floppy_ready);
@@ -3291,9 +3283,8 @@ static int raw_cmd_ioctl(int cmd, void _
 	cont = &raw_cmd_cont;
 	ret = wait_til_done(floppy_start, 1);
 #ifdef DCL_DEBUG
-	if (DP->flags & FD_DEBUG) {
+	if (DP->flags & FD_DEBUG)
 		DPRINT("calling disk change from raw_cmd ioctl\n");
-	}
 #endif
 
 	if (ret != -EINTR && FDCS->reset)
@@ -3486,18 +3477,18 @@ static int fd_ioctl(struct block_device 
 	 * We do this in order to provide a means to eject floppy disks before
 	 * installing the new fdutils package */
 	if (cmd == CDROMEJECT ||	/* CD-ROM eject */
-	    cmd == 0x6470 /* SunOS floppy eject */ ) {
+	    cmd == 0x6470) {		/* SunOS floppy eject */
 		DPRINT("obsolete eject ioctl\n");
 		DPRINT("please use floppycontrol --eject\n");
 		cmd = FDEJECT;
 	}
 
-	/* convert the old style command into a new style command */
-	if ((cmd & 0xff00) == 0x0200) {
-		ECALL(normalize_ioctl(&cmd, &size));
-	} else
+	if (!((cmd & 0xff00) == 0x0200))
 		return -EINVAL;
 
+	/* convert the old style command into a new style command */
+	ECALL(normalize_ioctl(&cmd, &size));
+
 	/* permission checks */
 	if (((cmd & 0x40) && !FD_IOCTL_ALLOWED) ||
 	    ((cmd & 0x80) && !capable(CAP_SYS_ADMIN)))
@@ -3746,9 +3737,8 @@ static int floppy_open(struct block_devi
 			INFBOUND(try, 16);
 			tmp = (char *)fd_dma_mem_alloc(1024 * try);
 		}
-		if (!tmp && !floppy_track_buffer) {
+		if (!tmp && !floppy_track_buffer)
 			fallback_on_nodma_alloc(&tmp, 2048 * try);
-		}
 		if (!tmp && !floppy_track_buffer) {
 			DPRINT("Unable to allocate DMA memory\n");
 			goto out;
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
net-rds-remove-uses-of-nipquad-use-%pi4.patch
net-sunrpc-remove-uses-of-nipquad-use-%pi4.patch
fs-ocfs2-cluster-tcpc-remove-use-of-nipquad-use-%pi4.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-remove-uses-of-nipquad-use-%pi4.patch
drivers-firmware-iscsi_ibftc-remove-nipquad_fmt-use-%pi4.patch
drivers-block-floppyc-convert-some-include-asm-to-include-linux.patch
drivers-block-floppyc-define-space-and-column-neatening.patch
drivers-block-floppyc-use-pr_level.patch
drivers-block-floppyc-remove-unnecessary-braces.patch
drivers-block-floppyc-remove-used-once-check_ready-macro.patch
drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch
drivers-block-floppyc-remove-last_out-macro.patch
drivers-block-floppyc-comment-neatening-and-remove-naked.patch
drivers-block-floppyc-remove-clearstruct-macro-use-memset.patch
drivers-block-floppyc-indent-a-comment.patch
drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch
drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch
drivers-block-floppyc-remove-macro-lock_fdc.patch
drivers-block-floppyc-add-debug_dcl-macro.patch
drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch
drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch
drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch
drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch
drivers-block-floppyc-move-leading-and-to-preceding-line.patch
drivers-block-floppyc-remove-define-device_name-floppy.patch
drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch
drivers-block-floppyc-add-function-is_ready_state.patch
drivers-block-floppyc-remove-unnecessary-return-and-braces.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses.patch
scripts-get_maintainerpl-add-file-emails-find-embedded-email-addresses-v2.patch
scripts-get_maintainerpl-add-sections-print-entire-matched-subsystem.patch
scripts-get_maintainerpl-change-sections-to-print-in-the-same-style-as-maintainers.patch
maintainers-remove-amd-geode-f-arch-x86-kernel-geode_32c.patch
maintainers-remove-hayes-esp-serial-driver.patch
maintainers-update-performance-events-f-patterns.patch
maintainers-starmode-radio-ip-strip-moved-to-staging.patch
maintainers-wavelan-moved-to-staging.patch
lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch
scripts-checkpatchpl-add-warn-on-sizeof.patch
checkpatchpl-allow-80-char-lines-for-logging-functions-not-just-printk.patch

