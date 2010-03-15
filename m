From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:53:38 -0400
Message-ID: <201003150654.o2F6sBRZ016056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934462Ab0COGyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove a few spaces from function casts
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-a-few-spaces-from-function-casts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove a few spaces from function casts
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

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-a-few-spaces-from-function-casts drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-a-few-spaces-from-function-casts
+++ a/drivers/block/floppy.c
@@ -632,7 +632,7 @@ static inline void set_debugt(void) { }
 static inline void debugt(const char *message) { }
 #endif /* DEBUGT */
 
-typedef void (*timeout_fn) (unsigned long);
+typedef void (*timeout_fn)(unsigned long);
 static DEFINE_TIMER(fd_timeout, floppy_shutdown, 0, 0);
 
 static const char *timeout_message;
@@ -1036,7 +1036,7 @@ static void fd_watchdog(void)
 		reset_fdc();
 	} else {
 		del_timer(&fd_timer);
-		fd_timer.function = (timeout_fn) fd_watchdog;
+		fd_timer.function = (timeout_fn)fd_watchdog;
 		fd_timer.expires = jiffies + HZ / 10;
 		add_timer(&fd_timer);
 	}
@@ -1534,9 +1534,9 @@ static void setup_rw_floppy(void)
 		 */
 		if (time_after(ready_date, jiffies + DP->select_delay)) {
 			ready_date -= DP->select_delay;
-			function = (timeout_fn) floppy_start;
+			function = (timeout_fn)floppy_start;
 		} else
-			function = (timeout_fn) setup_rw_floppy;
+			function = (timeout_fn)setup_rw_floppy;
 
 		/* wait until the floppy is spinning fast enough */
 		if (fd_wait_for_completion(ready_date, function))
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

