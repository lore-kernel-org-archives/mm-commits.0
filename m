Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C769FC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236091AbiEJEVh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BE82AC6FD
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 502D26176D
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78B3C385A6;
        Tue, 10 May 2022 04:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156110;
        bh=FkIUdOBKblIoL7y/LZxRwdiRprS2kDt/6DfOME2KQWE=;
        h=Date:To:From:Subject:From;
        b=yKPtfah17/LZ68hguvDEHiQluJIXncr+3M+pf0bpA/JZVDdeYAqhnC5KquH0HAW5n
         STFr/oiEo9fw1OK6YJLsd5rcY1H1HyKwFTpTVGzUcVfDsHcENTSpaZSgV7NI+l7a/G
         zeHU5kZnjy0OeBfQcIhIGSHpz987J7fBmuqDce1U=
Date:   Mon, 09 May 2022 21:15:10 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch removed from -mm tree
Message-Id: <20220510041510.A78B3C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: move responsibility for setting SWP_FS_OPS to ->swap_activate
has been removed from the -mm tree.  Its filename was
     mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: mm: move responsibility for setting SWP_FS_OPS to ->swap_activate

If a filesystem wishes to handle all swap IO itself (via ->direct_IO and
->readpage), rather than just providing devices addresses for
submit_bio(), SWP_FS_OPS must be set.

Currently the protocol for setting this it to have ->swap_activate return
zero.  In that case SWP_FS_OPS is set, and add_swap_extent() is called for
the entire file.

This is a little clumsy as different return values for ->swap_activate
have quite different meanings, and it makes it hard to search for which
filesystems require SWP_FS_OPS to be set.

So remove the special meaning of a zero return, and require the filesystem
to set SWP_FS_OPS if it so desires, and to always call add_swap_extent()
as required.

Currently only NFS and CIFS return zero for add_swap_extent().

Link: https://lkml.kernel.org/r/164859778123.29473.17908205846599043598.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: David Howells <dhowells@redhat.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c       |    3 ++-
 fs/nfs/file.c        |   14 ++++++++++++--
 include/linux/swap.h |    6 ++++++
 mm/swapfile.c        |   10 +++-------
 4 files changed, 23 insertions(+), 10 deletions(-)

--- a/fs/cifs/file.c~mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate
+++ a/fs/cifs/file.c
@@ -4933,7 +4933,8 @@ static int cifs_swap_activate(struct swa
 	 * from reading or writing the file
 	 */
 
-	return 0;
+	sis->flags |= SWP_FS_OPS;
+	return add_swap_extent(sis, 0, sis->max, 0);
 }
 
 static void cifs_swap_deactivate(struct file *file)
--- a/fs/nfs/file.c~mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate
+++ a/fs/nfs/file.c
@@ -483,6 +483,7 @@ static int nfs_swap_activate(struct swap
 {
 	unsigned long blocks;
 	long long isize;
+	int ret;
 	struct inode *inode = file_inode(file);
 	struct rpc_clnt *clnt = NFS_CLIENT(inode);
 	struct nfs_client *cl = NFS_SERVER(inode)->nfs_client;
@@ -496,13 +497,22 @@ static int nfs_swap_activate(struct swap
 		return -EINVAL;
 	}
 
-	*span = sis->pages;
+	ret = rpc_clnt_swap_activate(clnt);
+	if (ret)
+		return ret;
+	ret = add_swap_extent(sis, 0, sis->max, 0);
+	if (ret < 0) {
+		rpc_clnt_swap_deactivate(clnt);
+		return ret;
+	}
 
+	*span = sis->pages;
 
 	if (cl->rpc_ops->enable_swap)
 		cl->rpc_ops->enable_swap(inode);
 
-	return rpc_clnt_swap_activate(clnt);
+	sis->flags |= SWP_FS_OPS;
+	return ret;
 }
 
 static void nfs_swap_deactivate(struct file *file)
--- a/include/linux/swap.h~mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate
+++ a/include/linux/swap.h
@@ -577,6 +577,12 @@ static inline swp_entry_t get_swap_page(
 	return entry;
 }
 
+static inline int add_swap_extent(struct swap_info_struct *sis,
+				  unsigned long start_page,
+				  unsigned long nr_pages, sector_t start_block)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SWAP */
 
 #ifdef CONFIG_THP_SWAP
--- a/mm/swapfile.c~mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate
+++ a/mm/swapfile.c
@@ -2259,13 +2259,9 @@ static int setup_swap_extents(struct swa
 
 	if (mapping->a_ops->swap_activate) {
 		ret = mapping->a_ops->swap_activate(sis, swap_file, span);
-		if (ret >= 0)
-			sis->flags |= SWP_ACTIVATED;
-		if (!ret) {
-			sis->flags |= SWP_FS_OPS;
-			ret = add_swap_extent(sis, 0, sis->max, 0);
-			*span = sis->pages;
-		}
+		if (ret < 0)
+			return ret;
+		sis->flags |= SWP_ACTIVATED;
 		return ret;
 	}
 
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

