From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-descriptions-of-filler-arg.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:53:17 -0700
Message-ID: <201107260752.p6Q7qKW1003118@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890Ab1GZHwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: cleanup descriptions of filler arg
has been removed from the -mm tree.  Its filename was
     mm-cleanup-descriptions-of-filler-arg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: cleanup descriptions of filler arg
From: Hugh Dickins <hughd@google.com>

The often-NULL data arg to read_cache_page() and read_mapping_page()
functions is misdescribed as "destination for read data": no, it's the
first arg to the filler function, often struct file * to ->readpage().

Satisfy checkpatch.pl on those filler prototypes, and tidy up the
declarations in linux/pagemap.h.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   12 +++++-------
 mm/filemap.c            |   12 ++++++------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff -puN include/linux/pagemap.h~mm-cleanup-descriptions-of-filler-arg include/linux/pagemap.h
--- a/include/linux/pagemap.h~mm-cleanup-descriptions-of-filler-arg
+++ a/include/linux/pagemap.h
@@ -255,26 +255,24 @@ static inline struct page *grab_cache_pa
 extern struct page * grab_cache_page_nowait(struct address_space *mapping,
 				pgoff_t index);
 extern struct page * read_cache_page_async(struct address_space *mapping,
-				pgoff_t index, filler_t *filler,
-				void *data);
+				pgoff_t index, filler_t *filler, void *data);
 extern struct page * read_cache_page(struct address_space *mapping,
-				pgoff_t index, filler_t *filler,
-				void *data);
+				pgoff_t index, filler_t *filler, void *data);
 extern struct page * read_cache_page_gfp(struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
 extern int read_cache_pages(struct address_space *mapping,
 		struct list_head *pages, filler_t *filler, void *data);
 
 static inline struct page *read_mapping_page_async(
-						struct address_space *mapping,
-						     pgoff_t index, void *data)
+				struct address_space *mapping,
+				pgoff_t index, void *data)
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
 	return read_cache_page_async(mapping, index, filler, data);
 }
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
-					     pgoff_t index, void *data)
+				pgoff_t index, void *data)
 {
 	filler_t *filler = (filler_t *)mapping->a_ops->readpage;
 	return read_cache_page(mapping, index, filler, data);
diff -puN mm/filemap.c~mm-cleanup-descriptions-of-filler-arg mm/filemap.c
--- a/mm/filemap.c~mm-cleanup-descriptions-of-filler-arg
+++ a/mm/filemap.c
@@ -1792,7 +1792,7 @@ EXPORT_SYMBOL(generic_file_readonly_mmap
 
 static struct page *__read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data,
 				gfp_t gfp)
 {
@@ -1823,7 +1823,7 @@ repeat:
 
 static struct page *do_read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data,
 				gfp_t gfp)
 
@@ -1863,7 +1863,7 @@ out:
  * @mapping:	the page's address_space
  * @index:	the page index
  * @filler:	function to perform the read
- * @data:	destination for read data
+ * @data:	first arg to filler(data, page) function, often left as NULL
  *
  * Same as read_cache_page, but don't wait for page to become unlocked
  * after submitting it to the filler.
@@ -1875,7 +1875,7 @@ out:
  */
 struct page *read_cache_page_async(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data)
 {
 	return do_read_cache_page(mapping, index, filler, data, mapping_gfp_mask(mapping));
@@ -1923,7 +1923,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
  * @mapping:	the page's address_space
  * @index:	the page index
  * @filler:	function to perform the read
- * @data:	destination for read data
+ * @data:	first arg to filler(data, page) function, often left as NULL
  *
  * Read into the page cache. If a page already exists, and PageUptodate() is
  * not set, try to fill the page then wait for it to become unlocked.
@@ -1932,7 +1932,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
  */
 struct page *read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data)
 {
 	return wait_on_page_read(read_cache_page_async(mapping, index, filler, data));
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
slub-partly-fix-freeze-in-__slab_free.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
mm-a-few-small-updates-for-radix-swap-fix.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
panic-panic=-1-for-immediate-reboot.patch
panic-vt-do-not-force-oops-output-when-panic_timeout-0.patch
prio_tree-debugging-patch.patch

