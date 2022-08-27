Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887C7C0502A
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 23:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiH0XGM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 19:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiH0XGL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 19:06:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EFE26134
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 16:06:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3B7660EB5
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 23:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B281C433D6;
        Sat, 27 Aug 2022 23:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661641567;
        bh=8NMX9T6ObTcyDfzMy+fLu9ovKE99EzBmIcbZGZfS8Tw=;
        h=Date:To:From:Subject:From;
        b=e+QuyCdGRdAzbkolZMPgCeaXY+kr+Z+N9/gxTA5WFz4GlF+tonI9iKkWx0WuI4+X3
         WCredgWVFbEmqoK5+OfuNpt45iLaqmar+WKFaHUHNIM08KkUOOrK0dVr5hMHzgS8Vy
         NYJ+Rthpg2NXEDGj+3VGw+voZWgc2R61mG+P9l3E=
Date:   Sat, 27 Aug 2022 16:06:06 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, axboe@kernel.dk, anna@kernel.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] iov_iter-new-iov_iter_pin_pages-routines.patch removed from -mm tree
Message-Id: <20220827230607.4B281C433D6@smtp.kernel.org>
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
Date: Sat, 27 Aug 2022 01:36:04 -0700

Provide two new wrapper routines that are intended for user space pages
only:

    iov_iter_pin_pages()
    iov_iter_pin_pages_alloc()

Internally, these routines call pin_user_pages_fast(), instead of
get_user_pages_fast().

As always, callers must use unpin_user_pages() or a suitable FOLL_PIN
variant, to release the pages, if they actually were acquired via
pin_user_pages_fast().

This is a prerequisite to converting bio/block layers over to use
pin_user_pages_fast().

Link: https://lkml.kernel.org/r/20220827083607.2345453-4-jhubbard@nvidia.com
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

 include/linux/uio.h |    4 ++
 lib/iov_iter.c      |   74 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 74 insertions(+), 4 deletions(-)

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
@@ -1425,9 +1425,23 @@ static struct page *first_bvec_segment(c
 	return page;
 }
 
+enum pages_alloc_internal_flags {
+	USE_FOLL_GET,
+	USE_FOLL_PIN
+};
+
+/*
+ * TODO: get rid of the how_to_pin arg, and just call pin_user_pages_fast()
+ * unconditionally for the user_back_iter(i) case in this function. That can be
+ * done once all callers are ready to deal with FOLL_PIN pages for their
+ * user-space pages. (FOLL_PIN pages must be released via unpin_user_page(),
+ * rather than put_page().)
+ */
 static ssize_t __iov_iter_get_pages_alloc(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
-		   unsigned int maxpages, size_t *start)
+		   unsigned int maxpages, size_t *start,
+		   enum pages_alloc_internal_flags how_to_pin)
+
 {
 	unsigned int n;
 
@@ -1454,7 +1468,12 @@ static ssize_t __iov_iter_get_pages_allo
 		n = want_pages_array(pages, maxsize, *start, maxpages);
 		if (!n)
 			return -ENOMEM;
-		res = get_user_pages_fast(addr, n, gup_flags, *pages);
+
+		if (how_to_pin == USE_FOLL_PIN)
+			res = pin_user_pages_fast(addr, n, gup_flags, *pages);
+		else
+			res = get_user_pages_fast(addr, n, gup_flags, *pages);
+
 		if (unlikely(res <= 0))
 			return res;
 		maxsize = min_t(size_t, maxsize, res * PAGE_SIZE - *start);
@@ -1497,10 +1516,31 @@ ssize_t iov_iter_get_pages2(struct iov_i
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
+	if (WARN_ON_ONCE(!user_backed_iter(i)))
+		return -EINVAL;
+
+	return __iov_iter_get_pages_alloc(i, &pages, maxsize, maxpages, start,
+					  USE_FOLL_PIN);
+}
+EXPORT_SYMBOL(iov_iter_pin_pages);
+
 ssize_t iov_iter_get_pages_alloc2(struct iov_iter *i,
 		   struct page ***pages, size_t maxsize,
 		   size_t *start)
@@ -1509,7 +1549,8 @@ ssize_t iov_iter_get_pages_alloc2(struct
 
 	*pages = NULL;
 
-	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start);
+	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start,
+					 USE_FOLL_GET);
 	if (len <= 0) {
 		kvfree(*pages);
 		*pages = NULL;
@@ -1518,6 +1559,31 @@ ssize_t iov_iter_get_pages_alloc2(struct
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
+	if (WARN_ON_ONCE(!user_backed_iter(i)))
+		return -EINVAL;
+
+	len = __iov_iter_get_pages_alloc(i, pages, maxsize, ~0U, start,
+					 USE_FOLL_PIN);
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

