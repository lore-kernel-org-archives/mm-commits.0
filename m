From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:10 -0400
Message-ID: <201003150654.o2F6shSr016087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759729Ab0COGyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: convert int 1/0 to bool true/false
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-convert-int-1-0-to-bool-true-false.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

