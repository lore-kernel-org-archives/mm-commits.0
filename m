Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E150C0502C
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 23:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiH0XGO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 19:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiH0XGL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 19:06:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D8C2655C
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 16:06:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8367960EEA
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 23:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F33C433D6;
        Sat, 27 Aug 2022 23:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661641569;
        bh=khJrvfGcbus/SJsR83M/5989092xWpm3Vs3UCd0BBkU=;
        h=Date:To:From:Subject:From;
        b=dq6ziJj9zKipY8862vxUjjfOTtEp3cPgUPpEgkMKO1N2GA/wO22PuZ/+dG6B3gT5X
         zTrwvMPOSTR+kNM6wEBI+3VSWlgwvMH1KsGD6GvIk+OiCUq70PTmgwxWaxNLj7O53b
         nct68o+IPdWBYUsuomfltO0mxnsYN4gty2aotg3Y=
Date:   Sat, 27 Aug 2022 16:06:09 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, axboe@kernel.dk, anna@kernel.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] nfs-direct-io-convert-to-foll_pin-pages.patch removed from -mm tree
Message-Id: <20220827230609.D3F33C433D6@smtp.kernel.org>
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
Date: Sat, 27 Aug 2022 01:36:06 -0700

Convert the NFS Direct IO layer to use pin_user_pages_fast() and
unpin_user_page(), instead of get_user_pages_fast() and put_page().

Link: https://lkml.kernel.org/r/20220827083607.2345453-6-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/direct.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/fs/nfs/direct.c~nfs-direct-io-convert-to-foll_pin-pages
+++ a/fs/nfs/direct.c
@@ -142,13 +142,6 @@ int nfs_swap_rw(struct kiocb *iocb, stru
 	return 0;
 }
 
-static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
-{
-	unsigned int i;
-	for (i = 0; i < npages; i++)
-		put_page(pages[i]);
-}
-
 void nfs_init_cinfo_from_dreq(struct nfs_commit_info *cinfo,
 			      struct nfs_direct_req *dreq)
 {
@@ -332,11 +325,11 @@ static ssize_t nfs_direct_read_schedule_
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
@@ -362,7 +355,7 @@ static ssize_t nfs_direct_read_schedule_
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		dio_w_unpin_user_pages(pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
@@ -791,8 +784,8 @@ static ssize_t nfs_direct_write_schedule
 		size_t pgbase;
 		unsigned npages, i;
 
-		result = iov_iter_get_pages_alloc2(iter, &pagevec,
-						  wsize, &pgbase);
+		result = dio_w_iov_iter_pin_pages_alloc(iter, &pagevec,
+							wsize, &pgbase);
 		if (result < 0)
 			break;
 
@@ -829,7 +822,7 @@ static ssize_t nfs_direct_write_schedule
 			pos += req_len;
 			dreq->bytes_left -= req_len;
 		}
-		nfs_direct_release_pages(pagevec, npages);
+		dio_w_unpin_user_pages(pagevec, npages);
 		kvfree(pagevec);
 		if (result < 0)
 			break;
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

fuse-convert-direct-io-paths-to-use-foll_pin.patch

