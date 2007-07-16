From: akpm@linux-foundation.org
Subject: - fs-block_devc-use-list_for_each_entry.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:13 -0700
Message-ID: <200707162055.l6GKtDtm001894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51079 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758045AbXGPVHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:07:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/block_dev.c: use list_for_each_entry()
has been removed from the -mm tree.  Its filename was
     fs-block_devc-use-list_for_each_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/block_dev.c: use list_for_each_entry()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/block_dev.c: Use list_for_each_entry() instead of list_for_each()
in nr_blockdev_pages()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-use-list_for_each_entry fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-use-list_for_each_entry
+++ a/fs/block_dev.c
@@ -588,12 +588,10 @@ EXPORT_SYMBOL(bdget);
 
 long nr_blockdev_pages(void)
 {
-	struct list_head *p;
+	struct block_device *bdev;
 	long ret = 0;
 	spin_lock(&bdev_lock);
-	list_for_each(p, &all_bdevs) {
-		struct block_device *bdev;
-		bdev = list_entry(p, struct block_device, bd_list);
+	list_for_each_entry(bdev, &all_bdevs, bd_list) {
 		ret += bdev->bd_inode->i_mapping->nrpages;
 	}
 	spin_unlock(&bdev_lock);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
