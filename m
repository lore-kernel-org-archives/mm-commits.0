From: akpm@linux-foundation.org
Subject: + logic-to-move-mlocked-pages.patch added to -mm tree
Date: Wed, 14 Feb 2007 21:42:33 -0800
Message-ID: <200702150542.l1F5gXeN021105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35571 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932280AbXBOFmg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 00:42:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Logic to move mlocked pages
has been added to the -mm tree.  Its filename is
     logic-to-move-mlocked-pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Logic to move mlocked pages
From: Christoph Lameter <clameter@sgi.com>

Add logic to lazily remove/add mlocked pages from LRU

This is the core of the patchset.  It adds the necessary logic to remove
mlocked pages from the LRU and put them back later.  The basic idea by Andrew
Morton and others has been around for awhile.

During reclaim we attempt to unmap pages.  In order to do so we have to scan
all vmas that a page belongs to to check for VM_LOCKED.

If we find that VM_LOCKED is set for a page then we remove the page from the
LRU and mark it with SetMlocked.  We must mark the page with a special flag
bit.  Without PageMLocked we have later no way to distinguish pages that are
off the LRU because of mlock from pages that are off the LRU for other
reasons.  We should only feed back mlocked pages to the LRU and not the pages
that were removed for other reasons.

We feed pages back to the LRU in two places:

zap_pte_range: 	Here pages are removed from a vma. If a page is mlocked then
	we add it back to the LRU. If other vmas with VM_LOCKED set have
	mapped the page then we will discover that later during reclaim and
	move the page off the LRU again.

munlock/munlockall: We scan all pages in the vma and do the
	same as in zap_pte_range.

We also have to modify the page migration logic to handle PageMlocked pages. 
We simply clear the PageMlocked bit and then we can treat the page as a
regular page from the LRU.  Page migration feeds all pages back the LRU and
relies on reclaim to move them off again.

Note that this is lazy accounting for mlocked pages.  NR_MLOCK may increase as
the system discovers more mlocked pages.  If a machine has a large amount of
memory then it may take awhile until reclaim gets through with all pages.  We
may only discover the extend of mlocked pages when memory gets tight.

Some of the later patches opportunistically move pages off the LRU to avoid
delays in accounting.  Usually these opportunistic moves do a pretty good job
but there are special situations (such as page migration and munlocking a
memory area mlocked by multiple processes) where NR_MLOCK may become low until
reclaim detects the mlocked pages again.

So, the scheme is fundamentally lazy and one cannot count on NR_MLOCK to
reflect the actual number of mlocked pages.  NR_MLOCK represents the number
*discovered* mlocked pages so far which may be less than the actual number of
mlocked pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c  |    2 ++
 mm/migrate.c |    7 +++++++
 mm/mlock.c   |   19 ++++++++++++++++++-
 mm/vmscan.c  |   10 +++++++++-
 4 files changed, 36 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~logic-to-move-mlocked-pages mm/memory.c
--- a/mm/memory.c~logic-to-move-mlocked-pages
+++ a/mm/memory.c
@@ -682,6 +682,8 @@ static unsigned long zap_pte_range(struc
 				file_rss--;
 			}
 			page_remove_rmap(page, vma);
+			if (PageMlocked(page) && vma->vm_flags & VM_LOCKED)
+				lru_cache_add_mlock(page);
 			tlb_remove_page(tlb, page);
 			continue;
 		}
diff -puN mm/migrate.c~logic-to-move-mlocked-pages mm/migrate.c
--- a/mm/migrate.c~logic-to-move-mlocked-pages
+++ a/mm/migrate.c
@@ -58,6 +58,13 @@ int isolate_lru_page(struct page *page, 
 			else
 				del_page_from_inactive_list(zone, page);
 			list_add_tail(&page->lru, pagelist);
+		} else
+		if (PageMlocked(page)) {
+			ret = 0;
+			get_page(page);
+			ClearPageMlocked(page);
+			list_add_tail(&page->lru, pagelist);
+			__dec_zone_state(zone, NR_MLOCK);
 		}
 		spin_unlock_irq(&zone->lru_lock);
 	}
diff -puN mm/mlock.c~logic-to-move-mlocked-pages mm/mlock.c
--- a/mm/mlock.c~logic-to-move-mlocked-pages
+++ a/mm/mlock.c
@@ -10,7 +10,7 @@
 #include <linux/mm.h>
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
-
+#include <linux/swap.h>
 
 static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 	unsigned long start, unsigned long end, unsigned int newflags)
@@ -63,6 +63,23 @@ success:
 		pages = -pages;
 		if (!(newflags & VM_IO))
 			ret = make_pages_present(start, end);
+	} else {
+		unsigned long addr;
+
+		/*
+		 * We are clearing VM_LOCKED. Feed all pages back
+		 * to the LRU via lru_cache_add_mlock()
+		 */
+		for (addr = start; addr < end; addr += PAGE_SIZE) {
+			struct page *page;
+
+			page = follow_page(vma, start, FOLL_GET);
+			if (page && PageMlocked(page)) {
+				lru_cache_add_mlock(page);
+				put_page(page);
+			}
+			cond_resched();
+		}
 	}
 
 	mm->locked_vm -= pages;
diff -puN mm/vmscan.c~logic-to-move-mlocked-pages mm/vmscan.c
--- a/mm/vmscan.c~logic-to-move-mlocked-pages
+++ a/mm/vmscan.c
@@ -509,10 +509,11 @@ static unsigned long shrink_page_list(st
 		if (page_mapped(page) && mapping) {
 			switch (try_to_unmap(page, 0)) {
 			case SWAP_FAIL:
-			case SWAP_MLOCK:
 				goto activate_locked;
 			case SWAP_AGAIN:
 				goto keep_locked;
+			case SWAP_MLOCK:
+				goto mlocked;
 			case SWAP_SUCCESS:
 				; /* try to free the page below */
 			}
@@ -587,6 +588,13 @@ free_it:
 			__pagevec_release_nonlru(&freed_pvec);
 		continue;
 
+mlocked:
+		ClearPageActive(page);
+		unlock_page(page);
+		__inc_zone_page_state(page, NR_MLOCK);
+		SetPageMlocked(page);
+		continue;
+
 activate_locked:
 		SetPageActive(page);
 		pgactivate++;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages-fix.patch
make-try_to_unmap-return-a-special-exit-code.patch
add-pagemlocked-page-state-bit-and-lru-infrastructure.patch
add-nr_mlock-zvc.patch
logic-to-move-mlocked-pages.patch
consolidate-new-anonymous-page-code-paths.patch
avoid-putting-new-mlocked-anonymous-pages-on-lru.patch
opportunistically-move-mlocked-pages-off-the-lru.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
