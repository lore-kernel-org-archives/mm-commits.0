From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-dprint-neatening.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:40 -0400
Message-ID: <201003150655.o2F6tDS1016140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759753Ab0COGzT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: DPRINT neatening
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-dprint-neatening.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: DPRINT neatening
From: Joe Perches <joe@perches.com>

Move DPRINT macro definition above 1st use Consolidate a format string
(>80 columns) Add a newline to an unterminated message Comment neatened

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-dprint-neatening drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-dprint-neatening
+++ a/drivers/block/floppy.c
@@ -149,8 +149,11 @@
 #define REALLY_SLOW_IO
 
 #define DEBUGT 2
-#define DCL_DEBUG		/* debug disk change line */
 
+#define DPRINT(format, args...) \
+	pr_info("floppy%d: " format, current_drive, ##args)
+
+#define DCL_DEBUG		/* debug disk change line */
 #ifdef DCL_DEBUG
 #define debug_dcl(test, fmt, args...) \
 	do { if ((test) & FD_DEBUG) DPRINT(fmt, ##args); } while (0)
@@ -159,7 +162,6 @@
 	do { if (0) DPRINT(fmt, ##args); } while (0)
 #endif
 
-
 /* do print messages for unexpected interrupts */
 static int print_unex = 1;
 #include <linux/module.h>
@@ -308,9 +310,6 @@ static bool initialized;
 #define UDRWE	(&write_errors[drive])
 #define UFDCS	(&fdc_state[FDC(drive)])
 
-#define DPRINT(format, args...) \
-	pr_info("floppy%d: " format, current_drive, ##args)
-
 #define PH_HEAD(floppy, head) (((((floppy)->stretch & 2) >> 1) ^ head) << 2)
 #define STRETCH(floppy)	((floppy)->stretch & FD_STRETCH)
 
@@ -345,7 +344,7 @@ static bool initialized;
  */
 #define MAX_REPLIES 16
 static unsigned char reply_buffer[MAX_REPLIES];
-static int inr;			/* size of reply buffer, when called from interrupt */
+static int inr;		/* size of reply buffer, when called from interrupt */
 #define ST0		(reply_buffer[0])
 #define ST1		(reply_buffer[1])
 #define ST2		(reply_buffer[2])
@@ -755,8 +754,7 @@ static int disk_change(int drive)
 		if (UDRS->keep_data >= 0) {
 			if ((UDP->flags & FTD_MSG) &&
 			    current_type[drive] != NULL)
-				DPRINT("Disk type is undefined after "
-				       "disk change\n");
+				DPRINT("Disk type is undefined after disk change\n");
 			current_type[drive] = NULL;
 			floppy_sizes[TOMINOR(drive)] = MAX_DISK_SIZE << 1;
 		}
@@ -1447,7 +1445,7 @@ static int interpret_errors(void)
 	char bad;
 
 	if (inr != 7) {
-		DPRINT("-- FDC reply error");
+		DPRINT("-- FDC reply error\n");
 		FDCS->reset = 1;
 		return 1;
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

