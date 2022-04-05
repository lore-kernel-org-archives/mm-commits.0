Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9D7C4321E
	for <mm-commits@archiver.kernel.org>; Wed,  6 Apr 2022 01:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392393AbiDFB5G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Apr 2022 21:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242102AbiDEUch (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2022 16:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D85F70C6
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 13:17:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B9A8B81FC9
        for <mm-commits@vger.kernel.org>; Tue,  5 Apr 2022 20:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34ACBC385A0;
        Tue,  5 Apr 2022 20:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649189793;
        bh=z1aA1K9GEL5/BRaAI0h0joETiySCEicVTDWXtGfwbtw=;
        h=Date:To:From:Subject:From;
        b=EoKzvsxpYGUjQ9DvdeNdW6JftZpjE9cwLhNcP/wz7s1DccWhWBZPHB7hSFZBH0MFB
         RoEVlgQZX0Rip84itt2x6+GKezWxtnPlLwXdeLB735tMdNLZSLBM6UUPW0D+BryLlw
         HFjz/JQxWfOSlBs6Soe2sskKuCan1pf/pkfZQd48=
Date:   Tue, 05 Apr 2022 13:16:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-teach-core-mm-about-pte-markers.patch added to -mm tree
Message-Id: <20220405201633.34ACBC385A0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: teach core mm about pte markers
has been added to the -mm tree.  Its filename is
     mm-teach-core-mm-about-pte-markers.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-teach-core-mm-about-pte-markers.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-teach-core-mm-about-pte-markers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: teach core mm about pte markers

This patch still does not use pte marker in any way, however it teaches
the core mm about the pte marker idea.

For example, handle_pte_marker() is introduced that will parse and handle
all the pte marker faults.

Many of the places are more about commenting it up - so that we know
there's the possibility of pte marker showing up, and why we don't need
special code for the cases.

Link: https://lkml.kernel.org/r/20220405014833.14015-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   10 ++++++----
 mm/filemap.c     |    5 +++++
 mm/hmm.c         |    2 +-
 mm/memcontrol.c  |    8 ++++++--
 mm/memory.c      |   23 +++++++++++++++++++++++
 mm/mincore.c     |    3 ++-
 mm/mprotect.c    |    3 +++
 7 files changed, 46 insertions(+), 8 deletions(-)

--- a/fs/userfaultfd.c~mm-teach-core-mm-about-pte-markers
+++ a/fs/userfaultfd.c
@@ -249,9 +249,10 @@ static inline bool userfaultfd_huge_must
 
 	/*
 	 * Lockless access: we're in a wait_event so it's ok if it
-	 * changes under us.
+	 * changes under us.  PTE markers should be handled the same as none
+	 * ptes here.
 	 */
-	if (huge_pte_none(pte))
+	if (huge_pte_none_mostly(pte))
 		ret = true;
 	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
 		ret = true;
@@ -330,9 +331,10 @@ static inline bool userfaultfd_must_wait
 	pte = pte_offset_map(pmd, address);
 	/*
 	 * Lockless access: we're in a wait_event so it's ok if it
-	 * changes under us.
+	 * changes under us.  PTE markers should be handled the same as none
+	 * ptes here.
 	 */
-	if (pte_none(*pte))
+	if (pte_none_mostly(*pte))
 		ret = true;
 	if (!pte_write(*pte) && (reason & VM_UFFD_WP))
 		ret = true;
--- a/mm/filemap.c~mm-teach-core-mm-about-pte-markers
+++ a/mm/filemap.c
@@ -3382,6 +3382,11 @@ again:
 		vmf->pte += xas.xa_index - last_pgoff;
 		last_pgoff = xas.xa_index;
 
+		/*
+		 * NOTE: If there're PTE markers, we'll leave them to be
+		 * handled in the specific fault path, and it'll prohibit the
+		 * fault-around logic.
+		 */
 		if (!pte_none(*vmf->pte))
 			goto unlock;
 
--- a/mm/hmm.c~mm-teach-core-mm-about-pte-markers
+++ a/mm/hmm.c
@@ -239,7 +239,7 @@ static int hmm_vma_handle_pte(struct mm_
 	pte_t pte = *ptep;
 	uint64_t pfn_req_flags = *hmm_pfn;
 
-	if (pte_none(pte)) {
+	if (pte_none_mostly(pte)) {
 		required_fault =
 			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
 		if (required_fault)
--- a/mm/memcontrol.c~mm-teach-core-mm-about-pte-markers
+++ a/mm/memcontrol.c
@@ -5644,10 +5644,14 @@ static enum mc_target_type get_mctgt_typ
 
 	if (pte_present(ptent))
 		page = mc_handle_present_pte(vma, addr, ptent);
+	else if (pte_none_mostly(ptent))
+		/*
+		 * PTE markers should be treated as a none pte here, separated
+		 * from other swap handling below.
+		 */
+		page = mc_handle_file_pte(vma, addr, ptent);
 	else if (is_swap_pte(ptent))
 		page = mc_handle_swap_pte(vma, ptent, &ent);
-	else if (pte_none(ptent))
-		page = mc_handle_file_pte(vma, addr, ptent);
 
 	if (!page && !ent.val)
 		return ret;
--- a/mm/memory.c~mm-teach-core-mm-about-pte-markers
+++ a/mm/memory.c
@@ -100,6 +100,8 @@ struct page *mem_map;
 EXPORT_SYMBOL(mem_map);
 #endif
 
+static vm_fault_t do_fault(struct vm_fault *vmf);
+
 /*
  * A number of key systems in x86 including ioremap() rely on the assumption
  * that high_memory defines the upper bound on direct map memory, then end
@@ -1415,6 +1417,8 @@ again:
 			if (!should_zap_page(details, page))
 				continue;
 			rss[mm_counter(page)]--;
+		} else if (is_pte_marker_entry(entry)) {
+			/* By default, simply drop all pte markers when zap */
 		} else if (is_hwpoison_entry(entry)) {
 			if (!should_zap_cows(details))
 				continue;
@@ -3551,6 +3555,23 @@ static inline bool should_try_to_free_sw
 		page_count(page) == 2;
 }
 
+static vm_fault_t handle_pte_marker(struct vm_fault *vmf)
+{
+	swp_entry_t entry = pte_to_swp_entry(vmf->orig_pte);
+	unsigned long marker = pte_marker_get(entry);
+
+	/*
+	 * PTE markers should always be with file-backed memories, and the
+	 * marker should never be empty.  If anything weird happened, the best
+	 * thing to do is to kill the process along with its mm.
+	 */
+	if (WARN_ON_ONCE(vma_is_anonymous(vmf->vma) || !marker))
+		return VM_FAULT_SIGBUS;
+
+	/* TODO: handle pte markers */
+	return 0;
+}
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -3588,6 +3609,8 @@ vm_fault_t do_swap_page(struct vm_fault
 			ret = vmf->page->pgmap->ops->migrate_to_ram(vmf);
 		} else if (is_hwpoison_entry(entry)) {
 			ret = VM_FAULT_HWPOISON;
+		} else if (is_pte_marker_entry(entry)) {
+			ret = handle_pte_marker(vmf);
 		} else {
 			print_bad_pte(vma, vmf->address, vmf->orig_pte, NULL);
 			ret = VM_FAULT_SIGBUS;
--- a/mm/mincore.c~mm-teach-core-mm-about-pte-markers
+++ a/mm/mincore.c
@@ -122,7 +122,8 @@ static int mincore_pte_range(pmd_t *pmd,
 	for (; addr != end; ptep++, addr += PAGE_SIZE) {
 		pte_t pte = *ptep;
 
-		if (pte_none(pte))
+		/* We need to do cache lookup too for pte markers */
+		if (pte_none_mostly(pte))
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
 						 vma, vec);
 		else if (pte_present(pte))
--- a/mm/mprotect.c~mm-teach-core-mm-about-pte-markers
+++ a/mm/mprotect.c
@@ -193,6 +193,9 @@ static unsigned long change_pte_range(st
 					newpte = pte_swp_mksoft_dirty(newpte);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte = pte_swp_mkuffd_wp(newpte);
+			} else if (is_pte_marker_entry(entry)) {
+				/* Skip it, the same as none pte */
+				continue;
 			} else {
 				newpte = oldpte;
 			}
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-introduce-pte_marker-swap-entry.patch
mm-teach-core-mm-about-pte-markers.patch
mm-check-against-orig_pte-for-finish_fault.patch
mm-uffd-pte_marker_uffd_wp.patch
mm-shmem-take-care-of-uffdio_copy_mode_wp.patch
mm-shmem-handle-uffd-wp-special-pte-in-page-fault-handler.patch
mm-shmem-persist-uffd-wp-bit-across-zapping-for-file-backed.patch
mm-shmem-allow-uffd-wr-protect-none-pte-for-file-backed-mem.patch
mm-shmem-allows-file-back-mem-to-be-uffd-wr-protected-on-thps.patch
mm-shmem-handle-uffd-wp-during-fork.patch
mm-hugetlb-introduce-huge-pte-version-of-uffd-wp-helpers.patch
mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch
mm-hugetlb-take-care-of-uffdio_copy_mode_wp.patch
mm-hugetlb-handle-uffdio_writeprotect.patch
mm-hugetlb-handle-pte-markers-in-page-faults.patch
mm-hugetlb-allow-uffd-wr-protect-none-ptes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required.patch
mm-hugetlb-handle-uffd-wp-during-fork.patch
mm-khugepaged-dont-recycle-vma-pgtable-if-uffd-wp-registered.patch
mm-pagemap-recognize-uffd-wp-bit-for-shmem-hugetlbfs.patch
mm-uffd-enable-write-protection-for-shmem-hugetlbfs.patch
mm-enable-pte-markers-by-default.patch
selftests-uffd-enable-uffd-wp-for-shmem-hugetlbfs.patch

