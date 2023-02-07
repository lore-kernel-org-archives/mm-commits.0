Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32342C05027
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjBGB36 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjBGB3t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639FA2ED42
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 188B9B8164F
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09D7C433EF;
        Tue,  7 Feb 2023 01:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733385;
        bh=5GeVbtIQx7zH0pu3oxENirbdmVbV+vj9Iry5fFkAuKA=;
        h=Date:To:From:Subject:From;
        b=OoIZ0m98iKEciLtE5/7svUwNz3k4HVP3DOVfBUoctPbNAFpEuyaHfAQnMs59aYXra
         A+3OHA3pK4z6TTU9I+wxHwOr0kW2FsXMFhl2nUwegY8JlrAPuvkfJAD3O2unn+P4zZ
         uD655lgXE6+MuUDjt9cUEoH/VCBIs7GNhUtN+8lY=
Date:   Mon, 06 Feb 2023 17:29:45 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-pin_user_pages_fast_only.patch added to mm-unstable branch
Message-Id: <20230207012945.B09D7C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove pin_user_pages_fast_only()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-pin_user_pages_fast_only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-pin_user_pages_fast_only.patch

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
Subject: mm/gup: remove pin_user_pages_fast_only()
Date: Tue, 24 Jan 2023 16:34:31 -0400

Commit ed29c2691188 ("drm/i915: Fix userptr so we do not have to worry
about obj->mm.lock, v7.") removed the only caller, remove this dead code
too.

Link: https://lkml.kernel.org/r/10-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
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


--- a/include/linux/mm.h~mm-gup-remove-pin_user_pages_fast_only
+++ a/include/linux/mm.h
@@ -2286,8 +2286,6 @@ extern int mprotect_fixup(struct vma_ite
  */
 int get_user_pages_fast_only(unsigned long start, int nr_pages,
 			     unsigned int gup_flags, struct page **pages);
-int pin_user_pages_fast_only(unsigned long start, int nr_pages,
-			     unsigned int gup_flags, struct page **pages);
 
 static inline bool get_user_page_fast_only(unsigned long addr,
 			unsigned int gup_flags, struct page **pagep)
--- a/mm/gup.c~mm-gup-remove-pin_user_pages_fast_only
+++ a/mm/gup.c
@@ -3102,39 +3102,6 @@ int pin_user_pages_fast(unsigned long st
 }
 EXPORT_SYMBOL_GPL(pin_user_pages_fast);
 
-/*
- * This is the FOLL_PIN equivalent of get_user_pages_fast_only(). Behavior
- * is the same, except that this one sets FOLL_PIN instead of FOLL_GET.
- *
- * The API rules are the same, too: no negative values may be returned.
- */
-int pin_user_pages_fast_only(unsigned long start, int nr_pages,
-			     unsigned int gup_flags, struct page **pages)
-{
-	int nr_pinned;
-
-	/*
-	 * FOLL_FAST_ONLY is required in order to match the API description of
-	 * this routine: no fall back to regular ("slow") GUP.
-	 */
-	if (!is_valid_gup_args(pages, NULL, NULL, &gup_flags,
-			       FOLL_PIN | FOLL_FAST_ONLY))
-		return 0;
-
-	nr_pinned = internal_get_user_pages_fast(start, nr_pages, gup_flags,
-						 pages);
-	/*
-	 * This routine is not allowed to return negative values. However,
-	 * internal_get_user_pages_fast() *can* return -errno. Therefore,
-	 * correct for that here:
-	 */
-	if (nr_pinned < 0)
-		nr_pinned = 0;
-
-	return nr_pinned;
-}
-EXPORT_SYMBOL_GPL(pin_user_pages_fast_only);
-
 /**
  * pin_user_pages_remote() - pin pages of a remote process
  *
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

