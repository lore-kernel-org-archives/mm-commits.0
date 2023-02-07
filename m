Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B1BC636D3
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjBGB3u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjBGB3q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089842ED42
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD1D2B816BF
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AB5C433D2;
        Tue,  7 Feb 2023 01:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733380;
        bh=VUs8ab0IxZEMfxWza+LQ5f5nb0mJtut/vA+i/R5XdrI=;
        h=Date:To:From:Subject:From;
        b=BrErehyeTUxcntPux2lZVfK870UYj0rkv7RXXP9Ws533Da2YX6d3IN3xKDlVyL9PZ
         Mdw02zi2KFMQ4fOyMniaOT22YfVO0SUF9iw3wWw118bWPllJa8u4HQ52Wi39sKceGD
         GnFICHSaDn0QXkjicK9uuqmkif5qlNiuEqnaymTA=
Date:   Mon, 06 Feb 2023 17:29:39 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch added to mm-unstable branch
Message-Id: <20230207012940.50AB5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: remove locked being NULL from faultin_vma_page_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch

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
Subject: mm/gup: remove locked being NULL from faultin_vma_page_range()
Date: Tue, 24 Jan 2023 16:34:28 -0400

The only caller of this function always passes in a non-NULL locked, so
just remove this obsolete comment.

Link: https://lkml.kernel.org/r/7-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
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


--- a/mm/gup.c~mm-gup-remove-locked-being-null-from-faultin_vma_page_range
+++ a/mm/gup.c
@@ -1558,12 +1558,7 @@ long populate_vma_page_range(struct vm_a
  * code on error (see __get_user_pages()).
  *
  * vma->vm_mm->mmap_lock must be held. The range must be page-aligned and
- * covered by the VMA.
- *
- * If @locked is NULL, it may be held for read or write and will be unperturbed.
- *
- * If @locked is non-NULL, it must held for read only and may be released.  If
- * it's released, *@locked will be set to 0.
+ * covered by the VMA. If it's released, *@locked will be set to 0.
  */
 long faultin_vma_page_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end, bool write, int *locked)
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

