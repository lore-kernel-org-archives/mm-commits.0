From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:01 -0400
Message-ID: <201003150654.o2F6sYNn016076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759721Ab0COGyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove most uses of CALL and ECALL macros
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove most uses of CALL and ECALL macros
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   51 ++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-most-uses-of-call-and-ecall-macros
+++ a/drivers/block/floppy.c
@@ -3151,8 +3151,10 @@ static inline int raw_cmd_copyout(int cm
 			if (ptr->length >= 0 &&
 			    ptr->length <= ptr->buffer_length) {
 				long length = ptr->buffer_length - ptr->length;
-				ECALL(fd_copyout(ptr->data, ptr->kernel_data,
-						 length));
+				ret = fd_copyout(ptr->data, ptr->kernel_data,
+						 length);
+				if (ret)
+					return ret;
 			}
 		}
 		ptr = ptr->next;
@@ -3223,9 +3225,12 @@ static inline int raw_cmd_copyin(int cmd
 				return -ENOMEM;
 			ptr->buffer_length = ptr->length;
 		}
-		if (ptr->flags & FD_RAW_WRITE)
-			ECALL(fd_copyin(ptr->data, ptr->kernel_data,
-					ptr->length));
+		if (ptr->flags & FD_RAW_WRITE) {
+			ret = fd_copyin(ptr->data, ptr->kernel_data,
+					ptr->length);
+			if (ret)
+				return ret;
+		}
 		rcmd = &(ptr->next);
 		if (!(ptr->flags & FD_RAW_MORE))
 			return 0;
@@ -3329,10 +3334,12 @@ static inline int set_geometry(unsigned 
 
 		if (lock_fdc(drive, 1))
 			return -EINTR;
-		if (cmd != FDDEFPRM)
+		if (cmd != FDDEFPRM) {
 			/* notice a disk change immediately, else
 			 * we lose our settings immediately*/
-			CALL(poll_drive(1, FD_RAW_NEED_DISK));
+			if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+				return -EINTR;
+		}
 		oldStretch = g->stretch;
 		user_params[drive] = *g;
 		if (buffer_drive == drive)
@@ -3413,7 +3420,8 @@ static int get_floppy_geometry(int drive
 	else {
 		if (lock_fdc(drive, 0))
 			return -EINTR;
-		CALL(poll_drive(0, 0));
+		if (poll_drive(0, 0) == -EINTR)
+			return -EINTR;
 		process_fd_request();
 		*g = current_type[drive];
 	}
@@ -3471,7 +3479,9 @@ static int fd_ioctl(struct block_device 
 		return -EINVAL;
 
 	/* convert the old style command into a new style command */
-	ECALL(normalize_ioctl(&cmd, &size));
+	ret = normalize_ioctl(&cmd, &size);
+	if (ret)
+		return ret;
 
 	/* permission checks */
 	if (((cmd & 0x40) && !FD_IOCTL_ALLOWED) ||
@@ -3483,8 +3493,11 @@ static int fd_ioctl(struct block_device 
 
 	/* copyin */
 	memset(&inparam, 0, sizeof(inparam));
-	if (_IOC_DIR(cmd) & _IOC_WRITE)
-		ECALL(fd_copyin((void __user *)param, &inparam, size));
+	if (_IOC_DIR(cmd) & _IOC_WRITE) {
+		ret = fd_copyin((void __user *)param, &inparam, size);
+		if (ret)
+			return ret;
+	}
 
 	switch (cmd) {
 	case FDEJECT:
@@ -3513,9 +3526,11 @@ static int fd_ioctl(struct block_device 
 	case FDDEFPRM:
 		return set_geometry(cmd, &inparam.g, drive, type, bdev);
 	case FDGETPRM:
-		ECALL(get_floppy_geometry(drive, type,
+		ret = get_floppy_geometry(drive, type,
 					  (struct floppy_struct **)
-					  &outparam));
+					  &outparam);
+		if (ret)
+			return ret;
 		break;
 	case FDMSGON:
 		UDP->flags |= FTD_MSG;
@@ -3526,7 +3541,8 @@ static int fd_ioctl(struct block_device 
 	case FDFMTBEG:
 		if (lock_fdc(drive, 1))
 			return -EINTR;
-		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+			return -EINTR;
 		ret = UDRS->flags;
 		process_fd_request();
 		if (ret & FD_VERIFY)
@@ -3565,7 +3581,8 @@ static int fd_ioctl(struct block_device 
 	case FDPOLLDRVSTAT:
 		if (lock_fdc(drive, 1))
 			return -EINTR;
-		CALL(poll_drive(1, FD_RAW_NEED_DISK));
+		if (poll_drive(1, FD_RAW_NEED_DISK) == -EINTR)
+			return -EINTR;
 		process_fd_request();
 		/* fall through */
 	case FDGETDRVSTAT:
@@ -3588,7 +3605,9 @@ static int fd_ioctl(struct block_device 
 		if (lock_fdc(drive, 1))
 			return -EINTR;
 		set_floppy(drive);
-		CALL(i = raw_cmd_ioctl(cmd, (void __user *)param));
+		i = raw_cmd_ioctl(cmd, (void __user *)param);
+		if (i == -EINTR)
+			return -EINTR;
 		process_fd_request();
 		return i;
 	case FDTWADDLE:
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

