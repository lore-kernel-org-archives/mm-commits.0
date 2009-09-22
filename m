From: akpm@linux-foundation.org
Subject: [merged] mm-move-highest_memmap_pfn.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:43:13 -0700
Message-ID: <200909222043.n8MKhDwh011177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbZIVUnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:43:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, npiggin@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: move highest_memmap_pfn
has been removed from the -mm tree.  Its filename was
     mm-move-highest_memmap_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: move highest_memmap_pfn
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Move highest_memmap_pfn __read_mostly from page_alloc.c next to zero_pfn
__read_mostly in memory.c: to help them share a cacheline, since they're
very often tested together in vm_normal_page().

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    3 ++-
 mm/memory.c     |    1 +
 mm/page_alloc.c |    1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~mm-move-highest_memmap_pfn mm/internal.h
--- a/mm/internal.h~mm-move-highest_memmap_pfn
+++ a/mm/internal.h
@@ -37,6 +37,8 @@ static inline void __put_page(struct pag
 	atomic_dec(&page->_count);
 }
 
+extern unsigned long highest_memmap_pfn;
+
 /*
  * in mm/vmscan.c:
  */
@@ -46,7 +48,6 @@ extern void putback_lru_page(struct page
 /*
  * in mm/page_alloc.c
  */
-extern unsigned long highest_memmap_pfn;
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 
diff -puN mm/memory.c~mm-move-highest_memmap_pfn mm/memory.c
--- a/mm/memory.c~mm-move-highest_memmap_pfn
+++ a/mm/memory.c
@@ -109,6 +109,7 @@ static int __init disable_randmaps(char 
 __setup("norandmaps", disable_randmaps);
 
 unsigned long zero_pfn __read_mostly;
+unsigned long highest_memmap_pfn __read_mostly;
 
 /*
  * CONFIG_MMU architectures set up ZERO_PAGE in their paging_init()
diff -puN mm/page_alloc.c~mm-move-highest_memmap_pfn mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-highest_memmap_pfn
+++ a/mm/page_alloc.c
@@ -72,7 +72,6 @@ EXPORT_SYMBOL(node_states);
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
-unsigned long highest_memmap_pfn __read_mostly;
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

