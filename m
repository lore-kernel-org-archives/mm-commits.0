From: akpm@linux-foundation.org
Subject: +
 mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch
 added to -mm tree
Date: Thu, 05 Nov 2015 16:34:10 -0800
Message-ID: <563bf582.2poGYjo+gkjYFnjC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965414AbbKFAeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 19:34:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack
has been added to the -mm tree.  Its filename is
     mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack

dopey hack so I can test stuff

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN include/linux/mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack include/linux/mm.h
--- a/include/linux/mm.h~mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack
+++ a/include/linux/mm.h
@@ -435,7 +435,7 @@ static inline int page_mapcount(struct p
 
 static inline int total_mapcount(struct page *page)
 {
-	int i, ret;
+	int ret;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -445,8 +445,14 @@ static inline int total_mapcount(struct
 	ret = compound_mapcount(page);
 	if (PageHuge(page))
 		return ret;
-	for (i = 0; i < HPAGE_PMD_NR; i++)
-		ret += atomic_read(&page[i]._mapcount) + 1;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	{
+		int i;
+
+		for (i = 0; i < HPAGE_PMD_NR; i++)
+			ret += atomic_read(&page[i]._mapcount) + 1;
+	}
+#endif
 	if (PageDoubleMap(page))
 		ret -= HPAGE_PMD_NR;
 	return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
mm-cmac-suppress-warning.patch
memcg-fix-thresholds-for-32b-architectures-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
mm-slub-kasan-enable-user-tracking-by-default-with-kasan=y-fix.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-hack.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-nvem-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

