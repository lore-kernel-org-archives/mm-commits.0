From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:48 -0800
Message-ID: <201001270037.o0R0bm2R032558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755296Ab0A0AtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove [U]CLEARF, [U]SETF, and [U]TESTF macros
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-clearf-setf-and-testf-macros.patch

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
Subject: drivers/block/floppy.c: remove [U]CLEARF, [U]SETF, and [U]TESTF macros
From: Joe Perches <joe@perches.com>

Use clear_bit, set_bit, and test_bit functions directly

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   94 +++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-clearf-setf-and-testf-macros drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-clearf-setf-and-testf-macros
+++ a/drivers/block/floppy.c
@@ -305,17 +305,11 @@ static int initialising = 1;
 #define DRS	(&drive_state[current_drive])
 #define DRWE	(&write_errors[current_drive])
 #define FDCS	(&fdc_state[fdc])
-#define CLEARF(x)	clear_bit(x##_BIT, &DRS->flags)
-#define SETF(x)		set_bit(x##_BIT, &DRS->flags)
-#define TESTF(x)	test_bit(x##_BIT, &DRS->flags)
 
 #define UDP	(&drive_params[drive])
 #define UDRS	(&drive_state[drive])
 #define UDRWE	(&write_errors[drive])
 #define UFDCS	(&fdc_state[FDC(drive)])
