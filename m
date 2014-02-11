From: akpm@linux-foundation.org
Subject: + mm-remove-read_cache_page_async.patch added to -mm tree
Date: Tue, 11 Feb 2014 12:41:51 -0800
Message-ID: <52fa8b0f.k6K/FxhzqCOXNYF5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaBKUlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 15:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com

Subject: + mm-remove-read_cache_page_async.patch added to -mm tree
To: sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 12:41:51 -0800


The patch titled
     Subject: mm: remove read_cache_page_async()
has been added to the -mm tree.  Its filename is
     mm-remove-read_cache_page_async.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-read_cache_page_async.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-read_cache_page_async.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: remove read_cache_page_async()

This patch removes read_cache_page_async() which wasn't really needed
anywhere and simplifies the code around it a bit.

read_cache_page_async() is useful when we want to read a page into the
cache without waiting for it to complete.  This happens when the
appropriate callback 'filler' doesn't complete its read operation and
releases the page lock immediately, and instead queues a different
completion routine to do that.  This never actually happened anywhere in
the code.

read_cache_page_async() had 3 different callers:

- read_cache_page() which is the sync version, it would just wait for
  the requested read to complete using wait_on_page_read().

- JFFS2 would call it from jffs2_gc_fetch_page(), but the filler
  function it supplied doesn't do any async reads, and would complete
  before the filler function returns - making it actually a sync read.

- CRAMFS would call it using the read_mapping_page_async() wrapper, with
  a similar story to JFFS2 - the filler function doesn't do anything that
  reminds async reads and would always complete before the filler function
  returns.

To sum it up, the code in mm/filemap.c never took advantage of having
read_cache_page_async().  While there are filler callbacks that do async
reads (such as the block one), we always called it with the
read_cache_page().

This patch adds a mandatory wait for read to complete when adding a new
page to the cache, and removes read_cache_page_async() and its wrappers.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c       |    3 -
 fs/jffs2/fs.c           |    2 -
 include/linux/pagemap.h |   10 -----
 mm/filemap.c            |   64 +++++++++++++-------------------------
 4 files changed, 25 insertions(+), 54 deletions(-)

