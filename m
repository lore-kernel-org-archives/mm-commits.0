From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:54 -0800
Message-ID: <201001270037.o0R0bs2n032569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754195Ab0A0Ai3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:38:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch

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
Subject: drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
From: Joe Perches <joe@perches.com>

Obfuscating macros with embedded returns are not nice

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-macros-call-wait-and-iwait drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-macros-call-wait-and-iwait
+++ a/drivers/block/floppy.c
@@ -519,10 +519,6 @@ static DECLARE_WAIT_QUEUE_HEAD(fdc_wait)
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
-#define CALL(x)		if ((x) == -EINTR) return -EINTR
-#define _WAIT(x,i)	CALL(ret=wait_til_done((x),i))
-#define WAIT(x)		_WAIT((x),interruptible)
-#define IWAIT(x)	_WAIT((x),1)
 
 /* Errors during formatting are counted here. */
 static int format_errors;
@@ -2268,7 +2264,9 @@ static int do_format(int drive, struct f
 	format_errors = 0;
 	cont = &format_cont;
 	errors = &format_errors;
-	IWAIT(redo_format);
+	ret = wait_til_done(redo_format, 1);
+	if (ret == -EINTR)
+		return -EINTR;
 	process_fd_request();
 	return ret;
 }
@@ -2996,8 +2994,6 @@ static struct cont_t poll_cont = {
 
 static int poll_drive(int interruptible, int flag)
 {
-	int ret;
-
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->flags = flag;
@@ -3006,8 +3002,8 @@ static int poll_drive(int interruptible,
 	cont = &poll_cont;
 	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
 	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
-	WAIT(floppy_ready);
-	return ret;
+
+	return wait_til_done(floppy_ready, interruptible);
 }
 
 /*
@@ -3038,7 +3034,9 @@ static int user_reset_fdc(int drive, int
 		FDCS->reset = 1;
 	if (FDCS->reset) {
 		cont = &reset_cont;
-		WAIT(reset_fdc);
+		ret = wait_til_done(reset_fdc, interruptible);
+		if (ret == -EINTR)
+			return -EINTR;
 	}
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

