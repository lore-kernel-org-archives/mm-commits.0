Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1549DC04A95
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 14:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiI1Ozf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiI1Oze (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 10:55:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEEF48CA8
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 07:55:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05D3E61EC5
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 14:55:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20507C433D6;
        Wed, 28 Sep 2022 14:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664376932;
        bh=gIrSsfKXmPdONKrO62gx8LW/KT37TqqnRrXHejQlSDw=;
        h=Date:To:From:Subject:From;
        b=GlTht7fVQz/oO24R//nprj3JwJFSitC5YOlGmNIl15BqnQoY8s3r3Db8iWoG2rktz
         55K7Ay4unNYBC19ip/ZLK+EMGUfKLHiPR3JP3C2e96V+7k8129+bRCMPkUdhvc68fV
         QtqAPnvehbxtJxVsFxVcv5uRd/BBjWGXO4Grhuyo=
Date:   Wed, 28 Sep 2022 07:55:25 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, david@redhat.com, axboe@kernel.dk,
        anna@kernel.org, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-change-release_pages-to-use-unsigned-long-for-npages.patch removed from -mm tree
Message-Id: <20220928145532.20507C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: change release_pages() to use unsigned long for npages
has been removed from the -mm tree.  Its filename was
     mm-change-release_pages-to-use-unsigned-long-for-npages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm: change release_pages() to use unsigned long for npages
Date: Tue, 30 Aug 2022 21:18:37 -0700

Patch series "convert most filesystems to pin_user_pages_fast()", v2.

This converts the iomap core and bio_release_pages() to
pin_user_pages_fast(), also referred to as FOLL_PIN here.

The conversion is temporarily guarded by
CONFIG_BLK_USE_PIN_USER_PAGES_FOR_DIO.  In the future (not part of this
series), when we are certain that all filesystems have converted their
Direct IO paths to FOLL_PIN, then we can do the final step, which is to
get rid of CONFIG_BLK_USE_PIN_USER_PAGES_FOR_DIO and search-and-replace
the dio_w_*() functions with their final names (see bvec.h changes).

I'd like to get this part committed at some point, because it seems to
work well already.  And this will help get the remaining items, below,
converted.

Status: although many filesystems have been converted, some remain to be
investigated.  These include (you can recreate this list by grepping for
iov_iter_get_pages):

	cephfs
	cifs
	9P
	RDS
	net/core: datagram.c, skmsg.c
	net/tls
	fs/splice.c


This patch (of 7):

The various callers of release_pages() are passing in either various types
(signed or unsigned) and lengths (int or long) of integers, for the second
argument (number of pages).  To make this conversion accurate and to avoid
having to check for overflow (or deal with type conversion warnings),
let's just change release_pages() to accept an unsigned long for the
number of pages.

Also change the name of the argument, from "nr" to "npages", for clarity,
as long as that line is being changed anyway.

Link: https://lkml.kernel.org/r/20220831041843.973026-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20220831041843.973026-2-jhubbard@nvidia.com
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

 include/linux/mm.h |    2 +-
 mm/swap.c          |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-change-release_pages-to-use-unsigned-long-for-npages
+++ a/include/linux/mm.h
@@ -1177,7 +1177,7 @@ static inline void folio_put_refs(struct
 		__folio_put(folio);
 }
 
-void release_pages(struct page **pages, int nr);
+void release_pages(struct page **pages, unsigned long npages);
 
 /**
  * folios_put - Decrement the reference count on an array of folios.
--- a/mm/swap.c~mm-change-release_pages-to-use-unsigned-long-for-npages
+++ a/mm/swap.c
@@ -975,15 +975,15 @@ void lru_cache_disable(void)
  * Decrement the reference count on all the pages in @pages.  If it
  * fell to zero, remove the page from the LRU and free it.
  */
-void release_pages(struct page **pages, int nr)
+void release_pages(struct page **pages, unsigned long npages)
 {
-	int i;
+	unsigned long i;
 	LIST_HEAD(pages_to_free);
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
 	unsigned int lock_batch;
 
-	for (i = 0; i < nr; i++) {
+	for (i = 0; i < npages; i++) {
 		struct folio *folio = page_folio(pages[i]);
 
 		/*
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-introduce-pin_user_page.patch
block-add-dio_w_-wrappers-for-pin-unpin-user-pages.patch
iov_iter-new-iov_iter_pin_pages-routines.patch
block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch
nfs-direct-io-convert-to-foll_pin-pages.patch
fuse-convert-direct-io-paths-to-use-foll_pin.patch

