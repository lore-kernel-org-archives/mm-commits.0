From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-use-%pf-in-logging-messages.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:46 -0400
Message-ID: <201003150655.o2F6tJEF016146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759757Ab0COGzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: use %pf in logging messages
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-use-%pf-in-logging-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

