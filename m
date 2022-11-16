Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2EEC4167B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiKPWoa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234308AbiKPWoI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1EAA6C71E
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:43:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44C3561FF9
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D20DC433D7;
        Wed, 16 Nov 2022 22:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638630;
        bh=2XYb4kWqLfrA3YxDUsGo9EQ9iREztugX3yGZ48N4ztk=;
        h=Date:To:From:Subject:From;
        b=J02wFb+IOqgowc6yOti339sJlry743+JuTVmV9owkjtIME73ZfOvAEuMJdvUW5VUE
         Ed03srDU+jjg+jYLmygCzx+6Ap4uVlbj0OENGCyK9HuPV6QvavqQk1x6V+4Rxz5osK
         6QjKrNtLsjuapc+LtzfNdeulZkXWnG20VPexfSvI=
Date:   Wed, 16 Nov 2022 14:43:49 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-early-fault_flag_unshare-consistency-checks.patch added to mm-unstable branch
Message-Id: <20221116224350.9D20DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add early FAULT_FLAG_UNSHARE consistency checks
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-early-fault_flag_unshare-consistency-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-early-fault_flag_unshare-consistency-checks.patch

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
Subject: mm: add early FAULT_FLAG_UNSHARE consistency checks
Date: Wed, 16 Nov 2022 11:26:43 +0100

For now, FAULT_FLAG_UNSHARE only applies to anonymous pages, which
implies a COW mapping. Let's hide FAULT_FLAG_UNSHARE early if we're not
dealing with a COW mapping, such that we treat it like a read fault as
documented and don't have to worry about the flag throughout all fault
handlers.

While at it, centralize the check for mutual exclusion of
FAULT_FLAG_UNSHARE and FAULT_FLAG_WRITE and just drop the check that
either flag is set in the WP handler.

Link: https://lkml.kernel.org/r/20221116102659.70287-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ---
 mm/hugetlb.c     |    5 -----
 mm/memory.c      |   23 ++++++++++++++++++++---
 3 files changed, 20 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-add-early-fault_flag_unshare-consistency-checks
+++ a/mm/huge_memory.c
@@ -1267,9 +1267,6 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	vmf->ptl = pmd_lockptr(vma->vm_mm, vmf->pmd);
 	VM_BUG_ON_VMA(!vma->anon_vma, vma);
 
-	VM_BUG_ON(unshare && (vmf->flags & FAULT_FLAG_WRITE));
-	VM_BUG_ON(!unshare && !(vmf->flags & FAULT_FLAG_WRITE));
-
 	if (is_huge_zero_pmd(orig_pmd))
 		goto fallback;
 
--- a/mm/hugetlb.c~mm-add-early-fault_flag_unshare-consistency-checks
+++ a/mm/hugetlb.c
@@ -5314,9 +5314,6 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	unsigned long haddr = address & huge_page_mask(h);
 	struct mmu_notifier_range range;
 
-	VM_BUG_ON(unshare && (flags & FOLL_WRITE));
-	VM_BUG_ON(!unshare && !(flags & FOLL_WRITE));
-
 	/*
 	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
 	 * PTE mapped R/O such as maybe_mkwrite() would do.
@@ -5326,8 +5323,6 @@ static vm_fault_t hugetlb_wp(struct mm_s
 
 	/* Let's take out MAP_SHARED mappings first. */
 	if (vma->vm_flags & VM_MAYSHARE) {
-		if (unlikely(unshare))
-			return 0;
 		set_huge_ptep_writable(vma, haddr, ptep);
 		return 0;
 	}
--- a/mm/memory.c~mm-add-early-fault_flag_unshare-consistency-checks
+++ a/mm/memory.c
@@ -3344,9 +3344,6 @@ static vm_fault_t do_wp_page(struct vm_f
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *folio;
 
-	VM_BUG_ON(unshare && (vmf->flags & FAULT_FLAG_WRITE));
-	VM_BUG_ON(!unshare && !(vmf->flags & FAULT_FLAG_WRITE));
-
 	if (likely(!unshare)) {
 		if (userfaultfd_pte_wp(vma, *vmf->pte)) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
@@ -5161,6 +5158,22 @@ static void lru_gen_exit_fault(void)
 }
 #endif /* CONFIG_LRU_GEN */
 
+static vm_fault_t sanitize_fault_flags(struct vm_area_struct *vma,
+				       unsigned int *flags)
+{
+	if (unlikely(*flags & FAULT_FLAG_UNSHARE)) {
+		if (WARN_ON_ONCE(*flags & FAULT_FLAG_WRITE))
+			return VM_FAULT_SIGSEGV;
+		/*
+		 * FAULT_FLAG_UNSHARE only applies to COW mappings. Let's
+		 * just treat it like an ordinary read-fault otherwise.
+		 */
+		if (!is_cow_mapping(vma->vm_flags))
+			*flags &= ~FAULT_FLAG_UNSHARE;
+	}
+	return 0;
+}
+
 /*
  * By the time we get here, we already hold the mm semaphore
  *
@@ -5177,6 +5190,10 @@ vm_fault_t handle_mm_fault(struct vm_are
 	count_vm_event(PGFAULT);
 	count_memcg_event_mm(vma->vm_mm, PGFAULT);
 
+	ret = sanitize_fault_flags(vma, &flags);
+	if (ret)
+		return ret;
+
 	if (!arch_vma_access_permitted(vma, flags & FAULT_FLAG_WRITE,
 					    flags & FAULT_FLAG_INSTRUCTION,
 					    flags & FAULT_FLAG_REMOTE))
_

Patches currently in -mm which might be from david@redhat.com are

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
selftests-vm-anon_cow-prepare-for-non-anonymous-cow-tests.patch
selftests-vm-cow-basic-cow-tests-for-non-anonymous-pages.patch
selftests-vm-cow-r-o-long-term-pinning-reliability-tests-for-non-anon-pages.patch
mm-add-early-fault_flag_unshare-consistency-checks.patch
mm-add-early-fault_flag_write-consistency-checks.patch
mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch
mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch
mm-extend-fault_flag_unshare-support-to-anything-in-a-cow-mapping.patch
mm-gup-reliable-r-o-long-term-pinning-in-cow-mappings.patch
rdma-umem-remove-foll_force-usage.patch
rdma-usnic-remove-foll_force-usage.patch
rdma-siw-remove-foll_force-usage.patch
media-videobuf-dma-sg-remove-foll_force-usage.patch
drm-etnaviv-remove-foll_force-usage.patch
media-pci-ivtv-remove-foll_force-usage.patch
mm-frame-vector-remove-foll_force-usage.patch
drm-exynos-remove-foll_force-usage.patch
rdma-hw-qib-qib_user_pages-remove-foll_force-usage.patch
habanalabs-remove-foll_force-usage.patch

