Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9709FC433E5
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8462361999
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhCSQOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhCSQOd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 12:14:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEF5261984;
        Fri, 19 Mar 2021 16:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616170473;
        bh=ZXv+zf7I6Mj2mmEas/IZLYCC9WnVA37G2bEjhBKFl9E=;
        h=Date:From:To:Subject:From;
        b=e2TRmPvpq5kZ4DxHKxJ8NLP7MKRk5OA1Vh9sGuy0EA5xz3I0RfYtU5lEdnyY9xl1u
         1w0ivZAMYWJtEBa04j5WQqLG9Fsgw6MmYGXCB225LyKwWNutwh0SeurU5v3AnYudYu
         kn4ZlayS6MsvlY3ZcLnjjTJbc/mXyru/d1N1eFVs=
Date:   Fri, 19 Mar 2021 09:14:32 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        minhquangbui99@gmail.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  +
 =?US-ASCII?Q?userfaultfd-write-protect-when-virtual-memory-range-has-n?=
 =?US-ASCII?Q?o-page-table-entry.patch?= added to -mm tree
Message-ID: <20210319161432.lKb2CxRTw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: write protect when virtual memory range has no page table entry
has been added to the -mm tree.  Its filename is
     userfaultfd-write-protect-when-virtual-memory-range-has-no-page-table-entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-write-protect-when-virtual-memory-range-has-no-page-table-entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-write-protect-when-virtual-memory-range-has-no-page-table-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bui Quang Minh <minhquangbui99@gmail.com>
Subject: userfaultfd: write protect when virtual memory range has no page table entry

userfaultfd_writeprotect() use change_protection() to clear write bit in
page table entries (pte/pmd).  So, later write to this virtual address
range causes a page fault, which is then handled by userspace program. 
However, change_protection() has no effect when there is no page table
entries associated with that virtual memory range (a newly mapped memory
range).  As a result, later access to that memory range causes allocating
a page table entry with write bit still set (due to VM_WRITE flag in
vma->vm_flags).

Add checks for VM_UFFD_WP in vma->vm_flags when allocating new page table
entry in missing page table entry page fault path.

Link: https://lkml.kernel.org/r/20210319152428.52683-1-minhquangbui99@gmail.com
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++++++++
 mm/memory.c      |   10 ++++++++++
 2 files changed, 22 insertions(+)

--- a/mm/huge_memory.c~userfaultfd-write-protect-when-virtual-memory-range-has-no-page-table-entry
+++ a/mm/huge_memory.c
@@ -636,6 +636,11 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+		if (userfaultfd_wp(vma)) {
+			entry = pmd_wrprotect(entry);
+			entry = pmd_mkuffd_wp(entry);
+		}
+
 		page_add_new_anon_rmap(page, vma, haddr, true);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
@@ -643,6 +648,13 @@ static vm_fault_t __do_huge_pmd_anonymou
 		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(vma->vm_mm);
+
+		if (userfaultfd_huge_pmd_wp(vma, *vmf->pmd)) {
+			spin_unlock(vmf->ptl);
+			count_vm_event(THP_FAULT_ALLOC);
+			count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+			return handle_userfault(vmf, VM_UFFD_WP);
+		}
 		spin_unlock(vmf->ptl);
 		count_vm_event(THP_FAULT_ALLOC);
 		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
--- a/mm/memory.c~userfaultfd-write-protect-when-virtual-memory-range-has-no-page-table-entry
+++ a/mm/memory.c
@@ -3564,6 +3564,11 @@ static vm_fault_t do_anonymous_page(stru
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
+	if (userfaultfd_wp(vma)) {
+		entry = pte_wrprotect(entry);
+		entry = pte_mkuffd_wp(entry);
+	}
+
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
 			&vmf->ptl);
 	if (!pte_none(*vmf->pte)) {
@@ -3590,6 +3595,11 @@ setpte:
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(vma, vmf->address, vmf->pte);
+
+	if (userfaultfd_pte_wp(vma, *vmf->pte)) {
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		return handle_userfault(vmf, VM_UFFD_WP);
+	}
 unlock:
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	return ret;
_

Patches currently in -mm which might be from minhquangbui99@gmail.com are

userfaultfd-write-protect-when-virtual-memory-range-has-no-page-table-entry.patch

