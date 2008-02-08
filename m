From: akpm@linux-foundation.org
Subject: - rewrite-rd-fix-2.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:43:02 -0800
Message-ID: <200802080842.m188ghLS016099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54427 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753244AbYBHInW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:43:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byron.bbradley@gmail.com, npiggin@suse.de, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ramdisk driver: make rd_size non-static
has been removed from the -mm tree.  Its filename was
     rewrite-rd-fix-2.patch

This patch was dropped because it was folded into rewrite-rd.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramdisk driver: make rd_size non-static
From: Byron Bradley <byron.bbradley@gmail.com>

In arch/arm/kernel/setup.c:setup_ramdisk(), rd_size is set from the boot
tags.  The replacement ramdisk driver has rd_size as static which causes
linking to fail when ramdisk is built-in.

Signed-off-by: Byron Bradley <byron.bbradley@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/brd.c~rewrite-rd-fix-2 drivers/block/brd.c
--- a/drivers/block/brd.c~rewrite-rd-fix-2
+++ a/drivers/block/brd.c
@@ -350,7 +350,7 @@ static struct block_device_operations br
  * And now the modules code and kernel interface.
  */
 static int rd_nr;
-static int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
+int rd_size = CONFIG_BLK_DEV_RAM_SIZE;
 module_param(rd_nr, int, 0);
 MODULE_PARM_DESC(rd_nr, "Maximum number of brd devices");
 module_param(rd_size, int, 0);
_

Patches currently in -mm which might be from byron.bbradley@gmail.com are

origin.patch
rewrite-rd.patch
rewrite-rd-fix-2.patch
