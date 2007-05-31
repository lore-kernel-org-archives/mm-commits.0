From: akpm@linux-foundation.org
Subject: + rd-remove-ramdisk_set_page_dirty.patch added to -mm tree
Date: Thu, 31 May 2007 16:12:51 -0700
Message-ID: <200705312312.l4VNCpda030345@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754313AbXEaXMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 19:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, nickpiggin@yahoo.com.au


The patch titled
     rd: remove ramdisk_set_page_dirty
has been added to the -mm tree.  Its filename is
     rd-remove-ramdisk_set_page_dirty.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rd: remove ramdisk_set_page_dirty
From: Eric W. Biederman <ebiederm@xmission.com>

The generic function __set_page_dirty_buffers called by default by
set_page_dirty appears to be a correct superset of ramdisk_set_page_dirty. 
So remove the specialized ramdisk version.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/rd.c |   27 ---------------------------
 1 files changed, 27 deletions(-)

diff -puN drivers/block/rd.c~rd-remove-ramdisk_set_page_dirty drivers/block/rd.c
--- a/drivers/block/rd.c~rd-remove-ramdisk_set_page_dirty
+++ a/drivers/block/rd.c
@@ -114,37 +114,10 @@ static int ramdisk_readpage(struct file 
 	return 0;
 }
 
-/*
- * ramdisk blockdev pages have their own ->set_page_dirty() because we don't
- * want them to contribute to dirty memory accounting.
- */
-static int ramdisk_set_page_dirty(struct page *page)
-{
-	struct address_space * const mapping = page->mapping;
-
-	spin_lock(&mapping->private_lock);
-	if (page_has_buffers(page)) {
-		struct buffer_head *head = page_buffers(page);
-		struct buffer_head *bh = head;
-
-		do {
-			set_buffer_uptodate(bh);
-			set_buffer_dirty(bh);
-			bh = bh->b_this_page;
-		} while (bh != head);
-	}
-	spin_unlock(&mapping->private_lock);
-
-	if (!TestSetPageDirty(page))
-		return 1;
-	return 0;
-}
-
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
 	.prepare_write	= simple_prepare_write,
 	.commit_write	= simple_commit_write,
-	.set_page_dirty	= ramdisk_set_page_dirty,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

dvb_en_50221-convert-to-kthread-api.patch
fix-i-oat-for-kexec.patch
pci-disable-msi-by-default-on-systems-with-serverworks-ht1000-chips.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3-fix.patch
msi-fix-the-ordering-of-msix-irqs.patch
msi-mask-the-msix-vector-before-we-unmap-it.patch
aacraid-fix-shutdown-handler-to-also-disable-interrupts.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
preserve-the-dirty-bit-in-init_page_buffers.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
rd-simplify-by-using-the-same-helper-functions-in-libfs.patch
rd-remove-ramdisk_set_page_dirty.patch
rd-remove-ramdisk_set_page_dirty-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
