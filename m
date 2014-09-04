From: akpm@linux-foundation.org
Subject: + fsc-support-buffer-cache-allocations-with-gfp-modifiers.patch
 added to -mm tree
Date: Thu, 04 Sep 2014 15:18:02 -0700
Message-ID: <5408e51a.J6gD8LLxNssjvvHt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56610 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbaIDWSD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2014 18:18:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gioh.kim@lge.com, adilger.kernel@dilger.ca, gunho.lee@lge.com, jack@suse.cz, js1304@gmail.com, minchan@kernel.org, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs.c: support buffer cache allocations with gfp modifiers
has been added to the -mm tree.  Its filename is
     fsc-support-buffer-cache-allocations-with-gfp-modifiers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fsc-support-buffer-cache-allocations-with-gfp-modifiers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fsc-support-buffer-cache-allocations-with-gfp-modifiers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gioh Kim <gioh.kim@lge.com>
Subject: fs.c: support buffer cache allocations with gfp modifiers

This patchset tries to solve problem that a long-lasting page caches of
ext4 superblock and journaling of superblock disturb page migration.

I've been testing CMA feature on my ARM-based platform and found that two
page caches cannot be migrated.  They are page caches of superblock of
ext4 filesystem and its journaling data.

Current ext4 reads superblock with sb_bread() that allocates page from
movable area.  But the problem is that ext4 hold the page until it is
unmounted.  If root filesystem is ext4 the page cannot be migrated
forever.  And also the journaling data for the superblock cannot be
migreated.

I introduce new APIs that allocates page cache with specific flag passed
by an argument.  *_gfp APIs are for user want to set page allocation flag
for page cache allocation.  And *_unmovable APIs are for the user wants to
allocate page cache from non-movable area.

It is useful for ext4/ext3 and others that want to hold page cache for a
long time.


This patch (of 3):

A buffer cache is allocated from movable area because it is referred for a
while and released soon.  But some filesystems are taking buffer cache for
a long time and it can disturb page migration.

New APIs are introduced to allocate buffer cache with user specific flag. 
*_gfp APIs are for user want to set page allocation flag for page cache
allocation.  And *_unmovable APIs are for the user wants to allocate page
cache from non-movable area.

Signed-off-by: Gioh Kim <gioh.kim@lge.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   45 ++++++++++++++++++--------------
 include/linux/buffer_head.h |   47 ++++++++++++++++++++++++++++++----
 2 files changed, 68 insertions(+), 24 deletions(-)

diff -puN fs/buffer.c~fsc-support-buffer-cache-allocations-with-gfp-modifiers fs/buffer.c
--- a/fs/buffer.c~fsc-support-buffer-cache-allocations-with-gfp-modifiers
+++ a/fs/buffer.c
@@ -993,7 +993,7 @@ init_page_buffers(struct page *page, str
  */
 static int
 grow_dev_page(struct block_device *bdev, sector_t block,
-		pgoff_t index, int size, int sizebits)
+	      pgoff_t index, int size, int sizebits, gfp_t gfp)
 {
 	struct inode *inode = bdev->bd_inode;
 	struct page *page;
@@ -1002,8 +1002,8 @@ grow_dev_page(struct block_device *bdev,
 	int ret = 0;		/* Will call free_more_memory() */
 	gfp_t gfp_mask;
 
-	gfp_mask = mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
-	gfp_mask |= __GFP_MOVABLE;
+	gfp_mask = (mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS) | gfp;
+
 	/*
 	 * XXX: __getblk_slow() can not really deal with failure and
 	 * will endlessly loop on improvised global reclaim.  Prefer
@@ -1058,7 +1058,7 @@ failed:
  * that page was dirty, the buffers are set dirty also.
  */
 static int
-grow_buffers(struct block_device *bdev, sector_t block, int size)
+grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_t gfp)
 {
 	pgoff_t index;
 	int sizebits;
@@ -1085,11 +1085,12 @@ grow_buffers(struct block_device *bdev,
 	}
 
 	/* Create a page with the proper size buffers.. */
-	return grow_dev_page(bdev, block, index, size, sizebits);
+	return grow_dev_page(bdev, block, index, size, sizebits, gfp);
 }
 
-static struct buffer_head *
-__getblk_slow(struct block_device *bdev, sector_t block, int size)
+struct buffer_head *
+__getblk_slow(struct block_device *bdev, sector_t block,
+	     unsigned size, gfp_t gfp)
 {
 	/* Size must be multiple of hard sectorsize */
 	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
@@ -1111,13 +1112,14 @@ __getblk_slow(struct block_device *bdev,
 		if (bh)
 			return bh;
 
-		ret = grow_buffers(bdev, block, size);
+		ret = grow_buffers(bdev, block, size, gfp);
 		if (ret < 0)
 			return NULL;
 		if (ret == 0)
 			free_more_memory();
 	}
 }
+EXPORT_SYMBOL(__getblk_slow);
 
 /*
  * The relationship between dirty buffers and dirty pages:
@@ -1371,24 +1373,25 @@ __find_get_block(struct block_device *bd
 EXPORT_SYMBOL(__find_get_block);
 
 /*
- * __getblk will locate (and, if necessary, create) the buffer_head
+ * __getblk_gfp() will locate (and, if necessary, create) the buffer_head
  * which corresponds to the passed block_device, block and size. The
  * returned buffer has its reference count incremented.
  *
- * __getblk() will lock up the machine if grow_dev_page's try_to_free_buffers()
- * attempt is failing.  FIXME, perhaps?
+ * __getblk_gfp() will lock up the machine if grow_dev_page's
+ * try_to_free_buffers() attempt is failing.  FIXME, perhaps?
  */
 struct buffer_head *
-__getblk(struct block_device *bdev, sector_t block, unsigned size)
+__getblk_gfp(struct block_device *bdev, sector_t block,
+	     unsigned size, gfp_t gfp)
 {
 	struct buffer_head *bh = __find_get_block(bdev, block, size);
 
 	might_sleep();
 	if (bh == NULL)
-		bh = __getblk_slow(bdev, block, size);
+		bh = __getblk_slow(bdev, block, size, gfp);
 	return bh;
 }
-EXPORT_SYMBOL(__getblk);
+EXPORT_SYMBOL(__getblk_gfp);
 
 /*
  * Do async read-ahead on a buffer..
@@ -1404,24 +1407,28 @@ void __breadahead(struct block_device *b
 EXPORT_SYMBOL(__breadahead);
 
 /**
- *  __bread() - reads a specified block and returns the bh
+ *  __bread_gfp() - reads a specified block and returns the bh
  *  @bdev: the block_device to read from
  *  @block: number of block
  *  @size: size (in bytes) to read
- * 
+ *  @gfp: page allocation flag
+ *
  *  Reads a specified block, and returns buffer head that contains it.
+ *  The page cache can be allocated from non-movable area
+ *  not to prevent page migration if you set gfp to zero.
  *  It returns NULL if the block was unreadable.
  */
 struct buffer_head *
-__bread(struct block_device *bdev, sector_t block, unsigned size)
+__bread_gfp(struct block_device *bdev, sector_t block,
+		   unsigned size, gfp_t gfp)
 {
-	struct buffer_head *bh = __getblk(bdev, block, size);
+	struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);
 
 	if (likely(bh) && !buffer_uptodate(bh))
 		bh = __bread_slow(bh);
 	return bh;
 }
