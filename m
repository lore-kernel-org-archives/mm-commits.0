Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F85ECAAD5
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiH0W2y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiH0W2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E628043E4F
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:28:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C10D60EA8
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F9BC433D7;
        Sat, 27 Aug 2022 22:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661639332;
        bh=PPAcwhsJRAKVGy3oenggmc/MxmUT01FLdrAA318q+l8=;
        h=Date:To:From:Subject:From;
        b=XipR8LSyrPgvGMeQ7/EPVZNfQhK2ZEMv8tadLeohT3EsHKOG8A1hJeiBtPFkI1zNK
         k8BiiiBBUga46jpJmgXH9u9qUp/eu3U9pby/9T1V88ENDgZCwdOF9CFzCu2VK1Ms0j
         4nIjAONz25xJeEWC8I0HscI7yV+tjX5yqA3zAbxg=
Date:   Sat, 27 Aug 2022 15:28:51 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        trond.myklebust@hammerspace.com, miklos@szeredi.hu,
        logang@deltatee.com, jack@suse.cz, hch@infradead.org,
        djwong@kernel.org, axboe@kernel.dk, anna@kernel.org,
        jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-introduce-pin_user_page.patch added to mm-unstable branch
Message-Id: <20220827222851.D5F9BC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: introduce pin_user_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-introduce-pin_user_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-introduce-pin_user_page.patch

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

mm-gup-introduce-pin_user_page.patch
block-add-dio_w_-wrappers-for-pin-unpin-user-pages.patch
iov_iter-new-iov_iter_pin_pages-routines.patch
block-bio-fs-convert-most-filesystems-to-pin_user_pages_fast.patch
nfs-direct-io-convert-to-foll_pin-pages.patch
fuse-convert-direct-io-paths-to-use-foll_pin.patch

