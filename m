From: akpm@linux-foundation.org
Subject: [merged] mmksm-swapoff-might-need-to-copy.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:11 -0800
Message-ID: <20130225205611.CE8E531C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:45237 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759787Ab3BYU4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:13 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so363497qah.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm,ksm: swapoff might need to copy
has been removed from the -mm tree.  Its filename was
     mmksm-swapoff-might-need-to-copy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,ksm: swapoff might need to copy

Before establishing that KSM page migration was the cause of my
WARN_ON_ONCE(page_mapped(page))s, I suspected that they came from the lack
of a ksm_might_need_to_copy() in swapoff's unuse_pte() - which in many
respects is equivalent to faulting in a page.

In fact I've never caught that as the cause: but in theory it does at
least need the KSM_RUN_UNMERGE check in ksm_might_need_to_copy(), to avoid
bringing a KSM page back in when it's not supposed to be.

I intended to copy how it's done in do_swap_page(), but have a strong
aversion to how "swapcache" ends up being used there: rework it with "page
!= swapcache".

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/swapfile.c~mmksm-swapoff-might-need-to-copy mm/swapfile.c
--- a/mm/swapfile.c~mmksm-swapoff-might-need-to-copy
+++ a/mm/swapfile.c
@@ -874,11 +874,17 @@ unsigned int count_swap_pages(int type, 
 static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
+	struct page *swapcache;
 	struct mem_cgroup *memcg;
 	spinlock_t *ptl;
 	pte_t *pte;
 	int ret = 1;
 
+	swapcache = page;
+	page = ksm_might_need_to_copy(page, vma, addr);
+	if (unlikely(!page))
+		return -ENOMEM;
+
 	if (mem_cgroup_try_charge_swapin(vma->vm_mm, page,
 					 GFP_KERNEL, &memcg)) {
 		ret = -ENOMEM;
@@ -897,7 +903,10 @@ static int unuse_pte(struct vm_area_stru
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
 		   pte_mkold(mk_pte(page, vma->vm_page_prot)));
-	page_add_anon_rmap(page, vma, addr);
+	if (page == swapcache)
+		page_add_anon_rmap(page, vma, addr);
+	else /* ksm created a completely new copy */
+		page_add_new_anon_rmap(page, vma, addr);
 	mem_cgroup_commit_charge_swapin(page, memcg);
 	swap_free(entry);
 	/*
@@ -908,6 +917,10 @@ static int unuse_pte(struct vm_area_stru
 out:
 	pte_unmap_unlock(pte, ptl);
 out_nolock:
+	if (page != swapcache) {
+		unlock_page(page);
+		put_page(page);
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

