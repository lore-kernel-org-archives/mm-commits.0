From: akpm@osdl.org
Subject: + nfs-fix-race-in-nfs_release_page.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:22:55 -0800
Message-ID: <200701082322.l08NMtFC022509@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53363 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161287AbXAHXXB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:23:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com, a.p.zijlstra@chello.nl


The patch titled
     NFS: Fix race in nfs_release_page()
has been added to the -mm tree.  Its filename is
     nfs-fix-race-in-nfs_release_page.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: Fix race in nfs_release_page()
From: Trond Myklebust <Trond.Myklebust@netapp.com>

    NFS: Fix race in nfs_release_page()

    invalidate_inode_pages2() may find the dirty bit has been set on a page
    owing to the fact that the page may still be mapped after it was locked.
    Only after the call to unmap_mapping_range() are we sure that the page
    can no longer be dirtied.
    In order to fix this, NFS has hooked the releasepage() method and tries
    to write the page out between the call to unmap_mapping_range() and the
    call to remove_mapping(). This, however leads to deadlocks in the page
    reclaim code, where the page may be locked without holding a reference
    to the inode or dentry.

    Fix is to add a new address_space_operation, launder_page(), which will
    attempt to write out a dirty page without releasing the page lock.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

    Also, the bare SetPageDirty() can skew all sort of accounting leading to
    other nasties.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/filesystems/Locking |    8 ++++++++
 fs/nfs/file.c                     |   16 ++++++++--------
 include/linux/fs.h                |    1 +
 mm/truncate.c                     |   13 ++++++++++++-
 4 files changed, 29 insertions(+), 9 deletions(-)

diff -puN Documentation/filesystems/Locking~nfs-fix-race-in-nfs_release_page Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~nfs-fix-race-in-nfs_release_page
+++ a/Documentation/filesystems/Locking
@@ -171,6 +171,7 @@ prototypes:
 	int (*releasepage) (struct page *, int);
 	int (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
 			loff_t offset, unsigned long nr_segs);
+	int (*launder_page) (struct page *);
 
 locking rules:
 	All except set_page_dirty may block
@@ -188,6 +189,7 @@ bmap:			yes
 invalidatepage:		no	yes
 releasepage:		no	yes
 direct_IO:		no
+launder_page:		no	yes
 
 	->prepare_write(), ->commit_write(), ->sync_page() and ->readpage()
 may be called from the request handler (/dev/loop).
@@ -281,6 +283,12 @@ buffers from the page in preparation for
 indicate that the buffers are (or may be) freeable.  If ->releasepage is zero,
 the kernel assumes that the fs has no private interest in the buffers.
 
+	->launder_page() may be called prior to releasing a page if
+it is still found to be dirty. It returns zero if the page was successfully
+cleaned, or an error value if not. Note that in order to prevent the page
+getting mapped back in and redirtied, it needs to be kept locked
+across the entire operation.
+
 	Note: currently almost all instances of address_space methods are
 using BKL for internal serialization and that's one of the worst sources
 of contention. Normally they are calling library functions (in fs/buffer.c)
diff -puN fs/nfs/file.c~nfs-fix-race-in-nfs_release_page fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-fix-race-in-nfs_release_page
+++ a/fs/nfs/file.c
@@ -315,14 +315,13 @@ static void nfs_invalidate_page(struct p
 
 static int nfs_release_page(struct page *page, gfp_t gfp)
 {
-	/*
-	 * Avoid deadlock on nfs_wait_on_request().
-	 */
-	if (!(gfp & __GFP_FS))
-		return 0;
-	/* Hack... Force nfs_wb_page() to write out the page */
-	SetPageDirty(page);
-	return !nfs_wb_page(page->mapping->host, page);
+	/* If PagePrivate() is set, then the page is not freeable */
+	return 0;
+}
+
+static int nfs_launder_page(struct page *page)
+{
+	return nfs_wb_page(page->mapping->host, page);
 }
 
 const struct address_space_operations nfs_file_aops = {
@@ -338,6 +337,7 @@ const struct address_space_operations nf
 #ifdef CONFIG_NFS_DIRECTIO
 	.direct_IO = nfs_direct_IO,
 #endif
+	.launder_page = nfs_launder_page,
 };
 
 static ssize_t nfs_file_write(struct kiocb *iocb, const struct iovec *iov,
diff -puN include/linux/fs.h~nfs-fix-race-in-nfs_release_page include/linux/fs.h
--- a/include/linux/fs.h~nfs-fix-race-in-nfs_release_page
+++ a/include/linux/fs.h
@@ -426,6 +426,7 @@ struct address_space_operations {
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
+	int (*launder_page) (struct page *);
 };
 
 struct backing_dev_info;
diff -puN mm/truncate.c~nfs-fix-race-in-nfs_release_page mm/truncate.c
--- a/mm/truncate.c~nfs-fix-race-in-nfs_release_page
+++ a/mm/truncate.c
@@ -341,6 +341,16 @@ failed:
 	return 0;
 }
 
+static int
+do_launder_page(struct address_space *mapping, struct page *page)
+{
+	if (!PageDirty(page))
+		return 0;
+	if (page->mapping != mapping || mapping->a_ops->launder_page == NULL)
+		return 0;
+	return mapping->a_ops->launder_page(page);
+}
+
 /**
  * invalidate_inode_pages2_range - remove range of pages from an address_space
  * @mapping: the address_space
@@ -405,7 +415,8 @@ int invalidate_inode_pages2_range(struct
 					  PAGE_CACHE_SIZE, 0);
 				}
 			}
-			if (!invalidate_complete_page2(mapping, page))
+			ret = do_launder_page(mapping, page);
+			if (ret == 0 && !invalidate_complete_page2(mapping, page))
 				ret = -EIO;
 			unlock_page(page);
 		}
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

nfs-fix-race-in-nfs_release_page.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
nfs-kill-the-obsolete-nfs_paranoia.patch
