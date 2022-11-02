Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA2EC433FE
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 20:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKBUrw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 16:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiKBUrt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 16:47:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65FA9FD3;
        Wed,  2 Nov 2022 13:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78105B824EC;
        Wed,  2 Nov 2022 20:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC4AC433C1;
        Wed,  2 Nov 2022 20:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667422065;
        bh=QmdJk8xreg7eA7OSbIRZeVlOTPufqtG1mQ9ZNCgm/aE=;
        h=Date:To:From:Subject:From;
        b=TlB/Ba4+Fz6SqS4eNHArTLJcJ0Yuw9KbVseEbsI609En+3Tc8GM75ibk5hDu8ZZXr
         qXZkO2J6lNraX4OC/3OTy0y33pnip4chB0maV6+LXFoTE3LKHqVxSHckcNTwlYlhF6
         /tJBkACfuM72I7di08t9s7ChCgfBkcVKYtmeFJrQ=
Date:   Wed, 02 Nov 2022 13:47:44 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, hughd@google.com, axelrasmussen@google.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102204745.1BC4AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: use page_mapping() to detect page cache for uffd continue
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: use page_mapping() to detect page cache for uffd continue
Date: Wed, 2 Nov 2022 14:41:52 -0400

mfill_atomic_install_pte() checks page->mapping to detect whether one page
is used in the page cache.  However as pointed out by Matthew, the page
can logically be a tail page rather than always the head in the case of
uffd minor mode with UFFDIO_CONTINUE.  It means we could wrongly install
one pte with shmem thp tail page assuming it's an anonymous page.

It's not that clear even for anonymous page, since normally anonymous
pages also have page->mapping being setup with the anon vma.  It's safe
here only because the only such caller to mfill_atomic_install_pte() is
always passing in a newly allocated page (mcopy_atomic_pte()), whose
page->mapping is not yet setup.  However that's not extremely obvious
either.

For either of above, use page_mapping() instead.

Link: https://lkml.kernel.org/r/Y2K+y7wnhC4vbnP2@x1n
Fixes: 153132571f02 ("userfaultfd/shmem: support UFFDIO_CONTINUE for shmem")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/userfaultfd.c~mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue
+++ a/mm/userfaultfd.c
@@ -64,7 +64,7 @@ int mfill_atomic_install_pte(struct mm_s
 	pte_t _dst_pte, *dst_pte;
 	bool writable = dst_vma->vm_flags & VM_WRITE;
 	bool vm_shared = dst_vma->vm_flags & VM_SHARED;
-	bool page_in_cache = page->mapping;
+	bool page_in_cache = page_mapping(page);
 	spinlock_t *ptl;
 	struct inode *inode;
 	pgoff_t offset, max_off;
_

Patches currently in -mm which might be from peterx@redhat.com are

partly-revert-mm-thp-carry-over-dirty-bit-when-thp-splits-on-pmd.patch
mm-shmem-use-page_mapping-to-detect-page-cache-for-uffd-continue.patch
selftests-vm-use-memfd-for-uffd-hugetlb-tests.patch
selftests-vm-use-memfd-for-hugetlb-madvise-test.patch
selftests-vm-use-memfd-for-hugepage-mremap-test.patch
selftests-vm-drop-mnt-point-for-hugetlb-in-run_vmtestssh.patch
mm-hugetlb-unify-clearing-of-restorereserve-for-private-pages.patch
revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

