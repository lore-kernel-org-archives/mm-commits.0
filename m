Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5F6C4167D
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiEJEVm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E0A2AD751
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31FA2B81AFE
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C1AC385C2;
        Tue, 10 May 2022 04:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156113;
        bh=m8fsE8yknsyHRkLLJeidfNtq7y+AF8vJmFDCyfiN5EY=;
        h=Date:To:From:Subject:From;
        b=ECkJLKmR9+OjrTk6BlDu48RJ3x+iKUMtBVZUeYpg6TgdfJ5GD/dpT/ipdPdOodPT9
         Y/6DHbogY5GmijpNAAjx5jN07x4/CWNAusU4Zeku7FSF2HZtw+1lFkZ/M7BCBoqgmT
         mwEdtKlcq23csX+UIhlhpygmht1QKFwf/ucG7ESM=
Date:   Mon, 09 May 2022 21:15:13 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nfs-rename-nfs_direct_io-and-use-as-swap_rw.patch removed from -mm tree
Message-Id: <20220510041513.D2C1AC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nfs: rename nfs_direct_IO and use as ->swap_rw
has been removed from the -mm tree.  Its filename was
     nfs-rename-nfs_direct_io-and-use-as-swap_rw.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: nfs: rename nfs_direct_IO and use as ->swap_rw

The nfs_direct_IO() exists to support SWAP IO, but hasn't worked for a
while.  We now need a ->swap_rw function which behaves slightly
differently, returning zero for success rather than a byte count.

So modify nfs_direct_IO accordingly, rename it, and use it as the
->swap_rw function.

Link: https://lkml.kernel.org/r/165119301493.15698.7491285551903597618.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be> (on Renesas RSK+RZA1 with 32 MiB of SDRAM)
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/direct.c        |   23 ++++++++++-------------
 fs/nfs/file.c          |    5 +----
 include/linux/nfs_fs.h |    2 +-
 3 files changed, 12 insertions(+), 18 deletions(-)

--- a/fs/nfs/direct.c~nfs-rename-nfs_direct_io-and-use-as-swap_rw
+++ a/fs/nfs/direct.c
@@ -153,28 +153,25 @@ nfs_direct_count_bytes(struct nfs_direct
 }
 
 /**
- * nfs_direct_IO - NFS address space operation for direct I/O
+ * nfs_swap_rw - NFS address space operation for swap I/O
  * @iocb: target I/O control block
  * @iter: I/O buffer
  *
- * The presence of this routine in the address space ops vector means
- * the NFS client supports direct I/O. However, for most direct IO, we
- * shunt off direct read and write requests before the VFS gets them,
- * so this method is only ever called for swap.
+ * Perform IO to the swap-file.  This is much like direct IO.
  */
-ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
+int nfs_swap_rw(struct kiocb *iocb, struct iov_iter *iter)
 {
-	struct inode *inode = iocb->ki_filp->f_mapping->host;
-
-	/* we only support swap file calling nfs_direct_IO */
-	if (!IS_SWAPFILE(inode))
-		return 0;
+	ssize_t ret;
 
 	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
 
 	if (iov_iter_rw(iter) == READ)
-		return nfs_file_direct_read(iocb, iter, true);
-	return nfs_file_direct_write(iocb, iter, true);
+		ret = nfs_file_direct_read(iocb, iter, true);
+	else
+		ret = nfs_file_direct_write(iocb, iter, true);
+	if (ret < 0)
+		return ret;
+	return 0;
 }
 
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
--- a/fs/nfs/file.c~nfs-rename-nfs_direct_io-and-use-as-swap_rw
+++ a/fs/nfs/file.c
@@ -488,10 +488,6 @@ static int nfs_swap_activate(struct swap
 	struct rpc_clnt *clnt = NFS_CLIENT(inode);
 	struct nfs_client *cl = NFS_SERVER(inode)->nfs_client;
 
-	if (!file->f_mapping->a_ops->swap_rw)
-		/* Cannot support swap */
-		return -EINVAL;
-
 	spin_lock(&inode->i_lock);
 	blocks = inode->i_blocks;
 	isize = inode->i_size;
@@ -549,6 +545,7 @@ const struct address_space_operations nf
 	.error_remove_page = generic_error_remove_page,
 	.swap_activate = nfs_swap_activate,
 	.swap_deactivate = nfs_swap_deactivate,
+	.swap_rw = nfs_swap_rw,
 };
 
 /*
--- a/include/linux/nfs_fs.h~nfs-rename-nfs_direct_io-and-use-as-swap_rw
+++ a/include/linux/nfs_fs.h
@@ -507,7 +507,7 @@ static inline const struct cred *nfs_fil
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(struct kiocb *, struct iov_iter *);
+int nfs_swap_rw(struct kiocb *iocb, struct iov_iter *iter);
 ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			     struct iov_iter *iter, bool swap);
 ssize_t nfs_file_direct_write(struct kiocb *iocb,
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

