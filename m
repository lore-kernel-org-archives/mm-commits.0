From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-swapcache-in-do_swap_page.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:14 -0800
Message-ID: <20130225205614.B9F005A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:51730 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3BYU4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:16 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so347695ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, hannes@cmpxchg.org, izik.eidus@ravellosystems.com, mgorman@suse.de, pholasek@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cleanup "swapcache" in do_swap_page
has been removed from the -mm tree.  Its filename was
     mm-cleanup-swapcache-in-do_swap_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: cleanup "swapcache" in do_swap_page

I dislike the way in which "swapcache" gets used in do_swap_page(): there
is always a page from swapcache there (even if maybe uncached by the time
we lock it), but tests are made according to "swapcache".  Rework that
with "page != swapcache", as has been done in unuse_pte().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN mm/memory.c~mm-cleanup-swapcache-in-do_swap_page mm/memory.c
--- a/mm/memory.c~mm-cleanup-swapcache-in-do_swap_page
+++ a/mm/memory.c
@@ -2954,7 +2954,7 @@ static int do_swap_page(struct mm_struct
 		unsigned int flags, pte_t orig_pte)
 {
 	spinlock_t *ptl;
-	struct page *page, *swapcache = NULL;
+	struct page *page, *swapcache;
 	swp_entry_t entry;
 	pte_t pte;
 	int locked;
@@ -3005,9 +3005,11 @@ static int do_swap_page(struct mm_struct
 		 */
 		ret = VM_FAULT_HWPOISON;
 		delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
+		swapcache = page;
 		goto out_release;
 	}
 
+	swapcache = page;
 	locked = lock_page_or_retry(page, mm, flags);
 
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
@@ -3025,16 +3027,12 @@ static int do_swap_page(struct mm_struct
 	if (unlikely(!PageSwapCache(page) || page_private(page) != entry.val))
 		goto out_page;
 
-	swapcache = page;
 	page = ksm_might_need_to_copy(page, vma, address);
 	if (unlikely(!page)) {
 		ret = VM_FAULT_OOM;
 		page = swapcache;
-		swapcache = NULL;
 		goto out_page;
 	}
-	if (page == swapcache)
-		swapcache = NULL;
 
 	if (mem_cgroup_try_charge_swapin(mm, page, GFP_KERNEL, &ptr)) {
 		ret = VM_FAULT_OOM;
@@ -3078,10 +3076,10 @@ static int do_swap_page(struct mm_struct
 	}
 	flush_icache_page(vma, page);
 	set_pte_at(mm, address, page_table, pte);
-	if (swapcache) /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, address);
-	else
+	if (page == swapcache)
 		do_page_add_anon_rmap(page, vma, address, exclusive);
+	else /* ksm created a completely new copy */
+		page_add_new_anon_rmap(page, vma, address);
 	/* It's better to call commit-charge after rmap is established */
 	mem_cgroup_commit_charge_swapin(page, ptr);
 
@@ -3089,7 +3087,7 @@ static int do_swap_page(struct mm_struct
 	if (vm_swap_full() || (vma->vm_flags & VM_LOCKED) || PageMlocked(page))
 		try_to_free_swap(page);
 	unlock_page(page);
-	if (swapcache) {
+	if (page != swapcache) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -3122,7 +3120,7 @@ out_page:
 	unlock_page(page);
 out_release:
 	page_cache_release(page);
-	if (swapcache) {
+	if (page != swapcache) {
 		unlock_page(swapcache);
 		page_cache_release(swapcache);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

