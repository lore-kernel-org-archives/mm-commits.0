From: akpm@linux-foundation.org
Subject: + badpage-ratelimit-print_bad_pte-and-bad_page.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:57:23 -0800
Message-ID: <200812030057.mB30vNwn024546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbYLCA7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:59:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     badpage: ratelimit print_bad_pte and bad_page
has been added to the -mm tree.  Its filename is
     badpage-ratelimit-print_bad_pte-and-bad_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: badpage: ratelimit print_bad_pte and bad_page
From: Hugh Dickins <hugh@veritas.com>

print_bad_pte() and bad_page() might each need ratelimiting - especially
for their dump_stacks, almost never of interest, yet not quite
dispensible.  Correlating corruption across neighbouring entries can be
very helpful, so allow a burst of 60 reports before keeping quiet for the
remainder of that minute (or allow a steady drip of one report per
second).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |   23 +++++++++++++++++++++++
 mm/page_alloc.c |   26 +++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~badpage-ratelimit-print_bad_pte-and-bad_page mm/memory.c
--- a/mm/memory.c~badpage-ratelimit-print_bad_pte-and-bad_page
+++ a/mm/memory.c
@@ -383,6 +383,29 @@ static void print_bad_pte(struct vm_area
 	pmd_t *pmd = pmd_offset(pud, addr);
 	struct address_space *mapping;
 	pgoff_t index;
+	static unsigned long resume;
+	static unsigned long nr_shown;
+	static unsigned long nr_unshown;
+
+	/*
+	 * Allow a burst of 60 reports, then keep quiet for that minute;
+	 * or allow a steady drip of one report per second.
+	 */
+	if (nr_shown == 60) {
+		if (time_before(jiffies, resume)) {
+			nr_unshown++;
+			return;
+		}
+		if (nr_unshown) {
+			printk(KERN_EMERG
+				"Bad page map: %lu messages suppressed\n",
+				nr_unshown);
+			nr_unshown = 0;
+		}
+		nr_shown = 0;
+	}
+	if (nr_shown++ == 0)
+		resume = jiffies + 60 * HZ;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
diff -puN mm/page_alloc.c~badpage-ratelimit-print_bad_pte-and-bad_page mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-ratelimit-print_bad_pte-and-bad_page
+++ a/mm/page_alloc.c
@@ -223,6 +223,30 @@ static inline int bad_range(struct zone 
 
 static void bad_page(struct page *page)
 {
+	static unsigned long resume;
+	static unsigned long nr_shown;
+	static unsigned long nr_unshown;
+
+	/*
+	 * Allow a burst of 60 reports, then keep quiet for that minute;
+	 * or allow a steady drip of one report per second.
+	 */
+	if (nr_shown == 60) {
+		if (time_before(jiffies, resume)) {
+			nr_unshown++;
+			goto out;
+		}
+		if (nr_unshown) {
+			printk(KERN_EMERG
+				"Bad page state: %lu messages suppressed\n",
+				nr_unshown);
+			nr_unshown = 0;
+		}
+		nr_shown = 0;
+	}
+	if (nr_shown++ == 0)
+		resume = jiffies + 60 * HZ;
+
 	printk(KERN_EMERG "Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
 	printk(KERN_EMERG
@@ -232,7 +256,7 @@ static void bad_page(struct page *page)
 	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
 
 	dump_stack();
-
+out:
 	/* Leave bad fields for debug, except PageBuddy could make trouble */
 	__ClearPageBuddy(page);
 	add_taint(TAINT_BAD_PAGE);
_

Patches currently in -mm which might be from hugh@veritas.com are

ksym_symbol_len-fixes.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
badpage-simplify-page_alloc-flag-checkclear.patch
badpage-keep-any-bad-page-out-of-circulation.patch
badpage-replace-page_remove_rmap-eeek-and-bug.patch
badpage-vm_normal_page-use-print_bad_pte.patch
badpage-zap-print_bad_pte-on-swap-and-file.patch
badpage-remove-vma-from-page_remove_rmap.patch
badpage-ratelimit-print_bad_pte-and-bad_page.patch
badpage-kern_alert-bug-instead-of-kern_emerg.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

