Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9A9C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358825AbiEMTVW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380334AbiEMTUy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:20:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4A1DECE
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:20:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1E74ECE3303
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEAFC34113;
        Fri, 13 May 2022 19:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469649;
        bh=u8VYSXkIEt/cH2AfypzS0Kc9jInQ+8DtD3vEx7bsSXk=;
        h=Date:To:From:Subject:From;
        b=zr181nv5jDCDrK2ZvDwqr0s63QONTBvdRBgytPsN3IIMFHVGzBFBFbhp0Xzzg42bo
         INr6zTYwmY9YboovTAEOAm3eW/irMD9ckbQ6YYBwcWLmBZDjzONzU0EZTnNPtWhZSK
         62Pb2IYegmEbqBBfZpV37r0AGrWN4q4tYRp3eP1w=
Date:   Fri, 13 May 2022 12:20:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-teach-core-mm-about-pte-markers.patch removed from -mm tree
Message-Id: <20220513192049.7EEAFC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: teach core mm about pte markers
has been removed from the -mm tree.  Its filename was
     mm-teach-core-mm-about-pte-markers.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[peterx@redhat.com: userfaultfd.c needs swapops.h]
  Link: https://lkml.kernel.org/r/YmRlVj3cdizYJsr0@xz-m1.local
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

 fs/userfaultfd.c |   11 +++++++----
 mm/filemap.c     |    5 +++++
 mm/hmm.c         |    2 +-
 mm/memcontrol.c  |    8 ++++++--
 mm/memory.c      |   23 +++++++++++++++++++++++
 mm/mincore.c     |    3 ++-
 mm/mprotect.c    |    3 +++
 7 files changed, 47 insertions(+), 8 deletions(-)

--- a/fs/userfaultfd.c~mm-teach-core-mm-about-pte-markers
+++ a/fs/userfaultfd.c
@@ -29,6 +29,7 @@
 #include <linux/ioctl.h>
 #include <linux/security.h>
 #include <linux/hugetlb.h>
+#include <linux/swapops.h>
 
 int sysctl_unprivileged_userfaultfd __read_mostly;
 
@@ -249,9 +250,10 @@ static inline bool userfaultfd_huge_must
 
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
@@ -330,9 +332,10 @@ static inline bool userfaultfd_must_wait
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
@@ -3376,6 +3376,11 @@ again:
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
@@ -5640,10 +5640,14 @@ static enum mc_target_type get_mctgt_typ
 
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
@@ -3555,6 +3559,23 @@ static inline bool should_try_to_free_sw
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
@@ -3592,6 +3613,8 @@ vm_fault_t do_swap_page(struct vm_fault
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