-EXPORT_SYMBOL(__bread);
+EXPORT_SYMBOL(__bread_gfp);
 
 /*
  * invalidate_bh_lrus() is called rarely - but not only at unmount.
diff -puN include/linux/buffer_head.h~fsc-support-buffer-cache-allocations-with-gfp-modifiers include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fsc-support-buffer-cache-allocations-with-gfp-modifiers
+++ a/include/linux/buffer_head.h
@@ -175,12 +175,13 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
 			unsigned size);
-struct buffer_head *__getblk(struct block_device *bdev, sector_t block,
-			unsigned size);
+struct buffer_head *__getblk_gfp(struct block_device *bdev, sector_t block,
+				  unsigned size, gfp_t gfp);
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
-struct buffer_head *__bread(struct block_device *, sector_t block, unsigned size);
+struct buffer_head *__bread_gfp(struct block_device *,
+				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
@@ -295,7 +296,13 @@ static inline void bforget(struct buffer
 static inline struct buffer_head *
 sb_bread(struct super_block *sb, sector_t block)
 {
-	return __bread(sb->s_bdev, block, sb->s_blocksize);
+	return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP_MOVABLE);
+}
+
+static inline struct buffer_head *
+sb_bread_unmovable(struct super_block *sb, sector_t block)
+{
+	return __bread_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
 }
 
 static inline void
@@ -307,7 +314,7 @@ sb_breadahead(struct super_block *sb, se
 static inline struct buffer_head *
 sb_getblk(struct super_block *sb, sector_t block)
 {
-	return __getblk(sb->s_bdev, block, sb->s_blocksize);
+	return __getblk_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP_MOVABLE);
 }
 
 static inline struct buffer_head *
@@ -344,6 +351,36 @@ static inline void lock_buffer(struct bu
 		__lock_buffer(bh);
 }
 
+static inline struct buffer_head *getblk_unmovable(struct block_device *bdev,
+						   sector_t block,
+						   unsigned size)
+{
+	return __getblk_gfp(bdev, block, size, 0);
+}
+
+static inline struct buffer_head *__getblk(struct block_device *bdev,
+					   sector_t block,
+					   unsigned size)
+{
+	return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
+}
+
+/**
+ *  __bread() - reads a specified block and returns the bh
+ *  @bdev: the block_device to read from
+ *  @block: number of block
+ *  @size: size (in bytes) to read
+ *
+ *  Reads a specified block, and returns buffer head that contains it.
+ *  The page cache is allocated from movable area so that it can be migrated.
+ *  It returns NULL if the block was unreadable.
+ */
+static inline struct buffer_head *
+__bread(struct block_device *bdev, sector_t block, unsigned size)
+{
+	return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
+}
+
 extern int __set_page_dirty_buffers(struct page *page);
 
 #else /* CONFIG_BLOCK */
_

Patches currently in -mm which might be from gioh.kim@lge.com are

fsc-support-buffer-cache-allocations-with-gfp-modifiers.patch
ext4-use-non-movable-memory-for-the-ext4-superblock.patch
jbd-jbd2-use-non-movable-memory-for-the-jbd-superblock.patch
linux-next.patch

