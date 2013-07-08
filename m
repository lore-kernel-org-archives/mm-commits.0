From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:40 -0700
Message-ID: <51db1234.J5DBqAkrXwfMhU4Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3GHTZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: [merged] mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch removed from -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:40 -0700


The patch titled
     Subject: mm: remove lru parameter from __pagevec_lru_add and remove parts of pagevec API
has been removed from the -mm tree.  Its filename was
     mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: remove lru parameter from __pagevec_lru_add and remove parts of pagevec API

Now that the LRU to add a page to is decided at LRU-add time, remove the
misleading lru parameter from __pagevec_lru_add.  A consequence of this is
that the pagevec_lru_add_file, pagevec_lru_add_anon and similar helpers
are misleading as the caller no longer has direct control over what LRU
the page is added to.  Unused helpers are removed by this patch and
existing users of pagevec_lru_add_file() are converted to use
lru_cache_add_file() directly and use the per-cpu pagevecs instead of
creating their own pagevec.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Lyahkov <alexey.lyashkov@gmail.com>
Cc: Andrew Perepechko <anserper@ya.ru>
Cc: Robin Dong <sanbai@taobao.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cachefiles/rdwr.c    |   30 +++++++-----------------------
 fs/nfs/dir.c            |    7 ++-----
 include/linux/pagevec.h |   34 +---------------------------------
 mm/swap.c               |   12 ++++--------
 4 files changed, 14 insertions(+), 69 deletions(-)

diff -puN fs/cachefiles/rdwr.c~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api fs/cachefiles/rdwr.c
--- a/fs/cachefiles/rdwr.c~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api
+++ a/fs/cachefiles/rdwr.c
@@ -12,6 +12,7 @@
 #include <linux/mount.h>
 #include <linux/slab.h>
 #include <linux/file.h>
