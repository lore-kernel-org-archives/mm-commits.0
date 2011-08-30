From: akpm@linux-foundation.org
Subject: + dio-inline-the-complete-submission-path-v2.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:53:33 -0700
Message-ID: <201108302353.p7UNrXUF026553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759Ab1H3XyL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:54:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: inline the complete submission path
has been added to the -mm tree.  Its filename is
     dio-inline-the-complete-submission-path-v2.patch

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
Subject: dio: inline the complete submission path
From: Andi Kleen <ak@linux.intel.com>

Add inlines to all the submission path functions.  While this increases
code size it also gives gcc a lot of optimization opportunities in this
critical hotpath.

In particular -- together with some other changes -- this allows gcc to
get rid of the unnecessary clearing of sdio at the beginning and optimize
the messy parameter passing.  Any non inlining of a function which takes a
sdio parameter would break this optimization because they cannot be done
if the address of a structure is taken.

Note that benefits are only seen with CONFIG_OPTIMIZE_INLINING and
CONFIG_CC_OPTIMIZE_FOR_SIZE both set to off.

This gives about 2.2% improvement on a large database benchmark with a
high IOPS rate.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff -puN fs/direct-io.c~dio-inline-the-complete-submission-path-v2 fs/direct-io.c
--- a/fs/direct-io.c~dio-inline-the-complete-submission-path-v2
+++ a/fs/direct-io.c
@@ -199,7 +199,7 @@ static inline unsigned dio_pages_present
 /*
  * Go grab and pin some userspace pages.   Typically we'll get 64 at a time.
  */
-static int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 	int nr_pages;
@@ -245,7 +245,7 @@ out:
  * decent number of pages, less frequently.  To provide nicer use of the
  * L1 cache.
  */
-static struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
+static inline struct page *dio_get_page(struct dio *dio, struct dio_submit *sdio)
 {
 	if (dio_pages_present(dio, sdio) == 0) {
 		int ret;
@@ -376,7 +376,7 @@ void dio_end_io(struct bio *bio, int err
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
-static void
+static void inline
 dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	      struct block_device *bdev,
 	      sector_t first_sector, int nr_vecs)
@@ -407,7 +407,7 @@ dio_bio_alloc(struct dio *dio, struct di
  *
  * bios hold a dio reference between submit_bio and ->end_io.
  */
-static void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
+static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 {
 	struct bio *bio = sdio->bio;
 	unsigned long flags;
@@ -435,7 +435,7 @@ static void dio_bio_submit(struct dio *d
 /*
  * Release any resources in case of a failure
  */
-static void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
+static inline void dio_cleanup(struct dio *dio, struct dio_submit *sdio)
 {
 	while (dio_pages_present(dio, sdio))
 		page_cache_release(dio_get_page(dio, sdio));
@@ -528,7 +528,7 @@ static void dio_await_completion(struct 
  *
  * This also helps to limit the peak amount of pinned userspace memory.
  */
-static int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_reap(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret = 0;
 
@@ -631,7 +631,7 @@ static int get_more_blocks(struct dio *d
 /*
  * There is no bio.  Make one now.
  */
-static int dio_new_bio(struct dio *dio, struct dio_submit *sdio,
+static inline int dio_new_bio(struct dio *dio, struct dio_submit *sdio, 
 		       sector_t start_sector, struct buffer_head *map_bh)
 {
 	sector_t sector;
@@ -657,7 +657,7 @@ out:
  *
  * Return zero on success.  Non-zero means the caller needs to start a new BIO.
  */
-static int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
+static inline int dio_bio_add_page(struct dio *dio, struct dio_submit *sdio)
 {
 	int ret;
 
@@ -689,8 +689,8 @@ static int dio_bio_add_page(struct dio *
  * The caller of this function is responsible for removing cur_page from the
  * dio, and for dropping the refcount which came from that presence.
  */
-static int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
-			     struct buffer_head *map_bh)
+static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
+	  		    	    struct buffer_head *map_bh)
 {
 	int ret = 0;
 
@@ -759,7 +759,7 @@ out:
  * If that doesn't work out then we put the old page into the bio and add this
  * page to the dio instead.
  */
-static int
+static inline int
 submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 		    unsigned offset, unsigned len, sector_t blocknr,
 		    struct buffer_head *map_bh)
@@ -842,7 +842,7 @@ static void clean_blockdev_aliases(struc
  * `end' is zero if we're doing the start of the IO, 1 at the end of the
  * IO.
  */
-static void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,
+static inline void dio_zero_block(struct dio *dio, struct dio_submit *sdio, int end,
 			   struct buffer_head *map_bh)
 {
 	unsigned dio_blocks_per_fs_block;
@@ -1039,7 +1039,7 @@ out:
 	return ret;
 }
 
-static ssize_t
+static inline ssize_t
 direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode, 
 	const struct iovec *iov, loff_t offset, unsigned long nr_segs, 
 	unsigned blkbits, get_block_t get_block, dio_iodone_t end_io,
@@ -1213,6 +1213,11 @@ direct_io_worker(int rw, struct kiocb *i
  * expected that filesystem provide exclusion between new direct I/O
  * and truncates.  For DIO_LOCKING filesystems this is done by i_mutex,
  * but other filesystems need to take care of this on their own.
+ * 
+ * NOTE: if you pass "sdio" to anything by pointer make sure that function
+ * is always inlined. Otherwise gcc is unable to split the structure into
+ * individual fields and will generate much worse code. 
+ * This is important for the whole file.
  */
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
_

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-fix-a-wrong-comment.patch
dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch
dio-use-a-slab-cache-for-struct-dio.patch
dio-separate-map_bh-from-dio-v2.patch
dio-inline-the-complete-submission-path-v2.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-remove-unnecessary-dio-argument-from-dio_pages_present.patch
dio-remove-unused-dio-parameter-from-dio_bio_add_page.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch

