From: akpm@linux-foundation.org
Subject: [merged] mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:17 -0800
Message-ID: <20130222203918.0CF865A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50239 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab3BVUjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:19 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103789ggi.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darrick.wong@oracle.com, adrian.hunter@intel.com, axboe@kernel.dk, dedekind1@gmail.com, ericvh@gmail.com, jack@suse.cz, jlbec@evilplan.org, lucho@ionkov.net, luto@amacapital.net, mfasheh@suse.com, rminnich@sandia.gov, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: only enforce stable page writes if the backing device requires it
has been removed from the -mm tree.  Its filename was
     mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: mm: only enforce stable page writes if the backing device requires it

Create a helper function to check if a backing device requires stable page
writes and, if so, performs the necessary wait.  Then, make it so that all
points in the memory manager that handle making pages writable use the
helper function.  This should provide stable page write support to most
filesystems, while eliminating unnecessary waiting for devices that don't
require the feature.

Before this patchset, all filesystems would block, regardless of whether
or not it was necessary.  ext3 would wait, but still generate occasional
checksum errors.  The network filesystems were left to do their own thing,
so they'd wait too.

After this patchset, all the disk filesystems except ext3 and btrfs will
wait only if the hardware requires it.  ext3 (if necessary) snapshots
pages instead of blocking, and btrfs provides its own bdi so the mm will
never wait.  Network filesystems haven't been touched, so either they
provide their own stable page guarantees or they don't block at all.  The
blocking behavior is back to what it was before 3.0 if you don't have a
disk requiring stable page writes.

Here's the result of using dbench to test latency on ext2:

3.8.0-rc3:
 Operation      Count    AvgLat    MaxLat
 ----------------------------------------
 WriteX        109347     0.028    59.817
 ReadX         347180     0.004     3.391
 Flush          15514    29.828   287.283

Throughput 57.429 MB/sec  4 clients  4 procs  max_latency=287.290 ms

3.8.0-rc3 + patches:
 WriteX        105556     0.029     4.273
 ReadX         335004     0.005     4.112
 Flush          14982    30.540   298.634

Throughput 55.4496 MB/sec  4 clients  4 procs  max_latency=298.650 ms

As you can see, the maximum write latency drops considerably with this
patch enabled.  The other filesystems (ext3/ext4/xfs/btrfs) behave
similarly, but see the cover letter for those results.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Steven Whitehouse <swhiteho@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c             |    2 +-
 fs/ext4/inode.c         |    2 +-
 fs/gfs2/file.c          |    2 +-
 fs/nilfs2/file.c        |    2 +-
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |    3 ++-
 mm/page-writeback.c     |   20 ++++++++++++++++++++
 7 files changed, 27 insertions(+), 5 deletions(-)

diff -puN fs/buffer.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it fs/buffer.c
--- a/fs/buffer.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it
+++ a/fs/buffer.c
@@ -2359,7 +2359,7 @@ int __block_page_mkwrite(struct vm_area_
 	if (unlikely(ret < 0))
 		goto out_unlock;
 	set_page_dirty(page);
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
 	return 0;
 out_unlock:
 	unlock_page(page);
diff -puN fs/ext4/inode.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it fs/ext4/inode.c
--- a/fs/ext4/inode.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it
+++ a/fs/ext4/inode.c
@@ -4968,7 +4968,7 @@ int ext4_page_mkwrite(struct vm_area_str
 					    0, len, NULL,
 					    ext4_bh_unmapped)) {
 			/* Wait so that we don't change page under IO */
-			wait_on_page_writeback(page);
+			wait_for_stable_page(page);
 			ret = VM_FAULT_LOCKED;
 			goto out;
 		}
diff -puN fs/gfs2/file.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it fs/gfs2/file.c
--- a/fs/gfs2/file.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it
+++ a/fs/gfs2/file.c
@@ -483,7 +483,7 @@ out:
 	gfs2_holder_uninit(&gh);
 	if (ret == 0) {
 		set_page_dirty(page);
-		wait_on_page_writeback(page);
+		wait_for_stable_page(page);
 	}
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);
diff -puN fs/nilfs2/file.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it
+++ a/fs/nilfs2/file.c
@@ -126,7 +126,7 @@ static int nilfs_page_mkwrite(struct vm_
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
  out:
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);
diff -puN include/linux/pagemap.h~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it
+++ a/include/linux/pagemap.h
@@ -414,6 +414,7 @@ static inline void wait_on_page_writebac
 }
 
 extern void end_page_writeback(struct page *page);
+void wait_for_stable_page(struct page *page);
 
 /*
  * Add an arbitrary waiter to a page's wait queue
diff -puN mm/filemap.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it mm/filemap.c
--- a/mm/filemap.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it
+++ a/mm/filemap.c
@@ -1728,6 +1728,7 @@ int filemap_page_mkwrite(struct vm_area_
 	 * see the dirty page and writeprotect it again.
 	 */
 	set_page_dirty(page);
+	wait_for_stable_page(page);
 out:
 	sb_end_pagefault(inode->i_sb);
 	return ret;
@@ -2274,7 +2275,7 @@ repeat:
 		return NULL;
 	}
 found:
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);
diff -puN mm/page-writeback.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it mm/page-writeback.c
--- a/mm/page-writeback.c~mm-only-enforce-stable-page-writes-if-the-backing-device-requires-it
+++ a/mm/page-writeback.c
@@ -2290,3 +2290,23 @@ int mapping_tagged(struct address_space 
 	return radix_tree_tagged(&mapping->page_tree, tag);
 }
 EXPORT_SYMBOL(mapping_tagged);
+
+/**
+ * wait_for_stable_page() - wait for writeback to finish, if necessary.
+ * @page:	The page to wait on.
+ *
+ * This function determines if the given page is related to a backing device
+ * that requires page contents to be held stable during writeback.  If so, then
+ * it will wait for any pending writeback to complete.
+ */
+void wait_for_stable_page(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+
+	if (!bdi_cap_stable_pages_required(bdi))
+		return;
+
+	wait_on_page_writeback(page);
+}
+EXPORT_SYMBOL_GPL(wait_for_stable_page);
_

Patches currently in -mm which might be from darrick.wong@oracle.com are

origin.patch
linux-next.patch

