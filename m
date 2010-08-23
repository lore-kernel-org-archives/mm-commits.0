From: akpm@linux-foundation.org
Subject: + writeback-remove-nonblocking-encountered_congestion-references.patch added to -mm tree
Date: Mon, 23 Aug 2010 16:35:28 -0700
Message-ID: <201008232335.o7NNZSkT021215@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab0HWXgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 19:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, axboe@kernel.dk, chris.mason@oracle.com, dhowells@redhat.com, hch@infradead.org, sage@newdream.net, sfrench@samba.org, tytso@mit.edu


The patch titled
     writeback: remove nonblocking/encountered_congestion references
has been added to the -mm tree.  Its filename is
     writeback-remove-nonblocking-encountered_congestion-references.patch

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
Subject: writeback: remove nonblocking/encountered_congestion references
From: Wu Fengguang <fengguang.wu@intel.com>

This removes more dead code that was somehow missed by commit 0d99519efef
(writeback: remove unused nonblocking and congestion checks).  There are
no behavior change except for the removal of two entries from one of the
ext4 tracing interface.

The nonblocking checks in ->writepages are no longer used because the
flusher now prefer to block on get_request_wait() than to skip inodes on
IO congestion.  The latter will lead to more seeky IO.

The nonblocking checks in ->writepage are no longer used because it's
redundant with the WB_SYNC_NONE check.

We no long set ->nonblocking in VM page out and page migration, because
a) it's effectively redundant with WB_SYNC_NONE in current code
b) it's old semantic of "Don't get stuck on request queues" is mis-behavior:
   that would skip some dirty inodes on congestion and page out others, which
   is unfair in terms of LRU age.

Inspired by Christoph Hellwig. Thanks!

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: David Howells <dhowells@redhat.com>
Cc: Sage Weil <sage@newdream.net>
Cc: Steve French <sfrench@samba.org>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/write.c                   |   19 +------------------
 fs/buffer.c                      |    2 +-
 fs/ceph/addr.c                   |    9 ---------
 fs/cifs/file.c                   |   11 -----------
 fs/gfs2/meta_io.c                |    2 +-
 fs/nfs/write.c                   |    4 +---
 fs/reiserfs/inode.c              |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c      |    3 +--
 include/trace/events/ext4.h      |    8 +++++---
 include/trace/events/writeback.h |    2 --
 mm/migrate.c                     |    1 -
 mm/vmscan.c                      |    1 -
 12 files changed, 11 insertions(+), 53 deletions(-)

diff -puN fs/afs/write.c~writeback-remove-nonblocking-encountered_congestion-references fs/afs/write.c
--- a/fs/afs/write.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/afs/write.c
@@ -438,7 +438,6 @@ no_more:
  */
 int afs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = page->mapping->backing_dev_info;
 	struct afs_writeback *wb;
 	int ret;
 
@@ -455,8 +454,6 @@ int afs_writepage(struct page *page, str
 	}
 
 	wbc->nr_to_write -= ret;
-	if (wbc->nonblocking && bdi_write_congested(bdi))
-		wbc->encountered_congestion = 1;
 
 	_leave(" = 0");
 	return 0;
@@ -469,7 +466,6 @@ static int afs_writepages_region(struct 
 				 struct writeback_control *wbc,
 				 pgoff_t index, pgoff_t end, pgoff_t *_next)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct afs_writeback *wb;
 	struct page *page;
 	int ret, n;
@@ -529,11 +525,6 @@ static int afs_writepages_region(struct 
 
 		wbc->nr_to_write -= ret;
 
-		if (wbc->nonblocking && bdi_write_congested(bdi)) {
-			wbc->encountered_congestion = 1;
-			break;
-		}
-
 		cond_resched();
 	} while (index < end && wbc->nr_to_write > 0);
 
