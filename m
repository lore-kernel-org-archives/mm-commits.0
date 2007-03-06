From: akpm@linux-foundation.org
Subject: - readahead-sysctl-parameters-set-readahead_hit_rate=1.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:44:48 -0800
Message-ID: <200703060144.l261imoq008189@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45942 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933824AbXCFBpE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:45:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: sysctl parameters: set readahead_hit_rate=1
has been removed from the -mm tree.  Its filename was
     readahead-sysctl-parameters-set-readahead_hit_rate=1.patch

This patch was dropped because it was folded into readahead-sysctl-parameters.patch

------------------------------------------------------
Subject: readahead: sysctl parameters: set readahead_hit_rate=1
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

Set default readahead_hit_rate to 1 for the majority users.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 mm/readahead.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/sysctl/vm.txt~readahead-sysctl-parameters-set-readahead_hit_rate=1 Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~readahead-sysctl-parameters-set-readahead_hit_rate=1
+++ a/Documentation/sysctl/vm.txt
@@ -261,4 +261,4 @@ Possible values can be:
 
 The larger value, the more capabilities, with more possible overheads.
 
-The default value is 0.
+The default value is 1.
diff -puN mm/readahead.c~readahead-sysctl-parameters-set-readahead_hit_rate=1 mm/readahead.c
--- a/mm/readahead.c~readahead-sysctl-parameters-set-readahead_hit_rate=1
+++ a/mm/readahead.c
@@ -42,7 +42,7 @@ int readahead_ratio = 50;
 EXPORT_SYMBOL_GPL(readahead_ratio);
 
 /* Readahead as long as cache hit ratio keeps above 1/##. */
-int readahead_hit_rate = 0;
+int readahead_hit_rate = 1;
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 /*
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
readahead-sysctl-parameters-set-readahead_hit_rate=1.patch
readahead-min-max-sizes.patch
readahead-min-max-sizes-remove-get_readahead_bounds.patch
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
