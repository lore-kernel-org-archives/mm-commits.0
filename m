Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40888C001E0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjHJQb3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjHJQb2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:31:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E96A8
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:31:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B585615C2
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 16:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D73C433C7;
        Thu, 10 Aug 2023 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691685087;
        bh=zEHiJ0OjgJ7KSF5vSpRqrGxHmJQQuxXNLH1sHoIaGY4=;
        h=Date:To:From:Subject:From;
        b=sGnxK1fCAwW8ZobGRqARvcxLlDNromMcabeAp4K/GrgWdeJrHQ9muezZpwpfuIE0s
         3sT/re38KCBeXO4DPgHcKJx4aDTBsHCyeV3zrH68U6qBMCaAnwbnTqhkNOR9Eysqcl
         voidrJSwx3KaGQN49aqd2iGHgkLnyBkKQKDXtquM=
Date:   Thu, 10 Aug 2023 09:31:26 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        mcgrof@kernel.org, kirill.shutemov@linux.intel.com,
        itaru.kitayama@gmail.com, fengwei.yin@intel.com, david@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch added to mm-unstable branch
Message-Id: <20230810163126.F1D73C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow deferred splitting of arbitrary large anon folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch

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
Subject: mm: allow deferred splitting of arbitrary large anon folios
Date: Thu, 10 Aug 2023 15:29:38 +0100

Patch series "variable-order, large folios for anonymous memory", v5.

A series to implement variable order, large folios for anonymous memory. 
(currently called "LARGE_ANON_FOLIO", previously called "FLEXIBLE_THP"). 
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

This patchset deals with the SW side of things (1).  (2) is being tackled
in a separate series.  The new behaviour is hidden behind a new Kconfig
switch, LARGE_ANON_FOLIO, which is disabled by default.  Although the
eventual aim is to enable it by default.

My hope is that we are pretty much there with the changes at this point;
hopefully this is sufficient to get an initial version merged so that we
can scale up characterization efforts.  Although they should not be merged
until the prerequisites are complete.  These are in progress and tracked
at [5].

Testing
-------

This version adds patches to mm selftests so that the cow tests explicitly
test large anon folios, in the same way that thp is tested.  When enabled
you should see something similar at the start of the test suite:

  # [INFO] detected large anon folio size: 32 KiB

Then the following results are expected. The fails and skips are due to existing
issues in mm-unstable:

  # Totals: pass:291 fail:16 xfail:0 xpass:0 skip:1 error:0

Existing mm selftests reveal 1 regression in khugepaged tests when
LARGE_ANON_FOLIO is enabled:

  Run test: collapse_max_ptes_none (khugepaged:anon)
  Maybe collapse with max_ptes_none exceeded.... Fail
  Unexpected huge page

I believe this is because khugepaged currently skips non-order-0 pages when
looking for collapse opportunities and should get fixed with the help of
DavidH's work to create a mechanism to precisely determine shared vs exclusive
pages.

[1] https://lore.kernel.org/linux-mm/20230626171430.3167004-1-ryan.roberts@arm.com/
[2] https://lore.kernel.org/linux-mm/20230703135330.1865927-1-ryan.roberts@arm.com/
[3] https://lore.kernel.org/linux-mm/20230714160407.4142030-1-ryan.roberts@arm.com/
[4] https://lore.kernel.org/linux-mm/20230726095146.2826796-1-ryan.roberts@arm.com/
[5] https://lore.kernel.org/linux-mm/f8d47176-03a8-99bf-a813-b5942830fd73@arm.com/


This patch (of 5):

In preparation for the introduction of large folios for anonymous memory,
we would like to be able to split them when they have unmapped subpages,
in order to free those unused pages under memory pressure.  So remove the
artificial requirement that the large folio needed to be at least
PMD-sized.

Link: https://lkml.kernel.org/r/20230810142942.3169679-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20230810142942.3169679-2-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-allow-deferred-splitting-of-arbitrary-large-anon-folios
+++ a/mm/rmap.c
@@ -1446,11 +1446,11 @@ void page_remove_rmap(struct page *page,
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

selftests-line-buffer-test-programs-stdout.patch
selftests-line-buffer-test-programs-stdout-fix.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch
mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-large_anon_folio-for-improved-performance.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-large-anon-folio-tests.patch

