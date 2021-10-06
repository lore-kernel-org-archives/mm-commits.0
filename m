Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022D6C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 01:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD52F611CC
	for <mm-commits@archiver.kernel.org>; Wed,  6 Oct 2021 01:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbhJFBua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 21:50:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229908AbhJFBu3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 21:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 828326120D;
        Wed,  6 Oct 2021 01:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633484918;
        bh=1wOFXyN317qi6OF88tqYYPFudtbCd5PqyMxE2hZ4ZYQ=;
        h=Date:From:To:Subject:From;
        b=t/Q04dH96smSdxethUNdPRCbUuxcVFZOxDsEcqJz5ANmoEeZ4hdZuMdfaQpnFGOYK
         O6cLDcokSpxFjq1oQK5pYNc4hccZSa0r/Bwcy1V90Wq0yh03IOMAHob6z7piqwdJ0L
         ceJpxiz1Dx5VUSSmjD53MJgK4y+GqpJ156mxOP4I=
Date:   Tue, 05 Oct 2021 18:48:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20211006014838.VEzC-XhwV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/cache.c    |  140 ---------------------------------------------
 fs/9p/vfs_addr.c |    7 --
 2 files changed, 147 deletions(-)

--- a/fs/9p/cache.c~linux-next-git-rejects
+++ a/fs/9p/cache.c
@@ -199,143 +199,3 @@ void v9fs_cache_inode_reset_cookie(struc
 
 	mutex_unlock(&v9inode->fscache_lock);
 }
-<<<<<<< HEAD
-
-int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
-{
-	struct inode *inode = page->mapping->host;
-	struct v9fs_inode *v9inode = V9FS_I(inode);
-
-	BUG_ON(!v9inode->fscache);
-
-	return fscache_maybe_release_page(v9inode->fscache, page, gfp);
-}
-
-void __v9fs_fscache_invalidate_page(struct page *page)
-{
-	struct inode *inode = page->mapping->host;
-	struct v9fs_inode *v9inode = V9FS_I(inode);
-
-	BUG_ON(!v9inode->fscache);
-
-	if (PageFsCache(page)) {
-		fscache_wait_on_page_write(v9inode->fscache, page);
-		BUG_ON(!PageLocked(page));
-		fscache_uncache_page(v9inode->fscache, page);
-	}
-}
-
-static void v9fs_vfs_readpage_complete(struct page *page, void *data,
-				       int error)
-{
-	if (!error)
-		SetPageUptodate(page);
-
-	unlock_page(page);
-}
-
-/*
- * __v9fs_readpage_from_fscache - read a page from cache
- *
- * Returns 0 if the pages are in cache and a BIO is submitted,
- * 1 if the pages are not in cache and -error otherwise.
- */
-
-int __v9fs_readpage_from_fscache(struct inode *inode, struct page *page)
-{
-	int ret;
-	const struct v9fs_inode *v9inode = V9FS_I(inode);
-
-	p9_debug(P9_DEBUG_FSC, "inode %p page %p\n", inode, page);
-	if (!v9inode->fscache)
-		return -ENOBUFS;
-
-	ret = fscache_read_or_alloc_page(v9inode->fscache,
-					 page,
-					 v9fs_vfs_readpage_complete,
-					 NULL,
-					 GFP_KERNEL);
-	switch (ret) {
-	case -ENOBUFS:
-	case -ENODATA:
-		p9_debug(P9_DEBUG_FSC, "page/inode not in cache %d\n", ret);
-		return 1;
-	case 0:
-		p9_debug(P9_DEBUG_FSC, "BIO submitted\n");
-		return ret;
-	default:
-		p9_debug(P9_DEBUG_FSC, "ret %d\n", ret);
-		return ret;
-	}
-}
-
-/*
- * __v9fs_readpages_from_fscache - read multiple pages from cache
- *
- * Returns 0 if the pages are in cache and a BIO is submitted,
- * 1 if the pages are not in cache and -error otherwise.
- */
-
-int __v9fs_readpages_from_fscache(struct inode *inode,
-				  struct address_space *mapping,
-				  struct list_head *pages,
-				  unsigned *nr_pages)
-{
-	int ret;
-	const struct v9fs_inode *v9inode = V9FS_I(inode);
-
-	p9_debug(P9_DEBUG_FSC, "inode %p pages %u\n", inode, *nr_pages);
-	if (!v9inode->fscache)
-		return -ENOBUFS;
-
-	ret = fscache_read_or_alloc_pages(v9inode->fscache,
-					  mapping, pages, nr_pages,
-					  v9fs_vfs_readpage_complete,
-					  NULL,
-					  mapping_gfp_mask(mapping));
-	switch (ret) {
-	case -ENOBUFS:
-	case -ENODATA:
-		p9_debug(P9_DEBUG_FSC, "pages/inodes not in cache %d\n", ret);
-		return 1;
-	case 0:
-		BUG_ON(!list_empty(pages));
-		BUG_ON(*nr_pages != 0);
-		p9_debug(P9_DEBUG_FSC, "BIO submitted\n");
-		return ret;
-	default:
-		p9_debug(P9_DEBUG_FSC, "ret %d\n", ret);
-		return ret;
-	}
-}
-
-/*
- * __v9fs_readpage_to_fscache - write a page to the cache
- *
- */
-
-void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page)
-{
-	int ret;
-	const struct v9fs_inode *v9inode = V9FS_I(inode);
-
-	p9_debug(P9_DEBUG_FSC, "inode %p page %p\n", inode, page);
-	ret = fscache_write_page(v9inode->fscache, page,
-				 i_size_read(&v9inode->vfs_inode), GFP_KERNEL);
-	p9_debug(P9_DEBUG_FSC, "ret =  %d\n", ret);
-	if (ret != 0)
-		v9fs_uncache_page(inode, page);
-}
-
-/*
- * wait for a page to complete writing to the cache
- */
-void __v9fs_fscache_wait_on_page_write(struct inode *inode, struct page *page)
-{
-	const struct v9fs_inode *v9inode = V9FS_I(inode);
-	p9_debug(P9_DEBUG_FSC, "inode %p page %p\n", inode, page);
-	if (PageFsCache(page))
-		fscache_wait_on_page_write(v9inode->fscache, page);
-}
-=======
->>>>>>> linux-next/akpm-base
--- a/fs/9p/vfs_addr.c~linux-next-git-rejects
+++ a/fs/9p/vfs_addr.c
@@ -29,15 +29,8 @@
 #include "fid.h"
 
 /**
-<<<<<<< HEAD
- * v9fs_fid_readpage - read an entire page in from 9P
- * @data: Opaque pointer to the fid being read
- * @page: structure to page
- *
-=======
  * v9fs_req_issue_op - Issue a read from 9P
  * @subreq: The read to make
->>>>>>> linux-next/akpm-base
  */
 static void v9fs_req_issue_op(struct netfs_read_subrequest *subreq)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-dont-call-should_failslab-for-config_failslab-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

