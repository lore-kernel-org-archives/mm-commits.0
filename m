Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152C2C4332F
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 22:00:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiKHWAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 17:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiKHV7y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 16:59:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5312B220FF
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 142DFB81B14
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5EEC433C1;
        Tue,  8 Nov 2022 21:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667944790;
        bh=xU/Rzdyct2ooxrHo0IEFKHkTwZEQSKD0wH6BL+O4fUc=;
        h=Date:To:From:Subject:From;
        b=aWgrjQUlnXwd3vnbBDJeLWkWnZOb7mcnN7Nof79Sd3br/GF7eNY+BNZ1HA/vw/Yww
         ruuFJcFk+WahXmy6CRb8eAsCWVD3UpClNAdoeBbNkymln47toG2aeDYkccJyH+L0Lr
         94YDMAB5uGHeRN4yOvZ7oj6Xv5vXimYnbIQcx7ec=
Date:   Tue, 08 Nov 2022 13:59:50 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, namit@vmware.com, mpe@ellerman.id.au,
        mgorman@techsingularity.net, hughd@google.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch added to mm-unstable branch
Message-Id: <20221108215950.AE5EEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory: try avoiding write faults when changing PMD protection
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: try avoiding write faults when changing PMD protection
Date: Tue, 8 Nov 2022 18:46:48 +0100

Let's replicate what we have for PTEs in can_change_pte_writable() also
for PMDs.

While this might look like a pure performance improvement, we'll us this to
get rid of savedwrite handling in do_huge_pmd_numa_page() next. Place
do_huge_pmd_numa_page() strategically good for that purpose.

Note that MM_CP_TRY_CHANGE_WRITABLE is currently only set when we come
via mprotect_fixup().

Link: https://lkml.kernel.org/r/20221108174652.198904-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection
+++ a/mm/huge_memory.c
@@ -1344,6 +1344,36 @@ fallback:
 	return VM_FAULT_FALLBACK;
 }
 
+static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
+					   unsigned long addr, pmd_t pmd)
+{
+	struct page *page;
+
+	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
+		return false;
+
+	/* Don't touch entries that are not even readable (NUMA hinting). */
+	if (pmd_protnone(pmd))
+		return false;
+
+	/* Do we need write faults for softdirty tracking? */
+	if (vma_soft_dirty_enabled(vma) && !pmd_soft_dirty(pmd))
+		return false;
+
+	/* Do we need write faults for uffd-wp tracking? */
+	if (userfaultfd_huge_pmd_wp(vma, pmd))
+		return false;
+
+	if (!(vma->vm_flags & VM_SHARED)) {
+		/* See can_change_pte_writable(). */
+		page = vm_normal_page_pmd(vma, addr, pmd);
+		return page && PageAnon(page) && PageAnonExclusive(page);
+	}
+
+	/* See can_change_pte_writable(). */
+	return pmd_dirty(pmd);
+}
+
 /* FOLL_FORCE can write to even unwritable PMDs in COW mappings. */
 static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
 					struct vm_area_struct *vma,
@@ -1847,13 +1877,17 @@ int change_huge_pmd(struct mmu_gather *t
 		 */
 		entry = pmd_clear_uffd_wp(entry);
 	}
+
+	/* See change_pte_range(). */
+	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
+	    can_change_pmd_writable(vma, addr, entry))
+		entry = pmd_mkwrite(entry);
+
 	ret = HPAGE_PMD_NR;
 	set_pmd_at(mm, addr, pmd, entry);
 
 	if (huge_pmd_needs_flush(oldpmd, entry))
 		tlb_flush_pmd_range(tlb, addr, HPAGE_PMD_SIZE);
-
-	BUG_ON(vma_is_anonymous(vma) && !preserve_write && pmd_write(entry));
 unlock:
 	spin_unlock(ptl);
 	return ret;
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
selftests-vm-anon_cow-add-liburing-test-cases-fix.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