diff -puN fs/cramfs/inode.c~mm-remove-read_cache_page_async fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~mm-remove-read_cache_page_async
+++ a/fs/cramfs/inode.c
@@ -195,8 +195,7 @@ static void *cramfs_read(struct super_bl
 		struct page *page = NULL;
 
 		if (blocknr + i < devsize) {
-			page = read_mapping_page_async(mapping, blocknr + i,
-									NULL);
+			page = read_mapping_page(mapping, blocknr + i, NULL);
 			/* synchronous error? */
 			if (IS_ERR(page))
 				page = NULL;
diff -puN fs/jffs2/fs.c~mm-remove-read_cache_page_async fs/jffs2/fs.c
--- a/fs/jffs2/fs.c~mm-remove-read_cache_page_async
+++ a/fs/jffs2/fs.c
@@ -690,7 +690,7 @@ unsigned char *jffs2_gc_fetch_page(struc
 	struct inode *inode = OFNI_EDONI_2SFFJ(f);
 	struct page *pg;
 
-	pg = read_cache_page_async(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
+	pg = read_cache_page(inode->i_mapping, offset >> PAGE_CACHE_SHIFT,
 			     (void *)jffs2_do_readpage_unlock, inode);
 	if (IS_ERR(pg))
 		return (void *)pg;
diff -puN include/linux/pagemap.h~mm-remove-read_cache_page_async include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-remove-read_cache_page_async
+++ a/include/linux/pagemap.h
@@ -289,8 +289,6 @@ static inline struct page *grab_cache_pa
 
 extern struct page * grab_cache_page_nowait(struct address_space *mapping,
 				pgoff_t index);
-extern struct page * read_cache_page_async(struct address_space *mapping,
-				pgoff_t index, filler_t *filler, void *data);
 extern struct page * read_cache_page(struct address_space *mapping,
 				pgoff_t index, filler_t *filler, void *data);
 extern struct page * read_cache_page_gfp(struct address_space *mapping,
@@ -298,14 +296,6 @@ extern struct page * read_cache_page_gfp
 extern int read_cache_pages(struct address_space *mapping,
 		struct list_head *pages, filler_t *filler, void *data);
 
-static inline struct page *read_mapping_page_async(
-				struct address_space *mapping,
-				pgoff_t index, void *data)
-{
-	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
-	return read_cache_page_async(mapping, index, filler, data);
-}
-
 static inline struct page *read_mapping_page(struct address_space *mapping,
 				pgoff_t index, void *data)
 {
diff -puN mm/filemap.c~mm-remove-read_cache_page_async mm/filemap.c
--- a/mm/filemap.c~mm-remove-read_cache_page_async
+++ a/mm/filemap.c
@@ -2130,6 +2130,18 @@ int generic_file_readonly_mmap(struct fi
 EXPORT_SYMBOL(generic_file_mmap);
 EXPORT_SYMBOL(generic_file_readonly_mmap);
 
+static struct page *wait_on_page_read(struct page *page)
+{
+	if (!IS_ERR(page)) {
+		wait_on_page_locked(page);
+		if (!PageUptodate(page)) {
+			page_cache_release(page);
+			page = ERR_PTR(-EIO);
+		}
+	}
+	return page;
+}
+
 static struct page *__read_cache_page(struct address_space *mapping,
 				pgoff_t index,
 				int (*filler)(void *, struct page *),
@@ -2156,6 +2168,8 @@ repeat:
 		if (err < 0) {
 			page_cache_release(page);
 			page = ERR_PTR(err);
+		} else {
+			page = wait_on_page_read(page);
 		}
 	}
 	return page;
@@ -2192,6 +2206,10 @@ retry:
 	if (err < 0) {
 		page_cache_release(page);
 		return ERR_PTR(err);
+	} else {
+		page = wait_on_page_read(page);
+		if (IS_ERR(page))
+			return page;
 	}
 out:
 	mark_page_accessed(page);
@@ -2199,40 +2217,25 @@ out:
 }
 
 /**
- * read_cache_page_async - read into page cache, fill it if needed
+ * read_cache_page - read into page cache, fill it if needed
  * @mapping:	the page's address_space
  * @index:	the page index
  * @filler:	function to perform the read
  * @data:	first arg to filler(data, page) function, often left as NULL
  *
- * Same as read_cache_page, but don't wait for page to become unlocked
- * after submitting it to the filler.
- *
  * Read into the page cache. If a page already exists, and PageUptodate() is
- * not set, try to fill the page but don't wait for it to become unlocked.
+ * not set, try to fill the page and wait for it to become unlocked.
  *
  * If the page does not get brought uptodate, return -EIO.
  */
-struct page *read_cache_page_async(struct address_space *mapping,
+struct page *read_cache_page(struct address_space *mapping,
 				pgoff_t index,
 				int (*filler)(void *, struct page *),
 				void *data)
 {
 	return do_read_cache_page(mapping, index, filler, data, mapping_gfp_mask(mapping));
 }
-EXPORT_SYMBOL(read_cache_page_async);
-
-static struct page *wait_on_page_read(struct page *page)
-{
-	if (!IS_ERR(page)) {
-		wait_on_page_locked(page);
-		if (!PageUptodate(page)) {
-			page_cache_release(page);
-			page = ERR_PTR(-EIO);
-		}
-	}
-	return page;
-}
+EXPORT_SYMBOL(read_cache_page);
 
 /**
  * read_cache_page_gfp - read into page cache, using specified page allocation flags.
@@ -2251,31 +2254,10 @@ struct page *read_cache_page_gfp(struct
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
 
-	return wait_on_page_read(do_read_cache_page(mapping, index, filler, NULL, gfp));
+	return do_read_cache_page(mapping, index, filler, NULL, gfp);
 }
 EXPORT_SYMBOL(read_cache_page_gfp);
 
-/**
- * read_cache_page - read into page cache, fill it if needed
- * @mapping:	the page's address_space
- * @index:	the page index
- * @filler:	function to perform the read
- * @data:	first arg to filler(data, page) function, often left as NULL
- *
- * Read into the page cache. If a page already exists, and PageUptodate() is
- * not set, try to fill the page then wait for it to become unlocked.
- *
- * If the page does not get brought uptodate, return -EIO.
- */
-struct page *read_cache_page(struct address_space *mapping,
-				pgoff_t index,
-				int (*filler)(void *, struct page *),
-				void *data)
-{
-	return wait_on_page_read(read_cache_page_async(mapping, index, filler, data));
-}
-EXPORT_SYMBOL(read_cache_page);
