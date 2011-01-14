From: akpm@linux-foundation.org
Subject: [merged] thp-disable-transparent-hugepages-by-default-on-small-systems.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:48:27 -0800
Message-ID: <201101142251.p0EMpHvr005491@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753058Ab1ANWvb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aarcange@redhat.com, avi@redhat.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     thp: disable transparent hugepages by default on small systems
has been removed from the -mm tree.  Its filename was
     thp-disable-transparent-hugepages-by-default-on-small-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: disable transparent hugepages by default on small systems
From: Rik van Riel <riel@redhat.com>

On small systems, the extra memory used by the anti-fragmentation memory
reserve and simply because huge pages are smaller than large pages can
easily outweigh the benefits of less TLB misses.

A less obvious concern is if run on a NUMA machine with asymmetric node
sizes and one of them is very small.  The reserve could make the node
unusable.

In case of the crashdump kernel, OOMs have been observed due to the
anti-fragmentation memory reserve taking up a large fraction of the
crashdump image.

This patch disables transparent hugepages on systems with less than 1GB of
RAM, but the hugepage subsystem is fully initialized so administrators can
enable THP through /sys if desired.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Avi Kiviti <avi@redhat.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN mm/huge_memory.c~thp-disable-transparent-hugepages-by-default-on-small-systems mm/huge_memory.c
--- a/mm/huge_memory.c~thp-disable-transparent-hugepages-by-default-on-small-systems
+++ a/mm/huge_memory.c
@@ -527,6 +527,14 @@ static int __init hugepage_init(void)
 		goto out;
 	}
 
+	/*
+	 * By default disable transparent hugepages on smaller systems,
+	 * where the extra memory used could hurt more than TLB overhead
+	 * is likely to save.  The admin can still enable it through /sys.
+	 */
+	if (totalram_pages < (512 << (20 - PAGE_SHIFT)))
+		transparent_hugepage_flags = 0;
+
 	start_khugepaged();
 
 	set_recommended_min_free_kbytes();
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch

