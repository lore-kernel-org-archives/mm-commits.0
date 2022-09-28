Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6434C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 14:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiI1O4W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbiI1O4S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 10:56:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39E990825
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 07:56:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C2E61EC5
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 14:56:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C69C433D6;
        Wed, 28 Sep 2022 14:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664376965;
        bh=FACfqjpWleyq3h2v+2nOugOzfP2Xxz/5lfmhaOoLtgU=;
        h=Date:To:From:Subject:From;
        b=RZf4HIXJkcnCC0ap+ZtN5BxzY7Oc82r1uUUSaPWA7kvjbmzS5GyT0QCquaY9KR9H4
         541Sc1OAPFTngapQrt7F+WFkWItBdzYGwjZcAK/CVuiLchyV/z7dZZZoXDS+UoI4S3
         tRWur5ipy6gfyktVHBWAgeE270oa/I5j9WRzYyAY=
Date:   Wed, 28 Sep 2022 07:56:01 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, david@redhat.com, axboe@kernel.dk,
        anna@kernel.org, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] nfs-direct-io-convert-to-foll_pin-pages.patch removed from -mm tree
Message-Id: <20220928145605.66C69C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: NFS: direct-io: convert to FOLL_PIN pages
has been removed from the -mm tree.  Its filename was
     nfs-direct-io-convert-to-foll_pin-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: NFS: direct-io: convert to FOLL_PIN pages
Date: Tue, 30 Aug 2022 21:18:42 -0700

Convert the NFS Direct IO layer to use pin_user_pages_fast() and
unpin_user_page(), instead of get_user_pages_fast() and put_page().

The user of pin_user_pages_fast() depends upon:

1) CONFIG_BLK_USE_PIN_USER_PAGES_FOR_DIO, and

2) User-space-backed pages: user_backed_iter(i) == true

Link: https://lkml.kernel.org/r/20220831041843.973026-7-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/direct.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/nfs/direct.c~nfs-direct-io-convert-to-foll_pin-pages
+++ a/fs/nfs/direct.c
@@ -142,11 +142,13 @@ int nfs_swap_rw(struct kiocb *iocb, stru
 	return 0;
 }
 
-static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
+static void nfs_direct_release_pages(struct iov_iter *iter, struct page **pages,
+				     unsigned int npages)
 {
-	unsigned int i;
-	for (i = 0; i < npages; i++)
-		put_page(pages[i]);
+	if (user_backed_iter(iter) || iov_iter_is_bvec(iter))
+		dio_w_unpin_user_pages(pages, npages);
+	else
+		release_pages(pages, npages);
 }
 
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
@@ -332,11 +334,11 @@ static ssize_t nfs_direct_read_schedule_
 		size_t pgbase;
 		unsigned npages, i;
 
-		result = iov_iter_get_pages_alloc2(iter, &pagevec,
+		result = dio_w_iov_iter_pin_pages_alloc(iter, &pagevec,
 						  rsize, &pgbase);
 		if (result < 0)
 			break;
-	
+
 		bytes = result;
 		npages = (result + pgbase + PAGE_SIZE - 1) / PAGE_SIZE;
 		for (i = 0; i < npages; i++) {
@@ -362,7 +364,7 @@ static ssize_t nfs_direct_read_schedule_
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		nfs_direct_release_pages(iter, pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
@@ -791,8 +793,8 @@ static ssize_t nfs_direct_write_schedule
 		size_t pgbase;
 		unsigned npages, i;
 
-		result = iov_iter_get_pages_alloc2(iter, &pagevec,
-						  wsize, &pgbase);
+		result = dio_w_iov_iter_pin_pages_alloc(iter, &pagevec,
+							wsize, &pgbase);
 		if (result < 0)
 			break;
 
@@ -829,7 +831,7 @@ static ssize_t nfs_direct_write_schedule
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		nfs_direct_release_pages(iter, pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

fuse-convert-direct-io-paths-to-use-foll_pin.patch

