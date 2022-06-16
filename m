Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65490CCA47A
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jun 2022 20:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378798AbiFPUt1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 16:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiFPUsu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 16:48:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A379956C38
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 13:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62D92B8260A
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 20:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC86C341D3;
        Thu, 16 Jun 2022 20:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655412527;
        bh=Z+JjXms5qqWM0mSPBLJITFuas6Zh/8Ic4tNmnzQVFhQ=;
        h=Date:To:From:Subject:From;
        b=H7FMra/vSXiI+bZ+x+LahdJ2b3SEWE0tNFP4gr/MOn7XN0c6h7ShaduiBXisS5pRV
         GdmR5Ifzhslm6iUmDXSpIj7CcgJtEYm5kkBUyCaK1V1AIlE39utxVUGZQrBzQ0M19Z
         9yb4gdhjgREvEClzGyG95fxXD19LHLR+KcC7Spa0=
Date:   Thu, 16 Jun 2022 13:48:46 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        mike.kravetz@oracle.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch removed from -mm tree
Message-Id: <20220616204847.1FC86C341D3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: stop swapping in page when VM_FAULT_RETRY occurs
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: stop swapping in page when VM_FAULT_RETRY occurs
Date: Sat, 11 Jun 2022 16:47:26 +0800

When do_swap_page returns VM_FAULT_RETRY, we do not retry here and thus
swap entry will remain in pagetable.  This will result in later failure. 
So stop swapping in pages in this case to save cpu cycles.

Link: https://lkml.kernel.org/r/20220611084731.55155-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Zach O'Keefe" <zokeefe@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs
+++ a/mm/khugepaged.c
@@ -1003,19 +1003,16 @@ static bool __collapse_huge_page_swapin(
 		swapped_in++;
 		ret = do_swap_page(&vmf);
 
-		/* do_swap_page returns VM_FAULT_RETRY with released mmap_lock */
+		/*
+		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
+		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
+		 * we do not retry here and swap entry will remain in pagetable
+		 * resulting in later failure.
+		 */
 		if (ret & VM_FAULT_RETRY) {
 			mmap_read_lock(mm);
-			if (hugepage_vma_revalidate(mm, haddr, &vma)) {
-				/* vma is no longer available, don't continue to swapin */
-				trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
-				return false;
-			}
-			/* check if the pmd is still valid */
-			if (mm_find_pmd(mm, haddr) != pmd) {
-				trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
-				return false;
-			}
+			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
+			return false;
 		}
 		if (ret & VM_FAULT_ERROR) {
 			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

maintainers-add-myself-as-a-memory-failure-reviewer.patch
mm-shmemc-clean-up-comment-of-shmem_swapin_folio.patch
mm-reduce-the-rcu-lock-duration.patch
mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-memremap-fix-wrong-function-name-above-memremap_pages.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
lib-test_hmm-avoid-accessing-uninitialized-pages.patch
mm-memremap-fix-memunmap_pages-race-with-get_dev_pagemap.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

