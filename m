Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC92C04A95
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 14:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbiI1O4A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiI1Oz6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 10:55:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508F87DF4E
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 07:55:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1063B820EA
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 14:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76FC1C433B5;
        Wed, 28 Sep 2022 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664376953;
        bh=6/uL0x4Z11TyD8zLKbJlQPbuv8j1c7bsjQrzwJ82WaY=;
        h=Date:To:From:Subject:From;
        b=yelzcshhOQTAHlDuErOH9Ued8UAmJpRV5Qet2w5wdYwHTpvhkA2FXRjFO8Be7cwHT
         Xx0Kay46RFuJr5nVC/qhdYOfg78Nn0FMUVeabNVpvOZRQQJQ71VYR9rBONouSFvO6U
         OaTU/xbHacJm7GTNgsX5UZt0jZXvM29Ac5xpXXSY=
Date:   Wed, 28 Sep 2022 07:55:47 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, david@redhat.com, axboe@kernel.dk,
        anna@kernel.org, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] iov_iter-new-iov_iter_pin_pages-routines.patch removed from -mm tree
Message-Id: <20220928145553.76FC1C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iov_iter: new iov_iter_pin_pages*() routines
has been removed from the -mm tree.  Its filename was
     iov_iter-new-iov_iter_pin_pages-routines.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: iov_iter: new iov_iter_pin_pages*() routines
Date: Tue, 30 Aug 2022 21:18:40 -0700

Provide two new wrapper routines that are intended for user space pages
only:

    iov_iter_pin_pages()
    iov_iter_pin_pages_alloc()

Internally, these routines call pin_user_pages_fast(), instead of
get_user_pages_fast(), for user_backed_iter(i) and iov_iter_bvec(i)
cases.

As always, callers must use unpin_user_pages() or a suitable FOLL_PIN
variant, to release the pages, if they actually were acquired via
pin_user_pages_fast().

This is a prerequisite to converting bio/block layers over to use
pin_user_pages_fast().

Link: https://lkml.kernel.org/r/20220831041843.973026-5-jhubbard@nvidia.com
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

 include/linux/uio.h |    4 +
 lib/iov_iter.c      |   86 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 84 insertions(+), 6 deletions(-)

--- a/include/linux/uio.h~iov_iter-new-iov_iter_pin_pages-routines
+++ a/include/linux/uio.h
@@ -251,6 +251,10 @@ ssize_t iov_iter_get_pages2(struct iov_i
 			size_t maxsize, unsigned maxpages, size_t *start);
 ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
+ssize_t iov_iter_pin_pages(struct iov_iter *i, struct page **pages,
+			size_t maxsize, unsigned int maxpages, size_t *start);
+ssize_t iov_iter_pin_pages_alloc(struct iov_iter *i, struct page ***pages,
+			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
 void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state);
 
--- a/lib/iov_iter.c~iov_iter-new-iov_iter_pin_pages-routines
+++ a/lib/iov_iter.c
@@ -1425,9 +1425,31 @@ static struct page *first_bvec_segment(c
 	return page;
 }
 
+enum pages_alloc_internal_flags {
+	USE_FOLL_GET,
+	MAYBE_USE_FOLL_PIN
+};
+
+/*
+ * Pins pages, either via get_page(), or via pin_user_page*(). The caller is
+ * responsible for tracking which pinning mechanism was used here, and releasing
+ * pages via the appropriate call: put_page() or unpin_user_page().
+ *
+ * The way to figure that out is:
+ *
+ *     a) If how_to_pin == FOLL_GET, then this routine will always pin via
+ *        get_page().
+ *
+ *     b) If how_to_pin == MAYBE_USE_FOLL_PIN, then this routine will pin via
+ *          pin_user_page*() for either user_backed_iter(i) cases, or
+ *          iov_iter_is_bvec(i) cases. However, for the other cases (pipe,
+ *          xarray), pages will be pinned via get_page().
+ */
 static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
