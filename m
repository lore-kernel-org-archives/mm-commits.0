From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:16 -0400
Message-ID: <201003150655.o2F6tnfI016171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090Ab0COGzz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove unnecessary casting in fd_ioctl
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove unnecessary casting in fd_ioctl
From: Joe Perches <joe@perches.com>

Convert outparam to const void *.
Cast outparam to const char * for strlen().

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl
+++ a/drivers/block/floppy.c
@@ -3431,7 +3431,7 @@ static int fd_ioctl(struct block_device 
 		struct floppy_max_errors max_errors;
 		struct floppy_drive_params dp;
 	} inparam;		/* parameters coming from user space */
-	const char *outparam;	/* parameters passed back to user space */
+	const void *outparam;	/* parameters passed back to user space */
 
 	/* convert compatibility eject ioctls into floppy eject ioctl.
 	 * We do this in order to provide a means to eject floppy disks before
@@ -3495,8 +3495,7 @@ static int fd_ioctl(struct block_device 
 		return set_geometry(cmd, &inparam.g, drive, type, bdev);
 	case FDGETPRM:
 		ret = get_floppy_geometry(drive, type,
-					  (struct floppy_struct **)
-					  &outparam);
+					  (struct floppy_struct **)&outparam);
 		if (ret)
 			return ret;
 		break;
@@ -3531,20 +3530,20 @@ static int fd_ioctl(struct block_device 
 		UDP->max_errors.reporting = (unsigned short)(param & 0x0f);
 		return 0;
 	case FDGETMAXERRS:
-		outparam = (const char *)&UDP->max_errors;
+		outparam = &UDP->max_errors;
 		break;
 	case FDSETMAXERRS:
 		UDP->max_errors = inparam.max_errors;
 		break;
 	case FDGETDRVTYP:
 		outparam = drive_name(type, drive);
-		SUPBOUND(size, strlen(outparam) + 1);
+		SUPBOUND(size, strlen((const char *)outparam) + 1);
 		break;
 	case FDSETDRVPRM:
 		*UDP = inparam.dp;
 		break;
 	case FDGETDRVPRM:
-		outparam = (const char *)UDP;
+		outparam = UDP;
 		break;
 	case FDPOLLDRVSTAT:
 		if (lock_fdc(drive, true))
@@ -3554,18 +3553,18 @@ static int fd_ioctl(struct block_device 
 		process_fd_request();
 		/* fall through */
 	case FDGETDRVSTAT:
-		outparam = (const char *)UDRS;
+		outparam = UDRS;
 		break;
 	case FDRESET:
 		return user_reset_fdc(drive, (int)param, true);
 	case FDGETFDCSTAT:
-		outparam = (const char *)UFDCS;
+		outparam = UFDCS;
 		break;
 	case FDWERRORCLR:
 		memset(UDRWE, 0, sizeof(*UDRWE));
 		return 0;
 	case FDWERRORGET:
-		outparam = (const char *)UDRWE;
+		outparam = UDRWE;
 		break;
 	case FDRAWCMD:
 		if (type)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

