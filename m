From: akpm@linux-foundation.org
Subject: [merged]
 x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:10:07 -0800
Message-ID: <52e8008f.zwLBWpWlyJ59hsSu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbaA1TKI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:10:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, riel@redhat.com, mingo@kernel.org, hpa@zytor.com, davidlohr@hp.com, alex.shi@linaro.org, mgorman@suse.de

Subject: [merged] x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch removed from -mm tree
To: mgorman@suse.de,alex.shi@linaro.org,davidlohr@hp.com,hpa@zytor.com,mingo@kernel.org,riel@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:10:07 -0800


The patch titled
     Subject: x86: mm: clean up inconsistencies when flushing TLB ranges
has been removed from the -mm tree.  Its filename was
     x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86: mm: clean up inconsistencies when flushing TLB ranges

NR_TLB_LOCAL_FLUSH_ALL is not always accounted for correctly and the
comparison with total_vm is done before taking tlb_flushall_shift into
account.  Clean it up.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Alex Shi <alex.shi@linaro.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H Peter Anvin <hpa@zytor.com>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/tlb.c~x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges
+++ a/arch/x86/mm/tlb.c
@@ -189,6 +189,7 @@ void flush_tlb_mm_range(struct mm_struct
 {
 	unsigned long addr;
 	unsigned act_entries, tlb_entries = 0;
+	unsigned long nr_base_pages;
 
 	preempt_disable();
 	if (current->active_mm != mm)
@@ -210,18 +211,17 @@ void flush_tlb_mm_range(struct mm_struct
 		tlb_entries = tlb_lli_4k[ENTRIES];
 	else
 		tlb_entries = tlb_lld_4k[ENTRIES];
+
 	/* Assume all of TLB entries was occupied by this task */
-	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
+	act_entries = tlb_entries >> tlb_flushall_shift;
+	act_entries = mm->total_vm > act_entries ? act_entries : mm->total_vm;
+	nr_base_pages = (end - start) >> PAGE_SHIFT;
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
-	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift) {
+	if (nr_base_pages > act_entries || has_large_page(mm, start, end)) {
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
-		if (has_large_page(mm, start, end)) {
-			local_flush_tlb();
-			goto flush_all;
-		}
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
 			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-page-writebackc-fix-dirty_balance_reserve-subtraction-from-dirtyable-memory.patch
mm-page-writebackc-do-not-count-anon-pages-as-dirtyable-memory.patch
mm-numa-initialse-numa-balancing-after-jump-label-initialisation.patch
mm-mempolicyc-convert-to-pr_foo.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch

