From: akpm@linux-foundation.org
Subject: - ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch removed from -mm tree
Date: Mon, 28 Jul 2008 16:57:08 -0700
Message-ID: <200807282357.m6SNv8HK002735@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYG1X51 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 19:57:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     ramfs-and-ram-disk-pages-are-unevictable: undo the brd.c part 
has been removed from the -mm tree.  Its filename was
     ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch

This patch was dropped because it was folded into ramfs-and-ram-disk-pages-are-unevictable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ramfs-and-ram-disk-pages-are-unevictable: undo the brd.c part 
From: Rik van Riel <riel@redhat.com>

Undo the brd.c part of ramfs-and-ram-disk-pages-are-unevictable.patch.
The brd pages do not live on the LRU at all, so there is no need to
play these tricks.

Debugged-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/brd.c |   13 -------------
 1 file changed, 13 deletions(-)

diff -puN drivers/block/brd.c~ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part drivers/block/brd.c
--- a/drivers/block/brd.c~ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part
+++ a/drivers/block/brd.c
@@ -374,21 +374,8 @@ static int brd_ioctl(struct inode *inode
 	return error;
 }
 
-/*
- * brd_open():
- * Just mark the mapping as containing unevictable pages
- */
-static int brd_open(struct inode *inode, struct file *filp)
-{
-	struct address_space *mapping = inode->i_mapping;
-
-	mapping_set_unevictable(mapping);
-	return 0;
-}
-
 static struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
-	.open  =		brd_open,
 	.ioctl =		brd_ioctl,
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
ecryptfs-use-page_alloc-not-kmalloc-to-get-a-page-of-memory.patch
ntp-let-update_persistent_clock-sleep.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-free-swap-space-on-swap-in-activation.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check.patch
vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch
more-aggressively-use-lumpy-reclaim.patch
pageflag-helpers-for-configed-out-flags.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
ramfs-and-ram-disk-pages-are-unevictable.patch
ramfs-and-ram-disk-pages-are-unevictable-undo-the-brdc-part.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-downgrade-mmap-sem-while-populating-mlocked-regions.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
introduce-__get_user_pages-fix.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
swap-cull-unevictable-pages-in-fault-path.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
mlock-count-attempts-to-free-mlocked-page.patch
doc-unevictable-lru-and-mlocked-pages-documentation.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

