From: akpm@linux-foundation.org
Subject: + fscache-remove-unused-now_uncached-callback.patch added to -mm
 tree
Date: Wed, 26 Jul 2017 15:17:42 -0700
Message-ID: <59791506.xOqyVJkYU2EMrUVr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42576 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdGZWRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Jul 2017 18:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fscache: remove unused ->now_uncached callback
has been added to the -mm tree.  Its filename is
     fscache-remove-unused-now_uncached-callback.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fscache-remove-unused-now_uncached-callback.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fscache-remove-unused-now_uncached-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: fscache: remove unused ->now_uncached callback

Patch series "Ranged pagevec lookup", v2.

In this series I make pagevec_lookup() update the index (to be consistent
with pagevec_lookup_tag() and also as a preparation for ranged lookups),
provide ranged variant of pagevec_lookup() and use it in places where it
makes sense.  This not only removes some common code but is also a
measurable performance win for some use cases (see patch 4/10) where radix
tree is sparse and searching & grabing of a page after the end of the
range has measurable overhead.


This patch (of 10):

The callback doesn't ever get called.  Remove it.

Link: http://lkml.kernel.org/r/20170726114704.7626-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/caching/netfs-api.txt |    2 
 fs/9p/cache.c                                   |   29 ---------
 fs/afs/cache.c                                  |   43 --------------
 fs/ceph/cache.c                                 |   31 ----------
 fs/cifs/cache.c                                 |   31 ----------
 fs/nfs/fscache-index.c                          |   40 -------------
 include/linux/fscache.h                         |    9 --
 7 files changed, 185 deletions(-)

diff -puN Documentation/filesystems/caching/netfs-api.txt~fscache-remove-unused-now_uncached-callback Documentation/filesystems/caching/netfs-api.txt
--- a/Documentation/filesystems/caching/netfs-api.txt~fscache-remove-unused-now_uncached-callback
+++ a/Documentation/filesystems/caching/netfs-api.txt
@@ -151,8 +151,6 @@ To define an object, a structure of the
 		void (*mark_pages_cached)(void *cookie_netfs_data,
 					  struct address_space *mapping,
 					  struct pagevec *cached_pvec);
-
-		void (*now_uncached)(void *cookie_netfs_data);
 	};
 
 This has the following fields:
diff -puN fs/9p/cache.c~fscache-remove-unused-now_uncached-callback fs/9p/cache.c
--- a/fs/9p/cache.c~fscache-remove-unused-now_uncached-callback
+++ a/fs/9p/cache.c
@@ -151,34 +151,6 @@ fscache_checkaux v9fs_cache_inode_check_
 	return FSCACHE_CHECKAUX_OKAY;
 }
 
