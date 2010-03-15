From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:34 -0400
Message-ID: <201003150654.o2F6s7v2016045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934452Ab0COGyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove IN/OUT macros, indent switch/case
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove IN/OUT macros, indent switch/case
From: Joe Perches <joe@perches.com>

Remove ugly IN/OUT macros, use direct case and code
Add missing semicolon after ECALL

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |  218 +++++++++++++++++++--------------------
 1 file changed, 107 insertions(+), 111 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-in-out-macros-indent-switch-case drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-in-out-macros-indent-switch-case
+++ a/drivers/block/floppy.c
@@ -3466,8 +3466,6 @@ static int fd_ioctl(struct block_device 
 		    unsigned long param)
 {
 #define FD_IOCTL_ALLOWED (mode & (FMODE_WRITE|FMODE_WRITE_IOCTL))
-#define OUT(c,x) case c: outparam = (const char *) (x); break
-#define IN(c,x,tag) case c: *(x) = inparam. tag ; return 0
 
 	int drive = (long)bdev->bd_disk->private_data;
 	int type = ITYPE(UDRS->fd_device);
@@ -3509,122 +3507,120 @@ static int fd_ioctl(struct block_device 
 	/* copyin */
 	memset(&inparam, 0, sizeof(inparam));
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
-	    ECALL(fd_copyin((void __user *)param, &inparam, size))
+		ECALL(fd_copyin((void __user *)param, &inparam, size));
 
-		switch (cmd) {
-		case FDEJECT:
-			if (UDRS->fd_ref != 1)
-				/* somebody else has this drive open */
-				return -EBUSY;
-			LOCK_FDC(drive, 1);
-
-			/* do the actual eject. Fails on
-			 * non-Sparc architectures */
-			ret = fd_eject(UNIT(drive));
-
-			USETF(FD_DISK_CHANGED);
-			USETF(FD_VERIFY);
-			process_fd_request();
-			return ret;
-		case FDCLRPRM:
-			LOCK_FDC(drive, 1);
-			current_type[drive] = NULL;
-			floppy_sizes[drive] = MAX_DISK_SIZE << 1;
-			UDRS->keep_data = 0;
-			return invalidate_drive(bdev);
-		case FDSETPRM:
-		case FDDEFPRM:
-			return set_geometry(cmd, &inparam.g,
-					    drive, type, bdev);
-		case FDGETPRM:
-			ECALL(get_floppy_geometry(drive, type,
-						  (struct floppy_struct **)
-						  &outparam));
-			break;
-
-		case FDMSGON:
-			UDP->flags |= FTD_MSG;
-			return 0;
-		case FDMSGOFF:
-			UDP->flags &= ~FTD_MSG;
-			return 0;
-
-		case FDFMTBEG:
-			LOCK_FDC(drive, 1);
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
-			ret = UDRS->flags;
-			process_fd_request();
-			if (ret & FD_VERIFY)
-				return -ENODEV;
-			if (!(ret & FD_DISK_WRITABLE))
-				return -EROFS;
-			return 0;
-		case FDFMTTRK:
-			if (UDRS->fd_ref != 1)
-				return -EBUSY;
-			return do_format(drive, &inparam.f);
-		case FDFMTEND:
-		case FDFLUSH:
-			LOCK_FDC(drive, 1);
-			return invalidate_drive(bdev);
-
-		case FDSETEMSGTRESH:
-			UDP->max_errors.reporting =
-			    (unsigned short)(param & 0x0f);
-			return 0;
-			OUT(FDGETMAXERRS, &UDP->max_errors);
-			IN(FDSETMAXERRS, &UDP->max_errors, max_errors);
-
-		case FDGETDRVTYP:
-			outparam = drive_name(type, drive);
-			SUPBOUND(size, strlen(outparam) + 1);
-			break;
-
-			IN(FDSETDRVPRM, UDP, dp);
-			OUT(FDGETDRVPRM, UDP);
-
-		case FDPOLLDRVSTAT:
-			LOCK_FDC(drive, 1);
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
-			process_fd_request();
-			/* fall through */
-			OUT(FDGETDRVSTAT, UDRS);
-
-		case FDRESET:
-			return user_reset_fdc(drive, (int)param, 1);
-
-			OUT(FDGETFDCSTAT, UFDCS);
-
-		case FDWERRORCLR:
-			memset(UDRWE, 0, sizeof(*UDRWE));
-			return 0;
-			OUT(FDWERRORGET, UDRWE);
-
-		case FDRAWCMD:
-			if (type)
-				return -EINVAL;
-			LOCK_FDC(drive, 1);
-			set_floppy(drive);
-			CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
-			process_fd_request();
-			return i;
+	switch (cmd) {
+	case FDEJECT:
+		if (UDRS->fd_ref != 1)
+			/* somebody else has this drive open */
+			return -EBUSY;
+		LOCK_FDC(drive, 1);
 
-		case FDTWADDLE:
-			LOCK_FDC(drive, 1);
-			twaddle();
-			process_fd_request();
-			return 0;
+		/* do the actual eject. Fails on
+		 * non-Sparc architectures */
+		ret = fd_eject(UNIT(drive));
 
-		default:
+		USETF(FD_DISK_CHANGED);
+		USETF(FD_VERIFY);
+		process_fd_request();
+		return ret;
+	case FDCLRPRM:
+		LOCK_FDC(drive, 1);
+		current_type[drive] = NULL;
+		floppy_sizes[drive] = MAX_DISK_SIZE << 1;
+		UDRS->keep_data = 0;
+		return invalidate_drive(bdev);
+	case FDSETPRM:
+	case FDDEFPRM:
+		return set_geometry(cmd, &inparam.g, drive, type, bdev);
+	case FDGETPRM:
+		ECALL(get_floppy_geometry(drive, type,
+					  (struct floppy_struct **)
+					  &outparam));
+		break;
+	case FDMSGON:
+		UDP->flags |= FTD_MSG;
+		return 0;
+	case FDMSGOFF:
+		UDP->flags &= ~FTD_MSG;
+		return 0;
+	case FDFMTBEG:
+		LOCK_FDC(drive, 1);
+		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		ret = UDRS->flags;
+		process_fd_request();
+		if (ret & FD_VERIFY)
+			return -ENODEV;
+		if (!(ret & FD_DISK_WRITABLE))
+			return -EROFS;
+		return 0;
+	case FDFMTTRK:
+		if (UDRS->fd_ref != 1)
+			return -EBUSY;
+		return do_format(drive, &inparam.f);
+	case FDFMTEND:
+	case FDFLUSH:
+		LOCK_FDC(drive, 1);
+		return invalidate_drive(bdev);
+	case FDSETEMSGTRESH:
+		UDP->max_errors.reporting = (unsigned short)(param & 0x0f);
+		return 0;
+	case FDGETMAXERRS:
+		outparam = (const char *)&UDP->max_errors;
+		break;
+	case FDSETMAXERRS:
+		UDP->max_errors = inparam.max_errors;
+		break;
+	case FDGETDRVTYP:
+		outparam = drive_name(type, drive);
+		SUPBOUND(size, strlen(outparam) + 1);
+		break;
+	case FDSETDRVPRM:
+		*UDP = inparam.dp;
+		break;
+	case FDGETDRVPRM:
+		outparam = (const char *)UDP;
+		break;
+	case FDPOLLDRVSTAT:
+		LOCK_FDC(drive, 1);
+		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		process_fd_request();
+		/* fall through */
+	case FDGETDRVSTAT:
+		outparam = (const char *)UDRS;
+		break;
+	case FDRESET:
+		return user_reset_fdc(drive, (int)param, 1);
+	case FDGETFDCSTAT:
+		outparam = (const char *)UFDCS;
+		break;
+	case FDWERRORCLR:
+		memset(UDRWE, 0, sizeof(*UDRWE));
+		return 0;
+	case FDWERRORGET:
+		outparam = (const char *)UDRWE;
+		break;
+	case FDRAWCMD:
+		if (type)
 			return -EINVAL;
-		}
+		LOCK_FDC(drive, 1);
+		set_floppy(drive);
+		CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
+		process_fd_request();
+		return i;
+	case FDTWADDLE:
+		LOCK_FDC(drive, 1);
+		twaddle();
+		process_fd_request();
+		return 0;
+	default:
+		return -EINVAL;
+	}
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
 		return fd_copyout((void __user *)param, outparam, size);
-	else
-		return 0;
-#undef OUT
-#undef IN
+
+	return 0;
 }
 
 static void __init config_types(void)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

