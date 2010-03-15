From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:19 -0400
Message-ID: <201003150654.o2F6sqHo016096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36339 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759729Ab0COGy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: convert int initialising to bool initialized
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-convert-int-initialising-to-bool-initialized.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

