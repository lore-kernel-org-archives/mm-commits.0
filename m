From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-macro-lock_fdc.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:44 -0800
Message-ID: <201001270037.o0R0biRO032552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800Ab0A0Ary (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:47:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove macro LOCK_FDC
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-macro-lock_fdc.patch

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
Subject: drivers/block/floppy.c: remove macro LOCK_FDC
From: Joe Perches <joe@perches.com>

Macros with hidden returns aren't nice.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   43 +++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-macro-lock_fdc drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-macro-lock_fdc
+++ a/drivers/block/floppy.c
@@ -908,10 +908,6 @@ static int _lock_fdc(int drive, int inte
 #define lock_fdc(drive, interruptible)			\
 	_lock_fdc(drive, interruptible, __LINE__)
 
-#define LOCK_FDC(drive, interruptible)	    \
-	if (lock_fdc(drive, interruptible)) \
-		return -EINTR;
-
 /* unlocks the driver */
 static inline void unlock_fdc(void)
 {
@@ -2276,7 +2272,9 @@ static int do_format(int drive, struct f
 {
 	int ret;
 
-	LOCK_FDC(drive, 1);
+	if (lock_fdc(drive, 1))
+		return -EINTR;
+
 	set_floppy(drive);
 	if (!_floppy ||
 	    _floppy->track > DP->tracks ||
@@ -3056,8 +3054,9 @@ static int user_reset_fdc(int drive, int
 {
 	int ret;
 
-	ret = 0;
-	LOCK_FDC(drive, interruptible);
+	if (lock_fdc(drive, interruptible))
+		return -EINTR;
+
 	if (arg == FD_RESET_ALWAYS)
 		FDCS->reset = 1;
 	if (FDCS->reset) {
@@ -3065,7 +3064,7 @@ static int user_reset_fdc(int drive, int
 		WAIT(reset_fdc);
 	}
 	process_fd_request();
-	return ret;
+	return 0;
 }
 
 /*
@@ -3352,7 +3351,9 @@ static inline int set_geometry(unsigned 
 		mutex_unlock(&open_lock);
 	} else {
 		int oldStretch;
-		LOCK_FDC(drive, 1);
+
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		if (cmd != FDDEFPRM)
 			/* notice a disk change immediately, else
 			 * we lose our settings immediately*/
@@ -3435,7 +3436,8 @@ static int get_floppy_geometry(int drive
 	if (type)
 		*g = &floppy_type[type];
 	else {
-		LOCK_FDC(drive, 0);
+		if (lock_fdc(drive, 0))
+			return -EINTR;
 		CALL(poll_drive(0, 0));
 		process_fd_request();
 		*g = current_type[drive];
@@ -3514,7 +3516,8 @@ static int fd_ioctl(struct block_device 
 		if (UDRS->fd_ref != 1)
 			/* somebody else has this drive open */
 			return -EBUSY;
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 
 		/* do the actual eject. Fails on
 		 * non-Sparc architectures */
@@ -3525,7 +3528,8 @@ static int fd_ioctl(struct block_device 
 		process_fd_request();
 		return ret;
 	case FDCLRPRM:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		current_type[drive] = NULL;
 		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
 		UDRS->keep_data = 0;
@@ -3545,7 +3549,8 @@ static int fd_ioctl(struct block_device 
 		UDP->flags &= ~FTD_MSG;
 		return 0;
 	case FDFMTBEG:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		CALL(poll_drive(1, FD_RAW_NEED_DISK));
 		ret = UDRS->flags;
 		process_fd_request();
@@ -3560,7 +3565,8 @@ static int fd_ioctl(struct block_device 
 		return do_format(drive, &inparam.f);
 	case FDFMTEND:
 	case FDFLUSH:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		return invalidate_drive(bdev);
 	case FDSETEMSGTRESH:
 		UDP->max_errors.reporting = (unsigned short)(param & 0x0f);
@@ -3582,7 +3588,8 @@ static int fd_ioctl(struct block_device 
 		outparam = (const char *)UDP;
 		break;
 	case FDPOLLDRVSTAT:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		CALL(poll_drive(1, FD_RAW_NEED_DISK));
 		process_fd_request();
 		/* fall through */
@@ -3603,13 +3610,15 @@ static int fd_ioctl(struct block_device 
 	case FDRAWCMD:
 		if (type)
 			return -EINVAL;
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		set_floppy(drive);
 		CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
 		process_fd_request();
 		return i;
 	case FDTWADDLE:
-		LOCK_FDC(drive, 1);
+		if (lock_fdc(drive, 1))
+			return -EINTR;
 		twaddle();
 		process_fd_request();
 		return 0;
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

