From: akpm@linux-foundation.org
Subject: + mm-fix-pagecache-write-deadlocks.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:49 -0700
Message-ID: <200705292119.l4TLJoVV011715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbXE2VTz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: fix pagecache write deadlocks
has been added to the -mm tree.  Its filename is
     mm-fix-pagecache-write-deadlocks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fix pagecache write deadlocks
From: Nick Piggin <npiggin@suse.de>

Modify the core write() code so that it won't take a pagefault while holding a
lock on the pagecache page. There are a number of different deadlocks possible
if we try to do such a thing:

1.  generic_buffered_write
2.   lock_page
3.    prepare_write
4.     unlock_page+vmtruncate
5.     copy_from_user
6.      mmap_sem(r)
7.       handle_mm_fault
8.        lock_page (filemap_nopage)
9.    commit_write
10.  unlock_page

a. sys_munmap / sys_mlock / others
b.  mmap_sem(w)
c.   make_pages_present
d.    get_user_pages
e.     handle_mm_fault
f.      lock_page (filemap_nopage)

2,8	- recursive deadlock if page is same
2,8;2,8	- ABBA deadlock is page is different
2,6;b,f	- ABBA deadlock if page is same

The solution is as follows:
1.  If we find the destination page is uptodate, continue as normal, but use
    atomic usercopies which do not take pagefaults and do not zero the uncopied
    tail of the destination. The destination is already uptodate, so we can
    commit_write the full length even if there was a partial copy: it does not
    matter that the tail was not modified, because if it is dirtied and written
    back to disk it will not cause any problems (uptodate *means* that the
    destination page is as new or newer than the copy on disk).

1a. The above requires that fault_in_pages_readable correctly returns access
    information, because atomic usercopies cannot distinguish between
    non-present pages in a readable mapping, from lack of a readable mapping.

2.  If we find the destination page is non uptodate, unlock it (this could be
    made slightly more optimal), then allocate a temporary page to copy the
    source data into. Relock the destination page and continue with the copy.
    However, instead of a usercopy (which might take a fault), copy the data
    from the pinned temporary page via the kernel address space.

(also, rename maxlen to seglen, because it was confusing)

This increases the CPU/memory copy cost by almost 50% on the affected
workloads. That will be solved by introducing a new set of pagecache write
aops in a subsequent patch.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   11 ++-
 mm/filemap.c            |  122 ++++++++++++++++++++++++++++++++------
 2 files changed, 112 insertions(+), 21 deletions(-)

