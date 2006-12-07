From: akpm@osdl.org
Subject: - htlb-forget-rss-with-pt-sharing.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:35 -0800
Message-ID: <200612072256.kB7MuZaC029213@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163557AbWLGW5y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenneth.w.chen@intel.com, agl@us.ibm.com, benh@kernel.crashing.org, davem@davemloft.net, david@gibson.dropbear.id.au, dmccr@us.ibm.com, hugh@veritas.com, lethal@linux-sh.org, paulus@samba.org, tony.luck@intel.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     htlb forget rss with pt sharing
has been removed from the -mm tree.  Its filename was
     htlb-forget-rss-with-pt-sharing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: htlb forget rss with pt sharing
From: "Chen, Kenneth W" <kenneth.w.chen@intel.com>

Imprecise RSS accounting is an irritating ill effect with pt sharing.  After
consulted with several VM experts, I have tried various methods to solve that
problem: (1) iterate through all mm_structs that share the PT and increment
count; (2) keep RSS count in page table structure and then sum them up at
reporting time.  None of the above methods yield any satisfactory
implementation.

Since process RSS accounting is pure information only, I propose we don't
count them at all for hugetlb page.  rlimit has such field, though there is
absolutely no enforcement on limiting that resource.  One other method is to
account all RSS at hugetlb mmap time regardless they are faulted or not.  I
opt for the simplicity of no accounting at all.


Hugetlb page are special, they are reserved up front in global reservation
pool and is not reclaimable.  From physical memory resource point of view, it
is already consumed regardless whether there are users using them.

If the concern is that RSS can be used to control resource allocation, we
already can specify hugetlb fs size limit and sysadmin can enforce that at
mount time.  Combined with the two points mentioned above, I fail to see if
there is anything got affected because of this patch.

Signed-off-by: Ken Chen <kenneth.w.chen@intel.com>
Acked-by: Hugh Dickins <hugh@veritas.com>
Cc: Dave McCracken <dmccr@us.ibm.com>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/hugetlb.c |    8 --------
 1 file changed, 8 deletions(-)

diff -puN mm/hugetlb.c~htlb-forget-rss-with-pt-sharing mm/hugetlb.c
--- a/mm/hugetlb.c~htlb-forget-rss-with-pt-sharing
+++ a/mm/hugetlb.c
@@ -344,7 +344,6 @@ int copy_hugetlb_page_range(struct mm_st
 			entry = *src_pte;
 			ptepage = pte_page(entry);
 			get_page(ptepage);
-			add_mm_counter(dst, file_rss, HPAGE_SIZE / PAGE_SIZE);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		}
 		spin_unlock(&src->page_table_lock);
@@ -377,10 +376,6 @@ void __unmap_hugepage_range(struct vm_ar
 	BUG_ON(end & ~HPAGE_MASK);
 
 	spin_lock(&mm->page_table_lock);
-
-	/* Update high watermark before we lower rss */
-	update_hiwater_rss(mm);
-
 	for (address = start; address < end; address += HPAGE_SIZE) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
@@ -395,9 +390,7 @@ void __unmap_hugepage_range(struct vm_ar
 
 		page = pte_page(pte);
 		list_add(&page->lru, &page_list);
-		add_mm_counter(mm, file_rss, (int) -(HPAGE_SIZE / PAGE_SIZE));
 	}
-
 	spin_unlock(&mm->page_table_lock);
 	flush_tlb_range(vma, start, end);
 	list_for_each_entry_safe(page, tmp, &page_list, lru) {
@@ -523,7 +516,6 @@ retry:
 	if (!pte_none(*ptep))
 		goto backout;
 
-	add_mm_counter(mm, file_rss, HPAGE_SIZE / PAGE_SIZE);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, address, ptep, new_pte);
_

Patches currently in -mm which might be from kenneth.w.chen@intel.com are

origin.patch
optimize-o_direct-on-block-device-v3.patch
optimize-o_direct-on-block-device-v3-tweak.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
sched-improve-migration-accuracy.patch
sched-improve-migration-accuracy-tidy.patch
sched-remove-lb_stopbalance-counter.patch
sched-optimize-activate_task-for-rt-task.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch

