From: akpm@linux-foundation.org
Subject: [folded-merged] mm-compaction-cleanup-isolate_freepages-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:25:15 -0700
Message-ID: <538f9ccb.6WMOBejDfsNeFZLy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaFDWZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:25:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-compaction-cleanup-isolate_freepages-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:25:15 -0700


The patch titled
     Subject: mm-compaction-cleanup-isolate_freepages-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-cleanup-isolate_freepages-fix.patch

This patch was dropped because it was folded into mm-compaction-cleanup-isolate_freepages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-cleanup-isolate_freepages-fix

comment fixes, per Minchan

Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix
+++ a/mm/compaction.c
@@ -662,7 +662,10 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long pfn, low_pfn, next_free_pfn, z_end_pfn;
+	unsigned long pfn;	     /* scanning cursor */
+	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
+	unsigned long next_free_pfn; /* start pfn for scaning at next round */
+	unsigned long z_end_pfn;     /* zone's end pfn */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -679,8 +682,8 @@ static void isolate_freepages(struct zon
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * Seed the value for max(next_free_pfn, pfn) updates. If there are
-	 * none, the pfn < low_pfn check will kick in.
+	 * Seed the value for max(next_free_pfn, pfn) updates. If no pages are
+	 * isolated, the pfn < low_pfn check will kick in.
 	 */
 	next_free_pfn = 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

