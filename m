From: akpm@linux-foundation.org
Subject: - hugetlbfs-read-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:35:59 -0700
Message-ID: <200710162035.l9GKZxsE015102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41323 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965819AbXJPVkS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:40:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, bill.irwin@oracle.com, nacc@us.ibm.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     hugetlbfs read() support
has been removed from the -mm tree.  Its filename was
     hugetlbfs-read-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: hugetlbfs read() support
From: Badari Pulavarty <pbadari@us.ibm.com>

Support for reading from hugetlbfs files.  libhugetlbfs lets application
text/data to be placed in large pages.  When we do that, oprofile doesn't
work - since libbfd tries to read from it.

This code is very similar to what do_generic_mapping_read() does, but I
can't use it since it has PAGE_CACHE_SIZE assumptions.

[akpm@linux-foundation.org: cleanups, fix leak]
[bunk@stusta.de: make hugetlbfs_read() static]
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |  125 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-read-support fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-read-support
+++ a/fs/hugetlbfs/inode.c
@@ -179,6 +179,130 @@ full_search:
 }
 #endif
 
+static int
+hugetlbfs_read_actor(struct page *page, unsigned long offset,
+			char __user *buf, unsigned long count,
+			unsigned long size)
+{
+	char *kaddr;
+	unsigned long left, copied = 0;
+	int i, chunksize;
+
+	if (size > count)
+		size = count;
+
+	/* Find which 4k chunk and offset with in that chunk */
+	i = offset >> PAGE_CACHE_SHIFT;
+	offset = offset & ~PAGE_CACHE_MASK;
+
+	while (size) {
+		chunksize = PAGE_CACHE_SIZE;
+		if (offset)
+			chunksize -= offset;
+		if (chunksize > size)
+			chunksize = size;
+		kaddr = kmap(&page[i]);
+		left = __copy_to_user(buf, kaddr + offset, chunksize);
+		kunmap(&page[i]);
+		if (left) {
+			copied += (chunksize - left);
+			break;
+		}
+		offset = 0;
+		size -= chunksize;
+		buf += chunksize;
+		copied += chunksize;
+		i++;
+	}
+	return copied ? copied : -EFAULT;
+}
+
+/*
+ * Support for read() - Find the page attached to f_mapping and copy out the
+ * data. Its *very* similar to do_generic_mapping_read(), we can't use that
+ * since it has PAGE_CACHE_SIZE assumptions.
+ */
+static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
+			      size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	unsigned long index = *ppos >> HPAGE_SHIFT;
+	unsigned long offset = *ppos & ~HPAGE_MASK;
+	unsigned long end_index;
+	loff_t isize;
+	ssize_t retval = 0;
+
+	mutex_lock(&inode->i_mutex);
+
+	/* validate length */
+	if (len == 0)
+		goto out;
+
+	isize = i_size_read(inode);
+	if (!isize)
+		goto out;
+
+	end_index = (isize - 1) >> HPAGE_SHIFT;
+	for (;;) {
+		struct page *page;
+		int nr, ret;
+
+		/* nr is the maximum number of bytes to copy from this page */
+		nr = HPAGE_SIZE;
+		if (index >= end_index) {
+			if (index > end_index)
+				goto out;
+			nr = ((isize - 1) & ~HPAGE_MASK) + 1;
+			if (nr <= offset) {
+				goto out;
+			}
+		}
+		nr = nr - offset;
+
+		/* Find the page */
+		page = find_get_page(mapping, index);
+		if (unlikely(page == NULL)) {
+			/*
+			 * We have a HOLE, zero out the user-buffer for the
+			 * length of the hole or request.
+			 */
+			ret = len < nr ? len : nr;
+			if (clear_user(buf, ret))
+				ret = -EFAULT;
+		} else {
+			/*
+			 * We have the page, copy it to user space buffer.
+			 */
+			ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
+		}
+		if (ret < 0) {
+			if (retval == 0)
+				retval = ret;
+			if (page)
+				page_cache_release(page);
+			goto out;
+		}
+
+		offset += ret;
+		retval += ret;
+		len -= ret;
+		index += offset >> HPAGE_SHIFT;
+		offset &= ~HPAGE_MASK;
+
+		if (page)
+			page_cache_release(page);
+
+		/* short read or no more work */
+		if ((ret != nr) || (len == 0))
+			break;
+	}
+out:
+	*ppos = ((loff_t)index << HPAGE_SHIFT) + offset;
+	mutex_unlock(&inode->i_mutex);
+	return retval;
+}
+
 /*
  * Read a page. Again trivial. If it didn't already exist
  * in the page cache, it is zero-filled.
@@ -581,6 +705,7 @@ static void init_once(void *foo, struct 
 }
 
 const struct file_operations hugetlbfs_file_operations = {
+	.read			= hugetlbfs_read,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= simple_sync_file,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
aio-account-i-o-wait-time-properly.patch
fix-for-ext2-reservation.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
mem-controller-gfp-mask-fix.patch
powerpc-add-scaled-time-accounting-speedup.patch
