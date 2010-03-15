From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-repeat-macro.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:28 -0400
Message-ID: <201003150655.o2F6t1Nj016118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759745Ab0COGzH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove REPEAT macro
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-repeat-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove REPEAT macro
From: Joe Perches <joe@perches.com>

Macros with hidden flow changes aren't nice.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-repeat-macro drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-repeat-macro
+++ a/drivers/block/floppy.c
@@ -2885,7 +2885,6 @@ static int make_raw_rw_request(void)
 
 static void redo_fd_request(void)
 {
-#define REPEAT {request_done(0); continue; }
 	int drive;
 	int tmp;
 
@@ -2920,7 +2919,8 @@ static void redo_fd_request(void)
 		if (test_bit(current_drive, &fake_change) ||
 		    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
 			DPRINT("disk absent or changed during operation\n");
-			REPEAT;
+			request_done(0);
+			continue;
 		}
 		if (!_floppy) {	/* Autodetection */
 			if (!probing) {
@@ -2928,7 +2928,8 @@ static void redo_fd_request(void)
 				if (next_valid_format()) {
 					DPRINT("no autodetectable formats\n");
 					_floppy = NULL;
-					REPEAT;
+					request_done(0);
+					continue;
 				}
 			}
 			probing = 1;
@@ -2949,7 +2950,6 @@ static void redo_fd_request(void)
 		debugt("queue fd request");
 		return;
 	}
-#undef REPEAT
 }
 
 static struct cont_t rw_cont = {
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

