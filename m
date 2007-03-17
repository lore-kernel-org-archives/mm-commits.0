From: akpm@linux-foundation.org
Subject: - xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch removed from -mm tree
Date: Fri, 16 Mar 2007 16:52:34 -0800
Message-ID: <200703170052.l2H0qYTI025768@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45224 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932900AbXCQAwi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 20:52:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     xfs: stop using kmalloc in xfs_buf_get_noaddr
has been removed from the -mm tree.  Its filename was
     xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: xfs: stop using kmalloc in xfs_buf_get_noaddr
From: Christoph Hellwig <hch@lst.de>

Currently xfs_buf_get_noaddr allocates memory using kmem_alloc which can end
up either in kmalloc or vmalloc and assigns it to the buffer.  This patch
changes it to allocate individual pages and if there is more then one maps it
into kernel virtual space using vmap.

This means the minimum buffer allocation is PAGE_SIZE now.  For two of the
three caller (log buffers, log recovery) that is perfectly fine, because they
always allocate buffers that are a power of two of the page size anyway.  For
xfs_zero_remaining_bytes the minimum allocation goes up from blocksize to
pagesize and thus there is a potential waste of memory for blocksize <
pagesize allocations, which is unfortunate but not directly solveable when
block drivers expect reference countable pages.  To fix this waste
xfs_zero_remaining_bytes could be rewritten to zero more than a single block
at a time, which sounds like a good idea in general.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |   51 +++++++++++++++--------------------
 fs/xfs/linux-2.6/xfs_buf.h |    2 -
 2 files changed, 23 insertions(+), 30 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -314,7 +314,7 @@ xfs_buf_free(
 
 	ASSERT(list_empty(&bp->b_hash_list));
 
-	if (bp->b_flags & _XBF_PAGE_CACHE) {
+	if (bp->b_flags & (_XBF_PAGE_CACHE|_XBF_PAGES)) {
 		uint		i;
 
 		if ((bp->b_flags & XBF_MAPPED) && (bp->b_page_count > 1))
@@ -323,18 +323,11 @@ xfs_buf_free(
 		for (i = 0; i < bp->b_page_count; i++) {
 			struct page	*page = bp->b_pages[i];
 
-			ASSERT(!PagePrivate(page));
+			if (bp->b_flags & _XBF_PAGE_CACHE)
+				ASSERT(!PagePrivate(page));
 			page_cache_release(page);
 		}
 		_xfs_buf_free_pages(bp);
-	} else if (bp->b_flags & _XBF_KMEM_ALLOC) {
-		 /*
-		  * XXX(hch): bp->b_count_desired might be incorrect (see
-		  * xfs_buf_associate_memory for details), but fortunately
-		  * the Linux version of kmem_free ignores the len argument..
-		  */
-		kmem_free(bp->b_addr, bp->b_count_desired);
-		_xfs_buf_free_pages(bp);
 	}
 
 	xfs_buf_deallocate(bp);
@@ -764,41 +757,41 @@ xfs_buf_get_noaddr(
 	size_t			len,
 	xfs_buftarg_t		*target)
 {
-	size_t			malloc_len = len;
+	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
+	int			error, i;
 	xfs_buf_t		*bp;
-	void			*data;
-	int			error;
 
 	bp = xfs_buf_allocate(0);
 	if (unlikely(bp == NULL))
 		goto fail;
 	_xfs_buf_initialize(bp, target, 0, len, 0);
 
- try_again:
-	data = kmem_alloc(malloc_len, KM_SLEEP | KM_MAYFAIL | KM_LARGE);
-	if (unlikely(data == NULL))
+	error = _xfs_buf_get_pages(bp, page_count, 0);
+	if (error)
 		goto fail_free_buf;
 
-	/* check whether alignment matches.. */
-	if ((__psunsigned_t)data !=
-	    ((__psunsigned_t)data & ~target->bt_smask)) {
-		/* .. else double the size and try again */
-		kmem_free(data, malloc_len);
-		malloc_len <<= 1;
-		goto try_again;
-	}
-
-	error = xfs_buf_associate_memory(bp, data, len);
-	if (error)
+	for (i = 0; i < page_count; i++) {
+		bp->b_pages[i] = alloc_page(GFP_KERNEL);
+		if (!bp->b_pages[i])
+			goto fail_free_mem;
+	}
+	bp->b_flags |= _XBF_PAGES;
+
+	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
+	if (unlikely(error)) {
+		printk(KERN_WARNING "%s: failed to map pages\n",
+				__FUNCTION__);
 		goto fail_free_mem;
-	bp->b_flags |= _XBF_KMEM_ALLOC;
+	}
 
 	xfs_buf_unlock(bp);
 
 	XB_TRACE(bp, "no_daddr", data);
 	return bp;
+
  fail_free_mem:
-	kmem_free(data, malloc_len);
+ 	for ( ; i >= 0; i--)
+		__free_page(bp->b_pages[i]);
  fail_free_buf:
 	xfs_buf_free(bp);
  fail:
diff -puN fs/xfs/linux-2.6/xfs_buf.h~xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr fs/xfs/linux-2.6/xfs_buf.h
--- a/fs/xfs/linux-2.6/xfs_buf.h~xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr
+++ a/fs/xfs/linux-2.6/xfs_buf.h
@@ -63,7 +63,7 @@ typedef enum {
 
 	/* flags used only internally */
 	_XBF_PAGE_CACHE = (1 << 17),/* backed by pagecache		   */
-	_XBF_KMEM_ALLOC = (1 << 18),/* backed by kmem_alloc()		   */
+	_XBF_PAGES = (1 << 18),	    /* backed by refcounted pages	   */
 	_XBF_RUN_QUEUES = (1 << 19),/* run block device task queue	   */
 	_XBF_DELWRI_Q = (1 << 21),   /* buffer on delwri queue		   */
 } xfs_buf_flags_t;
_

Patches currently in -mm which might be from hch@lst.de are

ufs2-tindirect-truncate-fix.patch
cifs-remove-unneeded-checks.patch
xfs-stop-using-kmalloc-in-xfs_buf_get_noaddr.patch
simplify-the-stacktrace-code.patch
allow-access-to-proc-pid-fd-after-setuid.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freevxfs-possible-null-pointer-dereference-fix.patch
vfs-remove-superflous-sb-==-null-checks.patch
nameic-remove-utterly-outdated-comment.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
ps3fb-thread-updates.patch
ps3av-thread-updates.patch
ps3fb-kill-superfluous-zero-initializations.patch
ps3av-misc-updates.patch
