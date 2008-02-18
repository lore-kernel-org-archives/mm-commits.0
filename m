From: akpm@linux-foundation.org
Subject: + use-page_cache_xxx-in-fs-splicec.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:04:56 -0800
Message-ID: <200802181005.m1IA5sU7019228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbYBRKHB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 05:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, dgc@sgi.com, jens.axboe@oracle.com


The patch titled
     Use page_cache_xxx in fs/splice.c
has been added to the -mm tree.  Its filename is
     use-page_cache_xxx-in-fs-splicec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

define-functions-for-page-cache-handling.patch
gregkh-driver-kset-move-sys-slab-to-sys-kernel-slab-slabinfo-fallback-from-sys-kernel-slab-to-sys-slab.patch
use-page_cache_xxx-in-fs-splicec.patch
git-unionfs.patch
use-page_cache_xxx-for-fs-xfs.patch
git-slub.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
remove-set_migrateflags.patch
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
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
