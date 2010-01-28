From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-use-__func__-where-appropriate.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:18:50 -0800
Message-ID: <201001280118.o0S1IoJI011812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472Ab0A1BS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: use __func__ where appropriate
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-use-__func__-where-appropriate.patch

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

