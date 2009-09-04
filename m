From: akpm@linux-foundation.org
Subject: [to-be-updated] pagemap-document-kpf_ksm-and-show-it-in-page-types.patch removed from -mm tree
Date: Thu, 03 Sep 2009 17:07:29 -0700
Message-ID: <200909040007.n8407TJf023114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756586AbZIDAIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Sep 2009 20:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, aarcange@redhat.com, andi@firstfloor.org, chrisw@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, josh@joshtriplett.org, kosaki.motohiro@jp.fujitsu.co


The patch titled
     pagemap: document KPF_KSM and show it in page-types
has been removed from the -mm tree.  Its filename was
     pagemap-document-kpf_ksm-and-show-it-in-page-types.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: document KPF_KSM and show it in page-types
From: Wu Fengguang <fengguang.wu@intel.com>

It indicates to the system admin that processes mapping such pages may be
eating less physical memory than the reported numbers by legacy tools.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Chris Wright <chrisw@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/pagemap.txt |    4 ++++
 tools/vm/page-types.c        |    2 ++
 2 files changed, 6 insertions(+)

diff -puN Documentation/vm/pagemap.txt~pagemap-document-kpf_ksm-and-show-it-in-page-types Documentation/vm/pagemap.txt
--- a/Documentation/vm/pagemap.txt~pagemap-document-kpf_ksm-and-show-it-in-page-types
+++ a/Documentation/vm/pagemap.txt
@@ -59,6 +59,7 @@ There are three components to pagemap:
     18. UNEVICTABLE
     19. HWPOISON
     20. NOPAGE
+    21. KSM
 
 Short descriptions to the page flags:
 
@@ -93,6 +94,9 @@ Short descriptions to the page flags:
 20. NOPAGE
     no page frame exists at the requested address
 
+21. KSM
+    identical memory pages dynamically shared between one or more processes
+
     [IO related page flags]
  1. ERROR     IO error occurred
  3. UPTODATE  page has up-to-date data
diff -puN tools/vm/page-types.c~pagemap-document-kpf_ksm-and-show-it-in-page-types tools/vm/page-types.c
--- a/tools/vm/page-types.c~pagemap-document-kpf_ksm-and-show-it-in-page-types
+++ a/tools/vm/page-types.c
@@ -49,6 +49,7 @@
 #define KPF_UNEVICTABLE		18
 #define KPF_HWPOISON		19
 #define KPF_NOPAGE		20
+#define KPF_KSM			21
 
 /* [32-] kernel hacking assistances */
 #define KPF_RESERVED		32
@@ -97,6 +98,7 @@ static char *page_flag_names[] = {
 	[KPF_UNEVICTABLE]	= "u:unevictable",
 	[KPF_HWPOISON]		= "X:hwpoison",
 	[KPF_NOPAGE]		= "n:nopage",
+	[KPF_KSM]		= "x:ksm",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

linux-next.patch
mm-memory-failure-remove-config_unevictable_lru-config-option.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
mm-do-batched-scans-for-mem_cgroup.patch
pagemap-document-kpf_ksm-and-show-it-in-page-types.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
documentation-vm-gitignore-add-page-types.patch

