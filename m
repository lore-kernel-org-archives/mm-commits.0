From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:30 -0800
Message-ID: <201001270037.o0R0bUka032526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754191Ab0A0AiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: hoist assigns from if()s, neatening
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-hoist-assigns-from-ifs-neatening.patch

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
Subject: drivers/block/floppy.c: hoist assigns from if()s, neatening
From: Joe Perches <joe@perches.com>

Move assigns above if()s
Remove unnecessary parentheses from returns
Use a temporary for a duplicated test

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   53 +++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-hoist-assigns-from-ifs-neatening drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-hoist-assigns-from-ifs-neatening
+++ a/drivers/block/floppy.c
@@ -1175,9 +1175,9 @@ static int wait_til_ready(void)
 /* sends a command byte to the fdc */
 static int output_byte(char byte)
 {
-	int status;
+	int status = wait_til_ready();
 
-	if ((status = wait_til_ready()) < 0)
+	if (status < 0)
 		return -1;
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY) {
 		fd_outb(byte, FD_DATA);
@@ -1207,7 +1207,8 @@ static int result(void)
 	int status = 0;
 
 	for (i = 0; i < MAX_REPLIES; i++) {
-		if ((status = wait_til_ready()) < 0)
+		status = wait_til_ready();
+		if (status < 0)
 			break;
 		status &= STATUS_DIR | STATUS_READY | STATUS_BUSY | STATUS_DMA;
 		if ((status & ~STATUS_BUSY) == STATUS_READY) {
@@ -1236,9 +1237,9 @@ static int result(void)
 /* does the fdc need more output? */
 static int need_more_output(void)
 {
-	int status;
+	int status = wait_til_ready();
 
-	if ((status = wait_til_ready()) < 0)
+	if (status < 0)
 		return -1;
 	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY)
 		return MORE_OUTPUT;
@@ -1414,8 +1415,8 @@ static int fdc_dtr(void)
 	 * Pause 5 msec to avoid trouble. (Needs to be 2 jiffies)
 	 */
 	FDCS->dtr = raw_cmd->rate & 3;
-	return (fd_wait_for_completion(jiffies + 2UL * HZ / 100,
-				       (timeout_fn) floppy_ready));
+	return fd_wait_for_completion(jiffies + 2UL * HZ / 100,
+				      (timeout_fn)floppy_ready);
 }				/* fdc_dtr */
 
 static void tell_sector(void)
@@ -1951,8 +1952,8 @@ static int start_motor(void (*function)(
 	set_dor(fdc, mask, data);
 
 	/* wait_for_completion also schedules reset if needed. */
-	return (fd_wait_for_completion(DRS->select_date + DP->select_delay,
-				       (timeout_fn) function));
+	return fd_wait_for_completion(DRS->select_date + DP->select_delay,
+				      (timeout_fn)function);
 }
 
 static void floppy_ready(void)
@@ -2729,8 +2730,10 @@ static int make_raw_rw_request(void)
 		}
 	} else if (in_sector_offset || blk_rq_sectors(current_req) < ssize) {
 		if (CT(COMMAND) == FD_WRITE) {
-			if (fsector_t + blk_rq_sectors(current_req) > ssize &&
-			    fsector_t + blk_rq_sectors(current_req) < ssize + ssize)
+			unsigned int sectors;
+
+			sectors = fsector_t + blk_rq_sectors(current_req);
+			if (sectors > ssize && sectors < ssize + ssize)
 				max_size = ssize + ssize;
 			else
 				max_size = ssize;
@@ -2751,9 +2754,8 @@ static int make_raw_rw_request(void)
 		 * on a 64 bit machine!
 		 */
 		max_size = buffer_chain_size();
-		dma_limit =
-		    (MAX_DMA_ADDRESS -
-		     ((unsigned long)current_req->buffer)) >> 9;
+		dma_limit = (MAX_DMA_ADDRESS -
+			     ((unsigned long)current_req->buffer)) >> 9;
 		if ((unsigned long)max_size > dma_limit)
 			max_size = dma_limit;
 		/* 64 kb boundaries */
@@ -2771,16 +2773,16 @@ static int make_raw_rw_request(void)
 		 */
 		if (!direct ||
 		    (indirect * 2 > direct * 3 &&
-		     *errors < DP->max_errors.read_track && ((!probing
-		       || (DP->read_track & (1 << DRS->probed_format)))))) {
+		     *errors < DP->max_errors.read_track &&
+		     ((!probing ||
+		       (DP->read_track & (1 << DRS->probed_format)))))) {
 			max_size = blk_rq_sectors(current_req);
 		} else {
 			raw_cmd->kernel_data = current_req->buffer;
 			raw_cmd->length = current_count_sectors << 9;
 			if (raw_cmd->length == 0) {
-				DPRINT
-				    ("zero dma transfer attempted from make_raw_request\n");
-				DPRINT("indirect=%d direct=%d fsector_t=%d",
+				DPRINT("zero dma transfer attempted from make_raw_request\n");
+				DPRINT("indirect=%d direct=%d fsector_t=%d\n",
 				       indirect, direct, fsector_t);
 				return 0;
 			}
@@ -2977,7 +2979,7 @@ static void process_fd_request(void)
 	schedule_bh(redo_fd_request);
 }
 
-static void do_fd_request(struct request_queue * q)
+static void do_fd_request(struct request_queue *q)
 {
 	if (max_buffer_sectors == 0) {
 		pr_info("VFS: do_fd_request called on non-open device\n");
@@ -3937,7 +3939,8 @@ static char __init get_fdc_version(void)
 	output_byte(FD_DUMPREGS);	/* 82072 and better know DUMPREGS */
 	if (FDCS->reset)
 		return FDC_NONE;
-	if ((r = result()) <= 0x00)
+	r = result();
+	if (r <= 0x00)
 		return FDC_NONE;	/* No FDC present ??? */
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
 		pr_info("FDC %d is an 8272A\n", fdc);
@@ -3966,7 +3969,7 @@ static char __init get_fdc_version(void)
 	r = result();
 	if ((r == 1) && (reply_buffer[0] == 0x80)) {
 		pr_info("FDC %d is a pre-1991 82077\n", fdc);
-		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know 
+		return FDC_82077_ORIG;	/* Pre-1991 82077, doesn't know
 					 * LOCK/UNLOCK */
 	}
 	if ((r != 1) || (reply_buffer[0] != 0x00)) {
@@ -4357,7 +4360,8 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		err = device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err = device_create_file(&floppy_device[drive].dev,
+					 &dev_attr_cmos);
 		if (err)
 			goto out_unreg_platform_dev;
 
@@ -4578,7 +4582,8 @@ static void __init parse_floppy_cfg_stri
 	char *ptr;
 
 	while (*cfg) {
-		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++) ;
+		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++)
+			;
 		if (*cfg) {
 			*cfg = '\0';
 			cfg++;
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