-		   unsigned int maxpages, size_t *start)
+		   unsigned int maxpages, size_t *start,
+		   enum pages_alloc_internal_flags how_to_pin)
+
 {
 	unsigned int n;
 
@@ -1454,7 +1476,12 @@ static ssize_t __iov_iter_get_pages_allo
 		n = want_pages_array(pages, maxsize, *start, maxpages);
 		if (!n)
 			return -ENOMEM;
-		res = get_user_pages_fast(addr, n, gup_flags, *pages);
+
+		if (how_to_pin == MAYBE_USE_FOLL_PIN)
+			res = pin_user_pages_fast(addr, n, gup_flags, *pages);
+		else
+			res = get_user_pages_fast(addr, n, gup_flags, *pages);
+
 		if (unlikely(res <= 0))
 			return res;
 		maxsize = min_t(size_t, maxsize, res * PAGE_SIZE - *start);
@@ -1470,8 +1497,13 @@ static ssize_t __iov_iter_get_pages_allo
 		if (!n)
 			return -ENOMEM;
 		p = *pages;
-		for (int k = 0; k < n; k++)
-			get_page(p[k] = page + k);
+		for (int k = 0; k < n; k++) {
+			p[k] = page + k;
+			if (how_to_pin == MAYBE_USE_FOLL_PIN)
+				pin_user_page(p[k]);
+			else
+				get_page(p[k]);
+		}
 		maxsize = min_t(size_t, maxsize, n * PAGE_SIZE - *start);
 		i->count -= maxsize;
 		i->iov_offset += maxsize;
@@ -1497,10 +1529,29 @@ ssize_t iov_iter_get_pages2(struct iov_i
 		return 0;
 	BUG_ON(!pages);
 
-	return __iov_iter_get_pages_alloc(i, &pages, maxsize, maxpages, start);
+	return __iov_iter_get_pages_alloc(i, &pages, maxsize, maxpages, start,
+					  USE_FOLL_GET);
 }
 EXPORT_SYMBOL(iov_iter_get_pages2);
 
+/*
+ * A FOLL_PIN variant that calls pin_user_pages_fast() instead of
+ * get_user_pages_fast().
+ */
+ssize_t iov_iter_pin_pages(struct iov_iter *i,
+		   struct page **pages, size_t maxsize, unsigned int maxpages,
+		   size_t *start)
+{
+	if (!maxpages)
+		return 0;
+	if (WARN_ON_ONCE(!pages))
+		return -EINVAL;
+
+	return __iov_iter_get_pages_alloc(i, &pages, maxsize, maxpages, start,
+					  MAYBE_USE_FOLL_PIN);
+}
+EXPORT_SYMBOL(iov_iter_pin_pages);
+
 ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
 		   size_t *start)
@@ -1509,7 +1560,8 @@ ssize_t iov_iter_get_pages_alloc2(struct
 
 	*pages = NULL;
 
-	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start);
+	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start,
+					 USE_FOLL_GET);
 	if (len <= 0) {
 		kvfree(*pages);
 		*pages = NULL;
@@ -1518,6 +1570,28 @@ ssize_t iov_iter_get_pages_alloc2(struct
 }
 EXPORT_SYMBOL(iov_iter_get_pages_alloc2);
 
+/*
+ * A FOLL_PIN variant that calls pin_user_pages_fast() instead of
+ * get_user_pages_fast().
+ */
+ssize_t iov_iter_pin_pages_alloc(struct iov_iter *i,
+		   struct page ***pages, size_t maxsize,
+		   size_t *start)
+{
+	ssize_t len;
+
+	*pages = NULL;
+
+	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start,
+					 MAYBE_USE_FOLL_PIN);
+	if (len <= 0) {
+		kvfree(*pages);
+		*pages = NULL;
+	}
+	return len;
+}
+EXPORT_SYMBOL(iov_iter_pin_pages_alloc);
+
 size_t csum_and_copy_from_iter(void *addr, size_t bytes, __wsum *csum,
 			       struct iov_iter *i)
 {
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch
nfs-direct-io-convert-to-foll_pin-pages.patch
fuse-convert-direct-io-paths-to-use-foll_pin.patch

