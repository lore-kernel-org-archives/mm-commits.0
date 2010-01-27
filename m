From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:38:02 -0800
Message-ID: <201001270038.o0R0c22Z032582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754260Ab0A0Aij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: convert int initialising to bool initialized
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch

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
Subject: drivers/block/floppy.c: convert int initialising to bool initialized
From: Joe Perches <joe@perches.com>

Don't initialize initialized either.  Default is false.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-convert-int-initialising-to-bool-initialized drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-convert-int-initialising-to-bool-initialized
+++ a/drivers/block/floppy.c
@@ -290,7 +290,7 @@ static inline void fallback_on_nodma_all
 /* End dma memory related stuff */
 
 static unsigned long fake_change;
-static int initialising = 1;
+static bool initialized;
 
 #define ITYPE(x)	(((x) >> 2) & 0x1f)
 #define TOMINOR(x)	((x & 3) | ((x & 4) << 5))
@@ -1147,7 +1147,7 @@ static int wait_til_ready(void)
 		if (status & STATUS_READY)
 			return status;
 	}
-	if (!initialising) {
+	if (initialized) {
 		DPRINT("Getstatus times out (%x) on fdc %d\n", status, fdc);
 		show_floppy();
 	}
@@ -1173,7 +1173,7 @@ static int output_byte(char byte)
 		return 0;
 	}
 	FDCS->reset = 1;
-	if (!initialising) {
+	if (initialized) {
 		DPRINT("Unable to send byte %x to FDC. Fdc=%x Status=%x\n",
 		       byte, fdc, status);
 		show_floppy();
@@ -1204,10 +1204,9 @@ static int result(void)
 		else
 			break;
 	}
-	if (!initialising) {
-		DPRINT
-		    ("get result error. Fdc=%d Last status=%x Read bytes=%d\n",
-		     fdc, status, i);
+	if (initialized) {
+		DPRINT("get result error. Fdc=%d Last status=%x Read bytes=%d\n",
+		       fdc, status, i);
 		show_floppy();
 	}
 	FDCS->reset = 1;
@@ -1754,7 +1753,7 @@ irqreturn_t floppy_interrupt(int irq, vo
 	 * activity.
 	 */
 
-	do_print = !handler && print_unex && !initialising;
+	do_print = !handler && print_unex && initialized;
 
 	inr = result();
 	if (do_print)
@@ -1882,7 +1881,7 @@ static void floppy_shutdown(unsigned lon
 {
 	unsigned long flags;
 
-	if (!initialising)
+	if (initialized)
 		show_floppy();
 	cancel_activity();
 
@@ -1894,7 +1893,7 @@ static void floppy_shutdown(unsigned lon
 
 	/* avoid dma going to a random drive after shutdown */
 
-	if (!initialising)
+	if (initialized)
 		DPRINT("floppy timeout called\n");
 	FDCS->reset = 1;
 	if (cont) {
@@ -4337,7 +4336,7 @@ static int __init floppy_init(void)
 	fdc = 0;
 	del_timer(&fd_timeout);
 	current_drive = 0;
-	initialising = 0;
+	initialized = true;
 	if (have_no_fdc) {
 		DPRINT("no floppy controllers found\n");
 		err = have_no_fdc;
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

