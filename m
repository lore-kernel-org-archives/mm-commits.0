From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:40 -0800
Message-ID: <201001270037.o0R0beHo032545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895Ab0A0AtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:49:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove IN/OUT macros, indent switch/case
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-in-out-macros-indent-switch-case.patch

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

