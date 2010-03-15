From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:07 -0400
Message-ID: <201003150654.o2F6se4G016084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759728Ab0COGyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-macros-call-wait-and-iwait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
From: Joe Perches <joe@perches.com>

Obfuscating macros with embedded returns are not nice

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-macros-call-wait-and-iwait drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-macros-call-wait-and-iwait
+++ a/drivers/block/floppy.c
@@ -519,10 +519,6 @@ static DECLARE_WAIT_QUEUE_HEAD(fdc_wait)
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
-#define CALL(x)		if ((x) == -EINTR) return -EINTR
-#define _WAIT(x,i)	CALL(ret=wait_til_done((x),i))
-#define WAIT(x)		_WAIT((x),interruptible)
-#define IWAIT(x)	_WAIT((x),1)
 
 /* Errors during formatting are counted here. */
 static int format_errors;
@@ -2268,7 +2264,9 @@ static int do_format(int drive, struct f
 	format_errors = 0;
 	cont = &format_cont;
 	errors = &format_errors;
-	IWAIT(redo_format);
+	ret = wait_til_done(redo_format, 1);
+	if (ret == -EINTR)
+		return -EINTR;
 	process_fd_request();
 	return ret;
 }
@@ -2996,8 +2994,6 @@ static struct cont_t poll_cont = {
 
 static int poll_drive(int interruptible, int flag)
 {
-	int ret;
-
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->flags = flag;
@@ -3006,8 +3002,8 @@ static int poll_drive(int interruptible,
 	cont = &poll_cont;
 	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
 	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
-	WAIT(floppy_ready);
-	return ret;
+
+	return wait_til_done(floppy_ready, interruptible);
 }
 
 /*
@@ -3038,7 +3034,9 @@ static int user_reset_fdc(int drive, int
 		FDCS->reset = 1;
 	if (FDCS->reset) {
 		cont = &reset_cont;
-		WAIT(reset_fdc);
+		ret = wait_til_done(reset_fdc, interruptible);
+		if (ret == -EINTR)
+			return -EINTR;
 	}
 	process_fd_request();
 	return 0;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

