From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:04 -0400
Message-ID: <201003150654.o2F6sbdO016081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759723Ab0COGyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove [_]COPYIN [_]COPYOUT and ECALL macros
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove [_]COPYIN [_]COPYOUT and ECALL macros
From: Joe Perches <joe@perches.com>

Remove these obfuscating macros with hidden returns

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros
+++ a/drivers/block/floppy.c
@@ -520,7 +520,6 @@ static DECLARE_WAIT_QUEUE_HEAD(command_d
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
 #define CALL(x)		if ((x) == -EINTR) return -EINTR
-#define ECALL(x)	if ((ret = (x))) return ret;
 #define _WAIT(x,i)	CALL(ret=wait_til_done((x),i))
 #define WAIT(x)		_WAIT((x),interruptible)
 #define IWAIT(x)	_WAIT((x),1)
@@ -3061,14 +3060,6 @@ static inline int fd_copyin(void __user 
 	return copy_from_user(address, param, size) ? -EFAULT : 0;
 }
 
-#define _COPYOUT(x)	(copy_to_user((void __user *)param, &(x), sizeof(x)) \
-			 ? -EFAULT : 0)
-#define _COPYIN(x)	(copy_from_user(&(x), (void __user *)param, sizeof(x)) \
-			 ? -EFAULT : 0)
-
-#define COPYOUT(x)	ECALL(_COPYOUT(x))
-#define COPYIN(x)	ECALL(_COPYIN(x))
-
 static inline const char *drive_name(int type, int drive)
 {
 	struct floppy_struct *floppy;
@@ -3145,7 +3136,9 @@ static inline int raw_cmd_copyout(int cm
 	int ret;
 
 	while (ptr) {
-		COPYOUT(*ptr);
+		ret = copy_to_user((void __user *)param, ptr, sizeof(*ptr));
+		if (ret)
+			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
 		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
 			if (ptr->length >= 0 &&
@@ -3195,7 +3188,9 @@ static inline int raw_cmd_copyin(int cmd
 		if (!ptr)
 			return -ENOMEM;
 		*rcmd = ptr;
-		COPYIN(*ptr);
+		ret = copy_from_user(ptr, (void __user *)param, sizeof(*ptr));
+		if (ret)
+			return -EFAULT;
 		ptr->next = NULL;
 		ptr->buffer_length = 0;
 		param += sizeof(struct floppy_raw_cmd);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

