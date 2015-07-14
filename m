From: akpm@linux-foundation.org
Subject: + mm-show-proportional-swap-share-of-the-mapping.patch added to
 -mm tree
Date: Tue, 14 Jul 2015 14:07:31 -0700
Message-ID: <55a57a13.x3GAPIYJeNn9+pjA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbbGNVHc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 17:07:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, bongkyu.kim@lge.com, corbet@lwn.net, hughd@google.com, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/pid/smaps:: show proportional swap share of the mapping
has been added to the -mm tree.  Its filename is
     mm-show-proportional-swap-share-of-the-mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-show-proportional-swap-share-of-the-mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-show-proportional-swap-share-of-the-mapping.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: /proc/pid/smaps:: show proportional swap share of the mapping

We want to know per-process workingset size for smart memory management on
userland and we use swap(ex, zram) heavily to maximize memory efficiency
so workingset includes swap as well as RSS.

On such system, if there are lots of shared anonymous pages, it's really
hard to figure out exactly how many each process consumes memory(ie, rss +
wap) if the system has lots of shared anonymous memory(e.g, android).

This patch introduces SwapPss field on /proc/<pid>/smaps so we can get
more exact workingset size per process.

Bongkyu tested it. Result is below.

1. 50M used swap
SwapTotal: 461976 kB
SwapFree: 411192 kB

$ adb shell cat /proc/*/smaps | grep "SwapPss:" | awk '{sum += $2} END {print sum}';
48236
$ adb shell cat /proc/*/smaps | grep "Swap:" | awk '{sum += $2} END {print sum}';
141184

2. 240M used swap
SwapTotal: 461976 kB
SwapFree: 216808 kB

$ adb shell cat /proc/*/smaps | grep "SwapPss:" | awk '{sum += $2} END {print sum}';
230315
$ adb shell cat /proc/*/smaps | grep "Swap:" | awk '{sum += $2} END {print sum}';
1387744

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Bongkyu Kim <bongkyu.kim@lge.com>
Tested-by: Bongkyu Kim <bongkyu.kim@lge.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   18 ++++++++---
 fs/proc/task_mmu.c                 |   18 ++++++++++-
 include/linux/swap.h               |    6 +++
 mm/swapfile.c                      |   42 +++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 7 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-show-proportional-swap-share-of-the-mapping Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-show-proportional-swap-share-of-the-mapping
+++ a/Documentation/filesystems/proc.txt
@@ -424,6 +424,7 @@ Private_Dirty:         0 kB
 Referenced:          892 kB
 Anonymous:             0 kB
 Swap:                  0 kB
+SwapPss:               0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
 Locked:              374 kB
@@ -433,16 +434,23 @@ the first of these lines shows the same
 mapping in /proc/PID/maps.  The remaining lines show the size of the mapping
 (size), the amount of the mapping that is currently resident in RAM (RSS), the
 process' proportional share of this mapping (PSS), the number of clean and
-dirty private pages in the mapping.  Note that even a page which is part of a
-MAP_SHARED mapping, but has only a single pte mapped, i.e.  is currently used
-by only one process, is accounted as private and not as shared.  "Referenced"
-indicates the amount of memory currently marked as referenced or accessed.
+dirty private pages in the mapping.
+
+The "proportional set size" (PSS) of a process is the count of pages it has
+in memory, where each page is divided by the number of processes sharing it.
+So if a process has 1000 pages all to itself, and 1000 shared with one other
+process, its PSS will be 1500.
+Note that even a page which is part of a MAP_SHARED mapping, but has only
+a single pte mapped, i.e.  is currently used by only one process, is accounted
+as private and not as shared.
+"Referenced" indicates the amount of memory currently marked as referenced or
+accessed.
 "Anonymous" shows the amount of memory that does not belong to any file.  Even
 a mapping associated with a file may contain anonymous pages: when MAP_PRIVATE
 and a page is modified, the file page is replaced by a private anonymous copy.
 "Swap" shows how much would-be-anonymous memory is also used, but out on
 swap.
-
+"SwapPss" shows proportional swap share of this mapping.
 "VmFlags" field deserves a separate description. This member represents the kernel
 flags associated with the particular virtual memory area in two letter encoded
 manner. The codes are the following:
