From: akpm@linux-foundation.org
Subject: [merged] drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:55:13 -0400
Message-ID: <201003150655.o2F6tkth016167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417Ab0COGzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, bzolnier@gmail.com, jens.axboe@oracle.com, marcin.slusarz@gmail.com, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/floppy.c: remove misleading, used once FD_IOCTL_ALLOWED macro
has been removed from the -mm tree.  Its filename was
     drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/block/floppy.c: remove misleading, used once FD_IOCTL_ALLOWED macro
From: Joe Perches <joe@perches.com>

Just code the test directly

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/block/floppy.c~drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro drivers/block/floppy.c
--- a/drivers/block/floppy.c~drivers-block-floppyc-remove-misleading-used-once-fd_ioctl_allowed-macro
+++ a/drivers/block/floppy.c
@@ -3420,8 +3420,6 @@ static int fd_getgeo(struct block_device
 static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 		    unsigned long param)
 {
-#define FD_IOCTL_ALLOWED (mode & (FMODE_WRITE|FMODE_WRITE_IOCTL))
