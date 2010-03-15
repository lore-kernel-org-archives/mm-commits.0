From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-add-function-is_ready_state.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:54:22 -0400
Message-ID: <201003150654.o2F6stJX016100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42410 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759624Ab0COGzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: add function is_ready_state
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-add-function-is_ready_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: add function is_ready_state
From: Joe Perches <joe@perches.com>

Used a couple of times, might simplify the code a bit.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-add-function-is_ready_state drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-add-function-is_ready_state
+++ a/drivers/block/floppy.c
@@ -782,6 +782,12 @@ static inline int is_selected(int dor, i
 	return ((dor & (0x10 << unit)) && (dor & 3) == unit);
 }
 
+static bool is_ready_state(int status)
+{
+	int state = status & (STATUS_READY | STATUS_DIR | STATUS_DMA);
+	return state == STATUS_READY;
+}
+
 static int set_dor(int fdc, char mask, char data)
 {
 	unsigned char unit;
@@ -823,8 +829,10 @@ static void twaddle(void)
 	DRS->select_date = jiffies;
 }
 
-/* reset all driver information about the current fdc. This is needed after
- * a reset, and after a raw command. */
+/*
+ * Reset all driver information about the current fdc.
+ * This is needed after a reset, and after a raw command.
+ */
 static void reset_fdc_info(int mode)
 {
 	int drive;
@@ -1162,7 +1170,8 @@ static int output_byte(char byte)
 
 	if (status < 0)
 		return -1;
-	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY) {
+
+	if (is_ready_state(status)) {
 		fd_outb(byte, FD_DATA);
 #ifdef FLOPPY_SANITY_CHECK
 		output_log[output_log_pos].data = byte;
@@ -1221,8 +1230,10 @@ static int need_more_output(void)
 
 	if (status < 0)
 		return -1;
-	if ((status & (STATUS_READY | STATUS_DIR | STATUS_DMA)) == STATUS_READY)
+
+	if (is_ready_state(status))
 		return MORE_OUTPUT;
+
 	return result();
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

