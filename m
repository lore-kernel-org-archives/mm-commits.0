Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8F5C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiCaEfK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiCaEfG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FF55AA5B
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56DAA6147B
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA17C340ED;
        Thu, 31 Mar 2022 04:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701192;
        bh=kDeLfu+dAPaZXtn0pul1VnS1qvLYDaQDV24p/k5vA0M=;
        h=Date:To:From:Subject:From;
        b=CYHMXs1ogaFc2aQ331IdbirpUYqWQLWorj2bprYQLAXevdxLG7IsUxtyK3BMyzd91
         +tLV6dE+p2fFvw2SqjU2uW0Y0hzul2UIYtdC5jJEOivbhR4o0baGRykCHtXBg9uk27
         +9dUlrz+ggZwxw1fo38uPh7EBF7IPDcASQUrpvyo=
Date:   Wed, 30 Mar 2022 21:33:12 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-disallow-follow_pagefoll_pin.patch added to -mm tree
Message-Id: <20220331043312.ABA17C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: disallow follow_page(FOLL_PIN)
has been added to the -mm tree.  Its filename is
     mm-gup-disallow-follow_pagefoll_pin.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-disallow-follow_pagefoll_pin.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-disallow-follow_pagefoll_pin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/gup: disallow follow_page(FOLL_PIN)

We want to change the way we handle R/O pins on anonymous pages that might
be shared: if we detect a possibly shared anonymous page -- mapped R/O and
not !PageAnonExclusive() -- we want to trigger unsharing via a page fault,
resulting in an exclusive anonymous page that can be pinned reliably
without getting replaced via COW on the next write fault.

However, the required page fault will be problematic for follow_page(): in
contrast to ordinary GUP, follow_page() doesn't trigger faults internally.
So we would have to end up failing a R/O pin via follow_page(), although
there is something mapped R/O into the page table, which might be rather
surprising.

We don't seem to have follow_page(FOLL_PIN) users, and it's a purely
internal MM function.  Let's just make our life easier and the semantics
of follow_page() clearer by just disallowing FOLL_PIN for follow_page()
completely.

Link: https://lkml.kernel.org/r/20220329160440.193848-14-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c     |    3 +++
 mm/hugetlb.c |    8 +++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/mm/gup.c~mm-gup-disallow-follow_pagefoll_pin
+++ a/mm/gup.c
@@ -787,6 +787,9 @@ struct page *follow_page(struct vm_area_
 	if (vma_is_secretmem(vma))
 		return NULL;
 
+	if (foll_flags & FOLL_PIN)
+		return NULL;
+
 	page = follow_page_mask(vma, address, foll_flags, &ctx);
 	if (ctx.pgmap)
 		put_dev_pagemap(ctx.pgmap);
--- a/mm/hugetlb.c~mm-gup-disallow-follow_pagefoll_pin
+++ a/mm/hugetlb.c
@@ -6701,9 +6701,11 @@ follow_huge_pmd(struct mm_struct *mm, un
 	spinlock_t *ptl;
 	pte_t pte;
 
-	/* FOLL_GET and FOLL_PIN are mutually exclusive. */
-	if (WARN_ON_ONCE((flags & (FOLL_PIN | FOLL_GET)) ==
-			 (FOLL_PIN | FOLL_GET)))
+	/*
+	 * FOLL_PIN is not supported for follow_page(). Ordinary GUP goes via
+	 * follow_hugetlb_page().
+	 */
+	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
 retry:
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

