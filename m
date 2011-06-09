From: akpm@linux-foundation.org
Subject: + mm-cleanup-descriptions-of-filler-arg.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:36 -0700
Message-ID: <201106092242.p59MgaSb005054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962Ab1FIWp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com


The patch titled
     mm: cleanup descriptions of filler arg
has been added to the -mm tree.  Its filename is
     mm-cleanup-descriptions-of-filler-arg.patch

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
@@ -1795,7 +1795,7 @@ EXPORT_SYMBOL(generic_file_readonly_mmap
 
 static struct page *__read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data,
 				gfp_t gfp)
 {
@@ -1826,7 +1826,7 @@ repeat:
 
 static struct page *do_read_cache_page(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data,
 				gfp_t gfp)
 
@@ -1866,7 +1866,7 @@ out:
  * @mapping:	the page's address_space
  * @index:	the page index
  * @filler:	function to perform the read
- * @data:	destination for read data
+ * @data:	first arg to filler(data, page) function, often left as NULL
  *
  * Same as read_cache_page, but don't wait for page to become unlocked
  * after submitting it to the filler.
@@ -1878,7 +1878,7 @@ out:
  */
 struct page *read_cache_page_async(struct address_space *mapping,
 				pgoff_t index,
-				int (*filler)(void *,struct page*),
+				int (*filler)(void *, struct page *),
 				void *data)
 {
 	return do_read_cache_page(mapping, index, filler, data, mapping_gfp_mask(mapping));
@@ -1926,7 +1926,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
  * @mapping:	the page's address_space
  * @index:	the page index
  * @filler:	function to perform the read
- * @data:	destination for read data
+ * @data:	first arg to filler(data, page) function, often left as NULL
  *
  * Read into the page cache. If a page already exists, and PageUptodate() is
  * not set, try to fill the page then wait for it to become unlocked.
@@ -1935,7 +1935,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
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

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

