From: akpm@linux-foundation.org
Subject: [to-be-updated] pagemap-export-pg_hwpoison.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:42:23 -0700
Message-ID: <200906162242.n5GMgNwp004337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbZFPWm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: export PG_hwpoison
has been removed from the -mm tree.  Its filename was
     pagemap-export-pg_hwpoison.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: export PG_hwpoison
From: Wu Fengguang <fengguang.wu@intel.com>

This flag indicates a hardware detected memory corruption on the page.
Any future access of the page data may bring down the machine.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    2 ++
 Documentation/vm/pagemap.txt  |    4 ++++
 fs/proc/page.c                |    5 +++++
 3 files changed, 11 insertions(+)

diff -puN Documentation/vm/page-types.c~pagemap-export-pg_hwpoison Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~pagemap-export-pg_hwpoison
+++ a/Documentation/vm/page-types.c
@@ -47,6 +47,7 @@
 #define KPF_COMPOUND_TAIL	16
 #define KPF_HUGE		17
 #define KPF_UNEVICTABLE		18
+#define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
 
 /* [32-] kernel hacking assistances */
@@ -94,6 +95,7 @@ static char *page_flag_names[] = {
 	[KPF_COMPOUND_TAIL]	= "T:compound_tail",
 	[KPF_HUGE]		= "G:huge",
 	[KPF_UNEVICTABLE]	= "u:unevictable",
+	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
 
 	[KPF_RESERVED]		= "r:reserved",
diff -puN Documentation/vm/pagemap.txt~pagemap-export-pg_hwpoison Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-export-pg_hwpoison
+++ a/Documentation/vm/pagemap.txt
@@ -57,6 +57,7 @@ There are three components to pagemap:
     16. COMPOUND_TAIL
     16. HUGE
     18. UNEVICTABLE
+    19. HWPOISON
     20. NOPAGE
 
 Short descriptions to the page flags:
@@ -86,6 +87,9 @@ Short descriptions to the page flags:
 17. HUGE
     this is an integral part of a HugeTLB page
 
+19. HWPOISON
+    hardware detected memory corruption on this page: don't touch the data!
+
 20. NOPAGE
     no page frame exists at the requested address
 
diff -puN fs/proc/page.c~pagemap-export-pg_hwpoison fs/proc/page.c
--- a/fs/proc/page.c~pagemap-export-pg_hwpoison
+++ a/fs/proc/page.c
@@ -93,6 +93,7 @@ static const struct file_operations proc
 #define KPF_COMPOUND_TAIL	16
 #define KPF_HUGE		17
 #define KPF_UNEVICTABLE		18
+#define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
 
 /* kernel hacking assistances
@@ -172,6 +173,10 @@ static u64 get_uflags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_SWAPCACHE,	PG_swapcache);
 	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
+#ifdef CONFIG_MEMORY_FAILURE
+	u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
+#endif
+
 #ifdef CONFIG_UNEVICTABLE_LRU
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
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
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-remove-__invalidate_mapping_pages-variant.patch
vmscan-report-vm_flags-in-page_referenced.patch
vmscan-make-mapped-executable-pages-the-first-class-citizen.patch
vmscan-merge-duplicate-code-in-shrink_active_list.patch
writeback-skip-new-or-to-be-freed-inodes.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
linux-next.patch
pagemap-export-pg_hwpoison.patch
pagemap-export-pg_hwpoison-fix.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

