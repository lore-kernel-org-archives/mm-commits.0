From: akpm@linux-foundation.org
Subject: + mm-optimize-kill_bdev.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:18:19 -0700
Message-ID: <200704131918.l3DJIiBE007430@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47136 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXDMTSt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mm: optimize kill_bdev()
has been added to the -mm tree.  Its filename is
     mm-optimize-kill_bdev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c              |    2 +-
 fs/buffer.c                 |    3 +--
 include/linux/buffer_head.h |    1 +
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/block_dev.c~mm-optimize-kill_bdev fs/block_dev.c
--- a/fs/block_dev.c~mm-optimize-kill_bdev
+++ a/fs/block_dev.c
@@ -58,7 +58,7 @@ static sector_t max_block(struct block_d
 /* Kill _all_ buffers, dirty or not.. */
 static void kill_bdev(struct block_device *bdev)
 {
-	invalidate_bdev(bdev);
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
 
@@ -1404,7 +1403,7 @@ static void invalidate_bh_lru(void *arg)
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

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch
mm-optimize-kill_bdev.patch
exec-fix-remove_arg_zero-add-comment.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
