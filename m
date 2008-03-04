From: akpm@linux-foundation.org
Subject: - use-page_cache_xxx-in-fs-splicec.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:47:33 -0800
Message-ID: <200803041947.m24JlXqs025675@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941AbYCDTtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:49:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Use page_cache_xxx in fs/splice.c
has been removed from the -mm tree.  Its filename was
     use-page_cache_xxx-in-fs-splicec.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in fs/splice.c
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx in fs/splice.c

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN fs/splice.c~use-page_cache_xxx-in-fs-splicec fs/splice.c
--- a/fs/splice.c~use-page_cache_xxx-in-fs-splicec
+++ a/fs/splice.c
@@ -286,9 +286,9 @@ __generic_file_splice_read(struct file *
 		.spd_release = spd_release_page,
 	};
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
-	loff = *ppos & ~PAGE_CACHE_MASK;
-	req_pages = (len + loff + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
+	loff = page_cache_offset(mapping, *ppos);
+	req_pages = page_cache_next(mapping, len + loff);
 	nr_pages = min(req_pages, (unsigned)PIPE_BUFFERS);
 
 	/*
@@ -343,7 +343,7 @@ __generic_file_splice_read(struct file *
 	 * Now loop over the map and see if we need to start IO on any
 	 * pages, fill in the partial map, etc.
 	 */
-	index = *ppos >> PAGE_CACHE_SHIFT;
+	index = page_cache_index(mapping, *ppos);
 	nr_pages = spd.nr_pages;
 	spd.nr_pages = 0;
 	for (page_nr = 0; page_nr < nr_pages; page_nr++) {
@@ -355,7 +355,8 @@ __generic_file_splice_read(struct file *
 		/*
 		 * this_len is the max we'll use from this page
 		 */
-		this_len = min_t(unsigned long, len, PAGE_CACHE_SIZE - loff);
+		this_len = min_t(unsigned long, len,
+					page_cache_size(mapping) - loff);
 		page = pages[page_nr];
 
 		if (PageReadahead(page))
@@ -415,7 +416,7 @@ fill_it:
 		 * i_size must be checked after PageUptodate.
 		 */
 		isize = i_size_read(mapping->host);
-		end_index = (isize - 1) >> PAGE_CACHE_SHIFT;
+		end_index = page_cache_index(mapping, isize - 1);
 		if (unlikely(!isize || index > end_index))
 			break;
 
@@ -429,7 +430,7 @@ fill_it:
 			/*
 			 * max good bytes in this page
 			 */
-			plen = ((isize - 1) & ~PAGE_CACHE_MASK) + 1;
+			plen = page_cache_offset(mapping, isize - 1) + 1;
 			if (plen <= loff)
 				break;
 
@@ -454,7 +455,7 @@ fill_it:
 	 */
 	while (page_nr < nr_pages)
 		page_cache_release(pages[page_nr++]);
-	in->f_ra.prev_pos = (loff_t)index << PAGE_CACHE_SHIFT;
+	in->f_ra.prev_pos = page_cache_pos(mapping, index, 0);
 
 	if (spd.nr_pages)
 		return splice_to_pipe(pipe, &spd);
@@ -580,11 +581,11 @@ static int pipe_to_file(struct pipe_inod
 	if (unlikely(ret))
 		return ret;
 
-	offset = sd->pos & ~PAGE_CACHE_MASK;
+	offset = page_cache_offset(mapping, sd->pos);
 
 	this_len = sd->len;
-	if (this_len + offset > PAGE_CACHE_SIZE)
-		this_len = PAGE_CACHE_SIZE - offset;
+	if (this_len + offset > page_cache_size(mapping))
+		this_len = page_cache_size(mapping) - offset;
 
 	ret = pagecache_write_begin(file, mapping, sd->pos, this_len,
 				AOP_FLAG_UNINTERRUPTIBLE, &page, &fsdata);
@@ -791,7 +792,7 @@ generic_file_splice_write_nolock(struct 
 		unsigned long nr_pages;
 
 		*ppos += ret;
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		nr_pages = page_cache_next(mapping, ret);
 
 		/*
 		 * If file or inode is SYNC and we actually wrote some data,
@@ -853,7 +854,7 @@ generic_file_splice_write(struct pipe_in
 		unsigned long nr_pages;
 
 		*ppos += ret;
-		nr_pages = (ret + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		nr_pages = page_cache_next(mapping, ret);
 
 		/*
 		 * If file or inode is SYNC and we actually wrote some data,
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
use-page_cache_xxx-in-fs-splicec.patch
git-unionfs.patch
use-page_cache_xxx-for-fs-xfs.patch
git-slub.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
ntfs-fix-nommu-build.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
use-page_cache_xxx-functions-in-mm-filemapc.patch
use-page_cache_xxx-in-mm-page-writebackc.patch
use-page_cache_xxx-in-mm-truncatec.patch
use-page_cache_xxx-in-mm-rmapc.patch
use-page_cache_xxx-in-mm-filemap_xipc.patch
use-page_cache_xxx-in-mm-migratec.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
mm-move-cache_line_size-to-linux-cacheh.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-ext2-fix.patch
use-page_cache_xxx-in-ext2-fix-2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

