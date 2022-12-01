Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806FDC47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiLAACb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiLAAAx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A13687CBD
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6324614D0
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F29C433B5;
        Thu,  1 Dec 2022 00:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852849;
        bh=WRxklQY0yrpPqpPATApRsaSEjuE8nJaCCNX0eIEfodY=;
        h=Date:To:From:Subject:From;
        b=qruepiLCV7LOlrBN4XbfdmSlZFNUJuBWW144fVzw4zYARoSt/q6BBXrkfjXA/hjoU
         dh/E4anqkIkahL3x4yfJ8NlcYufdkMQm12jTSs/iYH+j6sWI8bG81ES7JcL+opOH1q
         aOD4AgNLTm5+gNaxK2Qlqw3/IUlBWOSqv990UPio=
Date:   Wed, 30 Nov 2022 16:00:48 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, david@redhat.com,
        aarcange@redhat.com, peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-pte-markers-for-swap-errors.patch removed from -mm tree
Message-Id: <20221201000049.06F29C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use pte markers for swap errors
has been removed from the -mm tree.  Its filename was
     mm-use-pte-markers-for-swap-errors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: use pte markers for swap errors
Date: Sun, 30 Oct 2022 17:41:51 -0400

PTE markers are ideal mechanism for things like SWP_SWAPIN_ERROR.  Using a
whole swap entry type for this purpose can be an overkill, especially if
we already have PTE markers.  Define a new bit for swapin error and
replace it with pte markers.  Then we can safely drop SWP_SWAPIN_ERROR and
give one device slot back to swap.

We used to have SWP_SWAPIN_ERROR taking the page pfn as part of the swap
entry, but it's never used.  Neither do I see how it can be useful because
normally the swapin failure should not be caused by a bad page but bad
swap device.  Drop it alongside.

Link: https://lkml.kernel.org/r/20221030214151.402274-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h    |    6 +-----
 include/linux/swapops.h |   26 ++++++++++++++------------
 mm/memory.c             |    6 ++++--
 mm/shmem.c              |    2 +-
 mm/swapfile.c           |    2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

--- a/include/linux/swap.h~mm-use-pte-markers-for-swap-errors
+++ a/include/linux/swap.h
@@ -55,10 +55,6 @@ static inline int current_is_kswapd(void
  * actions on faults.
  */
 
-#define SWP_SWAPIN_ERROR_NUM 1
-#define SWP_SWAPIN_ERROR     (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
-			     SWP_MIGRATION_NUM + SWP_DEVICE_NUM + \
-			     SWP_PTE_MARKER_NUM)
 /*
  * PTE markers are used to persist information onto PTEs that otherwise
  * should be a none pte.  As its name "PTE" hints, it should only be
@@ -121,7 +117,7 @@ static inline int current_is_kswapd(void
 #define MAX_SWAPFILES \
 	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
 	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - \
-	SWP_PTE_MARKER_NUM - SWP_SWAPIN_ERROR_NUM)
+	SWP_PTE_MARKER_NUM)
 
 /*
  * Magic header for a swap area. The first part of the union is
--- a/include/linux/swapops.h~mm-use-pte-markers-for-swap-errors
+++ a/include/linux/swapops.h
@@ -162,16 +162,6 @@ static inline void *swp_to_radix_entry(s
 	return xa_mk_value(entry.val);
 }
 
-static inline swp_entry_t make_swapin_error_entry(struct page *page)
-{
-	return swp_entry(SWP_SWAPIN_ERROR, page_to_pfn(page));
-}
-
-static inline int is_swapin_error_entry(swp_entry_t entry)
-{
-	return swp_type(entry) == SWP_SWAPIN_ERROR;
-}
-
 #if IS_ENABLED(CONFIG_DEVICE_PRIVATE)
 static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 {
@@ -409,8 +399,9 @@ static inline bool is_migration_entry_di
 
 typedef unsigned long pte_marker;
 
-#define  PTE_MARKER_UFFD_WP  BIT(0)
-#define  PTE_MARKER_MASK     (PTE_MARKER_UFFD_WP)
+#define  PTE_MARKER_UFFD_WP			BIT(0)
+#define  PTE_MARKER_SWAPIN_ERROR		BIT(1)
+#define  PTE_MARKER_MASK			(BIT(2) - 1)
 
 static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
 {
@@ -437,6 +428,17 @@ static inline pte_t make_pte_marker(pte_
 	return swp_entry_to_pte(make_pte_marker_entry(marker));
 }
 
+static inline swp_entry_t make_swapin_error_entry(void)
+{
+	return make_pte_marker_entry(PTE_MARKER_SWAPIN_ERROR);
+}
+
+static inline int is_swapin_error_entry(swp_entry_t entry)
+{
+	return is_pte_marker_entry(entry) &&
+	    (pte_marker_get(entry) & PTE_MARKER_SWAPIN_ERROR);
+}
+
 /*
  * This is a special version to check pte_none() just to cover the case when
  * the pte is a pte marker.  It existed because in many cases the pte marker
--- a/mm/memory.c~mm-use-pte-markers-for-swap-errors
+++ a/mm/memory.c
@@ -3668,6 +3668,10 @@ static vm_fault_t handle_pte_marker(stru
 	if (WARN_ON_ONCE(!marker))
 		return VM_FAULT_SIGBUS;
 
+	/* Higher priority than uffd-wp when data corrupted */
+	if (marker & PTE_MARKER_SWAPIN_ERROR)
+		return VM_FAULT_SIGBUS;
+
 	if (pte_marker_entry_uffd_wp(entry))
 		return pte_marker_handle_uffd_wp(vmf);
 
