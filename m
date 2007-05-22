From: akpm@linux-foundation.org
Subject: + rd-simplify-by-using-the-same-helper-functions-in-libfs.patch added to -mm tree
Date: Tue, 22 May 2007 09:47:09 -0700
Message-ID: <200705221647.l4MGl9rj005731@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43577 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757071AbXEVQsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 12:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     rd: Simplify by using the same helper functions in libfs
has been added to the -mm tree.  Its filename is
     rd-simplify-by-using-the-same-helper-functions-in-libfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rd: Simplify by using the same helper functions in libfs
From: Eric W. Biederman <ebiederm@xmission.com

While the ramdisk code in the page cache started with the ramfs code it has
diverged, and is a result is more complicated then it currently needs to be. 
This patch simplifies the ramfs code by syncing it with ramfs and similar
pieces of code.

The big difference is that the ramdisk must cope with people placing buffer
heads on it's pages so there is extra code required to mark those buffer heads
dirty and uptodate.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |   76 ++-----------------------------------------
 1 files changed, 5 insertions(+), 71 deletions(-)

diff -puN drivers/block/rd.c~rd-simplify-by-using-the-same-helper-functions-in-libfs drivers/block/rd.c
--- a/drivers/block/rd.c~rd-simplify-by-using-the-same-helper-functions-in-libfs
+++ a/drivers/block/rd.c
@@ -92,36 +92,16 @@ static int rd_blocksize = CONFIG_BLK_DEV
  * aops copied from ramfs.
  */
 
-/*
- * If a ramdisk page has buffers, some may be uptodate and some may be not.
- * To bring the page uptodate we zero out the non-uptodate buffers.  The
- * page must be locked.
- */
 static void make_page_uptodate(struct page *page)
 {
+	clear_highpage(page);
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh = page_buffers(page);
 		struct buffer_head *head = bh;
 
 		do {
-			if (!buffer_uptodate(bh)) {
-				memset(bh->b_data, 0, bh->b_size);
-				/*
-				 * akpm: I'm totally undecided about this.  The
-				 * buffer has just been magically brought "up to
-				 * date", but nobody should want to be reading
-				 * it anyway, because it hasn't been used for
-				 * anything yet.  It is still in a "not read
-				 * from disk yet" state.
-				 *
-				 * But non-uptodate buffers against an uptodate
-				 * page are against the rules.  So do it anyway.
-				 */
-				 set_buffer_uptodate(bh);
-			}
+			set_buffer_uptodate(bh);
 		} while ((bh = bh->b_this_page) != head);
-	} else {
-		memset(page_address(page), 0, PAGE_CACHE_SIZE);
 	}
 	flush_dcache_page(page);
 	SetPageUptodate(page);
@@ -129,55 +109,11 @@ static void make_page_uptodate(struct pa
 
 static int ramdisk_readpage(struct file *file, struct page *page)
 {
-	if (!PageUptodate(page))
-		make_page_uptodate(page);
+	make_page_uptodate(page);
 	unlock_page(page);
 	return 0;
 }
 
-static int ramdisk_prepare_write(struct file *file, struct page *page,
-				unsigned offset, unsigned to)
-{
-	if (!PageUptodate(page))
-		make_page_uptodate(page);
-	return 0;
-}
-
-static int ramdisk_commit_write(struct file *file, struct page *page,
-				unsigned offset, unsigned to)
-{
-	set_page_dirty(page);
-	return 0;
-}
-
-/*
- * ->writepage to the blockdev's mapping has to redirty the page so that the
- * VM doesn't go and steal it.  We return AOP_WRITEPAGE_ACTIVATE so that the VM
- * won't try to (pointlessly) write the page again for a while.
- *
- * Really, these pages should not be on the LRU at all.
- */
-static int ramdisk_writepage(struct page *page, struct writeback_control *wbc)
-{
-	if (!PageUptodate(page))
-		make_page_uptodate(page);
-	SetPageDirty(page);
-	if (wbc->for_reclaim)
-		return AOP_WRITEPAGE_ACTIVATE;
-	unlock_page(page);
-	return 0;
-}
-
-/*
- * This is a little speedup thing: short-circuit attempts to write back the
- * ramdisk blockdev inode to its non-existent backing store.
- */
-static int ramdisk_writepages(struct address_space *mapping,
-				struct writeback_control *wbc)
-{
-	return 0;
-}
-
 /*
  * ramdisk blockdev pages have their own ->set_page_dirty() because we don't
  * want them to contribute to dirty memory accounting.
@@ -206,11 +142,9 @@ static int ramdisk_set_page_dirty(struct
 
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
-	.prepare_write	= ramdisk_prepare_write,
-	.commit_write	= ramdisk_commit_write,
-	.writepage	= ramdisk_writepage,
+	.prepare_write	= simple_prepare_write,
+	.commit_write	= simple_commit_write,
 	.set_page_dirty	= ramdisk_set_page_dirty,
-	.writepages	= ramdisk_writepages,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

freezer-close-potential-race-between-refrigerator-and-thaw_tasks.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
freezer-fix-kthread_create-vs-freezer-theoretical-race.patch
freezer-fix-pf_nofreeze-vs-freezeable-race.patch
freezer-move-frozen_process-to-kernel-power-processc.patch
dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
x86_64-build-and-use-gdt-on-copied-compressed-kernel.patch
i386-efi-fix-proc-iomem-type-for-kexec-tools.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
preserve-the-dirty-bit-in-init_page_buffers.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
