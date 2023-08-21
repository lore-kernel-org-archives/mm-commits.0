Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FC0EE49A0
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjHUUII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjHUUIG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:08:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50938E4
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:08:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3614649D9
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BC9C433CC;
        Mon, 21 Aug 2023 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692648483;
        bh=GUSAxjiit/ZgxptDqu8FnYjwksVzcn0OybqLgAv6y5E=;
        h=Date:To:From:Subject:From;
        b=xcwn9FaOta+UBdhxfi+ctrzC2MnIdLHBQez1jijZ9xzOlkjR4/x9obed4bCh9QuEH
         gimNCBB6o5LlmA4iwXFptdb93Moc4ULoTk7wCNT0Rkg+cAi8XBA4oFUQSnVLPb95C+
         mIAiSvOSUDIkapZTaC5bYdOlNxoJq9hTNJL/ZWbE=
Date:   Mon, 21 Aug 2023 13:08:02 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        torvalds@linux-foundation.org, shuah@kernel.org, peterx@redhat.com,
        pbonzini@redhat.com, mgorman@techsingularity.net, mgorman@suse.de,
        liubo254@huawei.com, jhubbard@nvidia.com, jgg@ziepe.ca,
        hughd@google.com, david@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch removed from -mm tree
Message-Id: <20230821200803.46BC9C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: smaps: use vm_normal_page_pmd() instead of follow_trans_huge_pmd()
has been removed from the -mm tree.  Its filename was
     smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: smaps: use vm_normal_page_pmd() instead of follow_trans_huge_pmd()
Date: Thu, 3 Aug 2023 16:32:03 +0200

We shouldn't be using a GUP-internal helper if it can be avoided.

Similar to smaps_pte_entry() that uses vm_normal_page(), let's use
vm_normal_page_pmd() that similarly refuses to return the huge zeropage.

In contrast to follow_trans_huge_pmd(), vm_normal_page_pmd():

(1) Will always return the head page, not a tail page of a THP.

 If we'd ever call smaps_account with a tail page while setting "compound
 = true", we could be in trouble, because smaps_account() would look at
 the memmap of unrelated pages.

 If we're unlucky, that memmap does not exist at all. Before we removed
 PG_doublemap, we could have triggered something similar as in
 commit 24d7275ce279 ("fs/proc: task_mmu.c: don't read mapcount for
 migration entry").

 This can theoretically happen ever since commit ff9f47f6f00c ("mm: proc:
 smaps_rollup: do not stall write attempts on mmap_lock"):

  (a) We're in show_smaps_rollup() and processed a VMA
  (b) We release the mmap lock in show_smaps_rollup() because it is
      contended
  (c) We merged that VMA with another VMA
  (d) We collapsed a THP in that merged VMA at that position

 If the end address of the original VMA falls into the middle of a THP
 area, we would call smap_gather_stats() with a start address that falls
 into a PMD-mapped THP. It's probably very rare to trigger when not
 really forced.

(2) Will succeed on a is_pci_p2pdma_page(), like vm_normal_page()

 Treat such PMDs here just like smaps_pte_entry() would treat such PTEs.
 If such pages would be anonymous, we most certainly would want to
 account them.

(3) Will skip over pmd_devmap(), like vm_normal_page() for pte_devmap()

 As noted in vm_normal_page(), that is only for handling legacy ZONE_DEVICE
 pages. So just like smaps_pte_entry(), we'll now also ignore such PMD
 entries.

 Especially, follow_pmd_mask() never ends up calling
 follow_trans_huge_pmd() on pmd_devmap(). Instead it calls
 follow_devmap_pmd() -- which will fail if neither FOLL_GET nor FOLL_PIN
 is set.

 So skipping pmd_devmap() pages seems to be the right thing to do.

(4) Will properly handle VM_MIXEDMAP/VM_PFNMAP, like vm_normal_page()

 We won't be returning a memmap that should be ignored by core-mm, or
 worse, a memmap that does not even exist. Note that while
 walk_page_range() will skip VM_PFNMAP mappings, walk_page_vma() won't.

 Most probably this case doesn't currently really happen on the PMD level,
 otherwise we'd already be able to trigger kernel crashes when reading
 smaps / smaps_rollup.

So most probably only (1) is relevant in practice as of now, but could only
cause trouble in extreme corner cases.

Let's move follow_trans_huge_pmd() to mm/internal.h to discourage future
reuse in wrong context.

Link: https://lkml.kernel.org/r/20230803143208.383663-3-david@redhat.com
Fixes: ff9f47f6f00c ("mm: proc: smaps_rollup: do not stall write attempts on mmap_lock")
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: liubo <liubo254@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |    3 +--
 include/linux/huge_mm.h |    3 ---
 mm/internal.h           |    7 +++++++
 3 files changed, 8 insertions(+), 5 deletions(-)

--- a/fs/proc/task_mmu.c~smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd
+++ a/fs/proc/task_mmu.c
@@ -587,8 +587,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 	bool migration = false;
 
 	if (pmd_present(*pmd)) {
-		/* FOLL_DUMP will return -EFAULT on huge zero page */
-		page = follow_trans_huge_pmd(vma, addr, pmd, FOLL_DUMP);
+		page = vm_normal_page_pmd(vma, addr, *pmd);
 	} else if (unlikely(thp_migration_supported() && is_swap_pmd(*pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
 
--- a/include/linux/huge_mm.h~smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd
+++ a/include/linux/huge_mm.h
@@ -25,9 +25,6 @@ static inline void huge_pud_set_accessed
 #endif
 
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
-struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
-				   unsigned long addr, pmd_t *pmd,
-				   unsigned int flags);
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			   pmd_t *pmd, unsigned long addr, unsigned long next);
 int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
--- a/mm/internal.h~smaps-use-vm_normal_page_pmd-instead-of-follow_trans_huge_pmd
+++ a/mm/internal.h
@@ -924,6 +924,13 @@ int migrate_device_coherent_page(struct
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags);
 int __must_check try_grab_page(struct page *page, unsigned int flags);
 
+/*
+ * mm/huge_memory.c
+ */
+struct page *follow_trans_huge_pmd(struct vm_area_struct *vma,
+				   unsigned long addr, pmd_t *pmd,
+				   unsigned int flags);
+
 enum {
 	/* mark page accessed */
 	FOLL_TOUCH = 1 << 16,
_

Patches currently in -mm which might be from david@redhat.com are

kvm-explicitly-set-foll_honor_numa_fault-in-hva_to_pfn_slow.patch
mm-gup-dont-implicitly-set-foll_honor_numa_fault.patch
pgtable-improve-pte_protnone-comment.patch
selftest-mm-ksm_functional_tests-test-in-mmap_and_merge_range-if-anything-got-merged.patch
selftest-mm-ksm_functional_tests-add-prot_none-test.patch
selftest-mm-ksm_functional_tests-add-prot_none-test-fix.patch
mm-swap-stop-using-page-private-on-tail-pages-for-thp_swap.patch
mm-swap-inline-folio_set_swap_entry-and-folio_swap_entry.patch
mm-huge_memory-work-on-folio-swap-instead-of-page-private-when-splitting-folio.patch

