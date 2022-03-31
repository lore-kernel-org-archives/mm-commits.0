Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1678C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiCaETQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiCaESm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:18:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F51A122995
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3052360B0A
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873F2C340EC;
        Thu, 31 Mar 2022 02:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648695378;
        bh=6atHzDyonIYtKE9IKOeIxyWuGcn11oKsZ22ZvfV8Vn0=;
        h=Date:To:From:Subject:From;
        b=VF/FGgRq5NaipshSTpF60nrK4zfb/kbgDZKc8grvE7z1KI4+4azfiYBg4YcojXyC7
         epKGRxlY/Cx8SYYukCEtdYOksmK45CbStSvc/NGn5XLQY1isXTRvzU/GIUq0i8nkaM
         lYpbXdXQdx6SYiZgpGNOU4YRjNSqdPPXBoIY8Ysc=
Date:   Wed, 30 Mar 2022 19:56:17 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, hughd@google.com, hch@lst.de,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch added to -mm tree
Message-Id: <20220331025618.873F2C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce ->swap_rw and use it for reads from SWP_FS_OPS swap-space
has been added to the -mm tree.  Its filename is
     mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: introduce ->swap_rw and use it for reads from SWP_FS_OPS swap-space

swap currently uses ->readpage to read swap pages.  This can only request
one page at a time from the filesystem, which is not most efficient.

swap uses ->direct_IO for writes which while this is adequate is an
inappropriate over-loading.  ->direct_IO may need to had handle allocate
space for holes or other details that are not relevant for swap.

So this patch introduces a new address_space operation: ->swap_rw.  In
this patch it is used for reads, and a subsequent patch will switch writes
to use it.

No filesystem yet supports ->swap_rw, but that is not a problem because
no filesystem actually works with filesystem-based swap.
Only two filesystems set SWP_FS_OPS:
- cifs sets the flag, but ->direct_IO always fails so swap cannot work.
- nfs sets the flag, but ->direct_IO calls generic_write_checks()
  which has failed on swap files for several releases.

To ensure that a NULL ->swap_rw isn't called, ->activate_swap() for both
NFS and cifs are changed to fail if ->swap_rw is not set.  This can be
removed if/when the function is added.

Future patches will restore swap-over-NFS functionality.

To submit an async read with ->swap_rw() we need to allocate a structure
to hold the kiocb and other details.  swap_readpage() cannot handle
transient failure, so we create a mempool to provide the structures.

Link: https://lkml.kernel.org/r/164859778125.29473.13430559328221330589.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c     |    4 ++
 fs/nfs/file.c      |    4 ++
 include/linux/fs.h |    1 
 mm/page_io.c       |   68 +++++++++++++++++++++++++++++++++++++++----
 mm/swap.h          |    1 
 mm/swapfile.c      |    5 +++
 6 files changed, 77 insertions(+), 6 deletions(-)