-#define UCLEARF(x)	clear_bit(x##_BIT, &UDRS->flags)
-#define USETF(x)	set_bit(x##_BIT, &UDRS->flags)
-#define UTESTF(x)	test_bit(x##_BIT, &UDRS->flags)
 
 #define DPRINT(format, args...) \
 	pr_info(DEVICE_NAME "%d: " format, current_drive, ##args)
@@ -764,13 +758,13 @@ static int disk_change(int drive)
 	debug_dcl(UDP->flags, "flags=%lx\n", UDRS->flags);
 
 	if (UDP->flags & FD_BROKEN_DCL)
-		return UTESTF(FD_DISK_CHANGED);
+		return test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 	if ((fd_inb(FD_DIR) ^ UDP->flags) & 0x80) {
-		USETF(FD_VERIFY);	/* verify write protection */
-		if (UDRS->maxblock) {
-			/* mark it changed */
-			USETF(FD_DISK_CHANGED);
-		}
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
+					/* verify write protection */
+
+		if (UDRS->maxblock)	/* mark it changed */
+			set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 
 		/* invalidate its geometry */
 		if (UDRS->keep_data >= 0) {
@@ -785,7 +779,7 @@ static int disk_change(int drive)
 		return 1;
 	} else {
 		UDRS->last_checked = jiffies;
-		UCLEARF(FD_DISK_NEWCHANGE);
+		clear_bit(FD_DISK_NEWCHANGE_BIT, &UDRS->flags);
 	}
 	return 0;
 }
@@ -1477,11 +1471,11 @@ static int interpret_errors(void)
 		bad = 1;
 		if (ST1 & ST1_WP) {
 			DPRINT("Drive is write protected\n");
-			CLEARF(FD_DISK_WRITABLE);
+			clear_bit(FD_DISK_WRITABLE_BIT, &DRS->flags);
 			cont->done(0);
 			bad = 2;
 		} else if (ST1 & ST1_ND) {
-			SETF(FD_NEED_TWADDLE);
+			set_bit(FD_NEED_TWADDLE_BIT, &DRS->flags);
 		} else if (ST1 & ST1_OR) {
 			if (DP->flags & FTD_MSG)
 				DPRINT("Over/Underrun - retrying\n");
@@ -1587,7 +1581,8 @@ static void seek_interrupt(void)
 		debug_dcl(DP->flags,
 			  "clearing NEWCHANGE flag because of effective seek\n");
 		debug_dcl(DP->flags, "jiffies=%lu\n", jiffies);
-		CLEARF(FD_DISK_NEWCHANGE);	/* effective seek */
+		clear_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
+					/* effective seek */
 		DRS->select_date = jiffies;
 	}
 	DRS->track = ST1;
@@ -1596,23 +1591,23 @@ static void seek_interrupt(void)
 
 static void check_wp(void)
 {
-	if (TESTF(FD_VERIFY)) {
-		/* check write protection */
+	if (test_bit(FD_VERIFY_BIT, &DRS->flags)) {
+					/* check write protection */
 		output_byte(FD_GETSTATUS);
 		output_byte(UNIT(current_drive));
 		if (result() != 1) {
 			FDCS->reset = 1;
 			return;
 		}
-		CLEARF(FD_VERIFY);
-		CLEARF(FD_NEED_TWADDLE);
+		clear_bit(FD_VERIFY_BIT, &DRS->flags);
+		clear_bit(FD_NEED_TWADDLE_BIT, &DRS->flags);
 		debug_dcl(DP->flags,
 			  "checking whether disk is write protected\n");
 		debug_dcl(DP->flags, "wp=%x\n", ST3 & 0x40);
 		if (!(ST3 & 0x40))
-			SETF(FD_DISK_WRITABLE);
+			set_bit(FD_DISK_WRITABLE_BIT, &DRS->flags);
 		else
-			CLEARF(FD_DISK_WRITABLE);
+			clear_bit(FD_DISK_WRITABLE_BIT, &DRS->flags);
 	}
 }
 
@@ -1624,13 +1619,13 @@ static void seek_floppy(void)
 
 	debug_dcl(DP->flags, "calling disk change from seek\n");
 
-	if (!TESTF(FD_DISK_NEWCHANGE) &&
+	if (!test_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
 		/* the media changed flag should be cleared after the seek.
 		 * If it isn't, this means that there is really no disk in
 		 * the drive.
 		 */
-		SETF(FD_DISK_CHANGED);
+		set_bit(FD_DISK_CHANGED_BIT, &DRS->flags);
 		cont->done(0);
 		cont->redo();
 		return;
@@ -1638,7 +1633,7 @@ static void seek_floppy(void)
 	if (DRS->track <= NEED_1_RECAL) {
 		recalibrate_floppy();
 		return;
-	} else if (TESTF(FD_DISK_NEWCHANGE) &&
+	} else if (test_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags) &&
 		   (raw_cmd->flags & FD_RAW_NEED_DISK) &&
 		   (DRS->track <= NO_TRACK || DRS->track == raw_cmd->track)) {
 		/* we seek to clear the media-changed condition. Does anybody
@@ -1701,7 +1696,7 @@ static void recal_interrupt(void)
 			debug_dcl(DP->flags,
 				  "clearing NEWCHANGE flag because of second recalibrate\n");
 
-			CLEARF(FD_DISK_NEWCHANGE);
+			clear_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
 			DRS->select_date = jiffies;
 			/* fall through */
 		default:
@@ -1991,7 +1986,7 @@ static void floppy_start(void)
 
 	scandrives();
 	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
-	SETF(FD_DISK_NEWCHANGE);
+	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
 	floppy_ready();
 }
 
@@ -2647,7 +2642,8 @@ static int make_raw_rw_request(void)
 	HEAD = fsector_t / _floppy->sect;
 
 	if (((_floppy->stretch & (FD_SWAPSIDES | FD_SECTBASEMASK)) ||
-	     TESTF(FD_NEED_TWADDLE)) && fsector_t < _floppy->sect)
+	     test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags)) &&
+	    fsector_t < _floppy->sect)
 		max_sector = _floppy->sect;
 
 	/* 2M disks have phantom sectors on the first track */
@@ -2919,7 +2915,7 @@ static void redo_fd_request(void)
 			return;
 		disk_change(current_drive);
 		if (test_bit(current_drive, &fake_change) ||
-		    TESTF(FD_DISK_CHANGED)) {
+		    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
 			DPRINT("disk absent or changed during operation\n");
 			REPEAT;
 		}
@@ -2944,7 +2940,7 @@ static void redo_fd_request(void)
 			continue;
 		}
 
-		if (TESTF(FD_NEED_TWADDLE))
+		if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
 			twaddle();
 		schedule_bh(floppy_start);
 		debugt("queue fd request");
