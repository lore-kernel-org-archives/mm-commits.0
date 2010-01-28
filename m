From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:18:43 -0800
Message-ID: <201001280118.o0S1IhwF011800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932162Ab0A1BSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:18:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: remove unnecessary argument from [__]reschedule_timeout
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout.patch

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
Subject: drivers/block/floppy.c: remove unnecessary argument from [__]reschedule_timeout
From: Joe Perches <joe@perches.com>

Prior to patch "drivers/block/floppy.c: Use pr_<level>" only
reschedule_timeout(,"request done"...) printed a numeric value after a
reschedule_timeout event message.

Restore that behavior and remove the now unnecessary argument.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-unnecessary-argument-from-reschedule_timeout
+++ a/drivers/block/floppy.c
@@ -668,7 +668,7 @@ static int output_log_pos;
 #define current_reqD -1
 #define MAXTIMEOUT -2
 
-static void __reschedule_timeout(int drive, const char *message, int marg)
+static void __reschedule_timeout(int drive, const char *message)
 {
 	if (drive == current_reqD)
 		drive = current_drive;
@@ -680,16 +680,16 @@ static void __reschedule_timeout(int dri
 		fd_timeout.expires = jiffies + UDP->timeout;
 	add_timer(&fd_timeout);
 	if (UDP->flags & FD_DEBUG)
-		DPRINT("reschedule timeout %s %d\n", message, marg);
+		DPRINT("reschedule timeout %s\n", message);
 	timeout_message = message;
 }
 
-static void reschedule_timeout(int drive, const char *message, int marg)
+static void reschedule_timeout(int drive, const char *message)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&floppy_lock, flags);
-	__reschedule_timeout(drive, message, marg);
+	__reschedule_timeout(drive, message);
 	spin_unlock_irqrestore(&floppy_lock, flags);
 }
 
@@ -900,7 +900,7 @@ static int _lock_fdc(int drive, bool int
 	}
 	command_status = FD_COMMAND_NONE;
 
-	__reschedule_timeout(drive, "lock fdc", 0);
+	__reschedule_timeout(drive, "lock fdc");
 	set_fdc(drive);
 	return 0;
 }
@@ -1983,7 +1983,7 @@ static void floppy_ready(void)
 
 static void floppy_start(void)
 {
-	reschedule_timeout(current_reqD, "floppy start", 0);
+	reschedule_timeout(current_reqD, "floppy start");
 
 	scandrives();
 	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
@@ -2007,7 +2007,7 @@ static void floppy_start(void)
 
 static void do_wakeup(void)
 {
-	reschedule_timeout(MAXTIMEOUT, "do wakeup", 0);
+	reschedule_timeout(MAXTIMEOUT, "do wakeup");
 	cont = NULL;
 	command_status += 2;
 	wake_up(&command_done);
@@ -2306,9 +2306,11 @@ static void request_done(int uptodate)
 	struct request *req = current_req;
 	unsigned long flags;
 	int block;
+	char msg[sizeof("request done ") + sizeof(int) * 3];
 
 	probing = 0;
-	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);
+	snprintf(msg, sizeof(msg), "request done %d", uptodate);
+	reschedule_timeout(MAXTIMEOUT, msg);
 
 	if (!req) {
 		pr_info("floppy.c: no request in request_done\n");
@@ -2908,7 +2910,7 @@ do_request:
 	}
 	drive = (long)current_req->rq_disk->private_data;
 	set_fdc(drive);
-	reschedule_timeout(current_reqD, "redo fd request", 0);
+	reschedule_timeout(current_reqD, "redo fd request");
 
 	set_floppy(drive);
 	raw_cmd = &default_raw_cmd;
@@ -4254,7 +4256,7 @@ static int __init floppy_init(void)
 		else
 			floppy_sizes[i] = MAX_DISK_SIZE << 1;
 
-	reschedule_timeout(MAXTIMEOUT, "floppy init", MAXTIMEOUT);
+	reschedule_timeout(MAXTIMEOUT, "floppy init");
 	config_types();
 
 	for (i = 0; i < N_FDC; i++) {
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

