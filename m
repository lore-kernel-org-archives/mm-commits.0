From: akpm@linux-foundation.org
Subject: + fs-bufferc-clean-up-export-macros.patch added to -mm tree
Date: Wed, 19 Aug 2009 13:56:18 -0700
Message-ID: <200908192056.n7JKuIQN020238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbZHSU4S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 16:56:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, hsweeten@visionengravers.com


The patch titled
     fs/buffer.c: clean up EXPORT* macros
has been added to the -mm tree.  Its filename is
     fs-bufferc-clean-up-export-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/buffer.c: clean up EXPORT* macros
From: H Hartley Sweeten <hartleys@visionengravers.com>

According to Documentation/CodingStyle the EXPORT* macro should follow
immediately after the closing function brace line.

Also, mark_buffer_async_write_endio() and do_thaw_all() are not used
elsewhere so they should be marked as static.

In addition, file_fsync() is actually in fs/sync.c so move the EXPORT* to
that file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   57 +++++++++++++++++++++++---------------------------
 fs/sync.c   |    1 
 2 files changed, 28 insertions(+), 30 deletions(-)

diff -puN fs/buffer.c~fs-bufferc-clean-up-export-macros fs/buffer.c
--- a/fs/buffer.c~fs-bufferc-clean-up-export-macros
+++ a/fs/buffer.c
@@ -52,6 +52,7 @@ init_buffer(struct buffer_head *bh, bh_e
 	bh->b_end_io = handler;
 	bh->b_private = private;
 }
+EXPORT_SYMBOL(init_buffer);
 
 static int sync_buffer(void *word)
 {
@@ -80,6 +81,7 @@ void unlock_buffer(struct buffer_head *b
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);
 }
