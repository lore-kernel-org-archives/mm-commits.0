From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:52 -0800
Message-ID: <201001270037.o0R0bqQC032566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193Ab0A0Ai3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:38:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove [_]COPYIN [_]COPYOUT and ECALL macros
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch

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

