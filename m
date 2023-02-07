Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358FCC636D6
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBGB3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBGB3g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3AD2ED48
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87002B8167B
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED5EC4339B;
        Tue,  7 Feb 2023 01:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733371;
        bh=c49ATV7kAdinZRJgK5WF1rk8Gal6cFW992/8O5LndOw=;
        h=Date:To:From:Subject:From;
        b=0VCDV4Kac26FQlV3nStNNkh1TxSlYFerieNVJAxj8dyh0ZCjg+dr599MLFEYXtSI/
         J0YqCsvLG0Pso/qhKtBclq97/G218mFnFB2BjPUXbl0sDMw8tJTP0S4m9pC19AHwmW
         LUoxOX6CcklvjpAnaG8DF2EzpgIH1nKOhBefJYa0=
Date:   Mon, 06 Feb 2023 17:29:30 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-obsolete-foll_longterm-comment.patch added to mm-unstable branch
Message-Id: <20230207012931.1ED5EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove obsolete FOLL_LONGTERM comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-obsolete-foll_longterm-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-obsolete-foll_longterm-comment.patch

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
Subject: mm/gup: remove obsolete FOLL_LONGTERM comment
Date: Tue, 24 Jan 2023 16:34:23 -0400

These days FOLL_LONGTERM is not allowed at all on any get_user_pages*()
functions, it must be only be used with pin_user_pages*(), plus it now has
universal support for all the pin_user_pages*() functions.

Link: https://lkml.kernel.org/r/2-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
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


--- a/include/linux/mm_types.h~mm-gup-remove-obsolete-foll_longterm-comment
+++ a/include/linux/mm_types.h
@@ -1058,12 +1058,6 @@ typedef unsigned int __bitwise zap_flags
  * specifically failed.  Filesystem pages are still subject to bugs and use of
  * FOLL_LONGTERM should be avoided on those pages.
  *
- * FIXME: Also NOTE that FOLL_LONGTERM is not supported in every GUP call.
- * Currently only get_user_pages() and get_user_pages_fast() support this flag
- * and calls to get_user_pages_[un]locked are specifically not allowed.  This
- * is due to an incompatibility with the FS DAX check and
- * FAULT_FLAG_ALLOW_RETRY.
- *
  * In the CMA case: long term pins in a CMA region would unnecessarily fragment
  * that region.  And so, CMA attempts to migrate the page before pinning, when
  * FOLL_LONGTERM is specified.
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

