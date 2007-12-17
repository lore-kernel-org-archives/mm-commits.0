From: akpm@linux-foundation.org
Subject: + ecryptfs-fix-fsx-data-corruption-problems.patch added to -mm tree
Date: Sun, 16 Dec 2007 22:41:10 -0800
Message-ID: <200712170641.lBH6fAgb001519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbXLQGl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 01:41:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: fix fsx data corruption problems
has been added to the -mm tree.  Its filename is
     ecryptfs-fix-fsx-data-corruption-problems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ecryptfs: fix fsx data corruption problems
From: Eric Sandeen <sandeen@redhat.com>

ecryptfs in 2.6.24-rc3 wasn't surviving fsx for me at all, dying after 4
ops.  Generally, encountering problems with stale data and improperly
zeroed pages.  An extending truncate + write for example would expose stale
data.

With the changes below I got to a million ops and beyond with all mmap ops
disabled - mmap still needs work.  (A version of this patch on a RHEL5
kernel ran for over 110 million fsx ops)

I added a few comments as well, to the best of my understanding
as I read through the code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/mmap.c       |   31 ++++++++++++++++++++-----------
 fs/ecryptfs/read_write.c |   27 +++++++++++++++++++++------
 2 files changed, 41 insertions(+), 17 deletions(-)

diff -puN fs/ecryptfs/mmap.c~ecryptfs-fix-fsx-data-corruption-problems fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c~ecryptfs-fix-fsx-data-corruption-problems
+++ a/fs/ecryptfs/mmap.c
@@ -263,14 +263,13 @@ out:
 	return 0;
 }
 
+/* This function must zero any hole we create */
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
 	int rc = 0;
+	loff_t prev_page_end_size;
 
-	if (from == 0 && to == PAGE_CACHE_SIZE)
-		goto out;	/* If we are writing a full page, it will be
-				   up to date. */
 	if (!PageUptodate(page)) {
 		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
 						      PAGE_CACHE_SIZE,
@@ -283,22 +282,32 @@ static int ecryptfs_prepare_write(struct
 		} else
 			SetPageUptodate(page);
 	}
-	if (page->index != 0) {
-		loff_t end_of_prev_pg_pos =
-			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
 
-		if (end_of_prev_pg_pos > i_size_read(page->mapping->host)) {
+	prev_page_end_size = ((loff_t)page->index << PAGE_CACHE_SHIFT);
+
+	/*
+	 * If creating a page or more of holes, zero them out via truncate.
+	 * Note, this will increase i_size.
+	 */
+	if (page->index != 0) {
+		if (prev_page_end_size > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
-					       end_of_prev_pg_pos);
+					       prev_page_end_size);
 			if (rc) {
 				printk(KERN_ERR "Error on attempt to "
 				       "truncate to (higher) offset [%lld];"
-				       " rc = [%d]\n", end_of_prev_pg_pos, rc);
+				       " rc = [%d]\n", prev_page_end_size, rc);
 				goto out;
 			}
 		}
-		if (end_of_prev_pg_pos + 1 > i_size_read(page->mapping->host))
-			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+	}
+	/*
+	 * Writing to a new page, and creating a small hole from start of page?
+	 * Zero it out.
+	 */
+	if ((i_size_read(page->mapping->host) == prev_page_end_size) &&
+	    (from != 0)) {
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 	}
 out:
 	return rc;
diff -puN fs/ecryptfs/read_write.c~ecryptfs-fix-fsx-data-corruption-problems fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c~ecryptfs-fix-fsx-data-corruption-problems
+++ a/fs/ecryptfs/read_write.c
@@ -124,6 +124,10 @@ int ecryptfs_write(struct file *ecryptfs
 	loff_t pos;
 	int rc = 0;
 
+	/*
+	 * if we are writing beyond current size, then start pos
+	 * at the current size - we'll fill in zeros from there.
+	 */
 	if (offset > ecryptfs_file_size)
 		pos = ecryptfs_file_size;
 	else
@@ -137,6 +141,7 @@ int ecryptfs_write(struct file *ecryptfs
 		if (num_bytes > total_remaining_bytes)
 			num_bytes = total_remaining_bytes;
 		if (pos < offset) {
+			/* remaining zeros to write, up to destination offset */
 			size_t total_remaining_zeros = (offset - pos);
 
 			if (num_bytes > total_remaining_zeros)
@@ -167,17 +172,27 @@ int ecryptfs_write(struct file *ecryptfs
 			}
 		}
 		ecryptfs_page_virt = kmap_atomic(ecryptfs_page, KM_USER0);
+
+		/*
+		 * pos: where we're now writing, offset: where the request was
+		 * If current pos is before request, we are filling zeros
+		 * If we are at or beyond request, we are writing the *data*
+		 * If we're in a fresh page beyond eof, zero it in either case
+		 */
+		if (pos < offset || !start_offset_in_page) {
+			/* We are extending past the previous end of the file.
+			 * Fill in zero values to the end of the page */
+			memset(((char *)ecryptfs_page_virt
+				+ start_offset_in_page), 0,
+				PAGE_CACHE_SIZE - start_offset_in_page);
+		}
+
+		/* pos >= offset, we are now writing the data request */
 		if (pos >= offset) {
 			memcpy(((char *)ecryptfs_page_virt
 				+ start_offset_in_page),
 			       (data + data_offset), num_bytes);
 			data_offset += num_bytes;
-		} else {
-			/* We are extending past the previous end of the file.
-			 * Fill in zero values up to the start of where we
-			 * will be writing data. */
-			memset(((char *)ecryptfs_page_virt
-				+ start_offset_in_page), 0, num_bytes);
 		}
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
 		flush_dcache_page(ecryptfs_page);
_

Patches currently in -mm which might be from sandeen@redhat.com are

ecryptfs-initialize-new-auth_tokens-before-teardown.patch
ecryptfs-set-s_blocksize-from-lower-fs-in-sb.patch
ecryptfs-fix-fsx-data-corruption-problems.patch
ext2-change-the-default-behaviour-on-error.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
ext4-fix-mb_debug-format-warnings.patch
ext4-fix-freespace-accounting-with-mballoc-on-32bit-machines.patch
ext4-fix-oops-with-jbd-stats-through-procfs-and-external.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext3-change-the-default-behaviour-on-error.patch