@@ -3010,7 +3006,7 @@ static int poll_drive(int interruptible,
 	raw_cmd->cmd_count = 0;
 	cont = &poll_cont;
 	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
-	SETF(FD_DISK_NEWCHANGE);
+	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
 	WAIT(floppy_ready);
 	return ret;
 }
@@ -3502,8 +3498,8 @@ static int fd_ioctl(struct block_device 
 		 * non-Sparc architectures */
 		ret = fd_eject(UNIT(drive));
 
-		USETF(FD_DISK_CHANGED);
-		USETF(FD_VERIFY);
+		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 		process_fd_request();
 		return ret;
 	case FDCLRPRM:
@@ -3700,8 +3696,8 @@ static int floppy_open(struct block_devi
 		goto out2;
 
 	if (!UDRS->fd_ref && (UDP->flags & FD_BROKEN_DCL)) {
-		USETF(FD_DISK_CHANGED);
-		USETF(FD_VERIFY);
+		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 	}
 
 	if (UDRS->fd_ref == -1 || (UDRS->fd_ref && (mode & FMODE_EXCL)))
@@ -3761,11 +3757,12 @@ static int floppy_open(struct block_devi
 		if (mode & (FMODE_READ|FMODE_WRITE)) {
 			UDRS->last_checked = 0;
 			check_disk_change(bdev);
-			if (UTESTF(FD_DISK_CHANGED))
+			if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
 				goto out;
 		}
 		res = -EROFS;
-		if ((mode & FMODE_WRITE) && !(UTESTF(FD_DISK_WRITABLE)))
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
 			goto out;
 	}
 	mutex_unlock(&open_lock);
@@ -3789,7 +3786,8 @@ static int check_floppy_change(struct ge
 {
 	int drive = (long)disk->private_data;
 
-	if (UTESTF(FD_DISK_CHANGED) || UTESTF(FD_VERIFY))
+	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+	    test_bit(FD_VERIFY_BIT, &UDRS->flags))
 		return 1;
 
 	if (time_after(jiffies, UDRS->last_checked + UDP->checkfreq)) {
@@ -3798,8 +3796,8 @@ static int check_floppy_change(struct ge
 		process_fd_request();
 	}
 
-	if (UTESTF(FD_DISK_CHANGED) ||
-	    UTESTF(FD_VERIFY) ||
+	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) ||
 	    (!ITYPE(UDRS->fd_device) && !current_type[drive]))
 		return 1;
@@ -3870,14 +3868,16 @@ static int floppy_revalidate(struct gend
 	int cf;
 	int res = 0;
 
-	if (UTESTF(FD_DISK_CHANGED) ||
-	    UTESTF(FD_VERIFY) || test_bit(drive, &fake_change) || NO_GEOM) {
+	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
+	    test_bit(drive, &fake_change) || NO_GEOM) {
 		if (usage_count == 0) {
 			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
 		lock_fdc(drive, 0);
-		cf = UTESTF(FD_DISK_CHANGED) || UTESTF(FD_VERIFY);
+		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
+		      test_bit(FD_VERIFY_BIT, &UDRS->flags));
 		if (!(cf || test_bit(drive, &fake_change) || NO_GEOM)) {
 			process_fd_request();	/*already done by another thread */
 			return 0;
@@ -3887,7 +3887,7 @@ static int floppy_revalidate(struct gend
 		if (buffer_drive == drive)
 			buffer_track = -1;
 		clear_bit(drive, &fake_change);
-		UCLEARF(FD_DISK_CHANGED);
+		clear_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 		if (cf)
 			UDRS->generation++;
 		if (NO_GEOM) {
@@ -4277,9 +4277,9 @@ static int __init floppy_init(void)
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		memset(UDRS, 0, sizeof(*UDRS));
 		memset(UDRWE, 0, sizeof(*UDRWE));
-		USETF(FD_DISK_NEWCHANGE);
-		USETF(FD_DISK_CHANGED);
-		USETF(FD_VERIFY);
+		set_bit(FD_DISK_NEWCHANGE_BIT, &UDRS->flags);
+		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
+		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 		UDRS->fd_device = -1;
 		floppy_track_buffer = NULL;
 		max_buffer_sectors = 0;
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

