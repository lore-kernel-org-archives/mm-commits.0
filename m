From: akpm@linux-foundation.org
Subject: + mm-fs-obey-gfp_mapping-for-add_to_page_cache.patch added to -mm tree
Date: Tue, 29 Sep 2015 15:03:01 -0700
Message-ID: <560b0a95.x9jKu/0PjbeRGGBC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbbI2WDC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Sep 2015 18:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, andreas.dilger@intel.com, david@fromorbit.com, hch@lst.de, ming.lei@canonical.com, oleg.drokin@intel.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fs: obey gfp_mapping for add_to_page_cache()
has been added to the -mm tree.  Its filename is
     mm-fs-obey-gfp_mapping-for-add_to_page_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fs-obey-gfp_mapping-for-add_to_page_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fs-obey-gfp_mapping-for-add_to_page_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, fs: obey gfp_mapping for add_to_page_cache()

6afdb859b710 ("mm: do not ignore mapping_gfp_mask in page cache allocation
paths) has caught some users of hardcoded GFP_KERNEL used in the page
cache allocation paths.  This, however, wasn't complete and there were
others which went unnoticed.

Dave Chinner has reported the following deadlock for xfs on loop device:
: With the recent merge of the loop device changes, I'm now seeing
: XFS deadlock on my single CPU, 1GB RAM VM running xfs/073.
:
: The deadlocked is as follows:
:
: kloopd1: loop_queue_read_work
:       xfs_file_iter_read
:       lock XFS inode XFS_IOLOCK_SHARED (on image file)
:       page cache read (GFP_KERNEL)
:       radix tree alloc
:       memory reclaim
:       reclaim XFS inodes
:       log force to unpin inodes
:       <wait for log IO completion>
:
: xfs-cil/loop1: <does log force IO work>
:       xlog_cil_push
:       xlog_write
:       <loop issuing log writes>
:               xlog_state_get_iclog_space()
:               <blocks due to all log buffers under write io>
:               <waits for IO completion>
:
: kloopd1: loop_queue_write_work
:       xfs_file_write_iter
:       lock XFS inode XFS_IOLOCK_EXCL (on image file)
:       <wait for inode to be unlocked>
:
: i.e. the kloopd, with it's split read and write work queues, has
: introduced a dependency through memory reclaim. i.e. that writes
: need to be able to progress for reads make progress.
:
: The problem, fundamentally, is that mpage_readpages() does a
: GFP_KERNEL allocation, rather than paying attention to the inode's
: mapping gfp mask, which is set to GFP_NOFS.
:
: The didn't used to happen, because the loop device used to issue
: reads through the splice path and that does:
:
:       error = add_to_page_cache_lru(page, mapping, index,
:                       GFP_KERNEL & mapping_gfp_mask(mapping));

This has changed by aa4d86163e4 ("block: loop: switch to VFS ITER_BVEC").

This patch changes mpage_readpage{s} to follow gfp mask set for the
mapping.  There are, however, other places which are doing basically the
same.

lustre:ll_dir_filler is doing GFP_KERNEL from the function which
apparently uses GFP_NOFS for other allocations so let's make this
consistent.

cifs:readpages_get_pages is called from cifs_readpages and
__cifs_readpages_from_fscache called from the same path obeys mapping
gfp.

ramfs_nommu_expand_for_mapping is hardcoding GFP_KERNEL as well
regardless it uses mapping_gfp_mask for the page allocation.

ext4_mpage_readpages is the called from the page cache allocation path
same as read_pages and read_cache_pages

As I've noticed in my previous post I cannot say I would be happy about
sprinkling mapping_gfp_mask all over the place and it sounds like we
should drop gfp_mask argument altogether and use it internally in
__add_to_page_cache_locked that would require all the filesystems to use
mapping gfp consistently which I am not sure is the case here.  From a
quick glance it seems that some file system use it all the time while
others are selective.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/dir.c |    2 +-
 fs/cifs/file.c                            |    6 +++---
 fs/ext4/readpage.c                        |    3 ++-
 fs/mpage.c                                |   15 +++++++++------
 fs/ramfs/file-nommu.c                     |    5 +++--
 mm/readahead.c                            |    6 ++++--
 6 files changed, 22 insertions(+), 15 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/dir.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache drivers/staging/lustre/lustre/llite/dir.c
