From: akpm@linux-foundation.org
Subject: [merged] include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:04:02 -0800
Message-ID: <201101132006.p0DK6hdF029769@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933628Ab1AMUHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:07:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, eric.dumazet@gmail.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     include/asm-generic/vmlinux.lds.h: make readmostly section correctly align
has been removed from the -mm tree.  Its filename was
     include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/asm-generic/vmlinux.lds.h: make readmostly section correctly align
From: Shaohua Li <shaohua.li@intel.com>

The readmostly section should end at a cacheline aligned address,
otherwise the last several data might share cachline with other data and
make the readmostly data still have cache bounce.

For example, in ia64, secpath_cachep is the last readmostly data, and it
shares cacheline with init_uts_ns.

a000000100e80480 d secpath_cachep
a000000100e80488 D init_uts_ns

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/vmlinux.lds.h~include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align
+++ a/include/asm-generic/vmlinux.lds.h
@@ -200,7 +200,8 @@
 
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
-	*(.data..read_mostly)
+	*(.data..read_mostly)						\
+	. = ALIGN(align);
 
 #define CACHELINE_ALIGNED_DATA(align)					\
 	. = ALIGN(align);						\
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
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
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch

