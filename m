From: akpm@linux-foundation.org
Subject: [merged]
 move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:32:43 -0700
Message-ID: <53445ceb.+sc3D13T2zT1LKIn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbaDHUco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, rientjes@google.com, peterz@infradead.org, gang.xing@hp.com, chegu_vinod@hp.com, aarcange@redhat.com, riel@redhat.com

Subject: [merged] move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch removed from -mm tree
To: riel@redhat.com,aarcange@redhat.com,chegu_vinod@hp.com,gang.xing@hp.com,peterz@infradead.org,rientjes@google.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:32:43 -0700


The patch titled
     Subject: mm: move mmu notifier call from change_protection to change_pmd_range
has been removed from the -mm tree.  Its filename was
     move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: move mmu notifier call from change_protection to change_pmd_range

The NUMA scanning code can end up iterating over many gigabytes of
unpopulated memory, especially in the case of a freshly started KVM guest
with lots of memory.

This results in the mmu notifier code being called even when there are no
mapped pages in a virtual address range.  The amount of time wasted can be
enough to trigger soft lockup warnings with very large KVM guests.

This patch moves the mmu notifier call to the pmd level, which represents
1GB areas of memory on x86-64.  Furthermore, the mmu notifier code is only
called from the address in the PMD where present mappings are first
encountered.

The hugetlbfs code is left alone for now; hugetlb mappings are not
relocatable, and as such are left alone by the NUMA code, and should never
trigger this problem to begin with.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Xing Gang <gang.xing@hp.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    2 ++
 mm/mprotect.c |   15 ++++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~move-mmu-notifier-call-from-change_protection-to-change_pmd_range mm/hugetlb.c
--- a/mm/hugetlb.c~move-mmu-notifier-call-from-change_protection-to-change_pmd_range
+++ a/mm/hugetlb.c
@@ -3186,6 +3186,7 @@ unsigned long hugetlb_change_protection(
 	BUG_ON(address >= end);
 	flush_cache_range(vma, address, end);
 
+	mmu_notifier_invalidate_range_start(mm, start, end);
 	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
@@ -3215,6 +3216,7 @@ unsigned long hugetlb_change_protection(
 	 */
 	flush_tlb_range(vma, start, end);
 	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
+	mmu_notifier_invalidate_range_end(mm, start, end);
 
 	return pages << h->order;
 }
diff -puN mm/mprotect.c~move-mmu-notifier-call-from-change_protection-to-change_pmd_range mm/mprotect.c
--- a/mm/mprotect.c~move-mmu-notifier-call-from-change_protection-to-change_pmd_range
+++ a/mm/mprotect.c
@@ -140,9 +140,11 @@ static inline unsigned long change_pmd_r
 		pgprot_t newprot, int dirty_accountable, int prot_numa)
 {
 	pmd_t *pmd;
+	struct mm_struct *mm = vma->vm_mm;
 	unsigned long next;
 	unsigned long pages = 0;
 	unsigned long nr_huge_updates = 0;
+	unsigned long mni_start = 0;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -151,6 +153,13 @@ static inline unsigned long change_pmd_r
 		next = pmd_addr_end(addr, end);
 		if (!pmd_trans_huge(*pmd) && pmd_none_or_clear_bad(pmd))
 			continue;
+
+		/* invoke the mmu notifier if the pmd is populated */
+		if (!mni_start) {
+			mni_start = addr;
+			mmu_notifier_invalidate_range_start(mm, mni_start, end);
+		}
+
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
 				split_huge_page_pmd(vma, addr, pmd);
@@ -175,6 +184,9 @@ static inline unsigned long change_pmd_r
 		pages += this_pages;
 	} while (pmd++, addr = next, addr != end);
 
+	if (mni_start)
+		mmu_notifier_invalidate_range_end(mm, mni_start, end);
+
 	if (nr_huge_updates)
 		count_vm_numa_events(NUMA_HUGE_PTE_UPDATES, nr_huge_updates);
 	return pages;
@@ -234,15 +246,12 @@ unsigned long change_protection(struct v
 		       unsigned long end, pgprot_t newprot,
 		       int dirty_accountable, int prot_numa)
 {
-	struct mm_struct *mm = vma->vm_mm;
 	unsigned long pages;
 
-	mmu_notifier_invalidate_range_start(mm, start, end);
 	if (is_vm_hugetlb_page(vma))
 		pages = hugetlb_change_protection(vma, start, end, newprot);
 	else
 		pages = change_protection_range(vma, start, end, newprot, dirty_accountable, prot_numa);
-	mmu_notifier_invalidate_range_end(mm, start, end);
 
 	return pages;
 }
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-rmap-dont-try-to-add-an-unevictable-page-to-lru-list.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

