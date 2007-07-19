From: akpm@linux-foundation.org
Subject: + hugetlbfs-read-support.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:20:34 -0700
Message-ID: <200707190520.l6J5KY1e015330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730AbXGSFVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, bill.irwin@oracle.com, nacc@us.ibm.com, nickpiggin@yahoo.com.au


The patch titled
     hugetlbfs read() support
has been added to the -mm tree.  Its filename is
     hugetlbfs-read-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hugetlbfs read() support
From: Badari Pulavarty <pbadari@us.ibm.com>

Support for reading from hugetlbfs files.  libhugetlbfs lets application
text/data to be placed in large pages.  When we do that, oprofile doesn't
work - since libbfd tries to read from it.

This code is very similar to what do_generic_mapping_read() does, but I
can't use it since it has PAGE_CACHE_SIZE assumptions.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: William Irwin <bill.irwin@oracle.com>
Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |  113 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff -puN fs/hugetlbfs/inode.c~hugetlbfs-read-support fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~hugetlbfs-read-support
+++ a/fs/hugetlbfs/inode.c
@@ -174,6 +174,118 @@ full_search:
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
+ssize_t
+hugetlbfs_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
+{
+	struct address_space *mapping = filp->f_mapping;
+	struct inode *inode = mapping->host;
+	unsigned long index = *ppos >> HPAGE_SHIFT;
+	unsigned long end_index;
+	loff_t isize;
+	unsigned long offset;
+	ssize_t retval = 0;
+
+	/* validate length */
+	if (len == 0)
+		goto out;
+
+	isize = i_size_read(inode);
+	if (!isize)
+		goto out;
+
+	offset = *ppos & ~HPAGE_MASK;
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
+			 * We can't find the page in the cache - bail out ?
+			 */
+			goto out;
+		}
+		/*
+		 * Ok, we have the page, copy it to user space buffer.
+		 */
+		ret = hugetlbfs_read_actor(page, offset, buf, len, nr);
+		if (ret < 0) {
+			retval = retval ? : ret;
+			goto out;
+		}
+
+		offset += ret;
+		retval += ret;
+		len -= ret;
+		index += offset >> HPAGE_SHIFT;
+		offset &= ~HPAGE_MASK;
+
+		page_cache_release(page);
+		if (ret == nr && len)
+			continue;
+		goto out;
+	}
+out:
+	return retval;
+}
+
 /*
  * Read a page. Again trivial. If it didn't already exist
  * in the page cache, it is zero-filled.
@@ -582,6 +694,7 @@ static void init_once(void *foo, struct 
 }
 
 const struct file_operations hugetlbfs_file_operations = {
+	.read			= hugetlbfs_read,
 	.mmap			= hugetlbfs_file_mmap,
 	.fsync			= simple_sync_file,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

origin.patch
ext3-convert-to-new-aops.patch
ext4-convert-to-new-aops.patch
hugetlbfs-read-support.patch
ext2-statfs-improvement-for-block-and-inode-free-count.patch
fix-for-ext2-reservation.patch
