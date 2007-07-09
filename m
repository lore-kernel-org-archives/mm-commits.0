From: akpm@linux-foundation.org
Subject: - rd-simplify-by-using-the-same-helper-functions-in-libfs.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:48:39 -0700
Message-ID: <200707092148.l69Lmd3u014126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54083 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462AbXGIVsq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:48:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     rd: simplify by using the same helper functions in libfs
has been removed from the -mm tree.  Its filename was
     rd-simplify-by-using-the-same-helper-functions-in-libfs.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: rd: simplify by using the same helper functions in libfs
From: Eric W. Biederman <ebiederm@xmission.com>

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
 1 file changed, 5 insertions(+), 71 deletions(-)

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

dvb_en_50221-convert-to-kthread-api.patch
git-kbuild.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
i386-trim-memory-not-covered-by-wb-mtrrs.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-add-ioapic-nmi-support.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
buffer-kill-old-incorrect-comment.patch
remove-config_uts_ns-and-config_ipc_ns.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
mm-fix-create_new_namespaces-return-value.patch
add-a-kmem_cache-for-nsproxy-objects.patch
update-procfs-guide-doc-of-read_func.patch
namespace-ensure-clone_flags-are-always-stored-in-an-unsigned-long.patch
add-documentation-sysctl-ctl_unnumberedtxt.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
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
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
