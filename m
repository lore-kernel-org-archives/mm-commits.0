From: akpm@linux-foundation.org
Subject: + mm-deactivate-invalidated-pages-fix.patch added to -mm tree
Date: Mon, 22 Nov 2010 14:21:52 -0800
Message-ID: <201011222221.oAMMLqXK012598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690Ab0KVWWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 17:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, bgamari.foss@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com


The patch titled
     mm-deactivate-invalidated-pages-fix
has been added to the -mm tree.  Its filename is
     mm-deactivate-invalidated-pages-fix.patch

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
 mm/swap.c            |   13 ++++++-------
 mm/truncate.c        |    7 ++++++-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff -puN include/linux/swap.h~mm-deactivate-invalidated-pages-fix include/linux/swap.h
--- a/include/linux/swap.h~mm-deactivate-invalidated-pages-fix
+++ a/include/linux/swap.h
@@ -213,7 +213,7 @@ extern void mark_page_accessed(struct pa
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
@@ -334,23 +334,22 @@ static void drain_cpu_pagevecs(int cpu)
 		local_irq_restore(flags);
 	}
 
-	pvec = &per_cpu(lru_deactive_pvecs, cpu);
+	pvec = &per_cpu(lru_deactivate_pvecs, cpu);
 	if (pagevec_count(pvec))
 		__pagevec_lru_deactive(pvec);
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
 			__pagevec_lru_deactive(pvec);
-		put_cpu_var(lru_deactive_pvecs);
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

arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
aesni-nfg.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-page_allocc-fix-build_all_zonelist-where-percpu_alloc-is-wrongly-called-under-stop_machine_run-cleanup.patch
mm-vmap-area-cache.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-include-asm-fixmaph-mark-__set_fixmap_offset-as-__always_inline.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
irq-use-per_cpu-kstat_irqs-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
mm-prevent-promotion-of-page-in-madvise_dontneed-fix.patch

