From: akpm@linux-foundation.org
Subject: + reiser4-use-zero_user_page.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:26:46 -0700
Message-ID: <200704110626.l3B6Qkac030275@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33293 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161213AbXDKG06 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:26:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com, edward@namesys.com, vs@namesys.com


The patch titled
     reiser4: use zero_user_page
has been added to the -mm tree.  Its filename is
     reiser4-use-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiser4: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/plugin/file/cryptcompress.c   |   21 +++++----------------
 fs/reiser4/plugin/file/file.c            |    6 +-----
 fs/reiser4/plugin/item/ctail.c           |    6 +-----
 fs/reiser4/plugin/item/extent_file_ops.c |   19 ++++++-------------
 fs/reiser4/plugin/item/tail.c            |    9 +++------
 5 files changed, 16 insertions(+), 45 deletions(-)

diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-zero_user_page fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-zero_user_page
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1897,7 +1897,6 @@ static int
 write_hole(struct inode *inode, reiser4_cluster_t * clust, loff_t file_off,
 	   loff_t to_file)
 {
-	char *data;
 	int result = 0;
 	unsigned cl_off, cl_count = 0;
 	unsigned to_pg, pg_off;
@@ -1934,10 +1933,7 @@ write_hole(struct inode *inode, reiser4_
 
 		to_pg = min_count(PAGE_CACHE_SIZE - pg_off, cl_count);
 		lock_page(page);
-		data = kmap_atomic(page, KM_USER0);
-		memset(data + pg_off, 0, to_pg);
-		flush_dcache_page(page);
-		kunmap_atomic(data, KM_USER0);
+		zero_user_page(page, pg_off, to_pg, KM_USER0);
 		SetPageUptodate(page);
 		unlock_page(page);
 
@@ -2167,7 +2163,6 @@ read_some_cluster_pages(struct inode *in
 
 		if (clust->nr_pages) {
 			int off;
-			char *data;
 			struct page * pg;
 			assert("edward-1419", clust->pages != NULL);
 			pg = clust->pages[clust->nr_pages - 1];
@@ -2175,10 +2170,8 @@ read_some_cluster_pages(struct inode *in
 			off = off_to_pgoff(win->off+win->count+win->delta);
 			if (off) {
 				lock_page(pg);
-				data = kmap_atomic(pg, KM_USER0);
-				memset(data + off, 0, PAGE_CACHE_SIZE - off);
-				flush_dcache_page(pg);
-				kunmap_atomic(data, KM_USER0);
+				zero_user_page(pg, off, PAGE_CACHE_SIZE - off,
+						KM_USER0);
 				unlock_page(pg);
 			}
 		}
@@ -2217,20 +2210,16 @@ read_some_cluster_pages(struct inode *in
 		    (count_to_nrpages(inode->i_size) <= pg->index)) {
 			/* .. and appended,
 			   so set zeroes to the rest */
-			char *data;
 			int offset;
 			lock_page(pg);
-			data = kmap_atomic(pg, KM_USER0);
-
 			assert("edward-1260",
 			       count_to_nrpages(win->off + win->count +
 						win->delta) - 1 == i);
 
 			offset =
 			    off_to_pgoff(win->off + win->count + win->delta);
-			memset(data + offset, 0, PAGE_CACHE_SIZE - offset);
-			flush_dcache_page(pg);
-			kunmap_atomic(data, KM_USER0);
+			zero_user_page(pg, offset, PAGE_CACHE_SIZE - offset,
+					KM_USER0);
 			unlock_page(pg);
 			/* still not uptodate */
 			break;
diff -puN fs/reiser4/plugin/file/file.c~reiser4-use-zero_user_page fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-use-zero_user_page
+++ a/fs/reiser4/plugin/file/file.c
@@ -449,7 +449,6 @@ static int shorten_file(struct inode *in
 	struct page *page;
 	int padd_from;
 	unsigned long index;
-	char *kaddr;
 	unix_file_info_t *uf_info;
 
 	/*
@@ -539,10 +538,7 @@ static int shorten_file(struct inode *in
 
 	lock_page(page);
 	assert("vs-1066", PageLocked(page));
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + padd_from, 0, PAGE_CACHE_SIZE - padd_from);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, padd_from, PAGE_CACHE_SIZE - padd_from, KM_USER0);
 	unlock_page(page);
 	page_cache_release(page);
 	/* the below does up(sbinfo->delete_mutex). Do not get confused */
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-use-zero_user_page fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-use-zero_user_page
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -627,11 +627,7 @@ int do_readpage_ctail(struct inode * ino
 #endif
 	case FAKE_DISK_CLUSTER:
 		/* fill the page by zeroes */
-		data = kmap_atomic(page, KM_USER0);
-
-		memset(data, 0, PAGE_CACHE_SIZE);
-		flush_dcache_page(page);
-		kunmap_atomic(data, KM_USER0);
+		zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
 		SetPageUptodate(page);
 		break;
 	case PREP_DISK_CLUSTER:
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-zero_user_page fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-zero_user_page
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1083,17 +1083,6 @@ ssize_t reiser4_write_extent(struct file
 	return (count - left) ? (count - left) : -EFAULT;
 }
 
-static inline void zero_page(struct page *page)
-{
-	char *kaddr = kmap_atomic(page, KM_USER0);
-
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-	SetPageUptodate(page);
-	unlock_page(page);
-}
-
 int reiser4_do_readpage_extent(reiser4_extent * ext, reiser4_block_nr pos,
 			       struct page *page)
 {
@@ -1115,7 +1104,9 @@ int reiser4_do_readpage_extent(reiser4_e
 		 */
 		j = jfind(mapping, index);
 		if (j == NULL) {
-			zero_page(page);
+			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			SetPageUptodate(page);
+			unlock_page(page);
 			return 0;
 		}
 		spin_lock_jnode(j);
@@ -1128,7 +1119,9 @@ int reiser4_do_readpage_extent(reiser4_e
 		block = *jnode_get_io_block(j);
 		spin_unlock_jnode(j);
 		if (block == 0) {
-			zero_page(page);
+			zero_user_page(page, 0, PAGE_CACHE_SIZE, KM_USER0);
+			SetPageUptodate(page);
+			unlock_page(page);
 			jput(j);
 			return 0;
 		}
diff -puN fs/reiser4/plugin/item/tail.c~reiser4-use-zero_user_page fs/reiser4/plugin/item/tail.c
--- a/fs/reiser4/plugin/item/tail.c~reiser4-use-zero_user_page
+++ a/fs/reiser4/plugin/item/tail.c
@@ -391,12 +391,9 @@ static int do_readpage_tail(uf_coord_t *
 	}
 
  done:
-	if (mapped != PAGE_CACHE_SIZE) {
-		pagedata = kmap_atomic(page, KM_USER0);
-		memset(pagedata + mapped, 0, PAGE_CACHE_SIZE - mapped);
-		flush_dcache_page(page);
-		kunmap_atomic(pagedata, KM_USER0);
-	}
+	if (mapped != PAGE_CACHE_SIZE)
+		zero_user_page(page, mapped, PAGE_CACHE_SIZE - mapped,
+				KM_USER0);
 	SetPageUptodate(page);
  out_unlock_page:
 	unlock_page(page);
_

Patches currently in -mm which might be from nate.diller@gmail.com are

cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
fs-convert-core-functions-to-zero_user_page.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
affs-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
ext3-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ntfs-use-zero_user_page-fix.patch
ocfs2-use-zero_user_page.patch
reiserfs-use-zero_user_page.patch
xfs-use-zero_user_page.patch
fs-deprecate-memclear_highpage_flush.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
reiser4-use-zero_user_page.patch
