Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E6DC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E4361401
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhEIELO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhEIELO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 221336135F;
        Sun,  9 May 2021 04:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533411;
        bh=+I0YO7uEXBxbf5nEFi3oHbAm3rc9pfakZgbj89s2nC0=;
        h=Date:From:To:Subject:From;
        b=mZHlvlzsOkx4OgqjlYwKCK/kaQ4T2CNVt1lULz1Gk2OeCQdOOwm0+ZmHk4BBm2mPf
         NN1V00nRaxusUc+Wgqv7bLNAF6f9lMT8eJosiV+wdeQxom6+z8qGDQlTt3lYbPsH6a
         EEGap+vm7FRkDRORqHnNBvDmDZZciX01JVQTEKeQ=
Date:   Sat, 08 May 2021 21:10:10 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, almasrymina@google.com,
        axelrasmussen@google.com, bgeffon@google.com, dgilbert@redhat.com,
        hughd@google.com, jglisse@redhat.com, joe@perches.com,
        kirill@shutemov.name, lokeshgidra@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        oupton@google.com, peterx@redhat.com, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shli@fb.com, shuah@kernel.org,
        viro@zeniv.linux.org.uk, wangqing@vivo.com
Subject:  +
 mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch added to -mm
 tree
Message-ID: <20210509041010.AkQiL34Bt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: simplify copying of huge zero page pmd when fork
has been added to the -mm tree.  Its filename is
     mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch

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
Subject: mm/thp: simplify copying of huge zero page pmd when fork

Patch series "mm/uffd: Misc fix for uffd-wp and one more test".

This series tries to fix some corner case bugs for uffd-wp on either thp
or fork().  Then it introduced a new test with pagemap/pageout.

Patch layout:

Patch 1:    cleanup for THP, it'll slightly simplify the follow up patches
Patch 2-4:  misc fixes for uffd-wp here and there; please refer to each patch
Patch 5:    add pagemap support for uffd-wp
Patch 6:    add pagemap/pageout test for uffd-wp

The last test introduced can also verify some of the fixes in previous
patches, as the test will fail without the fixes.  However it's not easy
to verify all the changes in patch 2-4, but hopefully they can still be
properly reviewed.

Note that if considering the ongoing uffd-wp shmem & hugetlbfs work, patch
5 will be incomplete as it's missing e.g.  hugetlbfs part or the special
swap pte detection.  However that's not needed in this series, and since
that series is still during review, this series does not depend on that
one (the last test only runs with anonymous memory, not file-backed).  So
this series can be merged even before that series.


This patch (of 6):

Huge zero page is handled in a special path in copy_huge_pmd(), however it
should share most codes with a normal thp page.  Trying to share more code
with it by removing the special path.  The only leftover so far is the
huge zero page refcounting (mm_get_huge_zero_page()), because that's
separately done with a global counter.

This prepares for a future patch to modify the huge pmd to be installed,
so that we don't need to duplicate it explicitly into huge zero page case
too.

Link: https://lkml.kernel.org/r/20210428225030.9708-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210428225030.9708-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, peterx@redhat.com
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork
+++ a/mm/huge_memory.c
@@ -1076,17 +1076,13 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 * a page table.
 	 */
 	if (is_huge_zero_pmd(pmd)) {
-		struct page *zero_page;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
-		zero_page = mm_get_huge_zero_page(dst_mm);
-		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
-				zero_page);
-		ret = 0;
-		goto out_unlock;
+		mm_get_huge_zero_page(dst_mm);
+		goto out_zero_page;
 	}
 
 	src_page = pmd_page(pmd);
@@ -1110,6 +1106,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	get_page(src_page);
 	page_dup_rmap(src_page, true);
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
mm-gup_benchmark-support-threading.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch

