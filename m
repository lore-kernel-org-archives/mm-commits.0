Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8BCC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 01:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353955AbiD2B3m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 21:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353909AbiD2B3m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 21:29:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5F5B6D3D
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 18:26:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A78A9621FC
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 01:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09727C385A9;
        Fri, 29 Apr 2022 01:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651195584;
        bh=OPxNZd1MxgA5Mvn/hJNXznJl867CxkoB9pBH+NI0xCM=;
        h=Date:To:From:Subject:From;
        b=zBPkWY/Om8VWWdp16zMTemSg5DH67nVeB2riQHnEMlyd73AfjcE6HErT/OEiy5pJ2
         k5nDE9/Gc47pX/usPR6z30ct0Nq/1tqZCbGQmh2y4p6rCoRHlKneqUjLYJzyfh31jk
         ntXwvsLtq+7t16osDhVQdM9GT+mogtEYIVw3uE9E=
Date:   Thu, 28 Apr 2022 18:26:23 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-handle-thp-in-swap_page_fs.patch added to -mm tree
Message-Id: <20220429012624.09727C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: handle THP in swap_*page_fs()
has been added to the -mm tree.  Its filename is
     mm-handle-thp-in-swap_page_fs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-handle-thp-in-swap_page_fs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-handle-thp-in-swap_page_fs.patch

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
Subject: mm: handle THP in swap_*page_fs()

Pages passed to swap_readpage()/swap_writepage() are not necessarily all
the same size - there may be transparent-huge-pages involves.

The BIO paths of swap_*page() handle this correctly, but the SWP_FS_OPS
path does not.

So we need to use thp_size() to find the size, not just assume PAGE_SIZE,
and we need to track the total length of the request, not just assume it
is "page * PAGE_SIZE".

Link: https://lkml.kernel.org/r/165119301488.15698.9457662928942765453.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/mm/page_io.c~mm-handle-thp-in-swap_page_fs
+++ a/mm/page_io.c
@@ -239,6 +239,7 @@ struct swap_iocb {
 	struct kiocb		iocb;
 	struct bio_vec		bvec[SWAP_CLUSTER_MAX];
 	int			pages;
+	int			len;
 };
 static mempool_t *sio_pool;
 
@@ -261,7 +262,7 @@ static void sio_write_complete(struct ki
 	struct page *page = sio->bvec[0].bv_page;
 	int p;
 
-	if (ret != PAGE_SIZE * sio->pages) {
+	if (ret != sio->len) {
 		/*
 		 * In the case of swap-over-nfs, this can be a
 		 * temporary failure if the system has limited
@@ -301,7 +302,7 @@ static int swap_writepage_fs(struct page
 		sio = *wbc->swap_plug;
 	if (sio) {
 		if (sio->iocb.ki_filp != swap_file ||
-		    sio->iocb.ki_pos + sio->pages * PAGE_SIZE != pos) {
+		    sio->iocb.ki_pos + sio->len != pos) {
 			swap_write_unplug(sio);
 			sio = NULL;
 		}
@@ -312,10 +313,12 @@ static int swap_writepage_fs(struct page
 		sio->iocb.ki_complete = sio_write_complete;
 		sio->iocb.ki_pos = pos;
 		sio->pages = 0;
+		sio->len = 0;
 	}
 	sio->bvec[sio->pages].bv_page = page;
-	sio->bvec[sio->pages].bv_len = PAGE_SIZE;
+	sio->bvec[sio->pages].bv_len = thp_size(page);
 	sio->bvec[sio->pages].bv_offset = 0;
+	sio->len += thp_size(page);
 	sio->pages += 1;
 	if (sio->pages == ARRAY_SIZE(sio->bvec) || !wbc->swap_plug) {
 		swap_write_unplug(sio);
@@ -371,8 +374,7 @@ void swap_write_unplug(struct swap_iocb
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, WRITE, sio->bvec, sio->pages,
-		      PAGE_SIZE * sio->pages);
+	iov_iter_bvec(&from, WRITE, sio->bvec, sio->pages, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_write_complete(&sio->iocb, ret);
@@ -383,7 +385,7 @@ static void sio_read_complete(struct kio
 	struct swap_iocb *sio = container_of(iocb, struct swap_iocb, iocb);
 	int p;
 
-	if (ret == PAGE_SIZE * sio->pages) {
+	if (ret == sio->len) {
 		for (p = 0; p < sio->pages; p++) {
 			struct page *page = sio->bvec[p].bv_page;
 
@@ -415,7 +417,7 @@ static void swap_readpage_fs(struct page
 		sio = *plug;
 	if (sio) {
 		if (sio->iocb.ki_filp != sis->swap_file ||
-		    sio->iocb.ki_pos + sio->pages * PAGE_SIZE != pos) {
+		    sio->iocb.ki_pos + sio->len != pos) {
 			swap_read_unplug(sio);
 			sio = NULL;
 		}
@@ -426,10 +428,12 @@ static void swap_readpage_fs(struct page
 		sio->iocb.ki_pos = pos;
 		sio->iocb.ki_complete = sio_read_complete;
 		sio->pages = 0;
+		sio->len = 0;
 	}
 	sio->bvec[sio->pages].bv_page = page;
-	sio->bvec[sio->pages].bv_len = PAGE_SIZE;
+	sio->bvec[sio->pages].bv_len = thp_size(page);
 	sio->bvec[sio->pages].bv_offset = 0;
+	sio->len += thp_size(page);
 	sio->pages += 1;
 	if (sio->pages == ARRAY_SIZE(sio->bvec) || !plug) {
 		swap_read_unplug(sio);
@@ -521,8 +525,7 @@ void __swap_read_unplug(struct swap_iocb
 	struct address_space *mapping = sio->iocb.ki_filp->f_mapping;
 	int ret;
 
-	iov_iter_bvec(&from, READ, sio->bvec, sio->pages,
-		      PAGE_SIZE * sio->pages);
+	iov_iter_bvec(&from, READ, sio->bvec, sio->pages, sio->len);
 	ret = mapping->a_ops->swap_rw(&sio->iocb, &from);
 	if (ret != -EIOCBQUEUED)
 		sio_read_complete(&sio->iocb, ret);
_

Patches currently in -mm which might be from neilb@suse.de are

mm-create-new-mm-swaph-header-file.patch
mm-drop-swap_dirty_folio.patch
mm-move-responsibility-for-setting-swp_fs_ops-to-swap_activate.patch
mm-reclaim-mustnt-enter-fs-for-swp_fs_ops-swap-space.patch
mm-introduce-swap_rw-and-use-it-for-reads-from-swp_fs_ops-swap-space.patch
nfs-rename-nfs_direct_io-and-use-as-swap_rw.patch
mm-perform-async-writes-to-swp_fs_ops-swap-space-using-swap_rw.patch
doc-update-documentation-for-swap_activate-and-swap_rw.patch
mm-submit-multipage-reads-for-swp_fs_ops-swap-space.patch
mm-submit-multipage-write-for-swp_fs_ops-swap-space.patch
mm-handle-thp-in-swap_page_fs.patch
vfs-add-fmode_can_odirect-file-flag.patch
mm-discard-__gfp_atomic.patch