-static void v9fs_cache_inode_now_uncached(void *cookie_netfs_data)
-{
-	struct v9fs_inode *v9inode = cookie_netfs_data;
-	struct pagevec pvec;
-	pgoff_t first;
-	int loop, nr_pages;
-
-	pagevec_init(&pvec, 0);
-	first = 0;
-
-	for (;;) {
-		nr_pages = pagevec_lookup(&pvec, v9inode->vfs_inode.i_mapping,
-					  first,
-					  PAGEVEC_SIZE - pagevec_count(&pvec));
-		if (!nr_pages)
-			break;
-
-		for (loop = 0; loop < nr_pages; loop++)
-			ClearPageFsCache(pvec.pages[loop]);
-
-		first = pvec.pages[nr_pages - 1]->index + 1;
-
-		pvec.nr = nr_pages;
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-}
-
 const struct fscache_cookie_def v9fs_cache_inode_index_def = {
 	.name		= "9p.inode",
 	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
@@ -186,7 +158,6 @@ const struct fscache_cookie_def v9fs_cac
 	.get_attr	= v9fs_cache_inode_get_attr,
 	.get_aux	= v9fs_cache_inode_get_aux,
 	.check_aux	= v9fs_cache_inode_check_aux,
-	.now_uncached	= v9fs_cache_inode_now_uncached,
 };
 
 void v9fs_cache_inode_get_cookie(struct inode *inode)
diff -puN fs/afs/cache.c~fscache-remove-unused-now_uncached-callback fs/afs/cache.c
--- a/fs/afs/cache.c~fscache-remove-unused-now_uncached-callback
+++ a/fs/afs/cache.c
@@ -39,7 +39,6 @@ static uint16_t afs_vnode_cache_get_aux(
 static enum fscache_checkaux afs_vnode_cache_check_aux(void *cookie_netfs_data,
 						       const void *buffer,
 						       uint16_t buflen);
-static void afs_vnode_cache_now_uncached(void *cookie_netfs_data);
 
 struct fscache_netfs afs_cache_netfs = {
 	.name			= "afs",
@@ -75,7 +74,6 @@ struct fscache_cookie_def afs_vnode_cach
 	.get_attr		= afs_vnode_cache_get_attr,
 	.get_aux		= afs_vnode_cache_get_aux,
 	.check_aux		= afs_vnode_cache_check_aux,
-	.now_uncached		= afs_vnode_cache_now_uncached,
 };
 
 /*
@@ -359,44 +357,3 @@ static enum fscache_checkaux afs_vnode_c
 	_leave(" = SUCCESS");
 	return FSCACHE_CHECKAUX_OKAY;
 }
-
-/*
- * indication the cookie is no longer uncached
- * - this function is called when the backing store currently caching a cookie
- *   is removed
- * - the netfs should use this to clean up any markers indicating cached pages
- * - this is mandatory for any object that may have data
- */
-static void afs_vnode_cache_now_uncached(void *cookie_netfs_data)
-{
-	struct afs_vnode *vnode = cookie_netfs_data;
-	struct pagevec pvec;
-	pgoff_t first;
-	int loop, nr_pages;
-
-	_enter("{%x,%x,%Lx}",
-	       vnode->fid.vnode, vnode->fid.unique, vnode->status.data_version);
-
-	pagevec_init(&pvec, 0);
-	first = 0;
-
-	for (;;) {
-		/* grab a bunch of pages to clean */
-		nr_pages = pagevec_lookup(&pvec, vnode->vfs_inode.i_mapping,
-					  first,
-					  PAGEVEC_SIZE - pagevec_count(&pvec));
-		if (!nr_pages)
-			break;
-
-		for (loop = 0; loop < nr_pages; loop++)
-			ClearPageFsCache(pvec.pages[loop]);
-
-		first = pvec.pages[nr_pages - 1]->index + 1;
-
-		pvec.nr = nr_pages;
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-
-	_leave("");
-}
diff -puN fs/ceph/cache.c~fscache-remove-unused-now_uncached-callback fs/ceph/cache.c
--- a/fs/ceph/cache.c~fscache-remove-unused-now_uncached-callback
+++ a/fs/ceph/cache.c
@@ -194,36 +194,6 @@ static enum fscache_checkaux ceph_fscach
 	return FSCACHE_CHECKAUX_OKAY;
 }
 
-static void ceph_fscache_inode_now_uncached(void* cookie_netfs_data)
-{
-	struct ceph_inode_info* ci = cookie_netfs_data;
-	struct pagevec pvec;
-	pgoff_t first;
-	int loop, nr_pages;
-
-	pagevec_init(&pvec, 0);
-	first = 0;
-
-	dout("ceph inode 0x%p now uncached", ci);
-
-	while (1) {
-		nr_pages = pagevec_lookup(&pvec, ci->vfs_inode.i_mapping, first,
-					  PAGEVEC_SIZE - pagevec_count(&pvec));
-
-		if (!nr_pages)
-			break;
-
-		for (loop = 0; loop < nr_pages; loop++)
-			ClearPageFsCache(pvec.pages[loop]);
-
-		first = pvec.pages[nr_pages - 1]->index + 1;
-
-		pvec.nr = nr_pages;
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-}
-
 static const struct fscache_cookie_def ceph_fscache_inode_object_def = {
 	.name		= "CEPH.inode",
 	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
@@ -231,7 +201,6 @@ static const struct fscache_cookie_def c
 	.get_attr	= ceph_fscache_inode_get_attr,
 	.get_aux	= ceph_fscache_inode_get_aux,
 	.check_aux	= ceph_fscache_inode_check_aux,
-	.now_uncached	= ceph_fscache_inode_now_uncached,
 };
 
 void ceph_fscache_register_inode_cookie(struct inode *inode)
diff -puN fs/cifs/cache.c~fscache-remove-unused-now_uncached-callback fs/cifs/cache.c
--- a/fs/cifs/cache.c~fscache-remove-unused-now_uncached-callback
+++ a/fs/cifs/cache.c
@@ -292,36 +292,6 @@ fscache_checkaux cifs_fscache_inode_chec
 	return FSCACHE_CHECKAUX_OKAY;
 }
 
-static void cifs_fscache_inode_now_uncached(void *cookie_netfs_data)
-{
-	struct cifsInodeInfo *cifsi = cookie_netfs_data;
-	struct pagevec pvec;
-	pgoff_t first;
-	int loop, nr_pages;
-
-	pagevec_init(&pvec, 0);
-	first = 0;
-
-	cifs_dbg(FYI, "%s: cifs inode 0x%p now uncached\n", __func__, cifsi);
-
-	for (;;) {
-		nr_pages = pagevec_lookup(&pvec,
-					  cifsi->vfs_inode.i_mapping, first,
-					  PAGEVEC_SIZE - pagevec_count(&pvec));
-		if (!nr_pages)
-			break;
-
-		for (loop = 0; loop < nr_pages; loop++)
-			ClearPageFsCache(pvec.pages[loop]);
-
-		first = pvec.pages[nr_pages - 1]->index + 1;
-
-		pvec.nr = nr_pages;
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-}
-
 const struct fscache_cookie_def cifs_fscache_inode_object_def = {
 	.name		= "CIFS.uniqueid",
 	.type		= FSCACHE_COOKIE_TYPE_DATAFILE,
@@ -329,5 +299,4 @@ const struct fscache_cookie_def cifs_fsc
 	.get_attr	= cifs_fscache_inode_get_attr,
 	.get_aux	= cifs_fscache_inode_get_aux,
 	.check_aux	= cifs_fscache_inode_check_aux,
-	.now_uncached	= cifs_fscache_inode_now_uncached,
 };
diff -puN fs/nfs/fscache-index.c~fscache-remove-unused-now_uncached-callback fs/nfs/fscache-index.c
--- a/fs/nfs/fscache-index.c~fscache-remove-unused-now_uncached-callback
+++ a/fs/nfs/fscache-index.c
@@ -252,45 +252,6 @@ enum fscache_checkaux nfs_fscache_inode_
 }
 
 /*
- * Indication from FS-Cache that the cookie is no longer cached
- * - This function is called when the backing store currently caching a cookie
- *   is removed
- * - The netfs should use this to clean up any markers indicating cached pages
- * - This is mandatory for any object that may have data
- */
-static void nfs_fscache_inode_now_uncached(void *cookie_netfs_data)
-{
-	struct nfs_inode *nfsi = cookie_netfs_data;
-	struct pagevec pvec;
-	pgoff_t first;
-	int loop, nr_pages;
-
-	pagevec_init(&pvec, 0);
-	first = 0;
-
-	dprintk("NFS: nfs_inode_now_uncached: nfs_inode 0x%p\n", nfsi);
-
-	for (;;) {
-		/* grab a bunch of pages to unmark */
-		nr_pages = pagevec_lookup(&pvec,
-					  nfsi->vfs_inode.i_mapping,
-					  first,
-					  PAGEVEC_SIZE - pagevec_count(&pvec));
-		if (!nr_pages)
-			break;
-
-		for (loop = 0; loop < nr_pages; loop++)
-			ClearPageFsCache(pvec.pages[loop]);
-
-		first = pvec.pages[nr_pages - 1]->index + 1;
-
-		pvec.nr = nr_pages;
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-}
-
-/*
  * Get an extra reference on a read context.
  * - This function can be absent if the completion function doesn't require a
  *   context.
@@ -330,7 +291,6 @@ const struct fscache_cookie_def nfs_fsca
 	.get_attr	= nfs_fscache_inode_get_attr,
 	.get_aux	= nfs_fscache_inode_get_aux,
 	.check_aux	= nfs_fscache_inode_check_aux,
-	.now_uncached	= nfs_fscache_inode_now_uncached,
 	.get_context	= nfs_fh_get_context,
 	.put_context	= nfs_fh_put_context,
 };
diff -puN include/linux/fscache.h~fscache-remove-unused-now_uncached-callback include/linux/fscache.h
--- a/include/linux/fscache.h~fscache-remove-unused-now_uncached-callback
+++ a/include/linux/fscache.h
@@ -143,15 +143,6 @@ struct fscache_cookie_def {
 	void (*mark_page_cached)(void *cookie_netfs_data,
 				 struct address_space *mapping,
 				 struct page *page);
-
-	/* indicate the cookie is no longer cached
-	 * - this function is called when the backing store currently caching
-	 *   a cookie is removed
-	 * - the netfs should use this to clean up any markers indicating
-	 *   cached pages
-	 * - this is mandatory for any object that may have data
-	 */
-	void (*now_uncached)(void *cookie_netfs_data);
 };
 
 /*
_

Patches currently in -mm which might be from jack@suse.cz are

fscache-remove-unused-now_uncached-callback.patch
mm-make-pagevec_lookup-update-index.patch
mm-implement-find_get_pages_range.patch
fs-fix-performance-regression-in-clean_bdev_aliases.patch
ext4-use-pagevec_lookup_range-in-ext4_find_unwritten_pgoff.patch
ext4-use-pagevec_lookup_range-in-writeback-code.patch
hugetlbfs-use-pagevec_lookup_range-in-remove_inode_hugepages.patch
fs-use-pagevec_lookup_range-in-page_cache_seek_hole_data.patch
mm-use-find_get_pages_range-in-filemap_range_has_page.patch
mm-remove-nr_pages-argument-from-pagevec_lookup_range.patch

