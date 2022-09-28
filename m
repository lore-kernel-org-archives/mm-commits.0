Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1A7C32771
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 14:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbiI1Ozt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiI1Ozq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 10:55:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1727FB4E
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 07:55:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65E7961ED5
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 14:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859DDC433D6;
        Wed, 28 Sep 2022 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664376939;
        bh=xEogSp+bfJ6UolybdI4oTv4DLoIzMIEcT7KBPAzFN4g=;
        h=Date:To:From:Subject:From;
        b=jNpyfqYozvhzVJvwZ1kgb30d8cqf4PqchO+vS65w5Os7siJaGh7RlHDZxibjju1Y3
         o9y77ne6yPUKRiREFzIYkT+eIZOA/TmA7lI90PsHzoAkHtTL6fnUf+ue26i7htQXTT
         +YDy6+Lh1f24GIs7zSHgrHFKeEg7Rdh6y9WEqCtQ=
Date:   Wed, 28 Sep 2022 07:55:33 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, david@redhat.com, axboe@kernel.dk,
        anna@kernel.org, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-gup-introduce-pin_user_page.patch removed from -mm tree
Message-Id: <20220928145539.859DDC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: introduce pin_user_page()
has been removed from the -mm tree.  Its filename was
     mm-gup-introduce-pin_user_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: introduce pin_user_page()
Date: Tue, 30 Aug 2022 21:18:38 -0700

pin_user_page() is an externally-usable version of try_grab_page(), but
with semantics that match get_page(), so that it can act as a drop-in
replacement for get_page(). Specifically, pin_user_page() has a void
return type.

pin_user_page() elevates a page's refcount using FOLL_PIN rules. This
means that the caller must release the page via unpin_user_page().

Link: https://lkml.kernel.org/r/20220831041843.973026-3-jhubbard@nvidia.com
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

 include/linux/mm.h |    1 
 mm/gup.c           |   50 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

--- a/include/linux/mm.h~mm-gup-introduce-pin_user_page
+++ a/include/linux/mm.h
@@ -1943,6 +1943,7 @@ long pin_user_pages_remote(struct mm_str
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 			    unsigned int gup_flags, struct page **pages,
 			    struct vm_area_struct **vmas);
+void pin_user_page(struct page *page);
 long pin_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages,
 		    struct vm_area_struct **vmas);
--- a/mm/gup.c~mm-gup-introduce-pin_user_page
+++ a/mm/gup.c
@@ -3281,6 +3281,56 @@ long pin_user_pages(unsigned long start,
 }
 EXPORT_SYMBOL(pin_user_pages);
 
+/**
+ * pin_user_page() - apply a FOLL_PIN reference to a file-backed page that the
+ * caller already owns.
+ *
+ * @page: the page to be pinned.
+ *
+ * pin_user_page() elevates a page's refcount using FOLL_PIN rules. This means
+ * that the caller must release the page via unpin_user_page().
+ *
+ * pin_user_page() is intended as a drop-in replacement for get_page(). This
+ * provides a way for callers to do a subsequent unpin_user_page() on the
+ * affected page. However, it is only intended for use by callers (file systems,
+ * block/bio) that have a file-backed page. Anonymous pages are not expected nor
+ * supported, and will generate a warning.
+ *
+ * pin_user_page() may also be thought of as an externally-usable version of
+ * try_grab_page(), but with semantics that match get_page(), so that it can act
+ * as a drop-in replacement for get_page().
+ *
+ * IMPORTANT: The caller must release the page via unpin_user_page().
+ *
+ */
+void pin_user_page(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	WARN_ON_ONCE(folio_ref_count(folio) <= 0);
+
+	/*
+	 * This function is only intended for file-backed callers, who already
+	 * have a page reference.
+	 */
+	WARN_ON_ONCE(PageAnon(page));
+
+	/*
+	 * Similar to try_grab_page(): be sure to *also*
+	 * increment the normal page refcount field at least once,
+	 * so that the page really is pinned.
+	 */
+	if (folio_test_large(folio)) {
+		folio_ref_add(folio, 1);
+		atomic_add(1, folio_pincount_ptr(folio));
+	} else {
+		folio_ref_add(folio, GUP_PIN_COUNTING_BIAS);
+	}
+
+	node_stat_mod_folio(folio, NR_FOLL_PIN_ACQUIRED, 1);
+}
+EXPORT_SYMBOL(pin_user_page);
+
 /*
  * pin_user_pages_unlocked() is the FOLL_PIN variant of
  * get_user_pages_unlocked(). Behavior is the same, except that this one sets
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

block-add-dio_w_-wrappers-for-pin-unpin-user-pages.patch
iov_iter-new-iov_iter_pin_pages-routines.patch
block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch
nfs-direct-io-convert-to-foll_pin-pages.patch
fuse-convert-direct-io-paths-to-use-foll_pin.patch