diff -puN include/linux/pagemap.h~mm-fix-pagecache-write-deadlocks include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-fix-pagecache-write-deadlocks
+++ a/include/linux/pagemap.h
@@ -218,6 +218,9 @@ static inline int fault_in_pages_writeab
 {
 	int ret;
 
+	if (unlikely(size == 0))
+		return 0;
+
 	/*
 	 * Writing zeroes into userspace here is OK, because we know that if
 	 * the zero gets there, we'll be overwriting it.
@@ -237,19 +240,23 @@ static inline int fault_in_pages_writeab
 	return ret;
 }
 
-static inline void fault_in_pages_readable(const char __user *uaddr, int size)
+static inline int fault_in_pages_readable(const char __user *uaddr, int size)
 {
 	volatile char c;
 	int ret;
 
+	if (unlikely(size == 0))
+		return 0;
+
 	ret = __get_user(c, uaddr);
 	if (ret == 0) {
 		const char __user *end = uaddr + size - 1;
 
 		if (((unsigned long)uaddr & PAGE_MASK) !=
 				((unsigned long)end & PAGE_MASK))
-		 	__get_user(c, end);
+		 	ret = __get_user(c, end);
 	}
+	return ret;
 }
 
 #endif /* _LINUX_PAGEMAP_H */
diff -puN mm/filemap.c~mm-fix-pagecache-write-deadlocks mm/filemap.c
--- a/mm/filemap.c~mm-fix-pagecache-write-deadlocks
+++ a/mm/filemap.c
@@ -1880,11 +1880,12 @@ generic_file_buffered_write(struct kiocb
 	filemap_set_next_iovec(&cur_iov, nr_segs, &iov_offset, written);
 
 	do {
+		struct page *src_page;
 		struct page *page;
 		pgoff_t index;		/* Pagecache index for current page */
 		unsigned long offset;	/* Offset into pagecache page */
-		unsigned long maxlen;	/* Bytes remaining in current iovec */
-		size_t bytes;		/* Bytes to write to page */
+		unsigned long seglen;	/* Bytes remaining in current iovec */
+		unsigned long bytes;	/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 
 		buf = cur_iov->iov_base + iov_offset;
@@ -1894,20 +1895,30 @@ generic_file_buffered_write(struct kiocb
 		if (bytes > count)
 			bytes = count;
 
-		maxlen = cur_iov->iov_len - iov_offset;
-		if (maxlen > bytes)
-			maxlen = bytes;
+		/*
+		 * a non-NULL src_page indicates that we're doing the
+		 * copy via get_user_pages and kmap.
+		 */
+		src_page = NULL;
+
+		seglen = cur_iov->iov_len - iov_offset;
+		if (seglen > bytes)
+			seglen = bytes;
 
-#ifndef CONFIG_DEBUG_VM
 		/*
 		 * Bring in the user page that we will copy from _first_.
 		 * Otherwise there's a nasty deadlock on copying from the
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
+		 *
+		 * Not only is this an optimisation, but it is also required
+		 * to check that the address is actually valid, when atomic
+		 * usercopies are used, below.
 		 */
-		fault_in_pages_readable(buf, maxlen);
-#endif
-
+		if (unlikely(fault_in_pages_readable(buf, seglen))) {
+			status = -EFAULT;
+			break;
+		}
 
 		page = __grab_cache_page(mapping, index);
 		if (!page) {
@@ -1915,32 +1926,104 @@ generic_file_buffered_write(struct kiocb
 			break;
 		}
 
+		/*
+		 * non-uptodate pages cannot cope with short copies, and we
+		 * cannot take a pagefault with the destination page locked.
+		 * So pin the source page to copy it.
+		 */
+		if (!PageUptodate(page)) {
+			unlock_page(page);
+
+			src_page = alloc_page(GFP_KERNEL);
+			if (!src_page) {
+				page_cache_release(page);
+				status = -ENOMEM;
+				break;
+			}
+
+			/*
+			 * Cannot get_user_pages with a page locked for the
+			 * same reason as we can't take a page fault with a
+			 * page locked (as explained below).
+			 */
+			copied = filemap_copy_from_user(src_page, offset,
+					cur_iov, nr_segs, iov_offset, bytes);
+			if (unlikely(copied == 0)) {
+				status = -EFAULT;
+				page_cache_release(page);
+				page_cache_release(src_page);
+				break;
+			}
+			bytes = copied;
+
+			lock_page(page);
+			/*
+			 * Can't handle the page going uptodate here, because
+			 * that means we would use non-atomic usercopies, which
+			 * zero out the tail of the page, which can cause
+			 * zeroes to become transiently visible. We could just
+			 * use a non-zeroing copy, but the APIs aren't too
+			 * consistent.
+			 */
+			if (unlikely(!page->mapping || PageUptodate(page))) {
+				unlock_page(page);
+				page_cache_release(page);
+				page_cache_release(src_page);
+				continue;
+			}
+
+		}
+
 		status = a_ops->prepare_write(file, page, offset, offset+bytes);
 		if (unlikely(status))
 			goto fs_write_aop_error;
 
-		copied = filemap_copy_from_user(page, offset,
+		if (!src_page) {
+			/*
+			 * Must not enter the pagefault handler here, because
+			 * we hold the page lock, so we might recursively
+			 * deadlock on the same lock, or get an ABBA deadlock
+			 * against a different lock, or against the mmap_sem
+			 * (which nests outside the page lock).  So increment
+			 * preempt count, and use _atomic usercopies.
+			 *
+			 * The page is uptodate so we are OK to encounter a
+			 * short copy: if unmodified parts of the page are
+			 * marked dirty and written out to disk, it doesn't
+			 * really matter.
+			 */
+			pagefault_disable();
+			copied = filemap_copy_from_user_atomic(page, offset,
 					cur_iov, nr_segs, iov_offset, bytes);
+			pagefault_enable();
+		} else {
+			void *src, *dst;
+			src = kmap_atomic(src_page, KM_USER0);
+			dst = kmap_atomic(page, KM_USER1);
+			memcpy(dst + offset, src + offset, bytes);
+			kunmap_atomic(dst, KM_USER1);
+			kunmap_atomic(src, KM_USER0);
+			copied = bytes;
+		}
 		flush_dcache_page(page);
 
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (unlikely(status < 0 || status == AOP_TRUNCATED_PAGE))
 			goto fs_write_aop_error;
-		if (unlikely(copied != bytes)) {
-			status = -EFAULT;
-			goto fs_write_aop_error;
-		}
 		if (unlikely(status > 0)) /* filesystem did partial write */
-			copied = status;
+			copied = min_t(size_t, copied, status);
+
+		unlock_page(page);
+		mark_page_accessed(page);
+		page_cache_release(page);
+		if (src_page)
+			page_cache_release(src_page);
 
 		written += copied;
 		count -= copied;
 		pos += copied;
 		filemap_set_next_iovec(&cur_iov, nr_segs, &iov_offset, copied);
 
-		unlock_page(page);
-		mark_page_accessed(page);
-		page_cache_release(page);
 		balance_dirty_pages_ratelimited(mapping);
 		cond_resched();
 		continue;
@@ -1949,6 +2032,8 @@ fs_write_aop_error:
 		if (status != AOP_TRUNCATED_PAGE)
 			unlock_page(page);
 		page_cache_release(page);
+		if (src_page)
+			page_cache_release(src_page);
 
 		/*
 		 * prepare_write() may have instantiated a few blocks
@@ -1961,7 +2046,6 @@ fs_write_aop_error:
 			continue;
 		else
 			break;
-
 	} while (count);
 	*ppos = pos;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
git-arm-master.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
