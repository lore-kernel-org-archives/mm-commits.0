From: akpm@linux-foundation.org
Subject: + reiser4-use-set_page_dirty_notag.patch added to -mm tree
Date: Tue, 17 Feb 2009 14:41:02 -0800
Message-ID: <200902172241.n1HMf2hO025102@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753571AbZBQWlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 17:41:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward.shishkin@gmail.com


The patch titled
     reiser4: use set_page_dirty_notag()
has been added to the -mm tree.  Its filename is
     reiser4-use-set_page_dirty_notag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: use set_page_dirty_notag()
From: Edward Shishkin <edward.shishkin@gmail.com>

Use the core library functions set_page_dirty_notag() and
__set_page_dirty_nobuffers() instead of intenal reiser4_set_page_dirty().

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/as_ops.c                      |   31 +++------------------
 fs/reiser4/entd.c                        |    2 -
 fs/reiser4/page_cache.c                  |   21 --------------
 fs/reiser4/page_cache.h                  |    2 -
 fs/reiser4/plugin/file/cryptcompress.c   |    6 ++--
 fs/reiser4/plugin/file/file.c            |   12 +-------
 fs/reiser4/plugin/item/extent_file_ops.c |    2 -
 fs/reiser4/txnmgr.c                      |    2 -
 fs/reiser4/wander.c                      |    9 +++---
 9 files changed, 18 insertions(+), 69 deletions(-)

diff -puN fs/reiser4/as_ops.c~reiser4-use-set_page_dirty_notag fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/as_ops.c
@@ -67,33 +67,12 @@ int reiser4_set_page_dirty(struct page *
 	assert("vs-1734", (page->mapping &&
 			   page->mapping->host &&
 			   reiser4_get_super_fake(page->mapping->host->i_sb) !=
-			   page->mapping->host
-			   && reiser4_get_cc_fake(page->mapping->host->i_sb) !=
-			   page->mapping->host
-			   && reiser4_get_bitmap_fake(page->mapping->host->i_sb) !=
+			   page->mapping->host &&
+			   reiser4_get_cc_fake(page->mapping->host->i_sb) !=
+			   page->mapping->host &&
+			   reiser4_get_bitmap_fake(page->mapping->host->i_sb) !=
 			   page->mapping->host));
-
-	if (!TestSetPageDirty(page)) {
-		struct address_space *mapping = page->mapping;
-
-		if (mapping) {
-			spin_lock_irq(&mapping->tree_lock);
-
-			/* check for race with truncate */
-			if (page->mapping) {
-				assert("vs-1652", page->mapping == mapping);
-				if (mapping_cap_account_dirty(mapping))
-					inc_zone_page_state(page,
-							NR_FILE_DIRTY);
-				radix_tree_tag_set(&mapping->page_tree,
-						   page->index,
-						   PAGECACHE_TAG_REISER4_MOVED);
-			}
-			spin_unlock_irq(&mapping->tree_lock);
-			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-		}
-	}
-	return 0;
+	return __set_page_dirty_nobuffers(page);
 }
 
 /* ->invalidatepage method for reiser4 */