+#include <linux/swap.h>
 #include "internal.h"
 
 /*
@@ -227,8 +228,7 @@ static void cachefiles_read_copier(struc
  */
 static int cachefiles_read_backing_file_one(struct cachefiles_object *object,
 					    struct fscache_retrieval *op,
-					    struct page *netpage,
-					    struct pagevec *pagevec)
+					    struct page *netpage)
 {
 	struct cachefiles_one_read *monitor;
 	struct address_space *bmapping;
@@ -237,8 +237,6 @@ static int cachefiles_read_backing_file_
 
 	_enter("");
 
-	pagevec_reinit(pagevec);
-
 	_debug("read back %p{%lu,%d}",
 	       netpage, netpage->index, page_count(netpage));
 
@@ -283,9 +281,7 @@ installed_new_backing_page:
 	backpage = newpage;
 	newpage = NULL;
 
-	page_cache_get(backpage);
-	pagevec_add(pagevec, backpage);
-	__pagevec_lru_add_file(pagevec);
+	lru_cache_add_file(backpage);
 
 read_backing_page:
 	ret = bmapping->a_ops->readpage(NULL, backpage);
@@ -452,8 +448,7 @@ int cachefiles_read_or_alloc_page(struct
 	if (block) {
 		/* submit the apparently valid page to the backing fs to be
 		 * read from disk */
-		ret = cachefiles_read_backing_file_one(object, op, page,
-						       &pagevec);
+		ret = cachefiles_read_backing_file_one(object, op, page);
 	} else if (cachefiles_has_space(cache, 0, 1) == 0) {
 		/* there's space in the cache we can use */
 		fscache_mark_page_cached(op, page);
@@ -482,14 +477,11 @@ static int cachefiles_read_backing_file(
 {
 	struct cachefiles_one_read *monitor = NULL;
 	struct address_space *bmapping = object->backer->d_inode->i_mapping;
-	struct pagevec lru_pvec;
 	struct page *newpage = NULL, *netpage, *_n, *backpage = NULL;
 	int ret = 0;
 
 	_enter("");
 
-	pagevec_init(&lru_pvec, 0);
-
 	list_for_each_entry_safe(netpage, _n, list, lru) {
 		list_del(&netpage->lru);
 
@@ -534,9 +526,7 @@ static int cachefiles_read_backing_file(
 		backpage = newpage;
 		newpage = NULL;
 
-		page_cache_get(backpage);
-		if (!pagevec_add(&lru_pvec, backpage))
-			__pagevec_lru_add_file(&lru_pvec);
+		lru_cache_add_file(backpage);
 
 	reread_backing_page:
 		ret = bmapping->a_ops->readpage(NULL, backpage);
@@ -559,9 +549,7 @@ static int cachefiles_read_backing_file(
 			goto nomem;
 		}
 
-		page_cache_get(netpage);
-		if (!pagevec_add(&lru_pvec, netpage))
-			__pagevec_lru_add_file(&lru_pvec);
+		lru_cache_add_file(netpage);
 
 		/* install a monitor */
 		page_cache_get(netpage);
@@ -643,9 +631,7 @@ static int cachefiles_read_backing_file(
 
 		fscache_mark_page_cached(op, netpage);
 
-		page_cache_get(netpage);
-		if (!pagevec_add(&lru_pvec, netpage))
-			__pagevec_lru_add_file(&lru_pvec);
+		lru_cache_add_file(netpage);
 
 		/* the netpage is unlocked and marked up to date here */
 		fscache_end_io(op, netpage, 0);
@@ -661,8 +647,6 @@ static int cachefiles_read_backing_file(
 
 out:
 	/* tidy up */
-	pagevec_lru_add_file(&lru_pvec);
-
 	if (newpage)
 		page_cache_release(newpage);
 	if (netpage)
diff -puN fs/nfs/dir.c~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api fs/nfs/dir.c
--- a/fs/nfs/dir.c~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api
+++ a/fs/nfs/dir.c
@@ -33,6 +33,7 @@
 #include <linux/pagevec.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/swap.h>
 #include <linux/sched.h>
 #include <linux/kmemleak.h>
 #include <linux/xattr.h>
@@ -1758,7 +1759,6 @@ EXPORT_SYMBOL_GPL(nfs_unlink);
  */
 int nfs_symlink(struct inode *dir, struct dentry *dentry, const char *symname)
 {
-	struct pagevec lru_pvec;
 	struct page *page;
 	char *kaddr;
 	struct iattr attr;
@@ -1798,11 +1798,8 @@ int nfs_symlink(struct inode *dir, struc
 	 * No big deal if we can't add this page to the page cache here.
 	 * READLINK will get the missing page from the server if needed.
 	 */
-	pagevec_init(&lru_pvec, 0);
-	if (!add_to_page_cache(page, dentry->d_inode->i_mapping, 0,
+	if (!add_to_page_cache_lru(page, dentry->d_inode->i_mapping, 0,
 							GFP_KERNEL)) {
-		pagevec_add(&lru_pvec, page);
-		pagevec_lru_add_file(&lru_pvec);
 		SetPageUptodate(page);
 		unlock_page(page);
 	} else
diff -puN include/linux/pagevec.h~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api
+++ a/include/linux/pagevec.h
@@ -21,7 +21,7 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
+void __pagevec_lru_add(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
@@ -64,36 +64,4 @@ static inline void pagevec_release(struc
 		__pagevec_release(pvec);
 }
 
-static inline void __pagevec_lru_add_anon(struct pagevec *pvec)
-{
-	__pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
-}
-
-static inline void __pagevec_lru_add_active_anon(struct pagevec *pvec)
-{
-	__pagevec_lru_add(pvec, LRU_ACTIVE_ANON);
-}
-
-static inline void __pagevec_lru_add_file(struct pagevec *pvec)
-{
-	__pagevec_lru_add(pvec, LRU_INACTIVE_FILE);
-}
-
-static inline void __pagevec_lru_add_active_file(struct pagevec *pvec)
-{
-	__pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
-}
-
-static inline void pagevec_lru_add_file(struct pagevec *pvec)
-{
-	if (pagevec_count(pvec))
-		__pagevec_lru_add_file(pvec);
-}
-
-static inline void pagevec_lru_add_anon(struct pagevec *pvec)
-{
-	if (pagevec_count(pvec))
-		__pagevec_lru_add_anon(pvec);
-}
-
 #endif /* _LINUX_PAGEVEC_H */
diff -puN mm/swap.c~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api mm/swap.c
--- a/mm/swap.c~mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api
+++ a/mm/swap.c
@@ -505,7 +505,7 @@ void __lru_cache_add(struct page *page,
 
 	page_cache_get(page);
 	if (!pagevec_space(pvec))
-		__pagevec_lru_add(pvec, lru);
+		__pagevec_lru_add(pvec);
 	pagevec_add(pvec, page);
 	put_cpu_var(lru_add_pvec);
 }
@@ -628,7 +628,7 @@ void lru_add_drain_cpu(int cpu)
 	struct pagevec *pvec = &per_cpu(lru_add_pvec, cpu);
 
 	if (pagevec_count(pvec))
-		__pagevec_lru_add(pvec, NR_LRU_LISTS);
+		__pagevec_lru_add(pvec);
 
 	pvec = &per_cpu(lru_rotate_pvecs, cpu);
 	if (pagevec_count(pvec)) {
@@ -832,12 +832,10 @@ void lru_add_page_tail(struct page *page
 static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 				 void *arg)
 {
-	enum lru_list requested_lru = (enum lru_list)arg;
 	int file = page_is_file_cache(page);
 	int active = PageActive(page);
 	enum lru_list lru = page_lru(page);
 
-	WARN_ON_ONCE(requested_lru < NR_LRU_LISTS && requested_lru != lru);
 	VM_BUG_ON(PageUnevictable(page));
 	VM_BUG_ON(PageLRU(page));
 
@@ -851,11 +849,9 @@ static void __pagevec_lru_add_fn(struct
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
-void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
+void __pagevec_lru_add(struct pagevec *pvec)
 {
-	VM_BUG_ON(is_unevictable_lru(lru));
-
-	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, (void *)lru);
+	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, NULL);
 }
 EXPORT_SYMBOL(__pagevec_lru_add);
 
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

