From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-move-leading-and-to-preceding-line.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:13 -0400
Message-ID: <201003150654.o2F6skDI016090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759730Ab0COGyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: move leading && and || to preceding line
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-move-leading-and-to-preceding-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: move leading && and || to preceding line
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-move-leading-and-to-preceding-line drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-move-leading-and-to-preceding-line
+++ a/drivers/block/floppy.c
@@ -639,8 +639,8 @@ static const char *timeout_message;
 static void is_alive(const char *message)
 {
 	/* this routine checks whether the floppy driver is "alive" */
-	if (test_bit(0, &fdc_busy) && command_status < 2
-	    && !timer_pending(&fd_timeout)) {
+	if (test_bit(0, &fdc_busy) && command_status < 2 &&
+	    !timer_pending(&fd_timeout)) {
 		DPRINT("timeout handler died: %s\n", message);
 	}
 }
@@ -1769,8 +1769,8 @@ irqreturn_t floppy_interrupt(int irq, vo
 			if (do_print)
 				print_result("sensei", inr);
 			max_sensei--;
-		} while ((ST0 & 0x83) != UNIT(current_drive) && inr == 2
-			 && max_sensei);
+		} while ((ST0 & 0x83) != UNIT(current_drive) &&
+			 inr == 2 && max_sensei);
 	}
 	if (!handler) {
 		FDCS->reset = 1;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

