From: akpm@linux-foundation.org
Subject: - warning-fix-unsigned-signed.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:43:52 -0800
Message-ID: <200702122243.l1CMhq6L013535@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44897 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250AbXBLWny (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:43:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kvarsin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     warning fix: unsigned->signed
has been removed from the -mm tree.  Its filename was
     warning-fix-unsigned-signed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: warning fix: unsigned->signed
From: "Tomasz Kvarsin" <kvarsin@gmail.com>

While compiling my code with -Wconversion using gcc-trunk, I always get a
bunch of warrning from headers, here is fix for them:

__getblk is alawys called with unsigned argument,
but it takes signed, the same story with __bread,__breadahead and so on.

Signed-off-by: Tomasz Kvarsin
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   12 ++++++------
 include/linux/buffer_head.h |   10 ++++++----
 2 files changed, 12 insertions(+), 10 deletions(-)

diff -puN fs/buffer.c~warning-fix-unsigned-signed fs/buffer.c
--- a/fs/buffer.c~warning-fix-unsigned-signed
+++ a/fs/buffer.c
@@ -1283,11 +1283,11 @@ static void bh_lru_install(struct buffer
  * Look up the bh in this cpu's LRU.  If it's there, move it to the head.
  */
 static struct buffer_head *
-lookup_bh_lru(struct block_device *bdev, sector_t block, int size)
+lookup_bh_lru(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *ret = NULL;
 	struct bh_lru *lru;
-	int i;
+	unsigned int i;
 
 	check_irqs_on();
 	bh_lru_lock();
@@ -1319,7 +1319,7 @@ lookup_bh_lru(struct block_device *bdev,
  * NULL
  */
 struct buffer_head *
-__find_get_block(struct block_device *bdev, sector_t block, int size)
+__find_get_block(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = lookup_bh_lru(bdev, block, size);
 
@@ -1347,7 +1347,7 @@ EXPORT_SYMBOL(__find_get_block);
  * attempt is failing.  FIXME, perhaps?
  */
 struct buffer_head *
-__getblk(struct block_device *bdev, sector_t block, int size)
+__getblk(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __find_get_block(bdev, block, size);
 
@@ -1361,7 +1361,7 @@ EXPORT_SYMBOL(__getblk);
 /*
  * Do async read-ahead on a buffer..
  */
-void __breadahead(struct block_device *bdev, sector_t block, int size)
+void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
@@ -1381,7 +1381,7 @@ EXPORT_SYMBOL(__breadahead);
  *  It returns NULL if the block was unreadable.
  */
 struct buffer_head *
-__bread(struct block_device *bdev, sector_t block, int size)
+__bread(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 
diff -puN include/linux/buffer_head.h~warning-fix-unsigned-signed include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~warning-fix-unsigned-signed
+++ a/include/linux/buffer_head.h
@@ -174,12 +174,14 @@ struct super_block *freeze_bdev(struct b
 void thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
-struct buffer_head *__find_get_block(struct block_device *, sector_t, int);
-struct buffer_head * __getblk(struct block_device *, sector_t, int);
+struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
+			unsigned size);
+struct buffer_head *__getblk(struct block_device *bdev, sector_t block,
+			unsigned size);
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
-void __breadahead(struct block_device *, sector_t block, int size);
-struct buffer_head *__bread(struct block_device *, sector_t block, int size);
+void __breadahead(struct block_device *, sector_t block, unsigned int size);
+struct buffer_head *__bread(struct block_device *, sector_t block, unsigned size);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
 void FASTCALL(unlock_buffer(struct buffer_head *bh));
_

Patches currently in -mm which might be from kvarsin@gmail.com are

origin.patch
