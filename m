From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:56 -0800
Message-ID: <201001270037.o0R0budi032572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab0A0Aib (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:38:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: convert int 1/0 to bool true/false
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch

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
Subject: drivers/block/floppy.c: convert int 1/0 to bool true/false
From: Joe Perches <joe@perches.com>

Various functions use int where bool is appropriate
lock_fdc, wait_til_done, poll_drive, user_reset_fdc

Convert to bool.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   60 +++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-convert-int-1-0-to-bool-true-false drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-convert-int-1-0-to-bool-true-false
+++ a/drivers/block/floppy.c
@@ -862,7 +862,7 @@ static void set_fdc(int drive)
 }
 
 /* locks the driver */
-static int _lock_fdc(int drive, int interruptible, int line)
+static int _lock_fdc(int drive, bool interruptible, int line)
 {
 	if (!usage_count) {
 		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
@@ -2021,7 +2021,7 @@ static struct cont_t intr_cont = {
 	.done		= (done_f)empty
 };
 
-static int wait_til_done(void (*handler)(void), int interruptible)
+static int wait_til_done(void (*handler)(void), bool interruptible)
 {
 	int ret;
 
@@ -2247,7 +2247,7 @@ static int do_format(int drive, struct f
 {
 	int ret;
 
-	if (lock_fdc(drive, 1))
+	if (lock_fdc(drive, true))
 		return -EINTR;
 
 	set_floppy(drive);
@@ -2264,7 +2264,7 @@ static int do_format(int drive, struct f
 	format_errors = 0;
 	cont = &format_cont;
 	errors = &format_errors;
-	ret = wait_til_done(redo_format, 1);
+	ret = wait_til_done(redo_format, true);
 	if (ret == -EINTR)
 		return -EINTR;
 	process_fd_request();
@@ -2980,7 +2980,7 @@ static void do_fd_request(struct request
 		is_alive("do fd request, old request running");
 		return;
 	}
-	lock_fdc(MAXTIMEOUT, 0);
+	lock_fdc(MAXTIMEOUT, false);
 	process_fd_request();
 	is_alive("do fd request");
 }
@@ -2992,7 +2992,7 @@ static struct cont_t poll_cont = {
 	.done		= generic_done
 };
 
-static int poll_drive(int interruptible, int flag)
+static int poll_drive(bool interruptible, int flag)
 {
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
@@ -3023,7 +3023,7 @@ static struct cont_t reset_cont = {
 	.done		= generic_done
 };
 
-static int user_reset_fdc(int drive, int arg, int interruptible)
+static int user_reset_fdc(int drive, int arg, bool interruptible)
 {
 	int ret;
 
@@ -3265,7 +3265,7 @@ static int raw_cmd_ioctl(int cmd, void _
 
 	raw_cmd = my_raw_cmd;
 	cont = &raw_cmd_cont;
-	ret = wait_til_done(floppy_start, 1);
+	ret = wait_til_done(floppy_start, true);
 	debug_dcl(DP->flags, "calling disk change from raw_cmd ioctl\n");
 
 	if (ret != -EINTR && FDCS->reset)
@@ -3305,7 +3305,7 @@ static inline int set_geometry(unsigned 
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		mutex_lock(&open_lock);
-		if (lock_fdc(drive, 1)) {
+		if (lock_fdc(drive, true)) {
 			mutex_unlock(&open_lock);
 			return -EINTR;
 		}
@@ -3325,12 +3325,12 @@ static inline int set_geometry(unsigned 
 	} else {
 		int oldStretch;
 
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		if (cmd != FDDEFPRM) {
 			/* notice a disk change immediately, else
 			 * we lose our settings immediately*/
-			if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+			if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 				return -EINTR;
 		}
 		oldStretch = g->stretch;
@@ -3411,9 +3411,9 @@ static int get_floppy_geometry(int drive
 	if (type)
 		*g = &floppy_type[type];
 	else {
-		if (lock_fdc(drive, 0))
+		if (lock_fdc(drive, false))
 			return -EINTR;
-		if (poll_drive(0, 0) == -EINTR)
+		if (poll_drive(false, 0) == -EINTR)
 			return -EINTR;
 		process_fd_request();
 		*g = current_type[drive];
@@ -3497,7 +3497,7 @@ static int fd_ioctl(struct block_device 
 		if (UDRS->fd_ref != 1)
 			/* somebody else has this drive open */
 			return -EBUSY;
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 
 		/* do the actual eject. Fails on
@@ -3509,7 +3509,7 @@ static int fd_ioctl(struct block_device 
 		process_fd_request();
 		return ret;
 	case FDCLRPRM:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		current_type[drive] = NULL;
 		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
@@ -3532,9 +3532,9 @@ static int fd_ioctl(struct block_device 
 		UDP->flags &= ~FTD_MSG;
 		return 0;
 	case FDFMTBEG:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
-		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 			return -EINTR;
 		ret = UDRS->flags;
 		process_fd_request();
@@ -3549,7 +3549,7 @@ static int fd_ioctl(struct block_device 
 		return do_format(drive, &inparam.f);
 	case FDFMTEND:
 	case FDFLUSH:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		return invalidate_drive(bdev);
 	case FDSETEMSGTRESH:
@@ -3572,9 +3572,9 @@ static int fd_ioctl(struct block_device 
 		outparam = (const char *)UDP;
 		break;
 	case FDPOLLDRVSTAT:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
-		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+		if (poll_drive(true, FD_RAW_NEED_DISK) == -EINTR)
 			return -EINTR;
 		process_fd_request();
 		/* fall through */
@@ -3582,7 +3582,7 @@ static int fd_ioctl(struct block_device 
 		outparam = (const char *)UDRS;
 		break;
 	case FDRESET:
-		return user_reset_fdc(drive, (int)param, 1);
+		return user_reset_fdc(drive, (int)param, true);
 	case FDGETFDCSTAT:
 		outparam = (const char *)UFDCS;
 		break;
@@ -3595,7 +3595,7 @@ static int fd_ioctl(struct block_device 
 	case FDRAWCMD:
 		if (type)
 			return -EINVAL;
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		set_floppy(drive);
 		i = raw_cmd_ioctl(cmd, (void __user *)param);
@@ -3604,7 +3604,7 @@ static int fd_ioctl(struct block_device 
 		process_fd_request();
 		return i;
 	case FDTWADDLE:
-		if (lock_fdc(drive, 1))
+		if (lock_fdc(drive, true))
 			return -EINTR;
 		twaddle();
 		process_fd_request();
@@ -3803,8 +3803,8 @@ static int check_floppy_change(struct ge
 		return 1;
 
 	if (time_after(jiffies, UDRS->last_checked + UDP->checkfreq)) {
-		lock_fdc(drive, 0);
-		poll_drive(0, 0);
+		lock_fdc(drive, false);
+		poll_drive(false, 0);
 		process_fd_request();
 	}
 
@@ -3887,7 +3887,7 @@ static int floppy_revalidate(struct gend
 			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
-		lock_fdc(drive, 0);
+		lock_fdc(drive, false);
 		cf = (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 		      test_bit(FD_VERIFY_BIT, &UDRS->flags));
 		if (!(cf || test_bit(drive, &fake_change) || NO_GEOM)) {
@@ -3907,7 +3907,7 @@ static int floppy_revalidate(struct gend
 			res = __floppy_read_block_0(opened_bdev[drive]);
 		} else {
 			if (cf)
-				poll_drive(0, FD_RAW_NEED_DISK);
+				poll_drive(false, FD_RAW_NEED_DISK);
 			process_fd_request();
 		}
 	}
@@ -4164,7 +4164,7 @@ static int floppy_resume(struct device *
 
 	for (fdc = 0; fdc < N_FDC; fdc++)
 		if (FDCS->address != -1)
-			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
+			user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 
 	return 0;
 }
@@ -4311,7 +4311,7 @@ static int __init floppy_init(void)
 		if (FDCS->address == -1)
 			continue;
 		FDCS->rawcmd = 2;
-		if (user_reset_fdc(-1, FD_RESET_ALWAYS, 0)) {
+		if (user_reset_fdc(-1, FD_RESET_ALWAYS, false)) {
 			/* free ioports reserved by floppy_grab_irq_and_dma() */
 			floppy_release_regions(fdc);
 			FDCS->address = -1;
@@ -4334,7 +4334,7 @@ static int __init floppy_init(void)
 		 * properly, so force a reset for the standard FDC clones,
 		 * to avoid interrupt garbage.
 		 */
-		user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
+		user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 	}
 	fdc = 0;
 	del_timer(&fd_timeout);
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