@@ -548,24 +539,16 @@ static int afs_writepages_region(struct 
 int afs_writepages(struct address_space *mapping,
 		   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	pgoff_t start, end, next;
 	int ret;
 
 	_enter("");
 
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		_leave(" = 0 [congest]");
-		return 0;
-	}
-
 	if (wbc->range_cyclic) {
 		start = mapping->writeback_index;
 		end = -1;
 		ret = afs_writepages_region(mapping, wbc, start, end, &next);
-		if (start > 0 && wbc->nr_to_write > 0 && ret == 0 &&
-		    !(wbc->nonblocking && wbc->encountered_congestion))
+		if (start > 0 && wbc->nr_to_write > 0 && ret == 0)
 			ret = afs_writepages_region(mapping, wbc, 0, start,
 						    &next);
 		mapping->writeback_index = next;
diff -puN fs/buffer.c~writeback-remove-nonblocking-encountered_congestion-references fs/buffer.c
--- a/fs/buffer.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/buffer.c
@@ -1706,7 +1706,7 @@ static int __block_write_full_page(struc
 		 * and kswapd activity, but those code paths have their own
 		 * higher-level throttling.
 		 */
-		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
+		if (wbc->sync_mode != WB_SYNC_NONE) {
 			lock_buffer(bh);
 		} else if (!trylock_buffer(bh)) {
 			redirty_page_for_writepage(wbc, page);
diff -puN fs/ceph/addr.c~writeback-remove-nonblocking-encountered_congestion-references fs/ceph/addr.c
--- a/fs/ceph/addr.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/ceph/addr.c
@@ -591,7 +591,6 @@ static int ceph_writepages_start(struct 
 				 struct writeback_control *wbc)
 {
 	struct inode *inode = mapping->host;
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc;
 	pgoff_t index, start, end;
@@ -633,13 +632,6 @@ static int ceph_writepages_start(struct 
 
 	pagevec_init(&pvec, 0);
 
-	/* ?? */
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		dout(" writepages congested\n");
-		wbc->encountered_congestion = 1;
-		goto out_final;
-	}
-
 	/* where to start/end? */
 	if (wbc->range_cyclic) {
 		start = mapping->writeback_index; /* Start from prev offset */
@@ -884,7 +876,6 @@ out:
 		rc = 0;  /* vfs expects us to return 0 */
 	ceph_put_snap_context(snapc);
 	dout("writepages done, rc = %d\n", rc);
-out_final:
 	return rc;
 }
 
diff -puN fs/cifs/file.c~writeback-remove-nonblocking-encountered_congestion-references fs/cifs/file.c
--- a/fs/cifs/file.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/cifs/file.c
@@ -1337,7 +1337,6 @@ static int cifs_partialpagewrite(struct 
 static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	unsigned int bytes_to_write;
 	unsigned int bytes_written;
 	struct cifs_sb_info *cifs_sb;
@@ -1379,16 +1378,6 @@ static int cifs_writepages(struct addres
 		return generic_writepages(mapping, wbc);
 
 
-	/*
-	 * BB: Is this meaningful for a non-block-device file system?
-	 * If it is, we should test it again after we do I/O
-	 */
-	if (wbc->nonblocking && bdi_write_congested(bdi)) {
-		wbc->encountered_congestion = 1;
-		kfree(iov);
-		return 0;
-	}
-
 	xid = GetXid();
 
 	pagevec_init(&pvec, 0);
diff -puN fs/gfs2/meta_io.c~writeback-remove-nonblocking-encountered_congestion-references fs/gfs2/meta_io.c
--- a/fs/gfs2/meta_io.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/gfs2/meta_io.c
@@ -55,7 +55,7 @@ static int gfs2_aspace_writepage(struct 
 		 * activity, but those code paths have their own higher-level
 		 * throttling.
 		 */
-		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
+		if (wbc->sync_mode != WB_SYNC_NONE) {
 			lock_buffer(bh);
 		} else if (!trylock_buffer(bh)) {
 			redirty_page_for_writepage(wbc, page);
diff -puN fs/nfs/write.c~writeback-remove-nonblocking-encountered_congestion-references fs/nfs/write.c
--- a/fs/nfs/write.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/nfs/write.c
@@ -292,9 +292,7 @@ static int nfs_do_writepage(struct page 
 	nfs_add_stats(inode, NFSIOS_WRITEPAGES, 1);
 
 	nfs_pageio_cond_complete(pgio, page->index);
-	ret = nfs_page_async_flush(pgio, page,
-			wbc->sync_mode == WB_SYNC_NONE ||
-			wbc->nonblocking != 0);
+	ret = nfs_page_async_flush(pgio, page, wbc->sync_mode == WB_SYNC_NONE);
 	if (ret == -EAGAIN) {
 		redirty_page_for_writepage(wbc, page);
 		ret = 0;
diff -puN fs/reiserfs/inode.c~writeback-remove-nonblocking-encountered_congestion-references fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/reiserfs/inode.c
@@ -2438,7 +2438,7 @@ static int reiserfs_write_full_page(stru
 		/* from this point on, we know the buffer is mapped to a
 		 * real block and not a direct item
 		 */
-		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
+		if (wbc->sync_mode != WB_SYNC_NONE) {
 			lock_buffer(bh);
 		} else {
 			if (!trylock_buffer(bh)) {
diff -puN fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-nonblocking-encountered_congestion-references fs/xfs/linux-2.6/xfs_aops.c
--- a/fs/xfs/linux-2.6/xfs_aops.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/fs/xfs/linux-2.6/xfs_aops.c
@@ -1139,8 +1139,7 @@ xfs_vm_writepage(
 				type = IO_DELAY;
 				flags = BMAPI_ALLOCATE;
 
-				if (wbc->sync_mode == WB_SYNC_NONE &&
-				    wbc->nonblocking)
+				if (wbc->sync_mode == WB_SYNC_NONE)
 					flags |= BMAPI_TRYLOCK;
 			}
 
diff -puN include/trace/events/ext4.h~writeback-remove-nonblocking-encountered_congestion-references include/trace/events/ext4.h
--- a/include/trace/events/ext4.h~writeback-remove-nonblocking-encountered_congestion-references
+++ a/include/trace/events/ext4.h
@@ -242,18 +242,20 @@ TRACE_EVENT(ext4_da_writepages,
 		__entry->pages_skipped	= wbc->pages_skipped;
 		__entry->range_start	= wbc->range_start;
 		__entry->range_end	= wbc->range_end;
-		__entry->nonblocking	= wbc->nonblocking;
 		__entry->for_kupdate	= wbc->for_kupdate;
 		__entry->for_reclaim	= wbc->for_reclaim;
 		__entry->range_cyclic	= wbc->range_cyclic;
 		__entry->writeback_index = inode->i_mapping->writeback_index;
 	),
 
-	TP_printk("dev %s ino %lu nr_to_write %ld pages_skipped %ld range_start %llu range_end %llu nonblocking %d for_kupdate %d for_reclaim %d range_cyclic %d writeback_index %lu",
+	TP_printk("dev %s ino %lu nr_to_write %ld pages_skipped %ld "
+		  "range_start %llu range_end %llu "
+		  "for_kupdate %d for_reclaim %d "
+		  "range_cyclic %d writeback_index %lu",
 		  jbd2_dev_to_name(__entry->dev),
 		  (unsigned long) __entry->ino, __entry->nr_to_write,
 		  __entry->pages_skipped, __entry->range_start,
-		  __entry->range_end, __entry->nonblocking,
+		  __entry->range_end,
 		  __entry->for_kupdate, __entry->for_reclaim,
 		  __entry->range_cyclic,
 		  (unsigned long) __entry->writeback_index)
diff -puN include/trace/events/writeback.h~writeback-remove-nonblocking-encountered_congestion-references include/trace/events/writeback.h
--- a/include/trace/events/writeback.h~writeback-remove-nonblocking-encountered_congestion-references
+++ a/include/trace/events/writeback.h
@@ -96,8 +96,6 @@ DECLARE_EVENT_CLASS(wbc_class,
 		__field(long, nr_to_write)
 		__field(long, pages_skipped)
 		__field(int, sync_mode)
-		__field(int, nonblocking)
-		__field(int, encountered_congestion)
 		__field(int, for_kupdate)
 		__field(int, for_background)
 		__field(int, for_reclaim)
diff -puN mm/migrate.c~writeback-remove-nonblocking-encountered_congestion-references mm/migrate.c
--- a/mm/migrate.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/mm/migrate.c
@@ -431,7 +431,6 @@ static int writeout(struct address_space
 		.nr_to_write = 1,
 		.range_start = 0,
 		.range_end = LLONG_MAX,
-		.nonblocking = 1,
 		.for_reclaim = 1
 	};
 	int rc;
diff -puN mm/vmscan.c~writeback-remove-nonblocking-encountered_congestion-references mm/vmscan.c
--- a/mm/vmscan.c~writeback-remove-nonblocking-encountered_congestion-references
+++ a/mm/vmscan.c
@@ -391,7 +391,6 @@ static pageout_t pageout(struct page *pa
 			.nr_to_write = SWAP_CLUSTER_MAX,
 			.range_start = 0,
 			.range_end = LLONG_MAX,
-			.nonblocking = 1,
 			.for_reclaim = 1,
 		};
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

fs-inodec-work-around-bug.patch
proc-export-uncached-bit-properly-in-proc-kpageflags.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
documentation-filesystems-proctxt-improve-smaps-field-documentation.patch
mm-smaps-export-mlock-information.patch
writeback-remove-nonblocking-encountered_congestion-references.patch
vfs-add-super-operation-writeback_inodes.patch

