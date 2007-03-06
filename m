From: akpm@linux-foundation.org
Subject: - reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:31 -0800
Message-ID: <200703060200.l2620Vng008735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965690AbXCFCAj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, zam@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: fix readpages cryptcompress
has been removed from the -mm tree.  Its filename was
     reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: fix readpages cryptcompress
From: Edward Shishkin <edward@namesys.com>

. Use generic populate routine read_cache_pages() for
  readpages_cryptcompress();
. Fix oopsed debugging code;
. Convert cryptcompress to unix-files with notail policy only;
. Toughen the criterion of compressibility for conversion.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Cc: Alexander Zarochentsev <zam@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/plugin/cluster.h              |   10 -
 fs/reiser4/plugin/file/cryptcompress.c   |   11 +-
 fs/reiser4/plugin/file/cryptcompress.h   |    1 
 fs/reiser4/plugin/file/file_conversion.c |   18 ++-
 fs/reiser4/plugin/item/ctail.c           |  109 +++++++--------------
 5 files changed, 64 insertions(+), 85 deletions(-)

diff -puN fs/reiser4/plugin/cluster.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress fs/reiser4/plugin/cluster.h
--- a/fs/reiser4/plugin/cluster.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress
+++ a/fs/reiser4/plugin/cluster.h
@@ -282,15 +282,15 @@ void tfm_cluster_clr_uptodate(tfm_cluste
 /* move cluster handle to the target position
    specified by the page of index @pgidx
 */
-static inline void
-move_cluster_forward(reiser4_cluster_t * clust, struct inode *inode,
-		     pgoff_t pgidx, int *progress)
+static inline void move_cluster_forward(reiser4_cluster_t * clust,
+					struct inode *inode,
+					pgoff_t pgidx)
 {
 	assert("edward-1297", clust != NULL);
 	assert("edward-1298", inode != NULL);
 
 	reset_cluster_params(clust);
-	if (*progress &&
+	if (clust->index_valid &&
 	    /* Hole in the indices. Hint became invalid and can not be
 	       used by find_cluster_item() even if seal/node versions
 	       will coincide */
@@ -298,8 +298,8 @@ move_cluster_forward(reiser4_cluster_t *
 		reiser4_unset_hint(clust->hint);
 		invalidate_hint_cluster(clust);
 	}
-	*progress = 1;
 	clust->index = pg_to_clust(pgidx, inode);
+	clust->index_valid = 1;
 }
 
 static inline int
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -2482,8 +2482,11 @@ prepare_cluster(struct inode *inode,
 	result = prepare_page_cluster(inode, clust, 1);
 	if (result)
 		return result;
-	assert("edward-1447", jprivate(clust->pages[0]));
-	assert("edward-1448", jnode_is_cluster_page(jprivate(clust->pages[0])));
+	assert("edward-1447",
+	       ergo(clust->nr_pages != 0, jprivate(clust->pages[0])));
+	assert("edward-1448",
+	       ergo(clust->nr_pages != 0,
+		    jnode_is_cluster_page(jprivate(clust->pages[0]))));
 
 	result = reserve4cluster(inode, clust);
 	if (result)
@@ -3481,7 +3484,6 @@ capture_anonymous_clusters(struct addres
 {
 	int result = 0;
 	int found;
-	int progress = 0;
 	struct page *page = NULL;
 	hint_t *hint;
 	lock_handle *lh;
@@ -3514,8 +3516,7 @@ capture_anonymous_clusters(struct addres
 		}
 		assert("edward-1109", page != NULL);
 
-		move_cluster_forward(&clust, mapping->host, page->index,
-				     &progress);
+		move_cluster_forward(&clust, mapping->host, page->index);
 		result = capture_page_cluster(&clust, mapping->host);
 		page_cache_release(page);
 		if (result)
diff -puN fs/reiser4/plugin/file/cryptcompress.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress fs/reiser4/plugin/file/cryptcompress.h
--- a/fs/reiser4/plugin/file/cryptcompress.h~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress
+++ a/fs/reiser4/plugin/file/cryptcompress.h
@@ -369,6 +369,7 @@ typedef struct reiser4_cluster {
 	hint_t *hint;		/* disk cluster item for traversal */
 	disk_cluster_stat dstat;	/* state of the current disk cluster */
 	cloff_t index;		/* offset in the units of cluster size */
+	int index_valid;        /* to validate the index above, if needed */
 	reiser4_slide_t *win;	/* sliding window of cluster size */
 	int reserved;		/* this indicates that space for disk
 				   cluster modification is reserved */
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -115,7 +115,7 @@
 	_result;							\
 })
 
-/* Pass management to the unix file plugin */
+/* Pass management to the unix-file plugin with "notail" policy */
 static int __cryptcompress2unixfile(struct file *file, struct inode * inode)
 {
 	int result;
@@ -123,8 +123,16 @@ static int __cryptcompress2unixfile(stru
 	unix_file_info_t * uf;
 	info = reiser4_inode_data(inode);
 
-	result = aset_set_unsafe(&info->pset, PSET_FILE, (reiser4_plugin *)
-				 file_plugin_by_id(UNIX_FILE_PLUGIN_ID));
+	result = aset_set_unsafe(&info->pset,
+			    PSET_FILE,
+			    (reiser4_plugin *)
+			    file_plugin_by_id(UNIX_FILE_PLUGIN_ID));
+	if (result)
+		return result;
+	result = aset_set_unsafe(&info->pset,
+			    PSET_FORMATTING,
+			    (reiser4_plugin *)
+			    formatting_plugin_by_id(NEVER_TAILS_FORMATTING_ID));
 	if (result)
 		return result;
 	/* get rid of non-standard plugins */
@@ -252,10 +260,10 @@ int prepped_dclust_ok(hint_t * hint)
 }
 #endif
 
-#define thirty_persent(size) ((307 * size) >> 10)
+#define fifty_persent(size) (size >> 1)
 /* evaluation of data compressibility */
 #define data_is_compressible(osize, isize)		\
-	(osize < (isize - thirty_persent(isize)))
+	(osize < fifty_persent(isize))
 
 /* This is called only once per file life.
    Read first logical cluster (of index #0) and estimate its compressibility.
diff -puN fs/reiser4/plugin/item/ctail.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress fs/reiser4/plugin/item/ctail.c
--- a/fs/reiser4/plugin/item/ctail.c~reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress
+++ a/fs/reiser4/plugin/item/ctail.c
@@ -722,34 +722,45 @@ ctail_read_page_cluster(reiser4_cluster_
 	return result;
 }
 
-#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
-#define list_to_next_page(head) (list_entry((head)->prev->prev, struct page, lru))
+/* filler for read_cache_pages() */
+static int ctail_readpages_filler(void * data, struct page * page)
+{
+	int ret = 0;
+	reiser4_cluster_t * clust = data;
+	struct inode * inode = clust->file->f_dentry->d_inode;
+
+	if (PageUptodate(page)) {
+		unlock_page(page);
+		return 0;
+	}
+	unlock_page(page);
+	move_cluster_forward(clust, inode, page->index);
+	ret = ctail_read_page_cluster(clust, inode);
+	if (ret)
+		return ret;
+	assert("edward-869", !tfm_cluster_is_uptodate(&clust->tc));
+
+	lock_page(page);
+	ret = do_readpage_ctail(inode, clust, page, ZNODE_READ_LOCK);
+	assert("edward-1061", ergo(!ret, PageUptodate(page)));
+	unlock_page(page);
 
-#if REISER4_DEBUG
-#define check_order(pages)                                                    \
-assert("edward-214", ergo(!list_empty(pages) && pages->next != pages->prev,   \
-       list_to_page(pages)->index < list_to_next_page(pages)->index))
-#endif
-
-/* Populate an address space with some page clusters,
- * and start reads against them.
- */
+	return ret;
+}
+
+/* We populate a bit more then upper readahead suggests:
+   with each nominated page we read the whole page cluster
+   this page belongs to. */
 int readpages_ctail(struct file *file, struct address_space *mapping,
 		    struct list_head *pages)
 {
 	int ret = 0;
 	hint_t *hint;
 	reiser4_cluster_t clust;
-	struct page *page;
-	struct pagevec lru_pvec;
 	struct inode *inode = mapping->host;
-	int progress = 0;
 
-	assert("edward-214", ergo(!list_empty(pages) &&
-				  pages->next != pages->prev,
-				  list_to_page(pages)->index <
-				  list_to_next_page(pages)->index));
-	pagevec_init(&lru_pvec, 0);
+	assert("edward-1521", inode == file->f_dentry->d_inode);
+
 	cluster_init_read(&clust, NULL);
 	clust.file = file;
 	hint = kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
@@ -760,69 +771,27 @@ int readpages_ctail(struct file *file, s
 	}
 	clust.hint = hint;
 	ret = load_file_hint(clust.file, hint);
-	if (ret)
+	if (ret) {
+		warning("edward-1522", "failed to load hint");
 		goto exit2;
+	}
+	assert("vs-26", hint->ext_coord.lh == &hint->lh);
 	ret = alloc_cluster_pgset(&clust, cluster_nrpages(inode));
-	if (ret)
+	if (ret) {
+		warning("edward-1523", "failed to alloc pgset");
 		goto exit3;
-	assert("vs-26", hint->ext_coord.lh == &hint->lh);
-
-	/* address_space-level file readahead doesn't know about
-	   reiser4 concept of clustering, so we work around this
-	   fact: with each page of the list @pages address space
-	   will be populated with the whole page cluster.
-	*/
-	while (!list_empty(pages)) {
-		page = list_to_page(pages);
-		list_del(&page->lru);
-		if (add_to_page_cache(page, mapping, page->index,
-				      reiser4_ctx_gfp_mask_get())) {
-			page_cache_release(page);
-			continue;
-		}
-		if (PageUptodate(page)) {
-			if (!pagevec_add(&lru_pvec, page))
-				__pagevec_lru_add(&lru_pvec);
-			unlock_page(page);
-			continue;
-		}
-		unlock_page(page);
-
-		move_cluster_forward(&clust, inode, page->index, &progress);
-		ret = ctail_read_page_cluster(&clust, inode);
-		if (ret)
-			break;
-		assert("edward-869", !tfm_cluster_is_uptodate(&clust.tc));
-		lock_page(page);
-
-		ret = do_readpage_ctail(inode, &clust, page, ZNODE_READ_LOCK);
-		if (!pagevec_add(&lru_pvec, page))
-			__pagevec_lru_add(&lru_pvec);
-		if (ret) {
-			warning("edward-215", "do_readpage_ctail failed");
-			unlock_page(page);
-			break;
-		}
-		assert("edward-1061", PageUptodate(page));
-
-		unlock_page(page);
 	}
+	ret = read_cache_pages(mapping, pages, ctail_readpages_filler, &clust);
+
 	assert("edward-870", !tfm_cluster_is_uptodate(&clust.tc));
  exit3:
 	done_lh(&hint->lh);
-	save_file_hint(clust.file, hint);
+	save_file_hint(file, hint);
 	hint->ext_coord.valid = 0;
  exit2:
 	kfree(hint);
  exit1:
-	while (!list_empty(pages)) {
-		struct page *victim;
-		victim = list_to_page(pages);
-		list_del(&victim->lru);
-		page_cache_release(victim);
-	}
 	put_cluster_handle(&clust);
-	pagevec_lru_add(&lru_pvec);
 	return ret;
 }
 
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-format-subversion-numbers-heir-set-and-file-conversion-fix-readpages-cryptcompress.patch
reiser4-cleanups-in-lzo-compression-library.patch
reiser4-get-rid-of-deprecated-crypto-api.patch
reiser4-get-rid-of-deprecated-crypto-api-build-fix.patch
reiser4-fix-missed-unlock-and-exit_context.patch
reiser4-use-list_head-instead-of-struct-blocknr.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
