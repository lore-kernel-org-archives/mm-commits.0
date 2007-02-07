From: akpm@linux-foundation.org
Subject: + warning-fix-unsigned-signed.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:46:33 -0800
Message-ID: <200702070046.l170kXRV002257@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57050 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbXBGAqg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kvarsin@gmail.com


The patch titled
     warning fix: unsigned->signed
has been added to the -mm tree.  Its filename is
     warning-fix-unsigned-signed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: warning fix: unsigned->signed
From: "Tomasz Kvarsin" <kvarsin@gmail.com>

While compiling my code with -W, I always get bunch of warrning from
headers, here is fix for them:

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
@@ -1276,11 +1276,11 @@ static void bh_lru_install(struct buffer
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
@@ -1312,7 +1312,7 @@ lookup_bh_lru(struct block_device *bdev,
  * NULL
  */
 struct buffer_head *
-__find_get_block(struct block_device *bdev, sector_t block, int size)
+__find_get_block(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = lookup_bh_lru(bdev, block, size);
 
@@ -1340,7 +1340,7 @@ EXPORT_SYMBOL(__find_get_block);
  * attempt is failing.  FIXME, perhaps?
  */
 struct buffer_head *
-__getblk(struct block_device *bdev, sector_t block, int size)
+__getblk(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __find_get_block(bdev, block, size);
 
@@ -1354,7 +1354,7 @@ EXPORT_SYMBOL(__getblk);
 /*
  * Do async read-ahead on a buffer..
  */
-void __breadahead(struct block_device *bdev, sector_t block, int size)
+void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
@@ -1374,7 +1374,7 @@ EXPORT_SYMBOL(__breadahead);
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

warning-fix-unsigned-signed.patch
