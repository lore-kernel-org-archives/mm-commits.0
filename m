Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4E0C43334
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiGDBNF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiGDBL6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D632A6434
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80A06B80C73
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200D8C341C7;
        Mon,  4 Jul 2022 01:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897058;
        bh=xXFG3iwoLxeMlerUrDzK3PltcORdD1UkHl5T8iEB4DY=;
        h=Date:To:From:Subject:From;
        b=USR/6GbQ+4cY6XD6AJ8wRV5zGtu8kpbdwWguRm5//P1ZMlBHIaikZZeLr1MknfXCX
         6WG3LhI5+IuM/ZS9x/vDoGOibAjegZHp/tlNviUhc33Z8VqOJSF0SGAzRis5LYDhyF
         GchEGFmqQ4duOiazpnB6kMlZAFvS1iNXmBJPRAcA=
Date:   Sun, 03 Jul 2022 18:10:57 -0700
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        willy@infradead.org, vbabka@suse.cz, surenb@google.com,
        shy828301@gmail.com, peterx@redhat.com, neilb@suse.de,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch removed from -mm tree
Message-Id: <20220704011058.200D8C341C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/khugepaged: stop swapping in page when VM_FAULT_RETRY occurs
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -972,8 +972,8 @@ static int hugepage_vma_revalidate(struc
  * Bring missing pages in from swap, to complete THP collapse.
  * Only done if khugepaged_scan_pmd believes it is worthwhile.
  *
- * Called and returns without pte mapped or spinlocks held,
- * but with mmap_lock held to protect against vma changes.
+ * Called and returns without pte mapped or spinlocks held.
+ * Note that if false is returned, mmap_lock will be released.
  */
 
 static bool __collapse_huge_page_swapin(struct mm_struct *mm,
@@ -1000,27 +1000,24 @@ static bool __collapse_huge_page_swapin(
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
@@ -1086,13 +1083,12 @@ static void collapse_huge_page(struct mm
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

mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
mm-mmapc-fix-missing-call-to-vm_unacct_memory-in-mmap_region.patch
filemap-minor-cleanup-for-filemap_write_and_wait_range.patch

