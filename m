From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-add-__func__-to-debugt.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:18:58 -0800
Message-ID: <201001280118.o0S1IwHn011825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736Ab0A1BTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: add __func__ to debugt
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-add-__func__-to-debugt.patch

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
Subject: drivers/block/floppy.c: add __func__ to debugt
From: Joe Perches <joe@perches.com>

Make debugt messages a little neater.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-add-__func__-to-debugt drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-add-__func__-to-debugt
+++ a/drivers/block/floppy.c
@@ -616,14 +616,14 @@ static inline void set_debugt(void)
 	debugtimer = jiffies;
 }
 
-static inline void debugt(const char *message)
+static inline void debugt(const char *func, const char *msg)
 {
 	if (DP->flags & DEBUGT)
-		pr_info("%s dtime=%lu\n", message, jiffies - debugtimer);
+		pr_info("%s:%s dtime=%lu\n", func, msg, jiffies - debugtimer);
 }
 #else
 static inline void set_debugt(void) { }
-static inline void debugt(const char *message) { }
+static inline void debugt(const char *func, const char *msg) { }
 #endif /* DEBUGT */
 
 typedef void (*timeout_fn)(unsigned long);
@@ -1533,7 +1533,7 @@ static void setup_rw_floppy(void)
 	for (i = 0; i < raw_cmd->cmd_count; i++)
 		r |= output_byte(raw_cmd->cmd[i]);
 
-	debugt("rw_command: ");
+	debugt(__func__, "rw_command");
 
 	if (r) {
 		cont->error();
@@ -1556,7 +1556,7 @@ static int blind_seek;
  */
 static void seek_interrupt(void)
 {
-	debugt("seek interrupt:");
+	debugt(__func__, "");
 	if (inr != 2 || (ST0 & 0xF8) != 0x20) {
 		DPRINT("seek failed\n");
 		DRS->track = NEED_2_RECAL;
@@ -1604,7 +1604,7 @@ static void seek_floppy(void)
 
 	blind_seek = 0;
 
-	debug_dcl(DP->flags, "calling disk change from seek\n");
+	debug_dcl(DP->flags, "calling disk change from %s\n", __func__);
 
 	if (!test_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags) &&
 	    disk_change(current_drive) && (raw_cmd->flags & FD_RAW_NEED_DISK)) {
@@ -1653,18 +1653,18 @@ static void seek_floppy(void)
 		reset_fdc();
 		return;
 	}
-	debugt("seek command:");
+	debugt(__func__, "");
 }
 
 static void recal_interrupt(void)
 {
-	debugt("recal interrupt:");
+	debugt(__func__, "");
 	if (inr != 2)
 		FDCS->reset = 1;
 	else if (ST0 & ST0_ECE) {
 		switch (DRS->track) {
 		case NEED_1_RECAL:
-			debugt("recal interrupt need 1 recal:");
+			debugt(__func__, "need 1 recal");
 			/* after a second recalibrate, we still haven't
 			 * reached track 0. Probably no drive. Raise an
 			 * error, as failing immediately might upset
@@ -1673,7 +1673,7 @@ static void recal_interrupt(void)
 			cont->redo();
 			return;
 		case NEED_2_RECAL:
-			debugt("recal interrupt need 2 recal:");
+			debugt(__func__, "need 2 recal");
 			/* If we already did a recalibrate,
 			 * and we are not at track 0, this
 			 * means we have moved. (The only way
@@ -1687,7 +1687,7 @@ static void recal_interrupt(void)
 			DRS->select_date = jiffies;
 			/* fall through */
 		default:
-			debugt("recal interrupt default:");
+			debugt(__func__, "default");
 			/* Recalibrate moves the head by at
 			 * most 80 steps. If after one
 			 * recalibrate we don't have reached
@@ -1777,7 +1777,7 @@ irqreturn_t floppy_interrupt(int irq, vo
 
 static void recalibrate_floppy(void)
 {
-	debugt("recalibrate floppy:");
+	debugt(__func__, "");
 	do_floppy = recal_interrupt;
 	output_byte(FD_RECALIBRATE);
 	if (output_byte(UNIT(current_drive)) < 0)
@@ -1789,7 +1789,7 @@ static void recalibrate_floppy(void)
  */
 static void reset_interrupt(void)
 {
-	debugt("reset interrupt:");
+	debugt(__func__, "");
 	result();		/* get the status ready for set_fdc */
 	if (FDCS->reset) {
 		pr_info("reset set in interrupt, calling %pf\n", cont->error);
@@ -2221,7 +2221,7 @@ static void redo_format(void)
 	buffer_track = -1;
 	setup_format_params(format_req.track << STRETCH(_floppy));
 	floppy_start();
-	debugt("queue format request");
+	debugt(__func__, "queue format request");
 }
 
 static struct cont_t format_cont = {
@@ -2918,7 +2918,7 @@ do_request:
 	if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
 		twaddle();
 	schedule_bh(floppy_start);
-	debugt("queue fd request");
+	debugt(__func__, "queue fd request");
 	return;
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