+EXPORT_SYMBOL(unlock_buffer);
 
 /*
  * Block until a buffer comes unlocked.  This doesn't stop it
@@ -90,6 +92,7 @@ void __wait_on_buffer(struct buffer_head
 {
 	wait_on_bit(&bh->b_state, BH_Lock, sync_buffer, TASK_UNINTERRUPTIBLE);
 }
+EXPORT_SYMBOL(__wait_on_buffer);
 
 static void
 __clear_page_buffers(struct page *page)
@@ -144,6 +147,7 @@ void end_buffer_read_sync(struct buffer_
 	__end_buffer_read_notouch(bh, uptodate);
 	put_bh(bh);
 }
+EXPORT_SYMBOL(end_buffer_read_sync);
 
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 {
@@ -164,6 +168,7 @@ void end_buffer_write_sync(struct buffer
 	unlock_buffer(bh);
 	put_bh(bh);
 }
+EXPORT_SYMBOL(end_buffer_write_sync);
 
 /*
  * Various filesystems appear to want __find_get_block to be non-blocking.
@@ -272,6 +277,7 @@ void invalidate_bdev(struct block_device
 	invalidate_bh_lrus();
 	invalidate_mapping_pages(mapping, 0, -1);
 }
+EXPORT_SYMBOL(invalidate_bdev);
 
 /*
  * Kick pdflush then try to free up some ZONE_NORMAL memory.
@@ -410,6 +416,7 @@ still_busy:
 	local_irq_restore(flags);
 	return;
 }
+EXPORT_SYMBOL(end_buffer_async_write);
 
 /*
  * If a page's buffers are under async readin (end_buffer_async_read
@@ -438,8 +445,8 @@ static void mark_buffer_async_read(struc
 	set_buffer_async_read(bh);
 }
 
-void mark_buffer_async_write_endio(struct buffer_head *bh,
-				   bh_end_io_t *handler)
+static void mark_buffer_async_write_endio(struct buffer_head *bh,
+					  bh_end_io_t *handler)
 {
 	bh->b_end_io = handler;
 	set_buffer_async_write(bh);
@@ -553,7 +560,7 @@ repeat:
 	return err;
 }
 
-void do_thaw_all(struct work_struct *work)
+static void do_thaw_all(struct work_struct *work)
 {
 	struct super_block *sb;
 	char b[BDEVNAME_SIZE];
@@ -1169,6 +1176,7 @@ void mark_buffer_dirty(struct buffer_hea
 			__set_page_dirty(page, page_mapping(page), 0);
 	}
 }
+EXPORT_SYMBOL(mark_buffer_dirty);
 
 /*
  * Decrement a buffer_head's reference count.  If all buffers against a page
@@ -1185,6 +1193,7 @@ void __brelse(struct buffer_head * buf)
 	}
 	WARN(1, KERN_ERR "VFS: brelse: Trying to free free buffer\n");
 }
+EXPORT_SYMBOL(__brelse);
 
 /*
  * bforget() is like brelse(), except it discards any
@@ -1203,6 +1212,7 @@ void __bforget(struct buffer_head *bh)
 	}
 	__brelse(bh);
 }
+EXPORT_SYMBOL(__bforget);
 
 static struct buffer_head *__bread_slow(struct buffer_head *bh)
 {
@@ -2215,6 +2225,7 @@ int block_read_full_page(struct page *pa
 	}
 	return 0;
 }
+EXPORT_SYMBOL(block_read_full_page);
 
 /* utility function for filesystems that need to do work on expanding
  * truncates.  Uses filesystem pagecache writes to allow the filesystem to
@@ -2249,6 +2260,7 @@ int generic_cont_expand_simple(struct in
 out:
 	return err;
 }
+EXPORT_SYMBOL(generic_cont_expand_simple);
 
 static int cont_expand_zero(struct file *file, struct address_space *mapping,
 			    loff_t pos, loff_t *bytes)
@@ -2349,6 +2361,7 @@ int cont_write_begin(struct file *file, 
 out:
 	return err;
 }
+EXPORT_SYMBOL(cont_write_begin);
 
 int block_prepare_write(struct page *page, unsigned from, unsigned to,
 			get_block_t *get_block)
@@ -2359,6 +2372,7 @@ int block_prepare_write(struct page *pag
 		ClearPageUptodate(page);
 	return err;
 }
+EXPORT_SYMBOL(block_prepare_write);
 
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
@@ -2366,6 +2380,7 @@ int block_commit_write(struct page *page
 	__block_commit_write(inode,page,from,to);
 	return 0;
 }
+EXPORT_SYMBOL(block_commit_write);
 
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
@@ -2423,6 +2438,7 @@ block_page_mkwrite(struct vm_area_struct
 out:
 	return ret;
 }
+EXPORT_SYMBOL(block_page_mkwrite);
 
 /*
  * nobh_write_begin()'s prereads are special: the buffer_heads are freed
@@ -2846,6 +2862,7 @@ unlock:
 out:
 	return err;
 }
+EXPORT_SYMBOL(block_truncate_page);
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
@@ -2887,6 +2904,7 @@ int block_write_full_page_endio(struct p
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
 	return __block_write_full_page(inode, page, get_block, wbc, handler);
 }
+EXPORT_SYMBOL(block_write_full_page_endio);
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
@@ -2897,7 +2915,7 @@ int block_write_full_page(struct page *p
 	return block_write_full_page_endio(page, get_block, wbc,
 					   end_buffer_async_write);
 }
-
+EXPORT_SYMBOL(block_write_full_page);
 
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 			    get_block_t *get_block)
@@ -2910,6 +2928,7 @@ sector_t generic_block_bmap(struct addre
 	get_block(inode, block, &tmp, 0);
 	return tmp.b_blocknr;
 }
+EXPORT_SYMBOL(generic_block_bmap);
 
 static void end_bio_bh_io_sync(struct bio *bio, int err)
 {
@@ -2979,6 +2998,7 @@ int submit_bh(int rw, struct buffer_head
 	bio_put(bio);
 	return ret;
 }
+EXPORT_SYMBOL(submit_bh);
 
 /**
  * ll_rw_block: low-level access to block devices (DEPRECATED)
@@ -3040,6 +3060,7 @@ void ll_rw_block(int rw, int nr, struct 
 		unlock_buffer(bh);
 	}
 }
+EXPORT_SYMBOL(ll_rw_block);
 
 /*
  * For a data-integrity writeout, we need to wait upon any in-progress I/O
@@ -3068,6 +3089,7 @@ int sync_dirty_buffer(struct buffer_head
 	}
 	return ret;
 }
+EXPORT_SYMBOL(sync_dirty_buffer);
 
 /*
  * try_to_free_buffers() checks if all the buffers on this particular page
@@ -3182,6 +3204,7 @@ void block_sync_page(struct page *page)
 	if (mapping)
 		blk_run_backing_dev(mapping->backing_dev_info, page);
 }
+EXPORT_SYMBOL(block_sync_page);
 
 /*
  * There are no bdflush tunables left.  But distributions are
@@ -3358,29 +3381,3 @@ void __init buffer_init(void)
 	max_buffer_heads = nrpages * (PAGE_SIZE / sizeof(struct buffer_head));
 	hotcpu_notifier(buffer_cpu_notify, 0);
 }
-
-EXPORT_SYMBOL(__bforget);
-EXPORT_SYMBOL(__brelse);
-EXPORT_SYMBOL(__wait_on_buffer);
-EXPORT_SYMBOL(block_commit_write);
-EXPORT_SYMBOL(block_prepare_write);
-EXPORT_SYMBOL(block_page_mkwrite);
-EXPORT_SYMBOL(block_read_full_page);
-EXPORT_SYMBOL(block_sync_page);
-EXPORT_SYMBOL(block_truncate_page);
-EXPORT_SYMBOL(block_write_full_page);
-EXPORT_SYMBOL(block_write_full_page_endio);
-EXPORT_SYMBOL(cont_write_begin);
-EXPORT_SYMBOL(end_buffer_read_sync);
-EXPORT_SYMBOL(end_buffer_write_sync);
-EXPORT_SYMBOL(end_buffer_async_write);
-EXPORT_SYMBOL(file_fsync);
-EXPORT_SYMBOL(generic_block_bmap);
-EXPORT_SYMBOL(generic_cont_expand_simple);
-EXPORT_SYMBOL(init_buffer);
-EXPORT_SYMBOL(invalidate_bdev);
-EXPORT_SYMBOL(ll_rw_block);
-EXPORT_SYMBOL(mark_buffer_dirty);
-EXPORT_SYMBOL(submit_bh);
-EXPORT_SYMBOL(sync_dirty_buffer);
-EXPORT_SYMBOL(unlock_buffer);
diff -puN fs/sync.c~fs-bufferc-clean-up-export-macros fs/sync.c
--- a/fs/sync.c~fs-bufferc-clean-up-export-macros
+++ a/fs/sync.c
@@ -174,6 +174,7 @@ int file_fsync(struct file *filp, struct
 		ret = err;
 	return ret;
 }
+EXPORT_SYMBOL(file_fsync);
 
 /**
  * vfs_fsync - perform a fsync or fdatasync on a file
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
mtd-sst25l-non-jedec-spi-flash-driver.patch
drivers-mtd-mtdcorec-make-symbols-static.patch
jbd2h-bitfields-should-be-unsigned.patch
fs-bufferc-clean-up-export-macros.patch
gpio-include-linux-gpioh-not-asm-gpioh.patch
atyfb-coding-style-cleanup.patch
jbdh-bitfields-should-be-unsigned.patch

