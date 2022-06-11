Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2E1C43334
	for <mm-commits@archiver.kernel.org>; Sat, 11 Jun 2022 20:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbiFKUgO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 11 Jun 2022 16:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiFKUgO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 11 Jun 2022 16:36:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F593694A5
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 13:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B38D61297
        for <mm-commits@vger.kernel.org>; Sat, 11 Jun 2022 20:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B7AC34116;
        Sat, 11 Jun 2022 20:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654979772;
        bh=uYFQFDZ/PRPF5F/0tOv2CMn3a4h6BOSiuhD8xfpY+wM=;
        h=Date:To:From:Subject:From;
        b=m+k9pcsAXWG73nNVT+qxADMkkbYGotYxHheWNdkQq3b25/KU6y1Vznia3dByZhLlH
         t2t/IMlynSbTju4tRR5fk5ac7pYeFqzfgfoGIafs6csBYWEbIxCnKgQYB1Y1OrKtu2
         CD3Kk3MZRO/ErdSDDRV6+VLo2Svj1GDDLRhuc7yU=
Date:   Sat, 11 Jun 2022 13:36:11 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, neilb@suse.de,
        mike.kravetz@oracle.com, dhowells@redhat.com, david@redhat.com,
        apopple@nvidia.com, aarcange@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch added to mm-unstable branch
Message-Id: <20220611203612.65B7AC34116@smtp.kernel.org>
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
mm-khugepaged-remove-unneeded-shmem_huge_enabled-check.patch
mm-khugepaged-stop-swapping-in-page-when-vm_fault_retry-occurs.patch
mm-khugepaged-trivial-typo-and-codestyle-cleanup.patch
mm-khugepaged-minor-cleanup-for-collapse_file.patch
mm-khugepaged-use-helper-macro-__attr_rw.patch
mm-khugepaged-remove-unneeded-return-value-of-khugepaged_add_pte_mapped_thp.patch
mm-khugepaged-try-to-free-transhuge-swapcache-when-possible.patch

