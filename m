From: akpm@linux-foundation.org
Subject: - readahead-sysctl-parameters-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:44:45 -0800
Message-ID: <200703060144.l261ijXs008181@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45938 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXCFBow (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead sysctl parameters fix
has been removed from the -mm tree.  Its filename was
     readahead-sysctl-parameters-fix.patch

This patch was dropped because it was folded into readahead-sysctl-parameters.patch

------------------------------------------------------
Subject: readahead sysctl parameters fix
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

- do no extra readahead when (readahead_ratio == 1)
- define readahead_hit_rate inside CONFIG_ADAPTIVE_READAHEAD ifdefs

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 include/linux/mm.h          |    2 +-
 mm/readahead.c              |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/sysctl/vm.txt~readahead-sysctl-parameters-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~readahead-sysctl-parameters-fix
+++ a/Documentation/sysctl/vm.txt
@@ -234,7 +234,7 @@ plenty of memory(>>2MB per reader), a bi
 readahead_ratio also selects the readahead logic:
 	VALUE	CODE PATH
 	-------------------------------------------
-	    0	disable readahead totally
+	    0	read as is, no extra readahead
 	    1	select the stock readahead logic
 	2-100	select the adaptive readahead logic
 
diff -puN include/linux/mm.h~readahead-sysctl-parameters-fix include/linux/mm.h
--- a/include/linux/mm.h~readahead-sysctl-parameters-fix
+++ a/include/linux/mm.h
@@ -1112,7 +1112,7 @@ extern int readahead_ratio;
 
 static inline int prefer_adaptive_readahead(void)
 {
-	return readahead_ratio > 1;
+	return readahead_ratio != 1;
 }
 
 /* Do stack extension */
diff -puN mm/readahead.c~readahead-sysctl-parameters-fix mm/readahead.c
--- a/mm/readahead.c~readahead-sysctl-parameters-fix
+++ a/mm/readahead.c
@@ -40,10 +40,10 @@
 /* Set read-ahead size to ##% of the thrashing-threshold. */
 int readahead_ratio = 50;
 EXPORT_SYMBOL_GPL(readahead_ratio);
-#endif
 
 /* Readahead as long as cache hit ratio keeps above 1/##. */
 int readahead_hit_rate = 0;
+#endif /* CONFIG_ADAPTIVE_READAHEAD */
 
 /*
  * Detailed classification of read-ahead behaviors.
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
readahead-sysctl-parameters-fix.patch
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
