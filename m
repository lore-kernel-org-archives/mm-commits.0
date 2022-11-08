Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE0EC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 22:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiKHWAB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 17:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiKHV7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 16:59:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88B322BC4
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7737A617AF
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4F0C433C1;
        Tue,  8 Nov 2022 21:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667944792;
        bh=Ye82lchll+d3Qizh2nW7Kgqd0gFfvuKH5LgothN/tVo=;
        h=Date:To:From:Subject:From;
        b=QoGiuYwRUGXtgS+qCIKQYM852CH//N1JsPyNV0Ngyso/+LB7N4I3W2npaie0YGr7Y
         NRa6MnXl5mFt9oBLddsU457zkI5EvoQ3vU9Le9CzBPEDh1NKKJRhceBpTmbXRKDhIy
         cHkIxsdBe/L7l5zu+Ds0cDzRk7JW7GWz+M81DyA8=
Date:   Tue, 08 Nov 2022 13:59:52 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, namit@vmware.com, mpe@ellerman.id.au,
        mgorman@techsingularity.net, hughd@google.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch added to mm-unstable branch
Message-Id: <20221108215952.CE4F0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: factor out check whether manual PTE write upgrades are required
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch

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
Subject: mm/mprotect: factor out check whether manual PTE write upgrades are required
Date: Tue, 8 Nov 2022 18:46:49 +0100

Let's factor the check out into vma_wants_manual_pte_write_upgrade(), to be
reused in NUMA hinting fault context soon.

Link: https://lkml.kernel.org/r/20221108174652.198904-5-david@redhat.com
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

 include/linux/mm.h |   16 ++++++++++++++--
 mm/mprotect.c      |   17 ++++-------------
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required
+++ a/include/linux/mm.h
@@ -2016,6 +2016,20 @@ extern unsigned long move_page_tables(st
 #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
 					    MM_CP_UFFD_WP_RESOLVE)
 
+int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
+static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
+{
+	/*
+	 * We want to check manually if we can change individual PTEs writable
+	 * if we can't do that automatically for all PTEs in a mapping. For
+	 * private mappings, that's always the case when we have write
+	 * permissions as we properly have to handle COW.
+	 */
+	if (vma->vm_flags & VM_SHARED)
+		return vma_wants_writenotify(vma, vma->vm_page_prot);
+	return !!(vma->vm_flags & VM_WRITE);
+
+}
 extern unsigned long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
@@ -2155,8 +2169,6 @@ static inline int pte_devmap(pte_t pte)
 }
 #endif
 
-int vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
-
 extern pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			       spinlock_t **ptl);
 static inline pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
--- a/mm/mprotect.c~mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required
+++ a/mm/mprotect.c
@@ -558,8 +558,8 @@ mprotect_fixup(struct mmu_gather *tlb, s
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long oldflags = vma->vm_flags;
 	long nrpages = (end - start) >> PAGE_SHIFT;
+	unsigned int mm_cp_flags = 0;
 	unsigned long charged = 0;
-	bool try_change_writable;
 	pgoff_t pgoff;
 	int error;
 
@@ -637,20 +637,11 @@ success:
 	 * held in write mode.
 	 */
 	vma->vm_flags = newflags;
-	/*
-	 * We want to check manually if we can change individual PTEs writable
-	 * if we can't do that automatically for all PTEs in a mapping. For
-	 * private mappings, that's always the case when we have write
-	 * permissions as we properly have to handle COW.
-	 */
-	if (vma->vm_flags & VM_SHARED)
-		try_change_writable = vma_wants_writenotify(vma, vma->vm_page_prot);
-	else
-		try_change_writable = !!(vma->vm_flags & VM_WRITE);
+	if (vma_wants_manual_pte_write_upgrade(vma))
+		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
 
-	change_protection(tlb, vma, start, end, vma->vm_page_prot,
-			  try_change_writable ? MM_CP_TRY_CHANGE_WRITABLE : 0);
+	change_protection(tlb, vma, start, end, vma->vm_page_prot, mm_cp_flags);
 
 	/*
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
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

