From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-comment-neatening-and-remove-naked.patch added to -mm tree
Date: Tue, 26 Jan 2010 16:37:34 -0800
Message-ID: <201001270037.o0R0bYeV032532@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754871Ab0A0Asa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 19:48:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: comment neatening and remove naked ;
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-comment-neatening-and-remove-naked.patch

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
Subject: drivers/block/floppy.c: comment neatening and remove naked ;
From: Joe Perches <joe@perches.com>

Spacing, column alignment and a for loop with
a naked semicolon converted to an assign and while

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   55 +++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-comment-neatening-and-remove-naked drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-comment-neatening-and-remove-naked
+++ a/drivers/block/floppy.c
@@ -1262,9 +1262,12 @@ static inline void perpendicular_mode(vo
 		default:
 			DPRINT("Invalid data rate for perpendicular mode!\n");
 			cont->done(0);
-			FDCS->reset = 1;	/* convenient way to return to
-						 * redo without to much hassle (deep
-						 * stack et al. */
+			FDCS->reset = 1;
+					/*
+					 * convenient way to return to
+					 * redo without too much hassle
+					 * (deep stack et al.)
+					 */
 			return;
 		}
 	} else
@@ -1977,8 +1980,8 @@ static void floppy_ready(void)
 #endif
 	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR) &&
 	    disk_change(current_drive) && !DP->select_delay)
-		twaddle();	/* this clears the dcl on certain drive/controller
-				 * combinations */
+		twaddle();	/* this clears the dcl on certain
+				 * drive/controller combinations */
 
 #ifdef fd_chose_dma_mode
 	if ((raw_cmd->flags & FD_RAW_READ) || (raw_cmd->flags & FD_RAW_WRITE)) {
@@ -2806,15 +2809,14 @@ static int make_raw_rw_request(void)
 	    ((CT(COMMAND) == FD_READ ||
 	      (!in_sector_offset && blk_rq_sectors(current_req) >= ssize)) &&
 	     max_sector > 2 * max_buffer_sectors + buffer_min &&
-	     max_size + fsector_t > 2 * max_buffer_sectors + buffer_min)
-	    /* not enough space */
-	    ) {
+	     max_size + fsector_t > 2 * max_buffer_sectors + buffer_min)) {
+		/* not enough space */
 		buffer_track = -1;
 		buffer_drive = current_drive;
 		buffer_max = buffer_min = aligned_sector_t;
 	}
 	raw_cmd->kernel_data = floppy_track_buffer +
-	    ((aligned_sector_t - buffer_min) << 9);
+		((aligned_sector_t - buffer_min) << 9);
 
 	if (CT(COMMAND) == FD_WRITE) {
 		/* copy write buffer to track buffer.
@@ -3171,11 +3173,12 @@ static inline int raw_cmd_copyout(int cm
 		COPYOUT(*ptr);
 		param += sizeof(struct floppy_raw_cmd);
 		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
-			if (ptr->length >= 0
-			    && ptr->length <= ptr->buffer_length)
-				ECALL(fd_copyout
-				      (ptr->data, ptr->kernel_data,
-				       ptr->buffer_length - ptr->length));
+			if (ptr->length >= 0 &&
+			    ptr->length <= ptr->buffer_length) {
+				long length = ptr->buffer_length - ptr->length;
+				ECALL(fd_copyout(ptr->data, ptr->kernel_data,
+						 length));
+			}
 		}
 		ptr = ptr->next;
 	}
@@ -3827,8 +3830,7 @@ static int check_floppy_change(struct ge
  * a disk in the drive, and whether that disk is writable.
  */
 
-static void floppy_rb0_complete(struct bio *bio,
-			       int err)
+static void floppy_rb0_complete(struct bio *bio, int err)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -4120,9 +4122,9 @@ static int __init floppy_setup(char *str
 				else
 					param = config_params[i].def_param;
 				if (config_params[i].fn)
-					config_params[i].
-					    fn(ints, param,
-					       config_params[i].param2);
+					config_params[i].fn(ints, param,
+							    config_params[i].
+							    param2);
 				if (config_params[i].var) {
 					DPRINT("%s=%d\n", str, param);
 					*config_params[i].var = param;
@@ -4180,8 +4182,8 @@ static const struct dev_pm_ops floppy_pm
 
 static struct platform_driver floppy_driver = {
 	.driver = {
-		.name = "floppy",
-		.pm = &floppy_pm_ops,
+		   .name = "floppy",
+		   .pm = &floppy_pm_ops,
 	},
 };
 
@@ -4429,8 +4431,10 @@ static int floppy_request_regions(int fd
 	const struct io_region *p;
 
 	for (p = io_regions; p < ARRAY_END(io_regions); p++) {
-		if (!request_region(FDCS->address + p->offset, p->size, "floppy")) {
-			DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + p->offset);
+		if (!request_region(FDCS->address + p->offset,
+				    p->size, "floppy")) {
+			DPRINT("Floppy io-port 0x%04lx in use\n",
+			       FDCS->address + p->offset);
 			floppy_release_allocated_regions(fdc, p);
 			return -EBUSY;
 		}
@@ -4586,8 +4590,9 @@ static void __init parse_floppy_cfg_stri
 	char *ptr;
 
 	while (*cfg) {
-		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++)
-			;
+		ptr = cfg;
+		while (*cfg && *cfg != ' ' && *cfg != '\t')
+			cfg++;
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

