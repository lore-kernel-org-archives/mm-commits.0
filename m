From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-dprint-neatening.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:18:47 -0800
Message-ID: <201001280118.o0S1IlZt011809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755461Ab0A1BSy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:18:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: DPRINT neatening
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-dprint-neatening.patch

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
Subject: drivers/block/floppy.c: DPRINT neatening
From: Joe Perches <joe@perches.com>

Move DPRINT macro definition above 1st use Consolidate a format string
(>80 columns) Add a newline to an unterminated message Comment neatened

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-dprint-neatening drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-dprint-neatening
+++ a/drivers/block/floppy.c
@@ -149,8 +149,11 @@
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
-#define DCL_DEBUG		/* debug disk change line */
 
+#define DPRINT(format, args...) \
+	pr_info("floppy%d: " format, current_drive, ##args)
+
+#define DCL_DEBUG		/* debug disk change line */
 #ifdef DCL_DEBUG
 #define debug_dcl(test, fmt, args...) \
 	do { if ((test) & FD_DEBUG) DPRINT(fmt, ##args); } while (0)
@@ -159,7 +162,6 @@
 	do { if (0) DPRINT(fmt, ##args); } while (0)
 #endif
 
-
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
 #include <linux/module.h>
@@ -308,9 +310,6 @@ static bool initialized;
 #define UDRWE	(&write_errors[drive])
 #define UFDCS	(&fdc_state[FDC(drive)])
 
-#define DPRINT(format, args...) \
-	pr_info("floppy%d: " format, current_drive, ##args)
-
 #define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
 #define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
 
@@ -345,7 +344,7 @@ static bool initialized;
  */
 #define MAX_REPLIES 16
 static unsigned char reply_buffer[MAX_REPLIES];
-static int inr;			/* size of reply buffer, when called from interrupt */
+static int inr;		/* size of reply buffer, when called from interrupt */
 #define ST0		(reply_buffer[0])
 #define ST1		(reply_buffer[1])
 #define ST2		(reply_buffer[2])
@@ -755,8 +754,7 @@ static int disk_change(int drive)
 		if (UDRS->keep_data >= 0) {
 			if ((UDP->flags & FTD_MSG) &&
 			    current_type[drive] != NULL)
-				DPRINT("Disk type is undefined after "
-				       "disk change\n");
+				DPRINT("Disk type is undefined after disk change\n");
 			current_type[drive] = NULL;
 			floppy_sizes[TOMINOR(drive)] = MAX_DISK_SIZE << 1;
 		}
@@ -1447,7 +1445,7 @@ static int interpret_errors(void)
 	char bad;
 
 	if (inr != 7) {
-		DPRINT("-- FDC reply error");
+		DPRINT("-- FDC reply error\n");
 		FDCS->reset = 1;
 		return 1;
 	}
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

