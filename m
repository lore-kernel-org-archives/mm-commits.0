Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E144DC433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 20:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiBAU63 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Feb 2022 15:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiBAU6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Feb 2022 15:58:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D66C06173B
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 12:58:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA186176B
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 20:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8414C340EB;
        Tue,  1 Feb 2022 20:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643749102;
        bh=DLNcyv7PXYZceHyjiiQerbztLIhL51QKhwoiOjDUajI=;
        h=Date:To:From:Subject:From;
        b=AJu9uEPrzBqN6cJQcsTmqwL29cIm7zKflaeoVWFJdDU+Oyw6tpMtl/3znKXMLjD3E
         v5NXGaMA8mpJvBXeTkFZ72EPuIigN2mJejd9Nlcik1uYnsF5CuKKbzFbRKxP6axF5y
         nalapwxkYkoGLXIbcowKvRTQxVH6wVueuzn3abhw=
Received: by hp1 (sSMTP sendmail emulation); Tue, 01 Feb 2022 12:58:20 -0800
Date:   Tue, 01 Feb 2022 12:58:20 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        kirill.shutemov@linux.intel.com, jgg@ziepe.ca, jgg@nvidia.com,
        jack@suse.cz, david@redhat.com, alex.williamson@redhat.com,
        aarcange@redhat.com, jhubbard@nvidia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-unused-pin_user_pages_locked.patch added to -mm tree
Message-Id: <20220201205820.C8414C340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove unused pin_user_pages_locked()
has been added to the -mm tree.  Its filename is
     mm-gup-remove-unused-pin_user_pages_locked.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-remove-unused-pin_user_pages_locked.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-remove-unused-pin_user_pages_locked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: remove unused pin_user_pages_locked()

This routine was used for a short while, but then the calling code was
refactored and the only caller was removed.

Link: https://lkml.kernel.org/r/20220201101108.306062-4-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/gup.c           |   29 -----------------------------
 2 files changed, 31 deletions(-)

--- a/include/linux/mm.h~mm-gup-remove-unused-pin_user_pages_locked
+++ a/include/linux/mm.h
@@ -1918,8 +1918,6 @@ long pin_user_pages(unsigned long start,
 		    struct vm_area_struct **vmas);
 long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages, int *locked);
-long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
-		    unsigned int gup_flags, struct page **pages, int *locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 		    struct page **pages, unsigned int gup_flags);
 long pin_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
--- a/mm/gup.c~mm-gup-remove-unused-pin_user_pages_locked
+++ a/mm/gup.c
@@ -3120,32 +3120,3 @@ long pin_user_pages_unlocked(unsigned lo
 	return get_user_pages_unlocked(start, nr_pages, pages, gup_flags);
 }
 EXPORT_SYMBOL(pin_user_pages_unlocked);
-
-/*
- * pin_user_pages_locked() is the FOLL_PIN variant of get_user_pages_locked().
- * Behavior is the same, except that this one sets FOLL_PIN and rejects
- * FOLL_GET.
- */
-long pin_user_pages_locked(unsigned long start, unsigned long nr_pages,
-			   unsigned int gup_flags, struct page **pages,
-			   int *locked)
-{
-	/*
-	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
-	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas.  As there are no users of this flag in this call we simply
-	 * disallow this option for now.
-	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return -EINVAL;
-
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE(gup_flags & FOLL_GET))
-		return -EINVAL;
-
-	gup_flags |= FOLL_PIN;
-	return __get_user_pages_locked(current->mm, start, nr_pages,
-				       pages, NULL, locked,
-				       gup_flags | FOLL_TOUCH);
-}
-EXPORT_SYMBOL(pin_user_pages_locked);
_

Patches currently in -mm which might be from jhubbard@nvidia.com are

mm-gup-clean-up-follow_pfn_pte-slightly.patch
mm-gup-remove-unused-pin_user_pages_locked.patch
mm-gup-remove-get_user_pages_locked.patch

