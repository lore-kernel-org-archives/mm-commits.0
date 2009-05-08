From: akpm@linux-foundation.org
Subject: [to-be-updated] pagemap-documentation-9-more-exported-page-flags.patch removed from -mm tree
Date: Fri, 08 May 2009 13:30:14 -0700
Message-ID: <200905082030.n48KUEbq003700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116AbZEHUeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 16:34:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: documentation 9 more exported page flags
has been removed from the -mm tree.  Its filename was
     pagemap-documentation-9-more-exported-page-flags.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: documentation 9 more exported page flags
From: Wu Fengguang <fengguang.wu@intel.com>

Also add short descriptions for all of the 20 exported page flags.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |   62 +++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff -puN Documentation/vm/pagemap.txt~pagemap-documentation-9-more-exported-page-flags Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-documentation-9-more-exported-page-flags
+++ a/Documentation/vm/pagemap.txt
@@ -49,6 +49,68 @@ There are three components to pagemap:
      8. WRITEBACK
      9. RECLAIM
     10. BUDDY
+    11. MMAP
+    12. ANON
+    13. SWAPCACHE
+    14. SWAPBACKED
+    15. COMPOUND_HEAD
+    16. COMPOUND_TAIL
+    17. UNEVICTABLE
+    18. HWPOISON
+    19. NOPAGE
+
+Short descriptions to the page flags:
+
+ 0. LOCKED
+    page is being locked for exclusive access, eg. by undergoing read/write IO
+
+ 7. SLAB
+    page is managed by the SLAB/SLOB/SLUB/SLQB kernel memory allocator
+    When compound page is used, SLUB/SLQB will only set this flag on the head
+    page; SLOB will not flag it at all.
+
+10. BUDDY
+    a free memory block managed by the buddy system allocator
+    The buddy system organizes free memory in blocks of various orders.
+    An order N block has 2^N physically contiguous pages, with the BUDDY flag
+    set for and _only_ for the first page.
+
+15. COMPOUND_HEAD
+16. COMPOUND_TAIL
+    A compound page with order N consists of 2^N physically contiguous pages.
+    A compound page with order 2 takes the form of "HTTT", where H donates its
+    head page and T donates its tail page(s).  The major consumers of compound
+    pages are hugeTLB pages (Documentation/vm/hugetlbpage.txt), the SLUB etc.
+    memory allocators and various device drivers. However in this interface,
+    only huge/giga pages are made visible to end users.
+
+18. HWPOISON
+    hardware detected memory corruption on this page: don't touch the data!
+
+19. NOPAGE
+    no page frame exists at the requested address
+
+    [IO related page flags]
+ 1. ERROR     IO error occurred
+ 3. UPTODATE  page has up-to-date data
+              ie. for file backed page: (in-memory data revision >= on-disk one)
+ 4. DIRTY     page has been written to, hence contains new data
+              ie. for file backed page: (in-memory data revision >  on-disk one)
+ 8. WRITEBACK page is being synced to disk
+
+    [LRU related page flags]
+ 5. LRU         page is in one of the LRU lists
+ 6. ACTIVE      page is in the active LRU list
+17. UNEVICTABLE page is in the unevictable (non-)LRU list
+                It is somehow pinned and not a candidate for LRU page reclaims,
+		eg. ramfs pages, shmctl(SHM_LOCK) and mlock() memory segments
+ 2. REFERENCED  page has been referenced since last LRU list enqueue/requeue
+ 9. RECLAIM     page will be reclaimed soon after its pageout IO completed
+11. MMAP        a memory mapped page
+12. ANON        a memory mapped page that is not part of a file
+13. SWAPCACHE   page is mapped to swap space, ie. has an associated swap entry
+14. SWAPBACKED  page is backed by swap/RAM
+
 
 Using pagemap to do something useful:
 
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
pagemap-documentation-9-more-exported-page-flags.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
inotify-reimplement-inotify-using-fsnotify-report-rounded-up-event-size-to-user-space.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
slob-use-pg_slab-for-identifying-slob-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch

