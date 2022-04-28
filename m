Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1943C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 28 Apr 2022 23:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiD1XOI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Apr 2022 19:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353415AbiD1XOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2022 19:14:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E74C0F
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 16:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04040620CC
        for <mm-commits@vger.kernel.org>; Thu, 28 Apr 2022 23:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F84C385AE;
        Thu, 28 Apr 2022 23:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651187440;
        bh=fLF40bAtxgW1uv7R4gmRMvyz0RpLAlOXkDurKH1ILCQ=;
        h=Date:To:From:Subject:From;
        b=IO7tGWLO5Pdpm9nhkG85nx25c7hObB0q6I4axTAg7Pb3IitunNj1XAF8CRz/tPLPd
         KjPCKSN6zOdZ3xOcUSMYJl69Yti8607DuQn7HX4FvQEAnmxPWG7sCVs9Fwzc3mDehQ
         JqCSHjn/CjtcXg7pg+x4n+CJwhXdOFvqAxPLQcFw=
Date:   Thu, 28 Apr 2022 16:10:39 -0700
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
Subject: + mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch added to -mm tree
Message-Id: <20220428231040.40F84C385AE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: fix missing swap_free() in try_to_unmap() after arch_unmap_one() failed
has been added to the -mm tree.  Its filename is
     mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch

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
Subject: mm/rmap: fix missing swap_free() in try_to_unmap() after arch_unmap_one() failed

Patch series "mm: COW fixes part 2: reliable GUP pins of anonymous pages", v4.

This series is the result of the discussion on the previous approach [2]. 
More information on the general COW issues can be found there.  It is
based on latest linus/master (post v5.17, with relevant core-MM changes
for v5.18-rc1).

This series fixes memory corruptions when a GUP pin (FOLL_PIN) was taken
on an anonymous page and COW logic fails to detect exclusivity of the page
to then replacing the anonymous page by a copy in the page table: The GUP
pin lost synchronicity with the pages mapped into the page tables.

This issue, including other related COW issues, has been summarized in [3]
under 3):
"
  3. Intra Process Memory Corruptions due to Wrong COW (FOLL_PIN)

  page_maybe_dma_pinned() is used to check if a page may be pinned for
  DMA (using FOLL_PIN instead of FOLL_GET).  While false positives are
  tolerable, false negatives are problematic: pages that are pinned for
  DMA must not be added to the swapcache.  If it happens, the (now pinned)
  page could be faulted back from the swapcache into page tables
  read-only.  Future write-access would detect the pinning and COW the
  page, losing synchronicity.  For the interested reader, this is nicely
  documented in feb889fb40fa ("mm: don't put pinned pages into the swap
  cache").

  Peter reports [8] that page_maybe_dma_pinned() as used is racy in some
  cases and can result in a violation of the documented semantics: giving
  false negatives because of the race.

  There are cases where we call it without properly taking a per-process
  sequence lock, turning the usage of page_maybe_dma_pinned() racy.  While
  one case (clear_refs SOFTDIRTY tracking, see below) seems to be easy to
  handle, there is especially one rmap case (shrink_page_list) that's hard
  to fix: in the rmap world, we're not limited to a single process.

  The shrink_page_list() issue is really subtle.  If we race with
  someone pinning a page, we can trigger the same issue as in the FOLL_GET
  case.  See the detail section at the end of this mail on a discussion
  how bad this can bite us with VFIO or other FOLL_PIN user.

  It's harder to reproduce, but I managed to modify the O_DIRECT
  reproducer to use io_uring fixed buffers [15] instead, which ends up
  using FOLL_PIN | FOLL_WRITE | FOLL_LONGTERM to pin buffer pages and can
  similarly trigger a loss of synchronicity and consequently a memory
  corruption.

  Again, the root issue is that a write-fault on a page that has
  additional references results in a COW and thereby a loss of
  synchronicity and consequently a memory corruption if two parties
  believe they are referencing the same page.
"

This series makes GUP pins (R/O and R/W) on anonymous pages fully
reliable, especially also taking care of concurrent pinning via GUP-fast,
for example, also fully fixing an issue reported regarding NUMA balancing
[4] recently.  While doing that, it further reduces "unnecessary COWs",
especially when we don't fork()/KSM and don't swapout, and fixes the COW
security for hugetlb for FOLL_PIN.

In summary, we track via a pageflag (PG_anon_exclusive) whether a mapped
anonymous page is exclusive.  Exclusive anonymous pages that are mapped
R/O can directly be mapped R/W by the COW logic in the write fault
handler.  Exclusive anonymous pages that want to be shared (fork(), KSM)
first have to be marked shared -- which will fail if there are GUP pins on
the page.  GUP is only allowed to take a pin on anonymous pages that are
exclusive.  The PT lock is the primary mechanism to synchronize
modifications of PG_anon_exclusive.  We synchronize against GUP-fast
either via the src_mm->write_protect_seq (during fork()) or via
clear/invalidate+flush of the relevant page table entry.

Special care has to be taken about swap, migration, and THPs (whereby a
PMD-mapping can be converted to a PTE mapping and we have to track
information for subpages).  Besides these, we let the rmap code handle
most magic.  For reliable R/O pins of anonymous pages, we need
FAULT_FLAG_UNSHARE logic as part of our previous approach [2], however,
it's now 100% mapcount free and I further simplified it a bit.

  #1 is a fix
  #3-#10 are mostly rmap preparations for PG_anon_exclusive handling
  #11 introduces PG_anon_exclusive
  #12 uses PG_anon_exclusive and make R/W pins of anonymous pages
   reliable
  #13 is a preparation for reliable R/O pins
  #14 and #15 is reused/modified GUP-triggered unsharing for R/O GUP pins
   make R/O pins of anonymous pages reliable
  #16 adds sanity check when (un)pinning anonymous pages

[1] https://lkml.kernel.org/r/20220131162940.210846-1-david@redhat.com
[2] https://lkml.kernel.org/r/20211217113049.23850-1-david@redhat.com
[3] https://lore.kernel.org/r/3ae33b08-d9ef-f846-56fb-645e3b9b4c66@redhat.com
[4] https://bugzilla.kernel.org/show_bug.cgi?id=215616


This patch (of 17):

In case arch_unmap_one() fails, we already did a swap_duplicate().  let's
undo that properly via swap_free().

Link: https://lkml.kernel.org/r/20220428083441.37290-1-david@redhat.com
Link: https://lkml.kernel.org/r/20220428083441.37290-2-david@redhat.com
Fixes: ca827d55ebaa ("mm, swap: Add infrastructure for saving page metadata on swap")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/rmap.c~mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed
+++ a/mm/rmap.c
@@ -1681,6 +1681,7 @@ static bool try_to_unmap_one(struct foli
 				break;
 			}
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
+				swap_free(entry);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
 				page_vma_mapped_walk_done(&pvmw);
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
mm-rmap-fail-try_to_migrate-early-when-setting-a-pmd-migration-entry-fails.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit-fix.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive-fix.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