--- a/fs/cifs/file.c~mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space
+++ a/fs/cifs/file.c
@@ -4899,6 +4899,10 @@ static int cifs_swap_activate(struct swa
 
 	cifs_dbg(FYI, "swap activate\n");
 
+	if (!swap_file->f_mapping->a_ops->swap_rw)
+		/* Cannot support swap */
+		return -EINVAL;
+
 	spin_lock(&inode->i_lock);
 	blocks = inode->i_blocks;
 	isize = inode->i_size;
--- a/fs/nfs/file.c~mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space
+++ a/fs/nfs/file.c
@@ -488,6 +488,10 @@ static int nfs_swap_activate(struct swap
 	struct rpc_clnt *clnt = NFS_CLIENT(inode);
 	struct nfs_client *cl = NFS_SERVER(inode)->nfs_client;
 
+	if (!file->f_mapping->a_ops->swap_rw)
+		/* Cannot support swap */
+		return -EINVAL;
+
 	spin_lock(&inode->i_lock);
 	blocks = inode->i_blocks;
 	isize = inode->i_size;
--- a/include/linux/fs.h~mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space
+++ a/include/linux/fs.h
@@ -409,6 +409,7 @@ struct address_space_operations {
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *file,
 				sector_t *span);
 	void (*swap_deactivate)(struct file *file);
+	int (*swap_rw)(struct kiocb *iocb, struct iov_iter *iter);
 };
 
 extern const struct address_space_operations empty_aops;
--- a/mm/page_io.c~mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space
+++ a/mm/page_io.c
@@ -235,6 +235,25 @@ static void bio_associate_blkg_from_page
 #define bio_associate_blkg_from_page(bio, page)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
+struct swap_iocb {
+	struct kiocb		iocb;
+	struct bio_vec		bvec;
+};
+static mempool_t *sio_pool;
+
+int sio_pool_init(void)
+{
+	if (!sio_pool) {
+		mempool_t *pool = mempool_create_kmalloc_pool(
+			SWAP_CLUSTER_MAX, sizeof(struct swap_iocb));
+		if (cmpxchg(&sio_pool, NULL, pool))
+			mempool_destroy(pool);
+	}
+	if (!sio_pool)
+		return -ENOMEM;
+	return 0;
+}
+
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		bio_end_io_t end_write_func)
 {
@@ -306,6 +325,48 @@ int __swap_writepage(struct page *page,
 	return 0;
 }
 
+static void sio_read_complete(struct kiocb *iocb, long ret)
+{
+	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
+	struct page *page = sio->bvec.bv_page;
+
+	if (ret != 0 && ret != PAGE_SIZE) {
+		SetPageError(page);
+		ClearPageUptodate(page);
+		pr_alert_ratelimited("Read-error on swap-device\n");
+	} else {
+		SetPageUptodate(page);
+		count_vm_event(PSWPIN);
+	}
+	unlock_page(page);
+	mempool_free(sio, sio_pool);
+}
+
+static int swap_readpage_fs(struct page *page)
+{
+	struct swap_info_struct *sis = page_swap_info(page);
+	struct file *swap_file = sis->swap_file;
+	struct address_space *mapping = swap_file->f_mapping;
+	struct iov_iter from;
+	struct swap_iocb *sio;
+	loff_t pos = page_file_offset(page);
+	int ret;
+
+	sio = mempool_alloc(sio_pool, GFP_KERNEL);
+	init_sync_kiocb(&sio->iocb, swap_file);
+	sio->iocb.ki_pos = pos;
+	sio->iocb.ki_complete = sio_read_complete;
+	sio->bvec.bv_page = page;
+	sio->bvec.bv_len = PAGE_SIZE;
+	sio->bvec.bv_offset = 0;
+
+	iov_iter_bvec(&from, READ, &sio->bvec, 1, PAGE_SIZE);
+	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
+	if (ret != -EIOCBQUEUED)
+		sio_read_complete(&sio->iocb, ret);
+	return ret;
+}
+
 int swap_readpage(struct page *page, bool synchronous)
 {
 	struct bio *bio;
@@ -334,12 +395,7 @@ int swap_readpage(struct page *page, boo
 	}
 
 	if (data_race(sis->flags & SWP_FS_OPS)) {
-		struct file *swap_file = sis->swap_file;
-		struct address_space *mapping = swap_file->f_mapping;
-
-		ret = mapping->a_ops->readpage(swap_file, page);
-		if (!ret)
-			count_vm_event(PSWPIN);
+		ret = swap_readpage_fs(page);
 		goto out;
 	}
 
--- a/mm/swapfile.c~mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space
+++ a/mm/swapfile.c
@@ -2247,6 +2247,11 @@ static int setup_swap_extents(struct swa
 		if (ret < 0)
 			return ret;
 		sis->flags |= SWP_ACTIVATED;
+		if ((sis->flags & SWP_FS_OPS) &&
+		    sio_pool_init() != 0) {
+			destroy_swap_extents(sis);
+			return -ENOMEM;
+		}
 		return ret;
 	}
 
--- a/mm/swap.h~mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space
+++ a/mm/swap.h
@@ -6,6 +6,7 @@
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 /* linux/mm/page_io.c */
+int sio_pool_init(void);
 int swap_readpage(struct page *page, bool do_poll);
 int swap_writepage(struct page *page, struct writeback_control *wbc);
 void end_swap_bio_write(struct bio *bio);
_

Patches currently in -mm which might be from neilb@suse.de are

mm-create-new-mm-swaph-header-file.patch
mm-drop-swap_dirty_folio.patch
mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch
doc-update-documentation-for-swap_activate-and-swap_rw.patch
mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch
vfs-add-fmode_can_odirect-file-flag.patch
mm-discard-__gfp_atomic.patch

