Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE51C61DA4
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbjBGB36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjBGB3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C780E2ED5B
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EE8A610AA
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFDDC433EF;
        Tue,  7 Feb 2023 01:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733387;
        bh=bc3DSUqAQxMCh6xIXZVuuJY+1cZx5FdG8QcOwDg6Xo8=;
        h=Date:To:From:Subject:From;
        b=cSYZ10aMq2srf3K/pOzC2CCplz9QvEsFzQWuahTKwqdwR9qv5yd0ulLL3f5y38NR8
         dBkWp7wPhmVf/RTNreapxyuXXHQP+HUuC/NsxI8SfxE5nSnw9GOVqD4asyPSOFlJ6b
         SIYup/ApFVPJgwQ1WWQjGmWFLHuxXxL7LtMZLnr8=
Date:   Mon, 06 Feb 2023 17:29:47 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch added to mm-unstable branch
Message-Id: <20230207012947.9BFDDC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: make get_user_pages_fast_only() return the common return value
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch

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
Subject: mm/gup: make get_user_pages_fast_only() return the common return value
Date: Tue, 24 Jan 2023 16:34:32 -0400

There are only two callers, both can handle the common return code:

- get_user_page_fast_only() checks == 1

- gfn_to_page_many_atomic() already returns -1, and the only caller
  checks for negative return values

Remove the restriction against returning negative values.

Link: https://lkml.kernel.org/r/11-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/gup.c~mm-gup-make-get_user_pages_fast_only-return-the-common-return-value
+++ a/mm/gup.c
@@ -3005,8 +3005,6 @@ static int internal_get_user_pages_fast(
  *
  * Like get_user_pages_fast() except it's IRQ-safe in that it won't fall back to
  * the regular GUP.
- * Note a difference with get_user_pages_fast: this always returns the
- * number of pages pinned, 0 if no pages were pinned.
  *
  * If the architecture does not support this function, simply return with no
  * pages pinned.
@@ -3018,7 +3016,6 @@ static int internal_get_user_pages_fast(
 int get_user_pages_fast_only(unsigned long start, int nr_pages,
 			     unsigned int gup_flags, struct page **pages)
 {
-	int nr_pinned;
 	/*
 	 * Internally (within mm/gup.c), gup fast variants must set FOLL_GET,
 	 * because gup fast is always a "pin with a +1 page refcount" request.
@@ -3030,19 +3027,7 @@ int get_user_pages_fast_only(unsigned lo
 			       FOLL_GET | FOLL_FAST_ONLY))
 		return -EINVAL;
 
-	nr_pinned = internal_get_user_pages_fast(start, nr_pages, gup_flags,
-						 pages);
-
-	/*
-	 * As specified in the API description above, this routine is not
-	 * allowed to return negative values. However, the common core
-	 * routine internal_get_user_pages_fast() *can* return -errno.
-	 * Therefore, correct for that here:
-	 */
-	if (nr_pinned < 0)
-		nr_pinned = 0;
-
-	return nr_pinned;
+	return internal_get_user_pages_fast(start, nr_pages, gup_flags, pages);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast_only);
 
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

