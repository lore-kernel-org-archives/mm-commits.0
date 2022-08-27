Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EECC7ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiH0W3I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiH0W3E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:29:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AAB44564
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 366D660EC8
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843D4C433D6;
        Sat, 27 Aug 2022 22:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661639342;
        bh=WUGlmUA0UBB+uesj554W7foyprSMO56LDbbZimTmA4U=;
        h=Date:To:From:Subject:From;
        b=SdJN/YA7kWdDadsRze3eoNp/6sBA9zFej3XaXufJUGwuxceLvhvob15FsJ0R2eIuU
         apVUzC5mFqCnDHAf3mcPmOqjiY+kV+ojkjdCNb/tGdFcY3Liwtx4H+BagdX/y8KFTY
         eG9GhRZO+SdhBbO/xazoZ24vj8pDglwvLZ7pIA4A=
Date:   Sat, 27 Aug 2022 15:29:01 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, axboe@kernel.dk, anna@kernel.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-direct-io-convert-to-foll_pin-pages.patch added to mm-unstable branch
Message-Id: <20220827222902.843D4C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: NFS: direct-io: convert to FOLL_PIN pages
has been added to the -mm mm-unstable branch.  Its filename is
     nfs-direct-io-convert-to-foll_pin-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nfs-direct-io-convert-to-foll_pin-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-gup-introduce-pin_user_page.patch
block-add-dio_w_-wrappers-for-pin-unpin-user-pages.patch
iov_iter-new-iov_iter_pin_pages-routines.patch
block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch
nfs-direct-io-convert-to-foll_pin-pages.patch
fuse-convert-direct-io-paths-to-use-foll_pin.patch

