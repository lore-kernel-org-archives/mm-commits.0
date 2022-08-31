Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057F2ECAAD4
	for <mm-commits@archiver.kernel.org>; Wed, 31 Aug 2022 23:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbiHaXHA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Aug 2022 19:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiHaXGw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Aug 2022 19:06:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47D7F8EFA
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 16:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 715C661C5D
        for <mm-commits@vger.kernel.org>; Wed, 31 Aug 2022 23:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EBCC433C1;
        Wed, 31 Aug 2022 23:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661987210;
        bh=Is4AXTCZKPuS1w8Rv4Nb9JqsMe8anevxxcR6ifev2CY=;
        h=Date:To:From:Subject:From;
        b=jqmjNUHoUyqgPFjaZPl/G32i1OJaAz10hSCJy4bAIFyQN4XDiNm1BQbsAdXikWLZQ
         O6iKRngYp0nFiFUvOpw5PFG4Frbif+VlEjrODc4o8QlqQGrnLzV2AXQt+l0O+s1068
         ielAMfj/Kp+o7z5wxUFytVqTaRlptdSPrm4VMGOE=
Date:   Wed, 31 Aug 2022 16:06:50 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, david@redhat.com, axboe@kernel.dk,
        anna@kernel.org, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nfs-direct-io-convert-to-foll_pin-pages.patch added to mm-unstable branch
Message-Id: <20220831230650.C4EBCC433C1@smtp.kernel.org>
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

mm-change-release_pages-to-use-unsigned-long-for-npages.patch
mm-gup-introduce-pin_user_page.patch
block-add-dio_w_-wrappers-for-pin-unpin-user-pages.patch
iov_iter-new-iov_iter_pin_pages-routines.patch
block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch
nfs-direct-io-convert-to-foll_pin-pages.patch
fuse-convert-direct-io-paths-to-use-foll_pin.patch

