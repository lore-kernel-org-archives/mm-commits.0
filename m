From: akpm@linux-foundation.org
Subject: - mm-fix-pagecache-write-deadlocks.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:32:10 -0700
Message-ID: <200710162032.l9GKWA9J014575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965851AbXJPVky (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:40:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm: fix pagecache write deadlocks
has been removed from the -mm tree.  Its filename was
     mm-fix-pagecache-write-deadlocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -219,6 +219,9 @@ static inline int fault_in_pages_writeab
 {
 	int ret;
 
+	if (unlikely(size == 0))
+		return 0;
+
 	/*
 	 * Writing zeroes into userspace here is OK, because we know that if
 	 * the zero gets there, we'll be overwriting it.
@@ -238,19 +241,23 @@ static inline int fault_in_pages_writeab
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
@@ -1826,11 +1826,12 @@ generic_file_buffered_write(struct kiocb
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
@@ -1840,20 +1841,30 @@ generic_file_buffered_write(struct kiocb
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
@@ -1861,32 +1872,104 @@ generic_file_buffered_write(struct kiocb
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
@@ -1895,6 +1978,8 @@ fs_write_aop_error:
 		if (status != AOP_TRUNCATED_PAGE)
 			unlock_page(page);
 		page_cache_release(page);
+		if (src_page)
+			page_cache_release(src_page);
 
 		/*
 		 * prepare_write() may have instantiated a few blocks
@@ -1907,7 +1992,6 @@ fs_write_aop_error:
 			continue;
 		else
 			break;
-
 	} while (count);
 	*ppos = pos;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-document-tree_lock-zonelock-lockorder.patch
fs-reiserfs-cleanups.patch
atomic_opstxt-has-incorrect-misleading-and-insufficient-information.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke-fix.patch
bitops-introduce-lock-ops.patch
alpha-fix-bitops.patch
alpha-lock-bitops.patch
alpha-lock-bitops-fix.patch
ia64-lock-bitops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
bit_spin_lock-use-lock-bitops.patch
reiser4-fix-for-new-aops-patches.patch
