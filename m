From: akpm@linux-foundation.org
Subject: + filemap-convert-some-unsigned-long-to-pgoff_t.patch added to -mm tree
Date: Mon, 23 Jul 2007 20:53:26 -0700
Message-ID: <200707240353.l6O3rQcj026900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756769AbXGXDyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 23:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wfg@mail.ustc.edu.cn, rusty@rustcorp.com.au


The patch titled
     filemap: convert some unsigned long to pgoff_t
has been added to the -mm tree.  Its filename is
     filemap-convert-some-unsigned-long-to-pgoff_t.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: filemap: convert some unsigned long to pgoff_t
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Convert some 'unsigned long' to pgoff_t.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   23 ++++++++++++-----------
 mm/filemap.c            |   32 ++++++++++++++++----------------
 2 files changed, 28 insertions(+), 27 deletions(-)

diff -puN include/linux/pagemap.h~filemap-convert-some-unsigned-long-to-pgoff_t include/linux/pagemap.h
--- a/include/linux/pagemap.h~filemap-convert-some-unsigned-long-to-pgoff_t
+++ a/include/linux/pagemap.h
@@ -84,11 +84,11 @@ static inline struct page *page_cache_al
 typedef int filler_t(void *, struct page *);
 
 extern struct page * find_get_page(struct address_space *mapping,
-				unsigned long index);
+				pgoff_t index);
 extern struct page * find_lock_page(struct address_space *mapping,
-				unsigned long index);
+				pgoff_t index);
 extern struct page * find_or_create_page(struct address_space *mapping,
-				unsigned long index, gfp_t gfp_mask);
+				pgoff_t index, gfp_t gfp_mask);
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 			unsigned int nr_pages, struct page **pages);
 unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t start,
@@ -99,41 +99,42 @@ unsigned find_get_pages_tag(struct addre
 /*
  * Returns locked page at given index in given cache, creating it if needed.
  */
-static inline struct page *grab_cache_page(struct address_space *mapping, unsigned long index)
+static inline struct page *grab_cache_page(struct address_space *mapping,
+								pgoff_t index)
 {
 	return find_or_create_page(mapping, index, mapping_gfp_mask(mapping));
 }
 
 extern struct page * grab_cache_page_nowait(struct address_space *mapping,
-				unsigned long index);
+				pgoff_t index);
 extern struct page * read_cache_page_async(struct address_space *mapping,
-				unsigned long index, filler_t *filler,
+				pgoff_t index, filler_t *filler,
 				void *data);
 extern struct page * read_cache_page(struct address_space *mapping,
-				unsigned long index, filler_t *filler,
+				pgoff_t index, filler_t *filler,
 				void *data);
 extern int read_cache_pages(struct address_space *mapping,
 		struct list_head *pages, filler_t *filler, void *data);
 
 static inline struct page *read_mapping_page_async(
 						struct address_space *mapping,
-					     unsigned long index, void *data)
+						     pgoff_t index, void *data)
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
 	return read_cache_page_async(mapping, index, filler, data);
 }
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
-					     unsigned long index, void *data)
+					     pgoff_t index, void *data)
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
 	return read_cache_page(mapping, index, filler, data);
 }
 
 int add_to_page_cache(struct page *page, struct address_space *mapping,
-				unsigned long index, gfp_t gfp_mask);
+				pgoff_t index, gfp_t gfp_mask);
 int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
-				unsigned long index, gfp_t gfp_mask);
+				pgoff_t index, gfp_t gfp_mask);
 extern void remove_from_page_cache(struct page *page);
 extern void __remove_from_page_cache(struct page *page);
 
