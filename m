Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7E2E728CF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 19:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbjI2TIe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjI2TId (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 15:08:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C5B193
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 12:08:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19F7C433C7;
        Fri, 29 Sep 2023 19:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696014510;
        bh=bK4Hk2LY3HmZBLLHBY6h002xc1yTHUCiehS0lO2uqbc=;
        h=Date:To:From:Subject:From;
        b=J8GpeMzVbi+1eW9RPXwpleIgKKc1DSkrwanA8tia8pigfptSRXikMB6W4eJrX3DTC
         IBgov3igGU0Y3qhfYdNFU1rty8Atywgq90GtSI5YT7X3KOqFM+sXQdfbAqgIg+qq7u
         Yv10eN4qCqq19C5Sgv5wWbbu7AMFDHPNF+V9ZFsU=
Date:   Fri, 29 Sep 2023 12:08:30 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch added to mm-unstable branch
Message-Id: <20230929190830.C19F7C433C7@smtp.kernel.org>
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
Date: Fri, 29 Sep 2023 12:44:12 +0100

Patch series "variable-order, large folios for anonymous memory", v6.

A series to implement variable order, large folios for anonymous memory. 
(previously called "ANON_LARGE_FOLIO", "LARGE_ANON_FOLIO", "FLEXIBLE_THP",
but now exposed as an extension to THP; "small-order THP").  The objective
of this is to improve performance by allocating larger chunks of memory
during anonymous page faults:

1) Since SW (the kernel) is dealing with larger chunks of memory than base
   pages, there are efficiency savings to be had; fewer page faults, batched PTE
   and RMAP manipulation, reduced lru list, etc. In short, we reduce kernel
   overhead. This should benefit all architectures.
2) Since we are now mapping physically contiguous chunks of memory, we can take
   advantage of HW TLB compression techniques. A reduction in TLB pressure
   speeds up kernel and user space. arm64 systems have 2 mechanisms to coalesce
   TLB entries; "the contiguous bit" (architectural) and HPA (uarch).

Testing
=======

This version adds patches to mm selftests so that the cow tests explicitly test
small-order THP, in the same way that PMD-order THP is tested. The new tests all
pass, and no regressions are observed in the mm selftest suite.


Performance
===========

The below tables show performance and memory data for selected workloads, with
different small-order THPs enabled. All configs are compared to a 4k page kernel
with small-order THP disabled. 16k and 64k (with small-order THP disabled)
kernels are included to aid the comparison. All kernels built from the same
source; mm-hotfixes-unstable (f9911db48293) + this series.

4k-page-16k-folio: 16k (order-2) THP enabled
4k-page-32k-folio: 32k+16k (order-3, order-2) THP enabled
4k-page-64k-folio: 64k+32k+16k (order-4, order-3, order-2) THP enabled

Running on Ampere Altra with 1 NUMA node enabled, Ubuntu 22.04, XFS filesystem
20 repeats across 5 reboots (with 1 warmup run after each reboot)
Run in its own cgroup and read memory.peak after completion


Kernel Compilation with 8 jobs: (make defconfig && make -s -j8 Image)
(smaller is better):

| kernel            |   real-time |   kern-time |   user-time | memory |
|:------------------|------------:|------------:|------------:|-------:|
| baseline-4k-page  |        0.0% |        0.0% |        0.0% |   0.0% |
| 16k-page          |       -9.0% |      -49.7% |       -4.0% |   6.2% |
| 64k-page          |      -11.9% |      -66.5% |       -5.0% |  28.3% |
| 4k-page-16k-folio |       -2.8% |      -23.0% |       -0.3% |   0.0% |
| 4k-page-32k-folio |       -4.0% |      -32.0% |       -0.6% |   0.1% |
| 4k-page-64k-folio |       -4.6% |      -37.9% |       -0.5% |   0.1% |


Kernel Compilation with 80 jobs: (make defconfig && make -s -j80 Image)
(smaller is better):

| kernel            |   real-time |   kern-time |   user-time | memory |
|:------------------|------------:|------------:|------------:|:-------|
| baseline-4k-page  |        0.0% |        0.0% |        0.0% |   0.0% |
| 16k-page          |       -9.2% |      -52.1% |       -3.6% |   4.6% |
| 64k-page          |      -11.4% |      -66.4% |       -3.0% |  12.6% |
| 4k-page-16k-folio |       -3.2% |      -22.8% |       -0.3% |   2.7% |
| 4k-page-32k-folio |       -4.8% |      -37.1% |       -0.5% |   2.9% |
| 4k-page-64k-folio |       -5.0% |      -42.1% |       -0.3% |   3.4% |


Speedometer 2.0: Running on Chromium automated with Selenium
(bigger is better for runs_per_min, smaller is better for memory):

| kernel            |   runs_per_min | memory |
|:------------------|---------------:|-------:|
| baseline-4k-page  |           0.0% |   0.0% |
| 16k-page          |           5.9% |  10.6% |
| 4k-page-16k-folio |           1.0% |  -0.6% |
| 4k-page-32k-folio |           1.3% |   3.5% |
| 4k-page-64k-folio |           1.3% |   6.4% |


This patch (of 6):

In preparation for the introduction of large folios for anonymous memory,
we would like to be able to split them when they have unmapped subpages,
in order to free those unused pages under memory pressure.  So remove the
artificial requirement that the large folio needed to be at least
PMD-sized.

Link: https://lkml.kernel.org/r/20230929114421.3761121-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230929114421.3761121-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
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
@@ -1504,11 +1504,11 @@ void page_remove_rmap(struct page *page,
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

mm-hugetlb-add-huge-page-size-param-to-set_huge_pte_at.patch
arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-account-pte-mapped-anonymous-thp-usage.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files.patch
mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch
mm-thp-add-recommend-option-for-anon_orders.patch
arm64-mm-override-arch_wants_pte_order.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-small-order-anon-thp.patch

