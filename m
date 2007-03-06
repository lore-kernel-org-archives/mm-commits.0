From: akpm@linux-foundation.org
Subject: - readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:45:22 -0800
Message-ID: <200703060145.l261jMJJ008241@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45953 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932933AbXCFBp3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: min/max sizes: increase VM_MIN_READAHEAD to 32KB
has been removed from the -mm tree.  Its filename was
     readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch

This patch was dropped because it was folded into readahead-min-max-sizes.patch

------------------------------------------------------
Subject: readahead: min/max sizes: increase VM_MIN_READAHEAD to 32KB
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Use a minimal readahead size of 32KB instead of 16KB for the adaptive readahead.

The potential benefit(disk utilization in worst case doubles) is large, while
the potential panelty is small(wastes up to 32MB when thrashed/missed 1000
times).

This minimal value is only applied for sequential streams.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~readahead-min-max-sizes-increase-vm_min_readahead-to-32kb include/linux/mm.h
--- a/include/linux/mm.h~readahead-min-max-sizes-increase-vm_min_readahead-to-32kb
+++ a/include/linux/mm.h
@@ -1088,10 +1088,11 @@ int write_one_page(struct page *page, in
 /* readahead.c */
 #ifdef CONFIG_ADAPTIVE_READAHEAD
 #define VM_MAX_READAHEAD	1024	/* kbytes */
+#define VM_MIN_READAHEAD	32	/* kbytes (includes current page) */
 #else
 #define VM_MAX_READAHEAD	128	/* kbytes */
-#endif
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
+#endif
 #define VM_MAX_CACHE_HIT    	256	/* max pages in a row in cache before
 					 * turning readahead off */
 
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-kconfig-options.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-min-max-sizes-increase-vm_min_readahead-to-32kb.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-prevent-tiny-size.patch
readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
readahead-context-based-method.patch
readahead-context-based-method-locking-fix.patch
readahead-context-based-method-locking-fix-2.patch
readahead-context-based-method-update-ra_min.patch
readahead-context-based-method-remove-readahead_ratio.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-fix.patch
readahead-call-scheme.patch
readahead-call-scheme-ifdef-fix.patch
readahead-call-scheme-build-fix.patch
readahead-call-scheme-remove-get_readahead_bounds.patch
readahead-call-scheme-fix-thrashed-unaligned-read.patch
readahead-laptop-mode.patch
readahead-laptop-mode-fix.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
