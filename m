Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88071C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiCaETI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiCaESy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:18:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75861AD3AE
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE8860C44
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 02:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5798C340EC;
        Thu, 31 Mar 2022 02:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648695373;
        bh=vZTtVuuHZIZIiSAVMjd6kUWado9C6Bu53MfXoBfJmuI=;
        h=Date:To:From:Subject:From;
        b=OaSfkuyTN5G5h9g42wAavTk85kHUr/DfalHaTVC/k0nWo5oMks8MhIOEbXnGoaIud
         XRgPXrEWRXwDgBYW7P8/YE+6xwghYZjA6TqdD46UB4fMaOCFEjotnVXXaMbw3uBoLL
         nIja4BpGO3R7dS7R9E5onCtE5xD8LHr0XnYLLtFg=
Date:   Wed, 30 Mar 2022 19:56:13 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, hughd@google.com, hch@lst.de,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch added to -mm tree
Message-Id: <20220331025613.A5798C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move responsibility for setting SWP_FS_OPS to ->swap_activate
has been added to the -mm tree.  Its filename is
     mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch

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
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/file.c       |    3 ++-
 fs/nfs/file.c        |   14 ++++++++++++--
 include/linux/swap.h |    6 ++++++
 mm/swapfile.c        |   10 +++-------
 4 files changed, 23 insertions(+), 10 deletions(-)

--- a/fs/cifs/file.c~mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate
+++ a/fs/cifs/file.c
@@ -4927,7 +4927,8 @@ static int cifs_swap_activate(struct swa
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
@@ -570,6 +570,12 @@ static inline swp_entry_t get_swap_page(
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
@@ -2244,13 +2244,9 @@ static int setup_swap_extents(struct swa
 
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

