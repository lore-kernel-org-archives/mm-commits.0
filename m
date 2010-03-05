From: akpm@linux-foundation.org
Subject: [folded] mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch removed from -mm tree
Date: Fri, 05 Mar 2010 13:17:09 -0800
Message-ID: <201003052117.o25LH9rX028098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506Ab0CEVRz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 16:17:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, riel@redhat.com, rientjes@google.com, shijie8@gmail.com


The patch titled
     mm-restore-zone-all_unreclaimable-to-independence-word-fix-2
has been removed from the -mm tree.  Its filename was
     mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch

This patch was dropped because it was folded into mm-restore-zone-all_unreclaimable-to-independence-word.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-restore-zone-all_unreclaimable-to-independence-word-fix-2
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Sure. page allocator obviously touch zone->lock at first.
Incremental patch is here.

Cc: David Rientjes <rientjes@google.com>
Cc: Huang Shijie <shijie8@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-restore-zone-all_unreclaimable-to-independence-word-fix-2 include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-restore-zone-all_unreclaimable-to-independence-word-fix-2
+++ a/include/linux/mmzone.h
@@ -306,6 +306,7 @@ struct zone {
 	 * free areas of different sizes
 	 */
 	spinlock_t		lock;
+	int                     all_unreclaimable; /* All pages pinned */
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/* see spanned/present_pages for more description */
 	seqlock_t		span_seqlock;
@@ -333,7 +334,6 @@ struct zone {
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
-	int                     all_unreclaimable; /* All pages pinned */
 
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-get_scan_ratio-cleanup.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-mempolicyc-fix-indentation-of-the-comments-of-do_migrate_pages.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-further-cleanups.patch
rmap-remove-obsolete-check-from-__page_check_anon_rmap.patch
rmap-move-exclusively-owned-pages-to-own-anon_vma-in-do_wp_page.patch
mm-remove-vm_lock_rmap-code.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
mm-document-proc-pagetypeinfo.patch
mm-document-sys-devices-system-node-nodex.patch
vmscan-factor-out-page-reference-checks.patch
vmscan-factor-out-page-reference-checks-fix.patch
vmscan-drop-page_mapping_inuse.patch
vmscan-detect-mapped-file-pages-used-only-once.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
exec-create-initial-stack-independent-of-page_size.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch

