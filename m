Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19501C35276
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455437AbiDFB5m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346229AbiDEUeH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:34:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B82DFD6C8
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5979D61995
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD218C385A0;
        Tue,  5 Apr 2022 20:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189811;
        bh=8VN6Ywl2rPivnfkFJKNX+388Pc+AziQhtDAUqVhU3a4=;
        h=Date:To:From:Subject:From;
        b=v+g0gdvpxqhOO1/U9rdwxIBOOvyOYSsmI/+/Vxs8OYk4Y4egtSpoUJHf1kFwRmxqN
         2sCcnP4dmFmBanQTggm+F4JQhaoZc1sCsrisLfmHfeH95ZM8fy15oswi2os5nmyE9l
         mk+TG2QeqWlfANTvjNVTClRc5YPEBEHHPApTzRAs=
Date:   Tue, 05 Apr 2022 13:16:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch added to -mm tree
Message-Id: <20220405201651.AD218C385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: allows file-back mem to be uffd wr-protected on thps
has been added to the -mm tree.  Its filename is
     mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/shmem: allows file-back mem to be uffd wr-protected on thps

We don't have "huge" version of pte markers, instead when necessary we
split the thp.

However split the thp is not enough, because file-backed thp is handled
totally differently comparing to anonymous thps: rather than doing a real
split, the thp pmd will simply got cleared in __split_huge_pmd_locked().

That is not enough if e.g.  when there is a thp covers range [0, 2M) but
we want to wr-protect small page resides in [4K, 8K) range, because after
__split_huge_pmd() returns, there will be a none pmd, and
change_pmd_range() will just skip it right after the split.

Here we leverage the previously introduced change_pmd_prepare() macro so
that we'll populate the pmd with a pgtable page after the pmd split (in
which process the pmd will be cleared for cases like shmem).  Then
change_pte_range() will do all the rest for us by installing the uffd-wp
pte marker at any none pte that we'd like to wr-protect.

Link: https://lkml.kernel.org/r/20220405014852.14413-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/mprotect.c~mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps
+++ a/mm/mprotect.c
@@ -338,8 +338,15 @@ static inline unsigned long change_pmd_r
 		}
 
 		if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
-			if (next - addr != HPAGE_PMD_SIZE) {
+			if ((next - addr != HPAGE_PMD_SIZE) ||
+			    uffd_wp_protect_file(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false, NULL);
+				/*
+				 * For file-backed, the pmd could have been
+				 * cleared; make sure pmd populated if
+				 * necessary, then fall-through to pte level.
+				 */
+				change_pmd_prepare(vma, pmd, cp_flags);
 			} else {
 				/*
 				 * change_huge_pmd() does not defer TLB flushes,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

