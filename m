Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F4EC433ED
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A33D16100C
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhDAAYc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhDAAYI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14F1D60FEC;
        Thu,  1 Apr 2021 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617236647;
        bh=K9DVoiedJgThplQp4aBeiZGC14lvqN5It8pH2gBfGY0=;
        h=Date:From:To:Subject:From;
        b=EsZCrzE5Pv+C1+nbPPSle/KVaP41piaEe5ePMdOKA753xBFsYG3+sbk8gy+PlrQCL
         NggB3pHD8GSWIQRMRv3vZdtvcXTCFooB56TF8yizFseRirrgWyzayW+CokcX+FzERA
         zSrNo9x4QCahN4T4LYEAXgX8nhAWv21Gbmq7Svdo=
Date:   Wed, 31 Mar 2021 17:24:06 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, axelrasmussen@google.com,
        minhquangbui99@gmail.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  [withdrawn]
 =?US-ASCII?Q?userfaultfd-write-protect-when-virtual-memory-range-has-n?=
 =?US-ASCII?Q?o-page-table-entry.patch?= removed from -mm tree
Message-ID: <20210401002406.Bhp2TXc4C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: write protect when virtual memory range has no page table entry
has been removed from the -mm tree.  Its filename was
     userfaultfd-write-protect-when-virtual-memory-range-has-no-page-table-entry.patch

This patch was dropped because it was withdrawn

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