@@ -3727,8 +3731,6 @@ vm_fault_t do_swap_page(struct vm_fault
 			put_page(vmf->page);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
-		} else if (is_swapin_error_entry(entry)) {
-			ret = VM_FAULT_SIGBUS;
 		} else if (is_pte_marker_entry(entry)) {
 			ret = handle_pte_marker(vmf);
 		} else {
--- a/mm/shmem.c~mm-use-pte-markers-for-swap-errors
+++ a/mm/shmem.c
@@ -1682,7 +1682,7 @@ static void shmem_set_folio_swapin_error
 	swp_entry_t swapin_error;
 	void *old;
 
-	swapin_error = make_swapin_error_entry(&folio->page);
+	swapin_error = make_swapin_error_entry();
 	old = xa_cmpxchg_irq(&mapping->i_pages, index,
 			     swp_to_radix_entry(swap),
 			     swp_to_radix_entry(swapin_error), 0);
--- a/mm/swapfile.c~mm-use-pte-markers-for-swap-errors
+++ a/mm/swapfile.c
@@ -1781,7 +1781,7 @@ static int unuse_pte(struct vm_area_stru
 		pte_t pteval;
 
 		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-		pteval = swp_entry_to_pte(make_swapin_error_entry(page));
+		pteval = swp_entry_to_pte(make_swapin_error_entry());
 		set_pte_at(vma->vm_mm, addr, pte, pteval);
 		swap_free(entry);
 		ret = 0;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-migrate-fix-read-only-page-got-writable-when-recover-pte.patch
mm-hugetlb-let-vma_offset_start-to-return-start.patch
mm-hugetlb-dont-wait-for-migration-entry-during-follow-page.patch
mm-hugetlb-document-huge_pte_offset-usage.patch
mm-hugetlb-move-swap-entry-handling-into-vma-lock-when-faulted.patch
mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch
mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch
mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch
mm-hugetlb-make-walk_hugetlb_range-safe-to-pmd-unshare.patch
mm-hugetlb-make-page_vma_mapped_walk-safe-to-pmd-unshare.patch
mm-hugetlb-introduce-hugetlb_walk.patch
mm-hugetlb-introduce-hugetlb_walk-fix.patch
mm-hugetlb-introduce-hugetlb_walk-fix-2.patch

