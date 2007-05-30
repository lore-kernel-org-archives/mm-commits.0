From: akpm@linux-foundation.org
Subject: + fs-block_devc-use-list_for_each_entry.patch added to -mm tree
Date: Wed, 30 May 2007 13:38:43 -0700
Message-ID: <200705302038.l4UKch74004072@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738AbXE3Uiq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 16:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com


The patch titled
     fs/block_dev.c: use list_for_each_entry()
has been added to the -mm tree.  Its filename is
     fs-block_devc-use-list_for_each_entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/block_dev.c: use list_for_each_entry()
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

fs/block_dev.c: Use list_for_each_entry() instead of list_for_each()
in nr_blockdev_pages()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

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

kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
use-mutex-instead-of-semaphore-in-the-mtd-dataflash-driver.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
block-device-elevator-use-list_for_each_entry-instead-of-list_for_each.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-list_for_each_entry-for-iteration-in-hostap_apc.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
