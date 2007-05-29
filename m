From: akpm@linux-foundation.org
Subject: + mm-write-iovec-cleanup.patch added to -mm tree
Date: Tue, 29 May 2007 14:19:47 -0700
Message-ID: <200705292119.l4TLJl3d011712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43448 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751139AbXE2VUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 17:20:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: write iovec cleanup
has been added to the -mm tree.  Its filename is
     mm-write-iovec-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: write iovec cleanup
From: Nick Piggin <npiggin@suse.de>

Hide some of the open-coded nr_segs tests into the iovec helpers.  This is all
to simplify generic_file_buffered_write, because that gets more complex in the
next patch.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c     |   36 ++++-----------
 mm/filemap.h     |  104 ++++++++++++++++++++++-----------------------
 mm/filemap_xip.c |   17 +++----
 3 files changed, 69 insertions(+), 88 deletions(-)

diff -puN mm/filemap.c~mm-write-iovec-cleanup mm/filemap.c
--- a/mm/filemap.c~mm-write-iovec-cleanup
+++ a/mm/filemap.c
@@ -1877,12 +1877,7 @@ generic_file_buffered_write(struct kiocb
 	/*
 	 * handle partial DIO write.  Adjust cur_iov if needed.
 	 */
-	if (likely(nr_segs == 1))
-		buf = iov->iov_base + written;
-	else {
-		filemap_set_next_iovec(&cur_iov, &iov_offset, written);
-		buf = cur_iov->iov_base + iov_offset;
-	}
+	filemap_set_next_iovec(&cur_iov, nr_segs, &iov_offset, written);
 
 	do {
 		struct page *page;
@@ -1892,6 +1887,7 @@ generic_file_buffered_write(struct kiocb
 		size_t bytes;		/* Bytes to write to page */
 		size_t copied;		/* Bytes copied from user */
 
+		buf = cur_iov->iov_base + iov_offset;
 		offset = (pos & (PAGE_CACHE_SIZE - 1));
 		index = pos >> PAGE_CACHE_SHIFT;
 		bytes = PAGE_CACHE_SIZE - offset;
@@ -1923,13 +1919,10 @@ generic_file_buffered_write(struct kiocb
 		if (unlikely(status))
 			goto fs_write_aop_error;
 
-		if (likely(nr_segs == 1))
-			copied = filemap_copy_from_user(page, offset,
-							buf, bytes);
-		else
-			copied = filemap_copy_from_user_iovec(page, offset,
-						cur_iov, iov_offset, bytes);
+		copied = filemap_copy_from_user(page, offset,
+					cur_iov, nr_segs, iov_offset, bytes);
 		flush_dcache_page(page);
+
 		status = a_ops->commit_write(file, page, offset, offset+bytes);
 		if (unlikely(status < 0 || status == AOP_TRUNCATED_PAGE))
 			goto fs_write_aop_error;
@@ -1940,20 +1933,11 @@ generic_file_buffered_write(struct kiocb
 		if (unlikely(status > 0)) /* filesystem did partial write */
 			copied = status;
 
-		if (likely(copied > 0)) {
-			written += copied;
-			count -= copied;
-			pos += copied;
-			buf += copied;
-			if (unlikely(nr_segs > 1)) {
-				filemap_set_next_iovec(&cur_iov,
-						&iov_offset, copied);
-				if (count)
-					buf = cur_iov->iov_base + iov_offset;
-			} else {
-				iov_offset += copied;
-			}
-		}
+		written += copied;
+		count -= copied;
+		pos += copied;
+		filemap_set_next_iovec(&cur_iov, nr_segs, &iov_offset, copied);
+
 		unlock_page(page);
 		mark_page_accessed(page);
 		page_cache_release(page);
diff -puN mm/filemap.h~mm-write-iovec-cleanup mm/filemap.h
--- a/mm/filemap.h~mm-write-iovec-cleanup
+++ a/mm/filemap.h
@@ -22,82 +22,82 @@ __filemap_copy_from_user_iovec_inatomic(
 
 /*
  * Copy as much as we can into the page and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then clear the page
- * out to (offset+bytes) and return the number of bytes which were copied.
- *
- * NOTE: For this to work reliably we really want copy_from_user_inatomic_nocache
- * to *NOT* zero any tail of the buffer that it failed to copy.  If it does,
- * and if the following non-atomic copy succeeds, then there is a small window
- * where the target page contains neither the data before the write, nor the
- * data after the write (it contains zero).  A read at this time will see
- * data that is inconsistent with any ordering of the read and the write.
- * (This has been detected in practice).
+ * were sucessfully copied.  If a fault is encountered then return the number of
+ * bytes which were copied.
  */
 static inline size_t
-filemap_copy_from_user(struct page *page, unsigned long offset,
-			const char __user *buf, unsigned bytes)
+filemap_copy_from_user_atomic(struct page *page, unsigned long offset,
+			const struct iovec *iov, unsigned long nr_segs,
+			size_t base, size_t bytes)
 {
 	char *kaddr;
-	int left;
+	size_t copied;
 
 	kaddr = kmap_atomic(page, KM_USER0);
-	left = __copy_from_user_inatomic_nocache(kaddr + offset, buf, bytes);
+	if (likely(nr_segs == 1)) {
+		int left;
+		char __user *buf = iov->iov_base + base;
+		left = __copy_from_user_inatomic_nocache(kaddr + offset,
+							buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset,
+							iov, base, bytes);
+	}
 	kunmap_atomic(kaddr, KM_USER0);
 
-	if (left != 0) {
-		/* Do it the slow way */
-		kaddr = kmap(page);
-		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
-		kunmap(page);
-	}
-	return bytes - left;
+	return copied;
 }
 
 /*
- * This has the same sideeffects and return value as filemap_copy_from_user().
- * The difference is that on a fault we need to memset the remainder of the
- * page (out to offset+bytes), to emulate filemap_copy_from_user()'s
- * single-segment behaviour.
+ * This has the same sideeffects and return value as
+ * filemap_copy_from_user_atomic().
+ * The difference is that it attempts to resolve faults.
  */
 static inline size_t
-filemap_copy_from_user_iovec(struct page *page, unsigned long offset,
-			const struct iovec *iov, size_t base, size_t bytes)
+filemap_copy_from_user(struct page *page, unsigned long offset,
+			const struct iovec *iov, unsigned long nr_segs,
+			 size_t base, size_t bytes)
 {
 	char *kaddr;
 	size_t copied;
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset, iov,
-							 base, bytes);
-	kunmap_atomic(kaddr, KM_USER0);
-	if (copied != bytes) {
-		kaddr = kmap(page);
-		copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset, iov,
-								 base, bytes);
-		if (bytes - copied)
-			memset(kaddr + offset + copied, 0, bytes - copied);
-		kunmap(page);
+	kaddr = kmap(page);
+	if (likely(nr_segs == 1)) {
+		int left;
+		char __user *buf = iov->iov_base + base;
+		left = __copy_from_user_nocache(kaddr + offset, buf, bytes);
+		copied = bytes - left;
+	} else {
+		copied = __filemap_copy_from_user_iovec_inatomic(kaddr + offset,
+							iov, base, bytes);
 	}
+	kunmap(page);
 	return copied;
 }
 
 static inline void
-filemap_set_next_iovec(const struct iovec **iovp, size_t *basep, size_t bytes)
+filemap_set_next_iovec(const struct iovec **iovp, unsigned long nr_segs,
+						 size_t *basep, size_t bytes)
 {
-	const struct iovec *iov = *iovp;
-	size_t base = *basep;
-
-	while (bytes) {
-		int copy = min(bytes, iov->iov_len - base);
-
-		bytes -= copy;
-		base += copy;
-		if (iov->iov_len == base) {
-			iov++;
-			base = 0;
+	if (likely(nr_segs == 1)) {
+		*basep += bytes;
+	} else {
+		const struct iovec *iov = *iovp;
+		size_t base = *basep;
+
+		while (bytes) {
+			int copy = min(bytes, iov->iov_len - base);
+
+			bytes -= copy;
+			base += copy;
+			if (iov->iov_len == base) {
+				iov++;
+				base = 0;
+			}
 		}
+		*iovp = iov;
+		*basep = base;
 	}
-	*iovp = iov;
-	*basep = base;
 }
 #endif
diff -puN mm/filemap_xip.c~mm-write-iovec-cleanup mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-write-iovec-cleanup
+++ a/mm/filemap_xip.c
@@ -15,7 +15,6 @@
 #include <linux/rmap.h>
 #include <linux/sched.h>
 #include <asm/tlbflush.h>
-#include "filemap.h"
 
 /*
  * We do use our own empty page to avoid interference with other users
@@ -319,6 +318,7 @@ __xip_file_write(struct file *filp, cons
 		unsigned long index;
 		unsigned long offset;
 		size_t copied;
+		char *kaddr;
 
 		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
 		index = pos >> PAGE_CACHE_SHIFT;
@@ -326,14 +326,6 @@ __xip_file_write(struct file *filp, cons
 		if (bytes > count)
 			bytes = count;
 
-		/*
-		 * Bring in the user page that we will copy from _first_.
-		 * Otherwise there's a nasty deadlock on copying from the
-		 * same page as we're writing to, without it being marked
-		 * up-to-date.
-		 */
-		fault_in_pages_readable(buf, bytes);
-
 		page = a_ops->get_xip_page(mapping,
 					   index*(PAGE_SIZE/512), 0);
 		if (IS_ERR(page) && (PTR_ERR(page) == -ENODATA)) {
@@ -350,8 +342,13 @@ __xip_file_write(struct file *filp, cons
 			break;
 		}
 
-		copied = filemap_copy_from_user(page, offset, buf, bytes);
+		fault_in_pages_readable(buf, bytes);
+		kaddr = kmap_atomic(page, KM_USER0);
+		copied = bytes -
+			__copy_from_user_inatomic_nocache(kaddr, buf, bytes);
+		kunmap_atomic(kaddr, KM_USER0);
 		flush_dcache_page(page);
+
 		if (likely(copied > 0)) {
 			status = copied;
 
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