diff -puN fs/reiser4/entd.c~reiser4-use-set_page_dirty_notag fs/reiser4/entd.c
--- a/fs/reiser4/entd.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/entd.c
@@ -277,7 +277,7 @@ int write_page_by_ent(struct page *page,
 	 * page. Re-dirty page before unlocking so that if ent thread fails to
 	 * write it - it will remain dirty
 	 */
-	reiser4_set_page_dirty_internal(page);
+	set_page_dirty_notag(page);
 
 	/*
 	 * pin inode in memory, unlock page, entd_flush will iput. We can not
diff -puN fs/reiser4/page_cache.c~reiser4-use-set_page_dirty_notag fs/reiser4/page_cache.c
--- a/fs/reiser4/page_cache.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/page_cache.c
@@ -458,27 +458,6 @@ static struct bio *page_bio(struct page 
 		return ERR_PTR(RETERR(-ENOMEM));
 }
 
-/* this function is internally called by jnode_make_dirty() */
-int reiser4_set_page_dirty_internal(struct page *page)
-{
-	struct address_space *mapping;
-
-	mapping = page->mapping;
-	BUG_ON(mapping == NULL);
-
-	if (!TestSetPageDirty(page)) {
-		if (mapping_cap_account_dirty(mapping))
-			inc_zone_page_state(page, NR_FILE_DIRTY);
-
-		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-	}
-
-	/* znode must be dirty ? */
-	if (mapping->host == reiser4_get_super_fake(mapping->host->i_sb))
-		assert("", JF_ISSET(jprivate(page), JNODE_DIRTY));
-	return 0;
-}
-
 #if 0
 static int can_hit_entd(reiser4_context *ctx, struct super_block *s)
 {
diff -puN fs/reiser4/page_cache.h~reiser4-use-set_page_dirty_notag fs/reiser4/page_cache.h
--- a/fs/reiser4/page_cache.h~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/page_cache.h
@@ -18,8 +18,6 @@ extern void reiser4_done_formatted_fake(
 
 extern reiser4_tree *reiser4_tree_by_page(const struct page *);
 
-extern int reiser4_set_page_dirty_internal(struct page *);
-
 #define reiser4_submit_bio(rw, bio) submit_bio((rw), (bio))
 
 extern void reiser4_wait_page_writeback(struct page *);
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-set_page_dirty_notag fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -1260,7 +1260,7 @@ static void set_cluster_pages_dirty(stru
 		assert("edward-968", pg != NULL);
 		lock_page(pg);
 		assert("edward-1065", PageUptodate(pg));
-		reiser4_set_page_dirty_internal(pg);
+		set_page_dirty_notag(pg);
 		unlock_page(pg);
 		mark_page_accessed(pg);
 	}
@@ -2027,7 +2027,7 @@ static int write_hole(struct inode *inod
 		lock_page(page);
 		zero_user(page, pg_off, to_pg);
 		SetPageUptodate(page);
-		reiser4_set_page_dirty_internal(page);
+		set_page_dirty_notag(page);
 		mark_page_accessed(page);
 		unlock_page(page);
 
@@ -2747,7 +2747,7 @@ static loff_t do_write_cryptcompress(str
 				goto err2;
 			}
 			SetPageUptodate(clust.pages[i]);
-			reiser4_set_page_dirty_internal(clust.pages[i]);
+			set_page_dirty_notag(clust.pages[i]);
 			flush_dcache_page(clust.pages[i]);
 			mark_page_accessed(clust.pages[i]);
 			unlock_page(clust.pages[i]);
diff -puN fs/reiser4/plugin/file/file.c~reiser4-use-set_page_dirty_notag fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/plugin/file/file.c
@@ -912,12 +912,9 @@ int write_end_unix_file(struct file *fil
  *
  * As a result of (3) ->writepage may be called on a dirty page without
  * jnode. Such page is called "anonymous" in reiser4. Certain work-loads
- * (iozone) generate huge number of anonymous pages. Emergency flush handles
- * this situation by creating jnode for anonymous page, starting IO on the
- * page, and marking jnode with JNODE_KEEPME bit so that it's not thrown out of
- * memory. Such jnode is also called anonymous.
+ * (iozone) generate huge number of anonymous pages.
  *
- * reiser4_sync_sb() method tries to insert anonymous pages and jnodes into
+ * reiser4_sync_sb() method tries to insert anonymous pages into
  * tree. This is done by capture_anonymous_*() functions below.
  */
 
@@ -996,11 +993,6 @@ capture_anonymous_pages(struct address_s
 	*index = pvec.pages[i - 1]->index + 1;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
-		/*
-		 * tag PAGECACHE_TAG_REISER4_MOVED will be cleared by
-		 * reiser4_set_page_dirty_internal which is called when jnode is
-		 * captured
-		 */
 		result = capture_anonymous_page(pvec.pages[i]);
 		if (result == 1)
 			nr++;
diff -puN fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-set_page_dirty_notag fs/reiser4/plugin/item/extent_file_ops.c
--- a/fs/reiser4/plugin/item/extent_file_ops.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/plugin/item/extent_file_ops.c
@@ -1073,7 +1073,7 @@ ssize_t reiser4_write_extent(struct file
 		}
 
 		flush_dcache_page(page);
-		reiser4_set_page_dirty_internal(page);
+		set_page_dirty_notag(page);
 		unlock_page(page);
 		nr_dirty++;
 
diff -puN fs/reiser4/txnmgr.c~reiser4-use-set_page_dirty_notag fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/txnmgr.c
@@ -2426,7 +2426,7 @@ void znode_make_dirty(znode * z)
 		spin_unlock_jnode(node);
 		/* reiser4 file write code calls set_page_dirty for
 		 * unformatted nodes, for formatted nodes we do it here. */
-		reiser4_set_page_dirty_internal(page);
+		set_page_dirty_notag(page);
 		page_cache_release(page);
 		/* bump version counter in znode */
 		z->version = znode_build_version(jnode_get_tree(node));
diff -puN fs/reiser4/wander.c~reiser4-use-set_page_dirty_notag fs/reiser4/wander.c
--- a/fs/reiser4/wander.c~reiser4-use-set_page_dirty_notag
+++ a/fs/reiser4/wander.c
@@ -16,10 +16,11 @@
    This code guarantees that those blocks that are defined to be part of an
    atom either all take effect or none of them take effect.
 
-   Relocate set nodes are submitted to write by the jnode_flush() routine, and
-   the overwrite set is submitted by reiser4_write_log().  This is because with
-   the overwrite set we seek to optimize writes, and with the relocate set we
-   seek to cause disk order to correlate with the parent first pre-order.
+   The "relocate set" of nodes are submitted to write by the jnode_flush()
+   routine, and the "overwrite set" is submitted by reiser4_write_log().
+   This is because with the overwrite set we seek to optimize writes, and
+   with the relocate set we seek to cause disk order to correlate with the
+   "parent first order" (preorder).
 
    reiser4_write_log() allocates and writes wandered blocks and maintains
    additional on-disk structures of the atom as wander records (each wander
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

vfs-add-set_page_dirty_notag.patch
vfs-add-set_page_dirty_notag-checkpatch-fixes.patch
reiser4-vfs-add-super_operationssync_inodes-2.patch
reiser4.patch
reiser4-adjust-to-the-new-aops.patch
reiser4-adjust-to-the-new-aops-fixup.patch
reiser4-remove-simple_prepare_write-usage.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
reiser4-handling-error-returned-by-d_obtain_alias-fixup.patch
reiser4-update-names-of-quota-methods.patch
reiser4-use-set_page_dirty_notag.patch

