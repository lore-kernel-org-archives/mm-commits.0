Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D3CC43219
	for <mm-commits@archiver.kernel.org>; Wed, 16 Nov 2022 22:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbiKPWoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Nov 2022 17:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238971AbiKPWoT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Nov 2022 17:44:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BB0264B
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 14:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 886FCB81EDA
        for <mm-commits@vger.kernel.org>; Wed, 16 Nov 2022 22:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA12C433D6;
        Wed, 16 Nov 2022 22:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668638637;
        bh=g+gxfwi64tDG+tkDwzLpYNwd3sB9Z2YcR6hK+q8g4KU=;
        h=Date:To:From:Subject:From;
        b=bkIrJ8/1wMuqfjsi61fY/X0fFlqzC1efsyc6pJCujoNXJ+zK7VoMehKjU0WEVRj5M
         I8UBkHL6tuxRDtE1ZWvrmAKkMc8qtrSkg70UzWozdzZrmFhNF1Hq4bApAwXy0Z7dXZ
         bRAOPc84rj/U3hSBqTrFqNuO7V5ONUZid+HX85V4=
Date:   Wed, 16 Nov 2022 14:43:56 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch added to mm-unstable branch
Message-Id: <20221116224357.2EA12C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't call vm_ops->huge_fault() in wp_huge_pmd()/wp_huge_pud() for private mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings.patch

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
Subject: mm: don't call vm_ops->huge_fault() in wp_huge_pmd()/wp_huge_pud() for private mappings
Date: Wed, 16 Nov 2022 11:26:46 +0100

If we already have a PMD/PUD mapped write-protected in a private mapping
and we want to break COW either due to FAULT_FLAG_WRITE or
FAULT_FLAG_UNSHARE, there is no need to inform the file system just like on
the PTE path.

Let's just split (->zap) + fallback in that case.

This is a preparation for more generic FAULT_FLAG_UNSHARE support in
COW mappings.

Link: https://lkml.kernel.org/r/20221116102659.70287-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/mm/memory.c~mm-dont-call-vm_ops-huge_fault-in-wp_huge_pmd-wp_huge_pud-for-private-mappings
+++ a/mm/memory.c
@@ -4802,6 +4802,7 @@ static inline vm_fault_t create_huge_pmd
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
+	vm_fault_t ret;
 
 	if (vma_is_anonymous(vmf->vma)) {
 		if (likely(!unshare) &&
@@ -4809,11 +4810,13 @@ static inline vm_fault_t wp_huge_pmd(str
 			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf);
 	}
-	if (vmf->vma->vm_ops->huge_fault) {
-		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (vmf->vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		if (vmf->vma->vm_ops->huge_fault) {
+			ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	}
 
 	/* COW or write-notify handled on pte level: split pmd. */
@@ -4839,14 +4842,17 @@ static vm_fault_t wp_huge_pud(struct vm_
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	vm_fault_t ret;
+
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vmf->vma))
 		goto split;
-	if (vmf->vma->vm_ops->huge_fault) {
-		vm_fault_t ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
-
-		if (!(ret & VM_FAULT_FALLBACK))
-			return ret;
+	if (vmf->vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		if (vmf->vma->vm_ops->huge_fault) {
+			ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PUD);
+			if (!(ret & VM_FAULT_FALLBACK))
+				return ret;
+		}
 	}
 split:
 	/* COW or write-notify not handled on PUD level: split pud.*/
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

