From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-obfuscating-code2size-macro.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:07 -0400
Message-ID: <201003150655.o2F6tfZp016164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417Ab0COGzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove obfuscating CODE2SIZE macro
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-obfuscating-code2size-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove obfuscating CODE2SIZE macro
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-obfuscating-code2size-macro drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-obfuscating-code2size-macro
+++ a/drivers/block/floppy.c
@@ -2143,7 +2143,6 @@ static void format_interrupt(void)
 	cont->redo();
 }
 
-#define CODE2SIZE (ssize = ((1 << SIZECODE) + 3) >> 2)
 #define FM_MODE(x, y) ((y) & ~(((x)->rate & 0x80) >> 1))
 #define CT(x) ((x) | 0xc0)
 
@@ -2347,7 +2346,7 @@ static void rw_interrupt(void)
 		DRS->first_read_date = jiffies;
 
 	nr_sectors = 0;
-	CODE2SIZE;
+	ssize = DIV_ROUND_UP(1 << SIZECODE, 4);
 
 	if (ST1 & ST1_EOC)
 		eoc = 1;
@@ -2647,7 +2646,7 @@ static int make_raw_rw_request(void)
 	raw_cmd->track = TRACK << STRETCH(_floppy);
 	DR_SELECT = UNIT(current_drive) + PH_HEAD(_floppy, HEAD);
 	GAP = _floppy->gap;
-	CODE2SIZE;
+	ssize = DIV_ROUND_UP(1 << SIZECODE, 4);
 	SECT_PER_TRACK = _floppy->sect << 2 >> SIZECODE;
 	SECTOR = ((fsector_t % _floppy->sect) << 2 >> SIZECODE) +
 	    FD_SECTBASE(_floppy);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-gpu-drm-i915-intel_biosc-fix-continuation-line-formats.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch

