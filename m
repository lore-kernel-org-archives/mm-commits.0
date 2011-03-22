From: akpm@linux-foundation.org
Subject: [folded] mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:00:17 -0700
Message-ID: <201103222300.p2MN0HZ4000301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab1CVXBL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, arthur.marsh@internode.on.net, cladisch@googlemail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@


The patch titled
     mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch

This patch was dropped because it was folded into mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix
From: Andrew Morton <akpm@linux-foundation.org>

simplify with s/unlocked/locked/

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>
Cc: Clemens Ladisch <cladisch@googlemail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/compaction.c~mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix
+++ a/mm/compaction.c
@@ -281,21 +281,21 @@ static unsigned long isolate_migratepage
 	spin_lock_irq(&zone->lru_lock);
 	for (; low_pfn < end_pfn; low_pfn++) {
 		struct page *page;
-		bool unlocked = false;
+		bool locked = true;
 
 		/* give a chance to irqs before checking need_resched() */
 		if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
 			spin_unlock_irq(&zone->lru_lock);
-			unlocked = true;
+			locked = false;
 		}
 		if (need_resched() || spin_is_contended(&zone->lru_lock)) {
-			if (!unlocked)
+			if (locked)
 				spin_unlock_irq(&zone->lru_lock);
 			cond_resched();
 			spin_lock_irq(&zone->lru_lock);
 			if (fatal_signal_pending(current))
 				break;
-		} else if (unlocked)
+		} else if (!locked)
 			spin_lock_irq(&zone->lru_lock);
 
 		if (!pfn_valid_within(low_pfn))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
pagewalk-only-split-huge-pages-when-necessary.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

