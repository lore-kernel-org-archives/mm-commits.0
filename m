From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-used-once-check_ready-macro.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:15 -0400
Message-ID: <201003150653.o2F6rm0g016017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759697Ab0COGxy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove used once CHECK_READY macro
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-used-once-check_ready-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove used once CHECK_READY macro
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-used-once-check_ready-macro drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-used-once-check_ready-macro
+++ a/drivers/block/floppy.c
@@ -575,7 +575,6 @@ static void floppy_release_irq_and_dma(v
  * reset doesn't need to be tested before sending commands, because
  * output_byte is automatically disabled when reset is set.
  */
-#define CHECK_RESET { if (FDCS->reset){ reset_fdc(); return; } }
 static void reset_fdc(void);
 
 /*
@@ -1958,7 +1957,10 @@ static int start_motor(void (*function)(
 
 static void floppy_ready(void)
 {
-	CHECK_RESET;
+	if (FDCS->reset) {
+		reset_fdc();
+		return;
+	}
 	if (start_motor(floppy_ready))
 		return;
 	if (fdc_dtr())
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

