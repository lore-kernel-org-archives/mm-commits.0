From: akpm@linux-foundation.org
Subject: [merged]
 fs-fix-data-invalidation-in-the-cleancache-during-direct-io.patch removed
 from -mm tree
Date: Thu, 04 May 2017 12:13:27 -0700
Message-ID: <20170504191327.0n_V2vN7X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51942 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756179AbdEDTN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:13:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, axboe@kernel.dk, hannes@cmpxchg.org, hch@lst.de, jack@suse.cz, konrad.wilk@oracle.com, kuznet@virtuozzo.com, mm-commits@vger.kernel.org, n.borisov.lkml@gmail.com, ross.zwisler@linux.intel.com, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs: fix data invalidation in the cleancache during direct IO
has been removed from the -mm tree.  Its filename was
     fs-fix-data-invalidation-in-the-cleancache-during-direct-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: fs: fix data invalidation in the cleancache during direct IO

Patch series "Properly invalidate data in the cleancache", v2.

We've noticed that after direct IO write, buffered read sometimes gets
stale data which is coming from the cleancache.  The reason for this is
that some direct write hooks call call invalidate_inode_pages2[_range]()
conditionally iff mapping->nrpages is not zero, so we may not invalidate
data in the cleancache.

Another odd thing is that we check only for ->nrpages and don't check for
->nrexceptional, but invalidate_inode_pages2[_range] also invalidates
exceptional entries as well.  So we invalidate exceptional entries only if
->nrpages != 0?  This doesn't feel right.

 - Patch 1 fixes direct IO writes by removing ->nrpages check.
 - Patch 2 fixes similar case in invalidate_bdev(). 
     Note: I only fixed conditional cleancache_invalidate_inode() here.
       Do we also need to add ->nrexceptional check in into invalidate_bdev()?
     
 - Patches 3-4: some optimizations.


This patch (of 4):

Some direct IO write fs hooks call invalidate_inode_pages2[_range]()
conditionally iff mapping->nrpages is not zero.  This can't be right,
because invalidate_inode_pages2[_range]() also invalidate data in the
cleancache via cleancache_invalidate_inode() call.  So if page cache is
empty but there is some data in the cleancache, buffered read after direct
IO write would get stale data from the cleancache.

Also it doesn't feel right to check only for ->nrpages because
invalidate_inode_pages2[_range] invalidates exceptional entries as well.

Fix this by calling invalidate_inode_pages2[_range]() regardless of nrpages
state.

Note: nfs,cifs,9p doesn't need similar fix because the never call
cleancache_get_page() (nor directly, nor via mpage_readpage[s]()), so they
are not affected by this bug.

Fixes: c515e1fd361c ("mm/fs: add hooks to support cleancache")
Link: http://lkml.kernel.org/r/20170424164135.22350-2-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Kuznetsov <kuznet@virtuozzo.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/iomap.c   |   20 +++++++++-----------
 mm/filemap.c |   26 +++++++++++---------------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff -puN fs/iomap.c~fs-fix-data-invalidation-in-the-cleancache-during-direct-io fs/iomap.c
--- a/fs/iomap.c~fs-fix-data-invalidation-in-the-cleancache-during-direct-io
+++ a/fs/iomap.c
@@ -887,16 +887,14 @@ iomap_dio_rw(struct kiocb *iocb, struct
 		flags |= IOMAP_WRITE;
 	}
 
-	if (mapping->nrpages) {
-		ret = filemap_write_and_wait_range(mapping, start, end);
-		if (ret)
-			goto out_free_dio;
-
-		ret = invalidate_inode_pages2_range(mapping,
-				start >> PAGE_SHIFT, end >> PAGE_SHIFT);
-		WARN_ON_ONCE(ret);
-		ret = 0;
-	}
+	ret = filemap_write_and_wait_range(mapping, start, end);
+	if (ret)
+		goto out_free_dio;
+
+	ret = invalidate_inode_pages2_range(mapping,
+			start >> PAGE_SHIFT, end >> PAGE_SHIFT);
+	WARN_ON_ONCE(ret);
+	ret = 0;
 
 	inode_dio_begin(inode);
 
@@ -951,7 +949,7 @@ iomap_dio_rw(struct kiocb *iocb, struct
 	 * one is a pretty crazy thing to do, so we don't support it 100%.  If
 	 * this invalidation fails, tough, the write still worked...
 	 */
-	if (iov_iter_rw(iter) == WRITE && mapping->nrpages) {
+	if (iov_iter_rw(iter) == WRITE) {
 		int err = invalidate_inode_pages2_range(mapping,
 				start >> PAGE_SHIFT, end >> PAGE_SHIFT);
 		WARN_ON_ONCE(err);
diff -puN mm/filemap.c~fs-fix-data-invalidation-in-the-cleancache-during-direct-io mm/filemap.c
--- a/mm/filemap.c~fs-fix-data-invalidation-in-the-cleancache-during-direct-io
+++ a/mm/filemap.c
@@ -2720,18 +2720,16 @@ generic_file_direct_write(struct kiocb *
 	 * about to write.  We do this *before* the write so that we can return
 	 * without clobbering -EIOCBQUEUED from ->direct_IO().
 	 */
-	if (mapping->nrpages) {
-		written = invalidate_inode_pages2_range(mapping,
+	written = invalidate_inode_pages2_range(mapping,
 					pos >> PAGE_SHIFT, end);
-		/*
-		 * If a page can not be invalidated, return 0 to fall back
-		 * to buffered write.
-		 */
-		if (written) {
-			if (written == -EBUSY)
-				return 0;
-			goto out;
-		}
+	/*
+	 * If a page can not be invalidated, return 0 to fall back
+	 * to buffered write.
+	 */
+	if (written) {
+		if (written == -EBUSY)
+			return 0;
+		goto out;
 	}
 
 	written = mapping->a_ops->direct_IO(iocb, from);
@@ -2744,10 +2742,8 @@ generic_file_direct_write(struct kiocb *
 	 * so we don't support it 100%.  If this invalidation
 	 * fails, tough, the write still worked...
 	 */
-	if (mapping->nrpages) {
-		invalidate_inode_pages2_range(mapping,
-					      pos >> PAGE_SHIFT, end);
-	}
+	invalidate_inode_pages2_range(mapping,
+				pos >> PAGE_SHIFT, end);
 
 	if (written > 0) {
 		pos += written;
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are


