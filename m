From: akpm@linux-foundation.org
Subject: - remove-generic_commit_write.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:37 -0700
Message-ID: <200804300539.m3U5dbK2028864@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbYD3Fj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, hch@infradead.org, mm-commits@vger.kernel.org


The patch titled
     remove generic_commit_write()
has been removed from the -mm tree.  Its filename was
     remove-generic_commit_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove generic_commit_write()
From: Adrian Bunk <bunk@kernel.org>

Remove the obsolete and no longer used generic_commit_write().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   18 ------------------
 include/linux/buffer_head.h |    1 -
 2 files changed, 19 deletions(-)

diff -puN fs/buffer.c~remove-generic_commit_write fs/buffer.c
--- a/fs/buffer.c~remove-generic_commit_write
+++ a/fs/buffer.c
@@ -2328,23 +2328,6 @@ int block_commit_write(struct page *page
 	return 0;
 }
 
-int generic_commit_write(struct file *file, struct page *page,
-		unsigned from, unsigned to)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-	__block_commit_write(inode,page,from,to);
-	/*
-	 * No need to use i_size_read() here, the i_size
-	 * cannot change under us because we hold i_mutex.
-	 */
-	if (pos > inode->i_size) {
-		i_size_write(inode, pos);
-		mark_inode_dirty(inode);
-	}
-	return 0;
-}
-
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
@@ -3315,7 +3298,6 @@ EXPORT_SYMBOL(end_buffer_write_sync);
 EXPORT_SYMBOL(file_fsync);
 EXPORT_SYMBOL(fsync_bdev);
 EXPORT_SYMBOL(generic_block_bmap);
-EXPORT_SYMBOL(generic_commit_write);
 EXPORT_SYMBOL(generic_cont_expand_simple);
 EXPORT_SYMBOL(init_buffer);
 EXPORT_SYMBOL(invalidate_bdev);
diff -puN include/linux/buffer_head.h~remove-generic_commit_write include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~remove-generic_commit_write
+++ a/include/linux/buffer_head.h
@@ -225,7 +225,6 @@ int block_page_mkwrite(struct vm_area_st
 				get_block_t get_block);
 void block_sync_page(struct page *);
 sector_t generic_block_bmap(struct address_space *, sector_t, get_block_t *);
-int generic_commit_write(struct file *, struct page *, unsigned, unsigned);
 int block_truncate_page(struct address_space *, loff_t, get_block_t *);
 int file_fsync(struct file *, struct dentry *, int);
 int nobh_write_begin(struct file *, struct address_space *,
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

