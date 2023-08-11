Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D825C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbjHKXOK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237164AbjHKXNa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:13:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86F6E5C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:03:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702EC666E3
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99E2C433C8;
        Fri, 11 Aug 2023 23:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794981;
        bh=9LtTS1f8iWk00peSFjwXx+DhfPHcqhFSaOzjaSkqqgM=;
        h=Date:To:From:Subject:From;
        b=Fy7XHvKrQZ6XIKwTOWLXxXIpc0TQSg9kolf9HXKpRl495IuE1YvDq5ufhZYrSQ8+3
         jpUyiE+pkdGNdCRVCMid8EmhyfYqmL6Z3pikuTDaWKTyrrfUBFQkNvRJYEeUax4Box
         sfnh+ktMq3Ddxfs6LkaTlnH41As93o6v1zVmikRc=
Date:   Fri, 11 Aug 2023 16:03:01 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        punit.agrawal@bytedance.com, edumazet@google.com,
        arjunroy@google.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-some-pmd-faults-under-the-vma-lock.patch removed from -mm tree
Message-Id: <20230811230301.C99E2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle some PMD faults under the VMA lock
has been removed from the -mm tree.  Its filename was
     mm-handle-some-pmd-faults-under-the-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: handle some PMD faults under the VMA lock
Date: Mon, 24 Jul 2023 19:54:05 +0100

Push the VMA_LOCK check down from __handle_mm_fault() to
handle_pte_fault().  Once again, we refuse to call ->huge_fault() with the
VMA lock held, but we will wait for a PMD migration entry with the VMA
lock held, handle NUMA migration and set the accessed bit.  We were
already doing this for anonymous VMAs, so it should be safe.

Link: https://lkml.kernel.org/r/20230724185410.1124082-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Arjun Roy <arjunroy@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Punit Agrawal <punit.agrawal@bytedance.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

--- a/mm/memory.c~mm-handle-some-pmd-faults-under-the-vma-lock
+++ a/mm/memory.c
@@ -4821,36 +4821,47 @@ out_map:
 
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 {
-	if (vma_is_anonymous(vmf->vma))
+	struct vm_area_struct *vma = vmf->vma;
+	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
-	if (vmf->vma->vm_ops->huge_fault)
-		return vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+	if (vma->vm_ops->huge_fault) {
+		if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+			vma_end_read(vma);
+			return VM_FAULT_RETRY;
+		}
+		return vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+	}
 	return VM_FAULT_FALLBACK;
 }
 
 /* `inline' is required to avoid gcc 4.1.2 build error */
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
+	struct vm_area_struct *vma = vmf->vma;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	vm_fault_t ret;
 
-	if (vma_is_anonymous(vmf->vma)) {
+	if (vma_is_anonymous(vma)) {
 		if (likely(!unshare) &&
-		    userfaultfd_huge_pmd_wp(vmf->vma, vmf->orig_pmd))
+		    userfaultfd_huge_pmd_wp(vma, vmf->orig_pmd))
 			return handle_userfault(vmf, VM_UFFD_WP);
 		return do_huge_pmd_wp_page(vmf);
 	}
 
-	if (vmf->vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
-		if (vmf->vma->vm_ops->huge_fault) {
-			ret = vmf->vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
+	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		if (vma->vm_ops->huge_fault) {
+			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+				vma_end_read(vma);
+				return VM_FAULT_RETRY;
+			}
+			ret = vma->vm_ops->huge_fault(vmf, PE_SIZE_PMD);
 			if (!(ret & VM_FAULT_FALLBACK))
 				return ret;
 		}
 	}
 
 	/* COW or write-notify handled on pte level: split pmd. */
-	__split_huge_pmd(vmf->vma, vmf->pmd, vmf->address, false, NULL);
+	__split_huge_pmd(vma, vmf->pmd, vmf->address, false, NULL);
 
 	return VM_FAULT_FALLBACK;
 }
@@ -4921,6 +4932,11 @@ static vm_fault_t handle_pte_fault(struc
 {
 	pte_t entry;
 
+	if ((vmf->flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vmf->vma)) {
+		vma_end_read(vmf->vma);
+		return VM_FAULT_RETRY;
+	}
+
 	if (unlikely(pmd_none(*vmf->pmd))) {
 		/*
 		 * Leave __pte_alloc() until later: because vm_ops->fault may
@@ -5060,11 +5076,6 @@ retry_pud:
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if ((flags & FAULT_FLAG_VMA_LOCK) && !vma_is_anonymous(vma)) {
-		vma_end_read(vma);
-		return VM_FAULT_RETRY;
-	}
-
 	if (pmd_none(*vmf.pmd) &&
 	    hugepage_vma_check(vma, vm_flags, false, true, true)) {
 		ret = create_huge_pmd(&vmf);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

