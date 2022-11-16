Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6657FC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbiKPWom (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234495AbiKPWoT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2589FBE07
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:43:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79FEEB81EE6
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE81C433C1;
        Wed, 16 Nov 2022 22:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638635;
        bh=DmycEtI8pUxtIod+VdeKlBAfeMPa3rNYEQ7cF40gHnY=;
        h=Date:To:From:Subject:From;
        b=y0Hrs+CXBfMAQ1TgUOkIleoec1VAuiU0UgmyYdjWpXd1JLx0A0OzvmSnzASrKDisb
         0Pgawc2ca49jCTJ/ExSXlu2mh5+u0QH49noSClJAKFTHpk5OE0DT3aEX68Txk8CFbo
         YJCKdefHyt9WNoFMK6ooYOFWUPTXdCVDWsDRENPc=
Date:   Wed, 16 Nov 2022 14:43:54 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch added to mm-unstable branch
Message-Id: <20221116224355.2DE81C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rework handling in do_wp_page() based on private vs. shared mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings.patch

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
Subject: mm: rework handling in do_wp_page() based on private vs. shared mappings
Date: Wed, 16 Nov 2022 11:26:45 +0100

We want to extent FAULT_FLAG_UNSHARE support to anything mapped into a
COW mapping (pagecache page, zeropage, PFN, ...), not just anonymous pages.
Let's prepare for that by handling shared mappings first such that we can
handle private mappings last.

While at it, use folio-based functions instead of page-based functions
where we touch the code either way.

Link: https://lkml.kernel.org/r/20221116102659.70287-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

--- a/mm/memory.c~mm-rework-handling-in-do_wp_page-based-on-private-vs-shared-mappings
+++ a/mm/memory.c
@@ -3342,7 +3342,7 @@ static vm_fault_t do_wp_page(struct vm_f
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	struct vm_area_struct *vma = vmf->vma;
-	struct folio *folio;
+	struct folio *folio = NULL;
 
 	if (likely(!unshare)) {
 		if (userfaultfd_pte_wp(vma, *vmf->pte)) {
@@ -3360,13 +3360,12 @@ static vm_fault_t do_wp_page(struct vm_f
 	}
 
 	vmf->page = vm_normal_page(vma, vmf->address, vmf->orig_pte);
-	if (!vmf->page) {
-		if (unlikely(unshare)) {
-			/* No anonymous page -> nothing to do. */
-			pte_unmap_unlock(vmf->pte, vmf->ptl);
-			return 0;
-		}
 
+	/*
+	 * Shared mapping: we are guaranteed to have VM_WRITE and
+	 * FAULT_FLAG_WRITE set at this point.
+	 */
+	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
 		/*
 		 * VM_MIXEDMAP !pfn_valid() case, or VM_SOFTDIRTY clear on a
 		 * VM_PFNMAP VMA.
@@ -3374,20 +3373,19 @@ static vm_fault_t do_wp_page(struct vm_f
 		 * We should not cow pages in a shared writeable mapping.
 		 * Just mark the pages writable and/or call ops->pfn_mkwrite.
 		 */
-		if ((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-				     (VM_WRITE|VM_SHARED))
+		if (!vmf->page)
 			return wp_pfn_shared(vmf);
-
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-		return wp_page_copy(vmf);
+		return wp_page_shared(vmf);
 	}
 
+	if (vmf->page)
+		folio = page_folio(vmf->page);
+
 	/*
-	 * Take out anonymous pages first, anonymous shared vmas are
-	 * not dirty accountable.
+	 * Private mapping: create an exclusive anonymous page copy if reuse
+	 * is impossible. We might miss VM_WRITE for FOLL_FORCE handling.
 	 */
-	folio = page_folio(vmf->page);
-	if (folio_test_anon(folio)) {
+	if (folio && folio_test_anon(folio)) {
 		/*
 		 * If the page is exclusive to this process we must reuse the
 		 * page without further checks.
@@ -3438,19 +3436,17 @@ reuse:
 		/* No anonymous page -> nothing to do. */
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return 0;
-	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-					(VM_WRITE|VM_SHARED))) {
-		return wp_page_shared(vmf);
 	}
 copy:
 	/*
 	 * Ok, we need to copy. Oh, well..
 	 */
-	get_page(vmf->page);
+	if (folio)
+		folio_get(folio);
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 #ifdef CONFIG_KSM
-	if (PageKsm(vmf->page))
+	if (folio && folio_test_ksm(folio))
 		count_vm_event(COW_KSM);
 #endif
 	return wp_page_copy(vmf);
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

