Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A3DC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjLGWE1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbjLGWE0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:04:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676A998
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:04:32 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B704AC433C8;
        Thu,  7 Dec 2023 22:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701986671;
        bh=TFRs+bYWwyBZRyDdDmv0wpyrYviPb8elGgWmIsnSazA=;
        h=Date:To:From:Subject:From;
        b=o6tGNFmrBY/rgmMrwxmd9Rgie1nGRBiDGsyj12IGJrFb2F7ds9UFrYDTc+IpkakxD
         r+UH7d2cBN2ZiKa6bxypAjWTfTlf2pPCZk1YnAWD1APeJaMM3AO784IBBxbhuq5DQt
         +HStmEcHSiVWDa/0zDYquoC71579duOxl6wjZ6Ak=
Date:   Thu, 07 Dec 2023 14:04:30 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, v-songbaohua@oppo.com, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch added to mm-unstable branch
Message-Id: <20231207220431.B704AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow deferred splitting of arbitrary anon large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: allow deferred splitting of arbitrary anon large folios
Date: Thu, 7 Dec 2023 16:12:02 +0000

Patch series "Multi-size THP for anonymous memory", v9.

A series to implement multi-size THP (mTHP) for anonymous memory
(previously called "small-sized THP" and "large anonymous folios").

The objective of this is to improve performance by allocating larger
chunks of memory during anonymous page faults:

1) Since SW (the kernel) is dealing with larger chunks of memory than base
   pages, there are efficiency savings to be had; fewer page faults, batched PTE
   and RMAP manipulation, reduced lru list, etc. In short, we reduce kernel
   overhead. This should benefit all architectures.
2) Since we are now mapping physically contiguous chunks of memory, we can take
   advantage of HW TLB compression techniques. A reduction in TLB pressure
   speeds up kernel and user space. arm64 systems have 2 mechanisms to coalesce
   TLB entries; "the contiguous bit" (architectural) and HPA (uarch).

This version incorporates David's feedback on the core patches (#3, #4)
and adds some RB and TB tags (see change log for details).

By default, the existing behaviour (and performance) is maintained.  The
user must explicitly enable multi-size THP to see the performance benefit.
This is done via a new sysfs interface (as recommended by David
Hildenbrand - thanks to David for the suggestion)!  This interface is
inspired by the existing per-hugepage-size sysfs interface used by
hugetlb, provides full backwards compatibility with the existing PMD-size
THP interface, and provides a base for future extensibility.  See [9] for
detailed discussion of the interface.

This series is based on mm-unstable (715b67adf4c8).


Prerequisites
=============

I'm removing this section on the basis that I don't believe what we were
previously calling prerequisites are really prerequisites anymore.  We
originally defined them when mTHP was a compile-time feature.  There is
now a runtime control to opt-in to mTHP; when disabled, correctness and
performance are as before.  When enabled, the code is still
correct/robust, but in the absence of the one remaining item (compaction)
there may be a performance impact in some corners.  See the old list in
the v8 cover letter at [8].  And a longer explanation of my thinking here
[10].

SUMMARY: I don't think we should hold this series up, waiting for the
items on the prerequisites list.  I believe this series should be ready
now so hopefully can be added to mm-unstable for some testing, then
fingers crossed for v6.8.


Testing
=======

The series includes patches for mm selftests to enlighten the cow and
khugepaged tests to explicitly test with multi-size THP, in the same way
that PMD-sized THP is tested.  The new tests all pass, and no regressions
are observed in the mm selftest suite.  I've also run my usual kernel
compilation and java script benchmarks without any issues.

Refer to my performance numbers posted with v6 [6].  (These are for
multi-size THP only - they do not include the arm64 contpte follow-on
series).

John Hubbard at Nvidia has indicated dramatic 10x performance improvements
for some workloads at [11].  (Observed using v6 of this series as well as
the arm64 contpte series).

Kefeng Wang at Huawei has also indicated he sees improvements at [12] although
there are some latency regressions also.

I've also checked that there is no regression in the write fault path when
mTHP is disabled using a microbenchmark.  I ran it for a baseline kernel,
as well as v8 and v9.  I repeated on Ampere Altra (bare metal) and Apple
M2 (VM):

|              |        m2 vm        |        altra        |
|--------------|---------------------|---------------------|
| kernel       |     mean |  std_rel |     mean |  std_rel |
|--------------|----------|----------|----------|----------|
| baseline     |   0.000% |   0.341% |   0.000% |   3.581% |
| anonfolio-v8 |   0.005% |   0.272% |   5.068% |   1.128% |
| anonfolio-v9 |  -0.013% |   0.442% |   0.107% |   1.788% |

There is no measurable difference on M2, but altra has a slow down in v8
which is fixed in v9 by moving the THP order check to be inline within
thp_vma_allowable_orders(), as suggested by David.


This patch (of 10):

In preparation for the introduction of anonymous multi-size THP, we would
like to be able to split them when they have unmapped subpages, in order
to free those unused pages under memory pressure.  So remove the
artificial requirement that the large folio needed to be at least
PMD-sized.

Link: https://lkml.kernel.org/r/20231207161211.2374093-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20231207161211.2374093-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <v-songbaohua@oppo.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-allow-deferred-splitting-of-arbitrary-anon-large-folios
+++ a/mm/rmap.c
@@ -1535,11 +1535,11 @@ void page_remove_rmap(struct page *page,
 		__lruvec_stat_mod_folio(folio, idx, -nr);
 
 		/*
-		 * Queue anon THP for deferred split if at least one
+		 * Queue anon large folio for deferred split if at least one
 		 * page of the folio is unmapped and at least one page
 		 * is still mapped.
 		 */
-		if (folio_test_pmd_mappable(folio) && folio_test_anon(folio))
+		if (folio_test_large(folio) && folio_test_anon(folio))
 			if (!compound || nr < nr_pmdmapped)
 				deferred_split_folio(folio);
 	}
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-do-not-allow-order-1-folio.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

