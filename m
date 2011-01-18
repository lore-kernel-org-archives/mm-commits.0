From: akpm@linux-foundation.org
Subject: [folded] mm-deactivate-invalidated-pages-fix.patch removed from -mm tree
Date: Tue, 18 Jan 2011 12:29:19 -0800
Message-ID: <201101182029.p0IKTK3J003443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752168Ab1ARUqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Jan 2011 15:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bgamari.foss@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com


The patch titled
     mm-deactivate-invalidated-pages-fix
has been removed from the -mm tree.  Its filename was
     mm-deactivate-invalidated-pages-fix.patch

This patch was dropped because it was folded into mm-deactivate-invalidated-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-deactivate-invalidated-pages-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Ben Gamari <bgamari.foss@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/swap.c            |   19 +++++++++----------
 mm/truncate.c        |    7 ++++++-
 3 files changed, 16 insertions(+), 12 deletions(-)

diff -puN include/linux/swap.h~mm-deactivate-invalidated-pages-fix include/linux/swap.h
--- a/include/linux/swap.h~mm-deactivate-invalidated-pages-fix
+++ a/include/linux/swap.h
@@ -215,7 +215,7 @@ extern void mark_page_accessed(struct pa
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern void rotate_reclaimable_page(struct page *page);
-extern void lru_deactive_page(struct page *page);
+extern void lru_deactivate_page(struct page *page);
 extern void swap_setup(void);
 
 extern void add_page_to_unevictable_list(struct page *page);
diff -puN mm/swap.c~mm-deactivate-invalidated-pages-fix mm/swap.c
--- a/mm/swap.c~mm-deactivate-invalidated-pages-fix
+++ a/mm/swap.c
@@ -39,7 +39,7 @@ int page_cluster;
 
 static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
-static DEFINE_PER_CPU(struct pagevec, lru_deactive_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
 
 /*
@@ -348,7 +348,7 @@ void add_page_to_unevictable_list(struct
 	spin_unlock_irq(&zone->lru_lock);
 }
 
-static void __pagevec_lru_deactive(struct pagevec *pvec)
+static void __pagevec_lru_deactivate(struct pagevec *pvec)
 {
 	int i, lru, file;
 
@@ -413,23 +413,22 @@ static void drain_cpu_pagevecs(int cpu)
 		pagevec_move_tail(pvec);
 		local_irq_restore(flags);
 	}
-	pvec = &per_cpu(lru_deactive_pvecs, cpu);
+	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
 	if (pagevec_count(pvec))
-		__pagevec_lru_deactive(pvec);
+		__pagevec_lru_deactivate(pvec);
 }
 
 /*
- * Function used to forecefully demote a page to the head of the inactive
- * list.
+ * Forecfully demote a page to the tail of the inactive list.
  */
-void lru_deactive_page(struct page *page)
+void lru_deactivate_page(struct page *page)
 {
 	if (likely(get_page_unless_zero(page))) {
-		struct pagevec *pvec = &get_cpu_var(lru_deactive_pvecs);
+		struct pagevec *pvec = &get_cpu_var(lru_deactivate_pvecs);
 
 		if (!pagevec_add(pvec, page))
-			__pagevec_lru_deactive(pvec);
-		put_cpu_var(lru_deactive_pvecs);
+			__pagevec_lru_deactivate(pvec);
+		put_cpu_var(lru_deactivate_pvecs);
 	}
 }
 
diff -puN mm/truncate.c~mm-deactivate-invalidated-pages-fix mm/truncate.c
--- a/mm/truncate.c~mm-deactivate-invalidated-pages-fix
+++ a/mm/truncate.c
@@ -361,8 +361,13 @@ unsigned long invalidate_mapping_pages(s
 				continue;
 
 			ret = invalidate_inode_page(page);
+			/*
+			 * If the page was dirty or under writeback we cannot
+			 * invalidate it now.  Move it to the tail of the
+			 * inactive LRU so that reclaim will free it promptly.
+			 */
 			if (!ret)
-				lru_deactive_page(page);
+				lru_deactivate_page(page);
 			count += ret;
 			unlock_page(page);
 			if (next > end)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

