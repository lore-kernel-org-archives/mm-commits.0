From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:18:56 -0800
Message-ID: <201001280118.o0S1Iuum011821@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755733Ab0A1BTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: convert raw_cmd_copyin from while(1) to label: goto
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch

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
Subject: drivers/block/floppy.c: convert raw_cmd_copyin from while(1) to label: goto
From: Joe Perches <joe@perches.com>

Reduces indent.
Makes a bit more readable and intelligible.
Return value now at bottom of function.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   73 ++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 35 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto
+++ a/drivers/block/floppy.c
@@ -3126,6 +3126,7 @@ static inline int raw_cmd_copyout(int cm
 		}
 		ptr = ptr->next;
 	}
+
 	return 0;
 }
 
@@ -3156,18 +3157,19 @@ static inline int raw_cmd_copyin(int cmd
 	int i;
 
 	*rcmd = NULL;
-	while (1) {
-		ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
-		if (!ptr)
-			return -ENOMEM;
-		*rcmd = ptr;
-		ret = copy_from_user(ptr, param, sizeof(*ptr));
-		if (ret)
-			return -EFAULT;
-		ptr->next = NULL;
-		ptr->buffer_length = 0;
-		param += sizeof(struct floppy_raw_cmd);
-		if (ptr->cmd_count > 33)
+
+loop:
+	ptr = kmalloc(sizeof(struct floppy_raw_cmd), GFP_USER);
+	if (!ptr)
+		return -ENOMEM;
+	*rcmd = ptr;
+	ret = copy_from_user(ptr, param, sizeof(*ptr));
+	if (ret)
+		return -EFAULT;
+	ptr->next = NULL;
+	ptr->buffer_length = 0;
+	param += sizeof(struct floppy_raw_cmd);
+	if (ptr->cmd_count > 33)
 			/* the command may now also take up the space
 			 * initially intended for the reply & the
 			 * reply count. Needed for long 82078 commands
@@ -3176,34 +3178,35 @@ static inline int raw_cmd_copyin(int cmd
 			 * 16 bytes for a structure, you'll one day
 			 * discover that you really need 17...
 			 */
+		return -EINVAL;
+
+	for (i = 0; i < 16; i++)
+		ptr->reply[i] = 0;
+	ptr->resultcode = 0;
+	ptr->kernel_data = NULL;
+
+	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
+		if (ptr->length <= 0)
 			return -EINVAL;
+		ptr->kernel_data = (char *)fd_dma_mem_alloc(ptr->length);
+		fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
+		if (!ptr->kernel_data)
+			return -ENOMEM;
+		ptr->buffer_length = ptr->length;
+	}
+	if (ptr->flags & FD_RAW_WRITE) {
+		ret = fd_copyin(ptr->data, ptr->kernel_data, ptr->length);
+		if (ret)
+			return ret;
+	}
 
-		for (i = 0; i < 16; i++)
-			ptr->reply[i] = 0;
-		ptr->resultcode = 0;
-		ptr->kernel_data = NULL;
-
-		if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
-			if (ptr->length <= 0)
-				return -EINVAL;
-			ptr->kernel_data =
-			    (char *)fd_dma_mem_alloc(ptr->length);
-			fallback_on_nodma_alloc(&ptr->kernel_data, ptr->length);
-			if (!ptr->kernel_data)
-				return -ENOMEM;
-			ptr->buffer_length = ptr->length;
-		}
-		if (ptr->flags & FD_RAW_WRITE) {
-			ret = fd_copyin(ptr->data, ptr->kernel_data,
-					ptr->length);
-			if (ret)
-				return ret;
-		}
+	if (ptr->flags & FD_RAW_MORE) {
 		rcmd = &(ptr->next);
-		if (!(ptr->flags & FD_RAW_MORE))
-			return 0;
 		ptr->rate &= 0x43;
+		goto loop;
 	}
+
+	return 0;
 }
 
 static int raw_cmd_ioctl(int cmd, void __user *param)
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
get_maintainerpl-teach-git-log-to-use-no-color.patch
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
drivers-block-floppyc-remove-repeat-macro.patch
drivers-block-floppyc-unclutter-redo_fd_request-logic.patch
drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch
drivers-block-floppyc-remove-define-floppy_sanity_check.patch
drivers-block-floppyc-dprint-neatening.patch
drivers-block-floppyc-use-__func__-where-appropriate.patch
drivers-block-floppyc-use-%pf-in-logging-messages.patch
drivers-block-floppyc-remove-some-unnecessary-casting.patch
drivers-block-floppyc-convert-raw_cmd_copyin-from-while1-to-label-goto.patch
drivers-block-floppyc-add-__func__-to-debugt.patch
drivers-block-floppyc-remove-obfuscating-code2size-macro.patch
drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch
drivers-block-floppyc-remove-unnecessary-casting-in-fd_ioctl.patch
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