diff -puN fs/proc/task_mmu.c~mm-show-proportional-swap-share-of-the-mapping fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-show-proportional-swap-share-of-the-mapping
+++ a/fs/proc/task_mmu.c
@@ -446,6 +446,7 @@ struct mem_size_stats {
 	unsigned long anonymous_thp;
 	unsigned long swap;
 	u64 pss;
+	u64 swap_pss;
 };
 
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
@@ -492,9 +493,20 @@ static void smaps_pte_entry(pte_t *pte,
 	} else if (is_swap_pte(*pte)) {
 		swp_entry_t swpent = pte_to_swp_entry(*pte);
 
-		if (!non_swap_entry(swpent))
+		if (!non_swap_entry(swpent)) {
+			int mapcount;
+
 			mss->swap += PAGE_SIZE;
-		else if (is_migration_entry(swpent))
+			mapcount = swp_swapcount(swpent);
+			if (mapcount >= 2) {
+				u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
+
+				do_div(pss_delta, mapcount);
+				mss->swap_pss += pss_delta;
+			} else {
+				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
+			}
+		} else if (is_migration_entry(swpent))
 			page = migration_entry_to_page(swpent);
 	}
 
@@ -641,6 +653,7 @@ static int show_smap(struct seq_file *m,
 		   "Anonymous:      %8lu kB\n"
 		   "AnonHugePages:  %8lu kB\n"
 		   "Swap:           %8lu kB\n"
+		   "SwapPss:        %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
 		   "MMUPageSize:    %8lu kB\n"
 		   "Locked:         %8lu kB\n",
@@ -655,6 +668,7 @@ static int show_smap(struct seq_file *m,
 		   mss.anonymous >> 10,
 		   mss.anonymous_thp >> 10,
 		   mss.swap >> 10,
+		   (unsigned long)(mss.swap_pss >> (10 + PSS_SHIFT)),
 		   vma_kernel_pagesize(vma) >> 10,
 		   vma_mmu_pagesize(vma) >> 10,
 		   (vma->vm_flags & VM_LOCKED) ?
diff -puN include/linux/swap.h~mm-show-proportional-swap-share-of-the-mapping include/linux/swap.h
--- a/include/linux/swap.h~mm-show-proportional-swap-share-of-the-mapping
+++ a/include/linux/swap.h
@@ -431,6 +431,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
+extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
@@ -521,6 +522,11 @@ static inline int page_swapcount(struct
 {
 	return 0;
 }
+
+static inline int swp_swapcount(swp_entry_t entry)
+{
+	return 0;
+}
 
 #define reuse_swap_page(page)	(page_mapcount(page) == 1)
 
diff -puN mm/swapfile.c~mm-show-proportional-swap-share-of-the-mapping mm/swapfile.c
--- a/mm/swapfile.c~mm-show-proportional-swap-share-of-the-mapping
+++ a/mm/swapfile.c
@@ -875,6 +875,48 @@ int page_swapcount(struct page *page)
 }
 
 /*
+ * How many references to @entry are currently swapped out?
+ * This considers COUNT_CONTINUED so it returns exact answer.
+ */
+int swp_swapcount(swp_entry_t entry)
+{
+	int count, tmp_count, n;
+	struct swap_info_struct *p;
+	struct page *page;
+	pgoff_t offset;
+	unsigned char *map;
+
+	p = swap_info_get(entry);
+	if (!p)
+		return 0;
+
+	count = swap_count(p->swap_map[swp_offset(entry)]);
+	if (!(count & COUNT_CONTINUED))
+		goto out;
+
+	count &= ~COUNT_CONTINUED;
+	n = SWAP_MAP_MAX + 1;
+
+	offset = swp_offset(entry);
+	page = vmalloc_to_page(p->swap_map + offset);
+	offset &= ~PAGE_MASK;
+	VM_BUG_ON(page_private(page) != SWP_CONTINUED);
+
+	do {
+		page = list_entry(page->lru.next, struct page, lru);
+		map = kmap_atomic(page) + offset;
+		tmp_count = *map;
+		kunmap_atomic(map);
+
+		count += (tmp_count & ~COUNT_CONTINUED) * n;
+		n *= (SWAP_CONT_MAX + 1);
+	} while (tmp_count & COUNT_CONTINUED);
+out:
+	spin_unlock(&p->lock);
+	return count;
+}
+
+/*
  * We can write to an anon page without COW if there are no other references
  * to it.  And as a side-effect, free up its swap: because the old content
  * on disk will never be read, and seeking back there to write new content
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-show-proportional-swap-share-of-the-mapping.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch
mm-swap-zswap-maybe_preload-refactoring.patch

