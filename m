Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B216ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 23:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiH0XGM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 19:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiH0XGL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 19:06:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3026547
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 16:06:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48D25B80A3B
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 23:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1246C433D7;
        Sat, 27 Aug 2022 23:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661641564;
        bh=IQadXlN7BwDM0R0px2gAJ8k0F5QlLGGnhJIG6nS3L18=;
        h=Date:To:From:Subject:From;
        b=KC2lSyNyAIz+qLVoEcFbK5i9LZ83A5cKd+CzNS2I28OVoq5h8jIv0sJXbdxBGgAfy
         b466biL8nCu5g2FoZghedL/spZlIwmNJMPfQiQkykqmQPb1RKT5PyGJrkx9kCt9cUy
         tuN5dm6UGy5STxtRZ/plbDbUmuT6cm5RQdgOnUKo=
Date:   Sat, 27 Aug 2022 16:06:03 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, axboe@kernel.dk, anna@kernel.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-gup-introduce-pin_user_page.patch removed from -mm tree
Message-Id: <20220827230604.B1246C433D7@smtp.kernel.org>
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
Date: Sat, 27 Aug 2022 01:36:02 -0700

Paaaatch series "convert most filesystems to pin_user_pages_fast()".

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


This patch (of 6):

pin_user_page() is an externally-usable version of try_grab_page(), but
with semantics that match get_page(), so that it can act as a drop-in
replacement for get_page().  Specifically, pin_user_page() has a void
return type.

pin_user_page() elevates a page's refcount using FOLL_PIN rules.  This
means that the caller must release the page via unpin_user_page().

Link: https://lkml.kernel.org/r/20220827083607.2345453-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20220827083607.2345453-2-jhubbard@nvidia.com
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

 include/linux/mm.h |    1 +
 mm/gup.c           |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

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
@@ -3238,6 +3238,39 @@ long pin_user_pages(unsigned long start,
 }
 EXPORT_SYMBOL(pin_user_pages);
 
+/**
+ * pin_user_page() - apply a FOLL_PIN reference to a page
+ *
+ * @page: the page to be pinned.
+ *
+ * This is similar to get_user_pages(), except that the page's refcount is
+ * elevated using FOLL_PIN, instead of FOLL_GET.
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

