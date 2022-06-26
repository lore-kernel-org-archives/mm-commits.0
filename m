Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4901ECCA47C
	for <mm-commits@archiver.kernel.org>; Sun, 26 Jun 2022 20:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiFZU1u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Jun 2022 16:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiFZU1t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Jun 2022 16:27:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAC6FFC
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 13:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CABA60F85
        for <mm-commits@vger.kernel.org>; Sun, 26 Jun 2022 20:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B443CC341CA;
        Sun, 26 Jun 2022 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656275266;
        bh=KrT3me/b8w9GkR609GlWX4uvKiY6k+4T5uVOL0WcjAc=;
        h=Date:To:From:Subject:From;
        b=H1WP5Ht4RESSKoIxn9Y509hoaYwzbdlMQ8G7dYu4bqP6G35IbVQ1XVMP7zl6sSXtr
         9KkrwFhmmfdLrDeaDkvgfmE2cnsVwlhb25wdlDiEakmcCbaGvjP5GpYBHyPklL9dV3
         UOMIxdt+paxiDMNL9MwCnOCna8bnGVpDtINNZ82s=
Date:   Sun, 26 Jun 2022 13:27:46 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch added to mm-unstable branch
Message-Id: <20220626202746.B443CC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: stop swapping in page when VM_FAULT_RETRY occurs
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/khugepaged: stop swapping in page when VM_FAULT_RETRY occurs
Date: Sat, 25 Jun 2022 17:28:11 +0800

When do_swap_page returns VM_FAULT_RETRY, we do not retry here and thus
swap entry will remain in pagetable.  This will result in later failure. 
So stop swapping in pages in this case to save cpu cycles.  As A further
optimization, mmap_lock is released when __collapse_huge_page_swapin()
fails to avoid relocking mmap_lock.  And "swapped_in++" is moved after
error handling to make it more accurate.

Link: https://lkml.kernel.org/r/20220625092816.4856-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs
+++ a/mm/khugepaged.c
@@ -940,8 +940,8 @@ static int hugepage_vma_revalidate(struc
  * Bring missing pages in from swap, to complete THP collapse.
  * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
- * Called and returns without pte mapped or spinlocks held,
- * but with mmap_lock held to protect against vma changes.
+ * Called and returns without pte mapped or spinlocks held.
+ * Note that if false is returned, mmap_lock will be released.
  */
 
 static bool __collapse_huge_page_swapin(struct mm_struct *mm,
@@ -968,27 +968,24 @@ static bool __collapse_huge_page_swapin(
 			pte_unmap(vmf.pte);
 			continue;
 		}
-		swapped_in++;
 		ret = do_swap_page(&vmf);
 
-		/* do_swap_page returns VM_FAULT_RETRY with released mmap_lock */
+		/*
+		 * do_swap_page returns VM_FAULT_RETRY with released mmap_lock.
+		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
+		 * we do not retry here and swap entry will remain in pagetable
+		 * resulting in later failure.
+		 */
 		if (ret & VM_FAULT_RETRY) {
-			mmap_read_lock(mm);
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
+			mmap_read_unlock(mm);
 			trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, 0);
 			return false;
 		}
+		swapped_in++;
 	}
 
 	/* Drain LRU add pagevec to remove extra pin on the swapped in pages */
@@ -1054,13 +1051,12 @@ static void collapse_huge_page(struct mm
 	}
 
 	/*
-	 * __collapse_huge_page_swapin always returns with mmap_lock locked.
-	 * If it fails, we release mmap_lock and jump out_nolock.
+	 * __collapse_huge_page_swapin will return with mmap_lock released
+	 * when it fails. So we jump out_nolock directly in that case.
 	 * Continuing to collapse causes inconsistency.
 	 */
 	if (unmapped && !__collapse_huge_page_swapin(mm, vma, address,
 						     pmd, referenced)) {
-		mmap_read_unlock(mm);
 		goto out_nolock;
 	}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-migration-remove-unneeded-lock-page-and-pagemovable-check.patch
mm-migration-return-errno-when-isolate_huge_page-failed.patch
mm-migration-fix-potential-pte_unmap-on-an-not-mapped-pte.patch
mm-swapfile-make-security_vm_enough_memory_mm-work-as-expected.patch
mm-swapfile-fix-possible-data-races-of-inuse_pages.patch
mm-swap-remove-swap_cache_info-statistics.patch
mm-vmscan-dont-try-to-reclaim-freed-folios.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-madvise-minor-cleanup-for-swapin_walk_pmd_entry.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch

