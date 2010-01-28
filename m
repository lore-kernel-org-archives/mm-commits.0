From: akpm@linux-foundation.org
Subject: + drivers-block-floppyc-use-%pf-in-logging-messages.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:18:52 -0800
Message-ID: <201001280118.o0S1Iq2P011815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755475Ab0A1BS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:18:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com


The patch titled
     drivers/block/floppy.c: use %pf in logging messages
has been added to the -mm tree.  Its filename is
     drivers-block-floppyc-use-%pf-in-logging-messages.patch

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
Subject: drivers/block/floppy.c: use %pf in logging messages
From: Joe Perches <joe@perches.com>

Print the function name not the pointer address where useful and possible

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-use-%pf-in-logging-messages drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-use-%pf-in-logging-messages
+++ a/drivers/block/floppy.c
@@ -908,7 +908,7 @@ static inline void unlock_fdc(void)
 		DPRINT("FDC access conflict!\n");
 
 	if (do_floppy)
-		DPRINT("device interrupt still active at FDC release: %p!\n",
+		DPRINT("device interrupt still active at FDC release: %pf!\n",
 		       do_floppy);
 	command_status = FD_COMMAND_NONE;
 	spin_lock_irqsave(&floppy_lock, flags);
@@ -1733,7 +1733,7 @@ irqreturn_t floppy_interrupt(int irq, vo
 		/* we don't even know which FDC is the culprit */
 		pr_info("DOR0=%x\n", fdc_state[0].dor);
 		pr_info("floppy interrupt on bizarre fdc %d\n", fdc);
-		pr_info("handler=%p\n", handler);
+		pr_info("handler=%pf\n", handler);
 		is_alive(__func__, "bizarre fdc");
 		return IRQ_NONE;
 	}
@@ -1792,7 +1792,7 @@ static void reset_interrupt(void)
 	debugt("reset interrupt:");
 	result();		/* get the status ready for set_fdc */
 	if (FDCS->reset) {
-		pr_info("reset set in interrupt, calling %p\n", cont->error);
+		pr_info("reset set in interrupt, calling %pf\n", cont->error);
 		cont->error();	/* a reset just after a reset. BAD! */
 	}
 	cont->redo();
@@ -1833,7 +1833,7 @@ static void show_floppy(void)
 	pr_info("\n");
 	pr_info("floppy driver state\n");
 	pr_info("-------------------\n");
-	pr_info("now=%lu last interrupt=%lu diff=%lu last called handler=%p\n",
+	pr_info("now=%lu last interrupt=%lu diff=%lu last called handler=%pf\n",
 		jiffies, interruptjiffies, jiffies - interruptjiffies,
 		lasthandler);
 
@@ -1852,13 +1852,13 @@ static void show_floppy(void)
 	pr_info("status=%x\n", fd_inb(FD_STATUS));
 	pr_info("fdc_busy=%lu\n", fdc_busy);
 	if (do_floppy)
-		pr_info("do_floppy=%p\n", do_floppy);
+		pr_info("do_floppy=%pf\n", do_floppy);
 	if (work_pending(&floppy_work))
-		pr_info("floppy_work.func=%p\n", floppy_work.func);
+		pr_info("floppy_work.func=%pf\n", floppy_work.func);
 	if (timer_pending(&fd_timer))
-		pr_info("fd_timer.function=%p\n", fd_timer.function);
+		pr_info("fd_timer.function=%pf\n", fd_timer.function);
 	if (timer_pending(&fd_timeout)) {
-		pr_info("timer_function=%p\n", fd_timeout.function);
+		pr_info("timer_function=%pf\n", fd_timeout.function);
 		pr_info("expires=%lu\n", fd_timeout.expires - jiffies);
 		pr_info("now=%lu\n", jiffies);
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

