From: akpm@linux-foundation.org
Subject: + badpage-kern_alert-bug-instead-of-kern_emerg.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:57:25 -0800
Message-ID: <200812030057.mB30vQwQ024554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755837AbYLCA7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, cl@linux-foundation.org, mel@csn.ul.ie, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     badpage: KERN_ALERT BUG instead of KERN_EMERG
has been added to the -mm tree.  Its filename is
     badpage-kern_alert-bug-instead-of-kern_emerg.patch

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
Subject: badpage: KERN_ALERT BUG instead of KERN_EMERG
From: Hugh Dickins <hugh@veritas.com>

bad_page() and rmap Eeek messages have said KERN_EMERG for a few years,
which I've followed in print_bad_pte().  These are serious system errors,
on a par with BUGs, but they're not quite emergencies, and we do our best
to carry on: say KERN_ALERT "BUG: " like the x86 oops does.

And remove the "Trying to fix it up, but a reboot is needed" line: it's
not untrue, but I hope the KERN_ALERT "BUG: " conveys as much.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c     |   15 ++++++++-------
 mm/page_alloc.c |    9 ++++-----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN mm/memory.c~badpage-kern_alert-bug-instead-of-kern_emerg mm/memory.c
--- a/mm/memory.c~badpage-kern_alert-bug-instead-of-kern_emerg
+++ a/mm/memory.c
@@ -397,8 +397,8 @@ static void print_bad_pte(struct vm_area
 			return;
 		}
 		if (nr_unshown) {
-			printk(KERN_EMERG
-				"Bad page map: %lu messages suppressed\n",
+			printk(KERN_ALERT
+				"BUG: Bad page map: %lu messages suppressed\n",
 				nr_unshown);
 			nr_unshown = 0;
 		}
@@ -410,26 +410,27 @@ static void print_bad_pte(struct vm_area
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
 
-	printk(KERN_EMERG "Bad page map in process %s  pte:%08llx pmd:%08llx\n",
+	printk(KERN_ALERT
+		"BUG: Bad page map in process %s  pte:%08llx pmd:%08llx\n",
 		current->comm,
 		(long long)pte_val(pte), (long long)pmd_val(*pmd));
 	if (page) {
-		printk(KERN_EMERG
+		printk(KERN_ALERT
 		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
 		page, (void *)page->flags, page_count(page),
 		page_mapcount(page), page->mapping, page->index);
 	}
-	printk(KERN_EMERG
+	printk(KERN_ALERT
 		"addr:%p vm_flags:%08lx anon_vma:%p mapping:%p index:%lx\n",
 		(void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
 	/*
 	 * Choose text because data symbols depend on CONFIG_KALLSYMS_ALL=y
 	 */
 	if (vma->vm_ops)
-		print_symbol(KERN_EMERG "vma->vm_ops->fault: %s\n",
+		print_symbol(KERN_ALERT "vma->vm_ops->fault: %s\n",
 				(unsigned long)vma->vm_ops->fault);
 	if (vma->vm_file && vma->vm_file->f_op)
-		print_symbol(KERN_EMERG "vma->vm_file->f_op->mmap: %s\n",
+		print_symbol(KERN_ALERT "vma->vm_file->f_op->mmap: %s\n",
 				(unsigned long)vma->vm_file->f_op->mmap);
 	dump_stack();
 	add_taint(TAINT_BAD_PAGE);
diff -puN mm/page_alloc.c~badpage-kern_alert-bug-instead-of-kern_emerg mm/page_alloc.c
--- a/mm/page_alloc.c~badpage-kern_alert-bug-instead-of-kern_emerg
+++ a/mm/page_alloc.c
@@ -237,8 +237,8 @@ static void bad_page(struct page *page)
 			goto out;
 		}
 		if (nr_unshown) {
-			printk(KERN_EMERG
-				"Bad page state: %lu messages suppressed\n",
+			printk(KERN_ALERT
+			      "BUG: Bad page state: %lu messages suppressed\n",
 				nr_unshown);
 			nr_unshown = 0;
 		}
@@ -247,13 +247,12 @@ static void bad_page(struct page *page)
 	if (nr_shown++ == 0)
 		resume = jiffies + 60 * HZ;
 
-	printk(KERN_EMERG "Bad page state in process %s  pfn:%05lx\n",
+	printk(KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
-	printk(KERN_EMERG
+	printk(KERN_ALERT
 		"page:%p flags:%p count:%d mapcount:%d mapping:%p index:%lx\n",
 		page, (void *)page->flags, page_count(page),
 		page_mapcount(page), page->mapping, page->index);
-	printk(KERN_EMERG "Trying to fix it up, but a reboot is needed\n");
 
 	dump_stack();
 out:
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

