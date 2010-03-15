From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-use-__func__-where-appropriate.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:43 -0400
Message-ID: <201003150655.o2F6tGkv016143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759755Ab0COGzW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: use __func__ where appropriate
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-use-__func__-where-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: use __func__ where appropriate
From: Joe Perches <joe@perches.com>

Add and use __func__ to is_alive.
Use __func__ in some DPRINTs.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-use-__func__-where-appropriate drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-use-__func__-where-appropriate
+++ a/drivers/block/floppy.c
@@ -631,12 +631,12 @@ static DEFINE_TIMER(fd_timeout, floppy_s
 
 static const char *timeout_message;
 
-static void is_alive(const char *message)
+static void is_alive(const char *func, const char *message)
 {
 	/* this routine checks whether the floppy driver is "alive" */
 	if (test_bit(0, &fdc_busy) && command_status < 2 &&
 	    !timer_pending(&fd_timeout)) {
-		DPRINT("timeout handler died: %s\n", message);
+		DPRINT("%s: timeout handler died.  %s\n", func, message);
 	}
 }
 
@@ -1734,7 +1734,7 @@ irqreturn_t floppy_interrupt(int irq, vo
 		pr_info("DOR0=%x\n", fdc_state[0].dor);
 		pr_info("floppy interrupt on bizarre fdc %d\n", fdc);
 		pr_info("handler=%p\n", handler);
-		is_alive("bizarre fdc");
+		is_alive(__func__, "bizarre fdc");
 		return IRQ_NONE;
 	}
 
@@ -1769,7 +1769,7 @@ irqreturn_t floppy_interrupt(int irq, vo
 		return IRQ_NONE;
 	}
 	schedule_bh(handler);
-	is_alive("normal interrupt end");
+	is_alive(__func__, "normal interrupt end");
 
 	/* FIXME! Was it really for us? */
 	return IRQ_HANDLED;
@@ -1894,7 +1894,7 @@ static void floppy_shutdown(unsigned lon
 		pr_info("no cont in shutdown!\n");
 		process_fd_request();
 	}
-	is_alive("floppy shutdown");
+	is_alive(__func__, "");
 }
 
 /* start motor, check media-changed condition and write protection */
@@ -2027,7 +2027,7 @@ static int wait_til_done(void (*handler)
 			if (command_status >= 2 || !NO_SIGNAL)
 				break;
 
-			is_alive("wait_til_done");
+			is_alive(__func__, "");
 			schedule();
 		}
 
@@ -2602,7 +2602,7 @@ static int make_raw_rw_request(void)
 		raw_cmd->flags |= FD_RAW_WRITE;
 		COMMAND = FM_MODE(_floppy, FD_WRITE);
 	} else {
-		DPRINT("make_raw_rw_request: unknown command\n");
+		DPRINT("%s: unknown command\n", __func__);
 		return 0;
 	}
 
@@ -2743,7 +2743,7 @@ static int make_raw_rw_request(void)
 			raw_cmd->kernel_data = current_req->buffer;
 			raw_cmd->length = current_count_sectors << 9;
 			if (raw_cmd->length == 0) {
-				DPRINT("zero dma transfer attempted from make_raw_request\n");
+				DPRINT("%s: zero dma transfer attempted\n", __func__);
 				DPRINT("indirect=%d direct=%d fsector_t=%d\n",
 				       indirect, direct, fsector_t);
 				return 0;
@@ -2938,7 +2938,7 @@ static void process_fd_request(void)
 static void do_fd_request(struct request_queue *q)
 {
 	if (max_buffer_sectors == 0) {
-		pr_info("VFS: do_fd_request called on non-open device\n");
+		pr_info("VFS: %s called on non-open device\n", __func__);
 		return;
 	}
 
@@ -2953,12 +2953,12 @@ static void do_fd_request(struct request
 	if (test_bit(0, &fdc_busy)) {
 		/* fdc busy, this new request will be treated when the
 		   current one is done */
-		is_alive("do fd request, old request running");
+		is_alive(__func__, "old request running");
 		return;
 	}
 	lock_fdc(MAXTIMEOUT, false);
 	process_fd_request();
-	is_alive("do fd request");
+	is_alive(__func__, "");
 }
 
 static struct cont_t poll_cont = {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

