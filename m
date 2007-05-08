From: akpm@linux-foundation.org
Subject: - mm-optimize-kill_bdev.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:21 -0700
Message-ID: <200705080003.l4803LWw008943@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967337AbXEHADu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: optimize kill_bdev()
has been removed from the -mm tree.  Its filename was
     mm-optimize-kill_bdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: optimize kill_bdev()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Remove duplicate work in kill_bdev().

It currently invalidates and then truncates the bdev's mapping. 
invalidate_mapping_pages() will opportunistically remove pages from the
mapping.  And truncate_inode_pages() will forcefully remove all pages.

The only thing truncate doesn't do is flush the bh lrus.  So do that
explicitly.  This avoids (very unlikely) but possible invalid lookup
results if the same bdev is quickly re-issued.

It also will prevent extreme kernel latencies which are observed when
blockdevs which have a large amount of pagecache are unmounted, by avoiding
invalidate_mapping_pages() on that path.  invalidate_mapping_pages() has no
cond_resched (it can be called under spinlock), whereas truncate_inode_pages()
has one.

[akpm@linux-foundation.org: restore nrpages==0 optimisation]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c              |    6 ++++--
 fs/buffer.c                 |    3 +--
 include/linux/buffer_head.h |    1 +
 3 files changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/block_dev.c~mm-optimize-kill_bdev fs/block_dev.c
--- a/fs/block_dev.c~mm-optimize-kill_bdev
+++ a/fs/block_dev.c
@@ -55,10 +55,12 @@ static sector_t max_block(struct block_d
 	return retval;
 }
 
-/* Kill _all_ buffers, dirty or not.. */
+/* Kill _all_ buffers and pagecache , dirty or not.. */
 static void kill_bdev(struct block_device *bdev)
 {
-	invalidate_bdev(bdev);
+	if (bdev->bd_inode->i_mapping->nrpages == 0)
+		return;
+	invalidate_bh_lrus();
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
 }	
 
diff -puN fs/buffer.c~mm-optimize-kill_bdev fs/buffer.c
--- a/fs/buffer.c~mm-optimize-kill_bdev
+++ a/fs/buffer.c
@@ -44,7 +44,6 @@
 #include <linux/bit_spinlock.h>
 
 static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
-static void invalidate_bh_lrus(void);
 
 #define BH_ENTRY(list) list_entry((list), struct buffer_head, b_assoc_buffers)
 
@@ -1403,7 +1402,7 @@ static void invalidate_bh_lru(void *arg)
 	put_cpu_var(bh_lrus);
 }
 	
-static void invalidate_bh_lrus(void)
+void invalidate_bh_lrus(void)
 {
 	on_each_cpu(invalidate_bh_lru, NULL, 1, 1);
 }
diff -puN include/linux/buffer_head.h~mm-optimize-kill_bdev include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~mm-optimize-kill_bdev
+++ a/include/linux/buffer_head.h
@@ -182,6 +182,7 @@ void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
 struct buffer_head *__bread(struct block_device *, sector_t block, unsigned size);
+void invalidate_bh_lrus(void);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
 void FASTCALL(unlock_buffer(struct buffer_head *bh));
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
exec-fix-remove_arg_zero.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
