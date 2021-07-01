Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C54C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D864761464
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbhGAAvn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:51:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238274AbhGAAvn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:51:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D952061424;
        Thu,  1 Jul 2021 00:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100553;
        bh=xlLCtKJ3OIKLZvA/uioBR6g3WblLdUPYV4dTW9Vftec=;
        h=Date:From:To:Subject:From;
        b=S/9Wff6if5cyea78yDqoFn4UKPMdNXlEc+H3cQIkuPQXkg7hgLCxCMWrb80IyAqcr
         McPoabGSrI8UN9+WQ8MDc4S+NTjeKu7swBJFEGwDG2TalgcRI7X8xdfh5Mvv5HCOTQ
         tE6AqFFRpihIvvv6hGXcieZ8v9Ar+02TO82ZxSMs=
Date:   Wed, 30 Jun 2021 17:49:12 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-huge=5Fmemoryc-add-missing-read-only-thp-checking-in-t?=
 =?US-ASCII?Q?ransparent=5Fhugepage=5Fenabled-v4.patch?= removed from -mm
 tree
Message-ID: <20210701004912.iAIHfAI9c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4.patch

This patch was dropped because it was folded into mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4

define transhuge_vma_enabled next to transhuge_vma_suitable

Link: https://lkml.kernel.org/r/20210514093007.4117906-1-linmiaohe@huawei.com
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled-v4
+++ a/include/linux/huge_mm.h
@@ -115,6 +115,21 @@ extern struct kobj_attribute shmem_enabl
 
 extern unsigned long transparent_hugepage_flags;
 
+static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
+		unsigned long haddr)
+{
+	/* Don't have to check pgoff for anonymous vma */
+	if (!vma_is_anonymous(vma)) {
+		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
+				HPAGE_PMD_NR))
+			return false;
+	}
+
+	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
+		return false;
+	return true;
+}
+
 static inline bool transhuge_vma_enabled(struct vm_area_struct *vma,
 					  unsigned long vm_flags)
 {
@@ -159,21 +174,6 @@ static inline bool __transparent_hugepag
 
 bool transparent_hugepage_active(struct vm_area_struct *vma);
 
-static inline bool transhuge_vma_suitable(struct vm_area_struct *vma,
-		unsigned long haddr)
-{
-	/* Don't have to check pgoff for anonymous vma */
-	if (!vma_is_anonymous(vma)) {
-		if (!IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
-				HPAGE_PMD_NR))
-			return false;
-	}
-
-	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
-		return false;
-	return true;
-}
-
 #define transparent_hugepage_use_zero_page()				\
 	(transparent_hugepage_flags &					\
 	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-swapfile-use-percpu_ref-to-serialize-against-concurrent-swapoff.patch
swap-fix-do_swap_page-race-with-swapoff.patch
mm-swap-remove-confusing-checking-for-non_swap_entry-in-swap_ra_info.patch
mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
mm-swapfile-move-get_swap_page_of_type-under-config_hibernation.patch
mm-swap-remove-unused-local-variable-nr_shadows.patch
mm-swap_slotsc-delete-meaningless-forward-declarations.patch
mm-huge_memoryc-remove-dedicated-macro-hpage_cache_index_mask.patch
mm-huge_memoryc-use-page-deferred_list.patch
mm-huge_memoryc-add-missing-read-only-thp-checking-in-transparent_hugepage_enabled.patch
mm-huge_memoryc-remove-unnecessary-tlb_remove_page_size-for-huge-zero-pmd.patch
mm-huge_memoryc-dont-discard-hugepage-if-other-processes-are-mapping-it.patch
mm-workingset-define-macro-workingset_shift.patch
mm-z3fold-define-macro-nchunks-as-total_chunks-zhdr_chunks.patch
mm-z3fold-avoid-possible-underflow-in-z3fold_alloc.patch
mm-z3fold-remove-magic-number-in-z3fold_create_pool.patch
mm-z3fold-remove-unused-function-handle_to_z3fold_header.patch
mm-z3fold-fix-potential-memory-leak-in-z3fold_destroy_pool.patch
mm-z3fold-use-release_z3fold_page_locked-to-release-locked-z3fold-page.patch
mm-zbud-reuse-unbuddied-as-buddied-in-zbud_pool.patch
mm-zbud-dont-export-any-zbud-api.patch
mm-zbud-dont-export-any-zbud-api-fix.patch
mm-zswapc-remove-unused-function-zswap_debugfs_exit.patch
mm-zswapc-avoid-unnecessary-copy-in-at-map-time.patch
mm-zswapc-fix-two-bugs-in-zswap_writeback_entry.patch
mm-zsmallocc-remove-confusing-code-in-obj_free.patch
mm-zsmallocc-improve-readability-for-async_free_zspage.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

