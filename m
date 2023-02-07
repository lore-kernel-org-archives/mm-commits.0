Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0500C05027
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBGB3k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBGB3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B02ED48
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F06F7B816BF
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB13C4339B;
        Tue,  7 Feb 2023 01:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733374;
        bh=0vTccsv76F8hgfGBTmnwfoUYA6id1XRM5qfGFrm6IcE=;
        h=Date:To:From:Subject:From;
        b=Kxi1B44k8kiORVbGFf6HiY+ymfwnJB0+IN8REcKbdzzozEmOcWO28Nbx8euDfR1Rh
         Wl5LipqK2GkkFxfMUNGwlKFdoesfNbKasckdZbUZdkz83dNjFeIgnza3ZpvrcMqDSU
         n/5foliFCEiARMX7tovAByvKF5tKOigS17/SpwlE=
Date:   Mon, 06 Feb 2023 17:29:33 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-move-try_grab_page-to-mm-internalh.patch added to mm-unstable branch
Message-Id: <20230207012934.7BB13C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: move try_grab_page() to mm/internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-move-try_grab_page-to-mm-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-move-try_grab_page-to-mm-internalh.patch

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
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: move try_grab_page() to mm/internal.h
Date: Tue, 24 Jan 2023 16:34:25 -0400

This is part of the internal function of gup.c and is only non-static so
that the parts of gup.c in the huge_memory.c and hugetlb.c can call it.

Put it in internal.h beside the similarly purposed try_grab_folio()

Link: https://lkml.kernel.org/r/4-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm.h~mm-gup-move-try_grab_page-to-mm-internalh
+++ a/include/linux/mm.h
@@ -1275,8 +1275,6 @@ static inline void get_page(struct page
 	folio_get(page_folio(page));
 }
 
-int __must_check try_grab_page(struct page *page, unsigned int flags);
-
 static inline __must_check bool try_get_page(struct page *page)
 {
 	page = compound_head(page);
--- a/mm/internal.h~mm-gup-move-try_grab_page-to-mm-internalh
+++ a/mm/internal.h
@@ -856,6 +856,7 @@ int migrate_device_coherent_page(struct
  * mm/gup.c
  */
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags);
+int __must_check try_grab_page(struct page *page, unsigned int flags);
 
 extern bool mirrored_kernelcore;
 
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-have-internal-functions-get-the-mmap_read_lock.patch
mm-gup-remove-obsolete-foll_longterm-comment.patch
mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch
mm-gup-move-try_grab_page-to-mm-internalh.patch
mm-gup-simplify-the-external-interface-functions-and-consolidate-invariants.patch
mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch
mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch
mm-gup-add-foll_unlockable.patch
mm-gup-make-locked-never-null-in-the-internal-gup-functions.patch
mm-gup-remove-pin_user_pages_fast_only.patch
mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch
mm-gup-move-gup_must_unshare-to-mm-internalh.patch
mm-gup-move-private-gup-foll_-flags-to-internalh.patch

