From: akpm@linux-foundation.org
Subject: - ide-cd-fix-oops-when-using-growisofs.patch removed from -mm tree
Date: Wed, 23 Jul 2008 14:02:34 -0700
Message-ID: <200807232102.m6NL2YQU011773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753828AbYGWVEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 17:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jens.axboe@oracle.com, arnd@arndb.de, bzolnier@gmail.com, jack@suse.cz, mb@bu3sch.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ide-cd: fix oops when using growisofs
has been removed from the -mm tree.  Its filename was
     ide-cd-fix-oops-when-using-growisofs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ide-cd: fix oops when using growisofs
From: Jens Axboe <jens.axboe@oracle.com>

cdrom_read_capacity() will blindly return the capacity from the device
without sanity-checking it.  This later causes create_empty_buffers() to
oops.

Fix this by checking that the device is telling us sensible things.

Cc: Michael Buesch <mb@bu3sch.de>
Tested-by: Jan Kara <jack@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-cd.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/ide/ide-cd.c~ide-cd-fix-oops-when-using-growisofs drivers/ide/ide-cd.c
--- a/drivers/ide/ide-cd.c~ide-cd-fix-oops-when-using-growisofs
+++ a/drivers/ide/ide-cd.c
@@ -1311,13 +1311,29 @@ static int cdrom_read_capacity(ide_drive
 
 	stat = ide_cd_queue_pc(drive, cmd, 0, &capbuf, &len, sense, 0,
 			       REQ_QUIET);
-	if (stat == 0) {
-		*capacity = 1 + be32_to_cpu(capbuf.lba);
-		*sectors_per_frame =
-			be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	if (stat)
+		return stat;
+
+	/*
+	 * Sanity check the given block size
+	 */
+	switch (capbuf.blocklen) {
+	case 512:
+	case 1024:
+	case 2048:
+	case 4096:
+		break;
+	default:
+		printk(KERN_ERR "ide-cd: weird block size %u\n",
+							capbuf.blocklen);
+		printk(KERN_ERR "ide-cd: default to 2kb block size\n");
+		capbuf.blocklen = 2048;
+		break;
 	}
 
-	return stat;
+	*capacity = 1 + be32_to_cpu(capbuf.lba);
+	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
+	return 0;
 }
 
 static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
_

Patches currently in -mm which might be from jens.axboe@oracle.com are

origin.patch
linux-next.patch
cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch
git-block.patch
ide-cd-use-the-new-object_is_in_stack-helper.patch
block-blk-mapc-use-the-new-object_is_on_stack-helper.patch
i2o-handle-sysfs_create_link-failures.patch
fs-partition-checkc-fix-return-value-warning.patch
fs-partition-checkc-fix-return-value-warning-v2-cleanup.patch
block-ioctlc-and-fs-partition-checkc.patch
block-ioctlc-and-fs-partition-checkc-checkpatch-fixes.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
use-warn-in-block.patch
reiser4.patch

