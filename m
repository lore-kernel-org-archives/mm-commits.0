From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-comment-neatening-and-remove-naked.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:24 -0400
Message-ID: <201003150653.o2F6rwYF016029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759712Ab0COGyF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: comment neatening and remove naked ;
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-comment-neatening-and-remove-naked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