--- a/drivers/staging/lustre/lustre/llite/dir.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache
+++ a/drivers/staging/lustre/lustre/llite/dir.c
@@ -224,7 +224,7 @@ static int ll_dir_filler(void *_hash, st
 
 		prefetchw(&page->flags);
 		ret = add_to_page_cache_lru(page, inode->i_mapping, offset,
-					    GFP_KERNEL);
+					    GFP_NOFS);
 		if (ret == 0) {
 			unlock_page(page);
 		} else {
diff -puN fs/cifs/file.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache fs/cifs/file.c
--- a/fs/cifs/file.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache
+++ a/fs/cifs/file.c
@@ -3380,6 +3380,7 @@ readpages_get_pages(struct address_space
 	struct page *page, *tpage;
 	unsigned int expected_index;
 	int rc;
+	gfp_t gfp = GFP_KERNEL & mapping_gfp_mask(mapping);
 
 	INIT_LIST_HEAD(tmplist);
 
@@ -3392,7 +3393,7 @@ readpages_get_pages(struct address_space
 	 */
 	__set_page_locked(page);
 	rc = add_to_page_cache_locked(page, mapping,
-				      page->index, GFP_KERNEL);
+				      page->index, gfp);
 
 	/* give up if we can't stick it in the cache */
 	if (rc) {
@@ -3418,8 +3419,7 @@ readpages_get_pages(struct address_space
 			break;
 
 		__set_page_locked(page);
-		if (add_to_page_cache_locked(page, mapping, page->index,
-								GFP_KERNEL)) {
+		if (add_to_page_cache_locked(page, mapping, page->index, gfp)) {
 			__clear_page_locked(page);
 			break;
 		}
diff -puN fs/ext4/readpage.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache fs/ext4/readpage.c
--- a/fs/ext4/readpage.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache
+++ a/fs/ext4/readpage.c
@@ -166,7 +166,8 @@ int ext4_mpage_readpages(struct address_
 			page = list_entry(pages->prev, struct page, lru);
 			list_del(&page->lru);
 			if (add_to_page_cache_lru(page, mapping,
-						  page->index, GFP_KERNEL))
+						  page->index,
+						  GFP_KERNEL & mapping_gfp_mask(mapping)))
 				goto next_page;
 		}
 
diff -puN fs/mpage.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache fs/mpage.c
--- a/fs/mpage.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache
+++ a/fs/mpage.c
@@ -139,7 +139,8 @@ map_buffer_to_page(struct page *page, st
 static struct bio *
 do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 		sector_t *last_block_in_bio, struct buffer_head *map_bh,
-		unsigned long *first_logical_block, get_block_t get_block)
+		unsigned long *first_logical_block, get_block_t get_block,
+		gfp_t gfp)
 {
 	struct inode *inode = page->mapping->host;
 	const unsigned blkbits = inode->i_blkbits;
@@ -277,8 +278,7 @@ alloc_new:
 				goto out;
 		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
-				min_t(int, nr_pages, BIO_MAX_PAGES),
-				GFP_KERNEL);
+				min_t(int, nr_pages, BIO_MAX_PAGES), gfp);
 		if (bio == NULL)
 			goto confused;
 	}
@@ -361,6 +361,7 @@ mpage_readpages(struct address_space *ma
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
+	gfp_t gfp = GFP_KERNEL & mapping_gfp_mask(mapping);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
@@ -370,12 +371,13 @@ mpage_readpages(struct address_space *ma
 		prefetchw(&page->flags);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
+					page->index,
+					gfp)) {
 			bio = do_mpage_readpage(bio, page,
 					nr_pages - page_idx,
 					&last_block_in_bio, &map_bh,
 					&first_logical_block,
-					get_block);
+					get_block, gfp);
 		}
 		page_cache_release(page);
 	}
@@ -395,11 +397,12 @@ int mpage_readpage(struct page *page, ge
 	sector_t last_block_in_bio = 0;
 	struct buffer_head map_bh;
 	unsigned long first_logical_block = 0;
+	gfp_t gfp = mapping_gfp_mask(page->mapping);
 
 	map_bh.b_state = 0;
 	map_bh.b_size = 0;
 	bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
-			&map_bh, &first_logical_block, get_block);
+			&map_bh, &first_logical_block, get_block, gfp);
 	if (bio)
 		mpage_bio_submit(READ, bio);
 	return 0;
diff -puN fs/ramfs/file-nommu.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache
+++ a/fs/ramfs/file-nommu.c
@@ -70,6 +70,7 @@ int ramfs_nommu_expand_for_mapping(struc
 	unsigned order;
 	void *data;
 	int ret;
+	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
 
 	/* make various checks */
 	order = get_order(newsize);
@@ -84,7 +85,7 @@ int ramfs_nommu_expand_for_mapping(struc
 
 	/* allocate enough contiguous pages to be able to satisfy the
 	 * request */
-	pages = alloc_pages(mapping_gfp_mask(inode->i_mapping), order);
+	pages = alloc_pages(gfp, order);
 	if (!pages)
 		return -ENOMEM;
 
@@ -108,7 +109,7 @@ int ramfs_nommu_expand_for_mapping(struc
 		struct page *page = pages + loop;
 
 		ret = add_to_page_cache_lru(page, inode->i_mapping, loop,
-					GFP_KERNEL);
+					gfp);
 		if (ret < 0)
 			goto add_error;
 
diff -puN mm/readahead.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache mm/readahead.c
--- a/mm/readahead.c~mm-fs-obey-gfp_mapping-for-add_to_page_cache
+++ a/mm/readahead.c
@@ -90,7 +90,8 @@ int read_cache_pages(struct address_spac
 		page = list_to_page(pages);
 		list_del(&page->lru);
 		if (add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
+					page->index,
+					GFP_KERNEL & mapping_gfp_mask(mapping))) {
 			read_cache_pages_invalidate_page(mapping, page);
 			continue;
 		}
@@ -128,7 +129,8 @@ static int read_pages(struct address_spa
 		struct page *page = list_to_page(pages);
 		list_del(&page->lru);
 		if (!add_to_page_cache_lru(page, mapping,
-					page->index, GFP_KERNEL)) {
+					page->index,
+					GFP_KERNEL & mapping_gfp_mask(mapping))) {
 			mapping->a_ops->readpage(filp, page);
 		}
 		page_cache_release(page);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-fs-obey-gfp_mapping-for-add_to_page_cache.patch

