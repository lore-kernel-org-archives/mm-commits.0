Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0239C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235412AbiEJEV4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F162B031E
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81556B81B00
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F6CC385A6;
        Tue, 10 May 2022 04:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156119;
        bh=/PbndG/iwPYTCoqE3zP+/Ql6t8ZaTJJ5FdNyaWt5lDQ=;
        h=Date:To:From:Subject:From;
        b=EQoom6GMYNqE0UxsfWsOg1Y2hOeDWrs6GSsihM9hxN/s8VXdpTugIleZr+igjBJIL
         ZXHCovsbtj/GKDr5qyJTSbRB4YoI8WmtpaVn4aDEngcYb9T63l76pref8onLzVet13
         4zvJisvlbg+9znphgdmd9groI3I3ha+3+PDyu7w4=
Date:   Mon, 09 May 2022 21:15:18 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        mgorman@techsingularity.net, linmiaohe@huawei.com,
        hughd@google.com, hch@lst.de, geert+renesas@glider.be,
        dhowells@redhat.com, neilb@suse.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-thp-in-swap_page_fs.patch removed from -mm tree
Message-Id: <20220510041519.34F6CC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle THP in swap_*page_fs()
has been removed from the -mm tree.  Its filename was
     mm-handle-thp-in-swap_page_fs.patch

This patch was dropped because it was merged into mm-stable

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

mm-discard-__gfp_atomic.patch