diff -puN mm/filemap.c~filemap-convert-some-unsigned-long-to-pgoff_t mm/filemap.c
--- a/mm/filemap.c~filemap-convert-some-unsigned-long-to-pgoff_t
+++ a/mm/filemap.c
@@ -593,7 +593,7 @@ void fastcall __lock_page_nosync(struct 
  * Is there a pagecache struct page at the given (mapping, offset) tuple?
  * If yes, increment its refcount and return it; if no, return NULL.
  */
-struct page * find_get_page(struct address_space *mapping, unsigned long offset)
+struct page * find_get_page(struct address_space *mapping, pgoff_t offset)
 {
 	struct page *page;
 
@@ -617,7 +617,7 @@ EXPORT_SYMBOL(find_get_page);
  * Returns zero if the page was not present. find_lock_page() may sleep.
  */
 struct page *find_lock_page(struct address_space *mapping,
-				unsigned long offset)
+				pgoff_t offset)
 {
 	struct page *page;
 
@@ -663,7 +663,7 @@ EXPORT_SYMBOL(find_lock_page);
  * memory exhaustion.
  */
 struct page *find_or_create_page(struct address_space *mapping,
-		unsigned long index, gfp_t gfp_mask)
+		pgoff_t index, gfp_t gfp_mask)
 {
 	struct page *page, *cached_page = NULL;
 	int err;
@@ -797,7 +797,7 @@ EXPORT_SYMBOL(find_get_pages_tag);
  * and deadlock against the caller's locked page.
  */
 struct page *
-grab_cache_page_nowait(struct address_space *mapping, unsigned long index)
+grab_cache_page_nowait(struct address_space *mapping, pgoff_t index)
 {
 	struct page *page = find_get_page(mapping, index);
 
@@ -866,10 +866,10 @@ void do_generic_mapping_read(struct addr
 			     read_actor_t actor)
 {
 	struct inode *inode = mapping->host;
-	unsigned long index;
-	unsigned long offset;
-	unsigned long last_index;
-	unsigned long prev_index;
+	pgoff_t index;
+	pgoff_t last_index;
+	pgoff_t prev_index;
+	unsigned long offset;      /* offset into pagecache page */
 	unsigned int prev_offset;
 	struct page *cached_page;
 	int error;
@@ -883,7 +883,7 @@ void do_generic_mapping_read(struct addr
 
 	for (;;) {
 		struct page *page;
-		unsigned long end_index;
+		pgoff_t end_index;
 		loff_t isize;
 		unsigned long nr, ret;
 
@@ -1238,7 +1238,7 @@ int file_send_actor(read_descriptor_t * 
 
 static ssize_t
 do_readahead(struct address_space *mapping, struct file *filp,
-	     unsigned long index, unsigned long nr)
+	     pgoff_t index, unsigned long nr)
 {
 	if (!mapping || !mapping->a_ops || !mapping->a_ops->readpage)
 		return -EINVAL;
@@ -1258,8 +1258,8 @@ asmlinkage ssize_t sys_readahead(int fd,
 	if (file) {
 		if (file->f_mode & FMODE_READ) {
 			struct address_space *mapping = file->f_mapping;
-			unsigned long start = offset >> PAGE_CACHE_SHIFT;
-			unsigned long end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
+			pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
 			unsigned long len = end - start + 1;
 			ret = do_readahead(mapping, file, start, len);
 		}
@@ -1277,7 +1277,7 @@ asmlinkage ssize_t sys_readahead(int fd,
  * This adds the requested page to the page cache if it isn't already there,
  * and schedules an I/O to read in its contents from disk.
  */
-static int fastcall page_cache_read(struct file * file, unsigned long offset)
+static int fastcall page_cache_read(struct file * file, pgoff_t offset)
 {
 	struct address_space *mapping = file->f_mapping;
 	struct page *page; 
@@ -1517,7 +1517,7 @@ EXPORT_SYMBOL(generic_file_mmap);
 EXPORT_SYMBOL(generic_file_readonly_mmap);
 
 static struct page *__read_cache_page(struct address_space *mapping,
-				unsigned long index,
+				pgoff_t index,
 				int (*filler)(void *,struct page*),
 				void *data)
 {
@@ -1558,7 +1558,7 @@ repeat:
  * after submitting it to the filler.
  */
 struct page *read_cache_page_async(struct address_space *mapping,
-				unsigned long index,
+				pgoff_t index,
 				int (*filler)(void *,struct page*),
 				void *data)
 {
@@ -1606,7 +1606,7 @@ EXPORT_SYMBOL(read_cache_page_async);
  * If the page does not get brought uptodate, return -EIO.
  */
 struct page *read_cache_page(struct address_space *mapping,
-				unsigned long index,
+				pgoff_t index,
 				int (*filler)(void *,struct page*),
 				void *data)
 {
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-compacting-file_ra_state.patch
readahead-mmap-read-around-simplification.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
radixtree-introduce-radix_tree_scan_hole.patch
readahead-basic-support-of-interleaved-reads.patch
readahead-remove-the-local-copy-of-ra-in-do_generic_mapping_read.patch
readahead-remove-several-readahead-macros.patch
readahead-remove-the-limit-max_sectors_kb-imposed-on-max_readahead_kb.patch
filemap-trivial-code-cleanups.patch
filemap-convert-some-unsigned-long-to-pgoff_t.patch
convert-ill-defined-log2-to-ilog2.patch
